Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3D6348B1D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhCYIF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:05:26 -0400
Received: from mail-eopbgr00056.outbound.protection.outlook.com ([40.107.0.56]:43241
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhCYIFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:05:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVR3TOP8+uxVEpnwqK3LWYPPs7hLmbVv2ez9Z11QrWwMu0ZamC3amUG+GbhxybuajqtDYSoYBpTWcNS2Hve2GDSB+b08ZskFdIB5zjnhRqgdF2cADXv3LhMioezssrwWldCXObhbnkKLtCvZXu3R/2TCZ7d+g/eUs5tteDRKVK0L+rOWvLK4DV6tX33PzQOVt5mWiO9d99NeZV4XbeEbW6Npn7jSF/OmZB7bCnBt7ho4OyZJp/Md7EstIenfGjRh/mVqnHO6132vAsZGG2XIlzYAyTewlDTn9vd99giisa16UN/RXKtzGVXH1zUOXEDXGnRhXnrgayByZyT12FxsLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISTx2WzrDCgMo2aTSVbMqNmnzzvtW0kr1AdmEt5JlHE=;
 b=Fq7rnugWuzQm+FA30Xp3RCxt2WI8J1aWAx4+LHuERC+KIPR7wNOp1r6my2MZuikD9M4TpZCC3UPt7v1omt+fG4jfyk8hTLvuLDnjlnwNVDAe9p0JWqoroYxLrcy2QpKy7jZhbdeluaQIRH94UKNh3HRZXAsge5eaYZS56N77vJ2l35PFWqeO+Lil9vlVZNeh+h4Vsd8N7OfUt5GSgDO3fesbbvqrgo0tGpYnLSS3mOab2bX1+S0pnRnIoRG3DpYjkCK2Hs4F/Hv/DeXHX71VEq21lvUwIL6apNjD0xXZ0islWA3gNHaAJhEb5n01k886uvERdSzo2YFDxZp+gTZpFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISTx2WzrDCgMo2aTSVbMqNmnzzvtW0kr1AdmEt5JlHE=;
 b=QLp1IUdyiFVzrkrw3gcl6A5LK0oyP2NXgzfgLe83DuO7acQ0dRKtj9DPXGISgxVArjXSU4mjZI8eaUiE4PM3qAMBAjrrPayx5LNAdyK2mCoWI7sw9bvKRtfPuBsT2gnLlwz+fEq320RzuSlT7t5ZBPxH3LDuE4QxxAAfUbHRuS8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4955.eurprd04.prod.outlook.com (2603:10a6:10:19::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 08:04:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 08:04:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: FEC unbind/bind feature
Thread-Topic: FEC unbind/bind feature
Thread-Index: AdchTA4mhHE+X6FhQBmQJxJLMagesA==
Date:   Thu, 25 Mar 2021 08:04:58 +0000
Message-ID: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37b23b39-5b66-4ff0-69a5-08d8ef64aee4
x-ms-traffictypediagnostic: DB7PR04MB4955:
x-microsoft-antispam-prvs: <DB7PR04MB4955BA91F4C1D5EFFB5F0DAAE6629@DB7PR04MB4955.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1V+wu53t7hEgPK0G3IXqekxXCF6DBDl8vMOzjwhj6XyYrrx/QoLehAcxQcw3uTz300vC1D08wZVEplcjfatZPA9tuDfj4azD+fM6gO/QTixifH5tEspqF+Aib948y/m4Q18so8zEmBZ0EiDSl1dUg81IsBuJ0l7KJEa8TGN120s2tHiX27PC7l3gIyNoxzqR0EA15atSd5O8g3JZTc7DvJKTJzc5w5oJ1fcP05XWzN4r6Z3pp9jT9p8iS/OMYgKOV+RRjL9f353IXvrzkLQBNTkbMHm5ElLK0xHMi5O5yEeu0cBwpbx3Xmc4fa8Jaax30TOnI83ZAqwK5zzjkaAf5r2O9GyUo6ieArAQBZ1Wk/YvMGlsne5mP6nIaLN56hvW9opEl5tgMcImWto0J+x/oNqFSTEySNBAGFm51ahM3nPechwqt24UcKmikFriSfnBovxEeK41wtdbVX93x8ya3RkZMpLFtqxmh9FWEM8tt8326kaAsbB8SvOO31bhZXq8G11qqpqkC9EmB0SUIQKCCnZvP5AZx/n+6boZ6bV4eR39c2mDNP7UbDohiGNl1dCVl9lsMSP9RDWN25hqD/GUH0icJvi/xEXAE7UovKtVBFshS2jbW/RjJfQ7fxpdJzXE4ZfR5k3/lQWXEt1hPvmBrhoEOfta8gBLb7eZIo2Dxo8NvauPrkjnXhfhbLpeBONo9flyCFjyV3yS0cDNdaDCfB9YmuNv1XBHmJOFzx6xOA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(8676002)(8936002)(3480700007)(26005)(38100700001)(186003)(86362001)(71200400001)(4326008)(83380400001)(110136005)(76116006)(66556008)(478600001)(66446008)(7696005)(66476007)(6506007)(5660300002)(64756008)(84040400003)(66946007)(9686003)(55016002)(316002)(33656002)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gjp3rsdo7DUWN0M+fv56NEqIVZQfklmv2FaN7SwH0D3nMwOputYdnR+saF4n?=
 =?us-ascii?Q?Oan0lQ19mUI7HmjHn0WmqPfu24Vw8nkghBsoByA3CbyIL0FRVL18s7827kHQ?=
 =?us-ascii?Q?j4PgAHYKcqsayijsXmeiAKtqzhRAyQXq4Q5EzhkZ4MQJuWDawRO++LFdhZy+?=
 =?us-ascii?Q?AQ+JFla9pqWkYjrbeuDDXZzzR/u4EYfSFxtDlfb/AHy0Zvxz2u5+sBDwDMBb?=
 =?us-ascii?Q?JbxvAJuBoPQuqRLdV1ULMfyHCn7/64WocyEaIs2Usrb3SryhNaMtznlU1HQr?=
 =?us-ascii?Q?zPFcsV1mauWMWufpTc3/yBWBe4erOmiLPcW3IM9eVEHqn9BUDbbgtEjFEqTP?=
 =?us-ascii?Q?hqLv44Ub9eSV9v8sr1GiEfDDRT1c8Mrjxgztrmv0cAgTcr3smK7R9jcdmfpE?=
 =?us-ascii?Q?NFfJipLVHqETsNKP9pGdOvoq2rnbxxdD3LAmmpgk0JW8EmYpdIoBkWKfpevz?=
 =?us-ascii?Q?3uQzcWrysGy0Pej1EK4/pp+AYTSvVXmJowa9n0cBL0d7n/AGSfIS4DpALg/s?=
 =?us-ascii?Q?WDFaXbzpdRgcjytoa6d2XMFp+ur2xa8GvmbU3FAlhQVQUhldcvepffvlyzzb?=
 =?us-ascii?Q?Sq0C41E/goP80/6+supbilEzJsRvPYZ6F09z1vKx03aR2n72e8zep6dZghcs?=
 =?us-ascii?Q?/ETq++jlVSifo2xjnk5JFZDMj3nvPoPsbEeBa0C/txl4OiKUobzj9xZ5j4m0?=
 =?us-ascii?Q?Nj9tOrDm5HpXQCXSmySqjG2SZwvKLjZ7zGzPOOfJbolaqUaEJYc20Exfb90d?=
 =?us-ascii?Q?8U+3Dv6FXLJ/3BnpKGJWIAtSKur+KW0uC3dm8F8ii4EjRrJclEdf8AfUHF15?=
 =?us-ascii?Q?2x2jGRIaf+4k6hXvvnxj0AUAzze4n2Bw4GYYm5XuPoQ50ou5D+sgGDkI61We?=
 =?us-ascii?Q?4JFUhfmew6dsUm5X3gY0XCig1i78Ps06UoLw3mwYQcIgJ/Ob6ztzRDa0juPQ?=
 =?us-ascii?Q?tahFknSledA9ZkpilHsWGWVDbalgVQYSvgJIRoqv+Ki3t53/+2ZlKktFXpBS?=
 =?us-ascii?Q?vq2aSgb/Es+vH/DSclmGXyUk9RPTWRu2fu9007PgJjSMAqhk+rPUp9CBpDvy?=
 =?us-ascii?Q?TkHFZFMP41Z81Nzby0EZuvJpJx4JIVQ4H/QFmH3UqApVN6eMLLBX8P8iqNn0?=
 =?us-ascii?Q?eKjoTzwX8Y1/+lKhARS7yQmnkrAIEFHxlT18spllDzu6/f1gQxFfXyjfiLc9?=
 =?us-ascii?Q?d86dicHCyH7oJwh/9Z6Kk1zX9fv/Vb0suI1IDUFgZBERFn2M6h9+/yYvp6Lf?=
 =?us-ascii?Q?+y3Fw863DVTmwFAgU9MlgOujLZPnWROm5JcpphHQyDfIbV+fukimQl6laY6M?=
 =?us-ascii?Q?KenuWjrMq0aBkVP+F3GUShfM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b23b39-5b66-4ff0-69a5-08d8ef64aee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 08:04:58.1315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S9elLDRkANYsJA0Dq/1NTByyoKUSDlVT+ozUo95f+vWLxQkTzF+LTYoaVMMeORB8x/LeQQW3NUUfKKyWogTCrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Andrew, Florian, Heiner

You are all Ethernet MDIO bus and PHY experts, I have some questions may ne=
ed your help, thanks a lot in advance.

For many board designs, if it has dual MAC instances, they always share one=
 MDIO bus to save PINs. Such as, i.MX6UL EVK board:

&fec1 {
	pinctrl-names =3D "default";
	pinctrl-0 =3D <&pinctrl_enet1>;
	phy-mode =3D "rmii";
	phy-handle =3D <&ethphy0>;
	phy-supply =3D <&reg_peri_3v3>;
	status =3D "okay";
};

&fec2 {
	pinctrl-names =3D "default";
	pinctrl-0 =3D <&pinctrl_enet2>;
	phy-mode =3D "rmii";
	phy-handle =3D <&ethphy1>;
	phy-supply =3D <&reg_peri_3v3>;
	status =3D "okay";

	mdio {
		#address-cells =3D <1>;
		#size-cells =3D <0>;

		ethphy0: ethernet-phy@2 {
			compatible =3D "ethernet-phy-id0022.1560";
			reg =3D <2>;
			micrel,led-mode =3D <1>;
			clocks =3D <&clks IMX6UL_CLK_ENET_REF>;
			clock-names =3D "rmii-ref";

		};

		ethphy1: ethernet-phy@1 {
			compatible =3D "ethernet-phy-id0022.1560";
			reg =3D <1>;
			micrel,led-mode =3D <1>;
			clocks =3D <&clks IMX6UL_CLK_ENET2_REF>;
			clock-names =3D "rmii-ref";
		};
	};
};

For FEC driver now, there is a patch from Fabio to prevent unbind/bind feat=
ure since dual FEC controllers share one MDIO bus. (https://git.kernel.org/=
pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/net/ethernet/fr=
eescale/fec_main.c?h=3Dnext-20210324&id=3D272bb0e9e8cdc76e04baeefa0cd43019d=
aa0841b)
If we unbind fec2 and then fec1 can't work since MDIO bus is controlled by =
FEC1, FEC2 can't use it independently.

My question is that if we want to implement unbind/bind feature, what need =
we do? It seems to abstract an independent MDIO bus for dual FEC instances.=
 I look at the MDIO dt bindings, it seems support such case as it has "reg"=
 property. (Documentation/devicetree/bindings/net/mdio.yaml)

Is there any implements existing in the Linux kernel for a reference? From =
your opinions, do you think it is necessary to improve it?

Best Regards,
Joakim Zhang

