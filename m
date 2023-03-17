Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6946BF08A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCQSQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCQSQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:16:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CC4301B1;
        Fri, 17 Mar 2023 11:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679077014; x=1710613014;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2O4ZAFDo85Zl1Bnlj3p0yLhUeLAVVqRsvmjUndUjBYY=;
  b=QZQWzzxsHkLhng4lVAjnKP0MzRFm9bY7yRzJCjLp3EhKKGtJgPEzcdvB
   KwhepKNFEgpkzZ8IhE0texGb+Y9kragA/rIKu9QIpxJNuxUhTFv9vMO7z
   Tjrxwh1Xu2tu5Lx3rw3bNoVBpNIX6+/zGzrZHJngD8zhf41/c63X/uapR
   p+aYx5QYUHGxfN+cgU/S/Fn1d8zCUo5/caD4v+ixQtH6tHqAwHoNhdUUP
   tUVcSYosPz83GKwzJsDVZ7l2tXJ1s1AwCgk3IGbNVr7Fim2NSY3Z5waeG
   Z8tZy/NynDFhhAxYU5OYqjoOZtohwc1Jbno5Hsis4G3na//rKJ3QHd6VG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="424602362"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="424602362"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:16:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="744636674"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="744636674"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 17 Mar 2023 11:16:54 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:16:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:16:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:16:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hP1vt7rqBQfkDYU90QSNWjj+7ey736QEaeCTnNqCxIFER6nv5wfx7voyTQLDHjzBbnej/pm9mxsosrRn1zywSF+BQ1OY3bGFcYroIwTgFIGd991yM1xFIkEafzCShgV0pDXcPW/Wm5LFRtgF0T10/CDD7cj6u8fy9ReGY2mnTQHJl8VmbtivKUpv/QfjZAbzB3+tgEDEhb2WTg4/si9uNS3mLs74JE2Axs9Jo0ckAhB8pCcDRKm8JmRvtbaOF5MifcZaAq0qOZh1zgYwuLaMHMLWhRbPlrRBtyZDYauH6AACY7TFdsIULRDCFdz+zgGFK08wPND2Ls0ppvQrYVmNsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcSTg/b1hri1EGlafkhXvlktHOSGK4Kc274ZN+j2DUQ=;
 b=P6qadketRdnPQkdoprWrl/pUu83OyHdBP2Hd/fEVqBosMBf7te2kTQP2igzqoP9otDL761P1RhOhQewc+Hjrpa4BwaoaPku1AbfxIGWvxNr3Fn9vM3LCYmDjLkoCyagIfMo/ZYVkC2ALwtuhTV2nhqziiQglIdcG6/efNHsc69xdgcaprLG97hR68TDWWMQ7YwQ8yFgOu6SFeHSUSMXFzOU1rwP7BKl2TjHfKDfmNdiIChzw3x1e/HSbO1oj2l7WV+03BkCXq94/FtuKPSEv0VXc/nvDMU3r9ljYyScE9SPJRSINY4PkodS22ZYSpCVWqO70MdaGKt+MHO09UMVIHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH0PR11MB5610.namprd11.prod.outlook.com (2603:10b6:510:e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:16:51 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 18:16:51 +0000
Date:   Fri, 17 Mar 2023 19:16:50 +0100
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
Subject: Re: [PATCHv1 2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy
 regulator handling
Message-ID: <ZBSukvE/EEH5UsTQ@nimitz>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
 <20230317174243.61500-3-sebastian.reichel@collabora.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230317174243.61500-3-sebastian.reichel@collabora.com>
X-ClientProxiedBy: FR3P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::8) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH0PR11MB5610:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e9d2ab-78e3-4a0c-95ec-08db2713c7d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IT2vJdO5zVDscZP66DSb8tXXwAMLkDswlPCmCbCvv0x2riUHf94d8+RR0oJOnAq4dnpSXbV85z9yHhVnZJTC8TeS6JTUJBb21gBMvgyZzwxHqYlnJgVHFbOsHjncS+seKdzXGwLbZ4L9k190tGy0peAvZQnZ1ASCEBXVhKaYJqvGd5vbr3wVtNvMvzKSjbMQh/NdTxfsKVBylhZ0K3n0gETs9Km+cfEDiUQ0/VB5I27CPsHY76NI08nCFRg6VIDnkHCdF8i+NyXOoFvrXd4hGDxGW3pPKhiZjDmRsTgQBBS4S68N6S/N8vWUMvgI8sLrEx6JweE9yVDp7b1exub+T8UtaxIy7T36ju5JaXXsgUCSYEklNXHIC0OtfjtjYdLtMli3/1E1AhSQn7kk0nrBNdsG6lOwrsM4pKQ1gAsSkoVWNSRDo+AhYIOIT2dWbqgpIumVQtzonlfvCnCGkwCJfwle5Zrd00844wDCoNHcoe3cOODjmWJ0HcxErl9U2xqMLcoWl8dzNODz7MArUPZm85y2iCidraWvWYIXongz2oPG339y0k2GyFpM3+sv4XKyCrABFh5HDeHAZfJMWh73VVkFBZCiLhu0jwvirtngbNQV1AaAMuY+TM26I1r3o8RCK+uS3QVHrhWHoWfYKCrqDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(6512007)(66476007)(186003)(9686003)(26005)(6506007)(33716001)(83380400001)(86362001)(82960400001)(38100700002)(6916009)(4326008)(66946007)(66556008)(316002)(54906003)(44832011)(8936002)(5660300002)(7416002)(2906002)(41300700001)(6486002)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3X9hmYf32uDf6oUO93fXODkNhZxdypsUKdOYIyPL9ZN6X/pjjxUPcozvl0rG?=
 =?us-ascii?Q?xpnCzn94L06KDWdgIEeK3bgRyifz7z248X8bBzd3FZPxuuvgER0P67riWMiP?=
 =?us-ascii?Q?bsJha9u+QBwlJSarW8lJlx1JcdmMGEWRNXasAIXP4RfwdIhOA1a6GlLgQa2e?=
 =?us-ascii?Q?/PA90A2RMgC//adCIsiR9pThKUvbM9bNK6ESV6DFlJ+UZvovjOEgTC53Ox7e?=
 =?us-ascii?Q?ya56TXC/L4XkwqvtyG9uEvk6yCA7XXqf/btxb+GNMUUKCUbXb5xuLhci3yD/?=
 =?us-ascii?Q?5c/74EiVdmzI5mcexFydFHV6E6FoaoIiXX5nH1pFdLeBN0n7leu9BGw1TKir?=
 =?us-ascii?Q?9l37ipovSDk6HhNBGqwg7PgRUNuNHrYN2c1kFoA3xjKMrQZ9YXJpX2+EPVyy?=
 =?us-ascii?Q?PrEns+oPnMTzuZ3udb653lTdWdLyIH/G0kJ9vuVbQHk+Ent3tEDAKJMpAPDT?=
 =?us-ascii?Q?QoWS/qHpHBCCgTpQKKjzUx4V8pE9ytGjpE0QI7I9G/dvbwlhkgPJOYkvlPni?=
 =?us-ascii?Q?cjx9TZerT1WYc5CJtAXYyRrygdBXkacKPjPDOvoOAmuBbRqnTXWAjI6UYTva?=
 =?us-ascii?Q?UB7LGTVrikRDMxkBlqJxQ4QWOmdbWveChO9EHjKoX7umJlA8f84otujSnNPv?=
 =?us-ascii?Q?5kBj/vLlPpSFFA++g+3eq6BCDEBRhaN2XX96VovMBAhENmaZj34GbVAEEnbt?=
 =?us-ascii?Q?E3bigYCabpvTPBSrq6K5WczGsD8oUM4DvpwhCElbqOVoanrC/rRoOpOw5GNE?=
 =?us-ascii?Q?pH+wzCtSCT5L8iO187fjWnHqrpfa57dhu3524zYG28BpzwZHJoA32MV1kkDf?=
 =?us-ascii?Q?c7cCk7++luk+B00UAe8j8BNhnStqcMnDhWG5ibN8eLWsZ/1PgAzCoLItbzwJ?=
 =?us-ascii?Q?nzcRYuRifW/U2jRazQTIYPyYWIClm/uVkDH4p7tSb55i2D6+fZPqjaekIa/3?=
 =?us-ascii?Q?JVy8QdGtgUY/IuvOHn9hK3pTbya98guCX5++jmnMJNN5U6Ysp7Lndq64HZ4T?=
 =?us-ascii?Q?o3uh18GBlSVi/u9ZosQd8okPMJLWk+1eQPMMuSrDBF5ciSrt+GeBbEfAeVQk?=
 =?us-ascii?Q?vqG+tBhvLEHsXeh3ObDsTeo4/SNhXcbptL4T45Db4VhTbSna9UmhLL7V9R6N?=
 =?us-ascii?Q?iZZ8JCIl5FTyWLyVLYT5DU2sD8XHEswQowQ6DJIri2NXSn/rc6+WNkALN2Mk?=
 =?us-ascii?Q?424FTr2KLnyZNizWkhBVPS6zQgzonkrnAWjP3ic87apZ85ijFqOKFwDcbTda?=
 =?us-ascii?Q?kEYBXcBk2IJ5DlHjMFNkmn3tALtnZukBA//zpyNmWJgd7APkEg9rs4pEoTel?=
 =?us-ascii?Q?AoKMXgR9ATBGXSjctiIMwDMqcos8q3A/G0TBqdEhw4Uu6tQpaRpd+ZwMZ60g?=
 =?us-ascii?Q?bfVf3hdAX32s5kae8zUWSMpM0unNdPYKIl90kw4Xo2PNGD3xjrX/LU3f2kK8?=
 =?us-ascii?Q?acuS2VSmHqgU2gmr0YlVX0IPTJc/FPdwggqrdJ0VaqHPAdwlF3ZOwpKT+nyF?=
 =?us-ascii?Q?pCkBPRYA76dZTjrVMH+hisTxc+tCOpJZ2pggJh6C1PkSLmAjZLux1bDhnRhA?=
 =?us-ascii?Q?G3fZqW1xCDRYF/gXaTABfVjDg0EL1k4mtbC36wPxkran1/DctQ5FdgbjDwt5?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e9d2ab-78e3-4a0c-95ec-08db2713c7d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:16:51.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WorUN+VjQNXeyEvI2ujnVyDCZYjhZjBV+TbP0zbJ5C/RXdCaHx5wXgDorkeY0YGrN6uv83J/0Bxs0HCMLIFJN2fCoEiSKckDIewxOtx2m9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5610
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

On Fri, Mar 17, 2023 at 06:42:43PM +0100, Sebastian Reichel wrote:
> The usual devm_regulator_get() call already handles "optional"
> regulators by returning a valid dummy and printing a warning
> that the dummy regulator should be described properly. This
> code open coded the same behaviour, but masked any errors that
> are not -EPROBE_DEFER and is quite noisy.
> 
> This change effectively unmasks and propagates regulators errors
> not involving -ENODEV, downgrades the error print to warning level
> if no regulator is specified and captures the probe defer message
> for /sys/kernel/debug/devices_deferred.

Code looks fine, however this seems like a fix, then Fixes tag would
be nice. Also target tree (net?) should be specified.

> 
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> index 126812cd17e6..01de0174fa18 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> @@ -1680,14 +1680,11 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
>  		}
>  	}
>  
> -	bsp_priv->regulator = devm_regulator_get_optional(dev, "phy");
> +	bsp_priv->regulator = devm_regulator_get(dev, "phy");
>  	if (IS_ERR(bsp_priv->regulator)) {
> -		if (PTR_ERR(bsp_priv->regulator) == -EPROBE_DEFER) {
> -			dev_err(dev, "phy regulator is not available yet, deferred probing\n");
> -			return ERR_PTR(-EPROBE_DEFER);
> -		}
> -		dev_err(dev, "no regulator found\n");
> -		bsp_priv->regulator = NULL;
> +		ret = PTR_ERR(bsp_priv->regulator);
> +		dev_err_probe(dev, ret, "failed to get phy regulator\n");
> +		return ERR_PTR(ret);
>  	}
>  
>  	ret = of_property_read_string(dev->of_node, "clock_in_out", &strings);
> -- 
> 2.39.2
> 
