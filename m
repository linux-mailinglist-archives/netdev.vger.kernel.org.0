Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101C144FD3E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 03:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhKOCw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 21:52:56 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:51396 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKOCwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 21:52:39 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 51970202B9; Mon, 15 Nov 2021 10:49:42 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     Zev Weiss <zev@bewilderbeest.net>, Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 4/6] i2c: npcm7xx: Allow 255 byte block SMBus transfers
Date:   Mon, 15 Nov 2021 10:49:24 +0800
Message-Id: <20211115024926.205385-5-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115024926.205385-1-matt@codeconstruct.com.au>
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

255 byte support has been tested on a npcm750 board

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Reviewed-by: Tali Perry <tali.perry1@gmail.com>
Reviewed-by: Patrick Venture <venture@google.com>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 2ad166355ec9..6d60f65add85 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -1399,7 +1399,7 @@ static void npcm_i2c_irq_master_handler_read(struct npcm_i2c *bus)
 		if (bus->read_block_use) {
 			/* first byte in block protocol is the size: */
 			data = npcm_i2c_rd_byte(bus);
-			data = clamp_val(data, 1, I2C_SMBUS_BLOCK_MAX);
+			data = clamp_val(data, 1, I2C_SMBUS_V3_BLOCK_MAX);
 			bus->rd_size = data + block_extra_bytes_size;
 			bus->rd_buf[bus->rd_ind++] = data;
 
@@ -2187,6 +2187,7 @@ static u32 npcm_i2c_functionality(struct i2c_adapter *adap)
 	       I2C_FUNC_SMBUS_EMUL |
 	       I2C_FUNC_SMBUS_BLOCK_DATA |
 	       I2C_FUNC_SMBUS_PEC |
+	       I2C_FUNC_SMBUS_V3_BLOCK |
 	       I2C_FUNC_SLAVE;
 }
 
-- 
2.32.0

