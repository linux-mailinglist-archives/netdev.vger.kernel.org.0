Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E260526C61
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 23:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354092AbiEMViZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 17:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiEMViY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 17:38:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D827F3AF
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 14:38:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b18so16588407lfv.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 14:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sYCfXOYsHg4pPGmrCxYBDnmeWJzPRY2LbbOpiAnKw5w=;
        b=YJukoUXF/H/IL4no7mG/bpXLEfTJIF1mykYD9RnrxIfH8vqu/AidBSsOX7l2wNbDsV
         BMdCqTM6cvX/DxOoJOEFU4u0W3DFQg0OaGo/GtGO5P6SiWgDY++FuipGIKx25d+rMPqI
         YBhsmz/0cNCWrCsLIIT0s0I6NHyzobpHZ4t6zF2wrFrb0QO9a9qC92GRqeSTeJkcxrkf
         lSPg30uejWqEX1MstwFGd6CEmKEROqsf/hjdLnU3N22Nksxm/N/IOxbg2GG0ExaevR53
         0TbloWhVjqURN3dTMusjNOxyR1AtlcxzjhOtxL7l80RglWfKDrfI4lCsLeCTdChgu2hi
         +xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sYCfXOYsHg4pPGmrCxYBDnmeWJzPRY2LbbOpiAnKw5w=;
        b=WvOIGDXX3Av2bZe1uflkbZ06LFJEboo9N7ZIfgLFITcYtjMdTH+NObnKZ7zCCdJuyo
         aJS8q0utLllzaU5jTGtDa1l2VOvMvQu/uzk5491CSh6vwzXgwBa6KjIzjF3edI7sFq4t
         ijeI/6v/TUz5rjbEXbyOu9UfiafSsaScsf1IL5cA5Cdo7cI+77OYpN+4un9rLG1Wg7pL
         SKsoRYs1BepntvwDakNWnsP91PtsXpmd29kBmi9LVKGU7prl8gabZv4dJJXolpSjQGi/
         JzdS3ueisS31rG23Kln6pPdRCMlYkzxjYWyD5JZasg3G3IxB8sIAg9jUMGvwnMcp/t9z
         2fmw==
X-Gm-Message-State: AOAM532l8IQHkcbBGN5BBIA583/JWPV4D/ax/JmnPdrOhPML4GHks5bf
        kvJqhfDpcRgfxV11F1rXBruvvQ==
X-Google-Smtp-Source: ABdhPJyipDNOCeXlLAfuQwpRdvmaWCiujCdOhTBjxQ+71JSWBTkDs3V8dO2KTLrj50PU4i2Vb4UL9g==
X-Received: by 2002:a19:7015:0:b0:473:d75a:7a3d with SMTP id h21-20020a197015000000b00473d75a7a3dmr4524985lfc.525.1652477900920;
        Fri, 13 May 2022 14:38:20 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x2-20020a19f602000000b0047255d21126sm503773lfe.85.2022.05.13.14.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 14:38:20 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next v3] net: dsa: realtek: rtl8366rb: Serialize indirect PHY register access
Date:   Fri, 13 May 2022 23:36:18 +0200
Message-Id: <20220513213618.2742895-1-linus.walleij@linaro.org>
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
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Explicitly target net-next
ChangeLog v1->v2:
- Make sure to always return a properly assigned error
  code on the error path in rtl8366rb_phy_read()
  found by the kernel test robot.

I have tested that this does not create any regressions,
it makes more sense to have this applied than not. First
it is related to the same family as the other ASICs, also
it makes perfect logical sense to enforce serialization
of these reads/writes.
---
 drivers/net/dsa/realtek/rtl8366rb.c | 37 +++++++++++++++++++----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 1a3406b9e64c..25f88022b9e4 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1653,29 +1653,37 @@ static int rtl8366rb_phy_read(struct realtek_priv *priv, int phy, int regnum)
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
+
+	ret = val;
 
 	dev_dbg(priv->dev, "read PHY%d register 0x%04x @ %08x, val <- %04x\n",
 		phy, regnum, reg, val);
 
-	return val;
+out:
+	mutex_unlock(&priv->map_lock);
+
+	return ret;
 }
 
 static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
@@ -1687,21 +1695,26 @@ static int rtl8366rb_phy_write(struct realtek_priv *priv, int phy, int regnum,
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

