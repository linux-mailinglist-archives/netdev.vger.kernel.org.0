Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F530488D3C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbiAIXR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237558AbiAIXRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:44 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37654C061763;
        Sun,  9 Jan 2022 15:17:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p1-20020a1c7401000000b00345c2d068bdso8709071wmc.3;
        Sun, 09 Jan 2022 15:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueBZDa26xqCykYcwLBEdGWOTW5jehmct4P3RcD7Ziso=;
        b=OIzrQt4CAagai6BZ95MmATeYkt8tBPKhQ7pu3f0Q/cQ0Ip8wTMR0lBh7dVjE/DXh4h
         7iVLsZoh4kJGYaILyvNRepDvtbiA/NGj9xeLKu+2O19IJq7Eyz65lhKpFBz576dF+AjW
         JdIxRSlamovY+9rVu1EkaLN0DLAY/eOXNP2vcwbrU0PLgBIaI56fJw1XCuhivIHwIdXf
         +9Z8JVpT5poEaxxQTp4UCJLJYWrlW3uKEibdKkTe4TXg5BxDPmgbL1DwgX7LCL3drj+p
         5q8btmfrRwwUZCJhz8nJXjrLMtxN7P8VHCRFw8J6dvAen+x/7fuxxmdWzS9eFSWSWbGz
         VgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueBZDa26xqCykYcwLBEdGWOTW5jehmct4P3RcD7Ziso=;
        b=uifQy0zZJep42UaFlgq72w4dREXnTYU7Ic0ON9knpvhAek2LXPlmT2NtQaLovWZCDO
         +qckLhxs+iQtOGCLX4yeqj8MFaIvu8rKcIQK/B+EdJW+6WMobYhW6thaCeKfZn5pxg6a
         iaQ8wXslI+9yZ1/542gdBUUJfUUZCsEGIayq7GljwASsS46T4J5vnfUH0xcpI/0Um3Pi
         HX+uwSEIAPL+7t2F0BiuEchWdtghYX+hXkxwnhUgG2xyVw8cQs3dFWr0pcdsQ6edIDLD
         tZ5rZJmmBSAXw6d7nEy0KX9v8QQXISouajLMMhgfeEXFD202D6knScCzWSxu4NjJHW0k
         8RfQ==
X-Gm-Message-State: AOAM532uDbpnELr9XIh2uv8/ksoyY4bWsN+xZ+ZYJ2UgcWwKFka8FNr0
        PfAF+nNnvrf8t3094csjQr+t9GpLQtTaKw==
X-Google-Smtp-Source: ABdhPJwiEO8MjFm7D/0O8NV5TPI9m6I6Kq0EZi/wFHgZ4XWlO0Ogi/osUs8kd027LXo4ySM38cLkAw==
X-Received: by 2002:a05:600c:4998:: with SMTP id h24mr19511937wmp.188.1641770237826;
        Sun, 09 Jan 2022 15:17:17 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id c16sm1091315wrw.41.2022.01.09.15.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 15:17:17 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: at803x: make array offsets static
Date:   Sun,  9 Jan 2022 23:17:16 +0000
Message-Id: <20220109231716.59012-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't populate the read-only const array offsets on the stack
but instead make it static. Also makes the object code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/phy/at803x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index dae95d9a07e8..5b6c0d120e09 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -421,7 +421,7 @@ static int at803x_set_wol(struct phy_device *phydev,
 	const u8 *mac;
 	int ret, irq_enabled;
 	unsigned int i;
-	const unsigned int offsets[] = {
+	static const unsigned int offsets[] = {
 		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
 		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
 		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
-- 
2.32.0

