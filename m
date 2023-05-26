Return-Path: <netdev+bounces-5624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4AF71247C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1867628176E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F528156DF;
	Fri, 26 May 2023 10:21:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4E7156CF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:21:48 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2077.outbound.protection.outlook.com [40.107.8.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE44DF;
	Fri, 26 May 2023 03:21:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6/lZyqBCnmyGFsK4gDmSGRFXTs8KUctgs5nExQ52JLqZoqbcDIRPvF28vZ03UYRBdwglofGrzrZDFT8PxRnjKopWX822o1NBGYNeLCAM7c4fd1qMTUrj42qP5yMHADwWVc39gnWoVjR/Aw9ByPVr8O+3cuDbEOA/Nlzl9PNcnb8pDXXMbwPzCo/wFvt2inlj6dDqzUUA49QcvHgsN7QXqv/4zsBKdfFkCGPlSAu4qnCJl6MIIRRY0RleFFxaKBsAypMsrzBYpuh3qMLFRPIgzbBsrz8lQmz8EevgxcbcmYR0VyWGQDyeKP83q3lwbHK9UQ/7URXcSVAQ/p8oMbp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7kqjNsBM0VfTKQp9HIVSLKhluQsCOohqbPP0+UmHdo=;
 b=h1vUH0LGf9iGWgSuoFWZTL0AxmmhhaV0lxsOck6Ofp5negEzclh5498E/92P2YCZT541Ka9J1aTOCDactvDg6B9n4Vl5EPJpBtc5RRh3K4jbTo342mRu4XTRTdmcWLGNJDLaJfmH2gmLVdBzgFe9gxQ+C4xCf5OrOPO3JJjnji4/4MrTiw/2/WcnQ0TJ1Y6yeU9Rot7O3SPaPEThGYomoIZXIErumVgjJ/f3eOiGCGEz33sHsoVVeF36tfl8n67dwvR87YZXKo60hZ372J+LnQaLvxZTpH3NcDjcJPyXR11oe6COzj5xHQjIaIaaz+CNUG2vEQtNed8FOeM/SWAMoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7kqjNsBM0VfTKQp9HIVSLKhluQsCOohqbPP0+UmHdo=;
 b=AWE6NX5PQz289axhIAr4PXM2ZHqopmRiqLJsK8wwCMzLBUlAczD4MLLb1s3dJMbQOc/p2IXdQE9r53R4WoKoDVolnik0eIArmHvmjM2JQ7Yd5oANBIPIM4gt1WeNwtd1YuVoFo9JM4amWgYaathoRr5ZHpCAk4Dii/lb49Em0eA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8295.eurprd04.prod.outlook.com (2603:10a6:20b:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 10:21:43 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.018; Fri, 26 May 2023
 10:21:43 +0000
Date: Fri, 26 May 2023 13:21:39 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 1/4] net: mdio: Introduce a regmap-based mdio
 driver
Message-ID: <20230526102139.dwttilkquihvp7bs@skbuf>
References: <20230526074252.480200-1-maxime.chevallier@bootlin.com>
 <20230526074252.480200-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526074252.480200-2-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: FR0P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8295:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e1f6f3-51f5-4d9d-9d3d-08db5dd300cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BWgrwKKbF1sr1BJl3jhjjBSmzmgZTNnxLttuenfBXQ6+6gdC6BR6Wszv1J8ONJyaa64n4PV/3OGFyMp4X1OCeT99QtQN7icyPA+tv2RYjL7e/SjoUcUbq/gHAAUbf40w5AE+IyaaiRKaApny/4bQ14vUvNPECXmyF6NlaLpo2odyZQ/sK+iYlKab1Ly/BzsxG3EI+4A371R42LJaaKkpinARKJRkPDQfIbOADrXioNbNbc+LYXDrAFu5thYVpGVaoBoEhtrmQtrIL26ODfOnUIeIoRhmstdi6EFqg8kLLObO9slyHV0Inr5hYMG7gG+rTohT8hoD/PPlTS4VeEe0NIWlj4i1VaFcEHu93XJRoR2FYQ6zJ3PO0/WWt2nXyEGaN0Ki1TXXWOPi+ofMQ5ll7b/47lekG9ctI+mWeyzotOWD6cojhY1fpHzNINQmEZvfzSkZAhgzR7aFZW4fhzyATBQyKp6Z4BsHhO6Bu09+C5ZQXvH7fTxZhs8bY99IpFe27In03vXCrBLPCLmWx2xrLeQJGkh/Oj9i8wnErwSa0rizEhhjSsaWSaQpPlTEFooR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(44832011)(66476007)(66946007)(6916009)(66556008)(5660300002)(4326008)(8936002)(8676002)(7416002)(316002)(41300700001)(54906003)(2906002)(478600001)(6486002)(6666004)(9686003)(83380400001)(6512007)(1076003)(186003)(33716001)(26005)(38100700002)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SrZSSmDN/qWu1FINZk49BUPRU79WnN4cg7M6zaayPGdjYsCn6+UKYzcYy/Rl?=
 =?us-ascii?Q?nG4oUePOj/4AXpPAroaY+RPyhsl9dtCyn3j8TkhI+KcCaJkr6rMNbJEzcZDO?=
 =?us-ascii?Q?7HswDcAyCFuaeBqqdU2tnSITyHk9qpXmMkSPAqvOO8nKTRoXbZgvLatZY3Qu?=
 =?us-ascii?Q?x9rM7qiqTcKDa0JskC9jdIOL5jJZPTKzFhbXoUfdRne0osIAq/sbH4+RXq+C?=
 =?us-ascii?Q?zaoqQ1eeVSk+cQWwb85ITCaJOPpZKgGGrQ4jqSTRmv+UtM7q/BWSk3UePJDW?=
 =?us-ascii?Q?LD+Cz1olkWV01YogJoX9gDk9AfUS+gGHLAJr5JnkqAwQN+BBlkXDgAqTzOtX?=
 =?us-ascii?Q?Y5RNtcuzPTBA7ATS6fVxd/wDiRxW8EAzzs7A9gBt/kTvVk8Jp81vIRpDx7bH?=
 =?us-ascii?Q?wpWzarC8i8qJpTlA2TG/ZMGaeLWIfLbQc844eDsdtqpL0+QSA1DU9Q+JsQRh?=
 =?us-ascii?Q?nboAccFjNA2ylyk5DM7w3hL6X0OOrXTIaBGHp/rOi8eWhAB8oJtJo0SnR6g1?=
 =?us-ascii?Q?4Y23wE+MV6X0J1t5oADLWVkaDawwT1xXPO87sckWhQiokSw5iftivlZ2bND8?=
 =?us-ascii?Q?Q7Ssg99WDCC2sBrixQK0PJwweWUVZy/RqUxfzs6S+43qeUPztY0XQAG5vEMi?=
 =?us-ascii?Q?3aIoDPG+j5DUv2JlTiqvuTTHf3GpCSZgvKrhI/xTRmaoIzX0kYk+7gfTaamL?=
 =?us-ascii?Q?Et6V2vZkCrVlRzNURGCvWDYKvBRfpbl42ibb9v62qlA1RQMjlkvUnrxwS+87?=
 =?us-ascii?Q?2XKfsHRWP9KYx7/l1FwLW4ljE2j9kCCZCJoh6yIya7F96jLlxZCQXq6zqvW4?=
 =?us-ascii?Q?de7m+yKHU4E1+CV5ZjFqLM8WlvRpE3T5MTiDttQzmny12SXYStvgScLm9e3w?=
 =?us-ascii?Q?udWzzYMl4SDSjanFB4yfM9AEMLoh51uT9Wkp2cNxEGpYDMwDJRt77H+0fctB?=
 =?us-ascii?Q?/Cy4YYuJkUH5qeVFFPS4TPZ+/qt+JvEJCQ+ZqqDlEVFxSePAwMC5pn9YAWGc?=
 =?us-ascii?Q?OnprR1DpMSipWwFY68Dq0PXSDQm3E+plOD7fQPSFQlDvlcn6o9PFz4WqdHOC?=
 =?us-ascii?Q?L/aYGqhObIhcJrbEA6EJvl1AFteZPI3Q6ceQVD+lVdHNvvFknKgYeuGFr1L5?=
 =?us-ascii?Q?hIqeFHQJh6uDKBttXsc8nJB+RPcqpD79Po+Po8Zs/0D9GesF1B75np/w53dz?=
 =?us-ascii?Q?7zRd5pybo6Tfy5egrBLLuacARvm8B9R6lE0T6oi3ODQeeVnnpV4+49j8aAMV?=
 =?us-ascii?Q?/G2KlKIomuHLc9Y/OFqj1v9JYxDggzfxY1aytmLtrn8S0Xgs0H/x7WI4wJ6V?=
 =?us-ascii?Q?uLdUomDAEuw+zKrQ74UFdfv1H6DvcNkK7gkf7lqdqmpfcfyKElRDU3Sy6n7O?=
 =?us-ascii?Q?MGcFR5hMQebSGjKOFPbQ8lAxP68yisg/uyEqxtTVo2XVFxMQWYWx1R+kX00I?=
 =?us-ascii?Q?IvUMXtrLAGqhn3iXqwnua6O0uf0CILq7udYFZh7Fvx8PuUaTJveRN8dSTprI?=
 =?us-ascii?Q?S7z7ms17bdZNQb4Qz+vD5UT1ziQeleE4Qlp2Iy5RklWUPqgxqtY9N2lgUdeY?=
 =?us-ascii?Q?t+j0MnlPHLQNoHvNGWxJeTecbxQTQ7wbGtMCXaj6dZxzxG6tXioaxTKrs95R?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e1f6f3-51f5-4d9d-9d3d-08db5dd300cd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 10:21:43.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tW1E4Bb9wUryIHQkLj4VqMW1Yc1qHWWZ7nqvE6AEcE6tdZSm37SPTBSsv+9rvx/w8bvrRwvqk+8M7PkKGWrQZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8295
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:42:49AM +0200, Maxime Chevallier wrote:
> There exists several examples today of devices that embed an ethernet
> PHY or PCS directly inside an SoC. In this situation, either the device
> is controlled through a vendor-specific register set, or sometimes
> exposes the standard 802.3 registers that are typically accessed over
> MDIO.
> 
> As phylib and phylink are designed to use mdiodevices, this driver
> allows creating a virtual MDIO bus, that translates mdiodev register
> accesses to regmap accesses.
> 
> The reason we use regmap is because there are at least 3 such devices
> known today, 2 of them are Altera TSE PCS's, memory-mapped, exposed
> with a 4-byte stride in stmmac's dwmac-socfpga variant, and a 2-byte
> stride in altera-tse. The other one (nxp,sja1110-base-tx-mdio) is
> exposed over SPI.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2->V3 :
>  - Introduce struct miod_regmap_priv for priv elements instead of plain
>    reuse of the config struct
>  - Use ~O instead of ~0UL
> V1->V2 :
>  - Use phy_mask to avoid unnecessary scanning, suggested by Andrew
>  - Allow entirely disabling scanning, suggested by Vlad
> 
>  MAINTAINERS                         |  7 +++
>  drivers/net/ethernet/altera/Kconfig |  2 +
>  drivers/net/mdio/Kconfig            | 10 ++++
>  drivers/net/mdio/Makefile           |  1 +
>  drivers/net/mdio/mdio-regmap.c      | 93 +++++++++++++++++++++++++++++
>  include/linux/mdio/mdio-regmap.h    | 24 ++++++++
>  6 files changed, 137 insertions(+)
>  create mode 100644 drivers/net/mdio/mdio-regmap.c
>  create mode 100644 include/linux/mdio/mdio-regmap.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c904dba1733b..f68269b39e09 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12835,6 +12835,13 @@ F:	Documentation/devicetree/bindings/net/ieee802154/mcr20a.txt
>  F:	drivers/net/ieee802154/mcr20a.c
>  F:	drivers/net/ieee802154/mcr20a.h
>  
> +MDIO REGMAP DRIVER
> +M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/mdio/mdio-regmap.c
> +F:	include/linux/mdio/mdio-regmap.h
> +
>  MEASUREMENT COMPUTING CIO-DAC IIO DRIVER
>  M:	William Breathitt Gray <william.gray@linaro.org>
>  L:	linux-iio@vger.kernel.org
> diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
> index dd7fd41ccde5..0a7c0a217536 100644
> --- a/drivers/net/ethernet/altera/Kconfig
> +++ b/drivers/net/ethernet/altera/Kconfig
> @@ -5,6 +5,8 @@ config ALTERA_TSE
>  	select PHYLIB
>  	select PHYLINK
>  	select PCS_ALTERA_TSE
> +	select MDIO_REGMAP
> +	depends on REGMAP

I don't think this bit belongs in this patch.
Also: depends on REGMAP or select REGMAP?

>  	help
>  	  This driver supports the Altera Triple-Speed (TSE) Ethernet MAC.
>  
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 9ff2e6f22f3f..aef39c89cf44 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -185,6 +185,16 @@ config MDIO_IPQ8064
>  	  This driver supports the MDIO interface found in the network
>  	  interface units of the IPQ8064 SoC
>  
> +config MDIO_REGMAP
> +	tristate
> +	help
> +	  This driver allows using MDIO devices that are not sitting on a
> +	  regular MDIO bus, but still exposes the standard 802.3 register
> +	  layout. It's regmap-based so that it can be used on integrated,
> +	  memory-mapped PHYs, SPI PHYs and so on. A new virtual MDIO bus is
> +	  created, and its read/write operations are mapped to the underlying
> +	  regmap.

It would probably be helpful to state that those who select this option
should also explicitly select REGMAP.

> +
>  config MDIO_THUNDER
>  	tristate "ThunderX SOCs MDIO buses"
>  	depends on 64BIT
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index 7d4cb4c11e4e..1015f0db4531 100644
> --- a/drivers/net/mdio/Makefile
> +++ b/drivers/net/mdio/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_MDIO_MOXART)		+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)		+= mdio-mscc-miim.o
>  obj-$(CONFIG_MDIO_MVUSB)		+= mdio-mvusb.o
>  obj-$(CONFIG_MDIO_OCTEON)		+= mdio-octeon.o
> +obj-$(CONFIG_MDIO_REGMAP)		+= mdio-regmap.o
>  obj-$(CONFIG_MDIO_SUN4I)		+= mdio-sun4i.o
>  obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
>  obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
> diff --git a/include/linux/mdio/mdio-regmap.h b/include/linux/mdio/mdio-regmap.h
> new file mode 100644
> index 000000000000..b8508f152552
> --- /dev/null
> +++ b/include/linux/mdio/mdio-regmap.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
> + * within the MMIO-mapped area
> + *
> + * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
> + */
> +#ifndef MDIO_REGMAP_H
> +#define MDIO_REGMAP_H
> +
> +struct device;
> +struct regmap;
> +
> +struct mdio_regmap_config {
> +	struct device *parent;
> +	struct regmap *regmap;
> +	char name[MII_BUS_ID_SIZE];

don't we need a header included for the MII_BUS_ID_SIZE macro?
An empty C file which includes just <linux/mdio/mdio-regmap.h> must
build without errors.

> +	u8 valid_addr;
> +	bool autoscan;
> +};
> +
> +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> +					  const struct mdio_regmap_config *config);
> +
> +#endif
> -- 
> 2.40.1
>

