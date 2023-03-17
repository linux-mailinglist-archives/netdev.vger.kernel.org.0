Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCA26BE7FC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCQLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCQLYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:24:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E155D51CA1;
        Fri, 17 Mar 2023 04:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679052288; x=1710588288;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N6MsZjZir/Xx5fC2zCGUFStQXFLv9HhvIFK3lf1Vhi4=;
  b=X8uX9OeNv+GxQqbCUOZCWb+h1Mo7n5gYpKzuqF8yiHZAfDa+OuHxuDfX
   5c9Ma4UVxPMVCO90ACznj8zqJzpd2/0N/JTVOo7inKdBfMkArvFrk/BC2
   o2K4/XSEnbh+qf7nN7jC72212AoGcvHUWAhsaNO6UxXefLdF2BdFki20t
   1IqIK4Ee9Nr4NEzoE4s9XiSSpRfb1bKuQaazfmHbpMArqXTX24mBCchwT
   PXhsQTFYdxferUqjX4Y5eEFun97UpgpePrBdxCDjyhULFSxAb+oq1athw
   zwtpsPpH/ipmZXXS6QOYEZKgsoNvxfytzE4+2gMvp+oHn01Yp4P+Hgpg8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="424511178"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="424511178"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 04:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823638646"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="823638646"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 17 Mar 2023 04:24:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 04:24:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 04:24:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 04:24:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZHQTz/xDzWa3qf/vnCuUFR3smjmoXv+BLrH1dD6TGa3hQimhxpqzA1EhxCv8Nntk6rGsY097aQnCg7ke9kya5EXzfj+TjBjOptoGc34F33zR7WekuyqOCO/goW5TiMq3m6CxMR27UNxyQqmx14z7uVBPLojQ2QJqBlvFZ4dbUCaRjebtnXIoOOtHtlnKGGepl88GjrvixPo9LJxBrMi66NL2JS4upuD2oAuHTXoddofwGgQ5Nzxj2maLMWjJpuYAvpA7BkzqCY+bK0110RWhnubdj9jNd/6aDIhVOzV5BNnVsnnkkJA4gMcWCrStYeSzNhqFPDMAMxhDrJyLGz33g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XrpZrXRwOXSQUf8vlWswSTCN27bOdcmujGGcG94yBnc=;
 b=ZhMvGz4FHtV/6pPdKDH0S9ig/JUXKZc8SaLcUZhOgbq3uw06CqvXCel37wh1RSJHXZfyJaj0mLOqLZv+i+Ugn8axNjYpuKEZ9TDX/r7+UnNwAxlZM4no67cBKA6XGBSOh6I7qXTsPIcDQdlmvGimj4wRspSm8zvzNMqrHeX4bLZF3srRCC9wAG/GQxqz//8XtaPHQjTBOqRDgU6+e7Rz/5/D1yRptYUVkBGXvchOo9kQdxmgUWGo7CG7v82Y/CmkADJXXKXFl+0TEXaHHG+Q7zIbqGhDYoW+khePXKEV6JAx8SrKV15ZLrmu56GB3f/bstAHh0NzbvMh20A2+++Lfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 MW3PR11MB4618.namprd11.prod.outlook.com (2603:10b6:303:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 11:24:39 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 11:24:39 +0000
Date:   Fri, 17 Mar 2023 12:24:23 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, "Lee Jones" <lee@kernel.org>,
        <linux-leds@vger.kernel.org>
