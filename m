Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE78E202977
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgFUIAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:00:50 -0400
Received: from smtp45.i.mail.ru ([94.100.177.105]:46662 "EHLO smtp45.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbgFUIAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 04:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=HXcwBgcCaiZzPoa15DpN/fr+O9Oj6AmSqShxlkVKcMQ=;
        b=H8Q/AaXYJDal2vAVTmzFj8gZZ+YZeSElRJ3rUHKR7Hb2FBND/tVwx4mLmxmwqyLjEpKAd5dOcxgPuLksfINoEoJ8fu24szfCajwSSzzdnmF9da7vt+t1Nma/+A84J42bhBrKYjdYRnsnx/AZhLiuzOdlK/JRca9p5GO7ODrP8CE=;
Received: by smtp45.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jmuuC-0000ou-Le; Sun, 21 Jun 2020 11:00:44 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/3] net: phy: marvell: Add Marvell 88E1548P support
Date:   Sun, 21 Jun 2020 10:59:52 +0300
Message-Id: <20200621075952.11970-4-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621075952.11970-1-fido_max@inbox.ru>
References: <20200621075952.11970-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp45.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9AAC5A87EC32CE31E196090AC2CBDFADCC97DA7FD68450178182A05F538085040E543508AA00D9AE0B844C1D6810CF3D1C640CBE642EF27632E99995F3FC63007
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE769420192704DB0E7EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637ED4AC1F45ACA54B08638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC34C26AE549D86D25F6675CD448B530C038340AB035A929AA389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C34964A708C60C975A117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C3820445CF21F0C3CC0837EA9F3D197644AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C342AF7BC6F74C2E4EBA3038C0950A5D36B5C8C57E37DE458BCF70BCFA8C8197A467F23339F89546C55F5C1EE8F4F765FCC6A536F79815AD9275ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735444A83B712AC0148C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 223468489A3E5B72A64208AB62F08C935B771E251B299D72AA541F377F65911C1275DEE1D8A12566
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojijaCqZVrqPEHGfocAwqXxg==
X-Mailru-Sender: C88E38A2D15C6BD1F5DE00CD28993412C922172FCFC7F7D5A7A5DDCEA0BC305B4A66EE8953A98738EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this new phy ID.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 drivers/net/phy/marvell.c   | 23 +++++++++++++++++++++++
 include/linux/marvell_phy.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 0842deb33085..bb86ac0bd092 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2965,6 +2965,28 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1548P,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1548P",
+		.probe = m88e1510_probe,
+		.features = PHY_GBIT_FIBRE_FEATURES,
+		.config_init = marvell_config_init,
+		.config_aneg = m88e1510_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.did_interrupt = m88e1121_did_interrupt,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+	},
 };
 
 module_phy_driver(marvell_drivers);
@@ -2986,6 +3008,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1548P, MARVELL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index c4390e9cbf15..ff7b7607c8cf 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -20,6 +20,7 @@
 #define MARVELL_PHY_ID_88E1510		0x01410dd0
 #define MARVELL_PHY_ID_88E1540		0x01410eb0
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
+#define MARVELL_PHY_ID_88E1548P		0x01410ec0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
 #define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
-- 
2.25.1

