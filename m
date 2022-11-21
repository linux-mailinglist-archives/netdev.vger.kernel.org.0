Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B07632B7A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiKURvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiKURvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:51:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4424BD22A9;
        Mon, 21 Nov 2022 09:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669053081; x=1700589081;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uqDCy2cOXkUv7ZNnvlCV+g8niZQkK47asrHmjcimO1Q=;
  b=EAz045K3T0duIMcevsMYO8xNG3op5742OEraJI+Ibx0iIV4GDTMiihCz
   wlksYZyLHjHF1PuZZwtDhSGgpdJAewN4g4q+rw+M/PUwKJKQKCq7et5cS
   M3dwkV6KX+9UG6k+ZtHTG/UotuA9I6HNfgAGcwaTW4mHJ4Imyg7LwRSh6
   sQ5u72yk0Q6aD1uy+V2LERPuaSTLMl99xP/3bJwD0H6a3BGg0KLLUszCZ
   OCxY3yiD64M2Fro6nenmZKqJT7amK3Eh8AJgCgirEIeU3tp6RXAZq1FNg
   2bOBK4YHliP6al8fqqz6wvFqPvI1+W9uQDffbfpKPPfu08b0zwwGaMu2s
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="377879989"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="377879989"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:51:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="643406274"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="643406274"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 21 Nov 2022 09:51:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:51:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 09:51:19 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 09:51:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6c1I6UOW4lt8mHahRvkOC9+2BcZE/c801xeaLR/YQulHGL90w2rv+QaApg+Pv3GED38wdEwjSfZqpjH0YdTind7uIEEZVzMHWVLwm3sHEJVUbxZ0bOgtQXzxcg3ZvG+gViwCRgZsKUHEcIuKp130o3joQO6g950tlKXYcPtbtvAphQwU5PaTfDdF5As9SgzlgLa+4WIIdex7eCGAKjcSxKlkb9gsgd8lXAtbd/KaGrCWbu/WhjTh7yAsEeveOWg/OQGCYt26b5/lf5k1n2qkKQyOqyLk/Uco/XdTrh4ztU6rzLIrZfYYkpqz2JkFqznbCw84kO4sYBZ3Bbx8awh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCPSD3b9yIex6iqzT4K7txrOUX7iuswKjJ9rUhRFlCU=;
 b=GdDxzziTtIrXMs3z/dGMQblYs6dPeaCgpD+JGexjeq/aQMuo3+3Cv0dorolj6lxc2dR/xrlSBaZxdta4qgyGPP8ap2niAWiurQUu5o4t0qNqBRKgyuZrdhh9Qd1/ymMXo4TPq+wxHCHG7sM1yDRhId04vg9UYD79TG/usDovcskLWDXDAKxIWHcdQhlhjIK9AvyKU4/0zoW+fDSDewNDS45Jf6GV3X8llp8Jy2M5g8w6mR5dHWZKdht/E0RZ0bMV8KiuR2uPmiywXOXOQ+jNz2R3cfEyPDX9cvWLpJ3QOf5T8No71eGJ7np2zW/TBGgQv4uO5HVhmfy4C1Gls23ABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH8PR11MB7120.namprd11.prod.outlook.com (2603:10b6:510:214::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 17:51:11 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Mon, 21 Nov 2022
 17:51:11 +0000
Date:   Mon, 21 Nov 2022 18:51:05 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Roger Quadros <rogerq@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] net: ethernet: ti: am65-cpsw-nuss: Remove
 redundant ALE_CLEAR
Message-ID: <Y3u6iSiJOgcy38cL@boxer>
References: <20221121142300.9320-1-rogerq@kernel.org>
 <20221121142300.9320-3-rogerq@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221121142300.9320-3-rogerq@kernel.org>
