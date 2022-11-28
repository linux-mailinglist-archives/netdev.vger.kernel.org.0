Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3907263A7A4
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiK1MBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiK1MAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A0A18B3F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:18 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnw-0003n8-J8; Mon, 28 Nov 2022 13:00:08 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnp-000o8k-UZ; Mon, 28 Nov 2022 13:00:02 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnn-00Gzdl-Qs; Mon, 28 Nov 2022 12:59:59 +0100
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
Subject: [PATCH v1 09/26] net: dsa: microchip: ksz8_r_dyn_mac_table(): remove fid support
Date:   Mon, 28 Nov 2022 12:59:41 +0100
Message-Id: <20221128115958.4049431-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128115958.4049431-1-o.rempel@pengutronix.de>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
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

FID != VLAN. FID to VLAN conversation is currently not validated and was
not working before within the FDB dump context. So, drop it until
we have time to implement this functionality.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7310abd0d8df..736cf4e54333 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -395,7 +395,7 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 }
 
 static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
-				u8 *fid, u8 *src_port, u16 *entries)
+				u8 *src_port, u16 *entries)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
@@ -436,8 +436,6 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 			shifts[DYNAMIC_MAC_ENTRIES];
 		*entries = cnt + 1;
 
-		*fid = (data_hi & masks[DYNAMIC_MAC_TABLE_FID]) >>
-			shifts[DYNAMIC_MAC_FID];
 		*src_port = (data_hi & masks[DYNAMIC_MAC_TABLE_SRC_PORT]) >>
 			shifts[DYNAMIC_MAC_SRC_PORT];
 
@@ -954,12 +952,11 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	int ret = 0;
 	u16 i = 0;
 	u16 entries = 0;
-	u8 fid;
 	u8 src_port;
 	u8 mac[ETH_ALEN];
 
 	do {
-		ret = ksz8_r_dyn_mac_table(dev, i, mac, &fid, &src_port,
+		ret = ksz8_r_dyn_mac_table(dev, i, mac, &src_port,
 					   &entries);
 		if (!ret && port == src_port) {
 			ret = cb(mac, 0, false, data);
-- 
2.30.2

