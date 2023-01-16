Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26BC66BEF3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjAPNNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjAPNMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:12:45 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FF76E90;
        Mon, 16 Jan 2023 05:10:04 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GD8btC2091938
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 13:08:38 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GD8VC11812363
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 14:08:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673874512; bh=u51T8JhZaB+UtD6WCIYFGpWmuR+VLPagGh+9tChQ2OE=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=OKNeNVbRlsrv5iu3xoklk7QHkWV9XoVb8xsb4pPDTMNGSwQ1mPjOlkL26FnfY5FvD
         a/iUpcGbahr6LD+0PLwObS0B1wEEe0F2XALN95fZDlzihYtuBljX1zsHXQawBQWK8u
         5j3optEwF1tYO9mIdivEw3qD5PArcDKvZZB33jZk=
Received: (nullmailer pid 372666 invoked by uid 1000);
        Mon, 16 Jan 2023 13:08:30 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Organization: m
References: <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
        <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
        <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
        <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
        <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
        <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
        <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
        <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
        <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
        <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
        <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
Date:   Mon, 16 Jan 2023 14:08:30 +0100
In-Reply-To: <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        (Frank Wunderlich's message of "Tue, 25 Oct 2022 10:03:23 +0200")
Message-ID: <87o7qy39v5.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Frank Wunderlich <frank-w@public-files.de> writes:

> apart from this little problem it works much better than it actually is s=
o imho more
> people should test it on different platforms.

Hello!  I've been banging my head against an MT7986 board with two
Maxlinear GPY211C phys for a while. One of those phys is connected to
port 5 of the MT7531 switch.  This is working perfectly.

The other GPY211C is connected to the second MT7986 mac.  This one is
giving me a headache...

I can only get the port to work at 2500Mb/s.  Changing the speed to
anything lower looks fine in ethtool etc, but traffic is blocked.

Not knowing the first thing about MACs and PHYs and such, my best guess
is that there is something wrong with the PCS config.

Now I am currently testing this on an older kernel (using OpenWrt -
booting mainline is not straight forward). But I have backported all the
patches which came out of this thread.  The resulting mtk_sgmii.c is
identical to the one currently in next-next, except for some additional
debug printk's.  Since this is a small file, I've attached my current
mtk_sgmii.c copy for reference.

The output of those printks when changing peer speed to to 1000Mb/s is:

[  363.099410] mtk_soc_eth 15100000.ethernet wan: Link is Down
[  365.189945] mtk_sgmii_select_pcs: id=3D1
[  365.193709] mtk_pcs_config: interface=3D4
[  365.197530] offset:0 0x140
[  365.197533] offset:4 0x4d544950
[  365.200237] offset:8 0x20
[  365.203365] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), link_=
timer=3D1600000,  sgm_mode=3D0x1, bmcr=3D0x0
[  365.215601] mtk_pcs_link_up: interface=3D4
[  365.219511] offset:0 0x140
[  365.219513] offset:4 0x4d544950
[  365.222204] offset:8 0x1
[  365.225328] mtk_pcs_link_up: sgm_mode=3D0x18
[  365.231940] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full -=
 flow control rx/tx


and when changing peer back to autoneg (i.e. 2500Mb/s):

[  878.939417] mtk_soc_eth 15100000.ethernet wan: Link is Down
[  883.099857] mtk_sgmii_select_pcs: id=3D1
[  883.103620] mtk_pcs_config: interface=3D22
[  883.107527] offset:0 0x140
[  883.107529] offset:4 0x4d544950
[  883.110234] offset:8 0x1
[  883.113363] mtk_pcs_config: rgc3=3D0x4, advertise=3D0x20 (changed), link=
_timer=3D10000000,  sgm_mode=3D0x0, bmcr=3D0x0
[  883.125686] mtk_pcs_link_up: interface=3D22
[  883.129683] offset:0 0x40140
[  883.129685] offset:4 0x4d544950
[  883.132550] offset:8 0x20
[  883.135687] mtk_soc_eth 15100000.ethernet wan: Link is Up - 2.5Gbps/Full=
 - flow control rx/tx


ethtool output looks as expected in both cases:

