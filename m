Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080A942D8AA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhJNMCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:02:20 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:20003
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230518AbhJNMCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 08:02:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gR/zwMWJVtMq5X4x/cARMzJE4s4AUDgrCe5a/IZ2mmrltc2N7+P+oAP6o/Jq60TY1w1oZShK1XH91FwMl7UsNVTgCngrRTQnMNA85655JS5GWIixJh/KYWTwGpAhJtAUPUcw+NZgXm2fw+waLtlCy5ySZvaiHPlBxjVWtaV6FTOORRU0SIR+6b1M5NTXu4PexbiDCjy8G4WyMYrwtl8VCbA+3khATVlt9ZO/+88sYs4QbQliOP/bd7yb5/gSknxPfSxz8D8OUEJHXzO5lhQ6USsPZc0881Eul6WBoDOeCBOkv3TSCl/vibXgbpnxpt7sZq+q+x8S3/6HxuwETo+Cag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkysimlIWMk163y79une/c0+w1yjhDyoMpldKlPM/Ww=;
 b=aAdWlfU75w7PcU8oRv3cA2j9SCyl/qrsZhhsSrYsCum8UOJR6zkEPVMoeOMyuzYaqyAgxtj5QhZtwAS43DXzWDDJQvhJngX2w2Reb7bE/1EPA39xENvD2fgTUYWEidXEDzXC/hL5CNqfD1vc7jdFblg8oeq8imbTglVabYRWO0XZ2PVZA1hLnuuc/NHRicGAa4kHCMU9yxU+eAtBl6riUqmYif5HMjjnHm3hZ3ovdPYtpskdC73YS6MN/RxOR+Cy5Vn/zeWlNSD6+ymEqM+pUg6NtycNTVAvZn203jbBVD0thGrHZm9/AqqEvOA/i97jABR2gvkcg4OETee5Z58Whw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkysimlIWMk163y79une/c0+w1yjhDyoMpldKlPM/Ww=;
 b=oZDsp2PZs8vteKAuDfH7ViY7sIZHwyMtV9nIxNoeUuIzBgC9vUUln/JzPRrLHown3R5Klr6wYHL5BhKeh7U362mOc2s8ACWmnf4s/sqEGa5R5s9urpVYniNRi5+70rCdy1EeRfiXr2GEDGCGrAhinOMeE8Ciu70Sb0K0PD5byT0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 12:00:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 12:00:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 6/6] net: dsa: sja1105: parse
 {rx,tx}-internal-delay-ps properties for RGMII delays
Thread-Topic: [PATCH net-next 6/6] net: dsa: sja1105: parse
 {rx,tx}-internal-delay-ps properties for RGMII delays
Thread-Index: AQHXwIEVq1/AgHYHDEKe3jQ+7QpyaqvRosgAgADCSAA=
Date:   Thu, 14 Oct 2021 12:00:11 +0000
Message-ID: <20211014120010.im3bvg6ga7i2423n@skbuf>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-7-vladimir.oltean@nxp.com>
 <20211013172448.2db3b99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013172448.2db3b99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9f4fc6a-d34c-44e4-a7be-08d98f0a2cc0
