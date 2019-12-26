Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934C212A9A1
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfLZCQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:36 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37261 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLZCQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:32 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so12201102pga.4;
        Wed, 25 Dec 2019 18:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=suWtf3nURbS649jyBxL+jH/SGQj8upfDgdY7dmR5XqQ=;
        b=A9CD3PtrhgU7lrba5AzCnoUdW5ln5QvFW6URzDHZWrG8WjXrhDLBEwEeNAgP6QeQOg
         c/K2PNNsOEKJfW9QyKazI3nqunzxaK8+wqHPYhj4tkHQNvStexbcc0m4P39PyVC6mcZ6
         8+rwMqhbLrfSiuckxYWLS9/GZxuhqrlDDNhPH9GDT6lXRHLiq/A7mqzxeTBtGrIzUg/6
         uTyGrtfv+jRAlsosM8WAldn7yPze9+BAySYkQEF9xx9pamVuigCivBNgKO+MBFoVASbI
         vPwT7X4M/OE3002C06kOD91m+hJEFpoG7LI3XRLPCOFeiOQk3CAbA0Nyc6xlllyZBVbl
         MCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=suWtf3nURbS649jyBxL+jH/SGQj8upfDgdY7dmR5XqQ=;
        b=tHEcUmaC5rYmp281pWFEkBRpoQdXKRf1PoZ6aJjZfV3kE7J9QWAJBbjgWQMULQqDgz
         YScWl131hgNFpBOWSuhTrl5GmIwDSXDMLC6t+wMtrA6HU8gPgeL8uARRt3YoI65L8QhF
         ECPgRSwUqZeEUpmFo68IiwFnwH4m5s9mLFjv1LHQoMVna6XTf9QFb4xfZd5q9a62SBaP
         DBpvNTiGgvKc049U0jdvenmbq/yQkDn1bPQ1r3+WNXX28Nr+rF+3Moi0WkncgrHsbvAW
         qZCihjJCQXRLgAgL2bjC0tq7IT7Sb8Guks8P5TpRU5ZwDxi3FpLr9ShJxv5GdVl+g4cv
         oH8w==
X-Gm-Message-State: APjAAAX/48GyF2SL3J1eMNMWlCZwnFYe9yTE1wUDzM2wYfJUnp9C7EF2
        FipWsrLZkL5Wu/QI2JsIbqtvOZvU
X-Google-Smtp-Source: APXvYqxFKg4LK6qRjjJRqhvrPq/eK+kCFIFDn8BVA4REMuEv+IdRMmgmHbi1gypGkVKDEP/+r7OsBw==
X-Received: by 2002:a63:eb02:: with SMTP id t2mr46211808pgh.289.1577326590733;
        Wed, 25 Dec 2019 18:16:30 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:30 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 06/12] net: phy: dp83640: Move the probe and remove methods around.
Date:   Wed, 25 Dec 2019 18:16:14 -0800
Message-Id: <feda36d70c7d5defbaecb659bf988b26495490cf.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An upcoming patch will change how the PHY time stamping functions are
registered with the networking stack, and adapting this driver would
entail adding forward declarations for four time stamping methods.
However, forward declarations are considered to be stylistic defects.
This patch avoids the issue by moving the probe and remove methods
immediately above the phy_driver interface structure.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/dp83640.c | 180 +++++++++++++++++++-------------------
 1 file changed, 90 insertions(+), 90 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 8f241b57fcf6..b58abdb5491e 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1131,96 +1131,6 @@ static void dp83640_clock_put(struct dp83640_clock *clock)
 	mutex_unlock(&clock->clock_lock);
 }
 
