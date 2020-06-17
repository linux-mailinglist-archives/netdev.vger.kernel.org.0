Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB81FC568
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgFQEwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:52:49 -0400
Received: from smtp38.i.mail.ru ([94.100.177.98]:57850 "EHLO smtp38.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgFQEws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 00:52:48 -0400
X-Greylist: delayed 78691 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 00:52:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Cc:To:Subject:From; bh=6qeHu+rHNQdji3YWWvgcyxodWGmntOtop5VBbHoCBaM=;
        b=OSDmrBeGvlwMcidszQ/bH/mRHp9vNO4sfvxpcK7+aCogOa/H0m7Gg0sqmDLVCKMWppetLElH3KngDPuA1Znxdm8NuZ2Odp/jQ4aZG6VdZbHQwC9jgd4K5T/gN6odWt4Tdl/VXPEKCliN+aC6o6vkpHAFpwcvG5pbQ9eIWNAhAvo=;
Received: by smtp38.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jlQ45-00016m-JY; Wed, 17 Jun 2020 07:52:46 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 01/02] net: phy: marvell: Add Marvell 88E1340 support
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Message-ID: <05f6912b-d529-ae7d-183e-efa6951e94b7@inbox.ru>
Date:   Wed, 17 Jun 2020 07:52:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp38.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 78E4E2B564C1792B
X-77F55803: 4F1203BC0FB41BD9F3DF18D84EDC53E04E388BD6EE8D009D8F3DEE1CE6130DC2182A05F538085040753D33979F8C957C4A3EAF97D325A8A4D864A439F3D74FFA53F989A65C6896D0
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7526ABEDBD4A111ACEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637F9C02CFF5F27192B8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC08D0347DBCEB45062E483ABE9DD7C136B1B7A882FFE63D53389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3A12191B5F2BB8629117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947C7BF93E671518182A6136E347CC761E074AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C34BBC0F911FD68433BA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3522CA9DD8327EE4930A3850AC1BE2E735444A83B712AC0148C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: E79EADE35AB1A5EA23D8C9C4546E70154B021F2AA504BBBE71DF11191021C87CD35F5AAB08F0C2D6
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj1fDABIY57ZhbEz1J58JgmQ==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB248685A3B99C8ABC2AF21A660AF96DB45E858851C6474C3FE6EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Marvell 88E1340 support
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
  drivers/net/phy/marvell.c   | 23 +++++++++++++++++++++++
  include/linux/marvell_phy.h |  1 +
  2 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 7fc8e10c5f33..4cc4e25fed2d 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2459,6 +2459,28 @@ static struct phy_driver marvell_drivers[] = {
  		.get_tunable = m88e1540_get_tunable,
  		.set_tunable = m88e1540_set_tunable,
  	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1340S,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1340S",
+		.probe = m88e1510_probe,
+		/* PHY_GBIT_FEATURES */
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
  };

  module_phy_driver(marvell_drivers);
@@ -2479,6 +2501,7 @@ static struct mdio_device_id __maybe_unused 
marvell_tbl[] = {
  	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
  	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
  	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1340S, MARVELL_PHY_ID_MASK },
  	{ }
  };

diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index af6b11d4d673..39e8c382defb 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -15,6 +15,7 @@
  #define MARVELL_PHY_ID_88E1149R		0x01410e50
  #define MARVELL_PHY_ID_88E1240		0x01410e30
  #define MARVELL_PHY_ID_88E1318S		0x01410e90
+#define MARVELL_PHY_ID_88E1340S		0x01410dc0
  #define MARVELL_PHY_ID_88E1116R		0x01410e40
  #define MARVELL_PHY_ID_88E1510		0x01410dd0
  #define MARVELL_PHY_ID_88E1540		0x01410eb0
-- 
2.25.1