x-ms-traffictypediagnostic: VI1PR04MB4814:
x-microsoft-antispam-prvs: <VI1PR04MB4814F199C0E2160746D7B699E0B89@VI1PR04MB4814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AwVqnCNbKJF/1LOpKzvUB5EGfj0BPOmDm0NN3dVih/m1zPcMYJ70mS3xcJLglidg/Nzv2amju2eQEu273/SHEscX8WYqq6X1pL97JqqzXzYLCNw7+O8GHsjG5M20Qhq0uNyBd+6IUE+17DbqOZr2K3xk4jEhUwk7mouiiq1/xHRod0Xp8+xXSGnMtA2nerjIEKLlCSNhhGbuZgt0geWYR3nHZt6VHRnB6Lz5sYwC7Niynyr32LfrRaLTsDAiwK1gmwXjUHY/fLsVKeb3WZgtARtISpWaMg/tNE/Bww3TGWDs7tL3nWzp2jyvSPctSHmAHkoAo28bVwpvKxPE5JHHyu/RaoOVNAHyL0S1h11HQpPfmP9DuUXBW6Tke06PK5WNaZ7OcZohOZjeHBevXp25qwgPm/UitwltIEsbUQyzJWbMVQ/m7SYrY5o2okBcQWMdFhitX4BtN9yY0BNsS4UQv8yctON6W0qYBCDrBq+E/dck1XJ6IK9/WICpFHQFHIBiJEK2bm8TgQEZxPfbD9y4c4nOJiVxSGG5HNtP6qP8WVNtq6yYoNXC5nt4moYpWjWQjQidI/CuhJTqmtL9j8Filx+32FnObdQU/wha1nT0NAJZ6sKq07E4ivbOcEmtOhwxSdpAI+ufgEl9qLVyL8/tWo+9PNWztGzCZ650yfi2RCEEivhM0slprTKnBLFLczeYUJcNyz7BrjhEnG5cUMrCQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(38100700002)(5660300002)(316002)(66446008)(66946007)(64756008)(66556008)(44832011)(66476007)(8936002)(6506007)(38070700005)(7416002)(186003)(26005)(8676002)(71200400001)(508600001)(1076003)(54906003)(6916009)(4326008)(91956017)(76116006)(6512007)(6486002)(86362001)(2906002)(83380400001)(33716001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?XAPB+yYg+ulqDb9ux2Zwky/Mio2FbFvwqSEzLzvKdquLy1VI2yiSQlWa?=
 =?Windows-1252?Q?n0dURy9lCAkX4YL+EcnKUrNcBp58MK7QpYRKNMFLNJvxL3ds9wGAVutN?=
 =?Windows-1252?Q?kGYCt7u+Hn3sFmRrSylBbaCjVwR94IJ2GV72GgpgfPOjpWS7YGy2ll/0?=
 =?Windows-1252?Q?SF6180vCP1UIA4PHDgez8TrO83J5wGd8P1Fn/rGwxwPHrtvFIOUZLtJu?=
 =?Windows-1252?Q?1PzU9xQ6LSTWYSjXdB783rC8viKDssKDSrkQ7QQu2q9unuSEy1aMCNA5?=
 =?Windows-1252?Q?EoYDQ/h0K+EkECgvXT5Kf+gPHzav3Bk2JQQatgvNAxXeJZHOYIoY+ZD+?=
 =?Windows-1252?Q?Ho3Gc92fpd4MWh5/iL3smbR8aaSPIwfFQeky5EZWfbi8ja93mzIjS06j?=
 =?Windows-1252?Q?vGs7ydoToFj4Rpt0QiXEo13patsj2KAqCSrFlA2EdtG26P0j7mLannbu?=
 =?Windows-1252?Q?2j9Dbvku8NHS2Yni1XS1X6g5EZw+xxwIfD12DWQLMG4+OnW7O0LVeU0U?=
 =?Windows-1252?Q?etRJJRi7dxaibdKqklWZqlNM775xiICgPDViIku1HtDKhASXxpFe/ivt?=
 =?Windows-1252?Q?5Gr6sUaJ/vkBu7Tyueg35Xhjg63nBXQN8Qok/sAHQalPORBvZLZmqKaL?=
 =?Windows-1252?Q?ENMmAzEJvq7yJDy5EXtfV+DXOHKPLBAMCEe5N8K96RBp7RRSQrZkmj5T?=
 =?Windows-1252?Q?YdU2t6vwxf7IzzJrtLw1R+/jmx6oftSDsKFlyhesicpl65ZFYV4gEqo6?=
 =?Windows-1252?Q?GZSrIfPd+OwrErRwI6DeZBtJuWw+loolt/eLdbXX2TwujSy3FhOSrTvD?=
 =?Windows-1252?Q?Zxl/2ujYf+TewwmeKWj3TNH9KRAkN/Tkj55M7VAKSy1Mx7RFwVlLiKAV?=
 =?Windows-1252?Q?1b7DrIFM8J6g4PJsyR8Bwc5NjGmCtL9ajMD7E9QYrhWkZfEX7ecZtYSX?=
 =?Windows-1252?Q?DxRIpOCUpcIhkZrewkQ/TXrHgodsvOGs5e3IKRYBUE6D2ZunfZruYi1z?=
 =?Windows-1252?Q?q9xtTKXB+w2uTCv5BmOsWMUDbgqWSucPFZdUw23w6IHJc3G5DyMTsSwd?=
 =?Windows-1252?Q?UueNLoqzGZyQAqARulFqAYYXrGQgdH3Giv9suNPgnHH0WlSr86IjIZ8q?=
 =?Windows-1252?Q?GqB96fkTy8Y6apjZhjt6MvKkUID1HTsbpxVltObhgFOW3pk6EqIGSSI6?=
 =?Windows-1252?Q?LMGOf+A/QcY2hTZ1yKYc7FFKFmQvP/idgsigEYdmAsE+TGCASiLdKFo0?=
 =?Windows-1252?Q?PaXTit2Suw+JUCvmtJoEhEd9uVBhGdElDwAlZ1xJK0a38vplvMRe5UEZ?=
 =?Windows-1252?Q?ni9srZrWWeWgcgPeTuXlIFOHFWjn5hUSDdqZvdYCW140R9LdHh2G+H8t?=
 =?Windows-1252?Q?sxTk5AEr0AbeYys6ojAu2DvTdZR0S740ts7tJF8zzgRaZuiIxMi0KvBZ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <28CAFDAF059A324692B703DDBA1DB6F6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f4fc6a-d34c-44e4-a7be-08d98f0a2cc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 12:00:11.1305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a2RRF74/ve1k8B0H0VHgirv3v2KCIww8TbPPqheviAFUOvv+5ap063hO/hfS9mdA6i8UyhpmYGFjdu1tMgCHqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 05:24:48PM -0700, Jakub Kicinski wrote:
> Some take it or leave it comments, checkpatch pointed out some extra
> brackets so I had a look at the patch.
>=20
> On Thu, 14 Oct 2021 01:23:13 +0300 Vladimir Oltean wrote:
> > +	int rx_delay =3D -1, tx_delay =3D -1;
> > =20
> > +	if (!phy_interface_mode_is_rgmii(phy_mode))
> > +		return 0;
> > =20
> > +	of_property_read_u32(port_dn, "rx-internal-delay-ps", &rx_delay);
> > +	of_property_read_u32(port_dn, "tx-internal-delay-ps", &tx_delay);
>=20
> If I'm reading this right you're depending on delays being left as -1
> in case the property reads fail. Is this commonly accepted practice?

It works.

> Why not code it up as:
>=20
> 	u32 rx_delay;
>=20
> 	if (of_property_read_u32(...))
> 		rx_delay =3D 0;
> 	else if (rx_delay !=3D clamp(rx_delay, ...MIN, ...MAX)
> 		goto err;
>=20
> or some such?

"or some such" is not functionally equivalent.

This is what would be functionally equivalent, and following your
suggestion to check the return code of of_property_read_u32 instead of
assigning default values, and to use clamp() instead of open-coding the
bounds checks.

static int sja1105_parse_rgmii_delays(struct sja1105_private *priv, int por=
t,
				      struct device_node *port_dn)
{
	phy_interface_t phy_mode =3D priv->phy_mode[port];
	struct device *dev =3D &priv->spidev->dev;
	int rx_delay, tx_delay;
	int err_rx, err_tx;

	if (!phy_interface_mode_is_rgmii(phy_mode))
		return 0;

	err_rx =3D of_property_read_u32(port_dn, "rx-internal-delay-ps", &rx_delay=
);
	if (err_rx)
		rx_delay =3D 0;

	err_tx =3D of_property_read_u32(port_dn, "tx-internal-delay-ps", &tx_delay=
);
	if (err_tx)
		tx_delay =3D 0;

	if (err_rx && err_tx) {
		if (priv->fixed_link[port]) {
			dev_warn(dev,
				 "Port %d interpreting RGMII delay settings based on \"phy-mode\" prope=
rty, "
				 "please update device tree to specify \"rx-internal-delay-ps\" and "
				 "\"tx-internal-delay-ps\"",
				 port);

			if (phy_mode =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
			    phy_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
				rx_delay =3D 2000;

			if (phy_mode =3D=3D PHY_INTERFACE_MODE_RGMII_TXID ||
			    phy_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
				tx_delay =3D 2000;
		}
	} else {
		if ((rx_delay && rx_delay !=3D clamp(rx_delay, SJA1105_RGMII_DELAY_MIN_PS=
, SJA1105_RGMII_DELAY_MAX_PS)) ||
		    (tx_delay && tx_delay !=3D clamp(tx_delay, SJA1105_RGMII_DELAY_MIN_PS=
, SJA1105_RGMII_DELAY_MAX_PS))) {
			dev_err(dev,
				"port %d RGMII delay values out of range, must be between %d and %d ps\=
n",
				port, SJA1105_RGMII_DELAY_MIN_PS, SJA1105_RGMII_DELAY_MAX_PS);
			return -ERANGE;
		}
	}

	priv->rgmii_rx_delay_ps[port] =3D rx_delay;
	priv->rgmii_tx_delay_ps[port] =3D tx_delay;

	return 0;
}

>=20
> > +	if ((rx_delay && rx_delay < SJA1105_RGMII_DELAY_MIN_PS) ||
> > +	    (tx_delay && tx_delay < SJA1105_RGMII_DELAY_MIN_PS) ||
> > +	    (rx_delay > SJA1105_RGMII_DELAY_MAX_PS) ||
> > +	    (tx_delay > SJA1105_RGMII_DELAY_MAX_PS)) {
>=20
> nit: checkpatch says the brackets around the latter two are unnecessary,
>      just in case it's not for symmetry / on purpose

It is on purpose.=
