Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DC04284B9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhJKBdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhJKBc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C48C06177F;
        Sun, 10 Oct 2021 18:30:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r18so61204334edv.12;
        Sun, 10 Oct 2021 18:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pq8QlfWax57EIplXlVdBzRy4C0xbHVH3M+BqWLiLZXc=;
        b=N7iuZ4PGLdpTHp9eJCJ4IITf4eg+GFZS7RRZgUo75ccipPbBCsUy4/MKAQ3A1xkikg
         Ruxnx0SKFvX3DEKSIq0Xux7Kg4jDJZ5tuF1hy7AVtYwfQWnx7VKYsYPdokU1lbJnXJ1P
         GcbB2UdG0jHqo3waKKbwm4lz9BNSVv1aqvhgPz1iVx/GnviY2LAQRg2d4qboF/5TELy3
         vis7tboGOAEn5iP1Xir6CpRCUea3FrVzPfQVkWENXLyzciCHVo7jBmTDfuIpSNOsGK0a
         Y36DIHEEmm/vQYtrNRKDMPH8megjwWo7cPi9xYfTDluqfhB0cc4KaBNFfParA2zywcZp
         6dHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pq8QlfWax57EIplXlVdBzRy4C0xbHVH3M+BqWLiLZXc=;
        b=wlniGBKSI/z91cdfqnDI4weeedwV8/9VWbpYXG0bXrSzv6Ru8cVrC0DNgdBDWGx5Dq
         y1+9oYyU5gdvqry3U0HfWfjv/lvHXMaOiC6lNcaVwRFrA7kFsUKeazztQcgiRdOTjGTj
         3IKEBm7st79ZUyYUecCva0jBBOgp3uqTQJ3xjf/HjFWFzBIfahS0PI+/u6kdo1bDl/YI
         kZYJVDCYYGT7sFM81LaNVYRJHxtp63Y4b4bL2KSzzM6f/ahoQPs3PZWL3opeqlr3+81c
         xuNO1qxJ2ReCvpkurYTJ4mp0triGHIyyTeBf4axBOjbcCVTcAhGVVPY+CZTf63XNBe/z
         Dx8g==
X-Gm-Message-State: AOAM530Zev7AdjduGOoKCYQ0lrfNo20KlXOtXDqJn/2RFaFn45hHswwV
        4lHk4HHGCGyDTGFo4CJ/s5hCGMy3f2E=
X-Google-Smtp-Source: ABdhPJwIeoBXE4r7Rg9U9tCbWT6KDta7Trfa/NJMcU34sUZmnmBldGPIpV+29f17ivbPeZG/4fmUGw==
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr22138410ejb.139.1633915854445;
        Sun, 10 Oct 2021 18:30:54 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:54 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 10/14] drivers: net: dsa: qca8k: add support for pws config reg
Date:   Mon, 11 Oct 2021 03:30:20 +0200
Message-Id: <20211011013024.569-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some qca8327 switch require to force the ignore of power on sel
strapping. Some switch require to set the led open drain mode in regs
instead of using strapping. While most of the device implements this
using the correct way using pin strapping, there are still some broken
device that require to be set using sw regs.
Introduce a new binding and support these special configuration.
As led open drain require to ignore pin strapping to work, the probe
fails with EINVAL error with incorrect configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index c5aee1aee550..e9c16f82a373 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -931,6 +931,41 @@ static int qca8k_find_cpu_port(struct dsa_switch *ds)
 	return -EINVAL;
 }
 
+static int
+qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
+{
+	struct device_node *node = priv->dev->of_node;
+	u32 val = 0;
+	int ret;
+
+	/* QCA8327 require to set to the correct mode.
+	 * His bigger brother QCA8328 have the 172 pin layout.
+	 * Should be applied by default but we set this just to make sure.
+	 */
+	if (priv->switch_id == QCA8K_ID_QCA8327) {
+		ret = qca8k_rmw(priv, QCA8K_REG_PWS, QCA8327_PWS_PACKAGE148_EN,
+				QCA8327_PWS_PACKAGE148_EN);
+		if (ret)
+			return ret;
+	}
+
+	if (of_property_read_bool(node, "qca,ignore-power-on-sel"))
+		val |= QCA8K_PWS_POWER_ON_SEL;
+
+	if (of_property_read_bool(node, "qca,led-open-drain")) {
+		if (!(val & QCA8K_PWS_POWER_ON_SEL)) {
+			dev_err(priv->dev, "qca,led-open-drain require qca,ignore-power-on-sel to be set.");
+			return -EINVAL;
+		}
+
+		val |= QCA8K_PWS_LED_OPEN_EN_CSR;
+	}
+
+	return qca8k_rmw(priv, QCA8K_REG_PWS,
+			QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL,
+			val);
+}
+
 static int
 qca8k_parse_port_config(struct qca8k_priv *priv)
 {
@@ -1047,6 +1082,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_pws_reg(priv);
+	if (ret)
+		return ret;
+
 	ret = qca8k_setup_mac_pwr_sel(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 77b1677edafa..35a471bfd27f 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -46,6 +46,12 @@
 #define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
+#define   QCA8K_PWS_POWER_ON_SEL			BIT(31)
+/* This reg is only valid for QCA832x and toggle the package
+ * type from 176 pin (by default) to 148 pin used on QCA8327
+ */
+#define   QCA8327_PWS_PACKAGE148_EN			BIT(30)
+#define   QCA8K_PWS_LED_OPEN_EN_CSR			BIT(24)
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
-- 
2.32.0

