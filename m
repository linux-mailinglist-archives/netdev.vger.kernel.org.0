Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC725897EE
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 08:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiHDGwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 02:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiHDGwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 02:52:11 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F4B2496B
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 23:52:08 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j15so15994194wrr.2
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 23:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ororatech.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0AEunzLr7vTPk11eedsuPVfmI7JOhTR6S+12Kvpg100=;
        b=Qc7CSsWIDOJDekmEWSMYtJx81uVWuvMi32PR2QVNwlS9aNZY7jI7G2yEd7oEvFN6ql
         OmNmQYNMfcRVHCaag+a4fBv0x7R7Ko5T/9bzKGTn9y67yh5KfVnfdLPl/lM/yecNvfCJ
         20i8qSZDHf+dMyrTgQhIyDgt0gkZJ7D2isXLfFk8oHIOFZ6mvHMyASieuPEj1tqXI9mF
         DcooNCvZ4jR6xefHb4zgKR7gFQ5w0DYgTAWgJF2E65S/VottD/4oypHST30+/SN2Ll8V
         9zHOfcMnQ3rUfwebaN+2c2fa++LIbWpK2Wgpo9H2xo1YSNQIcRi/EgVJ5ljc+X4mhrwH
         G7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0AEunzLr7vTPk11eedsuPVfmI7JOhTR6S+12Kvpg100=;
        b=YKavJ7lj7WrqOFSj8nwtK8Z7ccijD9SAWeNDfx7VuPWtX3hREaN7U589u+UKohSkEq
         PsIm1GRscevuT6gmvtZmT/qwsHkYvAnQTgv9e2p6rE3xP8SjaExQIQ/YJxoImdYVtWdV
         kak4YQUsszzralZsNzwyqNeuKdl2zwQfkK+KoTQIDLdAcLynZwL4nuv8+ZNmQ0mYdONt
         WcC7S34kKx2TH6dwn/OxMRzutJP97Nom9mvBCeaBqrBoxzdXzqWTFc2teAsl4y6s9Qjl
         kkXC+Gui05/4ymH4t42azyLomSXUIfZR5UA8xDF9fz6lAFYaLrn5SjwG/l2sifHhdCQN
         tdPA==
X-Gm-Message-State: ACgBeo0ERAdV5tCpJCBftY5gxEKJN+wY4tLe5p0Lc2erGa4y2fm3gSDp
        WQuCPCU9rRe4nXYCfiV6kfddUw==
X-Google-Smtp-Source: AA6agR7Ajq6pXORGxS9sUC7eVWqphD3mHssT1VVxN/WpnIDF5MBPF4Tz5LjqNf23noRW1SbJIEXCcQ==
X-Received: by 2002:adf:e6ce:0:b0:220:5e20:ce80 with SMTP id y14-20020adfe6ce000000b002205e20ce80mr339553wrm.13.1659595926832;
        Wed, 03 Aug 2022 23:52:06 -0700 (PDT)
Received: from toolbox.dsn.orora.tech (host-88-217-137-115.customer.m-online.net. [88.217.137.115])
        by smtp.googlemail.com with ESMTPSA id u19-20020a05600c00d300b003a2fde6ef62sm350020wmm.7.2022.08.03.23.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 23:52:06 -0700 (PDT)
From:   =?UTF-8?q?Sebastian=20W=C3=BCrl?= <sebastian.wuerl@ororatech.com>
To:     sebastian.wuerl@ororatech.com
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: mcp251x: Fix race condition on receive interrupt
Date:   Thu,  4 Aug 2022 08:48:03 +0200
Message-Id: <20220804064803.63157-1-sebastian.wuerl@ororatech.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220803185910.5jpufgziqsslnqtf@pengutronix.de>
References: <20220803185910.5jpufgziqsslnqtf@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mcp251x driver uses both receiving mailboxes of the CAN controller
chips. For retrieving the CAN frames from the controller via SPI, it checks
once per interrupt which mailboxes have been filled and will retrieve the
messages accordingly.

This introduces a race condition, as another CAN frame can enter mailbox 1
while mailbox 0 is emptied. If now another CAN frame enters mailbox 0 until
the interrupt handler is called next, mailbox 0 is emptied before
mailbox 1, leading to out-of-order CAN frames in the network device.

This is fixed by checking the interrupt flags once again after freeing
mailbox 0, to correctly also empty mailbox 1 before leaving the handler.

For reproducing the bug I created the following setup:
 - Two CAN devices, one Raspberry Pi with MCP2515, the other can be any.
 - Setup CAN to 1 MHz
 - Spam bursts of 5 CAN-messages with increasing CAN-ids
 - Continue sending the bursts while sleeping a second between the bursts
 - Check on the RPi whether the received messages have increasing CAN-ids
 - Without this patch, every burst of messages will contain a flipped pair

Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead of workqueues.")
Signed-off-by: Sebastian Würl <sebastian.wuerl@ororatech.com>
---
 drivers/net/can/spi/mcp251x.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 89897a2d41fa..ca462868141c 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1068,17 +1068,14 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 	mutex_lock(&priv->mcp_lock);
 	while (!priv->force_quit) {
 		enum can_state new_state;
-		u8 intf, eflag;
+		u8 intf, intf0, intf1, eflag, eflag0, eflag1;
 		u8 clear_intf = 0;
 		int can_id = 0, data1 = 0;
 
-		mcp251x_read_2regs(spi, CANINTF, &intf, &eflag);
-
-		/* mask out flags we don't care about */
-		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
+		mcp251x_read_2regs(spi, CANINTF, &intf0, &eflag0);
 
 		/* receive buffer 0 */
-		if (intf & CANINTF_RX0IF) {
+		if (intf0 & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
 			/* Free one buffer ASAP
 			 * (The MCP2515/25625 does this automatically.)
@@ -1086,16 +1083,31 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF,
 						   CANINTF_RX0IF, 0x00);
+
+			if (intf0 & CANINTF_RX1IF) {
+				/* buffer 1 is already known to be full, no need to re-read */
+				intf1 = intf0;
+			} else {
+				/* intf needs to be read again to avoid a race condition */
+				mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);
+			}
 		}
 
 		/* receive buffer 1 */
-		if (intf & CANINTF_RX1IF) {
+		if (intf1 & CANINTF_RX1IF) {
 			mcp251x_hw_rx(spi, 1);
 			/* The MCP2515/25625 does this automatically. */
 			if (mcp251x_is_2510(spi))
 				clear_intf |= CANINTF_RX1IF;
 		}
 
+		/* combine flags from both operations for error handling */
+		intf = intf0 | intf1;
+		eflag = eflag0 | eflag1;
+
+		/* mask out flags we don't care about */
+		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
+
 		/* any error or tx interrupt we need to clear? */
 		if (intf & (CANINTF_ERR | CANINTF_TX))
 			clear_intf |= intf & (CANINTF_ERR | CANINTF_TX);
-- 
2.30.2

