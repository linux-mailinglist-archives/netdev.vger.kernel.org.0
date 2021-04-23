Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D8368A98
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbhDWBst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbhDWBsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC83C06138C;
        Thu, 22 Apr 2021 18:47:59 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s15so55735953edd.4;
        Thu, 22 Apr 2021 18:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wfLXpnhGJBdDME0GgFox4THhUlvgNKI4GtU1C1FAZTE=;
        b=cEDhlBGdPUJnj5pvq+u72MgXY0g6OKTlixluwNLiPM7SpD87EBvaJmOzZjv1UNLuLI
         iOkAvgVWZ5Lx/QH7JHMXStrE+UWgC65MkYYUqjjWfCsXXBkyvI/SbaL1k46enyPbg0bd
         aaR20YX9/J+2n96zwzUtIMlKoOrDV86EoTeJhwlebv3BtUX+OCCve28vkwVd6f5XLNmr
         9zAbfnwumIbPpxVeHJgOCtUCcDd6Kbf2+ebLSVMMdCvz7VKyP2qnV6tiYWe8i/6hok5O
         V/RvffW2GzDFenjbGTmLWmO9JrffeuFkMCcOa2YbYZ2Fs/QfTk1JhVdxv8KHlsuqfEut
         S5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wfLXpnhGJBdDME0GgFox4THhUlvgNKI4GtU1C1FAZTE=;
        b=Lf0Sgb6o8H0Q7gooM3UZBMCzPW3x7odjQqmruKrxuB+MgEB5WkJhHfCSdtSsdYhMfh
         EDCob+R5WOXgyLjejpvmx+3mJSSFsO79d7q7oFqpPjLcV+xxP+WiRE9VMipIL7Yujm1W
         s/uR4cFhEjHPzyl7C1S0Oyr21iKJIIk4hBCDM/BhpLbLe27L45x5Dga+NdmufMoPcWUU
         KoH/6wUSU5u5x6HroRgfzWKb0okRDzga8yN27fOCbf+a/osjPDyMqUAzYfzMTC8EXnE9
         h8b+Hygals/sOBFAe6KVZNZIS+0Yfqld1pPZnWXPv4DKQIBBJXABeCrhXMaah8kOeF9Z
         nooA==
X-Gm-Message-State: AOAM532GNFxUdSQpZKHoFdBFH19qfhf9R+yS6iAW2Psmc5j8Jm6mKHBa
        rxQ5BnCjGo2icRS1cjn8ZfE5eiKOyhdsPw==
X-Google-Smtp-Source: ABdhPJyv1e6gF3pgDMi6cudMISRbJFClxk8YgiRHQc6rSSJLZPkkyIi7DEXj0EHQ2ZqJR6dbUrR8PQ==
X-Received: by 2002:aa7:de8b:: with SMTP id j11mr1544562edv.363.1619142477882;
        Thu, 22 Apr 2021 18:47:57 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:47:57 -0700 (PDT)
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
Subject: [PATCH 04/14] drivers: net: dsa: qca8k: apply suggested packet priority
Date:   Fri, 23 Apr 2021 03:47:30 +0200
Message-Id: <20210423014741.11858-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port 5 of the ar8337 have some problem in flood condition. The
original legacy driver had some specific buffer and priority settings
for the different port suggested by the QCA switch team. Add this
missing settings to improve switch stability under load condition.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 42 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h | 24 +++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index b8bfc7acf6f4..7408cbee05c2 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -701,6 +701,7 @@ qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int ret, i;
+	u32 mask;
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
@@ -785,6 +786,47 @@ qca8k_setup(struct dsa_switch *ds)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
 	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
 
+	/* The port 5 of the switch ar8337 have some problem in flood condition.
+	 * To fix this the original code has some specific priority values
+	 * suggested by the QCA switch team.
+	 */
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		switch (i) {
+		/* The 2 CPU port and port 5 requires some different
+		 * priority than any other ports.
+		 */
+		case 0:
+		case 5:
+		case 6:
+			mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
+				QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
+			break;
+		default:
+			mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
+				QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
+				QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
+		}
+		qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
+
+		mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
+		       QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+		       QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+		       QCA8K_PORT_HOL_CTRL1_WRED_EN;
+		qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
+			  QCA8K_PORT_HOL_CTRL1_ING_BUF |
+			  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+			  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+			  QCA8K_PORT_HOL_CTRL1_WRED_EN,
+			  mask);
+	}
+
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index e0b679133880..0ff7abbd40dc 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -163,6 +163,30 @@
 #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
+#define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF		GENMASK(7, 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1(x)		((x) << 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF		GENMASK(11, 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2(x)		((x) << 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF		GENMASK(15, 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3(x)		((x) << 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF		GENMASK(19, 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4(x)		((x) << 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF		GENMASK(23, 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5(x)		((x) << 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF		GENMASK(29, 24)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT(x)		((x) << 24)
+
+#define QCA8K_REG_PORT_HOL_CTRL1(_i)			(0x974 + (_i) * 0x8)
+#define   QCA8K_PORT_HOL_CTRL1_ING_BUF			GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL1_ING(x)			((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN		BIT(6)
+#define   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN		BIT(7)
+#define   QCA8K_PORT_HOL_CTRL1_WRED_EN			BIT(8)
+#define   QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN		BIT(16)
+
 /* Pkt edit registers */
 #define QCA8K_EGRESS_VLAN(x)				(0x0c70 + (4 * (x / 2)))
 
-- 
2.30.2

