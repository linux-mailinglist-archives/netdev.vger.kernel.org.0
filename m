Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4BC21E1AF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGMUxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgGMUxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:53:44 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2616C061755;
        Mon, 13 Jul 2020 13:53:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so18386147wrw.1;
        Mon, 13 Jul 2020 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZtfiXav89wkpI0gUU9ArbYeF3poYQO7hSKJ5JBj8Is=;
        b=fung/LLFRum+RDTwtolw1vvFrmSuH4yuAH9sTFKLqHGXSoVOLz0V+QPjaSF67njYrh
         c7yACuSsPqsGdbLoSnXE+v5vWPfPRpqBPagAYRLi8BYIdRg1SY/ZEwCjDSxNX8hgCR7i
         cvDoaUvvedmz2cGAyfc2U0qfLSH1obS3KAu8Y1CmN6suX+iC30domrBnyd/i21FAZxCm
         pLgyzlEiA72HCw9g9LJeCId9SzUvSi9jf/cWKiTrFkQ6LEwRRetWGdEnvGLQis5XSKHo
         ddxC6i8d50v+DYMzTTtUSZJCHR90BrTWW+nmgJP6+0sZaGqVNeab366zV0mYRVmRePGH
         RLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZtfiXav89wkpI0gUU9ArbYeF3poYQO7hSKJ5JBj8Is=;
        b=MXWuVr/XNQsk0n0Rz8VYN62hjANyhojoV9gZQwCXeqww/MNgEuWr7nPxieZr3puCqF
         PUHY45BOT/s1oXZNxSWuase/kKOtJcHTeq9P355UwOaDmSj3wRGHey3HBgWIzPcVYMHE
         ODdujQAGZwuxNSCspYv17zFa0xoIT/vX2rWQxY+FymztX7TWIxEXE2dhFoLky9SZdtMh
         wfYv+znOXWX9FaSShxWUxX3RjPZf1S+85dtf22yq5RXGhx72R9qTleF3L05WdrXejr6G
         /mKGYWYijrpyyrUFW9mq0PtyhpXUHMhFx/kX2KuWmKJFc645XWGEA8USMCotiiE7pgxT
         lNgg==
X-Gm-Message-State: AOAM533H56v2+W68rlNuirsihGAhYvouqGxkOMLByTWWYSmqNKCxh0jS
        /6oHzgkBmZiJnBR6yE9V1RyN9diu
X-Google-Smtp-Source: ABdhPJxnGb0JC591zQeRAAFavJrZe5Bs7bJiLfZd0l0fnWlLWIChM52eUyFnE2RxEUQoQUNPkvkS5w==
X-Received: by 2002:adf:f54b:: with SMTP id j11mr1373720wrp.206.1594673622534;
        Mon, 13 Jul 2020 13:53:42 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id a15sm29443811wrh.54.2020.07.13.13.53.41
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 13 Jul 2020 13:53:42 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>
Subject: [PATCH 1/2] net: dsa: qca8k: Add additional PORT0_PAD_CTRL options
Date:   Mon, 13 Jul 2020 21:50:25 +0100
Message-Id: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of devices require additional PORT0_PAD configuration that cannot
otherwise be inferred. This patch is based on John Crispin's "net: dsa:
qca8k: allow swapping of mac0 and mac6", adding the ability to swap mac0
and mac6, as well as to set the transmit and receive clock phase to falling
edge.

To keep things tidy, a function has been added to handle these device tree
properties. However this handling could be moved to the
qca8k_phylink_mac_config function if preferred.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
---
 drivers/net/dsa/qca8k.c | 42 +++++++++++++++++++++++++++++++++++------
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4acad5fa0c84..1443f97dd348 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -587,6 +587,28 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	return 0;
 }
 
+static void
+qca8k_setup_port_pad_ctrl_reg(struct qca8k_priv *priv)
+{
+	u32 val = qca8k_read(priv, QCA8K_REG_PORT0_PAD_CTRL);
+
+	/* Swap MAC0-MAC6 */
+	if (of_property_read_bool(priv->dev->of_node,
+				  "qca,exchange-mac0-mac6"))
+		val |= QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG;
+
+	/* SGMII Clock phase configuration */
+	if (of_property_read_bool(priv->dev->of_node,
+				  "qca,sgmii-rxclk-falling-edge"))
+		val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+	if (of_property_read_bool(priv->dev->of_node,
+				  "qca,sgmii-txclk-falling-edge"))
+		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+	qca8k_write(priv, QCA8K_REG_PORT0_PAD_CTRL, val);
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -611,6 +633,9 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Configure additional port pad properties */
+	qca8k_setup_port_pad_ctrl_reg(priv);
+
 	/* Enable CPU Port */
 	qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
@@ -722,27 +747,32 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		return;
 	}
 
+	/* Read port pad ctrl reg */
+	val = qca8k_read(priv, reg);
+
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		/* RGMII mode means no delay so don't enable the delay */
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
+		val |= QCA8K_PORT_PAD_RGMII_EN;
+		qca8k_write(priv, reg, val);
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
 		/* RGMII_ID needs internal delay. This is enabled through
 		 * PORT5_PAD_CTRL for all ports, rather than individual port
 		 * registers
 		 */
-		qca8k_write(priv, reg,
-			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+		val |= QCA8K_PORT_PAD_RGMII_EN |
+		       QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
+		       QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY);
+		qca8k_write(priv, reg, val);
 		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
 		/* Enable SGMII on the port */
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
+		val |= QCA8K_PORT_PAD_SGMII_EN;
+		qca8k_write(priv, reg, val);
 
 		/* Enable/disable SerDes auto-negotiation as necessary */
 		val = qca8k_read(priv, QCA8K_REG_PWS);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 10ef2bca2cde..4e115557e571 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -26,6 +26,9 @@
 #define   QCA8K_MASK_CTRL_ID_M				0xff
 #define   QCA8K_MASK_CTRL_ID_S				8
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)
+#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
+#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-- 
2.25.4

