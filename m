Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3B588F72
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiHCPdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiHCPds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:33:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338E662C3
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:33:46 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v3so21101743wrp.0
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 08:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ororatech.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0umAYbB18JPdG3ZmPCkx39gW6/HCrNImGco95eRjbLE=;
        b=vvAjKhTnMfE1WOtRIHrwn4aQceY66tnhhJIlJlrHfBzwCq0bZYCrg0b/5zBmJA0dXF
         PPUKY4m9dc1sHGHSGEvHBIgoo+sCesx/L41p0YCubxRCLeQ3h10RM5gzqY9uqJ6zemEi
         frnk20o0H3C9lb40mODLFBWypNX5I3zE01TUqxhZVHR+jNuBwmADZSO19GFf12l7vz5M
         exH7JAIzyupcbiS3NppT1u9VVP+8QwZ9IZimwvUbRHg3GGWWJM6VBsKIVynKVsoRapxV
         17pm9zUEXAhEcc++IrS1L1hwteHbT2RDw+e9IXcayc0kwummKPxpZYjXE72UR82tPyXz
         wOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0umAYbB18JPdG3ZmPCkx39gW6/HCrNImGco95eRjbLE=;
        b=Rp1RQaqmVhcjX3Ihk6XiBKDuBpBrIUC4O56dyDSjlGuFQNZQ1yrnkT46ILxvYKdg9a
         deEotMH+JXDXeG3myMcgHXU96tLIo58tJkd9Y2o+hTaym/gP5JCISep9MNJ5bPQLQe3C
         kxWXm+bdKk+qqBXgeYWoLhBH8lnhF6qsHV7KYo/QA8pnt6C8fuOgF7WRefKttDAzEVy5
         5Egx7rMkU2lZsjmZOFOK10bIgBHL1OqPqw/fVGeYDMZTfjYj+nhLWuXRgJVJ+LcVsW50
         wyuPSBdpj8uYd7qS1FSMYvDV3O38uD8RCgDcxdVzEaJb2VWJNXygPWNNSiKEt4jZP0+8
         lmeA==
X-Gm-Message-State: ACgBeo1+xHMWYxk2IRdDSqJx6A20CgBMboh+ap1X6wsGCEKnvvWBf6Y3
        z7lODlbclsX3cxRW8EXvH7g79Q==
X-Google-Smtp-Source: AA6agR54iLIwbRC1Xy7tswVJx/HIgfcNEe28F3bPGIew4YgTJg3SKqCQfhPDdp/mo4fOcZJPCH7SNg==
X-Received: by 2002:adf:da45:0:b0:21d:8f3e:a3e0 with SMTP id r5-20020adfda45000000b0021d8f3ea3e0mr16366749wrl.310.1659540824764;
        Wed, 03 Aug 2022 08:33:44 -0700 (PDT)
Received: from toolbox.dsn.orora.tech (host-88-217-137-115.customer.m-online.net. [88.217.137.115])
        by smtp.googlemail.com with ESMTPSA id n18-20020a5d67d2000000b0020fff0ea0a3sm18273804wrw.116.2022.08.03.08.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 08:33:44 -0700 (PDT)
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
        <u.kleine-koenig@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/can/spi/mcp251x.c: Fix race condition on receive interrupt
Date:   Wed,  3 Aug 2022 17:32:59 +0200
Message-Id: <20220803153300.58732-1-sebastian.wuerl@ororatech.com>
X-Mailer: git-send-email 2.37.1
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

The mcp251x driver uses both receiving mailboxes of the can controller
chips. For retrieving the CAN frames from the controller via SPI, it checks
once per interrupt which mailboxes have been filled, an will retrieve the
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

Signed-off-by: Sebastian Würl <sebastian.wuerl@ororatech.com>
---
 drivers/net/can/spi/mcp251x.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 666a4505a55a..687aafef4717 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1063,17 +1063,14 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
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
@@ -1083,14 +1080,24 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 						   CANINTF_RX0IF, 0x00);
 		}
 
+		/* intf needs to be read again to avoid a race condition */
+		mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);
+
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
2.36.1

