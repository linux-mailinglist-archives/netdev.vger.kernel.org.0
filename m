Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347C2379CAF
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhEKCKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhEKCJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:25 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655FC06135C;
        Mon, 10 May 2021 19:07:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id j3-20020a05600c4843b02901484662c4ebso342744wmo.0;
        Mon, 10 May 2021 19:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mGHnGm/hpOZEaZYj5Kx0ZBgk1PIx8CsVXs93FeS0yH0=;
        b=bhHQo5vFJKoULMrOUPL6KGs10ONR1s3bpU4HKJEuNgAF+jPB4RbRurmu6gHib1mgYQ
         j11dlF0/g1NN7zQjZDAOkipi0+VdkuAfOqNKUnW23fENfBmqXTZ2rXHrOSQd584r6jII
         XJFol16lSLHMB/XTZhP0J+87ZLs/P/K7+DeaZnVYuR4TCrOJQWpUEf7gXf6Wd6NhdTeT
         rrqfJEZ3MQV1TtyhfuhtAvcIckGeA6Nk/XNsQLZl/vSzCdL+yxAaBsFFc4uViROjw6xT
         JhELKiZXLgh21VXO84MparenRp5N7/6pYHgGRM0mi6kouleDVyxtMzM95epFBu5cZMah
         i+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mGHnGm/hpOZEaZYj5Kx0ZBgk1PIx8CsVXs93FeS0yH0=;
        b=q9sYk7m51slp3wmubpuAVm9w/ONKWgZsqc6sIwXfwWp2f+eCKETDKavUBm1b1dhA7Q
         +0eh3itCP9a7Cug3E0JzcdAoAH6G93dGT+odxlWW3CQE1QOOc1SfqSkYI6qhAERwVAhl
         v7wgJlETYTsblLm3WJGK6JZQrkxYe9LHJv+OSJUrayRi8daCDkh0uDEAq93NeuBwVt++
         L1HV+4x3PbDHkcXDoyO8Xa85VDGl69Iw87cf05w7nkwxiTQOlJ2Yd2DYGI8zAlvG0afm
         j2RQlP4nElpFQH/bV22kxY0I2BNklwMkjdSG3a1DDKXKyT6cj1vKzcBG3QA2Ofyda+rP
         /F/Q==
X-Gm-Message-State: AOAM530OodEOyd8wusR3NNDP0MxAZyoD+rc58+KWSKLRkzgmOjaa5WNq
        9JYkif08VyCAlPHyi4JouQM=
X-Google-Smtp-Source: ABdhPJwJ+RBoO6ER4NAzW0JXDe7tEsUXzlThKzihEkmjt7L5cDdwH9yfqb5U4ONef5mD+8ZsntpDow==
X-Received: by 2002:a05:600c:4fd0:: with SMTP id o16mr29346962wmq.107.1620698864031;
        Mon, 10 May 2021 19:07:44 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:43 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 22/25] net: dsa: qca8k: improve internal mdio read/write bus access
Date:   Tue, 11 May 2021 04:04:57 +0200
Message-Id: <20210511020500.17269-23-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the internal mdio read/write bus access by caching the value
without accessing it for every read/write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 307fe7eb03f3..920cdb1ff2b9 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -655,6 +655,7 @@ static int
 qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = salve_bus->priv;
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -669,22 +670,22 @@ qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
 
 	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(priv->bus, page);
+	ret = qca8k_set_page(bus, page);
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_mdio_busy_wait(priv->bus, QCA8K_MDIO_MASTER_CTRL,
+	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	return ret;
 }
@@ -693,6 +694,7 @@ static int
 qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 {
 	struct qca8k_priv *priv = salve_bus->priv;
+	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -706,26 +708,26 @@ qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 
 	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	ret = qca8k_set_page(priv->bus, page);
+	ret = qca8k_set_page(bus, page);
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_mdio_busy_wait(priv->bus, QCA8K_MDIO_MASTER_CTRL,
+	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 	if (ret)
 		goto exit;
 
-	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
-	mutex_unlock(&priv->bus->mdio_lock);
+	mutex_unlock(&bus->mdio_lock);
 
 	if (val >= 0)
 		val &= QCA8K_MDIO_MASTER_DATA_MASK;
-- 
2.30.2

