Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39E645CD8E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 20:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbhKXT4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 14:56:55 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:39397
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235076AbhKXT4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 14:56:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErTmFb+5+O1phLqtt/iBiKpKoibJkh90l8Egzhsd09LaZ3Rbr1ivalXNrILWquinK4TS65YihXXX+TXOjTVCsN47w55YrIbePxF4c//vx/nzp1m8ycewzxMSM9oLvxGbn5NX2aqzj7b7dtBV4K1dStDnenuNTM9RL2oIyZK/unCVw1cvXGpMtIvCHe4+nqmIIAcEWcxXAqYZ8qaw2tANSBsK4+ISbtZ5HhyfF7w7GwRhSy+2NgY67n+Ik+ZTnNazZqpZC6EreCdnI0fG9facA0bBpF/wxeR8A3aHwEeJLjLvrXnmbWRUt0y5C7bZ2rGPgzmvZksgLgWJHJmPJfq3Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyCW1rFCEM3vfRy+oqhI7s/hkpZelvTFNduB9RspHDQ=;
 b=ArFwJTCHnqKBrog/J6bbUQe9+L2EkDQVD565F+MHJNLJINPqKrCNSKudhNxTJLwodN5CgScjuS3Fwe60gH2lWzaXoGzAymPuSNWciABAEoBdOwp0Q42squXSa0qJstlsa5ILD/phGJ7AVmvO0paGZEER8MU9QbN2LFvFFC/XoqSwh1cO4XRmWf4LDP+fzmlAegNyIpRPYzgt0oOcgAMZTsrdp1I7SY8ywrQy81gss5j1wDAo9+NjQjehPHFFkdLDlDHZ3RPRfTy3au6ZnpkIqYj6q0NkWv/1bG62iXIysqcoNZQDvuuAdOpClQ1r80AXrZ4KKjBiuMlN74rQOT5Hew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyCW1rFCEM3vfRy+oqhI7s/hkpZelvTFNduB9RspHDQ=;
 b=fauw5aAGDGNtNHOfNuA2kQmM3audGqasFpWJqsONxC+VxdSU47bR47YSM0rXlIhrHC9le189ZoC2nehGasPUbs5m3SI2Df7nSvEP49bDBJdVHCjyUTm3n8IJ5mATsB4qyVFYW1lczNi8nnEgCk1ZLESQpyYbAE5gsBzBj8bYGO4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5694.eurprd04.prod.outlook.com (2603:10a6:803:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 19:53:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 19:53:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
Thread-Topic: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
Thread-Index: AQHX4VwvfzWd9Rz+dU6sjp1u+N+3rawTFzqA
Date:   Wed, 24 Nov 2021 19:53:40 +0000
Message-ID: <20211124195339.oa7u4zyintrwr4tx@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 590498b6-8f44-4129-2a95-08d9af841ccf
x-ms-traffictypediagnostic: VI1PR04MB5694:
x-microsoft-antispam-prvs: <VI1PR04MB5694E241081C8EAA0053946BE0619@VI1PR04MB5694.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CfDElWWCiKNtP5p8IXiJGnII/VBgadYuHlsMNRL2hJlCT3JUn5sZ2t+313Pzp8qh52rT6JFJePS/uoMsxZg7HnR7Vn+ilb/mnOESdAiVNCisYXTqVSqJzyTvnnXEolHPTxziCfUZ09zwqSO/3SwHi5quPCepxjgA6nNmHXf5Wz3v6shiVZR+0FGZ199lUXoEpmESCDtKDwNKpEvod/SD1gaX7k4JLzYqPow9yUt/vO2iXga5ttvflNTAPalmyQYl5goTmniL/8rllN2P1QNlabVEWxz2re0bvsrd7i7C7K+n3CqDub3SFZeg3WYneQTEeFEzj0ST0SVkPPs3z8FeCkq0Uh25oMEB30o9BnkAszuZ6023q6dp+kWFTzxiC3Xwnj0r81PQ74agd18fOJbopb9E9WB+MJopmGzn9CM1YUQrrJioYfF4m/Efq7zLtmRmnNZIcnaYY4IZlufN52nLV+3kxhVqVTg6kz1vR5mjoajosmOW+ZaUmPRcuijvEzaOR3yDi7ZNmz8//ziDzxmuFcfKlMbA45GRourNn2sImfZjSmkG0HQPPnasa4IXNl2YJ9JxDKUVcGoQynFzYjCMIarDjNeLZhZuTrH7ztaMJ6BrzZmmPenrI9Qm9SyptA0sbalyF51zpk21SxoWjghwWc4dBAPBw+r0CDj3rtgDl6Es24DAintE+nQTSr0vpCA4SyqC/2T/fvJ5Z9egRA+euOtsgnRjW+/WzFnzBdqAw30=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(1076003)(86362001)(6486002)(186003)(33716001)(7416002)(2906002)(66946007)(8676002)(66476007)(44832011)(83380400001)(38100700002)(5660300002)(66446008)(66556008)(64756008)(38070700005)(508600001)(316002)(54906003)(8936002)(6512007)(9686003)(91956017)(71200400001)(6506007)(76116006)(4326008)(122000001)(53546011)(26005)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NJy/UZ+iNptzZxVyhzxgTwV8vNx8d2LqzxbC5Gi5qBLKjcRjmJaxZ3Zu/KmO?=
 =?us-ascii?Q?APeBCZZ438n1EZt7hZAv7FZcGMeRwaXRpxedaPlLj4LV4cG7LfjQfR9XqEkM?=
 =?us-ascii?Q?/fArA6iP8t673k2Hwg0dMQSXEKni4ndhfsqmD9eZ9bvkDqbv2pcpcIWoVeya?=
 =?us-ascii?Q?o0iIWOPUvpTDi5C2G+HTiplEhW5qbZMlWFfadpfrs6pxnwa4Mcdj1A39wvGU?=
 =?us-ascii?Q?7s3KWBjPrBVtlCWgGNdtm3e7BM722gj6JynkHMRXjFlM6Y5eiSdjSDYGkAmO?=
 =?us-ascii?Q?QLRUcPGcYXMy70F0THc47uSbUicpwGoSvdPV7j3QrUqSVOfrxSILSbpBNOi/?=
 =?us-ascii?Q?xenXQKQHcG6jFqIRstYXewg/hmmrfqgGpsZ856/cPI4+MWXc2tW7mH9Isz8g?=
 =?us-ascii?Q?5R/0vW44EiL3d745CmivZ1moELjSHcPx04aHmAVvJatHvz+fUw+KtrlyOrW5?=
 =?us-ascii?Q?B0n2thKvZFVo8y8QOMFV1um/Ue3QMmt46/EJvlPVsWbg8otu7HyYSJGvP8iu?=
 =?us-ascii?Q?AOtYFBr8J8RJSJNq0zgEnn4NAT7SAfbcAAoZtPP8oB6llyHwD+BQy3ghj2gR?=
 =?us-ascii?Q?kkDDMVEqcWnrFv9rJLDuZ888aEW6A4TueQJgZAAYUPTfGRKJpshc8BzZfQV/?=
 =?us-ascii?Q?f6er9HfUfA+ENrdpfjqo1NHaHI/rIFFh9Rmg7Wr/WRIRtsUOtA+0dlU282P4?=
 =?us-ascii?Q?iPo8Z6G/rJz4Ffho0nelgvTBkf5yreHHRnwiaztijUvzSCWwcm3FTDJ9Tsx+?=
 =?us-ascii?Q?MASmnUlpHXaNipsEf2mWR47IMc4aCqY6yDl9SOKcXasPBVBMrNFoEncLK3Cn?=
 =?us-ascii?Q?HqTfEAhl807pHxHXaY76VL8qQtcCkwVKP4HmsO5hB7Zx6b+xbYNOyoVsDP2W?=
 =?us-ascii?Q?paXZV+rKHGerdwlrHskXI27NC/didO0jA2Gtq5ad3IlAHhbjebtWHyshNkrU?=
 =?us-ascii?Q?qx98julOS0tA7Ns8ejgURcR2hqFxeRnazmR/zMlCyTUUzZNKJI4yqOtpM0pM?=
 =?us-ascii?Q?cHvM678/18XD60HBlz+bW+ZzUCLfvcWMsEjgMcbkA05iV/Fjn7J/q5QGFT9+?=
 =?us-ascii?Q?nFrrKKYc/USz1y2cIbTqA0dpC9XTl5hG8ykNh8owUw2b72vUQ7ubcJ0dra7p?=
 =?us-ascii?Q?6QL5wdXR98g4zCbn2mGyCckxNK2Fg+aaJwEdCNMdphep5OHmf8+ShbYbSni7?=
 =?us-ascii?Q?8KrorFSxL59UOATLiJ44ARIs3d3F2mlYU6PDCSVtilNQeI6SiowsXQiLy3Ks?=
 =?us-ascii?Q?tjzWpeah7TUJJpjixEJpX0vVgCrnM2ozWtUI8snGGtw/OhcVfPtdGwPdm87w?=
 =?us-ascii?Q?KGz/wwo9zd7LavfcOa1E+zFYS/c2BVanScaXruprno6xvZVC66UqFWW3SBMj?=
 =?us-ascii?Q?/ONxhcs7sTf0uuls0ljYiQ+6Cc81Et6h1iGbkq9kAUFvZ+x6+pn8hUssFl28?=
 =?us-ascii?Q?3C4iO5TO2xDqdJHLymmVdFR9KUpgkKem/pAzn31wqbtaB3yUUjt9/PR3FwSK?=
 =?us-ascii?Q?90ePJoxYYSMP2S5NG8AlYMwR2B80FlCDwlKc6sqCe+29e6GCBwyM6Wj9hXZc?=
 =?us-ascii?Q?9eiepdKyg8zwo/7Hym+YbcQu5RyofAG+0O4yVD+D2GuZ9ScZV0d02awtEZQK?=
 =?us-ascii?Q?c6aBsMVFo3opnNl3LtfBoFnMW04Z56FIKV7Zw1UEkq5M?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB3534CA87603D4F86B4BA44F2EA4745@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590498b6-8f44-4129-2a95-08d9af841ccf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 19:53:40.1959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJJ+/byjMrBRonieAEs8Pj43IBLLOodweF6Jr86KZU1MdOxgyue91MBmplGE2sq0s+U4Sr8Fq2Z4yh/wKWqjxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 05:53:19PM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the SJA1105
> DSA switch and remove the old validate implementation to allow DSA to
> use phylink_generic_validate() for this switch driver.
>=20
> This switch only supports a static model of configuration, so we
> restrict the interface modes to the configured setting, and pass the
> MAC capabilities. As it is unclear which interface modes support 1G
> speeds, we keep the setting of MAC_1000FD conditional on the configured
> interface mode.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Please use this patch for sja1105. Thanks.

-- >8 --
From cc8a64e9aec8afeae5005dd34636fdccde22c1ac Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 24 Nov 2021 21:02:43 +0200
Subject: [PATCH] net: dsa: sja1105: convert to phylink_generic_validate()

Provide a ->phylink_get_caps() implementation in order to tell phylink
what are the PHY modes between which each port can change, and the MAC
capabilities so it can limit the advertisement and supported masks of
the PHY using the generic validation method.

Now that we populate phylink_config->supported_interfaces, it is
phylink's responsibility to not attempt a PHY mode change towards
something which we do not support, so we can delete the logic from
sja1105_phy_mode_mismatch() and move the essence of it into
sja1105_phylink_get_caps(), which happens much earlier. By removing the
PHY mode mismatch checks, we now effectively allow SERDES protocol
changes between SGMII and 2500base-X, while still denying PHY mode
changes between one xMII kind and another, which did not make sense.

This patch also fixes an inconsequential bug, which was that for ports
which support 2500base-X, we used to keep advertising the gigabit and
lower speeds. We should not have done this, because 2500base-X operates
only at 2500Mbps (and we do not support PAUSE frames in order for the
lower media speeds to work via rate adaptation). Nonetheless, the only
SJA1110 boards which use 2500base-X use it in a SERDES-to-SERDES fixed
link, so there isn't any PHY whose advertisement matters there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 105 +++++++++++++------------
 1 file changed, 53 insertions(+), 52 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja11=
05/sja1105_main.c
index c343effe2e96..86883291e71d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1357,19 +1357,6 @@ static int sja1105_adjust_port_config(struct sja1105=
_private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
=20
-/* The SJA1105 MAC programming model is through the static config (the xMI=
I
- * Mode table cannot be dynamically reconfigured), and we have to program
- * that early (earlier than PHYLINK calls us, anyway).
- * So just error out in case the connected PHY attempts to change the init=
ial
- * system interface MII protocol from what is defined in the DT, at least =
for
- * now.
- */
-static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int po=
rt,
-				      phy_interface_t interface)
-{
-	return priv->phy_mode[port] !=3D interface;
-}
-
 static void sja1105_mac_config(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       const struct phylink_link_state *state)
@@ -1378,12 +1365,6 @@ static void sja1105_mac_config(struct dsa_switch *ds=
, int port,
 	struct sja1105_private *priv =3D ds->priv;
 	struct dw_xpcs *xpcs;
=20
-	if (sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		dev_err(ds->dev, "Changing PHY mode to %s not supported!\n",
-			phy_modes(state->interface));
-		return;
-	}
-
 	xpcs =3D priv->xpcs[port];
=20
 	if (xpcs)
@@ -1411,48 +1392,68 @@ static void sja1105_mac_link_up(struct dsa_switch *=
ds, int port,
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
=20
-static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
+static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
 {
-	/* Construct a new mask which exhaustively contains all link features
-	 * supported by the MAC, and then apply that (logical AND) to what will
-	 * be sent to the PHY for "marketing".
-	 */
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
 	struct sja1105_private *priv =3D ds->priv;
-	struct sja1105_xmii_params_entry *mii;
=20
-	mii =3D priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
-
-	/* include/linux/phylink.h says:
-	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
-	 *     expects the MAC driver to return all supported link modes.
-	 */
-	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
-	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		linkmode_zero(supported);
+	switch (priv->phy_mode[port]) {
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_INTERNAL:
+		/* Changing the PHY mode of xMII (parallel) ports is possible,
+		 * but requires a switch reset, and on top of that, will never
+		 * be needed in real life. So these ports support only the PHY
+		 * mode declared in the device tree.
+		 */
+		__set_bit(priv->phy_mode[port], config->supported_interfaces);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* Changing the PHY mode on SERDES ports is possible and makes
+		 * sense, because that is done through the XPCS. We allow
+		 * changes between SGMII and 2500base-X (it is unknown whether
+		 * 1000base-X is supported).
+		 */
+		if (priv->info->supports_sgmii[port]) {
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  config->supported_interfaces);
+		}
+		if (priv->info->supports_2500basex[port]) {
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+				  config->supported_interfaces);
+		}
+		break;
+	default:
 		return;
 	}
=20
 	/* The MAC does not support pause frames, and also doesn't
 	 * support half-duplex traffic modes.
 	 */
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, MII);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT1_Full);
-	if (mii->xmii_mode[port] =3D=3D XMII_MODE_RGMII ||
-	    mii->xmii_mode[port] =3D=3D XMII_MODE_SGMII)
-		phylink_set(mask, 1000baseT_Full);
-	if (priv->info->supports_2500basex[port]) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
+	if (priv->info->supports_rgmii[port] ||
+	    priv->info->supports_sgmii[port]) {
+		/* Ports can be gigabit-capable either because they are xMII or
+		 * because they are SERDES ports.
+		 */
+		config->mac_capabilities =3D MAC_10FD | MAC_100FD | MAC_1000FD;
+		/* Some SERDES ports also support the 2500Mbps speed */
+		if (priv->info->supports_2500basex)
+			config->mac_capabilities |=3D MAC_2500FD;
+	} else {
+		/* As per the "Port compatibility matrix" chapter in
+		 * Documentation/networking/dsa/sja1105.rst, ports that don't
+		 * support xMII or SERDES go to the internal 100base-T1 or
+		 * 100base-TX ports, which aren't gigabit capable.
+		 */
+		config->mac_capabilities =3D MAC_10FD | MAC_100FD | MAC_1000FD;
 	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
 }
=20
 static int
@@ -3189,7 +3190,7 @@ static const struct dsa_switch_ops sja1105_switch_ops=
 =3D {
 	.set_ageing_time	=3D sja1105_set_ageing_time,
 	.port_change_mtu	=3D sja1105_change_mtu,
 	.port_max_mtu		=3D sja1105_get_max_mtu,
-	.phylink_validate	=3D sja1105_phylink_validate,
+	.phylink_get_caps	=3D sja1105_phylink_get_caps,
 	.phylink_mac_config	=3D sja1105_mac_config,
 	.phylink_mac_link_up	=3D sja1105_mac_link_up,
 	.phylink_mac_link_down	=3D sja1105_mac_link_down,
-- >8 --=
