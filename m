Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC342B210
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhJMBS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236946AbhJMBSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:42 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6232FC06176E;
        Tue, 12 Oct 2021 18:16:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t16so3118605eds.9;
        Tue, 12 Oct 2021 18:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H+b9OOUqzx0gWcQEhH43sAPu6DsP0wQXfZw+S78Vnlc=;
        b=ehNBDZeoft9Q5wee3NvtSKSh/xpFV8EJ883yRjytFr31u9+9Fx1lf38hkUarz7VyHk
         /LqbF68hsydAoDTIZ5vNop09nzUf/CxaUMSyfd+B0HI3Rx7CmpwNJ4lYj3efqvApb8PB
         ySZLL9we/DtJKrJLeMbtQHGhHNyCe3LCO5p28ftwK3XjiKSTC0IjZqGne3JzR/kjA20/
         HUSuRdGwIqW36/116qWrXe4S2JXoO1PmXZRJLdgd+jt2CKDqnF3QU1uslTywE8nlXxaw
         9qB6IxytvWtOTNl9iAfhIIzkuC60IdREHFYKsUz7cqRhCTtzCdHba2rdb82LcNZ8P1IA
         ZQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+b9OOUqzx0gWcQEhH43sAPu6DsP0wQXfZw+S78Vnlc=;
        b=YQVHwSDyqZbe4I/yz+b9CSqV6ptRlOEaY5LTJ6oCzp8D2mxiWwkDk6PvfbZr1czxLS
         LGfkuhv9H1IHxm4GDQWRlVLGim0o9ow7pOAE9SofJEeeLDOhieeLrsFEUJr5z7xOhLpV
         HXuxQU30vy9k/szuUHuXW8M9cdD0lWRTWu4dsaP39+I47+uuK1DpQ9b8g6iQ40A3Rcjz
         IIwNmKYtpz29qbjQs8jG1hvJA1PXecliU88V2IYojWgSX14JJ07sQ6QS0uhWXw8TW7D/
         gbuVzXQ0z4lu8CKZBz+UuvPhnQxXtHNVMfJPsR3+hDyFILygfqhoeR7ZV9Ug4BhdGU7s
         vdng==
X-Gm-Message-State: AOAM5335jeO8cy2yVD9Dgbr1h5uAoVQ5WKBf9kbG7A4ftOB2+SPFnWL+
        R8/JFdVZHhQWL11Y4FWDyEI=
X-Google-Smtp-Source: ABdhPJy76piuNFRsuESBgYPU2A8pSST6nSiNKRnqbjWqIKedApZSCdF6vv0U3rS1kDM1Ub2RJuxCJA==
X-Received: by 2002:a17:906:c005:: with SMTP id e5mr36911815ejz.480.1634087797892;
        Tue, 12 Oct 2021 18:16:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:37 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 10/16] net: dsa: qca8k: add support for pws config reg
Date:   Wed, 13 Oct 2021 03:16:16 +0200
Message-Id: <20211013011622.10537-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 486e8a3d9af5..e63ca79f3452 100644
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
@@ -1054,6 +1089,10 @@ qca8k_setup(struct dsa_switch *ds)
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

