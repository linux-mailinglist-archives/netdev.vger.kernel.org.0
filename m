Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A023512BB53
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfL0VhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:03 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37753 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfL0VhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:37:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so9324749wmf.2
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rz3IKddwzsp7RU1FAAdxYiRU4evSdprM+Rl6DrXOpPI=;
        b=dvjHdYBPFCIOrwJCTJJovQiYQdZp4j0NCdZISad1Ggv77aNzAMUtqpKKj5ygQ/jROI
         Io9786uwU4ZT4PIZjpJgfeT5dERbP9DvQAc75h6yI0PKjl+uJkSTgeAAVZQNsS6RTm5n
         YiVBHI6kOuMp2PPmNs7cXbk/NSahCnpiaxO6UfUWZnc2Njk6ZYh301J0s8uoBLVU66u6
         /WOTyH1BL3Lrc2W4aMoBH1AK82/AnI423ylEFpzkgOWSly4H8uH/5ZaVM+GClLileRcl
         3ySyMcdFixxObHLWBX2/RLMbD2RmfB/NyCHyAlw39kLVaiQ4df0jmdCSGuAJLOinuj5F
         1RoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rz3IKddwzsp7RU1FAAdxYiRU4evSdprM+Rl6DrXOpPI=;
        b=R3ZyckUPF/hPSfaSvkZCYzIhPBaecHZHFOHaUhB6TyUSF7hV8KG9b6+RAs0uvNLAZ3
         QDB+7bAAPO72eQ10Uz1juSJ9YI6vzZUzxaGLP/XPft642MRrKb3kMq328H8TDmf9Fuen
         2cAttsZGeCZahrmSqvv9AFEKSCZyFOBI10HAIuOwPsO5xh578YJfS6BraKR4xd3MXqAk
         xZ82w+7tSpFY8ay+1dPsbSzbFSfhQESeV2uzEyOaqDXsNuUqzHFwfHnTzvoe9IqZQ0Ma
         hmtYo5D6Mgs8DewCmbMIqWlMZtqk2M2MBc61JvR2WOKoh5HAf+PcVMHdLKhQ5S7O3Cj5
         zsqA==
X-Gm-Message-State: APjAAAVanrBS/EXA8tRvB5AG5iX+sqOVLG6rBcGf7Be6x7YeQpXtrO0Q
        oESZ3fg3//vXNT6ISZoQwPE=
X-Google-Smtp-Source: APXvYqz13lFM6NY7BIX6dykSI+GhjohLNIumjMvAzozBErz2wFTz9IfhNe/LI9qIjg1f2t1L8zuVhg==
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr20529473wmb.174.1577482619630;
        Fri, 27 Dec 2019 13:36:59 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 08/11] enetc: Set MDIO_CFG_HOLD to the recommended value of 2
Date:   Fri, 27 Dec 2019 23:36:23 +0200
Message-Id: <20191227213626.4404-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
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
Changes in v3:
- None.

 drivers/net/ethernet/freescale/enetc/enetc_mdio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 18c68e048d43..48c32a171afa 100644
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
2.17.1

