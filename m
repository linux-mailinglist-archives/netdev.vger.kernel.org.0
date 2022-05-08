Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4951F201
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 01:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiEHXJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 19:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiEHXJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 19:09:02 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E4710FD6
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 16:05:09 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so21077705lfb.0
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 16:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pKcWqMXPbRXnlvseTKhNC7oDfe4PMWMkoN/OBTzYimw=;
        b=x4oaL6H/PCLlyEgmSnKLbOFxYYsQl4TrurnRi5EtGpr/NRkefNRb/oK/EAKSAyHHPK
         /0DGIpd/yDAI1wuv4YoYwstBB54o+B80RTFFf2Vk08OmD1Bd8OHwFY8a4kIhNDAdKSho
         AKk0qAfqD1O5DXQzzIKVNXM1fgnYyqhtroRsI0VBJbbyf/pjP3ynrGqNG7qPKAXrsIsQ
         pxO2x9tAlaYfGvbpDRufRU+9ATIF+9gG9L9xjx5dIYtrbApP1wQEFT1BT9tdpzG5cywK
         b43gd73E1DOew+pRkfAnHeedLKKRYy8ZMOIIabJJ6mCCt0dbL9TzbvrehH7FsQGk9sal
         L51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pKcWqMXPbRXnlvseTKhNC7oDfe4PMWMkoN/OBTzYimw=;
        b=7dsLxqStJLQ+ZMoTTcI3Bz5yJtDkgKjC2T8zx21UNeQSwED5Z6qjWCxQJnNzioMgke
         nsfbSqmz4R6wvT3W+qqQ3Rw9cbIQegy+CKEmh9hezkDI+50f5xgArvz7ZMfFRLkYm9/Q
         MPnGIkLD5ngPnNdfA6kQGxsHuAACUtyaiRkr5b2CDgJcBHl6OU82oNIBjbyqJhHhhb26
         hNYNcLlq7irffFzlBkLNWPXVgbmnBWLv6VMUQ+g8emILf9+/+oTN0VXMC4edTx00JDri
         qR4xoZV7wEi5Og0hB9IjAPRUzoKaxm5LvTbmgC40dF7XpMQ9DDNA97wrxK9BPU9reHEo
         kE6g==
X-Gm-Message-State: AOAM531gxN+Pw8BOv/4++GeQv3oX3SynQzvEAIBbJTQXdKw+EKGexoZA
        ipYNUPTTjjPjoUUNXgTItfOj5Q==
X-Google-Smtp-Source: ABdhPJyMxDja7uciWqpo+DrDyTEigmo+Io5Lt6UGH2LKLrRS2hqr5QQHpwWR5PhrH3tV1l+JYXkJTg==
X-Received: by 2002:a05:6512:31cd:b0:473:a235:1ac0 with SMTP id j13-20020a05651231cd00b00473a2351ac0mr11043962lfe.364.1652051107778;
        Sun, 08 May 2022 16:05:07 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id n6-20020a056512310600b0047255d2111bsm1714963lfb.74.2022.05.08.16.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 16:05:07 -0700 (PDT)
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
Subject: [PATCH v2] net: dsa: realtek: rtl8366rb: Serialize indirect PHY register access
Date:   Mon,  9 May 2022 01:03:03 +0200
Message-Id: <20220508230303.2522980-1-linus.walleij@linaro.org>
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

