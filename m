Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6B2376DC3
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhEHAbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhEHAai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:38 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EC6C06138A;
        Fri,  7 May 2021 17:29:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a10-20020a05600c068ab029014dcda1971aso5924747wmn.3;
        Fri, 07 May 2021 17:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/GMZuRee3fS9Mj6YAF8B3GyGYR/WPEZYlIZN7CWUqU=;
        b=o1PKHqO6q3SyV5/aoxC2YnlFf0fmYxNfqURmD2kO2PrkeTUqBQmNysyRK0qEaN4SVq
         e7vw40qhuOCLHsVXNa0DFzCVjvBcpXT3vK/N5kN8sOQ8CPEiVxdYyAR74n6HIFDei3p1
         L1K6w7CuIDLb7AhblN1ps+mR7HNeBB7+FQTQU0+O+gPaaPwB1t39bob8vCAODdqHSEqj
         eIxwO3ECqr5//uLKjMgZwxBwPTCyHTNpY75iHOvMXJbQ22NSZvuV+mNTlRmGfyBp6Lmq
         eNYhEVijWGJSwsM+jdRMaI1UGmmid3EEUooSA7i7u7lUweaBF7S+QFkqSCPF6Vxhh5BP
         uNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/GMZuRee3fS9Mj6YAF8B3GyGYR/WPEZYlIZN7CWUqU=;
        b=b9LJDDvcc9Dv0p3NPdeCGnkCeSOrG7KWNLdxZtB8pLvJPKf3wR3/5zqe1usLqKdbjZ
         aBOc1j7kIJO8tYfnO/S2Q1W27ilY0oaFmlNJZ4iejlU1A7bH1liXNk3hyzhthXORHJWg
         6dGBtRI9kiwaiNp32qkKdK5DxH7pZb0nhJaUkJ9uoSwAAXKCqWI34VO3vU2NJNmF/qpi
         SeKoG6rGmX6nP0nlYO/RcNwSN2k0XHFQpLNTXmyZh3bcMiUyoFpHvunWvK6+0TAL79Gh
         pnL646b9Z6m9Eici8WZrPgsUuhs63r66zFcU2Z45LQN155OrMr3f8ASpA6LDcs9cvPFn
         DGLQ==
X-Gm-Message-State: AOAM532fnGZxYcXquKk/OME1yCyIvJhxRFoJs4Ghmf5J43AydXShT9ij
        kFBKU6QyOxIDyRdNImHrZxE=
X-Google-Smtp-Source: ABdhPJyi6kHNzaxp7YPmTAjRU9MCcqa9JxGW3Ez/kHE1TKS4j1YezsWv+l/ZIGLsNDBQy7Lh9HHTrg==
X-Received: by 2002:a7b:c006:: with SMTP id c6mr12706442wmb.129.1620433775092;
        Fri, 07 May 2021 17:29:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:34 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 15/28] net: dsa: qca8k: limit port5 delay to qca8337
Date:   Sat,  8 May 2021 02:29:05 +0200
Message-Id: <20210508002920.19945-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Limit port5 rx delay to qca8337. This is taken from the legacy QSDK code
that limits the rx delay on port5 to only this particular switch version,
on other switch only the tx and rx delay for port0 are needed.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 69fd526344cc..612fa77164ae 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1015,8 +1015,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			    QCA8K_PORT_PAD_RGMII_EN |
 			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
-		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		/* QCA8337 requires to set rgmii rx delay */
+		if (priv->switch_id == QCA8K_ID_QCA8337)
+			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
-- 
2.30.2

