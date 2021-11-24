Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB90D45D01D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 23:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345074AbhKXWht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 17:37:49 -0500
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:58243
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243451AbhKXWhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 17:37:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EA13kcstIGnPeFEgnpQZydD2FVFgU2sAqmHiWgy056bXGyHZzA03LDaeX9vVY1A6NqRWueUwWUA7YdnQiDVzDb5SdzjqtyJdTNS+O/+SLbrMCVfIRqpYI70mAuLCC5uXFc6dSNswkVfOQJ2d97800iGQugTKCimY1PklwjvtXoPI9lgmD/Eyv/D/pv9glv81f/dLN+fdHPxmwfnu/FctQaQ008QP4OcW+kOtw9/hgwDY4l1akpDH+QcTBCXJs2xK3e7FJJG3w3HQoDsbWDXrZGtZs63w9PYsJqvypMgC2lCmzsbTcvdH6VPIhZyVEq/V5HY0PdVyNx/sWgqzj3+ukA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oShK8/FYsEiXUNBYoBcGvohujBp7W25v1gqXvHcDab4=;
 b=FDHf1EiahhiRTfb5mnTuHJ9CPnrK30k8jbX9vcEyaw18+R3R8xC9bEhovceYY3L89zlhZX6bOzhca33fcfoozR8rPh8qDnF6kdBfccNS9uBn0G/tX6gdFHtN1U9Bbi5qw76n+S/AVEtKXgTFeZ0gRRmT/rKV9Ztd4U8Ir/EP5AcdFAhE8dhWQHfcAk3uDzMPQ3uuIzsN0kPtS8cDP85EmSqfCx67fHo/zKFQi0JNMMY381u0I5/Ze1p/oHmIrt1y+RtFAeCgkRGcea5k6ts444LdrmUi6PUh20xGhru5RMP4VD3BCUTxvpSGEd3NckfkXN0aNOgmsfwljB77bC3Utg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oShK8/FYsEiXUNBYoBcGvohujBp7W25v1gqXvHcDab4=;
 b=ZJNml8Ge5MHnxhpsGbuoKjdQv+W17C+g/76qW9MiJxcmoRbV5U+6O8h0G71AFZA2LZxdzE5jdVwa0Z9IG232ZkH3PP9XVqS7a0ru/q2jDN+RBjvYC3WWp6ctm7CGJA9nqpQXWFgX4tcxSA4k1S8dzj9M9X1+TPXdEjcegug6bIQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5294.eurprd04.prod.outlook.com (2603:10a6:803:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 22:34:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 22:34:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Thread-Index: AQHX4VwvfzWd9Rz+dU6sjp1u+N+3rawTFzqAgAAU7YCAABgGAA==
Date:   Wed, 24 Nov 2021 22:34:33 +0000
Message-ID: <20211124223432.w3flpx55hyjxmkwn@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
 <20211124195339.oa7u4zyintrwr4tx@skbuf>
 <YZ6p0V0ZOEJLhgEH@shell.armlinux.org.uk>
In-Reply-To: <YZ6p0V0ZOEJLhgEH@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d701a613-de0d-44c1-e4e4-08d9af9a9676
x-ms-traffictypediagnostic: VI1PR04MB5294:
x-microsoft-antispam-prvs: <VI1PR04MB52946E1E7DA36D2C317D1607E0619@VI1PR04MB5294.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrH3nKgzb4G0Wjp9oWFL3lNE2yTh99QxWZHPsmNkg8ltnARjJwHs3ALt6c6DIGtF4+sHn77Zngg++m6bQWl84rvAgUKl04nBoj+a2BHmnlxBTQKerD6xBaDaT2seQhYn7weGG5nmaLASDH2Cbr7Ods4rF/suY5YEH4MDtpF8h6w03Zrcae7BxH53kWJgTV+TM1XsvMyaZjvskZSKUi8s1xafHA1zeZlp2RNbwhc0juwC0qhj564TrcF49Qe6QEoeR4j89U3e4Gw3yef1EYN6TbJtuhxivJRHYSFE864nZHXIzcM3Z3zy/ORjr7OKxZwfUfDs2vGtDSxQYsRtEs523nEPZWZQEd25396l0UbcNPMfbj4PbUDaK9Z72m/59Zz2Tyc4+yxVFk0H36abZSkwvU9VA7c8i+ZhKbc+fpG0iukIVBFJhgUNVoGBvyxz+5h+2fr9A4vm4yG6HIxaiigdQur2lRPULbHYj6ruVCbc9morMuxBWZn4C2/L1hJHGZPLiXkpEoc4xaSqCQPPrDaro4Gh2HrYdz616g9sfedwaHSMOz5osJfGhM0Z0JQJQQ8p6OfXLkkZA7STbiNTK+VWVPdnAz48LGl00CumPlMTikQNol38nxYCGenNs9KCnCQlvLu7x+px1OTNdXLFVFxATerNyagjpXg6OKPyzkc1xQiDNC6RAPwVsjWlyteZdPjYdXd2rZIjBlXbbwiVL/GpN/fwFe6xYUwM8kpT3DRlaaA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(38100700002)(122000001)(8936002)(53546011)(6506007)(4326008)(6486002)(508600001)(38070700005)(26005)(76116006)(8676002)(91956017)(66556008)(64756008)(66446008)(54906003)(316002)(66476007)(66946007)(6916009)(44832011)(5660300002)(186003)(33716001)(86362001)(1076003)(71200400001)(9686003)(83380400001)(6512007)(7416002)(2906002)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JlIXOnag+e38GgNG5W2kxIJXg2VJ/sos/NAUYz2vXClQbLxWfE+EPzq8MN6J?=
 =?us-ascii?Q?oN5GpKF/hZBH7dQZvBnVj9sodHZvUIreu4rUuE75ikuuR0qqWa/g/lPHvrfM?=
 =?us-ascii?Q?KRsqHF5spXkMs/TxMxMhesEU1M9wGwNAy5DFUfiAO2urF9cx1TGQriqTMnSO?=
 =?us-ascii?Q?4lMZYTYmOvfz5dKhMCAC7PMC3Or9naJvgVhPZlTcoe0v4MBAmKGnQEQcPzX2?=
 =?us-ascii?Q?tvkNqFPeIZESidKMgtxd7AlwgaCtYXYcWBsgEkL2/8dGXxdWppSxaosPZOsB?=
 =?us-ascii?Q?hEGk5VO4EZOldVC2YABdNxTzhzP7yVdV5xSDI6aL7Cr0gjAUSQjnueFvpxcB?=
 =?us-ascii?Q?apt5BM2wv2sxRuv16mltcrq47w+xMtWl80bWJuBSDLeeMcO/lGsm/zwAg+Ra?=
 =?us-ascii?Q?jKciay/sF3sjzHsmzDkt11c3w+UADFZdjzXn51n7w96b2au2VuqCDQLcjutf?=
 =?us-ascii?Q?y+IXS7FUTv+7jAjTmUNEw224UoPcuypeLdLCj/QggygyHa7lgKp6JY1ajZLm?=
 =?us-ascii?Q?t+aU7oahK2W6TYagor7I1l2k/0wW2rWRlES7oaUZq7HiIiId94AjByGIaScY?=
 =?us-ascii?Q?qSY4d3p3EJVYCGODWKaL4Mf2g1FsN5EhrZoj4APKSiCZi3RPnIC+bcSqHml7?=
 =?us-ascii?Q?oqCfXskD7UDsXBNUi/XwgMTZ2pDZ7dPEnu7hwUqfAfBweHhQWt6cLEWX+icY?=
 =?us-ascii?Q?uRoR9cp4ruAd7duefQXaGu9jnlxdGgnysHbEEHvQ8PAZ7LdDl06QgKBp53Bp?=
 =?us-ascii?Q?WIVhykRjBFAKEeNJjvq50Fp9cZkT4Hm6HJDK6fvLBRDSXbd3A8BnvNggGPsb?=
 =?us-ascii?Q?o8NtLGdmmqe5WlhOHzcm0bDgqJXNjDG07arisVlIf3/XagAD5bGDBGtkwJjL?=
 =?us-ascii?Q?KVyJ40/k3bC9VKFmaStWrML7h/xmeHp7mxVMClJSIt98d3wYtdJN/8j154RE?=
 =?us-ascii?Q?jlJiuCs2sk6whii+zlRg8aC6rCib7BRCrK03qLCZkiX9l+l1Uahq6+XW6GZa?=
 =?us-ascii?Q?QdV3ADIHde1Fg8Wrp0Jj4WTr9zZcA6k4XZOpijS84Iu9ibOuMCdo3krn/F3P?=
 =?us-ascii?Q?8WfzOG0hTzkHZjITbtoRK/XDhUIYCJFuDkJQKVQM+8Ckr2aJv0acvVQBgQql?=
 =?us-ascii?Q?p+hzkY3cTh8d7R6Zto0gQ44icja19oTzspdOtjMzVTfISLnuQZZt6eNXiHuC?=
 =?us-ascii?Q?kPNn4xEnS0B4JDUq4WvPjOP3FAYVB6XzbyNytYRFy+nPskStEqQoXAYuNKQn?=
 =?us-ascii?Q?4Q597quTFdloF/HG/EjbcFXG1oPVha9KwxLKHIgK5FIL4gc9DvHcx1HI8yyh?=
 =?us-ascii?Q?wIXOLZeYgb9Ol4blm5Ue8Sv6PydihvEYkqsHxpNYA9COgBtTqfG2fLmu0SrD?=
 =?us-ascii?Q?zNSe8NKOuYWU9xYTeO5uU2m+4s5l0MM/IJmu4UAOKhaAyTENSdPzSI0XLYhH?=
 =?us-ascii?Q?V/c7IoBTSoJfFE2nRnnuBAonhLPFr8ye09SdeKgKX4jI3SMFPWO/b6CNrury?=
 =?us-ascii?Q?V4GXa5A/BiIbn+JYgUNpEdUCQNYmhbMwfR61V/iMu0ZDIkXgu8GuTfsuFZ+r?=
 =?us-ascii?Q?mbn2nJ2hlJvaGK/Lp+PhN6kMIUXzp9/VFHFktb2VEKjRGnv6CVGfcwWJkLgL?=
 =?us-ascii?Q?zBKQhxdc8gWxM2O23g+zlmWepSucUG/xGhCh+9Uatv7C?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0491A8F43E4ADC46A239CC7A657BBCA4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d701a613-de0d-44c1-e4e4-08d9af9a9676
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 22:34:33.1665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BYr1/UtFm0q7rPfslv27LDWww/EZFehFKphqaU+HfGX+KkZvPL9mpmgX/uBVknoRScnUTwzZKH9EXFh+TaqM4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 09:08:33PM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 07:53:40PM +0000, Vladimir Oltean wrote:
> > On Wed, Nov 24, 2021 at 05:53:19PM +0000, Russell King (Oracle) wrote:
> > > Populate the supported interfaces and MAC capabilities for the SJA110=
5
> > > DSA switch and remove the old validate implementation to allow DSA to
> > > use phylink_generic_validate() for this switch driver.
> > >=20
> > > This switch only supports a static model of configuration, so we
> > > restrict the interface modes to the configured setting, and pass the
> > > MAC capabilities. As it is unclear which interface modes support 1G
> > > speeds, we keep the setting of MAC_1000FD conditional on the configur=
ed
> > > interface mode.
> > >=20
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > ---
> >=20
> > Please use this patch for sja1105. Thanks.
>=20
> Your patch is combining two changes into one patch. Specifically, the
> there are two logical changes in your patch:
>=20
> 1) changing the existing behaviour of the validate() function by
> allowing switching between PHY_INTERFACE_MODE_SGMII and
> PHY_INTERFACE_MODE_2500BASEX, which was not permitted before with the
> sja1105_phy_mode_mismatch() check.
>=20
> 2) converting to supported_interfaces / mac_capabilities way of defining
> what is supported.
>=20
> Combining the two changes makes the patch harder to review, and it
> becomes less obvious that it is actually correct. I would recommend
> changing the existing behaviour prior to the conversion, but ultimately
> that is your decision.
>=20
> For more information please see the "Separate your changes" section in
> Documentation/process/submitting-patches.rst
>=20
> Thanks.

