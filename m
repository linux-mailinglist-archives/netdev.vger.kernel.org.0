Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A4E58991A
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbiHDIPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiHDIPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:15:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8832674
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 01:15:17 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z12so14202953wrs.9
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 01:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ororatech.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=u0fPxWrfHBCAK7CNXAq0lMMiBJFpcqgKyrM33HYWfD0=;
        b=H5zNallHCpcL7sb5swZAjzXZw+V6YuNIbp89IVNGRlgT4nRgYWMFgVahqaE0rqvM//
         0N929iUQFhKUM0RMw5l/+FAo40iWhAnEtIOTS4QredVKptpHM7CTgqhG41CNoQfDdjE/
         BoentPZMZNJxIS5H2nmrZN8YmHKwJzqtHOMc/V9lC/mgqdYek8O8Exd182pD7oF36iXB
         3MXhc6VzCh0XQq6uSs7BpfO/uzI8T+frMWRtWZgr7oU4eiVBCUxT0s6cLlRmsZiC0zKy
         AKrosg1hUuAoAn/jvYhE1OuENnPDGqYRluuPKiaODAdT2aGZqC3HBl0y/YAr0+hiyIhH
         lALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=u0fPxWrfHBCAK7CNXAq0lMMiBJFpcqgKyrM33HYWfD0=;
        b=gn/f4D84ZfmGsTmWawV+DK1Mb/Y4H6JblFdMkc1wgiy6hERMT4kPtEBsFt35FJTWwN
         lvduuq2ZBYT0Ij1Nzm7Jw2k6rB99oPN4HmhjVoKxiu9V0WDYGxwwB2NQHugPxr2zLSkG
         Q3bDKxnE1Aaa3Bofq2bntbyqVvE/ftsVu13hWCgNphqcTrudX7IuXU9bNJLmPzhb0gDI
         bd0KP7+z9A8HRGIF/cfc4rLFUVDPX1YvdMShpqCR/xzXTn5nEXA6H0On2Sy47C1BnhBF
         2mtgM/iRYfvzd+lVf+91mBAm/r1VIna1KuKohz+Jhv6HzjGWBFVBEayYKDURBAglF5gj
         vANg==
X-Gm-Message-State: ACgBeo0WlMEIaXxgRenVyHsSfB/x5QcmOJN85G8oYvph9+Mx24zvZgun
        N94815T0GQUpANgPwaSnB5seyg==
X-Google-Smtp-Source: AA6agR4Wti/eqOETZ1+yhhNM+qHHe4drEgM8/ZqEeyEiE0q/YFAeeKJlgMGFAKhM1UOdP5E+ZKxDuw==
X-Received: by 2002:a5d:63cb:0:b0:21e:b81d:8b0d with SMTP id c11-20020a5d63cb000000b0021eb81d8b0dmr568865wrw.526.1659600916294;
        Thu, 04 Aug 2022 01:15:16 -0700 (PDT)
Received: from toolbox.dsn.orora.tech (host-88-217-137-115.customer.m-online.net. [88.217.137.115])
        by smtp.googlemail.com with ESMTPSA id e39-20020a5d5967000000b002205cbc1c74sm332505wri.101.2022.08.04.01.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 01:15:15 -0700 (PDT)
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
Subject: [PATCH v4] can: mcp251x: Fix race condition on receive interrupt
Date:   Thu,  4 Aug 2022 10:14:11 +0200
Message-Id: <20220804081411.68567-1-sebastian.wuerl@ororatech.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220804075914.67569-1-sebastian.wuerl@ororatech.com>
References: <20220804075914.67569-1-sebastian.wuerl@ororatech.com>
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
+			/* check if buffer 1 is already known to be full, no need to re-read */
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

