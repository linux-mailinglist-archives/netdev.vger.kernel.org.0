Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA945898EC
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiHDIBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbiHDIAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:00:44 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D899413F7A
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 01:00:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n185so9881880wmn.4
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 01:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ororatech.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ZmSGwqc22zHtNCEdp7Vy7QwaMLxmz8BdxpDnQjqdtXg=;
        b=KIkxKI6luZq5tLkph4q7fQi4668NPC6UFYLq0iwb+oG0K7RPx8awcoUYNCkNvbmfN+
         XYp4xqDMW8NWA0U1fD/R57XN8pMjg671P/jSqu2+aab+0CE60Zu6tzbi1C1yfl0peZ/a
         o1AmiIahXnT3P49w4n+R/8iSJN//zocvmMt/nkYWRP4m+82w8udfImtdwzL+QEhVgp+3
         mqSPeZCjaSmhIvMtdgF3SywUSSBia+tUk/Ir4U5jmNs0j9Teriy5T82GWYdkwFpXrWjR
         X7Vb+ZjAeZdjjxFxYq3dSkIjPcPEtogHnVrn0CgnVcPHMTzSjMpk4IFYiwwV68XGQVOh
         MXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ZmSGwqc22zHtNCEdp7Vy7QwaMLxmz8BdxpDnQjqdtXg=;
        b=fldttrsFro/cRipEEcLu+oxywVmRE4tHbAlLGJNaZvli/+dGgJ89PAIO3BiQX6FQEQ
         qFj6Y4YwRD4oE6mNShz10faylEFV3wBEdGQ3TL0/b1aBpH+EJ7GFPQhf4ASXGioerd3p
         F41qyYhBkdikDxWwsjpLr8LIggtlvh/5N6VK5P7gXOVEcTSrsHbhkUiPpWPBNZnjykZ6
         JeQHX+G36eUMZNQpkOcvzNJ+MJDa/xAZ1wvUasnl78hB3Aq3QrVcAygCvUib5hlzdpjM
         WwSl963glO+Y8jB4N1iUjeLCNaoTjAObo6qbrkrWGmmUmouxERPNCSSqURJQ9CV33vZJ
         QeDg==
X-Gm-Message-State: ACgBeo1/oE9xW905U4aWOe5Pa6+dlPCHxxpR1E3Ja0tJqGVqJKfYCjoy
        G6VWElwDXorzikYBKzpmIuERLg==
X-Google-Smtp-Source: AA6agR6pevlYnJMHzIdk0hsOSR/fooey3Mj1GDawX/YAJI5hKRtyeKVZO7fVCGKmzapwgbaSuujYZw==
X-Received: by 2002:a7b:ca47:0:b0:3a3:1874:648 with SMTP id m7-20020a7bca47000000b003a318740648mr489939wml.139.1659600041325;
        Thu, 04 Aug 2022 01:00:41 -0700 (PDT)
Received: from toolbox.dsn.orora.tech (host-88-217-137-115.customer.m-online.net. [88.217.137.115])
        by smtp.googlemail.com with ESMTPSA id bv20-20020a0560001f1400b0021d6d18a9f8sm335653wrb.76.2022.08.04.01.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 01:00:40 -0700 (PDT)
From:   =?UTF-8?q?Sebastian=20W=C3=BCrl?= <sebastian.wuerl@ororatech.com>
To:     sebastian.wuerl@ororatech.com
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] can: mcp251x: Fix race condition on receive interrupt
Date:   Thu,  4 Aug 2022 09:59:14 +0200
Message-Id: <20220804075914.67569-1-sebastian.wuerl@ororatech.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220804075152.kqlp5weoz4grzbpp@pengutronix.de>
References: <20220804075152.kqlp5weoz4grzbpp@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/can/spi/mcp251x.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 89897a2d41fa..df748b2e7421 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1068,15 +1068,12 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 	mutex_lock(&priv->mcp_lock);
 	while (!priv->force_quit) {
 		enum can_state new_state;
-		u8 intf, eflag;
+		u8 intf, intf1, eflag, eflag1;
 		u8 clear_intf = 0;
 		int can_id = 0, data1 = 0;
 
 		mcp251x_read_2regs(spi, CANINTF, &intf, &eflag);
 
-		/* mask out flags we don't care about */
-		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
-
 		/* receive buffer 0 */
 		if (intf & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
@@ -1086,6 +1083,16 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF,
 						   CANINTF_RX0IF, 0x00);
+
+			/* check ifbuffer 1 is already known to be full, no need to re-read */
+			if (!(intf & CANINTF_RX1IF)) {
+				/* intf needs to be read again to avoid a race condition */
+				mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);
+
+				/* combine flags from both operations for error handling */
+				intf |= intf1;
+				eflag |= eflag1;
+			}
 		}
 
 		/* receive buffer 1 */
@@ -1096,6 +1103,9 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 				clear_intf |= CANINTF_RX1IF;
 		}
 
+		/* mask out flags we don't care about */
+		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
+
 		/* any error or tx interrupt we need to clear? */
 		if (intf & (CANINTF_ERR | CANINTF_TX))
 			clear_intf |= intf & (CANINTF_ERR | CANINTF_TX);
-- 
2.30.2

