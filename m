Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FDB6B9E21
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCNSUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCNSTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:19:54 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A443F4EEB;
        Tue, 14 Mar 2023 11:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678817985; x=1710353985;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9Avm6P7YjrGgwLg4cck53kNK9bGWLOqXbLvCtxYdzJo=;
  b=Hmkt3AhBWY6LsWgnq+VJi9p/fLemh9BrBA0oaxruKytU42xnnZQOkn/a
   zQZ3bhnyY6nZcsoc6Sy7CvTHyZwQS5CoRW3NOwpCkMb1xpg6ihYuoXdOj
   8NyCt+6IvM3nSf9BKoUIQGcU4IXRApQOxMRTHow18bl66L7oSPCpD+TMI
   ngHxCRDzSKCjB5G25mRXcqzagPgzdTArPdi8nku1Q6xO2gl65mVyDuKfM
   G12L5UqmmO+wKQO6OkBX4eXIkYPMkU+pAxYaA4zbcx3kc8hC8ViDTiZIn
   t/VE69oilbCh0EcyAeUZNeB+xANTvu/RC2OIwlW3V+4we85+bIKGCJpRS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365178532"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="365178532"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768206602"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="768206602"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2023 11:19:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 11:19:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 11:19:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 11:19:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8Zqm7JaiQ51+Ic0LauMnFZZbRfsvKuiLNDE7k9i/yV99SsQRt0urg7YokcbI8VM+vcMIwQ/+8MpfQE/sDEUD1gbmxl+bVbniXikoJw4dIZ2eEPODFqKASmjvIURHCj7CBdIeAP+KPn7QF4KXNaQHrrpyvMXoA6iI6BAPVK8qCaPaFF+yc5uYeyPaL5lXWt8I6gxrmuStCijdm+NXjcplwc5/NVTXufs2ju+2gMqmoO/TFtoyq67DT7xZ/cfJVmxN6Sf3Z/GC56hzaUrj/CzhTojZLEZdjPJqB05klsP2GhU7chn1OjxruXh5Pnai1Gc4BIwiDhQKYA62x5i8KtmRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdXvdRuDkUjnrlfUH8PLoMuJ24y8+E/r33aDO5ZerXo=;
 b=DIY8ZPwua2VFVMuGnXZ620sJ8rk1nOvAyfd1iPKN0+D5Y/jeWwGjs3cxAwpceGDpVVgu0+9Aq233J75DQDDOxm15LkFHwpZjc2MlJsKWiikw8EOBRSDEJCOYybqW2hGAUiVwrMxAb2xrFKxKIRe7J85ocDFEURs+Rr4m1+cGBrj6s2qcjCRe1B2HTi2CNEv2maz129z2jndBeGxp2fXHJ3HefrQrG5vA2p9jB9Kxxg06/AGLcBrYNuY13LtWwWeyEHQOMGiKtr6dTW0OYGCu5RV2KIMlekLWfqEPAN1hj8elmdLrx6TpTp4E6SytabQjICXvgoW+GnOVPK+6w/zWSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DM6PR11MB4593.namprd11.prod.outlook.com (2603:10b6:5:2a3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 18:19:16 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:19:16 +0000
Date:   Tue, 14 Mar 2023 19:19:01 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] can: tcan4x5x: Add support for tcan4552/4553
Message-ID: <ZBC6lV44CIYsJA88@localhost.localdomain>
References: <20230314151201.2317134-1-msp@baylibre.com>
 <20230314151201.2317134-6-msp@baylibre.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314151201.2317134-6-msp@baylibre.com>