Subject: Re: [net-next PATCH v4 02/14] net: dsa: qca8k: add LEDs basic support
Message-ID: <ZBRN563Zw9Z28aET@localhost.localdomain>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317023125.486-3-ansuelsmth@gmail.com>
X-ClientProxiedBy: FR3P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::15) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|MW3PR11MB4618:EE_
X-MS-Office365-Filtering-Correlation-Id: a938c2d1-e0b3-4ce5-7312-08db26da3213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itAkitOpks4xLEglhBI2dRk271lPTYtdvNeXmnFxzVOYZ+NYvBlk2ETGMfEWOZoNqxBosmpI3MRJH81+vY6DeTum86Xdv3mx2ugKnUgeLzUewkyuYtZ2/Ydv7VKuSNV8YMTvCHVXcqqy2efLbuLcU0ylZLY2bXwDu+mwctvObFV9bMDUlFox/3fEN/RYoA8j3DfbHXtv+2n/kQs0V2+2kGilQeSfr1MUcJpFbIzynsk9Hc31w8N0qdrm5u5tf3flGsXPzmUe8vHZrqE7CdIeKiG9xBmSxVdVfC1sFC91UI8ikKbYIDcY0IKiBKkGBwzDIhhiSn1um6cPn3dXQLDWaC9/FqQGwYWNozzWByDF7VKofk7Wa5/fCJ4s0FjngK/nyD825mWm9ExhFsD6LnGQTqFX5JWQEOfR7BSHdYa6fX6J4ilTF0gtg9CuwxE8O7MJMpPE7ebrzxVIaOmJVrU8rboN8eZ7vK6pr3FVYMypsbRFtceiFoTD97DUsa1XtLI6x9JeaQry5aT5CiA08F5fv38KZcwEiC4h53o6gEguWSDqpM6M5//3BZNi4oDGZnVD4yYv8+mICU3O1xh90FPBX3lOO79Vou+K5wO+6pqNscC6pSNcl9t87LsTb2DYEN0tSPzqR+la/3ggE1g8w0w45z0h2w+QGAAbRfVYIVcjth2I7r7yFZ3uhDkMLkPOCLvl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199018)(186003)(6486002)(83380400001)(6666004)(478600001)(54906003)(316002)(8676002)(6506007)(6512007)(26005)(9686003)(66476007)(66556008)(66946007)(41300700001)(6916009)(4326008)(8936002)(44832011)(7416002)(5660300002)(30864003)(38100700002)(2906002)(82960400001)(86362001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JOZd03YpcOOd8oYo6siffYc7ta6BSAtFg+kAVjQY1ZGdmMPwf+l47RmX6Bgr?=
 =?us-ascii?Q?TYz7UXEPHodkqEtzdyqML362bb9rg8x66NfWZr5FQW6mspn5deXPQU6a6JH2?=
 =?us-ascii?Q?I9cg/n2VRTJKD5r2EP798fL73n2CdTbHbfo7d7K50wFJpai3A40cDlLlE6ay?=
 =?us-ascii?Q?oFbuuleJKPvKn/D9sXGr0keTv3H2jc6GQZPoyLs1KafnyIMikC4RhujOZ6FG?=
 =?us-ascii?Q?zkarVreO9UQPRkcCisWbBt4XzY+AwUA4BuVW4iN3YwdlWXcZXTeYhkVWJSae?=
 =?us-ascii?Q?bLYrMUw2TecymrB7pyOyS/C4KoBrtz2qmlFveulUN9I8A0juTpyTcdlIjdtD?=
 =?us-ascii?Q?0TD5f8S7Fh0+5ho0aeJ+LR/+LIEnpYodQyAoTm9nidUM6/UBy0cQm0V/0li7?=
 =?us-ascii?Q?vWmwyZaJHevIyetrJw9rTd/GiPT0L6W/ZnQ6HFnWMoist/So7aBr12VUmEBz?=
 =?us-ascii?Q?MktF4DKbpkf4cvcVCbDutZLwGlyYrXRS9/WAe1GGbtHB7dYfG6R8h+oKlN1G?=
 =?us-ascii?Q?3S4+ayYWGeme2QvKXX8jCTCtkWh1ejgrZZ2D+5H254BpcVFN8xojzkUhrCFB?=
 =?us-ascii?Q?omfjr6wD5T91jF+65ssn79svcZC+eDpxnalb+3+PwrqCLOtKIv1mYOilypsc?=
 =?us-ascii?Q?VjYOfFNDlmgjsXZa7nQPA/luovKxbKExcRVm84WcMC4nST/woJaBoj9/Pvwh?=
 =?us-ascii?Q?wM8kPPmY5TcEBTW47EV+wguzRIduHgvNOY2fRCpNaVCUuoMj9atanA6pr6kE?=
 =?us-ascii?Q?Tysi4DWpImHWb+fh+lbvtt4BvIKB8MK99PYrdF0+9L56tor83yI2aepTxTGD?=
 =?us-ascii?Q?G6jnfhoqstqtPczlfAh3vUspxHsLcG3fkDeA2780869Jz20fot22rDY5CR2s?=
 =?us-ascii?Q?zXo7DVrJfwpCpVyf4+se4CVVIxUG4SYRw2yj1OPMrMQAV82Fu13BmYMr1BW8?=
 =?us-ascii?Q?xCbvcfDC3JPj51pM0MYgHGgj8HjOuqwObP+k+Zpp4N2nVoMGT43X40m20Qgo?=
 =?us-ascii?Q?7ck0HIUst+1EhXKPnfG5PywdXuN1pPQWpeGYIPu1/9x86KTlTFCFw9fk5DQJ?=
 =?us-ascii?Q?h86f/LkReakUDMoJMMOeAsLJVJSL1nyZkqwlSIrmRB4M++JHQZdn30p+y7Qt?=
 =?us-ascii?Q?ITo1wJtI4ZNgwjAuPVkdXFfRdOJq9sM4Waa5/Mmlf+pbneQmiSv3d0IPQ34u?=
 =?us-ascii?Q?Ed1rilcBMQz0q7aWDWcLr8Yl/Rl/AduT6jPgvcQWhV1bKSMGcPlBpxs0T0U+?=
 =?us-ascii?Q?A3mALZyxx7QuXX/ZsM+FyymI5/3Ec6kXnZIQBmrhJ1qZV0mW1XerJMK0rqzT?=
 =?us-ascii?Q?JFIq8At0BdVJDxzswcDyZ0u6eNP+Hfo9drQqPfQYbI+UMsd3EOsMJwWWUEMW?=
 =?us-ascii?Q?wzPmksrd0vEeEStdNO0wWjhAp8HQLR4rRT8PgeAq8xc5nWh02tbRPV+AyslM?=
 =?us-ascii?Q?HLSAxr6tR3m5HZrYI/Bl1iTqhtA3Eb9lIau8ojrgg1uAEulHw/vRgcYQ2gWk?=
 =?us-ascii?Q?EhXCE2BqEfek9ChQ/m7glcapn4rchLRubGQFvdDdIQwucAsx1XrmNxJHFcqA?=
 =?us-ascii?Q?lvz1jiP6NK1PMpU404srPoyIuwGfunRNDnURC/zC7tRxX+MjgUiQGqU3L45r?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a938c2d1-e0b3-4ce5-7312-08db26da3213
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 11:24:39.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pnzu/tXFSMMgMro1us6Z784IdWwQ8ra6J2+6vRbBkIToOurHuR05LI1A/Z2odFr+WCg5I7r128VTrPyQ5qqeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4618
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

