Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261CE130B8E
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgAFBel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:41 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39198 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbgAFBel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:41 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so13748309wmj.4
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KdT0+mO3W38dPSAK9gjcZzQPus5e55NB960WJ7Xt5gw=;
        b=pFairh42ywrOIR7Bt4Fk8SJ2fXNHIxrADks0jwsevRWPwKIOuvE/kasYzP7va3BzFS
         5wwteDuUyRYNc2Gfka0b9fYJy2ukxZAnZBzw2HHW0YG6pIzEkWg4nSfBNC/+qqfSf//e
         SmGy8F295yIzGb0WZqclV7E5XAQPmzi93zaDxabm7SU99VS8Onm6V+k58/qgqcno49Rc
         GPA2F0jGixsbEQKExlWv6SMHU2Q12NcjCa5Jd8YlS4p0SeqWDLv2p6FcpZKjCCi4DW+3
         SDVLC3Aow33WuPZws4ZtnpnfJ/SbPQT6uu/o5J6uuGzuCAOlTshZxd/rqxGvERN+jyuN
         u91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KdT0+mO3W38dPSAK9gjcZzQPus5e55NB960WJ7Xt5gw=;
        b=AyLyojg6SAaanxqo/LaJB6FA89dCrF9R0Lnt0B0Hwh8wvUVRBmygl9aUiWUu8PkGRd
         1oD7sbII3wyQZVbhEopH3LY/c8YIWoDfupuMMHgOf86oC6Livs28scQ9pddvyGjHrd4i
         gkN7ogWt8JtE7OyLZoqNIFVrYxYvn+GiHHIj6gftz3s9jiMe2oiyA4CrmDPEdWalZmK+
         MFoHbxAR0D2Sns+2pe35qym7PptyCDdrnsHr7pKpDmVJMBg6HUdYXiGPotH7iemy/3P3
         6m2i8AglZ2n7J4RP/EWaBSUjQ7p7b8RwiJEPg8BFxSJPqvbDYhUdpqgEk7DJyMMbX4jb
         2DGg==
X-Gm-Message-State: APjAAAXdUgCwi+140MpA0BODfvJOs6BNFuTDDOTvLDiPx1jee8XvZGkz
        ArT8QFT/zb3rYdUeGncd+lI=
X-Google-Smtp-Source: APXvYqxJBfZA+7af8M+zaqraxgQUikgGjY0RlvCz6vqbcmfx7eZ/Z7vmw5O7QeimsKdzJVSu1yO7RA==
X-Received: by 2002:a1c:3c89:: with SMTP id j131mr31626269wma.34.1578274479213;
        Sun, 05 Jan 2020 17:34:39 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 6/9] enetc: Set MDIO_CFG_HOLD to the recommended value of 2
Date:   Mon,  6 Jan 2020 03:34:14 +0200
Message-Id: <20200106013417.12154-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
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
Changes in v5:
- None.

Changes in v4:
- None.

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