-- >8 --
From febedc56cf0e269556e7483a70a3e6cb8d0d5cc3 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 24 Nov 2021 21:02:43 +0200
Subject: [PATCH] net: dsa: sja1105: convert to phylink_generic_validate()

Provide a ->phylink_get_caps() implementation in order to tell phylink
what are the PHY modes between which each port can change (none for
now), and the MAC capabilities so it can limit the advertisement and
supported masks of the PHY.

Now that we populate phylink_config->supported_interfaces, it is
phylink's responsibility to not attempt a PHY mode change towards
something which we do not support, so we can delete the logic from
sja1105_phy_mode_mismatch() and move the essence of it into
sja1105_phylink_get_caps(), which happens much earlier.

This patch also fixes an inconsequential bug, which was that for ports
which support 2500base-X, we used to keep advertising the gigabit and
lower speeds. We should not have done this, because 2500base-X operates
only at 2500Mbps (and we do not support PAUSE frames in order for the
lower media speeds to work via rate adaptation). Nonetheless, the only
SJA1110 boards which use 2500base-X use it in a SERDES-to-SERDES fixed
link, so there isn't any PHY whose advertisement matters there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 78 ++++++++------------------
 1 file changed, 24 insertions(+), 54 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja11=
05/sja1105_main.c
index c343effe2e96..0db590daa3d9 100644
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
@@ -1411,48 +1392,37 @@ static void sja1105_mac_link_up(struct dsa_switch *=
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
-
-	mii =3D priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
-
-	/* include/linux/phylink.h says:
-	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
-	 *     expects the MAC driver to return all supported link modes.
+	phy_interface_t phy_mode;
+
+	phy_mode =3D priv->phy_mode[port];
+
+	/* Changing the PHY mode of xMII (parallel) ports is possible,
+	 * but requires a switch reset, and on top of that, will never
+	 * be needed in real life. So these ports support only the PHY
+	 * mode declared in the device tree.
+	 * On the other hand, changing the PHY mode on SERDES ports is
+	 * possible and makes sense, because that is done through the
+	 * XPCS. We could allow changes between SGMII and 2500base-X
+	 * (it is unknown whether 1000base-X is supported), but that
+	 * is left for a future time.
 	 */
-	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
-	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		linkmode_zero(supported);
-		return;
-	}
+	__set_bit(phy_mode, config->supported_interfaces);
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
+	if (phy_mode =3D=3D PHY_INTERFACE_MODE_2500BASEX) {
+		config->mac_capabilities =3D MAC_2500FD;
+	} else if (phy_interface_mode_is_rgmii(phy_mode) ||
+		   phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII) {
+		config->mac_capabilities =3D MAC_10FD | MAC_100FD | MAC_1000FD;
+	} else {
+		config->mac_capabilities =3D MAC_10FD | MAC_100FD;
 	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
 }
=20
 static int
@@ -3189,7 +3159,7 @@ static const struct dsa_switch_ops sja1105_switch_ops=
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
