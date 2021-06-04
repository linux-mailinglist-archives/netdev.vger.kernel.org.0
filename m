Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBE439B89D
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFDMCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:02:08 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:3070
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230033AbhFDMCH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 08:02:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXFzZUg/mpCYyjLv4JP+Kd5WGSGCJRzorKrGOqrzIqGa/fKjy6ILuFjojteqEkaMs2xkWCoBpRLqs0hPLsBizJ+6WgpsciZ9V9L66E4lDi0Q6IQbojfxXlNZDSOPu+ehA9ddJN/PjZAOFidl6kjb7nh0EKlQJsqylvX0StQXZvNdcNmI3LmdEZd9S/tGo+TjGbrDEG7OoEzrDiw8ghnWCpN3ohMhMvJ4u5DAQYlBogQf3QlccWLuYIBaFvGoklcown5LUACliv2TpHZzwNf3DBHXDkMRgHSmDVf2/e7RliCOLFQzszoyuhJmNXHnrCGmxaJCY0W3r+ttETuZm6x84A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYeK7fKqpjod7nba01fyBAdXNBge+WwrD/cuvWkr9b8=;
 b=lKzaY2CM0aT+7jT1JsFMaC0KLYnW3v6No3aa2B/FGMPqH2O/pItodTO0jie1jgIOeKRR879EHZiNaXo+3J9dk26WDMd2wkmyh+bifEDc3CREY+d5rAqdHs+yCpx6E1jy4zNAwmWLv5R1YHFiyIGIwDUEMiYX7rsPiN6ShFhQBO01WGGObaZNtq15Uhh/6gZQRzNRxeuZe5HboEoI0v6+tlPvzWtYxhZAjd7lARi192qrqDKae7DdxsV1DPWm55P0znSM3ArYa8pekc7MNFYQItkA+VwjAaCaZlz2MW12WDMlWisixzHJg5M5lvszvL9fgNf5Dqqprk9dfr8Xy6tL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYeK7fKqpjod7nba01fyBAdXNBge+WwrD/cuvWkr9b8=;
 b=TzyUOskTM916CDD8K66rQAKrMP6zSGzUx4a4TX7F0oGaPXRg7OteaDFUz4r1drDPQ7g0WXMP6NWa4JjRyGoXtP44wwxUzQ1ECJwygAzDktL3rmb2dWB4Tu+eUkUXcRPeu6S+NedBGXzoe8usuzbmM5Ux1rydW5myOPUghazdrKE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 12:00:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:00:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "tee.min.tan@intel.com" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "vee.khee.wong@intel.com" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH net-next v5 2/3] net: pcs: add 2500BASEX support
 for Intel mGbE controller
Thread-Topic: [RESEND PATCH net-next v5 2/3] net: pcs: add 2500BASEX support
 for Intel mGbE controller
Thread-Index: AQHXWTEQHoD7ayfD+0m0+amygCRgjKsDv/yA
Date:   Fri, 4 Jun 2021 12:00:18 +0000
Message-ID: <20210604120017.gbpwm27jjwoi2b32@skbuf>
References: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
 <20210604105733.31092-3-michael.wei.hong.sit@intel.com>
