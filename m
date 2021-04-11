Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACBD35B6EF
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhDKUzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 16:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbhDKUzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 16:55:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C400C061574;
        Sun, 11 Apr 2021 13:55:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x4so12671045edd.2;
        Sun, 11 Apr 2021 13:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1GLY6Eu9dQMP0XShrTgVjqUA8MtMQyS320t2XhbwrW0=;
        b=UK7OTbcEjHlRsD0XoePgHsAzs6+lsaUGE9wnXfsq7M5/290LA19+xCtPMuNBvK/HQK
         NKWifP0lryKzdiZFl/3jTQuy2F4F2k7/TkOKEHM6GLPHt8riH3AsrP8ym2N3wYjmnfyB
         kuy2l5LD3refApVsv6bUz2NnBA2cRfe613oAAnwfObYHShAIPlxNzczYZPMpV8vNUYSQ
         wjiw5i4AmP/Jb0cWuod5DUFrRwgh7e6SMXpNLlKTP/hGYbXBsfAJ5B0u+o2j/vsMTVtw
         DsINKliCj4GC+Wq+cjl+KSwXrfe0K4eLaXPatHgH621g6TSq+eYnsGPWBEzsdDptbtnk
         ewCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1GLY6Eu9dQMP0XShrTgVjqUA8MtMQyS320t2XhbwrW0=;
        b=gq3iCkbre2/wAs5AUovxGwgO3WYCE3+jaPXEDn604J80BciYYh/aR6n3KktjBMpK8Q
         mQP1kk3AAkRXb2ya4CYd5nUr0mSOWEfa4O8qUtVH2G5t/k5w5N65rsF5LYkNa2nIF3ye
         aZn94ZF42TpaHJezZDLODJ3wa1QT7UXMjpp593T4L27fiNq+CLUOnq+TDheVzNf+Wk/X
         MS0MGLx89IkCGPBwjgReNLVBk6xYEqFl4P3fwfqpwGPVltG7YhVUwJ1ofcA7OFWgf3Iw
         dqiKVe5a93iocSneNcpk+cjfOepLKBKlyQSaTW0bqlWhoGAaznf1UZ4Jij/vzyIGasr4
         OsDQ==
X-Gm-Message-State: AOAM530mUHhhyMlOO/dWcwyBpfwgejskNGOdDTzOnHgOe2mNqp2t+tCV
        3HjnRMedor0SxXkrczjk4B/yNQ5kPJQ=
X-Google-Smtp-Source: ABdhPJzJJOofM5sAz5+gUCX63gvn4xZT0ooG+kiNlEdjEYRt9NPbuQAKOJ/rLMxZDTP6omgY8NLDBA==
X-Received: by 2002:a05:6402:27d3:: with SMTP id c19mr27061624ede.129.1618174521757;
        Sun, 11 Apr 2021 13:55:21 -0700 (PDT)
Received: from localhost.localdomain (p200300f137277800428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3727:7800:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l2sm4475453ejz.93.2021.04.11.13.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 13:55:21 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping the registers
Date:   Sun, 11 Apr 2021 22:55:11 +0200
Message-Id: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for .get_regs_len and .get_regs so it is easier to find out
about the state of the ports on the GSWIP hardware. For this we
specifically add the GSWIP_MAC_PSTATp(port) and GSWIP_MDIO_STATp(port)
register #defines as these contain the current port status (as well as
the result of the auto polling mechanism). Other global and per-port
registers which are also considered useful are included as well.

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 83 ++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 314ae78bbdd6..d3cfc72644ff 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -90,6 +90,21 @@
 					 GSWIP_MDIO_PHY_LINK_MASK | \
 					 GSWIP_MDIO_PHY_SPEED_MASK | \
 					 GSWIP_MDIO_PHY_FDUP_MASK)
+#define GSWIP_MDIO_STATp(p)		(0x16 + (p))
+#define  GSWIP_MDIO_STAT_RXACT		BIT(10)
+#define  GSWIP_MDIO_STAT_TXACT		BIT(9)
+#define  GSWIP_MDIO_STAT_CLK_STOP_CAPAB	BIT(8)
+#define  GSWIP_MDIO_STAT_EEE_CAPABLE	BIT(7)
+#define  GSWIP_MDIO_STAT_PACT		BIT(6)
+#define  GSWIP_MDIO_STAT_LSTAT		BIT(5)
+#define  GSWIP_MDIO_STAT_SPEED_M10	0x00
+#define  GSWIP_MDIO_STAT_SPEED_M100	0x08
+#define  GSWIP_MDIO_STAT_SPEED_1G	0x10
+#define  GSWIP_MDIO_STAT_SPEED_RESERVED	0x18
+#define  GSWIP_MDIO_STAT_SPEED_MASK	0x18
+#define  GSWIP_MDIO_STAT_FDUP		BIT(2)
+#define  GSWIP_MDIO_STAT_RXPAUEN	BIT(1)
+#define  GSWIP_MDIO_STAT_TXPAUEN	BIT(0)
 
 /* GSWIP MII Registers */
 #define GSWIP_MII_CFGp(p)		(0x2 * (p))
@@ -195,6 +210,19 @@
 #define GSWIP_PCE_DEFPVID(p)		(0x486 + ((p) * 0xA))
 
 #define GSWIP_MAC_FLEN			0x8C5
