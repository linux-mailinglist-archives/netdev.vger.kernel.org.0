Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B0F427E44
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhJJB6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJJB6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B370C061570;
        Sat,  9 Oct 2021 18:56:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so52054909edt.7;
        Sat, 09 Oct 2021 18:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/uV0tNjeCdvzIjAHo5SSrbhvyG9Yb/Fo0F1BEFXhIe8=;
        b=hYRJldA60Z40LlHSKe7vV3YhxHs2ZkAUyzJoNZx9l7ev0rbFBgDFGvUkVmf89w5rcC
         7FuPXLUDRXDJ4GpaRpjhiYeKNlU0/fTM4I3y0mldxJKyuHNL681QW+ahOauZTQyh8XRo
         1eHwVTHNnuJsXGrG9CpcASEjQ1jgmSMenFN41lGBVX9evnCuAotLBJ6H261OHFLiUZAT
         4+ClFb1iszDheRRHwO/agTVdrLj2pvGvIi3VbkjP75QbMOLx14n3ZiBVBmO/vQdi1Eyt
         3j2uPe5BUpom9si4yPgrvp/EiM/Q9UjLa3Js83os6WriQgWR7gQVOZTZevwhjHa5YrAl
         ja7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uV0tNjeCdvzIjAHo5SSrbhvyG9Yb/Fo0F1BEFXhIe8=;
        b=s8LL2z+4By6C62Iy3A3h7/EUoLKIwBgbGGkH6ftoNICfRTcp7k+LOx7ArrfvSG7fTg
         UI4e3dEUX5acM5n5VpWShJVXrsvojBGcbPDx4Nge19uEbfmEFrb5Mw29acO6OASrgX9T
         K+fw12tmSTTeL3bNv3KW2rsxYOi6CGG4x29SWuAFcprSATOcjYvrRqBToUHhFVgnMlc5
         ZjGVkKSrwbjfYfDuR0hkv3/zecwufulHRe9h1yqnlqk2m1v+MF+re79M2qYPt9sxDOhS
         7gVDl5RkmMlr2B0rp/DGgtjheCla4XhLHzcWz/Q2w+OEvmium4NN1oop0QReaiEYvwXZ
         i5SA==
X-Gm-Message-State: AOAM530NwMQUXvKgJWuJ/ptHklm9yPkX7VAJd7wteUl5JCMeiDsgvmSp
        6CLbFxU+QjeAMDOV+5pq0nM=
X-Google-Smtp-Source: ABdhPJwpGC28wq6F9uOuizgw2lH4IKyiLUVCza8Z6NlSflVNXJ1rQBFDSCaZDa29jAmJVGzkHt1Blw==
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr28543657edk.251.1633830971647;
        Sat, 09 Oct 2021 18:56:11 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:11 -0700 (PDT)
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
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v3 02/13] net: dsa: qca8k: add support for sgmii falling edge
Date:   Sun, 10 Oct 2021 03:55:52 +0200
Message-Id: <20211010015603.24483-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this in the qca8k driver. Also add support for SGMII
rx/tx clock falling edge. This is only present for pad0, pad5 and
pad6 have these bit reserved from Documentation. Add a comment that this
is hardcoded to PAD0 as qca8327/28/34/37 have an unique sgmii line and
setting falling in port0 applies to both configuration with sgmii used
for port0 or port6.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a892b897cd0d..863eeac6eace 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1172,6 +1172,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
+	struct dsa_port *dp;
 	u32 reg, val;
 	int ret;
 
@@ -1240,6 +1241,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
+		dp = dsa_to_port(ds, port);
+
 		/* Enable SGMII on the port */
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 
@@ -1274,6 +1277,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		}
 
 		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
+
+		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
+		 * falling edge is set writing in the PORT0 PAD reg
+		 */
+		if (priv->switch_id == PHY_ID_QCA8327 ||
+		    priv->switch_id == PHY_ID_QCA8337)
+			reg = QCA8K_REG_PORT0_PAD_CTRL;
+
+		val = 0;
+
+		/* SGMII Clock phase configuration */
+		if (of_property_read_bool(dp->dn, "qca,sgmii-rxclk-falling-edge"))
+			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+		if (of_property_read_bool(dp->dn, "qca,sgmii-txclk-falling-edge"))
+			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+		if (val)
+			ret = qca8k_rmw(priv, reg,
+					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+					val);
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index fc7db94cc0c9..3fded69a6839 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -35,6 +35,9 @@
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
 #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)
+#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
+#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-- 
2.32.0

