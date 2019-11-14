Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5459CFC977
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKNPEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40441 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfKNPEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id f3so6259171wmc.5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N+yjJI5N3aVke0pDwwko1vig4MZhkQyNn75pjX2hX2M=;
        b=JsqQMr0uoW6RlM6irA2gF5tOZTdEXC3juI/mxqRz79A+KZleflGeKPdT9is7Rqysd5
         +6ABZcYo+hBUQ1eNvgIGQEtYgbSV+nKQQta7xWbMVNcyin872NPQTh4hviQc8Dzvo/qN
         2STYUZF06pvclnSN8lAQ4UjJMvdV5HgGniA2yUD6T3Y7TIWWvIdwKgYI75DM1YvFGKsT
         y3DMsk/4Hz/Q/Pw+jSYExUtcT3j5rkxL9cBxhvwKZc1sKY55OwzevJ7AtXDgdvjNYCV5
         ta0VcEQFx1zqu4esAQEuAZ3Rs14hf6f8ZQG+sBec54ArkwZ2VbBpBAH7s00OaRKzSPGm
         pO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N+yjJI5N3aVke0pDwwko1vig4MZhkQyNn75pjX2hX2M=;
        b=LSHr9vC3gQHjh9LGe6ZHzDb22bqlxEyGcP8wUjZydSfQJP78eksyTQB9Dc+mciJECh
         l/m8pCgZuNmr8jCHmxj6xj+LlH8CEBR8nsv9gDtAuOTXiwwBAx0RbZ0LDmylKdEP5FAs
         /Umt6i18Jm03uP1mdW1rpsVBU0OyooOLrDi/j4m6Kp1+jL1c53JCn5IiQCf3CK0io2qS
         1rTWLcnuvC4MFW0WRLxiCq4XBHBwe3lLYuzNARHm9hi/b/QgryhSEVysKq2eaKBdHCQe
         RhGExdfAVikAGjVj2VauCSQvwtTK/R1ZrxBt3B47WZddh0WE4DaiBiQ3iQWaGc5iIC3j
         SV0A==
X-Gm-Message-State: APjAAAXk3iJKKdUzUN0j9QyEPHvw+UYPcFleic4XiY8cv/Q7Pi+qmqUd
        qPZr6Zu4kD5QM9fjxEnKUmU=
X-Google-Smtp-Source: APXvYqwE8DAHo+lmoNIjrOdMxP3v4MwmcU79lRp406N+FePy2dCdshJBjUS5pkqhFT3rjwz1Rv0hFQ==
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr7772859wmg.99.1573743858460;
        Thu, 14 Nov 2019 07:04:18 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 05/11] net: mscc: ocelot: export a constant for the tag length in bytes
Date:   Thu, 14 Nov 2019 17:03:24 +0200
Message-Id: <20191114150330.25856-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This constant will be used in a future patch to increase the MTU on NPI
ports, and will also be used in the tagger driver for Felix.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c       | 4 ++--
 drivers/net/ethernet/mscc/ocelot.h       | 4 ++--
 drivers/net/ethernet/mscc/ocelot_board.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8ede8ad902c9..8b73d760dfa5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -576,11 +576,11 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	u32 val, ifh[OCELOT_TAG_LEN / 4];
 	struct frame_info info = {};
 	u8 grp = 0; /* Send everything on CPU group 0 */
 	unsigned int i, count, last;
 	int port = priv->chip_port;
-	u32 val, ifh[IFH_LEN];
 
 	val = ocelot_read(ocelot, QS_INJ_STATUS);
 	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
@@ -603,7 +603,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	ocelot_gen_ifh(ifh, &info);
 
-	for (i = 0; i < IFH_LEN; i++)
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
 		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
 				 QS_INJ_WR, grp);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 7e28434c22c1..9159b0adf1e7 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -43,8 +43,6 @@
 
 #define OCELOT_PTP_QUEUE_SZ	128
 
-#define IFH_LEN 4
-
 struct frame_info {
 	u32 len;
 	u16 port;
@@ -66,6 +64,8 @@ struct frame_info {
 #define IFH_REW_OP_TWO_STEP_PTP		0x3
 #define IFH_REW_OP_ORIGIN_PTP		0x5
 
+#define OCELOT_TAG_LEN			16
+
 #define OCELOT_SPEED_2500 0
 #define OCELOT_SPEED_1000 1
 #define OCELOT_SPEED_100  2
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index de2da6d33d43..32aafd951483 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -105,7 +105,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		int sz, len, buf_len;
 		struct sk_buff *skb;
 
-		for (i = 0; i < IFH_LEN; i++) {
+		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
 			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
 			if (err != 4)
 				break;
-- 
2.17.1

