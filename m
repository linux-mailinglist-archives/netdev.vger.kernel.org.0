Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366F151E54D
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 09:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbiEGHpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiEGHpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 03:45:43 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9FA3BA45
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 00:41:53 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id w19so15950827lfu.11
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 00:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=awYvuDlGXgSYXEjihWbh8CODDi8Cg7WHxPC91lRZqyw=;
        b=rmwsaDLYWZ4lDUaLORI+GrWgynCxEBTJU/4mT58A9dWyeSN1/gVTb+6npLY7qCifhD
         9xzWKF+NkiI/hAE24rufukSVQb+SRBTEUpxBCYeFe9QIbl9HNwzrE8mLkvlghnczv5lM
         +DvjgWKxilcL/qfnZXuqoulCSM7YhtVOcVRTD4yRRL/R6MWm93NyIy+DIGKCaAQogKjt
         RNTxWqupEM1e3A6gzaWb1eFBSPx0dWq8QePMdr8JloGADq3q2XiUPhEFms1+FUHh5McP
         oVytmVKhYGuivKXir/nQYNAcRVSCA7iC9vw/T2QG5K5ogd/ljk4m/YQhAZAm/074X7Gp
         /wPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=awYvuDlGXgSYXEjihWbh8CODDi8Cg7WHxPC91lRZqyw=;
        b=mX8FT7XzTP4ZNuB7Vf53DYcvk2PbcKpTrwuBmM9t4QeQrRulZiOmNTglcJBj6FWNTZ
         wM3exxi/oByQv7m8Rl+fyOoVHb/LaH8kyYx/SD7G+nnK5bYwM65TnSKojQkQvOY69k9P
         dDK3+LC4KauQ6HGuoW/HNSAK5043ycA1354EUwWFG/BZwkNt9NsnA9l6FPn44lhBRQ5b
         oQOpOHj5OiunnJy6MspDIj4CbBzAoXjeLe9fglsMp7SCAlZkjbwuNPb8wCTjQzg3mqhM
         JAAe7iock5bBowHdrCxUmRMPMb9FkhgFgNI/u8RiJF1XhLlwQMCPha5B7GlTfvh1rc8X
         zPAQ==
X-Gm-Message-State: AOAM532HcFlJSAGWOVSGN72PC+6e30CSqoLbDJT6gL/u4ybazMr+1z02
        jpBd1GASekDW1Zyhl9A/yAaCkg==
X-Google-Smtp-Source: ABdhPJz8QI4hWUaSVF0nVi0MUNMZFXojjpK7gwvcXwulT/sOajyh9I/raDn6DsxhClaZUvxcnxBWNQ==
X-Received: by 2002:a05:6512:3341:b0:44a:ea52:9735 with SMTP id y1-20020a056512334100b0044aea529735mr5322648lfd.593.1651909312122;
        Sat, 07 May 2022 00:41:52 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id du8-20020a056512298800b0047255d21153sm997499lfb.130.2022.05.07.00.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 00:41:51 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: dsa: realtek: rtl8366rb: Serialize indirect PHY register access
Date:   Sat,  7 May 2022 09:39:45 +0200
Message-Id: <20220507073945.2462186-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Lock the regmap during the whole PHY register access routines in
rtl8366rb.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
I have tested that this does not create any regressions,
it makes more sense to have this applied than not. First
it is related to the same family as the other ASICs, also
it makes perfect logical sense to enforce serialization
of these reads/writes.
---
 drivers/net/dsa/realtek/rtl8366rb.c | 33 +++++++++++++++++++----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 1a3406b9e64c..1298661abf2d 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1653,28 +1653,34 @@ static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
 	if (phy > RTL8366RB_PHY_NO_MAX)
 		return -EINVAL;
 
-	ret = regmap_write(priv->map, RTL8366RB_PHY_ACCESS_CTRL_REG,
+	mutex_lock(&priv->map_lock);
+
+	ret = regmap_write(priv->map_nolock, RTL8366RB_PHY_ACCESS_CTRL_REG,
 			   RTL8366RB_PHY_CTRL_READ);
 	if (ret)
-		return ret;
+		goto out;
 
 	reg = 0x8000 | (1 << (phy + RTL8366RB_PHY_NO_OFFSET)) | regnum;
 
-	ret = regmap_write(priv->map, reg, 0);
+	ret = regmap_write(priv->map_nolock, reg, 0);
 	if (ret) {
 		dev_err(priv->dev,
 			"failed to write PHY%d reg %04x @ %04x, ret %d\n",
 			phy, regnum, reg, ret);
-		return ret;
+		goto out;
 	}
 
-	ret = regmap_read(priv->map, RTL8366RB_PHY_ACCESS_DATA_REG, &val);
+	ret = regmap_read(priv->map_nolock, RTL8366RB_PHY_ACCESS_DATA_REG,
+			  &val);
 	if (ret)
-		return ret;
+		goto out;
 
 	dev_dbg(priv->dev, "read PHY%d register 0x%04x @ %08x, val <- %04x\n",
 		phy, regnum, reg, val);
 
+out:
+	mutex_unlock(&priv->map_lock);
+
 	return val;
 }
 
@@ -1687,21 +1693,26 @@ static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 	if (phy > RTL8366RB_PHY_NO_MAX)
 		return -EINVAL;
 
-	ret = regmap_write(priv->map, RTL8366RB_PHY_ACCESS_CTRL_REG,
+	mutex_lock(&priv->map_lock);
+
+	ret = regmap_write(priv->map_nolock, RTL8366RB_PHY_ACCESS_CTRL_REG,
 			   RTL8366RB_PHY_CTRL_WRITE);
 	if (ret)
-		return ret;
+		goto out;
 
 	reg = 0x8000 | (1 << (phy + RTL8366RB_PHY_NO_OFFSET)) | regnum;
 
 	dev_dbg(priv->dev, "write PHY%d register 0x%04x @ %04x, val -> %04x\n",
 		phy, regnum, reg, val);
 
-	ret = regmap_write(priv->map, reg, val);
+	ret = regmap_write(priv->map_nolock, reg, val);
 	if (ret)
-		return ret;
+		goto out;
 
-	return 0;
+out:
+	mutex_unlock(&priv->map_lock);
+
+	return ret;
 }
 
 static int rtl8366rb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnum)
-- 
2.35.1