In-Reply-To: <20210604105733.31092-3-michael.wei.hong.sit@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75bfdca5-da4c-44f6-c5eb-08d927505275
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-microsoft-antispam-prvs: <VI1PR0401MB2511793DADB59CC385AF771CE03B9@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3leoqyroWCe2eTQmU+RlEAiMf1soETbVHdTICxibLnv3o+kWtCLJiirHyC7LJfRH/y3w6Yac4j5BfBpdqd2wN9V+5OJCGfRwxVjyRgTGUO8txTsO5dAVjECfDk02M/EHSauxMEKzUxwv8VTGCfjWQma2z0phqGTs+FSRygQ+EWvkYih+5c/wDFxzk/5+9bqHy2BivbVeu837u9GYjvS6B81A8pjrzfDvpNa5betTIaDd+DcY5X/88oOEG270EjaJUeX9GcZrxxXRHfz06Apv/zgpk8xRpjDTzn9VdJdPS5eN1oB3eX9n2TD4CkC3C+bTGart8AbEsqFChsootGoKicyXz/+GCzPSo4PCvUzxCRXKkVwEA3eh8bieZ1Bt45grg+XsQYcRBWYqC3fYqQ72H2Txdly5yKJWsc4dxkYuNzfMa1PRlArSmhTuQyFJqUsRr8R7+Wffb5CY6V4gma9yRu7rKIOWciN1UqQ3En9PTPbedp/cjON96NBEI5rFPo5ml8qBKNinoD8NPRhYW6piyOGyQ9BVyP/OdcZpky3x9PtHSc+q9dPAZInDOe2+kS6GYt1bML4M+I4iPa7LtXPh+QxaBM2pxPmDhjvUcQYbY6z1FaShLzR9hmNiSK9paNKphyoCWqBzdR7QLeaN9GQDhgx2oab0QLEPbIGKL8dTJa4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(7916004)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(4326008)(2906002)(91956017)(64756008)(66946007)(66476007)(44832011)(66556008)(54906003)(76116006)(83380400001)(66446008)(33716001)(6486002)(316002)(186003)(9686003)(7416002)(6512007)(8936002)(6916009)(1076003)(8676002)(38100700002)(71200400001)(26005)(478600001)(86362001)(6506007)(5660300002)(122000001)(164013002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dsfYwm0Vj52lELxHmIPpLTeHJG+NWq0BfVZTTGFKFZvOZJshWhyEPCqOqVEJ?=
 =?us-ascii?Q?tX4nbZLqZ5gRpTwGHBp4Jtl0DBS8q+wUqe/BU2LnqydcN6COzMI+WxvY62qf?=
 =?us-ascii?Q?TSnyey3G4BTTwELtWovS23eIM0Vt0NCQl4gstpkfoWlg6LsGitjGliEeVods?=
 =?us-ascii?Q?c1fTjr2G3nOTNCh7Jmv4RQOt7kME0hiLGSsFCiGUzVeFRRs+kRVU46T95QBr?=
 =?us-ascii?Q?UuH0iSR+aPn8H0FPuu+BA2OCGWBCs5ifEdkdLQJ1l/budtTxgi9VbtUpbeew?=
 =?us-ascii?Q?qxlJaGZeqPzThML3cFPiuAi6WJO14ABN85UaesREvKzC1ROWAVBfQnsOTQ7F?=
 =?us-ascii?Q?2b+UaBBPgEalft6vI+iZ+1oUqN7afKC1z0NCg+ody9cisbRYLXp8ng+xr5ls?=
 =?us-ascii?Q?k1DgF1MxoitXq4Zmd0oa4dW66M1qLE/0FEBhr81bhTRqUoWlEMtkV2JDtbZq?=
 =?us-ascii?Q?Y8Uin1S3NJnDVzGlkevLObPtQXkw6WJOeBBLNz/B7ybsMXVz9x1XmGIXrDwo?=
 =?us-ascii?Q?uEd2AoFImX9cCdTZaK1pctfXZENIq60fkkfUxC4VD74mc/36ZsXce223eq4/?=
 =?us-ascii?Q?SeGckiE1zLy7JeU5LsLZqDdIm0SBWhMBOV3UP5s7zPppKrpC+pT490jd9f01?=
 =?us-ascii?Q?CIfBO/bqZ7BjVt5gFdJ/Qe7UdMfPr0kjaQ1ZSIMpuIyY+YHAwEmsSPxZefqM?=
 =?us-ascii?Q?scNbGskkjn+rRkUpKCesKMePRB7iteKLEiAswt4giV+EH2YhPCiRqK48dVXj?=
 =?us-ascii?Q?z08BfVqiWoKvVbgWBa6m+yrfQf70zm9hh0rF4GgRyiM5EMN6c434G6o6H+4a?=
 =?us-ascii?Q?k1BwZWsJmALNVtTktlRjUQfEKlL+4t/H16LXkJRWsU09HzSiEVYQPNG1q6uG?=
 =?us-ascii?Q?4xBaHRULiFQaNpUA3631+ZsAIYFfswCgjOn7ewtHUHDAz8nU4tYqDI9SIlTh?=
 =?us-ascii?Q?ud/2ywlC660xNrtAGOh840ElS8pH14ZOO5cAobYMG9XPOMHvK/FNG6nKgKdv?=
 =?us-ascii?Q?/AcvV9KOBzrOr4geXTantDKRbcXm7OWVgXlHJKvsdln/J4Wgf1SU75LeICRp?=
 =?us-ascii?Q?yuqq9TLCtpnUJJOKJ/rKRhgXJe4v+Mwx5kGvoJlzOcDaDZM7+MHfI+lMyilQ?=
 =?us-ascii?Q?Zo96uprNLybxp2ivagvU15ILwFAPUn8HGo4GoRGcjlbCxnsIOEeO0RUFu3L7?=
 =?us-ascii?Q?0Xaw1QD3n0XkyYU9Eoud5sJ2p7PNREijmEy2Ja0l5ZfNH9EKbg1veXPvG+Dp?=
 =?us-ascii?Q?fjzpCwqj5jJoI58y4EDx1fR022/krq2ke35C9BnAHz3Lm+MBU73fCSiebHZU?=
 =?us-ascii?Q?lHqx9gH4gTF3RuZLKOWNW+Ha?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <82F5F9870C4CB743A11DFD91B45EDFAE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75bfdca5-da4c-44f6-c5eb-08d927505275
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 12:00:18.3023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9BNI1nAGJ5KczeWff5fhGv+9M1pgMLZYVroletTFwPcez0dIrpVz1uw91fPFQpU8x/pwD5wOv6Ebg1lrDjMWwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 06:57:32PM +0800, Michael Sit Wei Hong wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
>=20
> XPCS IP supports 2500BASEX as PHY interface. It is configured as
> autonegotiation disable to cater for PHYs that does not supports 2500BASE=
X
> autonegotiation.
>=20
> v2: Add supported link speed masking.
> v3: Restructure to introduce xpcs_config_2500basex() used to configure th=
e
>     xpcs for 2.5G speeds. Added 2500BASEX specific information for
>     configuration.
> v4: Fix indentation error
>=20
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/pcs/pcs-xpcs.c   | 56 ++++++++++++++++++++++++++++++++++++
>  include/linux/pcs/pcs-xpcs.h |  1 +
>  2 files changed, 57 insertions(+)
>=20
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 34164437c135..98c4a3973402 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -57,9 +57,12 @@
> =20
>  /* Clause 37 Defines */
>  /* VR MII MMD registers offsets */
> +#define DW_VR_MII_MMD_CTRL		0x0000
>  #define DW_VR_MII_DIG_CTRL1		0x8000
>  #define DW_VR_MII_AN_CTRL		0x8001
>  #define DW_VR_MII_AN_INTR_STS		0x8002
> +/* Enable 2.5G Mode */
> +#define DW_VR_MII_DIG_CTRL1_2G5_EN	BIT(2)
>  /* EEE Mode Control Register */
>  #define DW_VR_MII_EEE_MCTRL0		0x8006
>  #define DW_VR_MII_EEE_MCTRL1		0x800b
> @@ -86,6 +89,11 @@
>  #define DW_VR_MII_C37_ANSGM_SP_1000		0x2
>  #define DW_VR_MII_C37_ANSGM_SP_LNKSTS		BIT(4)
> =20
> +/* SR MII MMD Control defines */
> +#define AN_CL37_EN		BIT(12)	/* Enable Clause 37 auto-nego */
> +#define SGMII_SPEED_SS13	BIT(13)	/* SGMII speed along with SS6 */
> +#define SGMII_SPEED_SS6		BIT(6)	/* SGMII speed along with SS13 */
> +
>  /* VR MII EEE Control 0 defines */
>  #define DW_VR_MII_EEE_LTX_EN		BIT(0)  /* LPI Tx Enable */
>  #define DW_VR_MII_EEE_LRX_EN		BIT(1)  /* LPI Rx Enable */
> @@ -161,6 +169,14 @@ static const int xpcs_sgmii_features[] =3D {
>  	__ETHTOOL_LINK_MODE_MASK_NBITS,
>  };
> =20
> +static const int xpcs_2500basex_features[] =3D {
> +	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +	ETHTOOL_LINK_MODE_Autoneg_BIT,
> +	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
> +	ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
> +	__ETHTOOL_LINK_MODE_MASK_NBITS,
> +};
> +

This is a general design comment, perhaps you could address this later,
but do keep it in mind:

I don't think the PCS has anything to do with whether the link will
support flow control.
Similarly, Aquantia (now Marvell) PHYs operating in 2500base-x mode are
capable of negotiating the copper-side link to 10/100/1000/2500 even if
the system-side link is fixed at 2500. The way this is achieved is by
the PHY emitting PAUSE frames towards the MAC in order to achieve rate
adaptation with the external link speed.
This is not completely standardized in phylink at the moment, but we
have systems where this works. My point is that maybe the PCS driver
isn't the most appropriate place to implement the phylink_validate
method - the MAC driver is almost always in the position to know better.

If you could move the xpcs validation inside stmmac I think that would
be an improvement. For example with the NXP SJA1105 patches that I am
going to send out for review soon, I am not calling xpcs_validate() at
all.

>  static const phy_interface_t xpcs_usxgmii_interfaces[] =3D {
>  	PHY_INTERFACE_MODE_USXGMII,
>  };
> @@ -177,11 +193,17 @@ static const phy_interface_t xpcs_sgmii_interfaces[=
] =3D {
>  	PHY_INTERFACE_MODE_SGMII,
>  };
> =20
> +static const phy_interface_t xpcs_2500basex_interfaces[] =3D {
> +	PHY_INTERFACE_MODE_2500BASEX,
> +	PHY_INTERFACE_MODE_MAX,
> +};
> +
>  enum {
>  	DW_XPCS_USXGMII,
>  	DW_XPCS_10GKR,
>  	DW_XPCS_XLGMII,
>  	DW_XPCS_SGMII,
> +	DW_XPCS_2500BASEX,
>  	DW_XPCS_INTERFACE_MAX,
>  };
> =20
> @@ -306,6 +328,7 @@ static int xpcs_soft_reset(struct mdio_xpcs_args *xpc=
s,
>  		dev =3D MDIO_MMD_PCS;
>  		break;
>  	case DW_AN_C37_SGMII:
> +	case DW_2500BASEX:
>  		dev =3D MDIO_MMD_VEND2;
>  		break;
>  	default:
> @@ -804,6 +827,28 @@ static int xpcs_config_aneg_c37_sgmii(struct mdio_xp=
cs_args *xpcs)
>  	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
>  }
> =20
> +static int xpcs_config_2500basex(struct mdio_xpcs_args *xpcs)
> +{
> +	int ret;
> +
> +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
> +	if (ret < 0)
> +		return ret;
> +	ret |=3D DW_VR_MII_DIG_CTRL1_2G5_EN;
> +	ret &=3D ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> +	ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +	ret &=3D ~AN_CL37_EN;
> +	ret |=3D SGMII_SPEED_SS6;
> +	ret &=3D ~SGMII_SPEED_SS13;
> +	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
> +}
> +
>  static int xpcs_do_config(struct mdio_xpcs_args *xpcs,
>  			  phy_interface_t interface, unsigned int mode)
>  {
> @@ -827,6 +872,11 @@ static int xpcs_do_config(struct mdio_xpcs_args *xpc=
s,
>  		if (ret)
>  			return ret;
>  		break;
> +	case DW_2500BASEX:
> +		ret =3D xpcs_config_2500basex(xpcs);
> +		if (ret)
> +			return ret;
> +		break;
>  	default:
>  		return -1;
>  	}
> @@ -1023,6 +1073,12 @@ static const struct xpcs_compat synopsys_xpcs_comp=
at[DW_XPCS_INTERFACE_MAX] =3D {
>  		.num_interfaces =3D ARRAY_SIZE(xpcs_sgmii_interfaces),
>  		.an_mode =3D DW_AN_C37_SGMII,
>  	},
> +	[DW_XPCS_2500BASEX] =3D {
> +		.supported =3D xpcs_2500basex_features,
> +		.interface =3D xpcs_2500basex_interfaces,
> +		.num_interfaces =3D ARRAY_SIZE(xpcs_2500basex_features),
> +		.an_mode =3D DW_2500BASEX,
> +	},
>  };
> =20
>  static const struct xpcs_id xpcs_id_list[] =3D {
> diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
> index 0860a5b59f10..4d815f03b4b2 100644
> --- a/include/linux/pcs/pcs-xpcs.h
> +++ b/include/linux/pcs/pcs-xpcs.h
> @@ -13,6 +13,7 @@
>  /* AN mode */
>  #define DW_AN_C73			1
>  #define DW_AN_C37_SGMII			2
> +#define DW_2500BASEX			3
> =20
>  struct xpcs_id;
> =20
> --=20
> 2.17.1
>=20