X-ClientProxiedBy: FR3P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH8PR11MB7120:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bde7cd3-dec9-41da-283c-08dacbe8f9fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qu5ghIGtsGwP5eXFQm/koZnz/jpp1lUqzslqwv8owbSOW6MWttw2m0Msptw0tKsj/PyXVLZEVxEkHO2Oo3n00FHPnXO+B8Htt/9Szml6MDIddjQ++wS2ThZAwcuaK8E7FPBx+pgAZl26LT7nQOmnseWTHXQHqFuePMNUiCNrqLKj5qyPHOW0xdsQtYt+PYj4T+mh94Y8k/FOTrYeoz23JAts6KaL92K1eO3OeK6FgDoakBc9SqDzlRJ2K2WEZmccZ1FUAaeZPrYlT/x5XpcqaT8Ma0z4oeRQrHG8+k75rJUptj10ChyfPgvTl92xGoqoarle3d6qDboKc9+P2zNQuO42b1KWuKJITIKsLQPucIqJuX/8DhVNUvt5skKYjJSFjRDx0iH8LEuAkQoKKiJ8m4Q7o5VM/6qJqps2BXPVDeZ5Ir3MwlDvQvGyGykh7DsW+gwTcibj1lmKKnKi8caxJV3XXhYVc9JVxWqpaZrD3hO1rR5O/8BZ/e9lTra/fkX0eplAYih5mIjvVxxp4ecJawphcgq7/Y+BoOBisDFJOqah75E56L89L+ikPdK8DJPhspqG9xjkSJWfr9bYQ9K7/5RcTk+dRGUnv9pIMlkNimdMk6R5CFWmsKEVdtJcI+rQ2fYKbWrJR5ChwFej9XmNrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(41300700001)(8936002)(316002)(6916009)(4326008)(5660300002)(66946007)(66476007)(54906003)(66556008)(8676002)(44832011)(478600001)(2906002)(6506007)(186003)(6512007)(9686003)(26005)(6666004)(6486002)(33716001)(38100700002)(83380400001)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gksZj5JOFEFa+sOlxVJTvxfjIBD8FsmpS/NUaQEIQUTyI4Lm6D7SXN/xcjia?=
 =?us-ascii?Q?fI8HCbuobVxAUsfSFB/ofFKH1Rxz3KTz+60s25Oz8u9CU7HuP7q1n2mgfjtI?=
 =?us-ascii?Q?SxbWDCx0lphQ1OzWg4IA6/olU4Fov7kkCdXtHoYyYuby3u/gFZrir7E4v8rr?=
 =?us-ascii?Q?0ms2ev3aoxPl1xwXa7p7BntFRmyRA2JFv/VyTnm6hmE99Fv86npUEniCJ15R?=
 =?us-ascii?Q?Ebmv37TdNYyGYgYOohwXl/4MMWmZJy5BepXIck/QGRq68PeYGp5i2ACK3XdU?=
 =?us-ascii?Q?TbAzOkTZxkU6mFbucxpN5gVHEqwlcpzTBxUNtizZMtzV1AHdcQFaFELig9eb?=
 =?us-ascii?Q?QyJ5XRBfUDPwHi7QgY2IVS1O6acm5+8KUrlg4lqRtaaMYfuDKTqPauHSaeWJ?=
 =?us-ascii?Q?LLJvG19JXEfTwYWMODU5W9K+Cv9oJMDB7RWKZcUtVRcFNKy33YPvVRcFqrrl?=
 =?us-ascii?Q?Gyy47AVX847wb7ykj2RZpymDMH2EZKKRWIaiUgrr7JPo16cucElXTFP/FWwo?=
 =?us-ascii?Q?ALNVAU1jtZIqymJ8pRYfZB1EipsdquTy8+Z1+8bfz+GDoYvhOKKVhpDhEmkl?=
 =?us-ascii?Q?eonNFpslcel0l/dbAbcGhBYy2uxZSrYopSOZrqhM5IhcR/FX4O+rEgVEmcF3?=
 =?us-ascii?Q?1mXSQHiZyqlWZmwaJrXpd6L+Jz4q6DZESMQDcF9vXwAN5mLke7IkY22TjlOs?=
 =?us-ascii?Q?ftAyEzCuBqvex/yoG3LtPj7+x4nnS9w7ChuohOjyay7TNKcucQljFvxLqTxr?=
 =?us-ascii?Q?4iQrRc8YEJ+h3/nuQEevyWxtzEvBxTNzeOdpIC8oO+2oXHUO8/Yq7IH9xHI1?=
 =?us-ascii?Q?WujGDn5focW0bk9c8MHavI8ncrOHL9avQE/6/56LqtWE3QflGLysyQDriyxA?=
 =?us-ascii?Q?IqN/f/07ltSBrePRhKCGYAzgI6FMtwl0wEY2waVHxFyrY/cfg+SaO0DYG7lS?=
 =?us-ascii?Q?x0RQshoCu1o5Zp8AtzcUUJXr3kQ37skLpALb8GMHcHzdaFZ1y3zlTk1zX2g8?=
 =?us-ascii?Q?APfQA8jC8cpvOwpP8gUtoIlIZXck0E3Jb/ZXmRJkZ7bDfvE0ZCimVtRR82KV?=
 =?us-ascii?Q?700WnoFM/sEWgErfz5mmWGcrPrsaJ5BFfuBFLie5xGgLEoDpmQBbcu2ntq4e?=
 =?us-ascii?Q?6O0W4SFbF66vUJbEHVkZXIsyCZemTPjcHUaMGiRz6Y44i0Kf1etV036kNDVh?=
 =?us-ascii?Q?LNUxmBO1taYdrNr6aqMpXmrdKrK3f1EB2YpLR+GkljHeyQzTvtcGVmTEa4sd?=
 =?us-ascii?Q?pIGNEoiqNBhUNFnHVijs6z9CT6SCC3zU8DjT50d58Gxz+y9IMSu+OETBhfq0?=
 =?us-ascii?Q?IOSDk17HX8dMiME0rCEqda+VvNb74TS8G5ujxev81p9N4qf2BTjGI2gm4sXb?=
 =?us-ascii?Q?ojooA++k3YErzKN/NXptUralc176S7/cyG4XHFoUZ9/fL3umSPvJhIEJlXIX?=
 =?us-ascii?Q?jJH5SKLjgurBwUNyUjfbryd8DNMgQXsJLBb/0hPcLZQbxotolVT2fKieUihI?=
 =?us-ascii?Q?H3YVYkBgMP9edIxByjk+/6DwaSZ4k5kgsiIUwXGUgdc91W+mknjYYL283KT7?=
 =?us-ascii?Q?kKBskXW9lkh12WRZEamejJdvaLTJJIX0WI+ow6ev1+p0ejFo0MKYjVIEBrN9?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bde7cd3-dec9-41da-283c-08dacbe8f9fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:51:11.4277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFD5KpELufa/B5xaAPJ8D23Jj1ac+iqdkpcuVCYBN3Vx0fLa+7JdLbU7MYVR0Z1mTotBt0AAbMNGNJ3UFh1xEHnJbkpK6tGdTG0czNcNmGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 03:22:58PM +0100, Roger Quadros wrote:
> ALE_CLEAR command is issued in cpsw_ale_start() so no need
> to issue it before the call to cpsw_ale_start().
> 
> Fixes: fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")

Not a fix to me, can you send it to -next tree? As you said, it's an
optimization.

> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 505c9edf98ff..2acde5b14516 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -404,7 +404,6 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common)
>  	/* disable priority elevation */
>  	writel(0, common->cpsw_base + AM65_CPSW_REG_PTYPE);
>  
> -	cpsw_ale_control_set(common->ale, 0, ALE_CLEAR, 1);
>  	cpsw_ale_start(common->ale);
>  
>  	/* limit to one RX flow only */
> -- 
> 2.17.1
> 
