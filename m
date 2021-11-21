Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D14458578
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbhKURf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:35:29 -0500
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:8512
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238384AbhKURf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:35:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhuyyjZDmLWs7dblzaR4iSiM2quMpSKoL3BjZ7Demgnuk6NJ1JKZSS96s+1+6HNgerIcdEA05E1jOuQmGlB7YjuF2aXu4AViEBDG2gdlGL6MnN5ooREB/cdy9oSNxhJd2GoIANC3YwUGbL6ZqGHBuW++zf01+nzs/ZoqSLExs7hRLoIJeYsEQNHn1I0erJtFxCWQOa02+jKveZqpn52aHbfITCPhdYpwp6lg8p9I8N9/kkCS8O8gq/M1WSAGB91ATmexBBH2X10yuUOqGqeNETlWVSAi0vexHcMx5ZFxNa47Goo+60Z/17QMcIYmYTaj7dqcbDoJ3Kpg8QXHQH1Hzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwD0TfYAx64ClL2wn/xkr0myzxjgKB4vaxmtauJfq0E=;
 b=miReAJppZiTX5eD3nwQvj5DG50yAPV0CKs2kCNj695lqPi8hpvGIV39E4mTJnfLfxIV8U0ZjY5MW8Re113g71TxiChkOo8PxuiQygoulOHhXUmvUyhQTWWnMUQZefCbuSCawnKVgBpfBYSAOhFLglAkq6mdvUES1Je6/asrNdYG1oOuDWVLnofKdZf8ZNDZ4UjAfPvmWIUPKtRK3DNcR7cLJiKcMOB2wH9MxMvHOrJ60kD6PMw88RF0mUsOPG+3qZOJ7METCEjKDpPKUhq6DLdd/3vpXrZ6eeN2XaFxQipmQ16ils2cGpMBRz7tiMooqeVyOTpdHEsQ4HV9ArmBWyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwD0TfYAx64ClL2wn/xkr0myzxjgKB4vaxmtauJfq0E=;
 b=PGXUX1HTeuw6Ev5/yeCbpgOTox3jAJr30N5ucrD/w7oPmTiVLeREVdJdAves52usYZBmCz+t3Rnao3ouUeWD5lUHVrHkR/o11mNgwg5ga9eMrMWbmOKI3+FkoyqIRV7oVw/ik1jGTSYzmSSWz9HztHNBQVZcwnCmQbITE5jdCvM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Sun, 21 Nov
 2021 17:32:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:32:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a regmap
 implementation
Thread-Topic: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Thread-Index: AQHX3Y3zJU4Db2KQ/UW5dFvidIRhsawOQFuA
Date:   Sun, 21 Nov 2021 17:32:19 +0000
Message-ID: <20211121173219.bewdatfn5uwfeicf@skbuf>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
 <20211119213918.2707530-2-colin.foster@in-advantage.com>
