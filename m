Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03A1239AC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfLQWTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34187 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfLQWTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id f4so3228237wmj.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JgKtfxkjvNoIckJzBnzUOpPZ/QMY7WdoGdoSUSDWFbA=;
        b=PvVXkg1pnEcvdYc29NIEPOdnaJyaCY283Gt8Ws68gbKknBuv7HvcTU1EbVudyYo8NW
         vVxpnbPAY56OYZq94HGZA+LlrHO9Yxr1HMvnpsArBFlwC7IkiDNEipiScUubtHEMIU3S
         2Y01hNJSHAkDSKov0h+LyPapuErofo0f0p4X4XkDRUpDO2DRMq8GjujYY3Iwehn0vfNj
         cUhfY0/or9FWKV/1fHGnlKF6SfqzL6JRap/RTpGF/jI8w+b3rNvC1eOwwHdj1CAIt3vG
         lKn/qTHA8rhyK/f4kC1THf3YwcVPrGiNNjZASEEhP7qF2PTIbcxNDxzJiQlpllDPlemD
         JReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JgKtfxkjvNoIckJzBnzUOpPZ/QMY7WdoGdoSUSDWFbA=;
        b=YsFr3NruD6JQUmo315TvgxLeesWFXjIWXAN2WbpjhrkUVHi9Ixoh6sahJgoOoyBqcN
         cKUV5hbLFle7lWCimORHMEneNZtG1bIJBnjZ6KNPV70c5BhQh9r+ccvUx6IdCyN7o4pX
         7Qt6i9dXAE3MWiMG4Qv3H8M+gejpRRlUry7rAPB8WQmUWBanylQpbNdZ/L66mBy8SMKM
         8FDCGghn7emHkG3HY0C1xDnzF60YIGp46t67HhSQgy3kkTuc7K8OGOPlO/PffTvKqHgS
         qGT37B4yPNwWmKOOuTdXQM7FqxJk8uiob9MUiFGH8cxdX8D6xFU9vT4FbPZDYjQ+reLY
         sDKA==
X-Gm-Message-State: APjAAAVcQ7znEiUWjUCh+eqEyjfNa0ZUJcetCbaEZMvFnBLd9CGuziKb
        x0z+YCs6I0dFAHqWrPw+VqE=
X-Google-Smtp-Source: APXvYqzWfr6FhuxkPvP474hqg8l2rAOmLw6PMrNLy2V5pKW+iR8WcwNRHjMwrycdJIHfDP5+2lFg1g==
X-Received: by 2002:a1c:a513:: with SMTP id o19mr7485058wme.156.1576621185430;
        Tue, 17 Dec 2019 14:19:45 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 5/8] enetc: Set MDIO_CFG_HOLD to the recommended value of 2
Date:   Wed, 18 Dec 2019 00:18:28 +0200
Message-Id: <20191217221831.10923-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This increases the MDIO hold time to 5 enet_clk cycles from the previous
value of 0. This is actually the out-of-reset value, that the driver was
previously overwriting with 0. Zero worked for the external MDIO, but
breaks communication with the internal MDIO buses on which the PCS of
ENETC SI's and Felix switch are found.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 6f6e31492b1c..ebe4b635421f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -31,15 +31,19 @@ static inline void _enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 	_enetc_mdio_wr(mdio_priv, ENETC_##off, val)
 #define enetc_mdio_rd_reg(off)	enetc_mdio_rd(mdio_priv, off)
 
-#define ENETC_MDC_DIV		258
-
 #define MDIO_CFG_CLKDIV(x)	((((x) >> 1) & 0xff) << 8)
 #define MDIO_CFG_BSY		BIT(0)
 #define MDIO_CFG_RD_ER		BIT(1)
+#define MDIO_CFG_HOLD(x)	(((x) << 2) & GENMASK(4, 2))
 #define MDIO_CFG_ENC45		BIT(6)
  /* external MDIO only - driven on neg MDC edge */
 #define MDIO_CFG_NEG		BIT(23)
 
+#define ENETC_EMDIO_CFG \
+	(MDIO_CFG_HOLD(2) | \
+	 MDIO_CFG_CLKDIV(258) | \
+	 MDIO_CFG_NEG)
+
 #define MDIO_CTL_DEV_ADDR(x)	((x) & 0x1f)
 #define MDIO_CTL_PORT_ADDR(x)	(((x) & 0x1f) << 5)
 #define MDIO_CTL_READ		BIT(15)
@@ -61,7 +65,7 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 	u16 dev_addr;
 	int ret;
 
-	mdio_cfg = MDIO_CFG_CLKDIV(ENETC_MDC_DIV) | MDIO_CFG_NEG;
+	mdio_cfg = ENETC_EMDIO_CFG;
 	if (regnum & MII_ADDR_C45) {
 		dev_addr = (regnum >> 16) & 0x1f;
 		mdio_cfg |= MDIO_CFG_ENC45;
@@ -108,7 +112,7 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	u16 dev_addr, value;
 	int ret;
 
-	mdio_cfg = MDIO_CFG_CLKDIV(ENETC_MDC_DIV) | MDIO_CFG_NEG;
+	mdio_cfg = ENETC_EMDIO_CFG;
 	if (regnum & MII_ADDR_C45) {
 		dev_addr = (regnum >> 16) & 0x1f;
 		mdio_cfg |= MDIO_CFG_ENC45;
-- 
2.7.4

