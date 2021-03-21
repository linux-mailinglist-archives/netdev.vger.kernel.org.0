Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8534336C
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 17:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCUQZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 12:25:06 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33102 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCUQZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 12:25:04 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4FC301C0B78; Sun, 21 Mar 2021 17:25:01 +0100 (CET)
Date:   Sun, 21 Mar 2021 17:25:00 +0100
From:   Pavel Machek <pavel@denx.de>
To:     kernel list <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: enetc: fix bitfields, we are clearing wrong bits
Message-ID: <20210321162500.GA26497@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Bitfield manipulation in enetc_mac_config() looks wrong. Fix
it. Untested.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_pf.c
index 224fc37a6757..b85079493933 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -505,7 +505,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_i=
nterface_t phy_mode)
 	if (phy_interface_mode_is_rgmii(phy_mode)) {
 		val =3D enetc_port_rd(hw, ENETC_PM0_IF_MODE);
 		val &=3D ~ENETC_PM0_IFM_EN_AUTO;
-		val &=3D ENETC_PM0_IFM_IFMODE_MASK;
+		val &=3D ~ENETC_PM0_IFM_IFMODE_MASK;
 		val |=3D ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
 	}

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBXc1wACgkQMOfwapXb+vKe5ACdF0gZA7BOIqGfRYy9hYClmoQg
31IAn2IamVwKbAIrn1M3IhfUcCRbxCLL
=KpUG
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
