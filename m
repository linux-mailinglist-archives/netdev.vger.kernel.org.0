Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D697636432
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiKWPm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbiKWPlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:41:45 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF668B8F98;
        Wed, 23 Nov 2022 07:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669218103; x=1700754103;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RY9fcRFSYNd4nMLKwMgL64h5Ej8MdpAnvM+IQQVM+DA=;
  b=eMlsGuFumwaKUzHUevvnNkobftGbJMbchHV5edgMdX4OshJuJxsE2X1O
   R8rjvr5VBXUY4052gzbE+nJg3HTuM9hNL7K3XT89KnFImX7WrzOClCyOH
   Geh+vNIH20unm7cDQg259cYVPd1WR4bXbxM7ztNoD4m7u/QtXFheubZMf
   cHWGNbzj8Vp3hZJSsTRPZKRwRVfCZK7SCGCsRfhumhVi2gTh8S8QjDipl
   W7YRC9nplWQCW4mksZVZ+CwX2fCfqLu5BeTOqPwRB04i/BS7VWhRKIHy9
   M4iTydvvCIA70y+u2CdWubFnLO/fh8SFcdl+5IaNi4TUb9vOPqRNAH0Ah
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293800181"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293800181"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:41:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="635953290"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="635953290"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2022 07:41:40 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 07:41:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 07:41:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 07:41:40 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 07:41:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPHHeYgdsSiiO9b83YGPuVY2vtWLdyllnOwuv9YCT69mLoib9xTfY65D2BmOgnuM36Ya+4UtQMGh2lFx6QT2cRogrsA8HRXRdzqLmTA/il5djbKR8NHj/Dq6DKv/BAevAeJDcXdHFxdhnQDmmsDHzUXs5tvZx0fBP6Z+yvIUZ/uASrWzWsmzR+JuadkiFLpczRTt0BjlLlniKMEGCcaIJyRXpg/a+gNctEZO6n65TmH0aLtMJZ3BqzEvs8BnEtPAJw86mcGfxub7Y8Hr5T2QBj2y+XpRq50t+keuBhljYCkYuxPNUOcugPyUPKEcHl0nyE8z3h3lYfHh3oyNsk8Txg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abzaikSlqE5RD7Fw9m2UkB2Uf2BdRJWJPSUi2oUCRg4=;
 b=n/guZ7mqOgxEeGbo0XIB7Yd//7039o5/pOTAejX5GGrA5ZzkOb7BzVptpCSRhh2BQuxwzDw04tu/1niuckDNyx7U5OWr2MvxP9b2j3RbKFt4Rie01lLSTuqLHc42Q5HSgbsIdI2vvFijTCraNai8FqBTmWtM8F/SpDjwbXHdBRfpVbyr6HSXLe0un4DXTWGwXv3iU/XdQwFrMjT341NCZn6kcMAd3rRWDbrNYyTgMMfsKWS69ObKaWCnwTrizecTXFggCB63GtOxH6vifwvqrPcAgHfSOy2xFToUqzpk0myEEq90Jb8Ttm6nJS5UymSGNsfcnephO7bYWDmH4QP1Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA2PR11MB4908.namprd11.prod.outlook.com (2603:10b6:806:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 15:41:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 15:41:38 +0000