X-ClientProxiedBy: DB6PR0201CA0018.eurprd02.prod.outlook.com
 (2603:10a6:4:3f::28) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DM6PR11MB4593:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb236d6-1c44-4f0f-3693-08db24b89ec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUQGL0CeL+t4U2J76gvjo82E4Fue23s0O3OPNO5C3X0ZUOLAxnZ9zyEBWRLCvktkrQDyuDexj9+L+tZmZKA7AaRJVkgi+ORF8g6JYdUBIuWKL0fLiVqrIEB/M59lWGKMMT1x+mFOPx9rjz41tUNN85NAt+0C7ZNE713d2uZE9SZZrBDwU5oncXbVMGmS815z6XbDGJrvQGfK/HLeGbYN4nxvnXvxso/4dO/TGFO+qWaWuoxolkklH0lj1LEZTL8J4o22BZFd6VX4Spnc5l1TKG9LcpUGcAlxlGVPiUf6E1jabR2oO/F1nHx8HmN+OucvpRjOh9lnzlbYGFYggi/3qyK1Xy3hSoI4h3MbnZS9tk6zf7A7GpxCnnU7ofXgn+gPjXPAKwsp0S1noATeK4byx15e0wDYpwjtiB+ntvtZ2pB6QfCySZeOEVuz1xw6hk8TP6xIqxrNqmolcYbHq+ApejUizFynCqQHsVM5hl5RZX0Qu2xVa4Z8RAeTkWm9y6GSagIwBgT8UUi0b7v1yB0OCxn3ZT4GluWC/uE3BSmg+HHglSxx5dn3EyxwZorO8cxOyI7US0IVvmNHlA+rimD1rEBFVKlfl3Fhmmh3vRh9jHSGmdzFzBJ677uvjxNq1gMpiuFKBilIJ8MOYJ6oESIweQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199018)(6666004)(54906003)(316002)(38100700002)(82960400001)(478600001)(83380400001)(26005)(6512007)(9686003)(6506007)(186003)(6486002)(7416002)(5660300002)(41300700001)(86362001)(6916009)(66476007)(2906002)(44832011)(8936002)(4326008)(66946007)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Cbdfod5tty/qeQFwebIXPg8Jc5psWvoYyyHr5zkFdImiKDaelWJNlb6njaY?=
 =?us-ascii?Q?w7MpqgXQ8K4ucoLTrR0UK8HzQ4poHadS+R6AGXeR6JY8Kv+/zQJ6i2h7+yN0?=
 =?us-ascii?Q?iqxVMN2p0Pxih8tcBy+VeAKHVEsbF4gPp440lRh/gIw+FPKyy8AGL4heQcMv?=
 =?us-ascii?Q?7D10qkdG1JpSGKW0hFB3bvpX96Y7cq+dWhkCtX3SUnSBVvoSdterhJg5MQ5B?=
 =?us-ascii?Q?l6gzXhb8x9MU+VGtyCpnzK+672XXPEJ19Fznb5b4JNTNUNpebPo1o5PlXamd?=
 =?us-ascii?Q?xFE4H5pkKr4ET03bxoHYEOhm4wrW66EfDYsQ/razfJjEUMYZ724YTaLXEAwR?=
 =?us-ascii?Q?5VtWGP1StBqQ6KgHYvIUj5Zao0uhca+OGxnMQPCp5tzrt1uM1Mz2bZcc0Vk8?=
 =?us-ascii?Q?rvGK2pVesvFbEYF1zGZNRDu7T8DGlBY9AC6eqi7/XZ5z3/QezkdTNq+N7CCG?=
 =?us-ascii?Q?XlKzXiix1/cPhU3TcK6owVB1Q+F49FFYekCXG2KpTcULPIoYW8enhzrBc6ZA?=
 =?us-ascii?Q?BMMNaygGZ7fOoya9vk6Z7X1gNpvF3ckF89cuZckNFymTJjqeCLpBfSExmkQj?=
 =?us-ascii?Q?PlFy67Xbmbm59SAYuI235eqyVmSLg622+IfSXyUXDmUTJNottnnRxG6E4fM5?=
 =?us-ascii?Q?xP2ZmAV2nZqgtUaFi2oE6RCFxSpjEaKblwQ3OoM1DXcEEfbid4TvGviCzLKi?=
 =?us-ascii?Q?+Pe72I6pvPQZ8Ajg4EVENjo1S0/qsvMoMvkDJXtoK3jTPNLjl/zA2oBADW2k?=
 =?us-ascii?Q?A0e6Yo09Zg9ZwkKis0SHEaFkAtYJMYHKFhMnOEYu+o05zkpTx+wiHUTldC0A?=
 =?us-ascii?Q?GnEh3ynD4o9v9BrS8Hg98MptAcl/o+5rE6Ed4D5B3QPFbFc+Z5hLHOyWtsx3?=
 =?us-ascii?Q?F66IqObmMubjDDIiIyun7r65DeeM8aMHItuDNvRM6s2xtoxnJDnXnsHS2eoy?=
 =?us-ascii?Q?Ymu5dSxZaWm8mb+UG7qBqn477G2cXuJUvWdRDtofjOnb8dD+KyPD4liQUqlO?=
 =?us-ascii?Q?ytaHPAUFvyIVnbeL2mPe3NF0p04RjQl2jnYOcV7+t+CgjgvUhCO8p7hv1uR1?=
 =?us-ascii?Q?hh3ga0N2owmQG4jA3s1kG2eSQTD73nJmyBldCEbMvG+8ElpxXFGSaWdNZ7Rj?=
 =?us-ascii?Q?InJOqK6aAukr0K79u7mGkhY8kgjBjkQTpPWG+DGTqYXs1n3c/5Majd1dF1gF?=
 =?us-ascii?Q?Cpu42frbhxMdhNBNMr4GEka0JzXNBO3CM/JcjGZIG4d2XnMIeUEi+2E2WrCc?=
 =?us-ascii?Q?REK00H9oQXtE9X/LwiOAzTZO3nE5V/E4OnXG5XSgB9Iv7FH5drJSJRbrj+nW?=
 =?us-ascii?Q?U2o2OSrBLTEEeTrTQx++jSipNjUOoT+b2Lf6CSL4jv2m7e2qhtOnt2lsvgg0?=
 =?us-ascii?Q?630RhT9IwDnoylGdw7TFKmZgVPm/Iwh9xPeRXehfYERdzwhBKkFeF/rvNHlr?=
 =?us-ascii?Q?txk3xRb/41VAKKTKCdU1LC5zbKxUgoidMNNulcgFZHoMLUZRmmIjFHyKvfV0?=
 =?us-ascii?Q?ePcCF8HOJKJgNwGvk+Q+9mOzs9XR8QJ3eNc7UjVCkrWomFmseHzjGugEqxlt?=
 =?us-ascii?Q?Bz7X6XT0A4v2eHtR13H3DdjL2YaSrku8KJWKxykWpgpzQ7HqvZkScZ3rOwos?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb236d6-1c44-4f0f-3693-08db24b89ec8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:19:16.2060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3HDMxbUb0TsNGqY4D8L90v4+0ep0AtoenmVI9Gt6FwbkrV9x8WswUvRwCTAV/7UKVfEB3n49mrL2TlF6b0jJVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:12:01PM +0100, Markus Schneider-Pargmann wrote:
