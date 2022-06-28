Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35E255E88C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347790AbiF1QJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347751AbiF1QIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:08:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70071.outbound.protection.outlook.com [40.107.7.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02473A45D;
        Tue, 28 Jun 2022 09:08:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioHkSy/PskT/doXqASFaquxT0UEGA7grFHX6Z1ou+9laYYkGP75YKRdIlA95MGRhXaD7Mi1wUKvNkqKji9x6a7g6ZlYm+NxP6P+LfukWhVcc0gg5FDh9+H9m3hvNWYgn6PaXunbupMrXluKy/UE/w0KrIactkJbzCPgnQtVSQC35lVtzb9fiIHeFQj0MVm7Y5kW0GEwtKosm4NhxQ6KejwyL1e29dLzIXnnWAMHgWG/r9tQSEvSluVcdAKB0ybDZV4FllY3pab+IuSLNGe/oO69TxdirLQCIFjpIg90cW/v2pNGf+CkQ48JUPL+eEpdogEUE8bE/GHEbQXCqUQxgoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zX5N+ZynjZYV3VwBEDQC/yu++SgtqrvMDLJ4yAip+Y=;
 b=aegRERwlcgO5tn0xCb/lmGIpFk/E0cliKvBJY9qnwmX84J2b1n7mseLryc0bXKQuJ4Wg9NPgNJnDmDLK9tzH5hv9yk1hwdJ+e83KOfLwDSHjPp0kmYv3Tr7fGOOMdvVdG1CigXRPvC/FXEUvH8At7gE5VoQ1fdRAbAvM+5o6w645WcYEGVaR5smaHvFqvvSnvhpGksy2AI1GAR5u0IaUjjaLBISLFQ98iZN2wCQpXbuf6//JfyA5FZs6B5KYMRyQgQFkL5sEaSH3tDHusr/bGfYfgLl+l/zmtEVD+yHE2mpHkX2Fk3LIxmum9T2wc24UCpb6GJUhW+3+YbIj0AvN6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zX5N+ZynjZYV3VwBEDQC/yu++SgtqrvMDLJ4yAip+Y=;
 b=Pq3WPl/BV9uJzw2BrtsqQcdV1bJecFH/z69sZM/KmxPjWQGrTwIxgiGizsHVO0wslTfv2Sp8iXuu0pOxDGygETYZbMIcK9kXsDZtT87pjj6i2f8elBt2czOCQU7SLm7nHoIJEFZQuO5yuLqKCOZBIude47WLJ2ghNHsacGCoWIQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB3960.eurprd04.prod.outlook.com (2603:10a6:209:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 16:08:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 16:08:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Topic: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWA
Date:   Tue, 28 Jun 2022 16:08:10 +0000
Message-ID: <20220628160809.marto7t6k24lneau@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
In-Reply-To: <20220628081709.829811-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ab0eee9-2971-4839-560a-08da59206572
x-ms-traffictypediagnostic: AM6PR04MB3960:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L9CYD4V+vuGCh9gm5z/6AW0W5UKGdtGTHuo/DQrbytZsXDCEh/Kgxu5RUyAxiXbK6nU6oO3lBGUCTk2ySZWm26ewjAyk7g5LZyJ2Kf/NmvGD4ycFvrs3ij0T0lBQSQynOjccSi9hfWslNs7oMGv/DRjSi1Rz3FVTBzUrWkFkqg/i/zlsy7erbLUYfh6IPA3pJzdERmf5F8Hrcr/FGlD4B8wlKBPba+yqcInaCg2gddJG6YMrHKs681qGZGdnJZsMyOJjdKJf0Ci5KFL3eHPkpMTc+LHVeW7VreLCXHvl5Md+smcnm2kv4a5iAJiMlIAlILtEIFOj11t+1duffbDbGzO0OQnn/PCCTkWjCtIBO+2gHGdhDtShss/AiFLiqwsLTPA9wdlJeELbzTdFBUHCv7Sq4ZPsXb2+0WrHNmVoF3XWoWM+6uGv8hQdrEZSEQuW3Z/vQD6R1M2iXrVwiltToTIEUsQ2oMwfrPwrmFfUsA+b0GS392QiqN66PuxQJfJum8fSoVuS2VW5nrRE8ffGtaUcR7xnNuquscvprV/bL1eLkOngV1MoeaqRRv5rrwCerw09kRKROCkdtTGrIccqemDsedAHx2uteKUjqXeMq7P+FioSiaiVEhkN+ieeiDsYjur4qm4HB/QUzuRym/PCttI4xBRdYCSYE5M29dPQD4SkW0l6e26iqDmq+D4jqWSt0q5oLYcA/Ak578+f68YYgsjQ2BTZ6YYztQRY98DmAzKvuUlu7mevl4WRDbetymMNIN1xqVAgnnlcIx+bi0lvkwXeCfCjjrDER1sEtKLtD3M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(346002)(366004)(136003)(376002)(39860400002)(6506007)(8676002)(33716001)(66476007)(86362001)(7416002)(71200400001)(6486002)(64756008)(4326008)(76116006)(66946007)(41300700001)(478600001)(44832011)(2906002)(8936002)(66556008)(66446008)(122000001)(6512007)(38070700005)(6916009)(1076003)(54906003)(316002)(9686003)(38100700002)(186003)(5660300002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MwQxlc0K/qihR/m4pJSBd3Skl/W+1x7BWnYDue0RkrpW63sH+U1sxl3fkC+D?=
 =?us-ascii?Q?GdDpy6ztyB/fU/r3jiL/x9Fp4Bx981FcxB4qLwRwo5cwNBvB/M99b/JsFNk/?=
 =?us-ascii?Q?/bE15CCf1tgw+J1s2j3qwh1qHnxotDb7YsnOAjggQ43pUYXmJQEuJYp+EsF9?=
 =?us-ascii?Q?Jvb4UzWfDBXrLMNa2Im+oktXYigdB92H35zg+EBHIbz4InMZOyb2grjk5WKy?=
 =?us-ascii?Q?MW7xhmUmKU6t1kQAy5mZOxN+dgWAnXLc4+T0lzM++WzZONATZShmdxGLoAnI?=
 =?us-ascii?Q?XcNo+KckQelmHycHieTClIHsU+lQJbOXcn2XJegHWuR5LkErtMpplRu2Lx7d?=
 =?us-ascii?Q?K+16izMTN6JRWLXlnFOTrO1ZNFXY8YfE+g+0YgJ+cp2V6UkbEPYfPV6PyG3K?=
 =?us-ascii?Q?C5GEQRCnXj2frd+okVoHI43JoEB+tODaBKJaZ4cxhkr/7z4krKdt+DTXW2V3?=
 =?us-ascii?Q?9kTHylvdl+oGpMM9VQNET7nH4T0oJLp3BxyNbzboNNjnh4fUWg84oF3paCLW?=
 =?us-ascii?Q?2JVB+5JUmph/lNmv+oirhdpthIstBORcJCs1BGrGh/h3rVX2W2ngrfJXkzng?=
 =?us-ascii?Q?/SAihfairjy6LxtyyYwijfEpS7EWPBWGdESKUenTLWoejcjetmvQjyhTjQWQ?=
 =?us-ascii?Q?UI/La5xuCfpIyH6PkxuRdOvnksaKlXZzwCZLhgNHUteFxZNwArY0k81at6QC?=
 =?us-ascii?Q?7wekQC8OsuCp3+lOGqjEmKWE2HIdjLK0pPWWMMUogDYTQocmhFVgiGBM7CtO?=
 =?us-ascii?Q?c+3oOoKEqpSr4hxA8pyCTuWdPfzgEU6VkZ8Ub9nzgtzv7GBZhCZyA9Mo/fur?=
 =?us-ascii?Q?C3Chp2hxIy3qoLhiPXAcjWM1ZGqEdFSrr+SwFunHiJbTBXTWCglKUqsKXEpT?=
 =?us-ascii?Q?zA0Tmh3o5Do3lt8EVeadiovue6W9bl+WcpiyZWV/buj79nhTYvH9aocAYDCn?=
 =?us-ascii?Q?+XFk1qaPVXoTGvYCi4LtRyGHvAKm5+bnFaARUQltvtqscyyzlH1OXP7pBImm?=
 =?us-ascii?Q?trBTuADj891uswt6D8TUsHm1TQKXrncijVgQRluitFY9CEIVqViEwnFSV4el?=
 =?us-ascii?Q?0cOTIkXQm4ue3Ek5sFDUfRr30DUvNqauunDbCI6ponmdjZmNp2m05tX09VR7?=
 =?us-ascii?Q?ltVP2+WMy7oRgyns0AA+tj6ybDGGvf+CV9iHgNaVAGMYsUQMWoQ9KLl2YL+F?=
 =?us-ascii?Q?PruDZ2rnwrPzI9j6eaiwHkgRYSeIxxKBCl8Y+MAmazyyckgx6Vzgk6vpFYH8?=
 =?us-ascii?Q?AC6loqMWSHDyJvZall/6dJpSvjpGw/Q313PA3n+T5iC2es4fqyCp1b8m+wke?=
 =?us-ascii?Q?VXvOulPZtauMW7do7gGa/DqcyYZWTLQcCFAd7WdeSNyQZxOx9oTw/Y8JCi2F?=
 =?us-ascii?Q?aiH82FEL5VeD5v9g0uvGEFuk0sbSQbyXW7vbTf4HHVpT/u3bUzfO9jpyREw3?=
 =?us-ascii?Q?fiQ21u7FJ3L7KLWDQn+r1sT5TVrufnMAnqWcoUDJmhdnRl0W52mmhCtw1bTg?=
 =?us-ascii?Q?XkGIBPyBb3c7DGzYyhLmwphT3wbijcvyWdZvF9mVuQeMD0NKUR5dAqiCnOa/?=
 =?us-ascii?Q?bxtoEqAGj9s6YjPRm3wJJA1DiMLOJyox/zbvdm8o+6BWdnpW3FztYKa3Am4v?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81C691B95E8EC74895C0068C3B5AFA80@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab0eee9-2971-4839-560a-08da59206572
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 16:08:10.1851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QWZ1N3/T4foI1Ka2AUb7/OIBe5hp/L76bdUfxS58AgIF8YN9mVd6AIpp382FZIAMocb/3JqsX93vpdIjQoMXmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB3960
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 01:17:01AM -0700, Colin Foster wrote:
> diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> new file mode 100644
> index 000000000000..5c95e4ee38a6
> --- /dev/null
> +++ b/include/linux/mfd/ocelot.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/* Copyright 2022 Innovative Advantage Inc. */
> +
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>
> +
> +struct resource;
> +
> +static inline struct regmap *
> +ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
> +					  unsigned int index,
> +					  const struct regmap_config *config)

I think this function name is too long (especially if you're going to
also introduce ocelot_platform_init_regmap_from_resource_optional),
and I have the impression that the "platform_init_" part of the name
doesn't bring too much value. How about ocelot_regmap_from_resource()?

> +{
> +	struct resource *res;
> +	u32 __iomem *regs;
> +
> +	regs =3D devm_platform_get_and_ioremap_resource(pdev, index, &res);
> +
> +	if (!res)
> +		return ERR_PTR(-ENOENT);
> +	else if (IS_ERR(regs))
> +		return ERR_CAST(regs);
> +	else
> +		return devm_regmap_init_mmio(&pdev->dev, regs, config);
> +}
> --=20
> 2.25.1
>

To illustrate what I'm trying to say, these would be the shim
definitions:

static inline struct regmap *
ocelot_regmap_from_resource(struct platform_device *pdev,
			    unsigned int index,
			    const struct regmap_config *config)
{
	struct resource *res;
	void __iomem *regs;

	regs =3D devm_platform_get_and_ioremap_resource(pdev, index, &res);
	if (IS_ERR(regs))
		return regs;

	return devm_regmap_init_mmio(&pdev->dev, regs, config);
}

static inline struct regmap *
ocelot_regmap_from_resource_optional(struct platform_device *pdev,
				     unsigned int index,
				     const struct regmap_config *config)
{
	struct resource *res;
	void __iomem *regs;

	res =3D platform_get_resource(pdev, IORESOURCE_MEM, index);
	if (!res)
		return NULL;

	regs =3D devm_ioremap_resource(&pdev->dev, r);
	if (IS_ERR(regs))
		return regs;

	return devm_regmap_init_mmio(&pdev->dev, regs, config);
}

and these would be the full versions:

static struct regmap *
ocelot_regmap_from_mem_resource(struct device *dev, struct resource *res,
				const struct regmap_config *config)
{
	void __iomem *regs;

	regs =3D devm_ioremap_resource(dev, r);
	if (IS_ERR(regs))
		return regs;

	return devm_regmap_init_mmio(dev, regs, config);
}

static struct regmap *
ocelot_regmap_from_reg_resource(struct device *dev, struct resource *res,
				const struct regmap_config *config)
{
	/* Open question: how to differentiate SPI from I2C resources? */
	return ocelot_spi_init_regmap(dev->parent, dev, res);
}

struct regmap *
ocelot_regmap_from_resource_optional(struct platform_device *pdev,
				     unsigned int index,
				     const struct regmap_config *config)
{
	struct device *dev =3D &pdev->dev;
	struct resource *res;

	res =3D platform_get_resource(pdev, IORESOURCE_MEM, index);
	if (res)
		return ocelot_regmap_from_mem_resource(dev, res, config);

	/*
	 * Fall back to using IORESOURCE_REG, which is possible in an
	 * MFD configuration
	 */
	res =3D platform_get_resource(pdev, IORESOURCE_REG, index);
	if (res)
		return ocelot_regmap_from_reg_resource(dev, res, config);

	return NULL;
}

struct regmap *
ocelot_regmap_from_resource(struct platform_device *pdev,
			    unsigned int index,
			    const struct regmap_config *config)
{
	struct regmap *map;

	map =3D ocelot_regmap_from_resource_optional(pdev, index, config);
	return map ? : ERR_PTR(-ENOENT);
}

I hope I didn't get something wrong, this is all code written within the
email client, so it is obviously not compiled/tested....=
