Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B3A128B27
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfLUTgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:53 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50537 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUTgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:50 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so5628856pjb.0;
        Sat, 21 Dec 2019 11:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iufX15HyInYqkt5BpnF9hIl241zgF1i5PO7B69MX67w=;
        b=MyGjMkqM0mdZt4j5JnOVa5hLXaWM63cQX4YChVDAoDaG2TTHoozJ4+w/E/kdimkgX+
         pc6ibfflP+lWfnG3VQqZvm5W/k0zU8yspfxwZbf/Kbft8v6Fx6JSsQ6B8VOqlHp7L0GE
         pDjM86Bn/X+jr6hMSN6CQEQKuKEAg7siXSJvKCJBOTyM11Og7GMukeGq5LStAy2R8E2T
         aTYJhuNNp3Le6JUxI2YafsRfn7vkAAiNhv/XoyLelUTFs/p6o7Srf6bGD81WefiFs+vo
         HJPfW6nZGC634albWGQx1T5A/9q0lz+1xkPEABGKaWxs8zQAEzsoFLJ4evDUI6Xwl6vo
         SogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iufX15HyInYqkt5BpnF9hIl241zgF1i5PO7B69MX67w=;
        b=adH0w8BwuLREjj6OTNCypTZr5fimzuPtriMfGNqb25zGoEdnT2aENN8SZa7xLKjHPZ
         WIkNeusGfm3lfOEqaBZodcLRg9foFvMn9okqpza5D50e3d1DxhGobT0teQFae36PLN6x
         3IILl6Pvf7Wv4/rApzwAQNzACJrChJlJD3SruQ+HGZHQzSar8LKMuisB1CntqmDHdU9o
         gQ+mbAckUWfS0739wfrRklPa6GIDIzhIjf2wZJzZIK+IumaefthY345pKItjBMJiKGcX
         Qd4PJC3EB/cIy7pjMizCxl1jsPaMmzEiV4fITyIhyoxuFYS+gz2SBciEcruXfzPJ0OKO
         qPSg==
X-Gm-Message-State: APjAAAV7k4UfDm8wvm8RU7qOKTSy6ErRI5MnmUjSK09qWOBQrjilyvqZ
        c5qqFF3b/1/XVT4/5Voutbtf1KSI
X-Google-Smtp-Source: APXvYqzqvg9i0YnGGTSSZN17isYLVDaza6jFl7oSWzlolylv0vZvQ7NE479FGzbsIpdq7LFuT7eLuA==
X-Received: by 2002:a17:90b:4383:: with SMTP id in3mr5519564pjb.111.1576957009810;
        Sat, 21 Dec 2019 11:36:49 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:49 -0800 (PST)
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
Subject: [PATCH V8 net-next 06/12] net: phy: dp83640: Move the probe and remove methods around.
Date:   Sat, 21 Dec 2019 11:36:32 -0800
Message-Id: <ed071a6dc40506744a7db58a4207ac8d7cdd993e.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
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

