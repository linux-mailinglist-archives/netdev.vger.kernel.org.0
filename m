Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3711368AB1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbhDWBth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbhDWBtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:49:00 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B66C06138C;
        Thu, 22 Apr 2021 18:48:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n2so71582816ejy.7;
        Thu, 22 Apr 2021 18:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=56PL0a5zXu4rcg3HLsKZZ+epvuKuacuxdJ5tVhsmylI=;
        b=BqZZKKo1hpCxnIbzNFdSp+JpbJurHmDiX2ajEiy5gHkbeTWqo3Au0CAvO/YtkZ+Olw
         Icw7O0rBzbPPOAEJUGsg2bQmhngSLEwDqLQ3kcBTKMGMmP0/OB3tu4ss35N+wXsubJFl
         NwNbKhb3dr/+GDSg497I35s3PYRIBi/D1FsXeZgTBfGbiobrrg6/NVs7kCCYmknVnrnX
         O0cp627DUc6S+PAj2uuQzgFWkc/p5cjTi6iT0wNRsMndA5o6F/Pd/sr5Kni5Jn9wsisP
         P3qLda360N8KO76Jaf8PtutaUKLsreVGqmdXgBj2I1nGNYUwIlEaIFwMmy95mWUaBxka
         9Iog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=56PL0a5zXu4rcg3HLsKZZ+epvuKuacuxdJ5tVhsmylI=;
        b=f0MWA46c+is9g5PjacWYKl5M6Kr+5q+maca42LsrcOBvbLVYVGWos9sb8bSwYz9+W/
         +BeqHm+bmz3f9Rmf9nAhlH0pY9CPZM4YrwSySzCK6rwyzKB9JXbZRjiK0RonIhMzmki5
         gLse7dnPfiiEl/BU1+mTnvlb3F4rPa0e0p1tC5KbhwlO7CkGMA38Jybit1jMtEPWgxKh
         rO5WkEa5zVA7UW3dOU/d2cJFC39XA1QIq5uK09RC7c25UYcDdvHf+jrJQb6Ccn/t8jwg
         O4syyQxHUwN/n/zjoBpZ3VHlR0ggLSsvMHuNfKm/TvDjeKIXReT6JzxKvonVqGewsawS
         A/PQ==
X-Gm-Message-State: AOAM5336UBLLggSh1uV+lFrGHy7ICTKYIIy09D2siktCM7KQEnwdoRuk
        QhFZpI/4H/Rq46viV4d1TxY=
X-Google-Smtp-Source: ABdhPJzfZqD/Zxc+bJLESHf2GJLG7qiUI1wsupPLBD/+ZmEgQudFNmr6VMSwrpRKt4NkNX23CKd4Qw==
X-Received: by 2002:a17:907:3f22:: with SMTP id hq34mr1525547ejc.535.1619142488732;
        Thu, 22 Apr 2021 18:48:08 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:08 -0700 (PDT)
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
Subject: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Date:   Fri, 23 Apr 2021 03:47:37 +0200
Message-Id: <20210423014741.11858-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k require special debug value based on the switch revision.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 193c269d8ed3..12d2c97d1417 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -909,7 +909,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg, val;
+	u32 phy, reg, val;
 
 	/* get the switches ID from the compatible */
 	data = of_device_get_match_data(priv->dev);
@@ -928,7 +928,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case 3:
 	case 4:
 	case 5:
-		/* Internal PHY, nothing to do */
+		/* Internal PHY, apply revision fixup */
+		phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
+		switch (priv->switch_revision) {
+		case 1:
+			/* For 100M waveform */
+			qca8k_phy_dbg_write(priv, phy, 0, 0x02ea);
+			/* Turn on Gigabit clock */
+			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x68a0);
+			break;
+
+		case 2:
+			qca8k_phy_mmd_write(priv, phy, 0x7, 0x3c, 0x0);
+			fallthrough;
+		case 4:
+			qca8k_phy_mmd_write(priv, phy, 0x3, 0x800d, 0x803f);
+			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x6860);
+			qca8k_phy_dbg_write(priv, phy, 0x5, 0x2c46);
+			qca8k_phy_dbg_write(priv, phy, 0x3c, 0x6000);
+			break;
+		}
 		return;
 	case 6: /* 2nd CPU port / external PHY */
 		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
-- 
2.30.2

