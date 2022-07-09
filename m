Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE756CB21
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 20:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiGIS4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 14:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIS4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 14:56:19 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44463FD09;
        Sat,  9 Jul 2022 11:56:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQ1/1P69QUGe1O0mjbeD/jeWltbZJzDGfuGpgnoMBxQGARH6WX7QxERgsNmMKaxpLTqcBCmobLwOg1CcZj20UGdmys9Hm4K5zPPg9yXxKz+t57EBrFRuqaqkeVaLmQVJNpWcGIrGOTbn1/jlhxq45MhzJvqkG1bc3ILXA8FtCHNVqPym+xzNBz2GpDP2S+44P39mMpy07qFGd368NcmwwXa0Bn1xlol015gjYoxk1TwuzKIdYWZtn9QrKq9QeS7eUtyGh7fQDFlRiH4D4SShelVTAlz3RY/KzIgCqj/yX90yIH70a9667RLb93y2xDqk9ZS6U23n4PS514lcFsuOQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNVdXiEJlP6KWy/uKc/nqqPN5sKBlV/uANLwd8ieq3U=;
 b=WwbxFkqOvBidGm43CZCV95IsPfigROC4Ab3XtxR0GXyaPjhtxwEccU+jMXUYA2Vhi/PWnzSKkYY86ZmplLvV1QS1GGMHZMmiqqOAgxtcfaSBjykjRs88foX4zQdIMmbhXyyIX4kBiMO4fibeYqSmxGijxmVJ7ptKWGkkjwIXQiDvptKcr4wI7WoRnYUmf3IO0O4A4VwMsjpKNBKRjiwyl3d+sOgDY1EHGiE7eouKzzR5WL1g94uz3cjDty1UX0+69CZD21pYGPEVCc4Y5RMIk8zY6t6eSMo2kQDujdZPTJJlX7u0fQppw0xwFW28rXvToFLwMX+YlKWMIrHRPRzGKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNVdXiEJlP6KWy/uKc/nqqPN5sKBlV/uANLwd8ieq3U=;
 b=ZyR8xyxvKriFno9JMx/ZUu/wvslERYIrBgHb4umLe6ep/RkCftdri742+h+d65BvVrKbgLpajDzYx/PLvE3qH5EjqFboKWVE0us7ltcsmbjl8qS3lAYR2jM6zKprm79qc+mxFpa98RjHHOSxZBM7MCv/DJkkjm3juK82alaIAZY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9462.eurprd04.prod.outlook.com (2603:10a6:102:2aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sat, 9 Jul
 2022 18:56:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.020; Sat, 9 Jul 2022
 18:56:15 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Topic: [PATCH v13 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Index: AQHYkLCMdCdG3kd5wEePWYl2oYvNba12ab4A
Date:   Sat, 9 Jul 2022 18:56:15 +0000
Message-ID: <20220709185614.4rrzo4hvmkena3ob@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-2-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76a99870-ad99-483f-5e35-08da61dcb31d
x-ms-traffictypediagnostic: PA4PR04MB9462:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1SSrVM+rg4K60X+HHtbVBuCJD9FaXbg+vDnoghkIUH2VQMFKMDOxSkHWWhLKRUPAPTMMfhAD0Ny5gCfo1hB9E9ESIyhNv171C7lk2c1I8P02QYqJDKlftq8YOE/SQzGydd50bZEzKs2fwbpM38TGknzX6Kr6FA18MLUnVIZdrMIs3PI/RuLWkeuSVqCeqO9jP3d4H/0oq4VoJh0YTaNgq6bk9R34dcUKYDvVXHCDbWvTI05Na8ppNx4MgmyQHH/jvD0wosz2ztrfybRIGWfymc1Y6Dzu++a1f8JGjbRMhIadCQxpyUNOHFMy4DO9qBIU8+NE1r7hseRbUFd2RwV4NC/NGe7LAzlmvZhvS5avuA5+Vw8TCWZ2XdXaYltlJmw77K6IB8o/Pq6MCS7tqGzP2H3FPcdxsCfmSlhFtpD41bI8bzytYs0+LI+ptiNH4HidpS5DNksfJ4ZD2hZI6zYvOvKQXb80LSh6fl6gTR7Q1HY+CXsOWacYqklj0vCfQhBnFuwvm/zSS08liLrC2IwhpqCROfbSZR6vDxgfdTjiZeGPoCQYehDQdu3INcltOwZEFLfWC3nWqcpvV5mfZ1z5Kq1fqytMiRg6+xsjUdDhbl3wAJ2AZ2VpiNjaYULZe1uDEyZ6N2tutn2pogAnkrKTXfnUIMqjRphD5eufOZy6hOAC7m99FAyXIM/oBrJYoq3/G2efHWiT95i9D5f2BkTl4YXwLnAKGMGKhJ+8ij+Y31hsYE4swZM/LVxydBT7Gqox8kX5uZgRjx1N46+Swww/gX9k41aU/hAgN/Yzx96NFOAN6BFtdxZDbnZ4kzVyi5m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6512007)(9686003)(38070700005)(26005)(86362001)(122000001)(38100700002)(6486002)(6506007)(76116006)(44832011)(7416002)(478600001)(4326008)(8936002)(64756008)(66556008)(66946007)(8676002)(66476007)(66446008)(5660300002)(186003)(33716001)(2906002)(91956017)(41300700001)(71200400001)(54906003)(6916009)(316002)(1076003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k8YySaJHCMZXstI1K2PfJtjrHjbkKa779CERcUKxqb9StqTGuoXGtWYsqZBD?=
 =?us-ascii?Q?mJ/0uqqQwlw1VpASbarlQxGfjt8/aClGwT5HolRO8lCcvQn2VJsOx4tdkOWR?=
 =?us-ascii?Q?MA2Sy7yPYRQ33Q3lyh3hnqjMI/eoZTDCGjFBnByZcBmMd1y+B3T/+U6b9c3G?=
 =?us-ascii?Q?zhhEXoNqnQwGMh9oPCXEE66MA0VNiMFChBUroyzCJY1vDcl16q40VeEWuVgC?=
 =?us-ascii?Q?zOcqQwRwDYp7GJOGzBE3kk9DWn7q4PkxqaTa7vSyF0ld8FksD8eJ03doRxE9?=
 =?us-ascii?Q?07XUGXNk2jaKlSuW+f5kHU+GD6R4yWsrbEMsJ92QnyEf214UN8OcLNAOAp8Q?=
 =?us-ascii?Q?4yrOta19aPFWOAfsz9NjaRG6eKyIvZKOpPa2LR8jtR+1kxgclMktZNZfMMug?=
 =?us-ascii?Q?FRDVFrSwF6Dfv8NDxVGYLbmGMVkjvTrBqQWDAwbw717DleTRPd7v5oDl5xwN?=
 =?us-ascii?Q?RdaqV2TGwRQxbu5iChY8naA7/AgdBS8HnbhTIyzLBLY6jzZHugVlJ7nFPfBA?=
 =?us-ascii?Q?cf4jIJKvZqpkmOTIJ6rGCrPLWlbF52BwF/I2ohRHU9IZIJzagv5AqbAnre45?=
 =?us-ascii?Q?Zkly/T64hct0zlt0FsWKFHK76dOXE1JWnqSIeE2FfMDB0h4alY61FpumkkKZ?=
 =?us-ascii?Q?hiULx6/vlDv3+1E5efnBoS6puIqePff+QxQihDLgT6YNp8T0TPAJKfHqXo7+?=
 =?us-ascii?Q?2qNgza9CQIizmP/UxleAdeDeTOulPgsFWUR3cvgbQwvHq4TvHxp9UA500WKx?=
 =?us-ascii?Q?SUcVASBQj1zI91L7gc0lKevzQuQY5utpcoTJG+37/mHb+gOZukabg6D29CvK?=
 =?us-ascii?Q?NuqIYoUdlZbKh1mKvrxGya7T7JDL2OxgTMJiCEm3OfW8LC9ToJIM67Dwz5L4?=
 =?us-ascii?Q?M2Hlr5bljtcA4ftSUU9exsDehIUp1Hv4Ibf8aynpmN5E9DldnemXaRKOufRB?=
 =?us-ascii?Q?elP+wmLNyexJGG08O367VulZ2boTQ7P2WhSLNoX7epQ6hypxB25L5aFm/TDN?=
 =?us-ascii?Q?n5U3QwWaS3CzWJEzz9JAy3L1HQmOzhxEywogP6uM2sBvlLt7trLdBrc/wGaE?=
 =?us-ascii?Q?52IGT2Ft3sQfPzSYYh34EMKnZ3oJKFxj5x4Oq80DN87zVlSkO51+QJHjtSm8?=
 =?us-ascii?Q?bcan9t2LsZEVB9rl84xjgk9cSYcTgmz5CZ8ZQF/Ase2yIQxkaYLHAJDy4x+1?=
 =?us-ascii?Q?5g3ufssdzp6iMO09R5vE8KtOTLHwegROGOGN9sUiV+jsjzqS++9bGfh+w8t0?=
 =?us-ascii?Q?66LCfjw+fzuGYw/xeztO8bt/3HVEX+3yqv5tHjhzW9VCPCnqUsuxKpCmzFSK?=
 =?us-ascii?Q?omPvwSUPXvuel00w9ki5g8gai98RiwyxKO6swKFJmtQsmCQWqGZKcnlTSfD+?=
 =?us-ascii?Q?glvN9ESEjEdl6m5i9Kc+CTXGmtUG4efvRGsiDDJyN5t86xn9FJvYuwmxqTsR?=
 =?us-ascii?Q?INz9VoGKMkt3F+nJqT4GRJCVMqtjMK6kgV88LCmnZUSjz3jt9hjb3AhLc+JD?=
 =?us-ascii?Q?jVYQSgMS07UtTRSct8ARNaDnlV6fJOwChbNhcx1waO0LrngN0nuEonhL7piM?=
 =?us-ascii?Q?ZS7o5QGeqAglsTJ8tjYG9Zw+PDIzMCZK7U0RHusStwZD6aEwveoxzIfmjiaE?=
 =?us-ascii?Q?oQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <64FFC8B0678A144B8940B4D0D14A45B2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a99870-ad99-483f-5e35-08da61dcb31d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 18:56:15.1935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lUs/3Op5eT70ZiweT9FQe/OufHyT2G4eHKr0dl77ABb/sNWLLTprfD7IaePemh5tRjoEIStOKtspH6NgqQ3AvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:47:35PM -0700, Colin Foster wrote:
> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource an=
d
> devm_regmap_init_mmio.
>=20
> Operating in an MFD might be different, in that it could be memory mapped=
,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_RE=
G
> instead of IORESOURCE_MEM becomes necessary.
>=20
> When this happens, there's redundant logic that needs to be implemented i=
n
> every driver. In order to avoid this redundancy, utilize a single functio=
n
> that, if the MFD scenario is enabled, will perform this fallback logic.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

To me this looks good, I'll just add a few minor comments which I think
you don't necessarily need to address by resending, they're just things
I noticed.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  MAINTAINERS                |  5 ++++
>  include/linux/mfd/ocelot.h | 55 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
>  create mode 100644 include/linux/mfd/ocelot.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 28108e4fdb8f..f781caceeb38 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14467,6 +14467,11 @@ F:	net/dsa/tag_ocelot.c
>  F:	net/dsa/tag_ocelot_8021q.c
>  F:	tools/testing/selftests/drivers/net/ocelot/*
> =20
> +OCELOT EXTERNAL SWITCH CONTROL
> +M:	Colin Foster <colin.foster@in-advantage.com>
> +S:	Supported
> +F:	include/linux/mfd/ocelot.h
> +
>  OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
>  M:	Frederic Barrat <fbarrat@linux.ibm.com>
>  M:	Andrew Donnellan <ajd@linux.ibm.com>
> diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> new file mode 100644
> index 000000000000..353b7c2ee445
> --- /dev/null
> +++ b/include/linux/mfd/ocelot.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/* Copyright 2022 Innovative Advantage Inc. */

A header file should have ifdefs which should prevent double inclusion,
like

#ifndef _MFD_OCELOT_H
#define _MFD_OCELOT_H

...

#endif

> +
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>
> +
> +struct resource;

IMO if include/linux/platform_device.h doesn't provide "struct resource"
that's a problem for that header to solve, not for its users.

> +
> +static inline struct regmap *
> +ocelot_regmap_from_resource_optional(struct platform_device *pdev,
> +				     unsigned int index,
> +				     const struct regmap_config *config)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *res;
> +	u32 __iomem *regs;

"regs" could be void *.

> +
> +	/*
> +	 * Don't use get_and_ioremap_resource here, since that will invoke
> +	 * prints of "invalid resource" which simply add confusion
> +	 */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, index);
> +	if (res) {
> +		regs =3D devm_ioremap_resource(dev, res);
> +		if (IS_ERR(regs))
> +			return ERR_CAST(regs);
> +		return devm_regmap_init_mmio(dev, regs, config);
> +	}
> +
> +	/*
> +	 * Fall back to using REG and getting the resource from the parent
> +	 * device, which is possible in an MFD configuration
> +	 */
> +	if (dev->parent) {
> +		res =3D platform_get_resource(pdev, IORESOURCE_REG, index);
> +		if (!res)
> +			return NULL;
> +
> +		return dev_get_regmap(dev->parent, res->name);
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline struct regmap *
> +ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int i=
ndex,
> +			    const struct regmap_config *config)
> +{
> +	struct regmap *map;
> +
> +	map =3D ocelot_regmap_from_resource_optional(pdev, index, config);
> +	return map ?: ERR_PTR(-ENOENT);
> +}
> --=20
> 2.25.1
>=
