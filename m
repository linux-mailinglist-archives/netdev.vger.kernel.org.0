Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355C14644D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfFNQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:35:06 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:55556
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfFNQfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 12:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uzxd1RSFLxoj4lrnxwyHX0XXk+m5+2uW/4XViLk+V0=;
 b=E968xKEU5ov/mdgBInFkFD84eZ484MPdW4DQl0pceCNkIfy42sA6M82+7MvLq40Bfo7ckhmNhcayP2UZ/AV3T8Zh+nhZfN5k/GJBGIJN314Scsnrqj02RLgeEswZnY2XDDQC78MRSEUsoO3qkGfBtNoQdRvJQS3pTfj1ZSzMsJY=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3887.eurprd04.prod.outlook.com (52.134.17.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 16:34:59 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 16:34:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Thread-Topic: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Thread-Index: AQHVIkOic0VlYNvv5k+vuQS/+20Wvqaa8RGAgABJPsA=
Date:   Fri, 14 Jun 2019 16:34:59 +0000
Message-ID: <VI1PR0402MB280076275F4B8343B4E8BC2EE0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
 <20190614102033.ae427mm7jh73wwkv@shell.armlinux.org.uk>
In-Reply-To: <20190614102033.ae427mm7jh73wwkv@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a67648f-bef1-4546-9f88-08d6f0e63e4c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3887;
x-ms-traffictypediagnostic: VI1PR0402MB3887:
x-microsoft-antispam-prvs: <VI1PR0402MB38876DE366DC4CB4A3939916E0EE0@VI1PR0402MB3887.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(346002)(396003)(199004)(189003)(68736007)(76176011)(6506007)(229853002)(30864003)(8936002)(478600001)(6916009)(44832011)(486006)(25786009)(7736002)(54906003)(52536014)(81166006)(33656002)(53936002)(476003)(186003)(305945005)(6246003)(81156014)(8676002)(102836004)(99286004)(66556008)(14454004)(5660300002)(14444005)(256004)(2906002)(73956011)(86362001)(316002)(66476007)(64756008)(74316002)(66946007)(71190400001)(55016002)(6116002)(4326008)(3846002)(66066001)(66446008)(71200400001)(7696005)(9686003)(76116006)(6436002)(11346002)(26005)(446003)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3887;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r1oJadELBUn1V43i5xZerGpb2Msk0+NlyqUl7WZRO5eEbi7otv6BX4qXpydQ5W8u5vgtTToCDK/5u5MTerZbzPZkuRcXB38R3CaGvUC+msJGt89ix9uKtR6QsAHP27fdhlk8dgq3kSJE5T+wvmEdR/0FTn1T91Xm7cLSifzrG1GJ3JWKkHedFWfScHdiei3gmquO4oP8iGcOCD+M7iSqixI3wTx+ExmXbYDdFCiRaSTwdUzGgepnl2s2Q1HYDcypxxufvqYmGiEsfJAAfj+Htsozp73eNsAIeFzM6B65DUNthRjHRl0vbxdfUWoGjz0lw15IgyKG6Fj7DdhIcjGjWqafytq3mhsQeD0Q+UaYLUkshKI5CXQ/7Nl+cpVlH+mr6oeNP1lyx2x+txNE7jLXl2gK+rOlqQzsuQsOmGmjuLs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a67648f-bef1-4546-9f88-08d6f0e63e4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 16:34:59.6105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3887
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
>=20
> On Fri, Jun 14, 2019 at 02:55:51AM +0300, Ioana Ciornei wrote:
> > The dpaa2-mac driver binds to DPAA2 DPMAC objects, dynamically
> > discovered on the fsl-mc bus. It acts as a proxy between the PHY
> > management layer and the MC firmware, delivering any configuration
> > changes to the firmware and also setting any new configuration
> > requested though PHYLINK.
> >
> > A in-depth view of the software architecture and the implementation
> > can be found in
> > 'Documentation/networking/device_drivers/freescale/dpaa2/dpmac-
> driver.rst'.
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  MAINTAINERS                                      |   7 +
> >  drivers/net/ethernet/freescale/dpaa2/Kconfig     |  13 +
> >  drivers/net/ethernet/freescale/dpaa2/Makefile    |   2 +
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 541
> > +++++++++++++++++++++++
> >  4 files changed, 563 insertions(+)
> >  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > dd247a059889..a024ab2b2548 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4929,6 +4929,13 @@ S:	Maintained
> >  F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp*
> >  F:	drivers/net/ethernet/freescale/dpaa2/dprtc*
> >
> > +DPAA2 MAC DRIVER
> > +M:	Ioana Ciornei <ioana.ciornei@nxp.com>
> > +L:	netdev@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
> > +F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
> > +
> >  DPT_I2O SCSI RAID DRIVER
> >  M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> >  L:	linux-scsi@vger.kernel.org
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > index 8bd384720f80..4ffa666c0a43 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > +++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> > @@ -16,3 +16,16 @@ config FSL_DPAA2_PTP_CLOCK
> >  	help
> >  	  This driver adds support for using the DPAA2 1588 timer module
> >  	  as a PTP clock.
> > +
> > +config FSL_DPAA2_MAC
> > +	tristate "DPAA2 MAC / PHY proxy interface"
> > +	depends on FSL_MC_BUS
> > +	select MDIO_BUS_MUX_MMIOREG
> > +	select FSL_XGMAC_MDIO
> > +	select PHYLINK
> > +	help
> > +	  Prototype driver for DPAA2 MAC / PHY interface object.
> > +	  This driver works as a proxy between PHYLINK including phy drivers =
and
> > +	  the MC firmware.  It receives updates on link state changes from
> PHYLINK
> > +	  and forwards them to MC and receives interrupt from MC whenever a
> > +	  request is made to change the link state or configuration.
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile
> > b/drivers/net/ethernet/freescale/dpaa2/Makefile
> > index d1e78cdd512f..e96386ab23ea 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/Makefile
> > +++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
> > @@ -5,10 +5,12 @@
> >
> >  obj-$(CONFIG_FSL_DPAA2_ETH)		+=3D fsl-dpaa2-eth.o
> >  obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+=3D fsl-dpaa2-ptp.o
> > +obj-$(CONFIG_FSL_DPAA2_MAC)		+=3D fsl-dpaa2-mac.o
> >
> >  fsl-dpaa2-eth-objs	:=3D dpaa2-eth.o dpaa2-ethtool.o dpni.o
> >  fsl-dpaa2-eth-${CONFIG_DEBUG_FS} +=3D dpaa2-eth-debugfs.o
> >  fsl-dpaa2-ptp-objs	:=3D dpaa2-ptp.o dprtc.o
> > +fsl-dpaa2-mac-objs	:=3D dpaa2-mac.o dpmac.o
> >
> >  # Needed by the tracing framework
> >  CFLAGS_dpaa2-eth.o :=3D -I$(src)
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > new file mode 100644
> > index 000000000000..145ab4771788
> > --- /dev/null
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> > @@ -0,0 +1,541 @@
> > +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> > +/* Copyright 2015 Freescale Semiconductor Inc.
> > + * Copyright 2018-2019 NXP
> > + */
> > +#include <linux/module.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/msi.h>
> > +#include <linux/rtnetlink.h>
> > +#include <linux/if_vlan.h>
> > +
> > +#include <net/netlink.h>
> > +#include <uapi/linux/if_bridge.h>
> > +
> > +#include <linux/of.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/of_net.h>
> > +#include <linux/phylink.h>
> > +#include <linux/notifier.h>
> > +
> > +#include <linux/fsl/mc.h>
> > +
> > +#include "dpmac.h"
> > +#include "dpmac-cmd.h"
> > +
> > +#define to_dpaa2_mac_priv(phylink_config) \
> > +	container_of(config, struct dpaa2_mac_priv, phylink_config)
> > +
> > +struct dpaa2_mac_priv {
> > +	struct fsl_mc_device *mc_dev;
> > +	struct dpmac_attr attr;
> > +	struct dpmac_link_state state;
> > +	u16 dpmac_ver_major;
> > +	u16 dpmac_ver_minor;
> > +
> > +	struct phylink *phylink;
> > +	struct phylink_config phylink_config;
> > +	struct ethtool_link_ksettings kset;
> > +};
> > +
> > +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if) {
> > +	switch (eth_if) {
> > +	case DPMAC_ETH_IF_RGMII:
> > +		return PHY_INTERFACE_MODE_RGMII;
> > +	case DPMAC_ETH_IF_XFI:
> > +		return PHY_INTERFACE_MODE_10GKR;
> > +	case DPMAC_ETH_IF_USXGMII:
> > +		return PHY_INTERFACE_MODE_USXGMII;
>=20
> No support for SGMII nor the 802.3z modes?

The Serdes has support for both of them but the driver does not at the mome=
nt.

>=20
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static int cmp_dpmac_ver(struct dpaa2_mac_priv *priv,
> > +			 u16 ver_major, u16 ver_minor)
> > +{
> > +	if (priv->dpmac_ver_major =3D=3D ver_major)
> > +		return priv->dpmac_ver_minor - ver_minor;
> > +	return priv->dpmac_ver_major - ver_major; }
> > +
> > +struct dpaa2_mac_link_mode_map {
> > +	u64 dpmac_lm;
> > +	enum ethtool_link_mode_bit_indices ethtool_lm; };
> > +
> > +static const struct dpaa2_mac_link_mode_map dpaa2_mac_lm_map[] =3D {
> > +	{DPMAC_ADVERTISED_10BASET_FULL,
> ETHTOOL_LINK_MODE_10baseT_Full_BIT},
> > +	{DPMAC_ADVERTISED_100BASET_FULL,
> ETHTOOL_LINK_MODE_100baseT_Full_BIT},
> > +	{DPMAC_ADVERTISED_1000BASET_FULL,
> ETHTOOL_LINK_MODE_1000baseT_Full_BIT},
> > +	{DPMAC_ADVERTISED_10000BASET_FULL,
> > +ETHTOOL_LINK_MODE_10000baseT_Full_BIT},
>=20
> No half-duplex support?

Yes, no half-duplex.

>=20
> > +	{DPMAC_ADVERTISED_AUTONEG,
> ETHTOOL_LINK_MODE_Autoneg_BIT}, };
> > +
> > +static void link_mode_phydev2dpmac(unsigned long *phydev_lm,
> > +				   u64 *dpmac_lm)
> > +{
> > +	enum ethtool_link_mode_bit_indices link_mode;
> > +	int i;
> > +
> > +	*dpmac_lm =3D 0;
> > +	for (i =3D 0; i < ARRAY_SIZE(dpaa2_mac_lm_map); i++) {
> > +		link_mode =3D dpaa2_mac_lm_map[i].ethtool_lm;
> > +		if (linkmode_test_bit(link_mode, phydev_lm))
> > +			*dpmac_lm |=3D dpaa2_mac_lm_map[i].dpmac_lm;
> > +	}
> > +}
> > +
> > +static void dpaa2_mac_ksettings_change(struct dpaa2_mac_priv *priv) {
> > +	struct fsl_mc_device *mc_dev =3D priv->mc_dev;
> > +	struct dpmac_link_cfg link_cfg =3D { 0 };
> > +	int err, i;
> > +
> > +	err =3D dpmac_get_link_cfg(mc_dev->mc_io, 0,
> > +				 mc_dev->mc_handle,
> > +				 &link_cfg);
> > +
> > +	if (err) {
> > +		dev_err(&mc_dev->dev, "dpmac_get_link_cfg() =3D %d\n", err);
> > +		return;
> > +	}
> > +
> > +	phylink_ethtool_ksettings_get(priv->phylink, &priv->kset);
> > +
> > +	priv->kset.base.speed =3D link_cfg.rate;
> > +	priv->kset.base.duplex =3D !!(link_cfg.options &
> > +DPMAC_LINK_OPT_HALF_DUPLEX);
>=20
> What's the point of setting duplex to anything other than true here - eve=
rything
> I've read in this driver apart from the above indicates that there is no =
support for
> half duplex.

Yep, that's another mishap on my part. That should have been removed.

>=20
> > +
> > +	ethtool_link_ksettings_zero_link_mode(&priv->kset, advertising);
> > +	for (i =3D 0; i < ARRAY_SIZE(dpaa2_mac_lm_map); i++) {
> > +		if (link_cfg.advertising & dpaa2_mac_lm_map[i].dpmac_lm)
> > +			__set_bit(dpaa2_mac_lm_map[i].ethtool_lm,
> > +				  priv->kset.link_modes.advertising);
> > +	}
> > +
> > +	if (link_cfg.options & DPMAC_LINK_OPT_AUTONEG) {
> > +		priv->kset.base.autoneg =3D AUTONEG_ENABLE;
> > +		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > +			  priv->kset.link_modes.advertising);
> > +	} else {
> > +		priv->kset.base.autoneg =3D AUTONEG_DISABLE;
> > +		__clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > +			    priv->kset.link_modes.advertising);
> > +	}
> > +
> > +	phylink_ethtool_ksettings_set(priv->phylink, &priv->kset);
>=20
> What if this returns an error?  There seems to be no way to communicate f=
ailure
> back through the firmware.

That's right, we do not have a way of signaling back the failure to the fir=
mware.

>=20
> > +static void dpaa2_mac_validate(struct phylink_config *config,
> > +			       unsigned long *supported,
> > +			       struct phylink_link_state *state) {
> > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > +
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set_port_modes(mask);
> > +
> > +	switch (state->interface) {
> > +	case PHY_INTERFACE_MODE_10GKR:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 10000baseT_Full);
> > +		break;
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 10000baseT_Full);
>=20
> Consider using the newer linkmode_set_bit() etc interfaces here.

Sure.

>=20
> > +		break;
> > +	default:
> > +		goto empty_set;
> > +	}
> > +
> > +	bitmap_and(supported, supported, mask,
> __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	bitmap_and(state->advertising, state->advertising, mask,
> > +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +
> > +	link_mode_phydev2dpmac(supported, &dpmac_state->supported);
> > +	link_mode_phydev2dpmac(state->advertising,
> > +&dpmac_state->advertising);
>=20
> This is not correct.  phylink will make calls to this function to enquire=
 whether
> something is supported or not, it isn't strictly used to say "this is wha=
t we are
> going to use", so storing these does not reflect the current state.

We can update these only on a mac_config.
>=20
> > +
> > +	return;
> > +
> > +empty_set:
> > +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS); }
> > +
> > +static void dpaa2_mac_config(struct phylink_config *config, unsigned i=
nt
> mode,
> > +			     const struct phylink_link_state *state) {
> > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > +	struct device *dev =3D &priv->mc_dev->dev;
> > +	int err;
> > +
> > +	if (state->speed =3D=3D SPEED_UNKNOWN && state->duplex =3D=3D
> DUPLEX_UNKNOWN)
> > +		return;
> > +
> > +	dpmac_state->up =3D !!state->link;
> > +	if (dpmac_state->up) {
> > +		dpmac_state->rate =3D state->speed;
> > +
> > +		if (!state->duplex)
> > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_HALF_DUPLEX;
> > +		else
> > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_HALF_DUPLEX;
> > +
> > +		if (state->an_enabled)
> > +			dpmac_state->options |=3D
> DPMAC_LINK_OPT_AUTONEG;
> > +		else
> > +			dpmac_state->options &=3D
> ~DPMAC_LINK_OPT_AUTONEG;
> > +	}
>=20
> Apart from my comments for the above in reply to Andrew, you can store th=
e
> "advertising" mask here.
>=20
> However, what is the point of the "dpmac_state->up =3D !!state->link"
> stuff (despite it being wrong as previously described) when you set dpmac=
_state-
> >up in the mac_link_up/mac_link_down functions below.
> This makes no sense to me.

Ok, so keep the last known value of the link until a .mac_link_{up/down} is=
 called and only them update it.
I'll change that.

>=20
> > +
> > +	err =3D dpmac_set_link_state(priv->mc_dev->mc_io, 0,
> > +				   priv->mc_dev->mc_handle, dpmac_state);
> > +	if (err)
> > +		dev_err(dev, "dpmac_set_link_state() =3D %d\n", err); }
> > +
> > +static void dpaa2_mac_link_up(struct phylink_config *config, unsigned =
int
> mode,
> > +			      phy_interface_t interface, struct phy_device *phy) {
> > +	struct dpaa2_mac_priv *priv =3D to_dpaa2_mac_priv(phylink_config);
> > +	struct dpmac_link_state *dpmac_state =3D &priv->state;
> > +	struct device *dev =3D &priv->mc_dev->dev;
> > +	int err;
> > +
> > +	dpmac_state->up =3D 1;
> > +	err =3D dpmac_set_link_state(priv->mc_dev->mc_io, 0,
> > +				   priv->mc_dev->mc_handle, dpmac_state);
> > +	if (err)
> > +		dev_err(dev, "dpmac_set_link_state() =3D %d\n", err);
>=20
> This is also very suspect - have you read the phylink documentation?
> The documentation details that there are some behavioural differences her=
e
> depending on the negotiation mode, but your code doesn't even look at tho=
se.
>=20
> Given that you're not handling those, I don't see how you expect SFP supp=
ort to
> work.  In fact, given that the validate callback doesn't make any mention=
 of
> SGMII, 1000BASEX, or 2500BASEX phy modes, I don't see how you expect this=
 to
> work with SFP.  Given that, I really question why you want to use phylink=
 rather
> than talking to phylib directly.

I am not handling the XFP/SFP+ support in this version of the driver since,=
 as you noticed, I am not accepting BASEX modes.
Nonetheless, I am not ruling out adding support for SFP on top of this. Thi=
s is one reason why we're using phylink.=20

Also, using phylib is not straight-forward either. The dpaa2-mac should fab=
ricate a net_device for each phy that it wants to connect to.
These net_device should be kept unregistered with the network core so that =
we don't see "MAC interfaces" in ifconfig.

>=20
> I get the overall impression from what I've seen so far that phylink is e=
ntirely
> unsuited to the structure of this implementation.
>=20
> phylinks purpose is to support hotpluggable PHYs on SFP modules where the
> MAC may be connected _directly_ to the SFP cage without an intervening PH=
Y,
> or if there is an intervening PHY, the PHY is completely transparent.  Fo=
r that to
> work, the interface modes that SFP modules support must be supported by t=
he
> MAC.
>=20
> I can't see a reason at the moment for you to use phylink.
>=20

Well, a phylib solution isn't cleaner either.=20

--
Ioana

