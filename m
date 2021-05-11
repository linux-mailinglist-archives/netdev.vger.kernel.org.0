Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5998B379CA1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhEKCKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhEKCJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:16 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8957AC06138A;
        Mon, 10 May 2021 19:07:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l13so18457156wru.11;
        Mon, 10 May 2021 19:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNPoW8mxh+bt5rBkPEBaaGVqTkrR9wt2Nd03MOmz1f8=;
        b=sjir3yn/okQfbGWBKcivVY1eN6VNM1//kkXOq7tRMb4gJgZXh27qnQpBj2RjH2cvSR
         KMZd+0skmvHq2NZ8lS4MhEPVDpNCDrIyzDsMSsN4U8vGrPY+OrKlEs9S0p4MwTKgcWvp
         7QEQXGog+1XDrPsO4W8IDUrPgTao1q+QJKOx6iadiFbuAzgSz+427thcUy+BTu1BUUwg
         aI8yKbBGDqFKBB8xDdcvYU6QSPte+q5/vW85oKOB2N9F/w0nZkHUv+q5q/sDQSqyeuO+
         0Dzf9KQd2PZVkoZARvu5/6gCNeYHz/iuu5+1t+cjDSVdP+T4IXSb+SIEWlEOGqZSswv/
         Dahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNPoW8mxh+bt5rBkPEBaaGVqTkrR9wt2Nd03MOmz1f8=;
        b=Zs/Q4ubv92hnD8jDjMowaoKEnzriY7/edYt4KfarON/tHJ05lrI/TeQczSWT7aO43j
         ic/InbyUaBG1sI5KgTG8xg0jBz7mFrTLFXN+lSWodT74CNvlz64taMYDDmCRWnMwIBpE
         jxrgjkaiaTAcOxTdv3QnOmrPYrYBPV2UOiSIiYFS26DwwgPxdocMF6xsBP/I/dHnVO9O
         KkayHNaHELf5uwwRbKc/H306KV+2qY1MJ7TJ6SODPb68xo+k6sLdP1SJxiNhyv1F8okq
         U5zMRrs2w3dnCYJ8M5GG48WRmZKmisd2EbrI95VD72AvU6Iwmmpy8D3ZtF4OPzEMNpQB
         QtUQ==
X-Gm-Message-State: AOAM5335ln/hD4x+VOMfer2QAL6vReeX/jYLGx2RxgQQSou/HKA3KcuP
        WCgtvQkg5VM+TIn5EyEXzz8QvWtaJDMwcQ==
X-Google-Smtp-Source: ABdhPJyG3uECTjHj0cB2bM1IvuNRfHGRJsyZgEcttvSLwJDCSgKvae0KteUmMa+rpeZ4xzisT+wvFg==
X-Received: by 2002:a5d:4b4e:: with SMTP id w14mr34853329wrs.9.1620698860129;
        Mon, 10 May 2021 19:07:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:39 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 18/25] net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
Date:   Tue, 11 May 2021 04:04:53 +0200
Message-Id: <20210511020500.17269-19-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO_MASTER operation have a dedicated busy wait that is not protected
by the mdio mutex. This can cause situation where the MASTER operation
is done and a normal operation is executed between the MASTER read/write
and the MASTER busy_wait. Rework the qca8k_mdio_read/write function to
address this issue by binding the lock for the whole MASTER operation
and not only the mdio read/write common operation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 68 +++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6f713289703b..fd74fcaf815f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -627,9 +627,32 @@ qca8k_port_to_phy(int port)
 	return port - 1;
 }
 
+static int
+qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	u16 r1, r2, page;
+	u32 val;
+	int ret;
+
+	qca8k_split_addr(reg, &r1, &r2, &page);
+
+	ret = read_poll_timeout(qca8k_mii_read32, val, !(val & mask), 0,
+				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
+				priv->bus, 0x10 | r2, r1);
+
+	/* Check if qca8k_read has failed for a different reason
+	 * before returnting -ETIMEDOUT
+	 */
+	if (ret < 0 && val < 0)
+		return val;
+
+	return ret;
+}
+
 static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -645,12 +668,21 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
+
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
+
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
@@ -662,6 +694,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -676,21 +709,30 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
-	if (ret)
-		return ret;
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	ret = qca8k_set_page(priv->bus, page);
 	if (ret)
-		return ret;
+		goto exit;
 
-	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
-	if (val < 0)
-		return val;
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
+	if (ret)
+		goto exit;
+
+	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+exit:
+	mutex_unlock(&priv->bus->mdio_lock);
+
+	if (val >= 0)
+		val &= QCA8K_MDIO_MASTER_DATA_MASK;
+
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
 			QCA8K_MDIO_MASTER_EN);
-- 
2.30.2

