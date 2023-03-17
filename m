Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFAF6BF0A5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCQSYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCQSYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:24:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A85BD9E;
        Fri, 17 Mar 2023 11:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679077479; x=1710613479;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RuLG5Bht7J1ClxIjMJHCJX3b/huVIrOfZxV19NMgwZc=;
  b=E+cz2cRzKcId3erfJfBrtdBHKo5zGvczID4jh5a/7YfxdrD4N4CcIlWt
   8vtR0wo9FEoX+2MWnGoPp5RR3zGVM41inybKrbfuB0bHUK8k6QCTXq7Px
   7i/impG4CT9710tvfepMHO/6XoL3Ka1A1vxrXdtSR1Q8Lpy/xMJh+zwj/
   sHqR8Tlw6O0R8lT7sMu9Xbg6/YaPyvi7oHv7KYJjP6UmtVFwKpWEwSr7w
   eh/fzlIso8Ggh80Yfq0yXAuXtyElhUg3nwo1Dw0/CeEIpWdTMEpesPjEc
   i5emGPA2LQAyUWzQlR4xtfjNeojF1m0PJNm+PCDOwdxnibeJeWyRpcafa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="424603992"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="424603992"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:24:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="744639555"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="744639555"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 17 Mar 2023 11:24:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:24:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:24:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:24:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5vLhrQ/Bv80nQS1QNm/+KGmlpw/AJjB7hBhRxYE3VmXxVHIWJ4TBlQ236q7CUgD3QfB/fUCRk3GbKjI4Ss7KoU4JmnMC8YEg2w2htv5ZOB4rHIzaVqItYKDbfPrIFOS16uYkCbjilq7/rYqddTHKet9SVjIfcN0IfuaXv1Z2QfBKvhhKBv2yatbvfL8PyX4OZG4XxnzTTfKz/NuLnelHCbsegF232gz+UFL9DzRsyQ3ajsHdpEJiO2QrXPNe8j40OrJzrjTNIEihhzv4iiANrC0lct31KlsC/u8LSarbdlH5jIVI69Q6iCOQacquRJGGKaZHmL07iajc6y2Bz/Omg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+pe3NZ+6TtHmy3YNhOwJc3gDDeVJpNwSiUCd6LVlEQ=;
 b=IV4A9UyD+Q/VOzvdQfMBX7OWnYQeqNFSqXLi0UEJQmzYr940Bhnji+47bh5n8eREun7Kz+LsCMUq6KnEHvhXAMwpiuNzCTzWn0rivUzIoRL7OUMAtrNiwK7wCfFezOZosMkePF1KUorrk35PY2r2RpcOrspvfOnM7ia7tuz+QM0AsTNNeZTVJHNgbWK22oAp5uzjRIZ6eeUA5LzPp+gA3xknF/II/kxNfuA3rl0DxoHu4Co8h8KYWTemDGNo1AWvrRSp+DWT7oYWI6BQp5XwDcE7casmTQmuvlnhV0I6qE2X3n2kkwyQ6j/o3jaq6OuEoWF28hDzIVjgobydsbzRpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH0PR11MB7657.namprd11.prod.outlook.com (2603:10b6:510:26c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:24:32 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 18:24:32 +0000
Date:   Fri, 17 Mar 2023 19:24:31 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@collabora.com>
Subject: Re: [PATCHv1 1/2] net: ethernet: stmmac: dwmac-rk: fix optional
 clock handling
Message-ID: <ZBSwX+eBsE02A3Xz@nimitz>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
 <20230317174243.61500-2-sebastian.reichel@collabora.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317174243.61500-2-sebastian.reichel@collabora.com>
X-ClientProxiedBy: FR3P281CA0173.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::15) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH0PR11MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: 50aa8736-77ba-4d97-ff9e-08db2714da8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Poxm/TTJt9YUOewL++uv8BW9D9f5E8Fuoe1XwwtayASjtENcVni3jD5H6eHV1X3hMFZxwu0y6ndLG9E5H6wb25HKG0sr1fE++j6Zf9/MB/OPV18GkignTvoDUJ7BURsRPFqZvLtT4aQnP+rLWD5qYk5Wu7YX/ncGOSzx011lZuNqMcZaj7G4+zxFtLYqqCRO8akHP4qPQSJgpaTs/BEmjkj7KWaQ6F4OPjUfFfbkL47RRchN90Avh4F3KFQLaER65NlWcvyvcaUp8qOzauAdqxPMBMiL7Cifg9mDNVDvt7ytrWIuGDQnSAR8euYx1wRd3mXCWuzwvOpFtj/Ej0X+HF+RrGnp3BBRbXGGie1OnyQQQTULjhVv8MB8dZtEi8eitzw/REktWKjy8MxvUm24I6fZNvMEffMLalv+lEhPewB1s017Fw60ic4mbGjwkuowic9pV1zaby344vH8fV2iSfpDLjKP+Lnyr6+M0/44Cw6WdfZZNMeuMAzQQjpnDSBMAQWzGTp1EL+NFdXbS/M27KSN3qwjzAVxMxFkyKTcxKBzTh8anozpxtxSRd4rFZTniud7qhb+TXWFrwBzs+iT4BHKCjiV6LaSY/5xKf6knItDEm5/MK2lriqY+mRW8iOy2VPn2EbExUGDtLZkd2CJ2wG4Swnero7T0tjfqfkhx+3Mw8pIrDJxibTDZbqV34ox
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199018)(186003)(6486002)(83380400001)(478600001)(316002)(66556008)(66476007)(8676002)(66946007)(9686003)(6512007)(26005)(6506007)(54906003)(41300700001)(6916009)(4326008)(7416002)(8936002)(44832011)(5660300002)(82960400001)(38100700002)(2906002)(33716001)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?csd7YXli84CZ/Q++fisy45rkyLYpV5GzhfKKBwh0RLNjxkIYdpBXMURf3qGe?=
 =?us-ascii?Q?VKketyACGbb0P5yMfBsWof5XNY4SyTFSfnMb1hpiSxaKdyyPOSf0+oa1rNSN?=
 =?us-ascii?Q?dF/GDEeEZ8g5PuD/MaKPLlEb8V7GlAGMyJOUJwYon9HEg+i9pWwPUl4Fy2sB?=
 =?us-ascii?Q?DQMNmassz3DvxIsvBC+rwYwvBnN57Ys5o+vwYoUSJv5k2XGs6X8iJlxA/mO5?=
 =?us-ascii?Q?/oxHapJibtjlQ8I/9yd9mLv0y/JkCfnKkAo5k7oahu1/gsUl1vU+tUIER5Ha?=
 =?us-ascii?Q?ElRDFShQYktug0JQhUM/R+vCTj8W6AszMOdsGKpSvfcxCOXNLDY+GoSxAMd9?=
 =?us-ascii?Q?31zajgWnwPo2gMle9yvuE7TR69YqDuI6apP7GnKIP7r5jQRy6pu+61WaqNc1?=
 =?us-ascii?Q?5D8Sd1DR/zqzh7JaabHs42yTdC/MWZDQPj4auzfJ7J168eWnsV1e5WREu5kV?=
 =?us-ascii?Q?0KdunWsisb5uUUP7r6HVFAD9YvqTFsA5TNhIDeeob5eGHAB/AVrnFhgSWtaq?=
 =?us-ascii?Q?ZPxMDQSBSPgmqugMFaxO8Sgqp2pIcbrGitc7jokhKLpnzPlAZUwblysv30LK?=
 =?us-ascii?Q?+jWii6X89cF2lYvRzY51uVkfoktsfXFK2GpIkWHxYLe+IJcpkzAP5w9elC6H?=
 =?us-ascii?Q?uIP/+CHMGdspr2LQ0V21FwFyxwE6rwnY9yx//a9MDs1NjlJWmMElYtt9gX34?=
 =?us-ascii?Q?1skgK/6k0Ic1L7EUeZwA7lYS1gP8pAIb1HNhfsDTcZJNeNB7jzvWL2AUPq6m?=
 =?us-ascii?Q?h7yWREwm23FxR91hi7hEISjW5aM5WNs9yAyROzV1UKH+YkAwy5jLNOE7Q+v+?=
 =?us-ascii?Q?FUEWSYJvWl+chQ1aJPbPSus3XCPZi8+DqREep2iuUjKPuMlk0RltRnHbXVP5?=
 =?us-ascii?Q?9u5upfCTsY0Tc+flU2JOoPy2ANkDnSoh84KxDUihXD2pxaRWY7pdRerZlmQz?=
 =?us-ascii?Q?y00uST4eNLUs4DRq0EsYWIoOBsGnV50WcjRW7cCLdnj4Xijw+xpqeMlzkBmg?=
 =?us-ascii?Q?Q4F1ivdMtE3/69GOk6ZtEyCM5jV5atw1eIwq9b8kIE4eg9I/1YFdj4UsEgAU?=
 =?us-ascii?Q?DZ5wlsAdHo0sd44YTb8eZQV8RnaKSH1vMPP2S+n9MP0wVvkYXP+dSZUajMow?=
 =?us-ascii?Q?7zBcIka++Y9fAmYInghNwXdHew4at/fXsKfzn1z13ACXJ6LwBebw8vX/oVsS?=
 =?us-ascii?Q?XoDSZdHfRZQ2cdMH0bxBE0YDt7V5+wFB62nHHJovOJkjNnaegLgk6BQWYCBp?=
 =?us-ascii?Q?MXe4diFXWPdc/Wpyu7c68Hmd6Gxm2H6JwxNqXAgae2yh753Wr4/1ZF6gIOLn?=
 =?us-ascii?Q?b0pdIQuHekwQasaXYHV6qT4qRu+QJLz2uSqwX1BUdXLp7CGTGTLb0Z3Zzwva?=
 =?us-ascii?Q?j1t3sOzT4J3I6snsYhKboN0Pb0RT6Wt9JxEyzB3iCCqKEOPHBf5VnhaVWfi6?=
 =?us-ascii?Q?sZRufkH6ZugD4cBdktIy0MRy0flvbudmcyZ2a20sg18WAZ8IxSI24MNvdrfm?=
 =?us-ascii?Q?peAS6lMtAmqKMEBfdi/OVChdD15n3yJO8pFcPPZmESHAQvLt7+ter1ZaRx6o?=
 =?us-ascii?Q?xDLwpo6276qToLoVbeuGheY092eGBpiQvezakViLeXRoo12rAXo6D/xUpK2m?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50aa8736-77ba-4d97-ff9e-08db2714da8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:24:32.5240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcGvPLdIkLI6yvkvmwwTZgnIAVlvRjMXQv/SIT7m0qi2drovI+ByDOgVugepIwX7MouI8CR2f98GNOEtAiHbEOfufWVk38ZQot9whbK0Mfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7657
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

