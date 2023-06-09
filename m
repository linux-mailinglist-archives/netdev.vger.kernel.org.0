Return-Path: <netdev+bounces-9607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C2972A02F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B71B81C210B2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A032068D;
	Fri,  9 Jun 2023 16:29:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6225619509
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:29:12 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9100F2737
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686328150; x=1717864150;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1FUV0Agk6msbeA8pg9eyrmP4Pe6aRth82JeGWe88Ewg=;
  b=X7cgtm2G/IXBXb0xiKFQundr/2PZLic1Ft47pege/Dc2L2F7RbzbSMXU
   d4KxfOrBwkFq2uu45aeyVEEYT+8IIwjIHryWMGetDa6EPZZtWOqDWoXtj
   l/iD1uK2n8eUgz1OB3HyTLtD9Ey6osrP9MhQsiVH/8pBeL6iBBmXEM02M
   VjTmUCOBIpk+sJBvHk/jhys9dWKjW3tsPK6/oqPfiMbRT4JzPZKJ/iMej
   kgajjDGuainJImr6KkPesEUaEB3AHBSsfMvpgUrmN2EIuTVuz+dsarO/5
   shlTl6+AM4XLYemH8q2WUwBB+5VzHUEZNYAbLMoykbfzXCuAYn/PhcfuH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="421225914"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="421225914"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:29:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="660811258"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="660811258"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 09 Jun 2023 09:29:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:29:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 09:29:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 09:29:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5501u8Q1EerWcFzusO7pMOHUoVZIAF6O5yi6twvnJcWDX+Flas6847r3w1+E/K6ohM9f7iFe5RVupBG5M8aCFvCBpOnJFZQT0t8qyH/QoP2/CwEcoHpW+ih/Y2S8AqTiVUsSdgqjU3qlRAf2sO0l3eNEG22scwuOFIO69xRcgB288ZKqrV2pZg1FzktqoJguMIml+87TdaUHs7xYp+eyIM+TwKXwHX/iQfLjo8tJ8MIARCR3ORJekuDOLo+9Uk8Fc3GOCsOEgKFSGJGGxuM8PQyi0Q+ISsIrMmfBxqEP5KL6XTeZ30Hsr+7bSOfwE5HRwVYeo3zDoluAwH+zwd/Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnKlJEcRlo0fDem+YbVHv6jGo3l+exv/xt/EAH379Jw=;
 b=m7m65RtnnJ82n0Kd/1+k53W9Nnw8oE0spe7z73jIz5Uxz7X7KWEhkVs7/yLDOY6g22cOsiE8IaEgkfmB2zb+9+pA9kvEwWk+eKbHmidHh8PXJLvHVs63Fv5vIfpfOuUqT8vORr9ITodpAjeGfjgdu0KVaFgo3K6RwL5OZfRvJxk7e8xYf4Ni7FNQAWYu/cQcZ2TxCw1Z9JB8pZDZ61DEpNFMsRN04J5xHdpIzuxGh3e294rFeU7UBY/2nfMe0ql60e38kW/5b0Mps5V67MpYUCgVxufEChYJINoHgbWFqVQXfNYvl5q0VoraLuSqjm/LkH53wgOkU9KcsDIH1V583w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5333.namprd11.prod.outlook.com (2603:10b6:208:309::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 9 Jun
 2023 16:29:06 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Fri, 9 Jun 2023
 16:29:06 +0000
Date: Fri, 9 Jun 2023 18:28:57 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Aleksandr Loktionov
	<aleksandr.loktionov@intel.com>, Pucha Himasekhar Reddy
	<himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net v2 3/3] igb: fix nvm.ops.read() error handling
Message-ID: <ZINTSVYbu9byMMFZ@boxer>
References: <20230609161058.3485225-1-anthony.l.nguyen@intel.com>
 <20230609161058.3485225-4-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230609161058.3485225-4-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: LO4P265CA0282.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5333:EE_
