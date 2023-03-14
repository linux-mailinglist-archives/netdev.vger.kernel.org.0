Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034EB6B8E84
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCNJWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCNJWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:22:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278D8279A8;
        Tue, 14 Mar 2023 02:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678785739; x=1710321739;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6o2OZHfq0Plw7wEc7FZAMbSP4RTdnFLpQq5CWL6RoZg=;
  b=dogFbg8Q9SWjUZisudDkzj+3JVRVT8IeVvvQd0jho2q83JMzTkyIPVH9
   jIoucLTJjaO5rSqOUS4vXg3LCoEHSHNKCUBpomv7Bxg7Acm8DE73zqZhW
   CYILWlVwaDIpDpVDskPXOfP4sV54g6BKhQHGHWV3KZ8w+1Aw5El+UuGVi
   NYnNM1CElSDgr9jyid4TGiZrJt2LJsT2nijWkV9vHAT/R1O7iB+hnUpVJ
   TKxm89KKCyUV19hcZ6XLfT1TvnPgoq826xtlUALECcPG4zpKtqpxaWWrJ
   CvnE4BNkYizMcBOJKCjyuvqftdmS0jKJaDrK1izB+ZtUlePIk1AFSD4Hh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="402241926"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="402241926"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 02:22:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="768019017"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="768019017"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2023 02:22:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 02:22:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 02:22:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 02:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFf9awqhVN+vUDZqjHtXhVvlN2uCLFRi6oUcpWsWeVWUDwVvhx9BeXHzsRL4cfXC+GIL7DdBv5c8Rdci5fAPezSTvkFqVHjrD5f31c9m1tkHxmjE9Qn2Gi6mwmtvr9reo7R3v2Yc1A6/Lxis9SxRwbEPW3ACpSs6NZF2zhrhMq51RxOrEWX4mbVC8X8/eHIDNrXHocEYGPupZ49xMXseg5nMYAM+DFd4L2ryLym8+NmEyF7IbIKC5wwerTCeKZprmTitfwiUGLiqHujoXCUbY6kLYuXujvH4HuhCLHBHemamU+CuGpBgU0XtcUx2DRtXixYjo0zOkGpO9/GgV+87iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgHsnCfWzW7DFHGXqvvY7IhrRq0+W+DeOOTDZVNDZRg=;
 b=nEN106ojUAkitvlEqZNHbyDj4InwizplkPQC8tgyerRt87gLNxv5dLp3msyFaPbeWjltmxdkiMkK+t2wSo4DZC9wJwouFbALhuDd2z+Bhd2gGaI54QsR3QzUuHELyCXFpizrJxxoCAcCBqBlyd9U+EujbgfO3f3QBWVByqyxoj/0R5sA4cObldwDTAIDSV3CTb5OlnJarx0w8U/vl1QKvdXvZGX4CHaY+J5H9/ASLOct+Llf/8YqV9TqGbxYu90YyRDkE8RbTi+OVqlonZBsP/SeLh2h6Q/f/148tuhwGq7Nu82YbUxUwpikq7pkTpKkEFgJOyNvlpuxHFB21gTTtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CO1PR11MB5090.namprd11.prod.outlook.com (2603:10b6:303:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:22:14 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 09:22:14 +0000
Date:   Tue, 14 Mar 2023 10:22:07 +0100
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
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        "Alexey Malahov" <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 07/13] net: stmmac: Free Rx descs on Tx allocation
 failure
