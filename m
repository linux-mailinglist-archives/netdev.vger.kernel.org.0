Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF76B30E0
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjCIWiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCIWiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:38:01 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFA27A84;
        Thu,  9 Mar 2023 14:37:59 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so4765614wms.2;
        Thu, 09 Mar 2023 14:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76LV00udkXPQUwmYWl6PMAZgt1+JmaJY28CfXEIfxZA=;
        b=kGmrRGymM4KXv3p2daK6qNA4CyjMECD39z2HhDe0pT7ZEek364CCVqdK+HgebbR3dV
         ISnvWARvuOTIyQNnslRwauZjxVg10QJFNfnZhnLLkbJ6b9BHrTG+lKRxlHN2SIws9ZZf
         H9fvOwlf43/Vtja+WL+PfrX9PThWjAu3H4BXXtjTLtBM1m8N4XvDYFKrDhXf3Jj2N+3j
         VppzFhHXUx39g9BXVmliwyz4EujqWhRDv1k9LwgasM4ZFzq3ScpBu513mI9xiW411MVY
         KFSXf7MxNJwwKtuZtZjd1cAeJGJA85tEpLspSJ490jXw9n6cHCwpaMywLIPAu7jdZ0Ij
         t9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76LV00udkXPQUwmYWl6PMAZgt1+JmaJY28CfXEIfxZA=;
        b=L6C/v3aQPyzALM/Iu+4OKavvU+8pxwmRKDXNnTzV7VY6vL6VwIuJXUrCjerpZCRfyp
         gFXH/+H0sZwbNz8hA8dCCwSKOFTvsKCvynutg3yCEja7IDI8RC62d46OdVX0cPce4+sr
         eOI7lADWwiSly0QX3poWO8cSBUZHA+FPrceqJ9kvp4NqkOniELPf1OQegJWHZsc+0gDk
         q0T3giJ/dyWGWx+RGupK1ijfuVjOoO25B3IHbCRRXyDrZ6uenzu+nKT/P8qr9BjaGvVc
         AcGkt649SFAc8exZAnC+uo64+1pS8moJvsnsLBD3ZjhwXofkuRtQywXVjv9cjAwChiKH
         er3w==
X-Gm-Message-State: AO0yUKWU+z9UkuS7Xm/7GIxAvvH4XRMZeIPMJONscfE9RbxzAUFu0x02
        L3dRn8Mj6mxxvK8vKhM8xcMWB9KkEkA=
X-Google-Smtp-Source: AK7set8JVwiOkfqLtU4wZgr4GnlFSjgxwHxCtSXt+MOW7NV3SQg1oWLTsIOhL2hlU1AkKo44Z9o14g==
X-Received: by 2002:a05:600c:3ca7:b0:3da:2ba4:b97 with SMTP id bg39-20020a05600c3ca700b003da2ba40b97mr120602wmb.19.1678401478052;
        Thu, 09 Mar 2023 14:37:58 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:37:57 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v2 01/14] net: dsa: qca8k: move qca8k_port_to_phy() to header
Date:   Thu,  9 Mar 2023 23:35:11 +0100
Message-Id: <20230309223524.23364-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309223524.23364-1-ansuelsmth@gmail.com>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k_port_to_phy() to qca8k header as it's useful for future
reference in Switch LEDs module since the same logic is applied to get
the right index of the switch port.
Make it inline as it's simple function that just decrease the port.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 15 ---------------
 drivers/net/dsa/qca/qca8k.h      | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 2f224b166bbb..8dfc5db84700 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -716,21 +716,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	return ret;
 }
 
-static u32
-qca8k_port_to_phy(int port)
-{
-	/* From Andrew Lunn:
-	 * Port 0 has no internal phy.
-	 * Port 1 has an internal PHY at MDIO address 0.
-	 * Port 2 has an internal PHY at MDIO address 1.
-	 * ...
-	 * Port 5 has an internal PHY at MDIO address 4.
-	 * Port 6 has no internal PHY.
-	 */
-
-	return port - 1;
-}
-
 static int
 qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 {
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 03514f7a20be..4e48e4dd8b0f 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -422,6 +422,20 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+static inline u32 qca8k_port_to_phy(int port)
+{
+	/* From Andrew Lunn:
+	 * Port 0 has no internal phy.
+	 * Port 1 has an internal PHY at MDIO address 0.
+	 * Port 2 has an internal PHY at MDIO address 1.
+	 * ...
+	 * Port 5 has an internal PHY at MDIO address 4.
+	 * Port 6 has no internal PHY.
+	 */
+
+	return port - 1;
+}
+
 /* Common setup function */
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
-- 
2.39.2