X-MS-Office365-Filtering-Correlation-Id: 6242e515-112a-442f-db31-08db6906a4fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3FN6x7vr+bnLxT04eDxkvlA17eRYbAuTNU1sjHAqZTyEtvnz873SVnl4FfICghw3lsEbC0sXt978BK03EDWiM7pccGGoUghua/vXM+7zzyN27s0UJM8dukM0Tez/Q7WJ6MRwi1OrXccqRh+imZoHLsVl5YowQAcXrW+6eIrKy/1YCtsc9GssKEUfvrftrZ3I1nRpB57d7nkGq1DDglHSfrM7CixgXj297+CwgvdASqk2iF9lgZapd8EWmuTq+jWD8jRhpL9Jbh9r61z1vti02K723zjRVKWc6/VA+1sVSaRObEGKwX5Qzn1RHRw9+7SQ+DOGxjh+gwH/GbPcgll9y4oHMin8CHE7+DfIi0r7WfAJlEvu+VDlp81b+k58GR+Mwz7Lj2qwvDcTsb3AkymWl0CP+5IsoE0KJ+41RiOXaMQspyFAoc7onwE2eSimhS2y+KxOepXOdoyIpJn3/YeDdE1urwEaLK+5zXFUh2rUPD7LDtfuWolyeSSKLiuQjrcVxcTC1cta6yQ3o2m1EfzHs8KE3v41Yl63eUl4FVOxD0kz/tQTUJtlKrlAMeKRDd/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(54906003)(82960400001)(478600001)(38100700002)(6862004)(5660300002)(8936002)(8676002)(4326008)(316002)(66946007)(6636002)(66476007)(66556008)(41300700001)(186003)(6486002)(83380400001)(6666004)(26005)(6512007)(6506007)(9686003)(107886003)(86362001)(44832011)(33716001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ALWLrUdkQ9dSGYrg4eo/8f6yab3xcwhMKXx7pAy7IXDdWnNWS+gy1aQZ1lq+?=
 =?us-ascii?Q?8tXiuNmqCQ21vmIylAPirs3hImNRHMwlnHgey+pYFWrhaf42q7YInGMF9XGF?=
 =?us-ascii?Q?Io6c1wIrL0Us3xoPaHv/pcqDiyYSE+AJBnyFnEOh+1kyWPXhFxc0sh6daKT2?=
 =?us-ascii?Q?vYeqIc8wH6bhOHjjp9dfQzXgortXXDPgAt47KRTHlC63OgSYb6UAmnVTxkDm?=
 =?us-ascii?Q?5CCUILF6ZWezKLadN/ve6WPbfPjiaAuYqgvA2NVfWYW4rEH58DChP3VDbv9Q?=
 =?us-ascii?Q?yeakEc68PMZf0jKqeRO6vI/ZvsWRoHycI7T3288usJQiupjrZHAgSnmZXpx+?=
 =?us-ascii?Q?sHAPilD5GjY3QVjOaCVFrBoAyUKqNMxQ0BVMD+UfS3tAaaNFBPSnlcz84Swa?=
 =?us-ascii?Q?Czu58QRTLjGtyz21qssMuqQMI52/LdbmMYXGxdFxiscnNdUJeDtI5jdvZYO0?=
 =?us-ascii?Q?qR3g/oFtccCW5egT0uuYr2nhg4HxVQjXZGouEcrm3PJmfnPMefWK9+B0BN5E?=
 =?us-ascii?Q?mlp7X9yGlPKsVSp15zlBg3s93JrtbRhmAAl1PIX+fB5RP1V6eDahC6IeJtLD?=
 =?us-ascii?Q?hPJf4d4updzcPZ1SOoACMVzn4ffjMpKJvZmNt7naVD1ss6pxGzK0MuiAvN+f?=
 =?us-ascii?Q?o8Y+/Zoa6q6HALqjm9DF01LuOykbVLejrsmZb3wMv2Ce9yTUwl7lXoWGzU03?=
 =?us-ascii?Q?7dSp8Xp1XX3jZ5CBnBERjorpYtaajskfR2KBfgh0hlIEn4hcsBx2T+yfzP+E?=
 =?us-ascii?Q?ASrmokCzvNtH1TjAFJkxyNVRsfVMXhWqoOfIbCECpZLTF4etOh4ndtD4Fh/H?=
 =?us-ascii?Q?TUnOvxelIPS3fCmhYG6FiIVqS+zGI83nE1VXXpqf7nZKfplmOnuwUsVLuDsp?=
 =?us-ascii?Q?2e/twZSNs0GimoyDNkL99J3FHDh73hz9I4qbquWGeo+36GIM3r+0fAvFuVA6?=
 =?us-ascii?Q?dJdFLzvQ7vpoV27Oh0lO5V0lMeEeGrx6TsCZKwXf9bFxceFquwv+EylPJ4U0?=
 =?us-ascii?Q?Nup9mb7wKiqlspDWCoX7tf3f2+DcFjFqt9OGhMQw/yiOpmAKWA8EUXp1DDpf?=
 =?us-ascii?Q?oeTbc+82384y3uTcfHRXMaPU27R34xjOTlU2WKSMeZgqtoXxKHLoFpVtZnS7?=
 =?us-ascii?Q?KITVQ7gYPR0JmDNBvAjbfTL7TlVNDLK6J3PFsDvSrAXHrF9NpljnQaS/GBF+?=
 =?us-ascii?Q?ZdpV+2Y0xs6rNevSShnzMOlg6t59iuoeRmD11snmwg5tpYowFYbSnagchXZG?=
 =?us-ascii?Q?G7GXxMKKtq3OzTOE/GJWfRcBLJFkm2eNIFizwot6BU/YqozaIPaloJkRYSIf?=
 =?us-ascii?Q?2Adv3Jd7+uyf/NPm7MpryvITK4P+WheZPHz2l2Sw8nL4u5N07GtbrjEV8ahL?=
 =?us-ascii?Q?J79aDOwvh7RquoYAoGoy7VJb8bHH4yuswsc5KTXBOvNX09Q7Hds/+aSZfHzs?=
 =?us-ascii?Q?Kzz6Q7utDSU0/HW615yaS4PLHsjbe61h183hnDKUcqLaimN2qhVnVgeRKQ29?=
 =?us-ascii?Q?5y6qFJvquzutve5F1a6uzVPH6+vbN1fOdJtjQ3moem8ChjuhUUc1I7mF/it3?=
 =?us-ascii?Q?zQoPdNM7DYSNICeRZvRCbsYNx0a5tNwj8JX9UsubOT0BKJAoHWVaf1vC96+v?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6242e515-112a-442f-db31-08db6906a4fc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 16:29:06.3298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNc+1Qr3Q/8zHCd92iMzAiIU6KKMxw8wltUkmQseyfJktHYjalnrMUx1DzambY9MjFYr+MBHi/nQVRi8jPMYFk13ctnc/DNGwJ/saPKgjQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5333
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 09:10:58AM -0700, Tony Nguyen wrote:
> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Hey Aleksandr,

> 
> Add error handling into igb_set_eeprom() function, in case
> nvm.ops.read() fails just quit with error code asap.
> 
> Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 7d60da1b7bf4..99b6b21caa02 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -822,6 +822,8 @@ static int igb_set_eeprom(struct net_device *netdev,
>  		 */
>  		ret_val = hw->nvm.ops.read(hw, last_word, 1,
>  				   &eeprom_buff[last_word - first_word]);
> +		if (ret_val)
> +			goto out;
>  	}
>  
>  	/* Device's eeprom is always little-endian, word addressable */
> @@ -839,7 +841,7 @@ static int igb_set_eeprom(struct net_device *netdev,
>  	/* Update the checksum if nvm write succeeded */
>  	if (ret_val == 0)
>  		hw->nvm.ops.update(hw);
> -
> +out:
>  	igb_set_fw_version(adapter);

why would you want to call the above in case of fail? just move out below
and stick only to kfree() and return error code.

>  	kfree(eeprom_buff);
>  	return ret_val;
> -- 
> 2.38.1
> 
> 