Message-ID: <ZBA8v592HgowIs6R@nimitz>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-8-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313224237.28757-8-Sergey.Semin@baikalelectronics.ru>
X-ClientProxiedBy: LO4P123CA0315.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::14) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CO1PR11MB5090:EE_
X-MS-Office365-Filtering-Correlation-Id: 6583c6a2-28b6-4920-32c8-08db246d98e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 006ysK4sC4F/XFxJBehEyIQAKrM8+wzx/uQlP5LfVnE0rQuncUAQJi6EmZlSds/Xm9E2COwfs75xBhXMTZKUc2TfXANMs2lmYILG5D+jI0TBlo7bZJ+YCWevCFlzpamzLG0SdHFCmh8xiJh4QuVUSB8AsukB4RB+l9tGfQffAbBlxeOVfxJbZQ5XPYOEb0K/+sNMFPwSg5glqRBelecH4L37fbFEgBpfne7AJCewS5NP9nFbfVVKD0ZHU/TtSLYGmK74xDJTFCjieQuhEGN0AQbC+ui4XJicHCR+WapBkI3FSl+VaJdZdrCPpm5TuuU1sG6RMJ1FOaQMqPpM+d9LF/9RkJR89QCWWKywQATdkJLmPmGeeXP4XjrhsSuBarEB7aT0O6khzZ6u9ZDlls5Zhz+csZAH0JPrDdhCrBy1t5FRHpwCSxiA8AHgXEAS+lqfKquT099B9dridsocibiv/Dh676kcMfu1RQ95IthHWSWc4dtwPxbAP0zoFRntf+Zr83blzcTQ6m59+EWhPWyCVdDRpppeFjdYhQPrsCh2X8DImdG+G3xRMQJf2SSuM5XWCHs3u2zOshZhVKQEe5nqgV1IswaCWVKwa0Ztx73AnC5ukvR0E2cC3n4swH0egq7ZIH9m4pOyHfeJ94axNeOddA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199018)(86362001)(38100700002)(82960400001)(2906002)(44832011)(7416002)(8936002)(41300700001)(5660300002)(33716001)(4326008)(9686003)(6512007)(186003)(26005)(6506007)(83380400001)(54906003)(316002)(8676002)(66946007)(66556008)(66476007)(6916009)(6666004)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CwWhxQkjpCl7OKNNyGzKd2yoZEstJ0uS8pG22yVx9dFHtWkbnfra6fBJdRvj?=
 =?us-ascii?Q?1IiMcejiysxVWMG0NwIJJzz/wWVfmNQuaM9F4tW2jgIXqOw2LccrXRAdcFOu?=
 =?us-ascii?Q?c2YFzYYGAkT0P1bFNZHuDOS5f00owRAH3YzgbjfUgEhqLVQIM0eP2ndBZTSM?=
 =?us-ascii?Q?BIlMz/m58A1CV/VQt/pNmMaQAzjWXR2iZ0jGXSJP/9oaB9rKl72XPb/BrjhQ?=
 =?us-ascii?Q?13cMAQH2ZEOf6rBWzQwId0Ob0fZUQclzyU67tJG/152lsF0kQtBe7cQAApy/?=
 =?us-ascii?Q?T91V9fmyoJsSpjqX1kNqUpYlv6VJhlH+1yRCOzCxXlI1f+WK5nlXJhwBKJ5N?=
 =?us-ascii?Q?6JYKgSseHy4w1NqCoEBe+NT9Pxo3F/q8k+OVqdWfp342LoTwGV3gZSZl9kTn?=
 =?us-ascii?Q?VBVUCYkHxcWDliroUsr7OA6VSQT/ZNgI02MLsW+ilvdufoEB3vxRClF5O9tb?=
 =?us-ascii?Q?DZoGLhWyiue9WhllVyzxrJIHIb26Gv3Ps/Y8qk0ClGsd7RkRihg4zHrMluK1?=
 =?us-ascii?Q?+GVjGAF1Nik8XL2nzBzxMflkIFt673WB/wpeiBAOhSk+PNXx+r90dnPRVAqM?=
 =?us-ascii?Q?jbGLXaWK94qW4enhta0qdE4UhbTVxgp8QlC2YWw/VBJUIJE/wttJMqBStXAO?=
 =?us-ascii?Q?orVkkIr2N1QfN3B5AA1hgk6NX+7lJ99zQ8NvuBa7ylsFfXLNOVxsFDFOnV62?=
 =?us-ascii?Q?fR74hqM8sA1/GS/78kygVB56G4AawcRXm1M7GGTzmQ+/66N6ry/ZXT+fwcJ8?=
 =?us-ascii?Q?XP6af7phYv7/ELP15MbCW7lb6vM7KlCWrzFE+Btg7unThrWLOviT+YWOzMZc?=
 =?us-ascii?Q?TN2dwhlHTpyAWdroumKOZxdO7kn4Ls++UeQZbUbbixuLnonODNnPyehg9XHF?=
 =?us-ascii?Q?XpMTxj/14DvRYg2kI/s8Ir6flL6yo1Fi8mibbq/jC1peEw6x9HtbGYNHjRq8?=
 =?us-ascii?Q?FAECXNPcBrdW+ty3B2tOWewes6oIHc5I93hP8LZjPKjjUG7kJuKaiK05herN?=
 =?us-ascii?Q?YiyTyMd5CMtwFw/D37brSwmBFy5FcyBzMyejy79eJLPxtExCy3qghwbB/k78?=
 =?us-ascii?Q?GJKDJoMqHigE7yJ1Y0GyAM1auIGthhOtt0qLmAVUJ1932GeRDRU8MQc73T4M?=
 =?us-ascii?Q?7n1gKWh0AjJTtwCubv0kgK8odjFLx3GIe+M7m0BTFvFNxGS7Qvf8XOzwuq0A?=
 =?us-ascii?Q?q80JGhMvWTIT8Ab6LtT4os8VQmHlLFUlVgZxoW/WuYxWH/7CKSGkuWTH4O5E?=
 =?us-ascii?Q?TFJHqmwYo924Ffz0vtln1iIyn0+uBZ6Mhpql6Cp/6A9JkkSvwbEBuFNIVIw3?=
 =?us-ascii?Q?znSM1M+oXvC1GTu3FMu2WsfHu/Zah4vo+yLkVTvcVZgoI3EEgCSqwBQ7wZK1?=
 =?us-ascii?Q?RWTK/pzhi/FfXJtjwY2RQRovgFPHNb3+E1Y109H5tnWQwWYUthlTOE5Oxq9P?=
 =?us-ascii?Q?NfKvrRQuFQDVGqg3TWS5Qk8gYSNpCkYxSVAwtyy+3AA+wS7FVjVuvYBAg2jJ?=
 =?us-ascii?Q?/p9hL4bp+b4JcT2KSGz+2gMrR8gGnOCK7ZuAqmlSa2FcDnXYCc5x0LRcF7gM?=
 =?us-ascii?Q?T60HfiuP3lXrY8U0vyp6UIl+NQfUIq/T1aF4OhPQut6YEgxVPTWDSX0wdP0V?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6583c6a2-28b6-4920-32c8-08db246d98e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:22:13.9812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wEohB9unlS+uhGzEotYPwonhoNosbJim+nvYvz1OPqtMY0YTkbr0o3X0R7lTrMnG/SUwX7PYaRCgcqHjNyepbX1+9RMlVORQrPFrDuesS4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5090
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:42:31AM +0300, Serge Semin wrote:
> Indeed in accordance with the alloc_dma_desc_resources() method logic the
> Rx descriptors will be left allocated if Tx descriptors allocation fails.
> Fix it by calling the free_dma_rx_desc_resources() in case if the
> alloc_dma_tx_desc_resources() method returns non-zero value.
> 
> While at it refactor the method a bit. Just move the Rx descriptors
> allocation method invocation out of the local variables declaration block
> and discard a pointless comment from there.
> 

LGTM, Thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Fixes: 71fedb0198cb ("net: stmmac: break some functions into RX and TX scopes")
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 4d643b1bbf65..229f827d7572 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2182,13 +2182,15 @@ static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv,
>  static int alloc_dma_desc_resources(struct stmmac_priv *priv,
>  				    struct stmmac_dma_conf *dma_conf)
>  {
> -	/* RX Allocation */
> -	int ret = alloc_dma_rx_desc_resources(priv, dma_conf);
> +	int ret;
>  
> +	ret = alloc_dma_rx_desc_resources(priv, dma_conf);
>  	if (ret)
>  		return ret;
>  
>  	ret = alloc_dma_tx_desc_resources(priv, dma_conf);
> +	if (ret)
> +		free_dma_rx_desc_resources(priv, dma_conf);
>  
>  	return ret;
>  }
> -- 
> 2.39.2
> 
> 
