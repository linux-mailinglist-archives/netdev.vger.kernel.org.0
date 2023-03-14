Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082B26B9199
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjCNL1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCNL1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:27:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B648C524;
        Tue, 14 Mar 2023 04:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678793224; x=1710329224;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N9JiEp7uIwq7dsClw5LVjF0fuD9ARjZcT5hz2VmKLH0=;
  b=Fy4b+Y6FU6qslbtKCTJTzVjfv3krHbaSyeRyHTWBIBF4Ab/0813grvG8
   wfbb16GrRjcqyf655bxNfYofgE9uIOa/knqjp8R6PRYz6GVgLVteCBuFd
   5IFrB5j2nrhSht58UYxAFwv1opT2Ur/KAcYcNhGd3cuH9jIgt00Jew950
   g3cOeS6LwdqpQbHg66+/oYiYDuc22UGthWN1qfl557mJYhiEypBOCW0BE
   TtqN67LCdZvk172TPA3a2Dkb7SrbOfycT6So1yt4f60+NHgtCe3Bijq4z
   +pSZARSEIWldsUKMgcUbyz8a/rbM9C6YPjj5J5Y53f7dYepEx6sI+jlGw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337422798"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="337422798"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 04:26:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="822338659"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="822338659"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2023 04:26:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 04:26:55 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 04:26:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 04:26:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 04:26:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEc36AfGBty4u6Sq9knA8bMjzEZxt3PlpGwVKay1Rnf/4encmQkIuq3pJ4YzW6do6MRwncSajYwIBjnjuCeMAIFfNCdTj+qVHMhCXMuyIgzi3vMAA95DsWDqL9MAkFOepPpW61aBpH1/atFlcJg+uII8eyXBgdVgG50T3hdUQF47sKcmueviniTXmU69DJxp3K+/KZoEehN+iB/UEq9PfjrOTX1LQLrbpz+XGATc1BOhP+pmpEM3xzEE4halJAV5f6587ni1Nq7vLlxUlhPfbVCZ5jnUdSrJTn2kjx78NhX+WHJXhDX5CNxXzo8NV0mvqEeDnPapWuLc/qLAqJM40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vr2PytjgqjQYhjXOVBWue94wEk0R8zN8S/IqP60PIAQ=;
 b=GP5sBPl0Hj5MIcN+389rKRO7mZZ5NcFujbZ8naAmCz6MM/eUYuTP+oWeQ+NGo0KzyNaE7p26/2aiPK+kVsGg+knPQGEOW/raI7zWhCE3achnh2skrC/uX9i9OlSZ2cnHiD2xXMzAm0kdPMFykSkcpIHw5sAQZL0rXEXg+0n5LXBaHk2UzkaJJgy3JUHUyq+l9ree5Uz6h0fjpxVOO/2bdAcfE2Nq2Zqd7vjPk1jxp9znpcUhnhlO/gdKTFBTZ3RG2KzuDM1F5O8y3u5z6+sguNZFl4kE9HRHckWmRMM/hMNey49iR8su3C3SYpSG5xayRg+7vpl3qDPCd8a37HhD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by MN2PR11MB4694.namprd11.prod.outlook.com (2603:10b6:208:266::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 11:26:52 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 11:26:52 +0000
Date:   Tue, 14 Mar 2023 12:26:49 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Jose Abreu" <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net 06/13] net: stmmac: Free temporary Rx SKB on request
Message-ID: <ZBBZ+RCOac62thQ1@nimitz>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-7-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313224237.28757-7-Sergey.Semin@baikalelectronics.ru>
X-ClientProxiedBy: LO4P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::6) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|MN2PR11MB4694:EE_
X-MS-Office365-Filtering-Correlation-Id: 8648714f-6dfa-4d2d-3ba5-08db247f01f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNtbLX3/v6kkrMDzZZ+2MRxkNea0gaS3Qqj8+jorQU/ojvdgxacaA30DHXliSCFdtO7zcpykOZyx4pDxZfrMeRiu5YYvwdyWJH2CJV+/JC9e12KO5IPFCt8sxKSDu8u1hQnhXuMbJ/hjgq8g0La0KNtYQcm5nW9eobLJSmsVG+VF+b3N+yS1ZeZxiqMYT7mcltJIfFeUlQ401G2uzW87FdNuuZFj2MvBeOneKWLGlTMjDIenppm7HAPcDnazaeZsMxw03TH6sCzMMDg611swX4XU4E0MosOM2SzBlExZLRWz5w2CUFU3z0yCWVoj3yWtMkiFDNecHCdJ5J4cgqakVd2OgvQocKvA8PSuAG4VICEAdzrG+XHPRyWv2E1b6MfFRt8qQor0TDf6BQW0kEW2F4bPPGgRCa8dc2HDMmXTWQJVGVJwzDlfxuB66FuEgG/oWXfIxNEd9pAVwRdlkzQ4L/0OvY1oXSY6UrYLFptZwccPainKlY8nc3sktkAZFsX0wx8VkKudSQ15ZO6pg1DBbm0v4k8xnXNPQIlEkcoTfRA70yc4g4bNBhHFMB9nS5bgBf0yeeQNo3SH+cAYYlGzZOy0y0HfQjTO6eXmBsA7AJZat/qMmFlrOXNscPI+wdpXoi07dxvAyhDC7OlNIY8CVBmK/n1ZKzzaLleadCTN2XvKnHPkePoBw+y/K374HzhR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199018)(86362001)(38100700002)(82960400001)(7416002)(44832011)(2906002)(5660300002)(8936002)(33716001)(26005)(6916009)(186003)(83380400001)(6512007)(6506007)(9686003)(4326008)(54906003)(66476007)(66946007)(8676002)(66556008)(316002)(6666004)(6486002)(478600001)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2PekCjwtf1M3STOEIKRSEssxdt4104EGJ9SgxvrdiefCACXCs/ATTpyL+TnV?=
 =?us-ascii?Q?zjmWJIWja6OxoK6Uuu3zVGgoCFSS0IVBRfiBHfSt8HzsXwmOiI4KpG9pEaha?=
 =?us-ascii?Q?Oj1GqBvteSZxEBwQXjafkKWLDqCqr9XVZzRw4qXRJ7uhknavVolEvdj/oZ0M?=
 =?us-ascii?Q?e9/6wq0aTwat7iN5c3ih7zNNUeT9h5a/Ovp+q+mta9Idr8RAXspPyYWHa9ER?=
 =?us-ascii?Q?ro6QeytVTDbJdP8ugFL7nM4/ByzeVLdylIJy474K+hIVLNtx8gcbZ0GFOZn6?=
 =?us-ascii?Q?T9WjhKIwBmgKYqBljDMwdHLrdPa4dKF0syR72PI2Hag0XxB3MAhjiB4uvCxW?=
 =?us-ascii?Q?rkgabi/ptVJ12MtxTAj7VjVYkCR27dyb0+zT2yZxaRHEKAvJNWEJCQ7T9MyZ?=
 =?us-ascii?Q?QW82B1u+Qrz3+BYLDsSiOpXhxxKoX5jSnjDE1JXU/12o/269wDAaQMJMLr+U?=
 =?us-ascii?Q?nyO+ehdZzly6DlqeFZydDhF2y1FWKFtiBnxlrSLlk6dE66kmBFCANyxB07Zn?=
 =?us-ascii?Q?BSomBoBSom2+UIRtLVccskrdEtFBB7Oi/19uPkgBn48liUIJqgpZDTiwL/KA?=
 =?us-ascii?Q?wfpWITqT98vFwuhY43G2EPEVWyHUUyU3TH/LHiEMMlnKC0RyyiAl43HG9nio?=
 =?us-ascii?Q?f0udaUwC1LMLO9XoX8m9cWK0NLT20oEBcyBg03/lQkVrE78c9Q3uSQrItG1m?=
 =?us-ascii?Q?yf2pAYCz4jvg+e+xyUaYrpsLyDy6D3bMugYIpE123mj+1JNDPpGRptHtFwQV?=
 =?us-ascii?Q?uC5IJltyOQgMbbTkbIboKNzdBQbwaXyRGirh/pXQAKUUFQSgOy1vaCwo2kMh?=
 =?us-ascii?Q?H72A2iKrMYT8ZXT7AMQn6+O0h6XlgUhsO7WkkPShUPTOPYTJSyiukqlsKdYA?=
 =?us-ascii?Q?jtFKNGPBj/gVPAMg1pPIcn2AdR2b6zaBX2OBIO3Peb6dSPSyDxeoUywMvRRo?=
 =?us-ascii?Q?3l5MAbijIn4CuuYHMlOEcfHruAghrDuPjDz0Opk3KSiI/N05VARH6/ikU2Jd?=
 =?us-ascii?Q?GypqiSuTtIHdHtpFzjb3xKo7hXmsmTUFEjDs1gE0SNefKUrHYnWz2iXzA94f?=
 =?us-ascii?Q?QteiUmf9qHfLuHA63Wysg5t61RAq2Fs5AvCqNWIxjWH9bf+JcLXTPX79qzkx?=
 =?us-ascii?Q?ri6c7YslYSIJ+0tOwbxNXXaBUjGmlKDUDDWhSaP3op8Sp2Zs/X3QeF3dB+Jn?=
 =?us-ascii?Q?3WqHlNr2aQBX4qnPNSWHvH/DdEBhUBLF8DPXvnHtCW/IbzTk/0woio441rss?=
 =?us-ascii?Q?HFPJvAtUBi367V6DN7kTjKjn+jm/qmUQ021NFV59wzutKAesBB1k1vmSgGQN?=
 =?us-ascii?Q?WEAa6+RMATKXk7VuMZUoMiFXrAeaT3pFptlJI0iqaT0b8FKAlnkkfv1tV3mh?=
 =?us-ascii?Q?RQi4/EmmxvzFrucooN3uxP48FsJcd1equ/B559HOFNNip6mggx7Wmkk5lDX5?=
 =?us-ascii?Q?zwQbJ4RoRe4UP30wPeriAkjsik662anja7vkddS8idIDq+k88GjLOtT8sB08?=
 =?us-ascii?Q?DYKhSZOX3L1h4Zb/Prbho5/sQBbrt6pycWicvDDWfU7/e0fXUvbk9KgCfutB?=
 =?us-ascii?Q?WCSITtgcXJIHZMxVHZqEbvqYtSPq6kiAQ9Cth8f7Iy9Y80XItOyI8nt0b9/b?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8648714f-6dfa-4d2d-3ba5-08db247f01f2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 11:26:51.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjKbdkBFPh8f1iddalzyqucTG1uUBHgD+uHdz6F18vDNaEfoWqBc4FbJL+t394VrCTW2vib4lcOElIdTFH9Y7mFHqyJCY1GeBzs4AKTU3ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4694
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:42:30AM +0300, Serge Semin wrote:
> In case if an incoming frame couldn't be finished in one stmmac_rx()
> method call an SKB used to collect data so far will be saved in the
> corresponding Rx-queue state buffer. If the network device is closed
> before the frame is completed the preserved SKB will be utilized on the
> next network interface link uprising cycle right on the first frame
> reception, which will cause having a confused set of SKB data. Let's free
> the allocated Rx SKB then when all Rx-buffers are requested to be freed.
> 
> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index ee4297a25521..4d643b1bbf65 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1545,6 +1545,10 @@ static void dma_free_rx_skbufs(struct stmmac_priv *priv,
>  
>  	for (i = 0; i < dma_conf->dma_rx_size; i++)
>  		stmmac_free_rx_buffer(priv, rx_q, i);
> +
> +	if (rx_q->state_saved)
> +		dev_kfree_skb(rx_q->state.skb);
> +	rx_q->state_saved = false;
>  }
>  
>  static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv,
> -- 
> 2.39.2
> 
> 
LGTM, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