On Fri, Mar 17, 2023 at 06:42:42PM +0100, Sebastian Reichel wrote:
> Right now any clock errors are printed and otherwise ignored.
> This has multiple disadvantages:
> 
> 1. it prints errors for clocks that do not exist (e.g. rk3588
>    reports errors for "mac_clk_rx", "mac_clk_tx" and "clk_mac_speed")
> 
> 2. it does not handle errors like -EPROBE_DEFER correctly
> 
> This series fixes it by switching to devm_clk_get_optional(),
> so that missing clocks are not considered an error and then
> passing on any other errors using dev_err_probe().
> 

Fixes tag would help here.
Piotr
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 47 ++++++++++---------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> index 4b8fd11563e4..126812cd17e6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> @@ -1479,49 +1479,50 @@ static int rk_gmac_clk_init(struct plat_stmmacenet_data *plat)
>  
>  	bsp_priv->clk_enabled = false;
>  
> -	bsp_priv->mac_clk_rx = devm_clk_get(dev, "mac_clk_rx");
> +	bsp_priv->mac_clk_rx = devm_clk_get_optional(dev, "mac_clk_rx");
>  	if (IS_ERR(bsp_priv->mac_clk_rx))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"mac_clk_rx");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_rx),
> +				"cannot get clock %s\n", "mac_clk_rx");
>  
> -	bsp_priv->mac_clk_tx = devm_clk_get(dev, "mac_clk_tx");
> +	bsp_priv->mac_clk_tx = devm_clk_get_optional(dev, "mac_clk_tx");
>  	if (IS_ERR(bsp_priv->mac_clk_tx))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"mac_clk_tx");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_tx),
> +				"cannot get clock %s\n", "mac_clk_tx");
>  
> -	bsp_priv->aclk_mac = devm_clk_get(dev, "aclk_mac");
> +	bsp_priv->aclk_mac = devm_clk_get_optional(dev, "aclk_mac");
>  	if (IS_ERR(bsp_priv->aclk_mac))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"aclk_mac");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->aclk_mac),
> +				"cannot get clock %s\n", "aclk_mac");
>  
> -	bsp_priv->pclk_mac = devm_clk_get(dev, "pclk_mac");
> +	bsp_priv->pclk_mac = devm_clk_get_optional(dev, "pclk_mac");
>  	if (IS_ERR(bsp_priv->pclk_mac))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"pclk_mac");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->pclk_mac),
> +				"cannot get clock %s\n", "pclk_mac");
>  
> -	bsp_priv->clk_mac = devm_clk_get(dev, "stmmaceth");
> +	bsp_priv->clk_mac = devm_clk_get_optional(dev, "stmmaceth");
>  	if (IS_ERR(bsp_priv->clk_mac))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"stmmaceth");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac),
> +				"cannot get clock %s\n", "stmmaceth");
>  
>  	if (bsp_priv->phy_iface == PHY_INTERFACE_MODE_RMII) {
> -		bsp_priv->clk_mac_ref = devm_clk_get(dev, "clk_mac_ref");
> +		bsp_priv->clk_mac_ref = devm_clk_get_optional(dev, "clk_mac_ref");
>  		if (IS_ERR(bsp_priv->clk_mac_ref))
> -			dev_err(dev, "cannot get clock %s\n",
> -				"clk_mac_ref");
> +			return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_ref),
> +					"cannot get clock %s\n", "clk_mac_ref");
>  
>  		if (!bsp_priv->clock_input) {
>  			bsp_priv->clk_mac_refout =
> -				devm_clk_get(dev, "clk_mac_refout");
> +				devm_clk_get_optional(dev, "clk_mac_refout");
>  			if (IS_ERR(bsp_priv->clk_mac_refout))
> -				dev_err(dev, "cannot get clock %s\n",
> -					"clk_mac_refout");
> +				return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_refout),
> +						"cannot get clock %s\n", "clk_mac_refout");
>  		}
>  	}
>  
> -	bsp_priv->clk_mac_speed = devm_clk_get(dev, "clk_mac_speed");
> +	bsp_priv->clk_mac_speed = devm_clk_get_optional(dev, "clk_mac_speed");
>  	if (IS_ERR(bsp_priv->clk_mac_speed))
> -		dev_err(dev, "cannot get clock %s\n", "clk_mac_speed");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->clk_mac_speed),
> +				"cannot get clock %s\n", "clk_mac_speed");
>  
>  	if (bsp_priv->clock_input) {
>  		dev_info(dev, "clock input from PHY\n");
> -- 
> 2.39.2
> 
