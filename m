Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A824280C2
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhJJLSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhJJLSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:07 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC23C061570;
        Sun, 10 Oct 2021 04:16:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a25so39497601edx.8;
        Sun, 10 Oct 2021 04:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=72QrxWD9ryrwuZQ23wpUQK4zvmjSMoPv4nxizwsmL9Q=;
        b=Y7Yip/7sjFmG0cRfxSluUGH0b2BahIvldiUAny/0WCVp04nmewUta2bBPoZabHj4Q2
         2GerJoOphTSYiTdiIp/oqozo4SJE4NmoUG9g1jX+9f5WWLqBSF4592LkapBBgEpUeKXo
         1CjSeyCwEmlMtwxfFbYkP27FNGv4dPuyKquB9OezkbBJqHX0OKcqLbTWIiJLwC2lFAIn
         b9u9Le1iau5LSjS/Zn9F6SQoZ2TfVD0ZQfGjEmhslsQWxNQY2TX2JKwfd/zpFm8v4L2c
         dkV7gWY9SR3+V++ETSE8lKp8xbuo9f/9nTQgo6+AkjQJQ6mFyX+PyBigfygRkMz+SQUm
         pNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72QrxWD9ryrwuZQ23wpUQK4zvmjSMoPv4nxizwsmL9Q=;
        b=Sw6kDsf/AobSESRpYEcRwjYG8l7bKOgfle8jyn+D3oeh+cUpJgtKmvCUOMhE1d3nc6
         a2c01CovIEzxIlI63BOPm3hs6J/h8Pcb3HIr3FX7YCNJUazvdidYOdzOqL6R7MwFPUPl
         iD/T4u17+Nw9KRcHSH90QXt35go3bl8f4jOs1J0fV8AqSFw+EMrFaGcq3rO7JvRYp1qN
         czp695VqG5xShdwr1a6OckrcVMEhLhcBI/g5S6YykBAeUw6uxLq43UvVPQosQ2prCf8R
         EX774kqTPW7++8eM97nkuab9GbcCHjaYsaXKpBaMM8qXPPyemlZglhgfWUkx2YaWXIdn
         6rCQ==
X-Gm-Message-State: AOAM532UQ+YNp5jO10DgddpeuQxC4Kg8BMpTSRk++1/RdQahgAtTNLoD
        qIXZ5T1+XTt53TWWsxnPm7E=
X-Google-Smtp-Source: ABdhPJx6t50b9zmaxMdte2D1x/oSorWIJ97lwyUw4E7NDuCpKRkI2sgNzxTeemjOP6pkOg4FHoRCxw==
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr18160997ejr.435.1633864567844;
        Sun, 10 Oct 2021 04:16:07 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:07 -0700 (PDT)
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
Subject: [net-next PATCH v4 02/13] net: dsa: qca8k: add support for sgmii falling edge
Date:   Sun, 10 Oct 2021 13:15:45 +0200
Message-Id: <20211010111556.30447-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
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
index a892b897cd0d..3e4a12d6d61c 100644
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
+		if (priv->switch_id == QCA8K_ID_QCA8327 ||
+		    priv->switch_id == QCA8K_ID_QCA8337)
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

