Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98B368AB2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbhDWBti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240408AbhDWBtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:49:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABAAC06138E;
        Thu, 22 Apr 2021 18:48:13 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r12so71623144ejr.5;
        Thu, 22 Apr 2021 18:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lAG/o0OGYJIRUzC/3iPfA0VGTvJTckfhIeXmdYy8D7s=;
        b=hP2RhnO2AfBseuJQQrTryszUEBwW99L+V55epRVWN5clVCRfFKOrwkqfJw7a79M/KC
         ZzEtKZXwaQRJwMDK4jCjP6QpbkBFhPIz3V+a5NX900DkCNMdOmCxF5gF6u/eLy25b+FY
         pJqdoBAPgrUskY89PmbCOQAAjA+P+kbuIdZSW2MGKSL5Xmg/ZN5xS1mDmHPfE2WZRc3t
         dAIjRtwZYsRTXy3zvgJ5mzZnGZdOFa/bdmcpYhKcPu/NtXLyteKv8CX4Bn28JnbMXydd
         tk60VxFeDNY0hARjNRYB7K+7dtkWGqIMYkR97N/ZXegaJrLYv8PlvdTCNNtHBukp7KvT
         Pg7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lAG/o0OGYJIRUzC/3iPfA0VGTvJTckfhIeXmdYy8D7s=;
        b=PQEJn7ZDwIataTHUIplXWor8KtmMO43nASq5s+CWhO8nPVsc7Yrv+5oJ/9LHVB7Tch
         x+B/pOtzwxlcA8LxxLSvheaMgTqq8ToqyPLv81xwsbtxjtFSJlH/KDwPyY85kfhRug2r
         YccZbmNwgU3YbaOgXZq8u3clx74zdCh83qgWtIMsGAJlyhu1FCWUh69ByV6lbyoHoxUz
         TJs1ww2iyJBkQDgwY29q+bcwISddIHTYDV9e5sewkoiloiQGPrlu/j4ZaRPlJl9pUvKq
         F4othPAf2yJSvWRjMWUBNlM6cDtdGyHZmR6UeC6jP1hY2DhccY5dtkMZF0WDIXWo+ptG
         z0xQ==
X-Gm-Message-State: AOAM5309qxBu177P1Y8BcHE2D8Q6FWikNbMDV6EK5axoShvO9vNuUmqp
        obkqGgve2ifwK/a53vbsNgKktWH4DkRe6Q==
X-Google-Smtp-Source: ABdhPJyxJI5kZhM/we67BpwL9wm0tcCVEwsQ9EccqVB6j6qo/2+n6eBWSBmwdgKWrgRQEXbv83xjHw==
X-Received: by 2002:a17:906:c44f:: with SMTP id ck15mr1564008ejb.269.1619142491920;
        Thu, 22 Apr 2021 18:48:11 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:11 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] drivers: net: dsa: qca8k: protect MASTER busy_wait with mdio mutex
Date:   Fri, 23 Apr 2021 03:47:39 +0200
Message-Id: <20210423014741.11858-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 59 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 88a0234f1a7b..d2f5e0b1c721 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -609,9 +609,33 @@ qca8k_port_to_phy(int port)
 	return port - 1;
 }
 
+static int
+qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	unsigned long timeout;
+	u16 r1, r2, page;
+
+	qca8k_split_addr(reg, &r1, &r2, &page);
+
+	timeout = jiffies + msecs_to_jiffies(20);
+
+	/* loop until the busy flag has cleared */
+	do {
+		u32 val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+		int busy = val & mask;
+
+		if (!busy)
+			break;
+		cond_resched();
+	} while (!time_after_eq(jiffies, timeout));
+
+	return time_after_eq(jiffies, timeout);
+}
+
 static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 	int ret;
 
@@ -627,10 +651,17 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
+
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	qca8k_set_page(priv->bus, page);
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			      QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				   QCA8K_MDIO_MASTER_BUSY);
+
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
 			QCA8K_MDIO_MASTER_EN);
@@ -641,6 +672,7 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
+	u16 r1, r2, page;
 	u32 phy, val;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
@@ -654,14 +686,23 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	qca8k_split_addr(QCA8K_MDIO_MASTER_CTRL, &r1, &r2, &page);
 
-	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			    QCA8K_MDIO_MASTER_BUSY))
-		return -ETIMEDOUT;
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	qca8k_set_page(priv->bus, page);
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
+
+	if (qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+				 QCA8K_MDIO_MASTER_BUSY))
+		val = -ETIMEDOUT;
+	else
+		val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
+
+	mutex_unlock(&priv->bus->mdio_lock);
 
-	val = (qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL) &
-		QCA8K_MDIO_MASTER_DATA_MASK);
+	if (val >= 0)
+		val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
 	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
 			QCA8K_MDIO_MASTER_EN);
-- 
2.30.2

