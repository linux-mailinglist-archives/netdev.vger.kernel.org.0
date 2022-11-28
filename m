Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C705263A7C1
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiK1MBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiK1MAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423D6186EC
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:47 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoS-0005Jb-19; Mon, 28 Nov 2022 13:00:40 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoQ-000oBM-Gl; Mon, 28 Nov 2022 13:00:39 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoN-00H6Na-Gn; Mon, 28 Nov 2022 13:00:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v1 07/26] net: dsa: microchip: ksz8_r_dyn_mac_table(): remove timestamp support
Date:   Mon, 28 Nov 2022 13:00:15 +0100
Message-Id: <20221128120034.4075562-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not use FDB timestamps. So, drop it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h    | 2 +-
 drivers/net/dsa/microchip/ksz8795.c | 7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index ea05abfbd51d..ad8e69051347 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -20,7 +20,7 @@ void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
-			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries);
+			 u8 *fid, u8 *src_port, u16 *entries);
 int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 			 struct alu_struct *alu);
 void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index e0530bc3bec0..d0cfe74d5b13 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -395,7 +395,7 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 }
 
 int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
-			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries)
+			 u8 *fid, u8 *src_port, u16 *entries)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
@@ -440,8 +440,6 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 			shifts[DYNAMIC_MAC_FID];
 		*src_port = (data_hi & masks[DYNAMIC_MAC_TABLE_SRC_PORT]) >>
 			shifts[DYNAMIC_MAC_SRC_PORT];
-		*timestamp = (data_hi & masks[DYNAMIC_MAC_TABLE_TIMESTAMP]) >>
-			shifts[DYNAMIC_MAC_TIMESTAMP];
 
 		mac_addr[5] = (u8)data_lo;
 		mac_addr[4] = (u8)(data_lo >> 8);
@@ -956,14 +954,13 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	int ret = 0;
 	u16 i = 0;
 	u16 entries = 0;
-	u8 timestamp = 0;
 	u8 fid;
 	u8 src_port;
 	u8 mac[ETH_ALEN];
 
 	do {
 		ret = ksz8_r_dyn_mac_table(dev, i, mac, &fid, &src_port,
-					   &timestamp, &entries);
+					   &entries);
 		if (!ret && port == src_port) {
 			ret = cb(mac, 0, false, data);
 			if (ret)
-- 
2.30.2

