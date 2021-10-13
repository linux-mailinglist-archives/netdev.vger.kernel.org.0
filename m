Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D30E42CEB2
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhJMWl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhJMWlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:49 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BC7C061762;
        Wed, 13 Oct 2021 15:39:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d3so16250954edp.3;
        Wed, 13 Oct 2021 15:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=31bcJbBeAXhFK3PQzUd4MHPO60YxYyRUrDKBEukTnMo=;
        b=JT7RvrvThZw3A7o0YCel3Otgxi6ymO8O7ppobPL2rFPHVru/5IDBtNlqwSWIeKy1FK
         r9mt0kMiiOH0hyjl5PALSoFgdi4lcXfY5Ui/LmHLR+dsHbU37uF5gkU2GkPVV0XP63gf
         2LXHQfiy4efSm+Qjw7q09ITbuy0y4McIISei3WrSH9g+iIlwS7qMbXKL/zzVV5gvEeI4
         p2omMmcVMzRjKdRhsfXnxq8eJwBMHEikMgLtYiZ1fpca04ihlF8USy7ZlJizi/NDowOf
         Jsee3YjAEv/B+4LlEvgxHEoh5Q7/qV0vGuvwSu0rsYWHbg5/TUkqW/zUaeBzq+wEN2cn
         z8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=31bcJbBeAXhFK3PQzUd4MHPO60YxYyRUrDKBEukTnMo=;
        b=705nkxfLjuqzmeJ0h3iYzLMpb9KU/5+1FlqEBWfrkJPHe1FvNkakCz33XCsRYPjrYw
         FAjuvc7N+pTj2xao5L/AEp3BhEy5tab4KcdX66y6luQ4ZSZ2/gNhgErYXQiaBGhwVngz
         lE5UYOKl7rqcvarY31DqApP0h00/MOpySF42VK2DHxEaxrDmTEde0qYYQKqZcBaGXCLK
         r7NPEWhWLm66Bi/7wFZYN+4xsQ3LwxZbWylT4TCIJntVrfkSv2U2zlN1ZL28CukQEs49
         TZv6IIY6Sfn6m4Bt4lq9A99pa9JxcbzRB4WekGF1ghltf1+e/tW2O4cG45DnwplzH0//
         /S+Q==
X-Gm-Message-State: AOAM532ifxej5uVX45vMqwgAhZZThvvxLeVbd1GENhQJvjjVNwVR2xlR
        0ypvGw3LLfTYYhxyD+dDU9Y=
X-Google-Smtp-Source: ABdhPJwFr8lYYvUXFv3ZQC8JMpfg4KwiO0iXQ48wC1LFWWpyZH5uh7VjDMsKc27QmmuPMIdVZfE3cA==
X-Received: by 2002:a17:906:3d32:: with SMTP id l18mr2352453ejf.393.1634164777524;
        Wed, 13 Oct 2021 15:39:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:37 -0700 (PDT)
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
Subject: [net-next PATCH v7 10/16] net: dsa: qca8k: add support for pws config reg
Date:   Thu, 14 Oct 2021 00:39:15 +0200
Message-Id: <20211013223921.4380-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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
index 23a05b857975..fad32ed75f45 100644
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
@@ -1053,6 +1088,10 @@ qca8k_setup(struct dsa_switch *ds)
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

