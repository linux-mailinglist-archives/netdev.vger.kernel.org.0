Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E22170277
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgBZPaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:30:30 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:39619 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgBZPaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:30:30 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 5503D1BF215;
        Wed, 26 Feb 2020 15:30:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: [PATCH net] net: phy: mscc: fix firmware paths
Date:   Wed, 26 Feb 2020 16:26:50 +0100
Message-Id: <20200226152650.1525515-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The firmware paths for the VSC8584 PHYs not not contain the leading
'microchip/' directory, as used in linux-firmware, resulting in an
error when probing the driver. This patch fixes it.

Fixes: a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 937ac7da2789..f686f40f6bdc 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -345,11 +345,11 @@ enum macsec_bank {
 				BIT(VSC8531_FORCE_LED_OFF) | \
 				BIT(VSC8531_FORCE_LED_ON))
 
-#define MSCC_VSC8584_REVB_INT8051_FW		"mscc_vsc8584_revb_int8051_fb48.bin"
+#define MSCC_VSC8584_REVB_INT8051_FW		"microchip/mscc_vsc8584_revb_int8051_fb48.bin"
 #define MSCC_VSC8584_REVB_INT8051_FW_START_ADDR	0xe800
 #define MSCC_VSC8584_REVB_INT8051_FW_CRC	0xfb48
 
-#define MSCC_VSC8574_REVB_INT8051_FW		"mscc_vsc8574_revb_int8051_29e8.bin"
+#define MSCC_VSC8574_REVB_INT8051_FW		"microchip/mscc_vsc8574_revb_int8051_29e8.bin"
 #define MSCC_VSC8574_REVB_INT8051_FW_START_ADDR	0x4000
 #define MSCC_VSC8574_REVB_INT8051_FW_CRC	0x29e8
 
-- 
2.24.1

