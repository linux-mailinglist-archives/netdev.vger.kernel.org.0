Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA51F6BCCEC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCPKgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:36:08 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1321735;
        Thu, 16 Mar 2023 03:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678962967; x=1710498967;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dvCx4nvSjzXyEWyrfmWg2nmOe5l2cJqpOk2LkTBiVeE=;
  b=h4U47KwD/z56SzOsh5jwWzZMHadzu6fVArcuWePatWlk4h66EP+DQfbu
   pjHbxTeJiJGnbsj97lT+3x++gN+tTZZb2V70orkKaE107bLqdz376Kwhk
   wYxLo+j+GwudoLYS0pOBhCsKF0YBwUJOk/iN75NIAt2CIHRflJdX5bwgo
   TxfTFe0PAwKomFxjxvw44pVO79RilNwsp2kTN9h4u7tSzR9TgeCb6ndLP
   jQDkW9lKtnPhMROMXvo8PS0DMn3zsh8PiqO4kBIUbbMwiEMrOkzg4eTNh
   vvyO81JApBE8+yzBOy0sDwGhmIXHMKBmwtKcs3w6zyvQEW8nDNbq1+uPF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="400521521"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="400521521"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 03:36:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="823180039"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823180039"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 03:36:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 03:36:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 03:36:06 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 03:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2nGt+FwYn/jSF3rvxdUEC/+UsiMtFNUUiizK9FkcIQJM9hkBrfU9SBZJ6BUZVAmvMTA1/T6ZwjbFhuxtXojcDOvtZClqkHNtNnQCWhxytcGJVX004CrqpdGeQGHTfBBJFdbTnhHruHJ07Y6QF+gIssnTdo/Cx1MRIm+/bnZY8wRCRI1DGAKxsq9NAv3mlzLelr6QHe1rcqOMLLBheTxVLIFZxomXuG+pvE3FRiz+t/gHLRVPOlE32E1Z/vDXuiYIhWO92cSJv52qSe7clqVhpq04aKMChTZR4iapHG0NhfV7hnVeMucZLhn7IA0vSrRpnw5rakEGG4I/ska2rSFBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eap+JaHFidn4S77CQW0nwPc1l7W9OGqbuiJ3DwacP5A=;
 b=UovemyNqNWYtFGcqa+f/DdjVFY0+mwpACJ2oJQ353HEo1YpZOoCp+AkG4N1wvHNjdU1kY5R6PBI2qBmZmvbfMRPXZ2za0bB8pjhPbL1acrIdDbQHnmTpUtAZ6fuxLUJTRMe0m6OGDXXwveasLnNDGWsCUt+3dMDQfiSmJUdNw9rJm3LUTxI5vdYBKEjYYFl39Sndjei5toN0nVMIKtANkbHL0BCcgk+nnBXeWW3fe1z191lPuYxdDmCi11CvJeotqphy+1pX7LceQZpV4mS1CHgQ3FnGULH1ikmRWiUNxj3RwydKt4mjIOf7Wuaex9uU6OKVGzGDiZ0LvpibTqyiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH7PR11MB5765.namprd11.prod.outlook.com (2603:10b6:510:139::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Thu, 16 Mar 2023 10:36:04 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:36:04 +0000
Date:   Thu, 16 Mar 2023 11:35:57 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Bartosz Wawrzyniak <bwawrzyn@cisco.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xe-linux-external@cisco.com>,
        <danielwa@cisco.com>, <olicht@cisco.com>, <mawierzb@cisco.com>
Subject: Re: [PATCH] net: macb: Set MDIO clock divisor for pclk higher than
 160MHz
Message-ID: <ZBLxDZRuRjyJb7qN@localhost.localdomain>
References: <20230316100339.1302212-1-bwawrzyn@cisco.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230316100339.1302212-1-bwawrzyn@cisco.com>
X-ClientProxiedBy: LO4P123CA0567.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::20) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH7PR11MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a739c5-6cd9-4fe7-ef7c-08db260a3e51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlAAA4z8RGwh0hJGlXxGkeZQSTShve9d6bgXuwatOolHkahVe1mSIs3XOkDsuGw/YTPraavLC1aa/aexmsgf7I4lGED4c5ZGDXd1DDC9FhFd2j65kRaeXNgpj6s4Tt361ZJAL198I9Sm8fHdDdpk7wqqDr5WIWFduOBPflhri0VhKJbmAFTwEBy2lWMRycPqVhmgP65Ix6SpDE6hQ4jzaL/6QmyDPzl///mbf9z14F6jiGL452KIPOEWGB8DlpP5/0aqBZooO0GrEZB8AzCiPvx/AmIPLP5dRi5+sDnEGjNDC4LNocBM1CMHtZ06KOqXio1ympzhsXQmqTOhVp4moUCv8t4DefJohWSz6yQVWAaU4Q43oKCE+CD0U+Rh0R3/FPDzL09+sisDJVDjz8DgVJOY2vNjQ1cyfcHuJywwjYk/4gExQnWuTb6RgN9MKhcxUR3GmX1Tebj8lQHhAIR4lNeLq1uR6CJkpqF0p69/crpgzulDOTcoFyhmhwPX9/Wndi4odDYkeZvQgz5OVtddqlh3XR6mQLOMCsiUAhpRlqkpJHvj6jXbvNAfAAAaksyllTY7fUup5V+pZ7bRO6YgAAUaxKm0ozxPFbmreFK+41g9fTxRr4GjIPfxWnms8LzjAPyOD6cqwOJ/Tq5hN0mT3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199018)(41300700001)(5660300002)(8936002)(7416002)(2906002)(44832011)(38100700002)(86362001)(82960400001)(478600001)(66556008)(6916009)(66476007)(8676002)(66946007)(6486002)(6666004)(316002)(83380400001)(4326008)(186003)(9686003)(6506007)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aKj9jNPKslKZdllW+tY9o57ZKRX2hUxhRp8X7R9uEuhYlbmgky2sCMavDkJa?=
 =?us-ascii?Q?XqKUacfRax79VyxQxWUk5fhLF/6qzI2AzSuS8qYnrifgYQmr0L9oU0mtpc6Y?=
 =?us-ascii?Q?617l/tWk8VzoOsVsVan3iCEkfU7hIRXBOTeL14NHvB2v6yQmFcGEu62NJpIs?=
 =?us-ascii?Q?KZbxgy4Jd9cKRcpZKb0H8A4gWUV+8PC3yzAloeCBmUOc0Fex9d/qOMhuw/n5?=
 =?us-ascii?Q?aGlIrD/+7NQoa3c7TD50KY9mLpFxCRINPcKfuenLtFPwAlW0jjeoEp7Ht4Ka?=
 =?us-ascii?Q?/z4rzlKHICU/Wu++9uZl7vZp2GuFz6BuxDvDBi139y93T+R3BaGfr2T0kC9A?=
 =?us-ascii?Q?Sc2uxTLhlo4a870zhue0NBO/3hRSagaGofxAPhO8XsGPpR+6nH5hsVu5N3kH?=
 =?us-ascii?Q?zxTbwuEZ593qdTsvoywpqChf7BKuzQLTHcctUB6Qj7K0CbDIQXgMENnDrd8n?=
 =?us-ascii?Q?AzWwehP7w5l/UoJJfiplLD/jXNbfM7eoeG4Ym6jFFrVltc/na7MxYWIbugMh?=
 =?us-ascii?Q?bk8jjqY1xwRW7DyiQ7HFfz0cjQKIM9lRpZ6OQV3Z/6R7AZW86yCs64+KX39b?=
 =?us-ascii?Q?LmU7vDVIkvztIxcA2aRW3TtrVtWVX+tVmZoqZVUIeHxMhxXp2faTtvVa/TW7?=
 =?us-ascii?Q?Y7LMQ4GE33ScBezWgzSthdrqfIDc2klg3NLkZsehmmWvA1ik2ea7HbrTX+5Z?=
 =?us-ascii?Q?RpmYSeBVMfCOgolpOkD+9wc1sMb9sD5EttQQr0cXyRGJOdrglXx4sd47uq5M?=
 =?us-ascii?Q?CuO2piiXessleC8Gsn59reVodkj0xZw14qk3UkslYpsmKpz0LKPyITFbB1L0?=
 =?us-ascii?Q?AkapTR+5ixw8ODC/BZTA2LSF5BN9cneCFm0Jz7x0NbjTfU4EmzHAOGP80Q/t?=
 =?us-ascii?Q?nO8kLXNWGXOEJULlrJz/5BPL9zA5qUAKtpz6QQqXAfQ3o5gd4L1uSPYeNh8N?=
 =?us-ascii?Q?98Yd4aQ3cyLEgKW1Q9ZfkLxMvNDXNjYYwNia5TFMocd/Wc2TqWQGjEAJI3Lx?=
 =?us-ascii?Q?lfRn4INkxaNmtDnL6FSrLkRSCZZpUvAmTTKjhtkOxLqTwbljv93YTTOKzU04?=
 =?us-ascii?Q?sTwFi8roVfPPXSurHWu6+eqpfQxrOaQttatHoBqdApgMN0v8s1lYDwQiKQoa?=
 =?us-ascii?Q?xBBcuMtT7qpLNkEeV148uCT2m4QJywPZh7o0aLivEYD5W3mYYA8aOJnsd3DB?=
 =?us-ascii?Q?hiJFl92xDyAhfaOwi1ahFECuFW3RErQlUd/O9R42QaiSK6+J5JBXH2GMkBJ9?=
 =?us-ascii?Q?o3BLVrXzFufZl4rpk59iaxrw2HJGdF+XWkoksxM4e/XarRfm/r6Omu6FXDAi?=
 =?us-ascii?Q?ks7PFJD41p2gtnR0fSH9yDupo00AxFQ1OK+M2NfId2AddjykF/Hio83v2Yzk?=
 =?us-ascii?Q?K8/Vp/jx8NQipiy4yVuYmFflisjJczxK9bRf53sm83jbTUCSIarVoe9mxkkt?=
 =?us-ascii?Q?VPjyE+uD45s44F6fnkezN03CiTPmwCWRAdYAMlALaI/XdXKZIdtkvrB9Rmxl?=
 =?us-ascii?Q?uQA4P2guuMJhX5Xyy3GJCLwD7eS+YpaY1wey+jzxonCDcps1Nk0K9eErBT+9?=
 =?us-ascii?Q?Jj78D55ojqa+RCqqMYvUgL3EyH4YdeWuIwUgJIAx5LtNEvS2JeY5v8HCIIaj?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a739c5-6cd9-4fe7-ef7c-08db260a3e51
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:36:04.1705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOLj1qhdxKF5L1dmVaike0RwDCl5iBFuktAWom6RA/5BzQUca+qX9235+xClM06MPTMQnkEWH/ykNRxfHxX3Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5765
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:03:39AM +0000, Bartosz Wawrzyniak wrote:
> Currently macb sets clock divisor for pclk up to 160 MHz.
> Function gem_mdc_clk_div was updated to enable divisor
> for higher values of pclk.
> 
> Signed-off-by: Bartosz Wawrzyniak <bwawrzyn@cisco.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      | 2 ++
>  drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 14dfec4db8f9..c1fc91c97cee 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -692,6 +692,8 @@
>  #define GEM_CLK_DIV48				3
>  #define GEM_CLK_DIV64				4
>  #define GEM_CLK_DIV96				5
> +#define GEM_CLK_DIV128				6
> +#define GEM_CLK_DIV224				7
>  
>  /* Constants for MAN register */
>  #define MACB_MAN_C22_SOF			1
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 6e141a8bbf43..8708af6d25ed 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2641,8 +2641,12 @@ static u32 gem_mdc_clk_div(struct macb *bp)
>  		config = GEM_BF(CLK, GEM_CLK_DIV48);
>  	else if (pclk_hz <= 160000000)
>  		config = GEM_BF(CLK, GEM_CLK_DIV64);
> -	else
> +	else if (pclk_hz <= 240000000)
>  		config = GEM_BF(CLK, GEM_CLK_DIV96);
> +	else if (pclk_hz <= 320000000)
> +		config = GEM_BF(CLK, GEM_CLK_DIV128);
> +	else
> +		config = GEM_BF(CLK, GEM_CLK_DIV224);
>  
>  	return config;
>  }

Hi,

The patch looks OK.

Thanks,
Michal

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

> -- 
> 2.33.0
> 
