Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B7C44AAE7
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245059AbhKIJxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242807AbhKIJxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B56C061767;
        Tue,  9 Nov 2021 01:50:48 -0800 (PST)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAIgtG2gp3vW7HRXGd/1SQnk8hM3CErk4xOJRxIoPy4=;
        b=MxiShnBCeruIZ6OUNZDjlmPNckzWmVeIwodAdtDHG6sXcZ9jT/Oy1fKDexO4vZ8WQbolQZ
        BR+sKRxo7z5Nl/JlzO84QX4lg09wZihftSfbKflXA+2XO2Wwbhroq+Q4WPUvIyu8Opgk8+
        mooLozMhbuwRdiNhv2f448PjGb8ud4GD0IQShn0r2KkF7Lvw8qv5G6yFpTvIu5ZFGQQSb7
        ImA8Q2j0nmilMe0L+VWYn00TzKDS9yix9sx5dV3S5+sMNZjMNaBRzrwLr1lv9IQYy9tzFU
        qQaPb7hy5bdtaFh6xJYNq23rFXsnhTPOc9Uy0i9RH2KsiDuaffjowlJdQ5f1iA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAIgtG2gp3vW7HRXGd/1SQnk8hM3CErk4xOJRxIoPy4=;
        b=l7HXjtYDaNWbSyXULGwrphGkVvQ3eIYb0bdPEbHuf1Pf4a3wJAxfDj4hZoghuXhFne/l+A
        abmjQN4xEfj2cPCA==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/7] net: dsa: b53: Add BroadSync HD register definitions
Date:   Tue,  9 Nov 2021 10:50:03 +0100
Message-Id: <20211109095013.27829-2-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

Add register definitions for the BroadSync HD features of
BCM53128. These will be used to enable PTP support.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 drivers/net/dsa/b53/b53_regs.h | 71 ++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index b2c539a42154..0deb11a7c9cd 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -50,6 +50,12 @@
 /* Jumbo Frame Registers */
 #define B53_JUMBO_PAGE			0x40
 
+/* BroadSync HD Register Page */
+#define B53_BROADSYNC_PAGE		0x90
+
+/* Traffic Remarking Register Page */
+#define B53_TRAFFICREMARKING_PAGE	0x91
+
 /* EEE Control Registers Page */
 #define B53_EEE_PAGE			0x92
 
@@ -260,6 +266,27 @@
 /* Broadcom header TX control (16 bit)	*/
 #define B53_BRCM_HDR_TX_DIS		0x62
 
+/*************************************************************************
+ * ARL Control Registers
+ *************************************************************************/
+
+/* Multiport Control Register (16 bit) */
+#define B53_MPORT_CTRL			0x0e
+#define   MPORT_CTRL_DIS_FORWARD	0
+#define   MPORT_CTRL_CMP_ETYPE		1
+#define   MPORT_CTRL_CMP_ADDR		2
+#define   MPORT_CTRL_CMP_ADDR_ETYPE	3
+#define   MPORT_CTRL_SHIFT(x)		((x) << 1)
+#define   MPORT_CTRL_MASK		0x2
+#define   MPORT0_TS_EN			BIT(15)
+
+/* Multiport Address N (N = 0–5) Register (64 bit) */
+#define B53_MPORT_ADDR(n)		(0x10 + ((n) << 4))
+#define   MPORT_ETYPE(x)		((u64)(x) << 48)
+
+/* Multiport Vector N (N = 0–5) Register (32 bit) */
+#define B53_MPORT_VCTR(n)		(0x18 + ((n) << 4))
+
 /*************************************************************************
  * ARL Access Page Registers
  *************************************************************************/
@@ -479,6 +506,50 @@
 #define   JMS_MIN_SIZE			1518
 #define   JMS_MAX_SIZE			9724
 
+/*************************************************************************
+ * BroadSync HD Page Registers
+ *************************************************************************/
+
+/* BroadSync HD Enable Control Register (16 bit) */
+#define B53_BROADSYNC_EN_CTRL		0x00
+
+/* BroadSync HD Time Stamp Report Control Register */
+#define B53_BROADSYNC_TS_REPORT_CTRL	0x02
+#define   TSRPT_PKT_EN			BIT(0)
+
+/* BroadSync HD PCP Value Control Register */
+#define B53_BROADSYNC_PCP_CTRL		0x03
+
+/* BroadSync HD Max Packet Size Register */
+#define B53_BROADSYNC_MAX_SDU		0x04
+
+/* BroadSync HD Time Base Register (32 bit) */
+#define B53_BROADSYNC_TIMEBASE		0x10
+
+/* BroadSync HD Time Base Adjustment Register (32 bit) */
+#define B53_BROADSYNC_TIMEBASE_ADJ	0x14
+
+/* BroadSync HD Slot Number and Tick Counter Register (32 bit) */
+#define B53_BROADSYNC_SLOT_CNT		0x18
+
+/* BroadSync HD Slot Adjustment Register (32 bit) */
+#define B53_BROADSYNC_SLOT_ADJ		0x1c
+
+/* BroadSync HD Class 5 Bandwidth Control Register */
+#define B53_BROADSYNC_CLS5_BW_CTRL	0x30
+
+/* BroadSync HD Class 4 Bandwidth Control Register */
+#define B53_BROADSYNC_CLS4_BW_CTRL	0x60
+
+/* BroadSync HD Egress Time Stamp Register */
+#define B53_BROADSYNC_EGRESS_TS		0x90
+
+/* BroadSync HD Egress Time Stamp Status Register */
+#define B53_BROADSYNC_EGRESS_TS_STS	0xd0
+
+/* BroadSync HD Link Status Register (16 bit) */
+#define B53_BROADSYNC_LINK_STS		0xe0
+
 /*************************************************************************
  * EEE Configuration Page Registers
  *************************************************************************/
-- 
2.20.1

