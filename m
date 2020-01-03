Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8D12FD61
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgACUB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:01:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36069 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgACUBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so43508031wru.3
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zW7UsPAFTTe3uwNU8N1BaQOosPHalsZyFyP+jBr1OrY=;
        b=pEhyJTzGWP3CoFtGzcbv2MotKcZ9eFwUJJMyZGPsyWb9VricsoSRHJ3a81ZQZp9POM
         g25quR8VGltrlPKoP9V8nSvv5twtI3O65rRU5crNNfezZvt3OLanZYzYLUpwnV73o8X7
         656tbyMXpMzn5ItBZOHtsc3zJuQ3/J7ACGX8T3VlY5U00KehzA/E44TayKpG/8bxlWdf
         5iyKdsiVxB334HTwEDEZ5iwz4T3tB4fpxPypQcIGcA3IbDX+66bu+pIC+d0BWGEIlmNb
         TCNw/90AM0p91t2iTNh0JOlpqaBHGUz5fjPx46wbKOU7nAb6hCpJKXJVdbOkz+SkkLUk
         K+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zW7UsPAFTTe3uwNU8N1BaQOosPHalsZyFyP+jBr1OrY=;
        b=DjHcSD6b3vKscE41xwMeg50SGg4Ax56XZuWH45/1Vtwh7koF8g+ero5/IbbZ0oKxJQ
         aSfkLaMXej4xfaJOev1ycbKLQySYmI5QAKTMYs+uXegK/Q2w0HRyfJsmqsthgdEfmtYA
         rJaZX6B3hSKs1fP/NYqkaW6/QLixcOa+DM6zfxswb0VrYe5+IWbbSGxpO3dtF7gKVgD/
         Xw2FWPXkvOgIfn+a1CBcBOO1PP88UlekwDyIfYxyf8M3VW3povGOsMijsFPJicni9Tby
         rv7fW9W+R5q/yQUp2F7q8NI1k80nUpJaOFdfWJ5PJU5EHnwqglsVtCRU58qjWe2Ew8q6
         tX5g==
X-Gm-Message-State: APjAAAUFZ429CaHsloFWCuYRqmLcJEgvY81DumiyXcYobGcDrGOMml1I
        2OxinYFpj2Wd5LyuJglzqGw=
X-Google-Smtp-Source: APXvYqw0GpGcrBIHuZfl2+j2tJC0U97YLLLlEpV2c2Xt4yVCB4uFRPAdOF0m2rDimA1W9wVoqWGFVA==
X-Received: by 2002:adf:fc4b:: with SMTP id e11mr23884690wrs.326.1578081713041;
        Fri, 03 Jan 2020 12:01:53 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:52 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 6/9] enetc: Set MDIO_CFG_HOLD to the recommended value of 2
Date:   Fri,  3 Jan 2020 22:01:24 +0200
Message-Id: <20200103200127.6331-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
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

