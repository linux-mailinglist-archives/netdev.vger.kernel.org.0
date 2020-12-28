Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDEA2E6891
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442197AbgL1QiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:38:00 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:45415 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgL1NB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:01:28 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7BD4123E5F;
        Mon, 28 Dec 2020 14:00:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1609160445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ayO2W2pek4dA7/J34Lw+5FZy5GZwyErlns+5yrT/rc4=;
        b=oo45lJPV7IGWVfQDhsIyy21/BqeCeZ7T4cpr5pl3Pc9aLiRUz/6fzoUKcv8u1hbAOHyi5L
        DOiiJ3kDjwu39QsXtG6U1SacZweyIPAFcMZs6vUcS7C6A/R9C14MEoAgGoaT1PD10QHPTV
        7be98aJdHbfDPPSTpI8xeTYIqOfoPyk=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RESEND net-next 4/4] enetc: reorder macros and functions
Date:   Mon, 28 Dec 2020 14:00:34 +0100
Message-Id: <20201228130034.21577-5-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201228130034.21577-1-michael@walle.cc>
References: <20201228130034.21577-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there aren't any more macros with parameters, move the macros
above any functions.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 591b16f01507..70e6d97b380f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -14,17 +14,6 @@
 #define	ENETC_MDIO_DATA	0x8	/* MDIO data */
 #define	ENETC_MDIO_ADDR	0xc	/* MDIO address */
 
-static inline u32 enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
-{
-	return enetc_port_rd_mdio(mdio_priv->hw, mdio_priv->mdio_base + off);
-}
-
-static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
-				 u32 val)
-{
-	enetc_port_wr_mdio(mdio_priv->hw, mdio_priv->mdio_base + off, val);
-}
-
 #define MDIO_CFG_CLKDIV(x)	((((x) >> 1) & 0xff) << 8)
 #define MDIO_CFG_BSY		BIT(0)
 #define MDIO_CFG_RD_ER		BIT(1)
@@ -42,6 +31,17 @@ static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 #define MDIO_CTL_PORT_ADDR(x)	(((x) & 0x1f) << 5)
 #define MDIO_CTL_READ		BIT(15)
 
+static inline u32 enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
+{
+	return enetc_port_rd_mdio(mdio_priv->hw, mdio_priv->mdio_base + off);
+}
+
+static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
+				 u32 val)
+{
+	enetc_port_wr_mdio(mdio_priv->hw, mdio_priv->mdio_base + off, val);
+}
+
 static bool enetc_mdio_is_busy(struct enetc_mdio_priv *mdio_priv)
 {
 	return enetc_mdio_rd(mdio_priv, ENETC_MDIO_CFG) & MDIO_CFG_BSY;
-- 
2.20.1

