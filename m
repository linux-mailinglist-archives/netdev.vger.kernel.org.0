Return-Path: <netdev+bounces-5563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B3F712268
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 050CF1C20FDC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8268E53B3;
	Fri, 26 May 2023 08:39:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7649E523D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:39:23 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2131.outbound.protection.outlook.com [40.107.237.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B632D9B;
	Fri, 26 May 2023 01:39:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU/fThrRz1Vkr4oe72xJgjuzkDfe8ZWX6vO8AncTe5lKdIKvZ9+6liO/5bSo9ecCDXfnrDXnJztraRZPPlHYNJyIlz99MVxUfPpT5VOYjBzd1HQpWOsYMgw+/2GTUHV2p9eu8g59jY4Et8cB2bsWcfGMkqIQwQWGaYSD9fpoquCchTa89xUUIzGNi/R2ZcbwWviG9by08p807FpKmV1E7Hcdp+tAUulkcHEQrL8h5JbVHBdqqQvcqaieEwqz+Z2700d+vn4LXnOZHzz+dKefneW2e6fCIe8kbmdX+qtFfA/YZMYQF2DhnHpEAM4mzioAHyDb0+KXB9vfVUitWfAxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yN27uWS7rRuhkEXJ4UAjJRkrCIE8o7VFGH7U103++Q=;
 b=lDEOSiIIgVKlfMU0s6wQYs+hB7Udy170/XysBxBCOme96YiLybS/XuPQTTtMABKq4zYlqtKgGG6QlBiaL1IreLNICgTXDT65hTxCPJQSmwD2n6GJL2UO8lzZ4F9JLJeoARpmD6JCbX1hVN+yZwSnVHU14YpcEzl4JN6U1IZGiORNSxEBQ3FIzeStNp+Kii1HXiKx2TRtY1a85qXruvlHohwlglKG7t/qylWjpq3VeinGSj7mbipBoWHKq2Zc1E0EdDwTOlB8WohcIlSwbMUpExvQue9mgwi3f1U3nqC6cZVzQGekpzkp4PCoscxxq9BsvzsPqh9FH6WcZ4Tg4lnPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yN27uWS7rRuhkEXJ4UAjJRkrCIE8o7VFGH7U103++Q=;
 b=haW9in/cY3vCBhkLVW+vEkVnCslatp5Zh3K59f09wQ+t2qMNkUzYQl+mU5aJh+omtFaaw3KE7eingk6wJ6FveR939aGXOQ5C61RbqVI0KXhzKpZNNYh7xDycYxeHHdkmkyj8ZrA5xczjV1prEVOqqndmhWsIaUW1MCkvlGShLRU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4947.namprd13.prod.outlook.com (2603:10b6:a03:357::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Fri, 26 May
 2023 08:39:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:39:17 +0000
Date: Fri, 26 May 2023 10:39:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v3 2/4] net: ethernet: altera-tse: Convert to
 mdio-regmap and use PCS Lynx
Message-ID: <ZHBwLBnKacQCG2/U@corigine.com>
References: <20230526074252.480200-1-maxime.chevallier@bootlin.com>
 <20230526074252.480200-3-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526074252.480200-3-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 60680147-f093-4909-0021-08db5dc4b11e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bbyipk+r8WP6IySGJsHnjrziybmHB3zcE5SILc8E48nnYesoKUyD4pkXRLA1RmFmlBW2y5IRwWEAvKNWzoBntwCaZTZAp5i4nLGX8Keu98raHRePZCF/m/zF4cI9vx9Df4Tfb/US1l15SHWweRW3Q5cb0aqFo7yFApOJ6zvMKvbRRAVjVGg+ZZjrF9vH0+5GRJ93L9w99Nv3eCMYG0bh3dQiumIWyB4vx5QhefWtnKI2iXICnlaqPXmquHyK3eJUGUU6u6bOYZywjPuUvSraA5RSWmcfmlLK50OBdLLFiqLFUuO7T52DZsW/oqwcwxhd2LpYiojVvi5Bh8LAfifOM9/kWN8YZL1KUlfFcj8CT1dEILgsrBQrszrguodCDV3lSFYpgiRVcFWGJSMOB/xn/Y2TLAYXRIb+B7+CYHDyRFkJj2YkzEnVsz75VTJ75R2NCzbcnbiy2So6RMiRm9i6lD5mq1T1/4mbXjJ9hP8BqSBUhHnJVitdpA+6JtYBk4w1/2hqBz8EgsXIkPDGsyM4DJxWlETZUsRcVCsCt1vbusLVFVPzew16WMJ4EbA+UHRuVZanFPq0DKEuU18+zckB9kWFlr48v2v/OBXZ+7zMdzU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(396003)(346002)(451199021)(86362001)(41300700001)(6486002)(478600001)(316002)(6916009)(54906003)(66476007)(66946007)(6666004)(4326008)(66556008)(5660300002)(8936002)(8676002)(6512007)(38100700002)(44832011)(7416002)(83380400001)(2906002)(2616005)(186003)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QcjLbQfsQMgRobZf593uTCAoF0ijpBXf14lFN2ms5lc+IM2X+KBqWYTSFDa1?=
 =?us-ascii?Q?mFO32ymItdfekZLQnxY8BAmfqgD+Twfk8uRPrYFGFjoWjvcdV7/e4e9lbXDw?=
 =?us-ascii?Q?JvYcx1ZltSuGPj+xK1jvdlp1U1cmoEe99O+mwkgSZITXjkrBqHlu8P3OJevq?=
 =?us-ascii?Q?2S1KMM6KKH6AgW7kZEFAh7Cd9a68V/rgeqI31Ze4COxc9+zIhAP89L/krcwP?=
 =?us-ascii?Q?OD8OR4iKu4KK6QscFOtxm7mIdZwq2c/CkM27tD5tSf+WjmQI9FzsqrdjR8gS?=
 =?us-ascii?Q?QbMHbyDTyZPvUqsvbt3DMaT8/ksjQZU/7X89pTtAUi8G6U9S9nTJrxigjrmw?=
 =?us-ascii?Q?9hEAkqbC7LDKwqbH7UHlEEfaQybtTWeukQyfSVdwXcqGXvV0MhUcvofkMlWG?=
 =?us-ascii?Q?aQjmWNgc7H27biqsKloqeT4IJ6ef1MZjecBP4hzWohbbLf8EW8zFONMqfCHV?=
 =?us-ascii?Q?H/wZhJ+Mtzzm/QvMHaZSKXPbwai26cK6w/19I8+iSSKPa45QnnWQV2hPfafi?=
 =?us-ascii?Q?QGzge4J1sBI+4+wXgtGiO1rJhIzIQsUhR7ptYPBaJLxoHS4PND1skQFdhWLo?=
 =?us-ascii?Q?EVT4K2r+IhrT+HmcQkGi9BWA4d8R6VHoN7fTjnhBycTRXrNI/r0e9fC4VdXT?=
 =?us-ascii?Q?+fGdV6VLFLI/Toi0Dp4EHN+CtxQ3wLYq2JhoMjn0L9t0p2XXEfLVjQtuI3Sg?=
 =?us-ascii?Q?fuoKC06cF4xLH0GDEl15ASvq2ILgJXlvMGpbkM1anOPmm+M2c0L0CVYTG8WS?=
 =?us-ascii?Q?cYlzBHNnVVB+qcoHa2shlSTHSpS7nPEAmygcgsbSeG7AMWqSczPBnS4onuZ5?=
 =?us-ascii?Q?6BQNskHcVsSOEK3vl9ewrqqAQi6bSdl7RjuBUSVVnKlXTZpGYsLIPTwBEnpl?=
 =?us-ascii?Q?bI9R1b9K2ykcIhYkpd4o/nZJoPpnd619r6xTbwqP/EREGXSkHoW23weEv0+s?=
 =?us-ascii?Q?e5Nc9EJJhMPTO7wrBdtmv8aKz2mKKxmnk8Uj9OD6ABnEgp8QudLFYjCd4FbA?=
 =?us-ascii?Q?i0grRSEfUMGhQtRFbJJ4VVmcdw0AEjaDSXOrB00oMWvlcmhXwZ1BnbPg8nGx?=
 =?us-ascii?Q?TOavF4exPBHHiAuoEPIMQPbXcFLqkUFdRJ6usvWdOyN+U5uddZS6S19c3K7y?=
 =?us-ascii?Q?kD6yUH+e74V7YX2JxhFWS8e+L5hkJRuzEWo5vEX/9kfeh9o48O03CK9dzbA/?=
 =?us-ascii?Q?qqzeyUNqH2CLht+d55u2XAOl/KqPi1ZhZ/qUnUtGuUqua+SaXy+vmKqXMCPy?=
 =?us-ascii?Q?riXPs6tXjyZwx6ToCHmFmmKijINq8gxcg4Fx9wXtbppTAkBjbxWuIvpO3/Vb?=
 =?us-ascii?Q?a8n9GGH9wJ1mO0/sQf0ftAaLaNlzGoBPE+nk3PdrXdE6Ksu5OxmZNocx6TJ3?=
 =?us-ascii?Q?2Kfa792e6b6CP1E3fI+Q3FmUGfoJzHXCk3Lxw9aQzYsGVO4BtZhkK5L5vniY?=
 =?us-ascii?Q?rC2cm0O6nv67NvRNTmrs/4fydO4UNd1hIjyBEMcCupvHrQIpO6jeRKyQhw7o?=
 =?us-ascii?Q?Kui3xo1WtRnkSrC0A9LXKSqW2ScafpvzSmvOTGafuQ4I3h4JMDHzGjhhwzce?=
 =?us-ascii?Q?Kf6a3UG1bQ7eo1qGMVzq+vlwpVNoeVqWp6puu9lChshEPkQaBn6wjgP4G8wk?=
 =?us-ascii?Q?QagAe98myGY9CWEs4Mj0jT8HjUKwobsAwyJ2Ei3rILScs+qeHCpEsPhw3RrN?=
 =?us-ascii?Q?tYWejA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60680147-f093-4909-0021-08db5dc4b11e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:39:17.0726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tn3mOaq2/5xnmqIsHhAzVKG9DM+xYE6Lm8kUF2egyF6+IkOCstKkhZytu+XasnwfZOc7espnwtikul900ttds+oU41yB8bqMmmbHo4HrQo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4947
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:42:50AM +0200, Maxime Chevallier wrote:
> The newly introduced regmap-based MDIO driver allows for an easy mapping
> of an mdiodevice onto the memory-mapped TSE PCS, which is actually a
> Lynx PCS.
> 
> Convert Altera TSE to use this PCS instead of the pcs-altera-tse, which
> is nothing more than a memory-mapped Lynx PCS.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Hi Maxime,

I have some concerns about the error paths in this patch.

...

> @@ -1134,13 +1136,21 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	const struct of_device_id *of_id = NULL;
>  	struct altera_tse_private *priv;
>  	struct resource *control_port;
> +	struct regmap *pcs_regmap;
>  	struct resource *dma_res;
>  	struct resource *pcs_res;
> +	struct mii_bus *pcs_bus;
>  	struct net_device *ndev;
>  	void __iomem *descmap;
> -	int pcs_reg_width = 2;
>  	int ret = -ENODEV;
>  
> +	struct regmap_config pcs_regmap_cfg;

nit: this probably belongs in with the bunch of declarations above it.

> +
> +	struct mdio_regmap_config mrc = {
> +		.parent = &pdev->dev,
> +		.valid_addr = 0x0,
> +	};

nit: maybe this too.

> +
>  	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
>  	if (!ndev) {
>  		dev_err(&pdev->dev, "Could not allocate network device\n");
> @@ -1258,10 +1268,29 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	ret = request_and_map(pdev, "pcs", &pcs_res,
>  			      &priv->pcs_base);
>  	if (ret) {
> +		/* If we can't find a dedicated resource for the PCS, fallback
> +		 * to the internal PCS, that has a different address stride
> +		 */
>  		priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
> -		pcs_reg_width = 4;
> +		pcs_regmap_cfg.reg_bits = 32;
> +		/* Values are MDIO-like values, on 16 bits */
> +		pcs_regmap_cfg.val_bits = 16;
> +		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(2);
> +	} else {
> +		pcs_regmap_cfg.reg_bits = 16;
> +		pcs_regmap_cfg.val_bits = 16;
> +		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
>  	}
>  
> +	/* Create a regmap for the PCS so that it can be used by the PCS driver */
> +	pcs_regmap = devm_regmap_init_mmio(&pdev->dev, priv->pcs_base,
> +					   &pcs_regmap_cfg);
> +	if (IS_ERR(pcs_regmap)) {
> +		ret = PTR_ERR(pcs_regmap);
> +		goto err_free_netdev;
> +	}
> +	mrc.regmap = pcs_regmap;
> +
>  	/* Rx IRQ */
>  	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
>  	if (priv->rx_irq == -ENXIO) {
> @@ -1384,7 +1413,20 @@ static int altera_tse_probe(struct platform_device *pdev)
>  			 (unsigned long) control_port->start, priv->rx_irq,
>  			 priv->tx_irq);
>  
> -	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
> +	snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
> +	pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
> +	if (IS_ERR(pcs_bus)) {
> +		ret = PTR_ERR(pcs_bus);
> +		goto err_init_phy;
> +	}
> +
> +	priv->pcs_mdiodev = mdio_device_create(pcs_bus, 0);

mdio_device_create() can fail. Should that be handled here?

> +
> +	priv->pcs = lynx_pcs_create(priv->pcs_mdiodev);
> +	if (!priv->pcs) {
> +		ret = -ENODEV;
> +		goto err_init_phy;

Does this leak priv->pcs_mdiodev?

> +	}
>  
>  	priv->phylink_config.dev = &ndev->dev;
>  	priv->phylink_config.type = PHYLINK_NETDEV;
> @@ -1407,11 +1449,12 @@ static int altera_tse_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv->phylink)) {
>  		dev_err(&pdev->dev, "failed to create phylink\n");
>  		ret = PTR_ERR(priv->phylink);
> -		goto err_init_phy;
> +		goto err_pcs;

Does this leak priv->pcs ?

>  	}
>  
>  	return 0;
> -
> +err_pcs:
> +	mdio_device_free(priv->pcs_mdiodev);
>  err_init_phy:
>  	unregister_netdev(ndev);
>  err_register_netdev:
> @@ -1433,6 +1476,8 @@ static int altera_tse_remove(struct platform_device *pdev)
>  	altera_tse_mdio_destroy(ndev);
>  	unregister_netdev(ndev);
>  	phylink_destroy(priv->phylink);
> +	mdio_device_free(priv->pcs_mdiodev);
> +
>  	free_netdev(ndev);
>  
>  	return 0;
> diff --git a/include/linux/mdio/mdio-regmap.h b/include/linux/mdio/mdio-regmap.h
> index b8508f152552..679d9069846b 100644
> --- a/include/linux/mdio/mdio-regmap.h
> +++ b/include/linux/mdio/mdio-regmap.h
> @@ -7,6 +7,8 @@
>  #ifndef MDIO_REGMAP_H
>  #define MDIO_REGMAP_H
>  
> +#include <linux/phy.h>
> +
>  struct device;
>  struct regmap;
>  

This hunk doesn't seem strictly related to the patch.
Perhaps the include belongs elsewhere.
Or the hunk belongs in another patch.