> tcan4552 and tcan4553 do not have wake or state pins, so they are
> currently not compatible with the generic driver. The generic driver
> uses tcan4x5x_disable_state() and tcan4x5x_disable_wake() if the gpios
> are not defined. These functions use register bits that are not
> available in tcan4552/4553.
> 
> This patch adds support by introducing version information to reflect if
> the chip has wake and state pins. Also the version is now checked.
> 
> Signed-off-by: Markus Schneider-Pargmann
> ---
>  drivers/net/can/m_can/tcan4x5x-core.c | 113 ++++++++++++++++++++------
>  1 file changed, 89 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
> index fb9375fa20ec..e7fa509dacc9 100644
> --- a/drivers/net/can/m_can/tcan4x5x-core.c
> +++ b/drivers/net/can/m_can/tcan4x5x-core.c
> @@ -7,6 +7,7 @@
>  #define TCAN4X5X_EXT_CLK_DEF 40000000
>  
>  #define TCAN4X5X_DEV_ID1 0x00
> +#define TCAN4X5X_DEV_ID1_TCAN 0x4e414354 /* ASCII TCAN */
>  #define TCAN4X5X_DEV_ID2 0x04
>  #define TCAN4X5X_REV 0x08
>  #define TCAN4X5X_STATUS 0x0C
> @@ -103,6 +104,13 @@
>  #define TCAN4X5X_WD_3_S_TIMER BIT(29)
>  #define TCAN4X5X_WD_6_S_TIMER (BIT(28) | BIT(29))
>  
> +struct tcan4x5x_version_info {
> +	u32 id2_register;
> +
> +	bool has_wake_pin;
> +	bool has_state_pin;
> +};
> +
>  static inline struct tcan4x5x_priv *cdev_to_priv(struct m_can_classdev *cdev)
>  {
>  	return container_of(cdev, struct tcan4x5x_priv, cdev);
> @@ -254,18 +262,53 @@ static int tcan4x5x_disable_state(struct m_can_classdev *cdev)
>  				  TCAN4X5X_DISABLE_INH_MSK, 0x01);
>  }
>  
> -static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
> +static int tcan4x5x_verify_version(
> +		struct tcan4x5x_priv *priv,
> +		const struct tcan4x5x_version_info *version_info)
> +{
> +	u32 val;
> +	int ret;
> +
> +	ret = regmap_read(priv->regmap, TCAN4X5X_DEV_ID1, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val != TCAN4X5X_DEV_ID1_TCAN) {
> +		dev_err(&priv->spi->dev, "Not a tcan device %x\n", val);
> +		return -ENODEV;
> +	}
> +
> +	if (!version_info->id2_register)
> +		return 0;
> +
> +	ret = regmap_read(priv->regmap, TCAN4X5X_DEV_ID2, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (version_info->id2_register != val) {
> +		dev_err(&priv->spi->dev, "Not the specified TCAN device, id2: %x != %x\n",
> +			version_info->id2_register, val);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tcan4x5x_get_gpios(struct m_can_classdev *cdev,
> +			      const struct tcan4x5x_version_info *version_info)
>  {
>  	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
>  	int ret;
>  
> -	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
> -						    GPIOD_OUT_HIGH);
> -	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
> -		if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
> -			return -EPROBE_DEFER;
> +	if (version_info->has_wake_pin) {
> +		tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
> +							    GPIOD_OUT_HIGH);
> +		if (IS_ERR(tcan4x5x->device_wake_gpio)) {
> +			if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
> +				return -EPROBE_DEFER;
>  
> -		tcan4x5x_disable_wake(cdev);
> +			tcan4x5x_disable_wake(cdev);
> +		}
>  	}
>  
>  	tcan4x5x->reset_gpio = devm_gpiod_get_optional(cdev->dev, "reset",
> @@ -277,12 +320,14 @@ static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
>  	if (ret)
>  		return ret;
>  
> -	tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
> -							      "device-state",
> -							      GPIOD_IN);
> -	if (IS_ERR(tcan4x5x->device_state_gpio)) {
> -		tcan4x5x->device_state_gpio = NULL;
> -		tcan4x5x_disable_state(cdev);
> +	if (version_info->has_state_pin) {
> +		tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
> +								      "device-state",
> +								      GPIOD_IN);
> +		if (IS_ERR(tcan4x5x->device_state_gpio)) {
> +			tcan4x5x->device_state_gpio = NULL;
> +			tcan4x5x_disable_state(cdev);
> +		}
>  	}
>  
>  	return 0;
> @@ -301,8 +346,13 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
>  {
>  	struct tcan4x5x_priv *priv;
>  	struct m_can_classdev *mcan_class;
> +	const struct tcan4x5x_version_info *version_info;
>  	int freq, ret;

Nitpick: RCT.

>  
> +	version_info = of_device_get_match_data(&spi->dev);
> +	if (!version_info)
> +		version_info = (void *)spi_get_device_id(spi)->driver_data;
> +
>  	mcan_class = m_can_class_allocate_dev(&spi->dev,
>  					      sizeof(struct tcan4x5x_priv));
>  	if (!mcan_class)
> @@ -361,7 +411,11 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
>  	if (ret)
>  		goto out_m_can_class_free_dev;
>  
> -	ret = tcan4x5x_get_gpios(mcan_class);
> +	ret = tcan4x5x_verify_version(priv, version_info);
> +	if (ret)
> +		goto out_power;
> +
> +	ret = tcan4x5x_get_gpios(mcan_class, version_info);
>  	if (ret)
>  		goto out_power;
>  
> @@ -394,21 +448,32 @@ static void tcan4x5x_can_remove(struct spi_device *spi)
>  	m_can_class_free_dev(priv->cdev.net);
>  }
>  
> +static const struct tcan4x5x_version_info tcan4x5x_generic = {
> +	.has_state_pin = true,
> +	.has_wake_pin = true,
> +};
> +
> +static const struct tcan4x5x_version_info tcan4x5x_tcan4552 = {
> +	.id2_register = 0x32353534, /* ASCII = 4552 */
> +};
> +
> +static const struct tcan4x5x_version_info tcan4x5x_tcan4553 = {
> +	.id2_register = 0x33353534, /* ASCII = 4553 */
> +};
> +
>  static const struct of_device_id tcan4x5x_of_match[] = {
> -	{
> -		.compatible = "ti,tcan4x5x",
> -	}, {
> -		/* sentinel */
> -	},
> +	{ .compatible = "ti,tcan4x5x", .data = &tcan4x5x_generic },
> +	{ .compatible = "ti,tcan4552", .data = &tcan4x5x_tcan4552 },
> +	{ .compatible = "ti,tcan4553", .data = &tcan4x5x_tcan4553 },
> +	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, tcan4x5x_of_match);
>  
>  static const struct spi_device_id tcan4x5x_id_table[] = {
> -	{
> -		.name = "tcan4x5x",
> -	}, {
> -		/* sentinel */
> -	},
> +	{ .name = "tcan4x5x", .driver_data = (unsigned long) &tcan4x5x_generic, },
> +	{ .name = "tcan4552", .driver_data = (unsigned long) &tcan4x5x_tcan4552, },
> +	{ .name = "tcan4553", .driver_data = (unsigned long) &tcan4x5x_tcan4553, },
> +	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(spi, tcan4x5x_id_table);

Thanks,
Michal

>  
> -- 
> 2.39.2
> 
