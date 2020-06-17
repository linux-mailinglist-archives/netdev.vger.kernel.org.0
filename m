Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1121F1FC56C
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgFQEwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:52:54 -0400
Received: from smtp45.i.mail.ru ([94.100.177.105]:55420 "EHLO smtp45.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgFQEwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 00:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Cc:To:Subject:From; bh=8C3LNATW1QR+MTb/LFjbaajP9NkwKFKFk3rN6Vv30d4=;
        b=RfrhtPgT306HUmBoxBhahalg37kEFo6zYDbvL0HUEZMWbZPrs+soSwqOcbKmtxm+iyAmWczpJzFQu+NeDIW3HHESrPrBxMbKZ3/FPl6DRTQhbygS6Wkwq2K2D0GtNQ2kkCcLA2H5rUpbc7DM1yV6t12Ak+84agIlH1pG7jBUDos=;
Received: by smtp45.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jlQ49-0000sV-Ep; Wed, 17 Jun 2020 07:52:49 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 02/02] net: phy: marvell: Add Marvell 88E1548 support
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Message-ID: <9e4c89a1-e2a6-5067-1ed2-ab5e2b0c4af3@inbox.ru>
Date:   Wed, 17 Jun 2020 07:52:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp45.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9F3DF18D84EDC53E08E939B0E900FFF52CC254837D7C0B606182A05F538085040FC8B6049799ED0761F35C3B5DAD3998B37F168320E1852B2EFCCDDBCF94F76F0
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7FF48036FC9305502EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637BC8EAE35C9B9FAA78638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC08D0347DBCEB4506F739721D4F72D76E10B118563259A7E3389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3A12191B5F2BB8629117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C7BF93E671518182A6136E347CC761E074AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C39AF398481F98DE8EBA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3522CA9DD8327EE4930A3850AC1BE2E735444A83B712AC0148C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 2C64EDDF45FB739CDC7D1EE7BA5017215CCAE122C410528D61EC794830A8682F4EEA570653E905CF
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj1fDABIY57ZihKVPDMz8XcA==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB2477ED706E6B6F97137E1A343CFB449CE1D6E2BA72FD04D86FEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Marvell 88E1548 support
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
  drivers/net/phy/marvell.c   | 24 ++++++++++++++++++++++++
  include/linux/marvell_phy.h |  1 +
  2 files changed, 25 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4cc4e25fed2d..f0d4ca87e4bc 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2481,6 +2481,29 @@ static struct phy_driver marvell_drivers[] = {
  		.get_tunable = m88e1540_get_tunable,
  		.set_tunable = m88e1540_set_tunable,
  	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1548,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1548P",
+		.probe = m88e1510_probe,
+		.features = PHY_GBIT_FIBRE_FEATURES,
+		.config_init = &marvell_config_init,
+		.config_aneg = &m88e1510_config_aneg,
+		.read_status = &marvell_read_status,
+		.ack_interrupt = &marvell_ack_interrupt,
+		.config_intr = &marvell_config_intr,
+		.did_interrupt = &m88e1121_did_interrupt,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+	},
+
  };

  module_phy_driver(marvell_drivers);
@@ -2502,6 +2525,7 @@ static struct mdio_device_id __maybe_unused 
marvell_tbl[] = {
  	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
  	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
  	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1548, MARVELL_PHY_ID_MASK },
  	{ }
  };

diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 39e8c382defb..3d8249c3e31d 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -20,6 +20,7 @@
  #define MARVELL_PHY_ID_88E1510		0x01410dd0
  #define MARVELL_PHY_ID_88E1540		0x01410eb0
  #define MARVELL_PHY_ID_88E1545		0x01410ea0
+#define MARVELL_PHY_ID_88E1548		0x01410ec0
  #define MARVELL_PHY_ID_88E3016		0x01410e60
  #define MARVELL_PHY_ID_88X3310		0x002b09a0
  #define MARVELL_PHY_ID_88E2110		0x002b09b0
-- 
2.25.1