# ethtool wan
Settings for wan:
        Supported ports: [  ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseT/Full
        Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred slave
        master-slave status: slave
        Port: Twisted Pair
        PHYAD: 6
        Transceiver: external
        MDI-X: on (auto)
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_e=
rr
        Link detected: yes


# ethtool wan
Settings for wan:
        Supported ports: [  ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  100baseT/Full
                                             1000baseT/Full
                                             2500baseT/Full
        Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 2500Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred slave
        master-slave status: master
        Port: Twisted Pair
        PHYAD: 6
        Transceiver: external
        MDI-X: on (auto)
        Current message level: 0x000000ff (255)
                               drv probe link timer ifdown ifup rx_err tx_e=
rr
        Link detected: yes



The behaviour looks similar to the GPY211C attached to switch port 5.
Except that the latter works regardless of speed..

I did however notice one difference, which may or may not be
significant, in the VSPEC1_SGMII_STAT register of the phys after
changing to 1000Mb/s.  The switch attached phy reports:

root@OpenWrt:/# mdio mdio-bus 5:30 raw 9
0x002e

while the soc mac attached phy reports

root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e

According to
https://assets.maxlinear.com/web/documents/617810_gpy211b1vc_gpy211c0vc_ds_=
rev1.4.pdf
bit 5 is "Auto-Negotiation Completed". So it does look like the switch
mac is doing AN on the SGMII link, and the soc mac is not.  Is that
correct?

Any hints on where I should look next?

The ethernet part of my device tree looks like this:

&eth {
	status =3D "okay";

	gmac0: mac@0 {
		compatible =3D "mediatek,eth-mac";
		reg =3D <0>;
		phy-mode =3D "2500base-x";

		fixed-link {
			speed =3D <2500>;
			full-duplex;
			pause;
		};
	};

	mac@1 {
		compatible =3D "mediatek,eth-mac";
		reg =3D <1>;
		label =3D "wan";
		phy-mode =3D "2500base-x";
		phy-handle =3D <&phy6>;
	};

	mdio: mdio-bus {
		#address-cells =3D <1>;
		#size-cells =3D <0>;
	};
};

&mdio {
	reset-gpios =3D <&pio 6 GPIO_ACTIVE_LOW>;
	reset-delay-us =3D <50000>;
	reset-post-delay-us =3D <20000>;
=20=20
	phy5: phy@5 {
		compatible =3D "ethernet-phy-ieee802.3-c45";
		reg =3D <5>;
	};

	phy6: phy@6 {
		compatible =3D "ethernet-phy-ieee802.3-c45";
		reg =3D <6>;
	};

	switch: switch@1f {
		compatible =3D "mediatek,mt7531";
		reg =3D <31>;
		reset-gpios =3D <&pio 5 GPIO_ACTIVE_HIGH>;
		interrupt-controller;
		#interrupt-cells =3D <1>;
		interrupt-parent =3D <&pio>;
		interrupts =3D <66 IRQ_TYPE_LEVEL_HIGH>;
	};
};

&switch {
	ports {
		#address-cells =3D <1>;
		#size-cells =3D <0>;

		port@0 {
			reg =3D <0>;
			label =3D "lan3";
		};

		port@1 {
			reg =3D <1>;
			label =3D "lan2";
		};

		port@2 {
			reg =3D <2>;
			label =3D "lan1";
		};

		port@5 {
			reg =3D <5>;
			label =3D "lan4";
			phy-mode =3D "2500base-x";
                        phy-handle =3D <&phy5>;
		};

		port@6 {
			reg =3D <6>;
			label =3D "cpu";
			ethernet =3D <&gmac0>;
			phy-mode =3D "2500base-x";

			fixed-link {
				speed =3D <2500>;
				full-duplex;
				pause;
			};
		};
	};
};




Bj=C3=B8rn


--=-=-=
Content-Type: text/x-csrc
Content-Disposition: inline; filename=mtk_sgmii.c

// SPDX-License-Identifier: GPL-2.0
// Copyright (c) 2018-2019 MediaTek Inc.

/* A library for MediaTek SGMII circuit
 *
 * Author: Sean Wang <sean.wang@mediatek.com>
 *
 */

#include <linux/mfd/syscon.h>
#include <linux/of.h>
#include <linux/phylink.h>
#include <linux/regmap.h>

#include "mtk_eth_soc.h"

static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
{
	return container_of(pcs, struct mtk_pcs, pcs);
}

static void _dump_pcs_ctrl(struct mtk_pcs *mpcs)
{
	unsigned int val;

	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
	pr_info("offset:0 0x%x", val);
	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+4, &val);
	pr_info("offset:4 0x%x", val);
	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
	pr_info("offset:8 0x%x", val);
}

static void mtk_pcs_get_state(struct phylink_pcs *pcs,
			      struct phylink_link_state *state)
{
	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
	unsigned int bm, adv;

	/* Read the BMSR and LPA */
	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);

	phylink_mii_c22_pcs_decode_state(state, FIELD_GET(SGMII_BMSR, bm),
					 FIELD_GET(SGMII_LPA, adv));

	pr_info("%s: bm=0x%x, adv=0x%x\n", __FUNCTION__, bm, adv);
}

