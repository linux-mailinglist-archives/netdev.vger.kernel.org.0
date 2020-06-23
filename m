Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2769B2048EB
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgFWFBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:01:03 -0400
Received: from smtp49.i.mail.ru ([94.100.177.109]:41410 "EHLO smtp49.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728767AbgFWFBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 01:01:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=MeYp+2el/TzuQHOo2MP0RExRYbUZyYueCGKgO5ukylg=;
        b=d37IXh53Bb4g9V14wLjCFxxXSaofzBUfhfj8o0MOMfIPQ+n+NP3PmgTKXzQG6WP6CeBmYnJP46YCICuaSrGY3pXu/+kUAtVVWa5JPuRC6jdF3DtRBQIzVB7neNwxR9/C9D+iGzcKHUKGE0eaISP0snnV+ntTqN7N3LbC3GjiL0c=;
Received: by smtp49.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jnb3K-0007eW-Ge; Tue, 23 Jun 2020 08:00:58 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Maxim Kochetkov <fido_max@inbox.ru>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 3/3] net: phy: marvell: Add Marvell 88E1548P support
Date:   Tue, 23 Jun 2020 08:00:44 +0300
Message-Id: <20200623050044.12303-4-fido_max@inbox.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623050044.12303-1-fido_max@inbox.ru>
References: <20200623050044.12303-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp49.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9AAC5A87EC32CE31E7E618D9A39B32F604F18773C824D9F38182A05F538085040BCE52D35B043A6304C0B904DF3F320829C0CA590BBF71A32E68C821B50727110
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE71840AE9AFD3F5D61C2099A533E45F2D0395957E7521B51C2CFCAF695D4D8E9FCEA1F7E6F0F101C6778DA827A17800CE7D3BEF3C661CDD2E7EA1F7E6F0F101C674E70A05D1297E1BBC6CDE5D1141D2B1CF581106DE51F22949ECCFA4CB9A5419E34BD0B01C8E833FA9FA2833FD35BB23D9E625A9149C048EE33AC447995A7AD18BDFBBEFFF4125B51D2E47CDBA5A96583BD4B6F7A4D31EC0BB23A54CFFDBC96A8389733CBF5DBD5E9D5E8D9A59859A8B61638054B7D09EC08CC7F00164DA146DA6F5DAA56C3B73B23E7DDDDC251EA7DABD81D268191BDAD3DC09775C1D3CA48CFC89C18C5046ADC62BA3038C0950A5D36C8A9BA7A39EFB7669EC76388C36FFEC7BA3038C0950A5D36D5E8D9A59859A8B6E629FEBEEC38437D76E601842F6C81A1F004C90652538430FAAB00FBE355B82D93EC92FD9297F6718AA50765F7900637149D0840703ADBE5A7F4EDE966BC389F395957E7521B51C24C7702A67D5C33162DBA43225CD8A89F83C798A30B85E16B262FEC7FBD7D1F5BB5C8C57E37DE458B4C7702A67D5C3316FA3894348FB808DB48C21F01D89DB561574AF45C6390F7469DAA53EE0834AAEE
X-C8649E89: 49CF6053C7B4EB01B154DAE81122F9EAE5FBA06E211E65D6469E749CBDEF4A6331FF3FAE5A240CA5
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj1gHwMoBzqge1zYK6InGBkA==
X-Mailru-Sender: C88E38A2D15C6BD1F5DE00CD289934120ECCDB11EABAE5B529A2CF7F5F102C4E4F43A3E4BAD3CFC3EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this new phy ID.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

