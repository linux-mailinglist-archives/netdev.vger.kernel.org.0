Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD11863416F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiKVQ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiKVQ1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:27:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFC6528A9;
        Tue, 22 Nov 2022 08:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669134421; x=1700670421;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LRl9OFrG3WKPzK0+KQQ5Jb19UpnCGBAfognwPjt/46M=;
  b=iTbJCo/mDmqCg9Vml4+WtJrc5/xcYZkJ+rkJVCb7z4dvNMVbc81Gfhp6
   xYvQJDaMVeExI/CnWkh1iQk9o5caQEbot39XWPymyzWVaPQdos4NXetAm
   dyizDn7iY0PKUTL/uAuW3sz6qw9M8sOycD0/j3pA6otuwtmAlYoOcPsvn
   tl2CaqFPc8OaIvf6/ReDVuChvMtTvcRTms7QqNojl2zYHvFCkEB4eTkFg
   vELh9NIEmsRXvg54MIBA5zb0j4Vk8lgERzzm4HF/4UcJNVw8YyS4fpORy
   O3J2eiIaX7wQLzLuanMTe+ewBPKe0QV77qD8OULTUChPHwks56uuAeHqC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315004946"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="315004946"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 08:27:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="641471580"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="641471580"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 22 Nov 2022 08:27:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.13; Tue, 22 Nov 2022 08:27:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 08:26:59 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 08:26:59 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 08:26:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDp8VC/gC2JVq+kcqv7tUSKp48UfVQSWf0OeiWeQACfJg5b0sEtM1fSsALaz89UBRksQkVD1oaYnH84n7ulKJUlwI4qsmfdJJlIT04sBdjheykQBOP2tsk0+tQSUBITcLSyPjD53hXGvLMDbFEkDiakJGTaXNIf5U5tZRiBCe/VYBOkXLlv+D0r8ESjazVInkVTAGu/baIPzwU5lIxHpQirwHXhfz1+Df638s6/lvb4NNsIs8yumgvvpsy71JQ35G+fcpGp/KImFk0s2Zc/9NAdCpyfoiRzdERCoc1170RK5CRLccZ5zPSe8p+56+6fpIM8deJhpmAs+ksZ45kHQDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/htbNsj/QtG3rGWw4G9+1tnkAKpBry6ub8WOIjUUJg=;
 b=l8zoQWmxdjLxgBlziZWHh7jY281NyFFqTefYZl3FotdVAz6LjBoPXJWMtLkcBPVQ8BhV95P6ENps43Idq4tUsUk9zsT+TpvqVq2xQQexmXhbohOY0X4ZF1arOgiYuzq07eVytiBdje7rAoveUK0tPm9ZG2ahQPbHUa1iWwUbnHb8H+3tB7gPO6RzrUD2YW7ZItyOTsI29l9w0zBQJzq4yK1gvsEKVicbftW2hCPHSAcpcOZTVxNnraQ28muzjrm+wEXf54pmfhAmvT719VLBpxDvVQXXOovVxM3ZGsCWy5FaE5gWdKl5sfwuyWA530AIE0vDsu7f+VqRB+rPW8Uupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6748.namprd11.prod.outlook.com (2603:10b6:510:1b6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 16:26:57 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 16:26:57 +0000
Date:   Tue, 22 Nov 2022 17:26:50 +0100
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
Subject: Re: [PATCH v2] igb: Allocate MSI-X vector when testing
Message-ID: <Y3z4SlmtA/u/3ipA@boxer>
References: <20221122131145.68107-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122131145.68107-1-akihiko.odaki@daynix.com>
X-ClientProxiedBy: FR3P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6748:EE_
X-MS-Office365-Filtering-Correlation-Id: 631f2858-c9cc-4882-4da0-08dacca65fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Df2jHsHikHY0FE1ArSeZvI9RwsupNOrPB+spmMRQgtw8hEs4YNwLUgDdoSm3BGzu8C/S1gA0VRqAyxkhilIZmcZ6ElAhIf9ZBo1iyitfqWvevoeMDPf/bVlIYeB93EOHQ2B3ru85kcg/7IyRzHIP5NQbuPmnIiMXTVaiVQQzeXxyGyUMfiITDsNEsGMBr+dXa28pV7MAvRKP711TTnt2ufcigdBMG6qNYWXt77ogKR3LyhJjDTFZtD36ITkMk3cBDE4zjSUpuOeWFDyxe/TWck+saEmA5mELcOUQFvhiLgajQ86HTghTf71QwQ/CH0oTTem0uA37H4ng2mcmHpV9fZi04rNVme5bO7WG+jZo5ewI2tfki9/O29k+pKJfUtIqhkIKGNIu59X9nbpeKW/fgNg2iD+rurApJ0rcOWMNETq9VdQAmXIZfKMMTx92B0GvVj3mOvKz71pipP90aYHcttrFUitWVtclQlyCvHNbBVb9iB4ugpUy3y8ao5mpqq2JzLiCTbBnMmtV3G2Fp2NRc2//E1/1IIkdn0OhgPSR3q2p+Eu6wS876D9Av5F6xi4lTVmm5lctbKziIvPXZwkcC658GkPKEw+5ZfwZHVfx0VMkf//0eRNHJ9FHVqy055mhbMy8QYcCln5tLIUIeVO/GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(86362001)(7416002)(2906002)(82960400001)(4326008)(83380400001)(38100700002)(316002)(8936002)(66476007)(6916009)(478600001)(6486002)(186003)(8676002)(9686003)(33716001)(26005)(41300700001)(66946007)(44832011)(66556008)(5660300002)(54906003)(6506007)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WtfLo6vdgKqesLYcis5gzO+MtWK27uwFVqJfDVzZWERMJ2uGV7M/HpCMf8pR?=
 =?us-ascii?Q?s0jBj8rM5k/MeKBUwFX/ckUXYfahw1Hq3MzaxSjXInWLKa+9jiA54k3k7eKr?=
 =?us-ascii?Q?frs6yqVY64khaXv1drLWti3mWhqbNDVuHSlU7RBpt+Ds/Krs+dLgeyCqJuyP?=
 =?us-ascii?Q?uWndAMvcqOrdrwCrqO+ViU0g/D5/98r8SjWOJXCLdT/wJsJurtZIDKVlX9iM?=
 =?us-ascii?Q?gj6SGYV8Jtmq13pUHkdE/mknM1NNTqnrdq9dD12Gxw+d7aRiaEZ9UDIe/C1A?=
 =?us-ascii?Q?iK5n7bylF6AZARx+BjKiby2fYSSgRaUQFSZ63XKGJaCi2AxBWoQDa0HFTx41?=
 =?us-ascii?Q?Bw5uBV+Km4LbuFZdWDZ/VDkdw1YMSHG0MpiPDqsDKAUvtDY6dbnkKLksbtAb?=
 =?us-ascii?Q?NwLngob+xecyqADCmBN9eGE4i1yfGtsTZcbbxWdZpfcxj82hoEGtVx6wCRi8?=
 =?us-ascii?Q?C/E6gyHVyIGNtWOa+Q2PWzhtez/PD+Bzp7XrtEeScyEBcWyChHV6npJC4Hji?=
 =?us-ascii?Q?3XOJjXlhn1NwLeE3kKQKarPmlmeUg1waoVX1UQkT9X7wTXDqyOuB1VOvKBey?=
 =?us-ascii?Q?WBUwITCLUTrpbx+B2ZvXwIORqT1f+PKruNtYhL5lN3IKH+CKOhvxl1pEi6vU?=
 =?us-ascii?Q?qgNXRKfy/4YNxHXUL9ZabWW2z7IRw5w8U3t9EhNB2xcYY9+pcq/GpDE0jdDP?=
 =?us-ascii?Q?17HdAaRNac/Gs325WkU0gg4HWEzcWGtdE3OUPjQJgoSp9570gpwyCvAWTcxI?=
 =?us-ascii?Q?A4oZr6iPRySfe1aGvB3gtDhdk1dw8lIIGYSwPzzwJ0m+QOaih//w+Z94lXe4?=
 =?us-ascii?Q?ctUmgBhVGUhcPde3dD6BB0+bMZeWARZ2tW0gw5nw/85jMVJ/y+FQjCTaOksh?=
 =?us-ascii?Q?yjeyMjrY5mxFPbY33QoIP96E1otAh2bpLsHXRSStvkJlr+v29eMQYf82QKlP?=
 =?us-ascii?Q?AYqVKEIRMhDAp0I/WFkIH+79C0gP/IeLhSmFYwwn5jMuqr3sw9SjAv2TVZea?=
 =?us-ascii?Q?TftUxFIC38fknkrXGXyw9LfWUkeOyzvVkR+ToJnrHcjcTix/Z6QQRIPMLSFw?=
 =?us-ascii?Q?AZ8GYL2/GE+8ZKgX3SaxXP9ozRop8qYRVbINGapzYnhvu5PdqUUlO7QtZIxI?=
 =?us-ascii?Q?XPKVfWERUKhxJIXkUC1Umkv8lu36CUsEshaaqYRYZeeV63KQ3BUih/CUHTOC?=
 =?us-ascii?Q?wCqQv4NwV3raDhzm2KmMfm0KzhS/K2BQi0fFhjHD50Y2MHaoy670hPCI4WUI?=
 =?us-ascii?Q?ytx8JSmU8zwU8ZJHl2+7CD7R1Dys0jPwKs9FrOEQfb78Qt5J0mpPDdsGxecG?=
 =?us-ascii?Q?6EaegP7sucj7PoO2JstpAltyevLJ8vMO1tsaHdGZMZlLVRJss53sy5Ni9cz2?=
 =?us-ascii?Q?hTeA4ZPqWJOv2uPVAujUZ/lMyq1OSZP9rvv6Z7kJ2T1rWRxPdfTC9JIaTmSN?=
 =?us-ascii?Q?cFYxABLTGC+uEqcKdfw0Y5Cuobi6HRU0sRotu2hxGiaWDFnNiu7uLFWNsZZo?=
 =?us-ascii?Q?5GUEcdh/aphFW2mvSv4lWtY4DWmiQ/8DBt6oCamnsLEM/YUgMOE8UAHi4hT0?=
 =?us-ascii?Q?y8P+Douv56whayatf8Yhj3P3rirquAIdkNJk3ng8VcONCLPEU7Ej904o0JqM?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 631f2858-c9cc-4882-4da0-08dacca65fc4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 16:26:57.0934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFdmLiKKWY7U0lzqOnk5H0tsH9yUdiixwkhU1GQwM0MazGd0FeC9K7tzmmcu86iovhHZhruqWSKUoTrHot39Ox90p04N4lxJYlXjQ/7Gahg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6748
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:11:45PM +0900, Akihiko Odaki wrote:
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
> This change routes interrupts correctly to the first MSI-X vector, and
> fixes the test:

Try to use imperative mood - simply stating something like "To fix this,
route IRQs correctly to the first MSI-X vector by xyz"

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

Looks better now, would be also good to explain what is the *actual* fix
by explaining the HW registers setting that you're doing.

Thanks!

> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
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