static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
			  phy_interface_t interface,
			  const unsigned long *advertising,
			  bool permit_pause_to_mac)
{
	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
	unsigned int rgc3, sgm_mode, bmcr;
	int advertise, link_timer;
	bool changed, use_an;

	pr_info("%s: interface=%u\n", __FUNCTION__, interface);
	_dump_pcs_ctrl(mpcs);
	if (interface == PHY_INTERFACE_MODE_2500BASEX)
		rgc3 = RG_PHY_SPEED_3_125G;
	else
		rgc3 = 0;

	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
							     advertising);
	if (advertise < 0)
		return advertise;

	link_timer = phylink_get_link_timer_ns(interface);
	if (link_timer < 0)
		return link_timer;

	/* Clearing IF_MODE_BIT0 switches the PCS to BASE-X mode, and
	 * we assume that fixes it's speed at bitrate = line rate (in
	 * other words, 1000Mbps or 2500Mbps).
	 */
	if (interface == PHY_INTERFACE_MODE_SGMII) {
		sgm_mode = SGMII_IF_MODE_SGMII;
		if (phylink_autoneg_inband(mode)) {
			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
				    SGMII_SPEED_DUPLEX_AN;
			use_an = true;
		} else {
			use_an = false;
		}
	} else if (phylink_autoneg_inband(mode)) {
		/* 1000base-X or 2500base-X autoneg */
		sgm_mode = SGMII_REMOTE_FAULT_DIS;
		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
					   advertising);
	} else {
		/* 1000base-X or 2500base-X without autoneg */
		sgm_mode = 0;
		use_an = false;
	}

	if (use_an) {
		/* FIXME: Do we need to set AN_RESTART here? */
		bmcr = SGMII_AN_RESTART | SGMII_AN_ENABLE;
	} else {
		bmcr = 0;
	}

	/* Configure the underlying interface speed */
	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
			   RG_PHY_SPEED_3_125G, rgc3);

	/* Update the advertisement, noting whether it has changed */
	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_ADVERTISE,
				 SGMII_ADVERTISE, advertise, &changed);

	/* Setup the link timer and QPHY power up inside SGMIISYS */
	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);

	/* Update the sgmsys mode register */
	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
			   SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN |
			   SGMII_IF_MODE_SGMII, sgm_mode);

	/* Update the BMCR */
	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
			   SGMII_AN_RESTART | SGMII_AN_ENABLE, bmcr);

	/* Release PHYA power down state */
	regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
			   SGMII_PHYA_PWD, 0);

	pr_info("%s: rgc3=0x%x, advertise=0x%x (%schanged), link_timer=%u,  sgm_mode=0x%x, bmcr=0x%x\n",
		__FUNCTION__, rgc3, advertise, changed ? "" : "not ", link_timer,  sgm_mode, bmcr);
	return changed;
}

static void mtk_pcs_restart_an(struct phylink_pcs *pcs)
{
	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);

	regmap_update_bits(mpcs->regmap, SGMSYS_PCS_CONTROL_1,
			   SGMII_AN_RESTART, SGMII_AN_RESTART);
	pr_info("%s\n", __FUNCTION__);
}

static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
			    phy_interface_t interface, int speed, int duplex)
{
	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
	unsigned int sgm_mode;

	pr_info("%s: interface=%u\n", __FUNCTION__, interface);
	_dump_pcs_ctrl(mpcs);
	if (interface != PHY_INTERFACE_MODE_SGMII ||
	    phylink_autoneg_inband(mode))
		return;

	/* Force the speed and duplex setting */
	if (speed == SPEED_10)
		sgm_mode = SGMII_SPEED_10;
	else if (speed == SPEED_100)
		sgm_mode = SGMII_SPEED_100;
	else
		sgm_mode = SGMII_SPEED_1000;

	if (duplex == DUPLEX_FULL)
		sgm_mode |= SGMII_DUPLEX_FULL;

	regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
			SGMII_DUPLEX_FULL | SGMII_SPEED_MASK,
			sgm_mode);
	pr_info("%s: sgm_mode=0x%x\n", __FUNCTION__, sgm_mode);
}

static const struct phylink_pcs_ops mtk_pcs_ops = {
	.pcs_get_state = mtk_pcs_get_state,
	.pcs_config = mtk_pcs_config,
	.pcs_an_restart = mtk_pcs_restart_an,
	.pcs_link_up = mtk_pcs_link_up,
};

int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
{
	struct device_node *np;
	int i;

	for (i = 0; i < MTK_MAX_DEVS; i++) {
		np = of_parse_phandle(r, "mediatek,sgmiisys", i);
		if (!np)
			break;

		ss->pcs[i].ana_rgc3 = ana_rgc3;
		ss->pcs[i].regmap = syscon_node_to_regmap(np);
		of_node_put(np);
		if (IS_ERR(ss->pcs[i].regmap))
			return PTR_ERR(ss->pcs[i].regmap);

		ss->pcs[i].pcs.ops = &mtk_pcs_ops;
//		ss->pcs[i].pcs.poll = 1;
	}

	pr_info("%s: ana_rgc3=0x%x\n", __FUNCTION__, ana_rgc3);
	return 0;
}

struct phylink_pcs *mtk_sgmii_select_pcs(struct mtk_sgmii *ss, int id)
{
	if (!ss->pcs[id].regmap)
		return NULL;

	pr_info("%s: id=%d\n", __FUNCTION__, id);
	return &ss->pcs[id].pcs;
}

--=-=-=--
