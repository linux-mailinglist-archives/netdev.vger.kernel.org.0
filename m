Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83643334B65
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhCJWSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbhCJWSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:18:05 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E001C061574;
        Wed, 10 Mar 2021 14:18:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so8291056pjg.5;
        Wed, 10 Mar 2021 14:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+xtotJdtE8IECL7B+knRaC6QHBjAVHpH83IXZLLoBaQ=;
        b=f4LFL0AM9KK3d+tr2hQeScaIcYk1HynSQDdJr4zn9C+1PAeAflMVtRZbS3lrFAsVEU
         yP2S5SjLP0alZeHosQxOoCevEeMYV/TbCru1XmUTFHFvVjEF59bjauphaW+75rCSJVpA
         vKjGtExXttTH6Gjqw8HxfK8dCPgDmIATBBLMQeml6sPAQBUQ/XtxXHbreHFh7sQWNkB1
         LPzn64sVSCBW2sYHtQOr0jz6shM/MivzFGI0HtV9tVwzOd9/O/5INzXPaJ/tUWXUDs7c
         eCeMgtr7Q6gHIoZZKhPcLw1mzs6WtrR3rWsh+0j25u9zHqZ9+/eJk7LBTSQ6YZSEsfyq
         BA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+xtotJdtE8IECL7B+knRaC6QHBjAVHpH83IXZLLoBaQ=;
        b=Jrm/eovopKtfjrl9R+wnA3tkXzLjqYndb7CbPpa+ISBV2CHOf75y+jr1EvdCGnpchm
         sBXNDAfTcfUW/9FXQNZJn3oIuuAQjuIqSPe3CUb84y9XCJxeV8QsoyYmatJLs1OldUSQ
         ztNRvrsIImMgwYJH2C81CjghrAPprjbIYbj8c8m1Qjylu+uEd7Shxd59BJU5e0Z16HwK
         rOPI8cz8kMVt0QpCIcdu7tbktHL5M/hYHCfBxAjYNEbaSbsLKh81A/H+nnDfnt3hfyyT
         5AocGaK8ahJcMpK1HGzFv7S4y6T03t5vpENzYF7I77yhZe3OUplDZtsVbREXbVtgWItm
         EQRw==
X-Gm-Message-State: AOAM533LOVatYzcy3um3x8nWhEvabSnKP/KG/VuuWzfhnl0tSnSUbIlY
        pSj994uU4okB9LAdgxoQ6SEnfcymIc0=
X-Google-Smtp-Source: ABdhPJz2HVXRhnTG+RhiHqBppOjdPBR8Li+O5WPdBDuX3iH2KS5T9Kg1TYpxr3Lfmj8kOznBO5qa0Q==
X-Received: by 2002:a17:902:8ec9:b029:e6:c5e:cf18 with SMTP id x9-20020a1709028ec9b02900e60c5ecf18mr4824029plo.47.1615414684221;
        Wed, 10 Mar 2021 14:18:04 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6sm476750pfi.15.2021.03.10.14.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:18:03 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port
Date:   Wed, 10 Mar 2021 14:17:58 -0800
Message-Id: <20210310221758.2969808-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 92696286f3bb37ba50e4bd8d1beb24afb759a799 ("net:
bcmgenet: Set phydev->dev_flags only for internal PHYs") we need to
qualify the phydev->dev_flags based on whether the port is connected to
an internal or external PHY otherwise we risk having a flags collision
with a completely different interpretation depending on the driver.

Fixes: aa9aef77c761 ("net: dsa: bcm_sf2: communicate integrated PHY revision to PHY driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1277e5f48b7f..321924a241f8 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -643,7 +643,10 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 	 * in bits 15:8 and the patch level in bits 7:0 which is exactly what
 	 * the REG_PHY_REVISION register layout is.
 	 */
-	return priv->hw_params.gphy_rev;
+	if (priv->int_phy_mask & BIT(port))
+		return priv->hw_params.gphy_rev;
+	else
+		return 0;
 }
 
 static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
-- 
2.25.1