-static int dp83640_probe(struct phy_device *phydev)
-{
-	struct dp83640_clock *clock;
-	struct dp83640_private *dp83640;
-	int err = -ENOMEM, i;
-
-	if (phydev->mdio.addr == BROADCAST_ADDR)
-		return 0;
-
-	clock = dp83640_clock_get_bus(phydev->mdio.bus);
-	if (!clock)
-		goto no_clock;
-
-	dp83640 = kzalloc(sizeof(struct dp83640_private), GFP_KERNEL);
-	if (!dp83640)
-		goto no_memory;
-
-	dp83640->phydev = phydev;
-	INIT_DELAYED_WORK(&dp83640->ts_work, rx_timestamp_work);
-
-	INIT_LIST_HEAD(&dp83640->rxts);
-	INIT_LIST_HEAD(&dp83640->rxpool);
-	for (i = 0; i < MAX_RXTS; i++)
-		list_add(&dp83640->rx_pool_data[i].list, &dp83640->rxpool);
-
-	phydev->priv = dp83640;
-
-	spin_lock_init(&dp83640->rx_lock);
-	skb_queue_head_init(&dp83640->rx_queue);
-	skb_queue_head_init(&dp83640->tx_queue);
-
-	dp83640->clock = clock;
-
-	if (choose_this_phy(clock, phydev)) {
-		clock->chosen = dp83640;
-		clock->ptp_clock = ptp_clock_register(&clock->caps,
-						      &phydev->mdio.dev);
-		if (IS_ERR(clock->ptp_clock)) {
-			err = PTR_ERR(clock->ptp_clock);
-			goto no_register;
-		}
-	} else
-		list_add_tail(&dp83640->list, &clock->phylist);
-
-	dp83640_clock_put(clock);
-	return 0;
-
-no_register:
-	clock->chosen = NULL;
-	kfree(dp83640);
-no_memory:
-	dp83640_clock_put(clock);
-no_clock:
-	return err;
-}
-
-static void dp83640_remove(struct phy_device *phydev)
-{
-	struct dp83640_clock *clock;
-	struct list_head *this, *next;
-	struct dp83640_private *tmp, *dp83640 = phydev->priv;
-
-	if (phydev->mdio.addr == BROADCAST_ADDR)
-		return;
-
-	enable_status_frames(phydev, false);
-	cancel_delayed_work_sync(&dp83640->ts_work);
-
-	skb_queue_purge(&dp83640->rx_queue);
-	skb_queue_purge(&dp83640->tx_queue);
-
-	clock = dp83640_clock_get(dp83640->clock);
-
-	if (dp83640 == clock->chosen) {
-		ptp_clock_unregister(clock->ptp_clock);
-		clock->chosen = NULL;
-	} else {
-		list_for_each_safe(this, next, &clock->phylist) {
-			tmp = list_entry(this, struct dp83640_private, list);
-			if (tmp == dp83640) {
-				list_del_init(&tmp->list);
-				break;
-			}
-		}
-	}
-
-	dp83640_clock_put(clock);
-	kfree(dp83640);
-}
-
 static int dp83640_soft_reset(struct phy_device *phydev)
 {
 	int ret;
@@ -1526,6 +1436,96 @@ static int dp83640_ts_info(struct phy_device *dev, struct ethtool_ts_info *info)
 	return 0;
 }
 
+static int dp83640_probe(struct phy_device *phydev)
+{
+	struct dp83640_clock *clock;
+	struct dp83640_private *dp83640;
+	int err = -ENOMEM, i;
+
+	if (phydev->mdio.addr == BROADCAST_ADDR)
+		return 0;
+
+	clock = dp83640_clock_get_bus(phydev->mdio.bus);
+	if (!clock)
+		goto no_clock;
+
+	dp83640 = kzalloc(sizeof(struct dp83640_private), GFP_KERNEL);
+	if (!dp83640)
+		goto no_memory;
+
+	dp83640->phydev = phydev;
+	INIT_DELAYED_WORK(&dp83640->ts_work, rx_timestamp_work);
+
+	INIT_LIST_HEAD(&dp83640->rxts);
+	INIT_LIST_HEAD(&dp83640->rxpool);
+	for (i = 0; i < MAX_RXTS; i++)
+		list_add(&dp83640->rx_pool_data[i].list, &dp83640->rxpool);
+
+	phydev->priv = dp83640;
+
+	spin_lock_init(&dp83640->rx_lock);
+	skb_queue_head_init(&dp83640->rx_queue);
+	skb_queue_head_init(&dp83640->tx_queue);
+
+	dp83640->clock = clock;
+
+	if (choose_this_phy(clock, phydev)) {
+		clock->chosen = dp83640;
+		clock->ptp_clock = ptp_clock_register(&clock->caps,
+						      &phydev->mdio.dev);
+		if (IS_ERR(clock->ptp_clock)) {
+			err = PTR_ERR(clock->ptp_clock);
+			goto no_register;
+		}
+	} else
+		list_add_tail(&dp83640->list, &clock->phylist);
+
+	dp83640_clock_put(clock);
+	return 0;
+
+no_register:
+	clock->chosen = NULL;
+	kfree(dp83640);
+no_memory:
+	dp83640_clock_put(clock);
+no_clock:
+	return err;
+}
+
+static void dp83640_remove(struct phy_device *phydev)
+{
+	struct dp83640_clock *clock;
+	struct list_head *this, *next;
+	struct dp83640_private *tmp, *dp83640 = phydev->priv;
+
+	if (phydev->mdio.addr == BROADCAST_ADDR)
+		return;
+
+	enable_status_frames(phydev, false);
+	cancel_delayed_work_sync(&dp83640->ts_work);
+
+	skb_queue_purge(&dp83640->rx_queue);
+	skb_queue_purge(&dp83640->tx_queue);
+
+	clock = dp83640_clock_get(dp83640->clock);
+
+	if (dp83640 == clock->chosen) {
+		ptp_clock_unregister(clock->ptp_clock);
+		clock->chosen = NULL;
+	} else {
+		list_for_each_safe(this, next, &clock->phylist) {
+			tmp = list_entry(this, struct dp83640_private, list);
+			if (tmp == dp83640) {
+				list_del_init(&tmp->list);
+				break;
+			}
+		}
+	}
+
+	dp83640_clock_put(clock);
+	kfree(dp83640);
+}
+
 static struct phy_driver dp83640_driver = {
 	.phy_id		= DP83640_PHY_ID,
 	.phy_id_mask	= 0xfffffff0,
-- 
2.20.1