+#define GSWIP_MAC_PSTATp(p)		(0x900 + ((p) * 0xC))
+#define  GSWIP_MAC_PSTAT_PACT		BIT(11)
+#define  GSWIP_MAC_PSTAT_GBIT		BIT(10)
+#define  GSWIP_MAC_PSTAT_MBIT		BIT(9)
+#define  GSWIP_MAC_PSTAT_FDUP		BIT(8)
+#define  GSWIP_MAC_PSTAT_RXPAU		BIT(7)
+#define  GSWIP_MAC_PSTAT_TXPAU		BIT(6)
+#define  GSWIP_MAC_PSTAT_RXPAUEN	BIT(5)
+#define  GSWIP_MAC_PSTAT_TXPAUEN	BIT(4)
+#define  GSWIP_MAC_PSTAT_LSTAT		BIT(3)
+#define  GSWIP_MAC_PSTAT_CRS		BIT(2)
+#define  GSWIP_MAC_PSTAT_TXLPI		BIT(1)
+#define  GSWIP_MAC_PSTAT_RXLPI		BIT(0)
 #define GSWIP_MAC_CTRL_0p(p)		(0x903 + ((p) * 0xC))
 #define  GSWIP_MAC_CTRL_0_PADEN		BIT(8)
 #define  GSWIP_MAC_CTRL_0_FCS_EN	BIT(7)
@@ -701,6 +729,57 @@ static void gswip_port_disable(struct dsa_switch *ds, int port)
 			  GSWIP_SDMA_PCTRLp(port));
 }
 
+static int gswip_get_regs_len(struct dsa_switch *ds, int port)
+{
+	return 17 * sizeof(u32);
+}
+
+static void gswip_get_regs(struct dsa_switch *ds, int port,
+			   struct ethtool_regs *regs, void *_p)
+{
+	struct gswip_priv *priv = ds->priv;
+	u32 *p = _p;
+
+	regs->version = gswip_switch_r(priv, GSWIP_VERSION);
+
+	memset(p, 0xff, 17 * sizeof(u32));
+
+	p[0] = gswip_mdio_r(priv, GSWIP_MDIO_GLOB);
+	p[1] = gswip_mdio_r(priv, GSWIP_MDIO_CTRL);
+	p[2] = gswip_mdio_r(priv, GSWIP_MDIO_MDC_CFG0);
+	p[3] = gswip_mdio_r(priv, GSWIP_MDIO_MDC_CFG1);
+
+	if (!dsa_is_cpu_port(priv->ds, port)) {
+		p[4] = gswip_mdio_r(priv, GSWIP_MDIO_PHYp(port));
+		p[5] = gswip_mdio_r(priv, GSWIP_MDIO_STATp(port));
+		p[6] = gswip_mii_r(priv, GSWIP_MII_CFGp(port));
+	}
+
+	switch (port) {
+	case 0:
+		p[7] = gswip_mii_r(priv, GSWIP_MII_PCDU0);
+		break;
+	case 1:
+		p[7] = gswip_mii_r(priv, GSWIP_MII_PCDU1);
+		break;
+	case 5:
+		p[7] = gswip_mii_r(priv, GSWIP_MII_PCDU5);
+		break;
+	default:
+		break;
+	}
+
+	p[8] = gswip_switch_r(priv, GSWIP_PCE_PCTRL_0p(port));
+	p[9] = gswip_switch_r(priv, GSWIP_PCE_VCTRL(port));
+	p[10] = gswip_switch_r(priv, GSWIP_PCE_DEFPVID(port));
+	p[11] = gswip_switch_r(priv, GSWIP_MAC_FLEN);
+	p[12] = gswip_switch_r(priv, GSWIP_MAC_PSTATp(port));
+	p[13] = gswip_switch_r(priv, GSWIP_MAC_CTRL_0p(port));
+	p[14] = gswip_switch_r(priv, GSWIP_MAC_CTRL_2p(port));
+	p[15] = gswip_switch_r(priv, GSWIP_FDMA_PCTRLp(port));
+	p[16] = gswip_switch_r(priv, GSWIP_SDMA_PCTRLp(port));
+}
+
 static int gswip_pce_load_microcode(struct gswip_priv *priv)
 {
 	int i;
@@ -1795,6 +1874,8 @@ static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.setup			= gswip_setup,
 	.port_enable		= gswip_port_enable,
 	.port_disable		= gswip_port_disable,
+	.get_regs_len		= gswip_get_regs_len,
+	.get_regs		= gswip_get_regs,
 	.port_bridge_join	= gswip_port_bridge_join,
 	.port_bridge_leave	= gswip_port_bridge_leave,
 	.port_fast_age		= gswip_port_fast_age,
@@ -1819,6 +1900,8 @@ static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
 	.setup			= gswip_setup,
 	.port_enable		= gswip_port_enable,
 	.port_disable		= gswip_port_disable,
+	.get_regs_len		= gswip_get_regs_len,
+	.get_regs		= gswip_get_regs,
 	.port_bridge_join	= gswip_port_bridge_join,
 	.port_bridge_leave	= gswip_port_bridge_leave,
 	.port_fast_age		= gswip_port_fast_age,
-- 
2.31.1

