Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB39A368AAA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbhDWBta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbhDWBsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:54 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FE9C06174A;
        Thu, 22 Apr 2021 18:48:11 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r12so71623086ejr.5;
        Thu, 22 Apr 2021 18:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Nf/+Y+13GJ3s0+R51l6M7NWLkrdPSWKqvmk7zfK1es=;
        b=GevxPR1q+4lC30fPIiTwR5droZivdeq5304ubvydRjKv+AGkBLB4Paxl1G/JMrDy7U
         VIV/f1ARCZxFsIE36tIX3do7Vm4KTumfD3ATnkfxGkYxhbsmNh7Z4QrfKopti6eLVLNO
         kJs8sjpGTNkvm3L4vdUKBlIJ/IZ6gPc+ixGJe1K0LGG7I8ErBaMGWQDAwTp0iRZKWD43
         XktvUkt2dt5EYrs6zOqN18XvWdL8E8UMAYrTd1OrFWvfvP+b7pnv2NIV+UQKKkVOPzwK
         XbHf25SOQwaNf0MRlqoECC0l36hTkALmTYg1oZoyqu9QdAHiPZhU5cS1mG7W9m/Hztov
         4t4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Nf/+Y+13GJ3s0+R51l6M7NWLkrdPSWKqvmk7zfK1es=;
        b=BAZ0CAuFNBSihsx2GI/zKPLb/EWiFjYv59i199lE90U1d/hzDSMQXSgjv+vdQhTPeH
         f84kTsjCknazu3GJ/snEBi9ABtZgSeZhJVbi/MO5b4QHFo5mmXdIBeRDq28JMb3TgrJK
         Gp/OgHO7X7kakNvxWgrG/feTr7TlbIwHUfc+iccOTG8ZRUX0Z4hB8EzkXltdJb6ObSGJ
         lgzHg3/RVW1cF/w0dkP1/hMoIwMLpE1QOKqqCyBN2DQXynCyupS9KKkygqkqLvWxRGTf
         IizG2+PmNj49zSz+qIRKBU81mZ+TkBTo2E5raTrVSP0IQmC5Bn1slWngwXXZ0IUjasgu
         F94g==
X-Gm-Message-State: AOAM5323rGEotqURfXKisRZkI4Dz9191mq6kgBCO6K4C5gMfJaZ2vzQG
        z8nEPkmdHLbsqHkU64WueJo=
X-Google-Smtp-Source: ABdhPJwIdyi0HpMxWThh4NHtG+R0F8nQpv0P1MvvoKE/G5pRR/UZpm4tT0l3Z2hwLn+kcEKpQIqSNg==
X-Received: by 2002:a17:906:7d82:: with SMTP id v2mr1625907ejo.524.1619142490267;
        Thu, 22 Apr 2021 18:48:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:09 -0700 (PDT)
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
Subject: [PATCH 12/14] drivers: net: dsa: qca8k: clear MASTER_EN after phy read/write
Date:   Fri, 23 Apr 2021 03:47:38 +0200
Message-Id: <20210423014741.11858-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear MDIO_MASTER_EN bit from MDIO_MASTER_CTRL after read/write
operation. The MDIO_MASTER_EN bit is not reset after read/write
operation and the next operation can be wrongly interpreted by the
switch as a mdio operation. This cause a production of wrong/garbage
data from the switch and underfined bheavior. (random port drop,
unplugged port flagged with link up, wrong port speed)

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 12d2c97d1417..88a0234f1a7b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -613,6 +613,7 @@ static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -628,8 +629,13 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 
 	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
 
-	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-		QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
+	return ret;
 }
 
 static int
@@ -657,6 +663,9 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	val = (qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL) &
 		QCA8K_MDIO_MASTER_DATA_MASK);
 
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
 	return val;
 }
 
-- 
2.30.2