In-Reply-To: <20211119213918.2707530-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18acd173-c1f6-4db2-6730-08d9ad14def8
x-ms-traffictypediagnostic: VI1PR04MB4221:
x-microsoft-antispam-prvs: <VI1PR04MB4221670B06EA05D4A923484DE09E9@VI1PR04MB4221.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5b0tUwNjqfHBkMoKOAfsZAqd/+/8O8/DvN2huVfurLlEPAKyc6ojixa2Y0qQoZ1dOaGmlfSg0lBQ9AeMfx8D8RpqE6FujkKzx8zU4N4n/nsT1lQyBOQhpHbAJpzxuKyRqW4AhhnEwNzAUILrcOa+plD3rwf7GV4CZSwOiffjySY+idfeelenTh3pW3I8zxqbzMluw9TDQS84WTnqQdowk+o0vyPt5a7JlxOHJZrlgXMljtEDumKOb039NcXcag1rkvoTEd4+9CDLNiEJdIuYuyxT6n7+vrhKqLsX/4As4spfojmXxH4U33x8s7WA0kfunDC7SBg+0w8XpaR4Xn3gwFGvAWmGtyYj7beye5u5gIv3FvZnz2oV0SoqdOyrEcFGEMISnmlw+BCgpbVD5ywDa6vn6KLYzJVJNuICkZzle2P3ns0FQjenB3YzaOLQLpxTtkINRb35VwigWUv70TIVbVeM636YOnGv+PiXfkYi6u1B2CYAs9K6Sxmvz/I/7KjTK0qK/TaJP8COxA8vZjkdNYlkqHtNbI5dnhnkVct60EgGGK/K2g2ClblvKC4JZ1Py9Sw1jabmRgg2u92wT36RqPQZAeD0PcRqZaKPcbVgHWEcRzN7OZ0kspZ+U/ga58H/1Tj2UGHppJisrn/1zpqWMHv2vohiLg8dL7cQm9qw5yal4KDnN5hxrIvgZmDuzIH93/JPSNdr/xQKsw2Xlebt5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(6916009)(316002)(4326008)(6506007)(186003)(122000001)(9686003)(2906002)(38100700002)(6512007)(83380400001)(71200400001)(508600001)(7416002)(6486002)(66446008)(44832011)(66476007)(66556008)(38070700005)(86362001)(5660300002)(91956017)(76116006)(54906003)(8936002)(66946007)(26005)(1076003)(64756008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nPDmfrXpy+ivT10uCx45oN8WcISW7GavLTwEMy8ltdTDLJmuiFoIwZW9O3HD?=
 =?us-ascii?Q?qVfdwBm/QgtdvCzM3aVkO3/7N+kXHyiafzPXUV7+bJSGyLjk376qJuidRfkC?=
 =?us-ascii?Q?bF0q6wfc5JhCbVkeAFcCS+awIWN9+aCeZK5Yy/R2DTBb+/iEkQ7qO6UHTIvN?=
 =?us-ascii?Q?zxoGISZUgXYbE+yUswsNXw9F455/Qw/qlt2egYgb1sSU1uTNmx1r4v8xS4vh?=
 =?us-ascii?Q?2bd3KwMvaCs19t+p1WS8jtr7gE4SRTVIuAkfwIbufmiIBQz4X9PZJlM+7K1c?=
 =?us-ascii?Q?+5nI9oBYUoSbJXnUSHtoh7kiy1tYMr03uUznbXBygKlaQG0Z5ANtaVberTP4?=
 =?us-ascii?Q?4YcCXSY6xz8PUqj15+EsxWwMtAsxnbNBcoqs7OtyQvzhdtQNY9ekhZMHR5cT?=
 =?us-ascii?Q?sooZNmidq9fxwAzez03rStM3RQtaarn6upvRyb7/r6aH+s3EHWWlGShH2bBR?=
 =?us-ascii?Q?OLkao8CJQN6CvgrR9zIpi4f4qqlQHAnLKTI6rKrZVBNicYXboY8rlJQwV0kJ?=
 =?us-ascii?Q?1g3WVo/ZQQuOjCZPWy8Nwobdeadn2fC7yCfjg9R6LtBcV+/58M/k/0XyBE5D?=
 =?us-ascii?Q?Za4WdA4GrMODXZFogXFSh/W2z0l29ZtOv8NTQP+Lf9I2kvI4aggjJeheVPcH?=
 =?us-ascii?Q?oCZnOu/6CrCCn5uDUd2YAKFQYhgH8urIy8FWo39MBviczY+5Dr0ZTWn8rY0j?=
 =?us-ascii?Q?8r+ohQxmUzkcEJjeWsGJsc3muW1Mw1+MX80D23dPEpcDr8xn2oE2u1g/zDl2?=
 =?us-ascii?Q?HgkOfKEjk1vsDJvRBPKtL8KjZZ1Sw2z72zP75MMR3KdqYxmUhXlBiwiJ8E1W?=
 =?us-ascii?Q?XuZ4bcaAh/PjD6QYclqzyfSyLGKy+arU6DCsuDF9+JoZtbdsrypd+tmF6u/n?=
 =?us-ascii?Q?AkxNcwS7eTusXO2tt9lJ/WDePuzssGdBr8o7hGgtX/drCVpaFf2o5eYZvim7?=
 =?us-ascii?Q?UGZPpPD9hSe6/CK/0VfpRTiUmzGlhQo1lKgcdnEP08NO6Wg+Yf8eNAY/XScz?=
 =?us-ascii?Q?JplszrrGaxNw9WSMcsqQpMNMlSnJ0JAcY6AoyNGZoAVF7CCBYYVcRDrb7gMo?=
 =?us-ascii?Q?YHommjmaT+dguQ4HLON+q3SfJqMTtyi+kiWqNZBiQwmK57JjKNZHiF5VK9SQ?=
 =?us-ascii?Q?korb8ClBbp755lY5WXCaUCU7T1GHaR69mrzj2epthBVZR1TfliJ3y/jUqbXm?=
 =?us-ascii?Q?Lj6QUy6p2XoP1qkD9JcxWtr8D88a7YdrccPJAZaADCF6bwZAvLeLwUQmMj6N?=
 =?us-ascii?Q?xvJU3hj35xW8tnAF5yWdroBNLBhYnpqVcZzmrNoLz5EMO5u4KZrI21k8R8Un?=
 =?us-ascii?Q?4VnoNiLw0ffBPFc7q3lp0vCUTXiANQMYX1uqAfZgt2AdCGTEVLzqNisRYDsC?=
 =?us-ascii?Q?rF1BXKLdeJpChQfRMP2TS3UzayxIYcl9ZoFq5EneWT5i88MSfMizu13Os2EO?=
 =?us-ascii?Q?w/5sMIApK4pDJllGBfnTuzE2gEhApS55gI/QGz3skZS/zxfliz8aEp8fF7Hy?=
 =?us-ascii?Q?tuDln5Lrt/qOYZJkYlJi48uPbf3EwouLnSzYI+Lh1PqTwf02Dww0fRy6q6I1?=
 =?us-ascii?Q?QC5xm3Y4ihPIZOCnoAKBDQA1UL0CFS1ZmViXi9qH0c5bbnfpVUz1gBMssy7o?=
 =?us-ascii?Q?YjdUR31Bp2x6d03EiaRmyow=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5CC69866DFA68E45ACC8776451B255FA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18acd173-c1f6-4db2-6730-08d9ad14def8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:32:20.0049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fUfSBuglaBF1t00cSJfBxc68QmfTn/Jwa4rIyFgSEhhYeRDLP4qY1PK0BcHDTNN3xN6BLazP7tIdAsv4OAAfWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 01:39:16PM -0800, Colin Foster wrote:
> Utilize regmap instead of __iomem to perform indirect mdio access. This
> will allow for custom regmaps to be used by way of the mscc_miim_setup
> function.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/mdio/mdio-mscc-miim.c | 150 +++++++++++++++++++++---------
>  1 file changed, 105 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-ms=
cc-miim.c
> index 17f98f609ec8..f55ad20c28d5 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -14,6 +14,7 @@
>  #include <linux/of_mdio.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
> +#include <linux/regmap.h>
> =20
>  #define MSCC_MIIM_REG_STATUS		0x0
>  #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
> @@ -35,37 +36,47 @@
>  #define MSCC_PHY_REG_PHY_STATUS	0x4
> =20
>  struct mscc_miim_dev {
> -	void __iomem *regs;
> -	void __iomem *phy_regs;
> +	struct regmap *regs;
> +	struct regmap *phy_regs;
>  };
> =20
>  /* When high resolution timers aren't built-in: we can't use usleep_rang=
e() as
>   * we would sleep way too long. Use udelay() instead.
>   */
> -#define mscc_readl_poll_timeout(addr, val, cond, delay_us, timeout_us)	\
> -({									\
> -	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			\
> -		readl_poll_timeout_atomic(addr, val, cond, delay_us,	\
> -					  timeout_us);			\
> -	readl_poll_timeout(addr, val, cond, delay_us, timeout_us);	\
> +#define mscc_readx_poll_timeout(op, addr, val, cond, delay_us, timeout_u=
s)\
> +({									  \
> +	if (!IS_ENABLED(CONFIG_HIGH_RES_TIMERS))			  \
> +		readx_poll_timeout_atomic(op, addr, val, cond, delay_us,  \
> +					  timeout_us);			  \
> +	readx_poll_timeout(op, addr, val, cond, delay_us, timeout_us);	  \
>  })
> =20
> -static int mscc_miim_wait_ready(struct mii_bus *bus)
> +static int mscc_miim_status(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim =3D bus->priv;
> +	int val, err;
> +
> +	err =3D regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim status read error %d\n", err);
> +
> +	return val;
> +}
> +
> +static int mscc_miim_wait_ready(struct mii_bus *bus)
> +{
>  	u32 val;
> =20
> -	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> +	return mscc_readx_poll_timeout(mscc_miim_status, bus, val,
>  				       !(val & MSCC_MIIM_STATUS_STAT_BUSY), 50,
>  				       10000);
>  }
> =20
>  static int mscc_miim_wait_pending(struct mii_bus *bus)
>  {
> -	struct mscc_miim_dev *miim =3D bus->priv;
>  	u32 val;
> =20
> -	return mscc_readl_poll_timeout(miim->regs + MSCC_MIIM_REG_STATUS, val,
> +	return mscc_readx_poll_timeout(mscc_miim_status, bus, val,
>  				       !(val & MSCC_MIIM_STATUS_STAT_PENDING),
>  				       50, 10000);
>  }
> @@ -73,22 +84,30 @@ static int mscc_miim_wait_pending(struct mii_bus *bus=
)
>  static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
>  {
>  	struct mscc_miim_dev *miim =3D bus->priv;
> +	int ret, err;
>  	u32 val;
> -	int ret;
> =20
>  	ret =3D mscc_miim_wait_pending(bus);
>  	if (ret)
>  		goto out;
> =20
> -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
> -	       miim->regs + MSCC_MIIM_REG_CMD);
> +	err =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> +			   MSCC_MIIM_CMD_OPR_READ);
> +
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim write cmd reg error %d\n", err);
> =20
>  	ret =3D mscc_miim_wait_ready(bus);
>  	if (ret)
>  		goto out;
> =20
> -	val =3D readl(miim->regs + MSCC_MIIM_REG_DATA);
> +	err =3D regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> +
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);
> +
>  	if (val & MSCC_MIIM_DATA_ERROR) {
>  		ret =3D -EIO;
>  		goto out;
> @@ -103,18 +122,20 @@ static int mscc_miim_write(struct mii_bus *bus, int=
 mii_id,
>  			   int regnum, u16 value)
>  {
>  	struct mscc_miim_dev *miim =3D bus->priv;
> -	int ret;
> +	int err, ret;
> =20
>  	ret =3D mscc_miim_wait_pending(bus);
>  	if (ret < 0)
>  		goto out;
> =20
> -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> -	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> -	       MSCC_MIIM_CMD_OPR_WRITE,
> -	       miim->regs + MSCC_MIIM_REG_CMD);
> +	err =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> +			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> +			   MSCC_MIIM_CMD_OPR_WRITE);
> =20
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim write error %d\n", err);
>  out:
>  	return ret;
>  }
> @@ -122,24 +143,35 @@ static int mscc_miim_write(struct mii_bus *bus, int=
 mii_id,
>  static int mscc_miim_reset(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim =3D bus->priv;
> +	int err;
> =20
>  	if (miim->phy_regs) {
> -		writel(0, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
> -		writel(0x1ff, miim->phy_regs + MSCC_PHY_REG_PHY_CFG);
> +		err =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> +		if (err < 0)
> +			WARN_ONCE(1, "mscc reset set error %d\n", err);
> +
> +		err =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> +		if (err < 0)
> +			WARN_ONCE(1, "mscc reset clear error %d\n", err);
> +
>  		mdelay(500);
>  	}
> =20
>  	return 0;
>  }
> =20
> -static int mscc_miim_probe(struct platform_device *pdev)
> +static const struct regmap_config mscc_miim_regmap_config =3D {
> +	.reg_bits	=3D 32,
> +	.val_bits	=3D 32,
> +	.reg_stride	=3D 4,
> +};
> +
> +static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
> +			   struct regmap *mii_regmap, struct regmap *phy_regmap)
>  {
> -	struct mscc_miim_dev *dev;
> -	struct resource *res;
> -	struct mii_bus *bus;
> -	int ret;
> +	struct mscc_miim_dev *miim;
> =20
> -	bus =3D devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
> +	bus =3D devm_mdiobus_alloc_size(dev, sizeof(*miim));
>  	if (!bus)
>  		return -ENOMEM;
> =20
> @@ -147,26 +179,54 @@ static int mscc_miim_probe(struct platform_device *=
pdev)
>  	bus->read =3D mscc_miim_read;
>  	bus->write =3D mscc_miim_write;
>  	bus->reset =3D mscc_miim_reset;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
> -	bus->parent =3D &pdev->dev;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(dev));
> +	bus->parent =3D dev;
> +
> +	miim =3D bus->priv;
> +
> +	miim->regs =3D mii_regmap;
> +	miim->phy_regs =3D phy_regmap;
> +
> +	return 0;
> +}
> =20
> -	dev =3D bus->priv;
> -	dev->regs =3D devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> -	if (IS_ERR(dev->regs)) {
> +static int mscc_miim_probe(struct platform_device *pdev)
> +{
> +	struct regmap *mii_regmap, *phy_regmap;
> +	void __iomem *regs, *phy_regs;
> +	struct mscc_miim_dev *dev;
> +	struct mii_bus *bus;
> +	int ret;
> +
> +	regs =3D devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> +	if (IS_ERR(regs)) {
>  		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
> -		return PTR_ERR(dev->regs);
> +		return PTR_ERR(regs);
>  	}
> =20
> -	/* This resource is optional */
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (res) {
> -		dev->phy_regs =3D devm_ioremap_resource(&pdev->dev, res);
> -		if (IS_ERR(dev->phy_regs)) {
> -			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
> -			return PTR_ERR(dev->phy_regs);
> -		}
> +	mii_regmap =3D devm_regmap_init_mmio(&pdev->dev, regs,
> +					   &mscc_miim_regmap_config);
> +
> +	if (IS_ERR(mii_regmap)) {
> +		dev_err(&pdev->dev, "Unable to create MIIM regmap\n");
> +		return PTR_ERR(mii_regmap);
>  	}
> =20
> +	phy_regs =3D devm_platform_ioremap_resource(pdev, 1);
> +	if (IS_ERR(dev->phy_regs)) {
> +		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
> +		return PTR_ERR(dev->phy_regs);
> +	}
> +
> +	phy_regmap =3D devm_regmap_init_mmio(&pdev->dev, phy_regs,
> +					   &mscc_miim_regmap_config);
> +	if (IS_ERR(phy_regmap)) {
> +		dev_err(&pdev->dev, "Unable to create phy register regmap\n");
> +		return PTR_ERR(dev->phy_regs);
> +	}
> +
> +	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);

You're ignoring potential errors here.

> +
>  	ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
> --=20
> 2.25.1
>=
