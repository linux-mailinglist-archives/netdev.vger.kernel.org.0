Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36B24F0B97
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 19:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbiDCRiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 13:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiDCRit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 13:38:49 -0400
X-Greylist: delayed 433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Apr 2022 10:36:54 PDT
Received: from mail.tintel.eu (mail.tintel.eu [IPv6:2001:41d0:a:6e77:0:ff:fe5c:6a54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CE71A3B6
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 10:36:53 -0700 (PDT)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id F28974474A42;
        Sun,  3 Apr 2022 19:29:38 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id lh6pndhPstgi; Sun,  3 Apr 2022 19:29:38 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 7788D4442F9F;
        Sun,  3 Apr 2022 19:29:38 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 7788D4442F9F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1649006978;
        bh=L832C14ssjhs8rlPPlAfnqCqDP4Gl4E61dMbF6zxnoQ=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=IWRtsxqye2sZffRU70kaaehVzenzI/Xb81zCLwRRRiTUC/jzFVsr03qF/9GoRyo1w
         I3Zxs7uZtJZCysB/PrJJitzCtCqMFOjm/a/Bv3D9GuSEcNgY6FXSGDp1uCap44vlY7
         WgeZS2/XRR4m7KTFD1iWnf0+oOkS9HtrxfdWjoXQ=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id KgQ1xBlyp6cl; Sun,  3 Apr 2022 19:29:38 +0200 (CEST)
Received: from taz.sof.bg.adlevio.net (unknown [IPv6:2001:67c:21bc:20::10])
        by mail.tintel.eu (Postfix) with ESMTPS id 3503B443B963;
        Sun,  3 Apr 2022 19:29:38 +0200 (CEST)
From:   Stijn Tintel <stijn@linux-ipv6.be>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pali@kernel.org, kabel@kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch
Subject: [PATCH] net: phy: marvell: add 88E1543 support
Date:   Sun,  3 Apr 2022 20:29:36 +0300
Message-Id: <20220403172936.3213998-1-stijn@linux-ipv6.be>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Rspamd-Queue-Id: 3503B443B963
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Spamd-Result: default: False [0.00 / 15.00];
        IP_WHITELIST(0.00)[2001:67c:21bc:20::10];
        ASN(0.00)[asn:200533, ipnet:2001:67c:21bc::/48, country:BG]
X-Rspamd-Server: skulls
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Marvell Alaska 88E1543 PHY used in the WatchGuard
Firebox M200 and M300.

Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 drivers/net/phy/marvell.c   | 27 +++++++++++++++++++++++++++
 include/linux/marvell_phy.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2702faf7b0f6..c510eda23069 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -3166,6 +3166,32 @@ static struct phy_driver marvell_drivers[] =3D {
 		.cable_test_tdr_start =3D marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status =3D marvell_vct7_cable_test_get_status,
 	},
+	{
+		.phy_id =3D MARVELL_PHY_ID_88E1543,
+		.phy_id_mask =3D MARVELL_PHY_ID_MASK,
+		.name =3D "Marvell 88E1543",
+		.probe =3D m88e1510_probe,
+		/* PHY_GBIT_FEATURES */
+		.flags =3D PHY_POLL_CABLE_TEST,
+		.config_init =3D marvell_config_init,
+		.config_aneg =3D m88e1510_config_aneg,
+		.read_status =3D marvell_read_status,
+		.ack_interrupt =3D marvell_ack_interrupt,
+		.config_intr =3D marvell_config_intr,
+		.did_interrupt =3D m88e1121_did_interrupt,
+		.resume =3D genphy_resume,
+		.suspend =3D genphy_suspend,
+		.read_page =3D marvell_read_page,
+		.write_page =3D marvell_write_page,
+		.get_sset_count =3D marvell_get_sset_count,
+		.get_strings =3D marvell_get_strings,
+		.get_stats =3D marvell_get_stats,
+		.get_tunable =3D m88e1540_get_tunable,
+		.set_tunable =3D m88e1540_set_tunable,
+		.cable_test_start =3D marvell_vct7_cable_test_start,
+		.cable_test_tdr_start =3D marvell_vct5_cable_test_tdr_start,
+		.cable_test_get_status =3D marvell_vct7_cable_test_get_status,
+	},
 	{
 		.phy_id =3D MARVELL_PHY_ID_88E1545,
 		.phy_id_mask =3D MARVELL_PHY_ID_MASK,
@@ -3351,6 +3377,7 @@ static struct mdio_device_id __maybe_unused marvell=
_tbl[] =3D {
 	{ MARVELL_PHY_ID_88E1116R, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1510, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1540, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1543, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E6341_FAMILY, MARVELL_PHY_ID_MASK },
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 0f06c2287b52..26a77a5b62fc 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -19,6 +19,7 @@
 #define MARVELL_PHY_ID_88E1116R		0x01410e40
 #define MARVELL_PHY_ID_88E1510		0x01410dd0
 #define MARVELL_PHY_ID_88E1540		0x01410eb0
+#define MARVELL_PHY_ID_88E1543		0x01410ea2
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
 #define MARVELL_PHY_ID_88E1548P		0x01410ec0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
--=20
2.35.1

