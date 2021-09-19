Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C3410C36
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhISPpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 11:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhISPpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 11:45:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDF6C061574;
        Sun, 19 Sep 2021 08:43:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v24so50626458eda.3;
        Sun, 19 Sep 2021 08:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=21nowariD76inilnHAN+GS6tHZVsucKQkxTmpZSNO8A=;
        b=hrxRrin1Qasg87BAYXGStevSUDYwxTQWEEPBNPy94Ye8sgDN4Qi/Nnoqf+L3Cdo/7v
         QQi/wV/6hD8YVcobJXz3QJ55zJlym7MM6QmyeLv9QgGfvUDg8pSdm0kUlW+CXzY0F0Pe
         u5SbXMWYS3J9FbWeDyodF1IvN8mFmlN+1c1GJkROEGrWfrBO+oeppppXBbbGQ1b7bi1W
         RfrBGK3l4RpmVm+u5Fbdf0RsgxQoZIXHCSsxGuwWAvWRI70km9L/fX1Cw+d2hvYng+Ye
         tcR5AkBJ/YUgxJI3QIjc1aMmNiGfED+VooBl+cebtRLaeW4La4xT4WYx/ZYWUtvzLx1B
         YwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=21nowariD76inilnHAN+GS6tHZVsucKQkxTmpZSNO8A=;
        b=FMzzLGljKRFU9M5W97EEjJOuEhITrOk1Gqowsmt6GTADNu1pRvt+ypovl0k6BGV7yA
         1241wHoGhHamChLo2kh8QuZ1rMCbK+0VsiohVcWyyP/ye7jb4KRpuoMKC0ABEuQnzoBE
         6VOb7skbhhXONgJr52XC3GkO08yw3nlmqv1N9bnCYJwuC8HGsCA9mCaGzY8QBDy1IqEN
         6UiNdczQ1HdwK6moemD8lytUEpGQpj33KT5KdNGKP2+x/7dBhRxUfWc9Smt3w0GNeyAj
         tEyvkclZOD7f8MIvGgzFl9jxSzLYFoFF49jfRUXOAwcaaIyojHPM9EueZE0JHJ07Kmi3
         4LVQ==
X-Gm-Message-State: AOAM532AdNcu9xb2q8FvijJZmjMPdjZeADihkNW6D3b13+qPM+9FE3en
        jTknIFGssUP0PJ09uQzBTITos+Xzs9E=
X-Google-Smtp-Source: ABdhPJzJ04iFjlmnzyY6W3jR7upKKCGYKZF9be2Z6iewlYxnQs+3zMp8Uzh0sP+08FUt0KleZJI1sA==
X-Received: by 2002:a17:906:f88a:: with SMTP id lg10mr24205524ejb.13.1632066223181;
        Sun, 19 Sep 2021 08:43:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id g10sm4999309ejj.44.2021.09.19.08.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 08:43:42 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 1/3] net: phy: at803x: add support for qca 8327 A variant internal phy
Date:   Sun, 19 Sep 2021 17:11:44 +0200
Message-Id: <20210919151146.10501-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For qca8327 internal phy there are 2 different switch variant with 2
different phy id. Add this missing variant so the internal phy can be
correctly identified and fixed.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 719860a93d7c..618e014abd2f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -150,7 +150,8 @@
 #define ATH8035_PHY_ID				0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
-#define QCA8327_PHY_ID				0x004dd034
+#define QCA8327_A_PHY_ID			0x004dd033
+#define QCA8327_B_PHY_ID			0x004dd034
 #define QCA8337_PHY_ID				0x004dd036
 #define QCA8K_PHY_ID_MASK			0xffffffff
 
@@ -1421,10 +1422,23 @@ static struct phy_driver at803x_driver[] = {
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
 }, {
-	/* QCA8327 */
-	.phy_id = QCA8327_PHY_ID,
+	/* QCA8327-A from switch QCA8327-AL1A */
+	.phy_id = QCA8327_A_PHY_ID,
 	.phy_id_mask = QCA8K_PHY_ID_MASK,
-	.name = "QCA PHY 8327",
+	.name = "QCA PHY 8327-A",
+	/* PHY_GBIT_FEATURES */
+	.probe = at803x_probe,
+	.flags = PHY_IS_INTERNAL,
+	.config_init = qca83xx_config_init,
+	.soft_reset = genphy_soft_reset,
+	.get_sset_count = at803x_get_sset_count,
+	.get_strings = at803x_get_strings,
+	.get_stats = at803x_get_stats,
+}, {
+	/* QCA8327-B from switch QCA8327-BL1A */
+	.phy_id = QCA8327_B_PHY_ID,
+	.phy_id_mask = QCA8K_PHY_ID_MASK,
+	.name = "QCA PHY 8327-B",
 	/* PHY_GBIT_FEATURES */
 	.probe = at803x_probe,
 	.flags = PHY_IS_INTERNAL,
@@ -1444,7 +1458,8 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(QCA8337_PHY_ID) },
-	{ PHY_ID_MATCH_EXACT(QCA8327_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8327_A_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8327_B_PHY_ID) },
 	{ }
 };
 
-- 
2.32.0

