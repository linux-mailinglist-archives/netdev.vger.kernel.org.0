Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F83FF8FDA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKLMoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34155 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbfKLMor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so18433044wrw.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EiYiX/kmOPogNm6cQNtCRHKk2Gxmhi5DMg9ko2kAIaY=;
        b=nIYNtFGJm4bN5YwTYCAXtHGq0tf/y7g31uchKNXRtZibv6hh0d9Z3kLRk0wsEDjRhT
         dPz0GVcCXM+6r9sQLTZXx+Y0+T0k8UxJPZYX79aNIcVcT4QZFAETFEUKCbOdECucSPzn
         yK3tE2uNgjqhLuyg5Jnv7yI4aRkKfzaH+0I0sdLu+3L3Tna8n87LFwQCUAvZvBYOydtm
         PpCJB76YNWx31S3qR5UL+LRXgRnrZMmSGO4495vDzal8o+bbYG84OZz7bPEwdF7w3ShT
         UuHp9/PZlv/twBqn3tpYxHIXlXOIeS8kVgipzpxlORIFoUDHHvn+tDqxqKXrGZCnTevq
         Ttmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EiYiX/kmOPogNm6cQNtCRHKk2Gxmhi5DMg9ko2kAIaY=;
        b=Cnnzp58MBWEdJLATHAUqAIet8RO92Mjh2wSVwoE/BP9Xa3ps2bFwk3iOFoaPZHErvg
         dKOBe/VgQkoqjcRuhdlmj+oe7bpwjrZp7hNhQZYRs9MUwY7jUrCfC4T9yrUNd8BRSphL
         KwenLNN3Wji8EkVTtn1L1M2uALKLiPhWlBqUp4ToWUsFelQPU70wDTWChFRfGrbb1sxO
         V3WYSQDSq7hrQvdoBBP8A9CV2HAvm+ZzSztEOxuylN+4c6JL01MK5xS9eaXPrxdaXFqE
         EN2g3l8HXRObG4seAC/P1lWoLNtlDzXEOlJQ/mEJJL6lmUCuYGuoikjIcI+xoF85UeZV
         BQQg==
X-Gm-Message-State: APjAAAVOxszCP+DxKZ5xNmeH4PCGIc60PL7TdKPNwpJBOVlQI5JvRlv+
        d70lMu2vszzJt1utxaw2AsA=
X-Google-Smtp-Source: APXvYqwpNSXg6WR1++T4D0iLkDXus++cyJguOzDSVqpf3zTaLYh/jEMSOA8pVc641dtW4opzw2dMXw==
X-Received: by 2002:adf:97dd:: with SMTP id t29mr3790211wrb.283.1573562685808;
        Tue, 12 Nov 2019 04:44:45 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 05/12] net: mscc: ocelot: export a constant for the tag length in bytes
Date:   Tue, 12 Nov 2019 14:44:13 +0200
Message-Id: <20191112124420.6225-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This constant will be used in a future patch to increase the MTU on NPI
ports, and will also be used in the tagger driver for Felix.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

