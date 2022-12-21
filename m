Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0978365334F
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiLUP0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiLUP0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:26:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C44248DE
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:55 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m19so22437439edj.8
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4xNKyUsvaXfBc3iUbNwfQj7kGAAWBTHhrvCBFQZpUU=;
        b=52QxhYPs+F0QvgoHcjHqY2chLRIcLMl5FPqqhjr7XB5Ej9buMkkxpu8jvstKww3K54
         XRlrPL2+JVczIXnXWD2+OK602DyWULP+nVUjTvdv6QmjZ5G4AJzZTtD/2OHeOQIBvPM7
         w/IRTWH2VKuTb74lJpnZiIg5gJY8Om9ZEiMcshUulCrCV2TEqvfxAuM2yao+jIQ7FEEd
         5J9VVmiAP3dC0mEzwPg+6JrgUiq7aOqV36VBIzeXm9IQSeNUE1vbmUjjzuKHznpUxL94
         P2hqzIk+NhRZOW49LrKUrrI5OJm6ZciFHb7YJlkaafCpgpU+IH0eY+J27Ivkq3JF32L6
         NQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r4xNKyUsvaXfBc3iUbNwfQj7kGAAWBTHhrvCBFQZpUU=;
        b=4hMHsGPzTVUuT0kl94tJd21upJK0BFuCF7A7rL5LBy/CwwpCEhfdEVOGhKeRwvFxmv
         CbPqgfeAUBiz6Ov9AQynjuJ2pWHCgYEA28IY3olxhNy6R2XDQTDnmNHKPdEguBsmWFYc
         XYxSvj7ELN9GOLVQNmEFLBn/6bCl40ponoWnSku/XRf0uEc5OJ3ox5rcTJSQCTRT3xhF
         1Rydf6FSuqQia6wCOjcpcO6CRThCySpTZ54cvrSC8IYMj4QXSHEvNQ92tXdLkeo9jSzg
         puO1f7SuS1dzyMe8FT8wvkfCXZd1tKC3epipJb+k4YMLJDacG8bfpiTRfd6OaMam411g
         wtPw==
X-Gm-Message-State: AFqh2krk2vhTodhRpHNobuX/yg3I5X/LJTVqSh6a6LoUWxMsg/FA/Kvh
        lcaD6/iTCPnntQBQxXYCCf9axQ==
X-Google-Smtp-Source: AMrXdXtOB58SBo1VGw1iWE3fwCZx07Rucqu1xCppcsfwv2RMOFP9Mcc6zIxb3bZU8SiaSNp18tExKg==
X-Received: by 2002:aa7:dd13:0:b0:47b:a6e:6b69 with SMTP id i19-20020aa7dd13000000b0047b0a6e6b69mr2080871edv.2.1671636354717;
        Wed, 21 Dec 2022 07:25:54 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:54 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 15/18] can: m_can: Introduce a tx_fifo_in_flight counter
Date:   Wed, 21 Dec 2022 16:25:34 +0100
Message-Id: <20221221152537.751564-16-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep track of the number of transmits in flight.

This patch prepares the driver to control the network interface queue
based on this counter. By itself this counter be
implemented with an atomic, but as we need to do other things in the
critical sections later I am using a spinlock instead.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 27 ++++++++++++++++++++++++++-
 drivers/net/can/m_can/m_can.h |  4 ++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 42cde31fc0a8..90c9ff474149 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -452,6 +452,10 @@ static void m_can_clean(struct net_device *net)
 
 	for (int i = 0; i != cdev->can.echo_skb_max; ++i)
 		can_free_echo_skb(cdev->net, i, NULL);
+
+	spin_lock(&cdev->tx_handling_spinlock);
+	cdev->tx_fifo_in_flight = 0;
+	spin_unlock(&cdev->tx_handling_spinlock);
 }
 
 /* For peripherals, pass skb to rx-offload, which will push skb from
@@ -1022,6 +1026,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	int i = 0;
 	int err = 0;
 	unsigned int msg_mark;
+	int processed = 0;
 
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
@@ -1051,12 +1056,17 @@ static int m_can_echo_tx_event(struct net_device *dev)
 
 		/* update stats */
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
+		++processed;
 	}
 
 	if (ack_fgi != -1)
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
 							  ack_fgi));
 
+	spin_lock(&cdev->tx_handling_spinlock);
+	cdev->tx_fifo_in_flight -= processed;
+	spin_unlock(&cdev->tx_handling_spinlock);
+
 	return err;
 }
 
@@ -1821,11 +1831,26 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 	}
 
 	netif_stop_queue(cdev->net);
+
+	spin_lock(&cdev->tx_handling_spinlock);
+	++cdev->tx_fifo_in_flight;
+	spin_unlock(&cdev->tx_handling_spinlock);
+
 	m_can_tx_queue_skb(cdev, skb);
 
 	return NETDEV_TX_OK;
 }
 
+static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
+					 struct sk_buff *skb)
+{
+	spin_lock(&cdev->tx_handling_spinlock);
+	++cdev->tx_fifo_in_flight;
+	spin_unlock(&cdev->tx_handling_spinlock);
+
+	return m_can_tx_handler(cdev, skb);
+}
+
 static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -1837,7 +1862,7 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 	if (cdev->is_peripheral)
 		return m_can_start_peripheral_xmit(cdev, skb);
 	else
-		return m_can_tx_handler(cdev, skb);
+		return m_can_start_fast_xmit(cdev, skb);
 }
 
 static int m_can_open(struct net_device *dev)
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index bf2d710c982f..adbd4765accc 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -109,6 +109,10 @@ struct m_can_classdev {
 	// Store this internally to avoid fetch delays on peripheral chips
 	int tx_fifo_putidx;
 
+	/* Protects shared state between start_xmit and m_can_isr */
+	spinlock_t tx_handling_spinlock;
+	int tx_fifo_in_flight;
+
 	struct m_can_tx_op *tx_ops;
 	int nr_tx_ops;
 	int next_tx_op;
-- 
2.38.1