On Fri, Mar 17, 2023 at 03:31:13AM +0100, Christian Marangi wrote:
> Add LEDs basic support for qca8k Switch Family by adding basic
> brightness_set() support.
> 
> Since these LEDs refelect port status, the default label is set to
> ":port". DT binding should describe the color, function and number of
> the leds using standard LEDs api.
> 
> These LEDs supports only blocking variant of the brightness_set()
> function since they can sleep during access of the switch leds to set
> the brightness.
> 
> While at it add to the qca8k header file each mode defined by the Switch
> Documentation for future use.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Hi Christian,

Please find my comments inline.

Thanks,
Michal

> ---
>  drivers/net/dsa/qca/Kconfig      |   8 ++
>  drivers/net/dsa/qca/Makefile     |   3 +
>  drivers/net/dsa/qca/qca8k-8xxx.c |   5 +
>  drivers/net/dsa/qca/qca8k-leds.c | 192 +++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca/qca8k.h      |  59 ++++++++++
>  drivers/net/dsa/qca/qca8k_leds.h |  16 +++
>  6 files changed, 283 insertions(+)
>  create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
>  create mode 100644 drivers/net/dsa/qca/qca8k_leds.h
> 
> diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> index ba339747362c..7a86d6d6a246 100644
> --- a/drivers/net/dsa/qca/Kconfig
> +++ b/drivers/net/dsa/qca/Kconfig
> @@ -15,3 +15,11 @@ config NET_DSA_QCA8K
>  	help
>  	  This enables support for the Qualcomm Atheros QCA8K Ethernet
>  	  switch chips.
> +
> +config NET_DSA_QCA8K_LEDS_SUPPORT
> +	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> +	depends on NET_DSA_QCA8K
> +	depends on LEDS_CLASS
> +	help
> +	  This enabled support for LEDs present on the Qualcomm Atheros
> +	  QCA8K Ethernet switch chips.
> diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
> index 701f1d199e93..ce66b1984e5f 100644
> --- a/drivers/net/dsa/qca/Makefile
> +++ b/drivers/net/dsa/qca/Makefile
> @@ -2,3 +2,6 @@
>  obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
>  obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
>  qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
> +ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> +qca8k-y				+= qca8k-leds.o
> +endif
> diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
> index 8dfc5db84700..5decf6fe3832 100644
> --- a/drivers/net/dsa/qca/qca8k-8xxx.c
> +++ b/drivers/net/dsa/qca/qca8k-8xxx.c
> @@ -22,6 +22,7 @@
>  #include <linux/dsa/tag_qca.h>
>  
>  #include "qca8k.h"
> +#include "qca8k_leds.h"
>  
>  static void
>  qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
> @@ -1727,6 +1728,10 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	ret = qca8k_setup_led_ctrl(priv);
> +	if (ret)
> +		return ret;
> +
>  	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
>  	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
>  
> diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
> new file mode 100644
> index 000000000000..adbe7f6e2994
> --- /dev/null
> +++ b/drivers/net/dsa/qca/qca8k-leds.c
> @@ -0,0 +1,192 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/regmap.h>
> +#include <net/dsa.h>
> +
> +#include "qca8k.h"
> +#include "qca8k_leds.h"
> +
> +static int
> +qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
> +{
> +	switch (port_num) {
> +	case 0:
> +		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
> +		reg_info->shift = QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT;
> +		break;
> +	case 1:
> +	case 2:
> +	case 3:
> +		/* Port 123 are controlled on a different reg */
> +		reg_info->reg = QCA8K_LED_CTRL_REG(3);
> +		reg_info->shift = QCA8K_LED_PHY123_PATTERN_EN_SHIFT(port_num, led_num);
> +		break;
> +	case 4:
> +		reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
> +		reg_info->shift = QCA8K_LED_PHY4_CONTROL_RULE_SHIFT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_led_brightness_set(struct qca8k_led *led,
> +			 enum led_brightness brightness)
> +{
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 mask, val = QCA8K_LED_ALWAYS_OFF;

Nitpick: RCT

> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	if (brightness)
> +		val = QCA8K_LED_ALWAYS_ON;
> +
> +	if (led->port_num == 0 || led->port_num == 4) {
> +		mask = QCA8K_LED_PATTERN_EN_MASK;
> +		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
> +	} else {
> +		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
> +	}
> +
> +	return regmap_update_bits(priv->regmap, reg_info.reg,
> +				  mask << reg_info.shift,
> +				  val << reg_info.shift);
> +}
> +
> +static int
> +qca8k_cled_brightness_set_blocking(struct led_classdev *ldev,
> +				   enum led_brightness brightness)
> +{
> +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> +
> +	return qca8k_led_brightness_set(led, brightness);
> +}
> +
> +static enum led_brightness
> +qca8k_led_brightness_get(struct qca8k_led *led)
> +{
> +	struct qca8k_led_pattern_en reg_info;
> +	struct qca8k_priv *priv = led->priv;
> +	u32 val;
> +	int ret;
> +
> +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> +
> +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> +	if (ret)
> +		return 0;
> +
> +	val >>= reg_info.shift;
> +
> +	if (led->port_num == 0 || led->port_num == 4) {
> +		val &= QCA8K_LED_PATTERN_EN_MASK;
> +		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
> +	} else {
> +		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
> +	}
> +
> +	/* Assume brightness ON only when the LED is set to always ON */
> +	return val == QCA8K_LED_ALWAYS_ON;
> +}
> +
> +static int
> +qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
> +{
> +	struct fwnode_handle *led = NULL, *leds = NULL;
> +	struct led_init_data init_data = { };
> +	enum led_default_state state;
> +	struct qca8k_led *port_led;
> +	int led_num, port_index;
> +	int ret;
> +
> +	leds = fwnode_get_named_child_node(port, "leds");
> +	if (!leds) {
> +		dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
> +			port_num);
> +		return 0;
> +	}
> +
> +	fwnode_for_each_child_node(leds, led) {
> +		/* Reg represent the led number of the port.
> +		 * Each port can have at least 3 leds attached
> +		 * Commonly:
> +		 * 1. is gigabit led
> +		 * 2. is mbit led
> +		 * 3. additional status led
> +		 */
> +		if (fwnode_property_read_u32(led, "reg", &led_num))
> +			continue;
> +
> +		if (led_num >= QCA8K_LED_PORT_COUNT) {
> +			dev_warn(priv->dev, "Invalid LED reg defined %d", port_num);
> +			continue;
> +		}

In the comment above you say "each port can have AT LEAST 3 leds".
However, now it seems that if the port has more than 3 leds, all the
remaining leds are not initialized.
Is this intentional? If so, maybe it is worth describing in the comment
that for ports with more than 3 leds, only the first 3 leds are
initialized?

According to the code it looks like the port can have up to 3 leds.

> +
> +		port_index = 3 * port_num + led_num;

Can QCA8K_LED_PORT_COUNT be used instead of "3"? I guess it is the number
of LEDs per port.

> +
> +		port_led = &priv->ports_led[port_index];

Also, the name of the "port_index" variable seems confusing to me. It is
not an index of the port, but rather a unique index of the LED across
all ports, right?

> +		port_led->port_num = port_num;
> +		port_led->led_num = led_num;
> +		port_led->priv = priv;
> +
> +		state = led_init_default_state_get(led);
> +		switch (state) {
> +		case LEDS_DEFSTATE_ON:
> +			port_led->cdev.brightness = 1;
> +			qca8k_led_brightness_set(port_led, 1);
> +			break;
> +		case LEDS_DEFSTATE_KEEP:
> +			port_led->cdev.brightness =
> +					qca8k_led_brightness_get(port_led);
> +			break;
> +		default:
> +			port_led->cdev.brightness = 0;
> +			qca8k_led_brightness_set(port_led, 0);
> +		}
> +
> +		port_led->cdev.max_brightness = 1;
> +		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
> +		init_data.default_label = ":port";
> +		init_data.devicename = "qca8k";
> +		init_data.fwnode = led;
> +
> +		ret = devm_led_classdev_register_ext(priv->dev, &port_led->cdev, &init_data);
> +		if (ret)
> +			dev_warn(priv->dev, "Failed to int led");

Typo: "init".
How about adding an index of the LED that could not be initialized?

> +	}
> +
> +	return 0;
> +}
> +
> +int
> +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> +{
> +	struct fwnode_handle *ports, *port;
> +	int port_num;
> +	int ret;
> +
> +	ports = device_get_named_child_node(priv->dev, "ports");
> +	if (!ports) {
> +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> +		return 0;
> +	}
> +
> +	fwnode_for_each_child_node(ports, port) {
> +		if (fwnode_property_read_u32(port, "reg", &port_num))
> +			continue;
> +
> +		/* Each port can have at least 3 different leds attached.
> +		 * Switch port starts from 0 to 6, but port 0 and 6 are CPU
> +		 * port. The port index needs to be decreased by one to identify
> +		 * the correct port for LED setup.
> +		 */

Again, are there really "at least 3 different leds" per port?
It's confusing a little bit, because  QCA8K_LED_PORT_COUNT == 3, so I
would say it cannot have more than 3.

> +		ret = qca8k_parse_port_leds(priv, port, qca8k_port_to_phy(port_num));

As I checked, the function "qca8k_port_to_phy()" can return all 0xFFs
for port_num == 0. Then, this value is implicitly casted to int (as the
last parameter of "qca8k_parse_port_leds()"). Internally, in
"qca8k_parse_port_leds()" this parameter can be used to do some
computing - that looks dangerous.
In summary, I think a special check for CPU port_num == 0 should be
added.
(I guess the LED configuration i only makes sense for non-CPU ports? It
seems you want to configure up to 15 LEDs in total for 5 ports).

> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> index 4e48e4dd8b0f..3c3c072fa9c2 100644
> --- a/drivers/net/dsa/qca/qca8k.h
> +++ b/drivers/net/dsa/qca/qca8k.h
> @@ -11,6 +11,7 @@
>  #include <linux/delay.h>
>  #include <linux/regmap.h>
>  #include <linux/gpio.h>
> +#include <linux/leds.h>
>  #include <linux/dsa/tag_qca.h>
>  
>  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
> @@ -85,6 +86,50 @@
>  #define   QCA8K_MDIO_MASTER_DATA(x)			FIELD_PREP(QCA8K_MDIO_MASTER_DATA_MASK, x)
>  #define   QCA8K_MDIO_MASTER_MAX_PORTS			5
>  #define   QCA8K_MDIO_MASTER_MAX_REG			32
> +
> +/* LED control register */
> +#define QCA8K_LED_COUNT					15
> +#define QCA8K_LED_PORT_COUNT				3
> +#define QCA8K_LED_RULE_COUNT				6
> +#define QCA8K_LED_RULE_MAX				11
> +
> +#define QCA8K_LED_PHY123_PATTERN_EN_SHIFT(_phy, _led)	((((_phy) - 1) * 6) + 8 + (2 * (_led)))
> +#define QCA8K_LED_PHY123_PATTERN_EN_MASK		GENMASK(1, 0)
> +
> +#define QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT		0
> +#define QCA8K_LED_PHY4_CONTROL_RULE_SHIFT		16
> +
> +#define QCA8K_LED_CTRL_REG(_i)				(0x050 + (_i) * 4)
> +#define QCA8K_LED_CTRL0_REG				0x50
> +#define QCA8K_LED_CTRL1_REG				0x54
> +#define QCA8K_LED_CTRL2_REG				0x58
> +#define QCA8K_LED_CTRL3_REG				0x5C
> +#define   QCA8K_LED_CTRL_SHIFT(_i)			(((_i) % 2) * 16)
> +#define   QCA8K_LED_CTRL_MASK				GENMASK(15, 0)
> +#define QCA8K_LED_RULE_MASK				GENMASK(13, 0)
> +#define QCA8K_LED_BLINK_FREQ_MASK			GENMASK(1, 0)
> +#define QCA8K_LED_BLINK_FREQ_SHITF			0
> +#define   QCA8K_LED_BLINK_2HZ				0
> +#define   QCA8K_LED_BLINK_4HZ				1
> +#define   QCA8K_LED_BLINK_8HZ				2
> +#define   QCA8K_LED_BLINK_AUTO				3
> +#define QCA8K_LED_LINKUP_OVER_MASK			BIT(2)
> +#define QCA8K_LED_TX_BLINK_MASK				BIT(4)
> +#define QCA8K_LED_RX_BLINK_MASK				BIT(5)
> +#define QCA8K_LED_COL_BLINK_MASK			BIT(7)
> +#define QCA8K_LED_LINK_10M_EN_MASK			BIT(8)
> +#define QCA8K_LED_LINK_100M_EN_MASK			BIT(9)
> +#define QCA8K_LED_LINK_1000M_EN_MASK			BIT(10)
> +#define QCA8K_LED_POWER_ON_LIGHT_MASK			BIT(11)
> +#define QCA8K_LED_HALF_DUPLEX_MASK			BIT(12)
> +#define QCA8K_LED_FULL_DUPLEX_MASK			BIT(13)
> +#define QCA8K_LED_PATTERN_EN_MASK			GENMASK(15, 14)
> +#define QCA8K_LED_PATTERN_EN_SHIFT			14
> +#define   QCA8K_LED_ALWAYS_OFF				0
> +#define   QCA8K_LED_ALWAYS_BLINK_4HZ			1
> +#define   QCA8K_LED_ALWAYS_ON				2
> +#define   QCA8K_LED_RULE_CONTROLLED			3
> +
>  #define QCA8K_GOL_MAC_ADDR0				0x60
>  #define QCA8K_GOL_MAC_ADDR1				0x64
>  #define QCA8K_MAX_FRAME_SIZE				0x78
> @@ -383,6 +428,19 @@ struct qca8k_pcs {
>  	int port;
>  };
>  
> +struct qca8k_led_pattern_en {
> +	u32 reg;
> +	u8 shift;
> +};
> +
> +struct qca8k_led {
> +	u8 port_num;
> +	u8 led_num;
> +	u16 old_rule;
> +	struct qca8k_priv *priv;
> +	struct led_classdev cdev;
> +};
> +
>  struct qca8k_priv {
>  	u8 switch_id;
>  	u8 switch_revision;
> @@ -407,6 +465,7 @@ struct qca8k_priv {
>  	struct qca8k_pcs pcs_port_0;
>  	struct qca8k_pcs pcs_port_6;
>  	const struct qca8k_match_data *info;
> +	struct qca8k_led ports_led[QCA8K_LED_COUNT];
>  };
>  
>  struct qca8k_mib_desc {
> diff --git a/drivers/net/dsa/qca/qca8k_leds.h b/drivers/net/dsa/qca/qca8k_leds.h
> new file mode 100644
> index 000000000000..ab367f05b173
> --- /dev/null
> +++ b/drivers/net/dsa/qca/qca8k_leds.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#ifndef __QCA8K_LEDS_H
> +#define __QCA8K_LEDS_H
> +
> +/* Leds Support function */
> +#ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> +int qca8k_setup_led_ctrl(struct qca8k_priv *priv);
> +#else
> +static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#endif /* __QCA8K_LEDS_H */
> -- 
> 2.39.2
> 
