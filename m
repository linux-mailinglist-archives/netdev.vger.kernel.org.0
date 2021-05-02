Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB17370F98
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhEBXIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhEBXIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:16 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1934C06138B;
        Sun,  2 May 2021 16:07:23 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l4so5163608ejc.10;
        Sun, 02 May 2021 16:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ekuqeoxLHfbOZYiMO+jEnVZpF6zKQ37nh4brLxCr8H0=;
        b=Tv3dqFybiMFrAIIZAfaTI9RViPWMRMPpepeNl1R5NIDA8bhBfjXWq1mwGd0mFhue3n
         wX06IukQVhfOjjwx0JWqDUyXeJjGFmTpDamJxwBbTJYu/c8UCh1+JFyWJVJZWQDNCirc
         uCIiz2B5Wq8oZb+WlBhedGIOP4xGf52pzHOZhbU+e7f3fu3+Cb0Yv6LhTGOYPRGeYBfK
         2OpJ5nS7UqW9KGrbe0qAbjCWAaMAcFsCOt6V58dvdQHOLYKVwIJnhH37epr4Evfeqlc9
         WzlQy/+9ho+MbHsrwpSnpnvS9DDKHf1ZKBelooDxmnGyODAuWmrc5XR5QQgrNHNwsx9X
         vOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ekuqeoxLHfbOZYiMO+jEnVZpF6zKQ37nh4brLxCr8H0=;
        b=POCrgT30syZ4Vs5Wf/z0qcjm88iHkOIE/tPVS0w1yNVEH51tVwIe/LN6/bLRO5gKb1
         HFiN/mun0zX+XS0UnB7dkseYFwpLkZ2pcdShtomH90RlV+vPzR9oTwdkWsWn/VYhLF2g
         VwR4FHkdRiOzjRN9y7/FNzesa/GxHN0UPiGw+Fy+A10eJHttRQKzFUI0ELrkrLqCEwo3
         upBIOLCeKBFiHv9tl7mq0nhPYCDq9QnMq8s5pwNPOaVAt26HU0TgjcA8Y0HGYPZo3wH9
         qFZwoCkPhlxzRWiOvwINuvwL0WZH5YAwuC7wN8/6QgR//uzpp8Em7Z1AWc7j6l9Cs9cX
         EgVQ==
X-Gm-Message-State: AOAM530TL55lWaQFg9LhSQ9OFzRGRiQTcDTfNbuW0G/1XRPR4Dwgpl4w
        TmYrgChsWkLhpQB4EaaQ3FI=
X-Google-Smtp-Source: ABdhPJztnaNAFKOIlNTGbazEdgliK25R4z8/Jflydp8JKuyZc98SVhB5HkBC4+Dl+RY23aiqhq6FkQ==
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr14394704ejb.256.1619996842439;
        Sun, 02 May 2021 16:07:22 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:22 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 08/17] net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
Date:   Mon,  3 May 2021 01:07:00 +0200
Message-Id: <20210502230710.30676-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch qca8327 needs special settings for the GLOBAL_FC_THRES regs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 10 ++++++++++
 drivers/net/dsa/qca8k.h |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a91c9c36c70e..3f42d731756c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -918,6 +918,16 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
+	if (data->id == QCA8K_ID_QCA8327) {
+		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
+		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
+		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
+			  QCA8K_GLOBAL_FC_GOL_XON_THRES_S |
+			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S,
+			  mask, &ret_val);
+	}
+
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 34c5522e7202..5fb68dbfa85a 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -166,6 +166,12 @@
 #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
+#define QCA8K_REG_GLOBAL_FC_THRESH			0x800
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		((x) << 16)
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES_S		GENMASK(24, 16)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES(x)		((x) << 0)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S		GENMASK(8, 0)
+
 #define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
 #define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
 #define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
@@ -242,6 +248,7 @@ struct qca8k_match_data {
 };
 
 struct qca8k_priv {
+	u8 switch_revision;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