Date:   Wed, 23 Nov 2022 16:41:32 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Yan Vugenfirer" <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Subject: Re: [PATCH v3] igb: Allocate MSI-X vector when testing
Message-ID: <Y34/LDxCnYd6VGJ2@boxer>
References: <20221123010926.7924-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221123010926.7924-1-akihiko.odaki@daynix.com>
X-ClientProxiedBy: FR3P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA2PR11MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6a45b3-a985-4444-f57e-08dacd6935c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6JxMSFzeAkma45nIhtCSF0kKjpzVXDntPIG9fc2x+N0Tx1X+B3svL8K9iFRmIOchcQPfgijwHws3w4+7p0JQaeME/GfPYbnYEqucb14byknEl+r2oXrGWOf7hQeKZICXAcZz6+8YFPJJLArWWnYogkPD6aXDBGBjglmXt7MMk/NYXJComwD4/eePpvmheELE3v82k/6keflNlWZvo9vepHwF4Carg6jGA7UGGd9s8Ou0wRyRMh2gTfJ4ALdXUK8dkEJB89FBsdhURJL1KJJN9G+7a5X44m/fEtuSGvP9kxOwKzjhdi5VGJDQcv9suW9X9EOWG/MBKeuH6G1BAUME+b6uhV+aAccK2F0CIT6Ik0q7xteLh7D76FUXyrgqoHmUWkWifyZfQW4j0KBJ9D/5lCBwjFNvXEazyzCAgo2f79C5aFbI7hH103cQv8c0/D63kteHdDGb5bqPSo4hYmGACv5EJPEi4omS1f4REF8CVaZ/WAL1BanzQH2tS8L3u3d7kYnueKchJbotlNGqi6B4+4Dr/FlR4HyZewSJo6RQanM0rZmgZ1uJJwcJPspN0KvmckSYGQpkIgRJ3VNjvDX8L4RelOx5PHso/ubUThyaviyb8G2d5C4HYDt9b2Nh6DQ7JnUJdpuFbuR4BuyTItgXxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199015)(66476007)(83380400001)(86362001)(9686003)(41300700001)(2906002)(82960400001)(38100700002)(44832011)(7416002)(478600001)(8936002)(6506007)(6512007)(5660300002)(6916009)(33716001)(6666004)(4326008)(186003)(8676002)(66556008)(316002)(66946007)(26005)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Dmct6oijr2ewdLC882EGqo/I4x1sPN7F7hjqNfSLa2mH8nTnZXhuzMdYcLT?=
 =?us-ascii?Q?NhSAqaX5t4G4vqWxNwN3Oei8r6ACF99Tncs7+nCrEMmfYLWbLCQ1zHHLroAa?=
 =?us-ascii?Q?jiKZvLeEbu8YfOETgjBIc3vPVZhY/U22Y3M60h+2OnI56VEI++Mo4H8+IsUa?=
 =?us-ascii?Q?YwsLMvs5rum9l2k0SUmXrCfuU9Ql2GyG6d08eOWpJZjlvHXAjHOn6A71Odiq?=
 =?us-ascii?Q?kd+dxR5usfzaok7iHEFout578D7uLGTmWIJxHG/1iell72NPT4eAayJ6x91r?=
 =?us-ascii?Q?WXjpzxDIh4XPmSWVX8UFCZYnKSTruBxZoh1CXfe2p7FZWWIrHQDE9b2ca15A?=
 =?us-ascii?Q?LvGZG1qRNfJB7hYnmkMEL/PLmHqQvXbbLlfr79jr8MtJsb4lQWyOm6EF7nus?=
 =?us-ascii?Q?Hm1FiUsDm2OlPrTb6NFl+vo0mdy3gqJq0i/BDGNJBc01mIFqCZl+KpgDiNRD?=
 =?us-ascii?Q?5ei2WDzIRudJjpZQeBcTkMAArczyLttAxN2Cr3mBhVzvgH/OFRdDZL2foaFK?=
 =?us-ascii?Q?jWRq5knPIvwvbVQwLk1BRTZjwxy9DAhGc34sRQb3zcH7g4PsRlitSsSf/U97?=
 =?us-ascii?Q?Y4cFLmCVZ6Fde9uuuIUyLDW4SH6NWJ1UywcV8k6Pvpsd7U8ZY+Fr49aIILss?=
 =?us-ascii?Q?HzqiaoOIW77B9Mmcsu/qLA6Ca7TIxQ+8Rbl2CgP3PNhm8swQgtxVSTgLf/cJ?=
 =?us-ascii?Q?QczDg3OedvxVaf6uyOSXII1EDkxjkU/iq4+lJ+QRLxB1gB1zcRA+ibPhduIC?=
 =?us-ascii?Q?9hAS/qCELuS3e+8/S02bHM3IjKHN4ACGzfwDBrDjAmzO5ASlJ30UtFClU3Mg?=
 =?us-ascii?Q?XV0u1Te4i2aC8gTeXY6o3VI2oJqVtgto9dbO0vLqlyfqnuPKesY2Ui1nwO3g?=
 =?us-ascii?Q?bJPHm/Yn+03O7GcNh2PzWwdpusiXNYGptt49O19WvNS+rmjHQ+jzSYZKvqqs?=
 =?us-ascii?Q?sobFVJqqUTQGf+/HxZqB4OlUjccLdewo1fb+Am6961y5Xvl8wBLuclaoY2B4?=
 =?us-ascii?Q?qABlGTg0YwrpscM456IQ5Nr+PkPpBjpjRV5dFSNU0b6nDCDbDuIbaVSfaTZ1?=
 =?us-ascii?Q?XWxYEk7JQfhh9T4gEvHjT8h+E8cu4Nm7fX9h94QwOVAgJuSAUmZW1A2/ur23?=
 =?us-ascii?Q?QJgKQNVooOPlj044Ymf2WVtQxsqnsglJmbFA+SahR2VuJTOlMo6I39QH+fHZ?=
 =?us-ascii?Q?6dhUdEaCiBVejmY34avSvIDphtwR3iEKscNfHHH1t7KVmexxOetIo2qJNGmu?=
 =?us-ascii?Q?1JzLX5BA5pPIUgMtuRpLi9gk3Go0i8pzYfoD4i4XQtImYcWCGoCBM3kmf+LE?=
 =?us-ascii?Q?Z5Hgbhqp+8KGtB9OcRdhiwlR8WSl+su8vfuBx/8Z9nuXclI1WIN7J5eutQ04?=
 =?us-ascii?Q?x7JzLIeSuvsm7q+FVNnonmQYTDuyibJshD74LDZeKn0xciPnV4vtGBo+jybO?=
 =?us-ascii?Q?PG18p5bJ1IuzyelLztRNU1PTsnj51S6D3xQglpiG8QZ7nueE5J7QkUHjtJ0T?=
 =?us-ascii?Q?uPfIkMQd84dlnHsTDU8QiD01bEZ0QVzHEJ63efBw6DFdh/NxJOIkHh9EyFzM?=
 =?us-ascii?Q?KQqeZKiLTmB+73Cl0d4iXECp6aOniGz5nzwlRaH6nF/d4K7k0SjSAE9Y++6e?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6a45b3-a985-4444-f57e-08dacd6935c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:41:38.5803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXu1VKbRhcrHddo4ecZ5PwmICJV72hGm+1CuFdMIpbORa4pdrBppfV9MF9H+R1l4H5tx4Pv2yLV9cWL22DQ8GAICMJHi0Rp+RgxKvCzQTJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4908
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 10:09:26AM +0900, Akihiko Odaki wrote:
> Without this change, the interrupt test fail with MSI-X environment:
> 
> $ sudo ethtool -t enp0s2 offline
> [   43.921783] igb 0000:00:02.0: offline testing starting
> [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
> [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> [   51.272202] igb 0000:00:02.0: testing shared interrupt
> [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> The test result is FAIL
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 4
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
> 
> Here, "4" means an expected interrupt was not delivered.
> 
> To fix this, route IRQs correctly to the first MSI-X vector by setting
> IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
> masked. The interrupt test now runs properly with this change:

Much better!

> 
> $ sudo ethtool -t enp0s2 offline
> [   42.762985] igb 0000:00:02.0: offline testing starting
> [   50.141967] igb 0000:00:02.0: testing shared interrupt
> [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> The test result is PASS
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 0
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Same comment as on other patch - justify why there is no fixes tag and
specify the tree in subject.

> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index e5f3e7680dc6..ff911af16a4b 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
>  			*data = 1;
>  			return -1;
>  		}
> +		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
> +		wr32(E1000_EIMS, BIT(0));
>  	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
>  		shared_int = false;
>  		if (request_irq(irq,
> -- 
> 2.38.1
> 
