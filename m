Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2725F1FA95B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFPHBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:01:21 -0400
Received: from fallback18.mail.ru ([185.5.136.250]:50920 "EHLO
        fallback18.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgFPHBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:01:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To; bh=5ofss1brrnqAwVu0rgVvlRnh91spAI6EHRLZJiV04Iw=;
        b=G5J8JiB4Mhl2tfXdqWSTdwyLgdRar7N8OK+9K0wnhxgpnVpcFfevzpON4TUHJ383snpXv/I8aBX2j8n4Nb6JTOZ4Hu+vv27vYUPdkMgpdUjpD+OzdUWmwJ3h4jO7vJRKEkMNANwCJlKWzADSBl/g8dIpL7hwGQsVA/ArIODpLWA=;
Received: from [10.161.64.45] (port=42292 helo=smtp37.i.mail.ru)
        by fallback18.m.smailru.net with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1jl5av-0005ca-Rz
        for netdev@vger.kernel.org; Tue, 16 Jun 2020 10:01:18 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To; bh=5ofss1brrnqAwVu0rgVvlRnh91spAI6EHRLZJiV04Iw=;
        b=G5J8JiB4Mhl2tfXdqWSTdwyLgdRar7N8OK+9K0wnhxgpnVpcFfevzpON4TUHJ383snpXv/I8aBX2j8n4Nb6JTOZ4Hu+vv27vYUPdkMgpdUjpD+OzdUWmwJ3h4jO7vJRKEkMNANwCJlKWzADSBl/g8dIpL7hwGQsVA/ArIODpLWA=;
Received: by smtp37.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1jl5ar-0000fP-UW; Tue, 16 Jun 2020 10:01:14 +0300
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
From:   Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH 01/02] net: phy: marvell: Add Marvell 88E1340 support
Message-ID: <3fcbc447-877d-0e95-af39-86fc72a34e10@inbox.ru>
Date:   Tue, 16 Jun 2020 10:01:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9F3DF18D84EDC53E082BD8620E748A3B24B1BACBDE80A87C5182A05F538085040E308D2109F2CB5BF062A8046CD820DA8D48D897BCBAEE66B592F7A5FDA7AEEBA
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7E2637B1BEF39BC4CEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637CECE2C1FEC389EDA8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FCF2B97552CBC98E4085BE72183AD5F4F48DFF7EC0911FC8DB389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C05A64D9A1E9CA65708941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3E97D2AE7161E217F117882F4460429728AD0CFFFB425014E40A5AABA2AD371193AA81AA40904B5D9A18204E546F3947CEE16715F795C715C6E0066C2D8992A164AD6D5ED66289B52F4A82D016A4342E36136E347CC761E07725E5C173C3A84C322EEDC3ADD1F6A27BA3038C0950A5D36B5C8C57E37DE458B0B4866841D68ED3522CA9DD8327EE4930A3850AC1BE2E735E4A630A5B664A4FFC4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-C8649E89: 54D2F8F0A1EE20EB192CCA9AF028AA089BC6654D481DBBD11BE1237437EBC970D35F5AAB08F0C2D6
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj4XA7CrCOa3/J+LMWeYDbMQ==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB24EA3A24903F16E0A32B6DA0FFE9B7417FF3ABF60B6F9D903EEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
X-7564579A: EEAE043A70213CC8
X-77F55803: 669901E4625912A97F9F52485CB584D7271FD7DF62800FDC963F1F427133582B6A6EB643E1FE34A2A17C0EB2E90AF861A93D718B38860F14
X-7FA49CB5: 0D63561A33F958A59C9D9522256F38B218C74AC003EC3A7CF174CA5C72418DDF8941B15DA834481FA18204E546F3947C78444BBB7636F62AF6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8B60CDF180582EB8FBA471835C12D1D977C4224003CC8364767815B9869FA544D8D32BA5DBAC0009BE9E8FC8737B5C224938BB39C8C12D3C3076E601842F6C81A12EF20D2F80756B5F7874E805F1D05189089D37D7C0E48F6C8AA50765F7900637AF8E4F18C523FAA9EFF80C71ABB335746BA297DBC24807EA27F269C8F02392CD20465B3A5AADEC6827F269C8F02392CD5571747095F342E88FB05168BE4CE3AF
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2bioj4XA7CrCOa3+1xMRu7UVq8Q==
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C90051485E59330854475D49FA44640A4517B6A6EB643E1FE34A2B03078242870122EC099ADC76E806A99D50E20E2BC48EF5A30D242760C51EA9CEAB4BC95F72C04283CDA0F3B3F5B9367
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
+		.phy_id = MARVELL_PHY_ID_88E1340,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1340",
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
+	{ MARVELL_PHY_ID_88E1340, MARVELL_PHY_ID_MASK },
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
+#define MARVELL_PHY_ID_88E1340		0x01410dc0
  #define MARVELL_PHY_ID_88E1116R		0x01410e40
  #define MARVELL_PHY_ID_88E1510		0x01410dd0
  #define MARVELL_PHY_ID_88E1540		0x01410eb0
-- 
2.25.1
