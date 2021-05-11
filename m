Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A44379CC4
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhEKCN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhEKCNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:13:19 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A98C06137B;
        Mon, 10 May 2021 19:11:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so356337wmh.4;
        Mon, 10 May 2021 19:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DuIZvkVyxl0vo+4ykBws9GPNTneGdS9CaBr3gH+w73E=;
        b=QJ/x8bepYw/41vq4RENKLOZqNtH9xT5cehueBesyHjQ3I3XQpe/hZqLLyTeeaVbvc6
         g/c+IhO2U1ZClPkPFCsnVyUZiacDKl4FaGFjWplcvvPltGAqM0TyupYNfZyxQoFl8BFE
         F2crz5f/JfaaKxn9h7bnQhjlW4KGNVnzYf3xM26X7Q4jWyB2TVZWlzMrNPKIMgjh5pJt
         fp0l//SA3+OZzkfmTHCOj5SsT/mkyOzWP//+g2NUe6kCzWjP5TLYDjhpBYPV+LjGu8/I
         IzlWVUhHcOmenhvBkhoWNUVaLffSFZ76C38yPM9ibuTDGB8yNpbp4OVmBHg42v6q4h1F
         IBWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DuIZvkVyxl0vo+4ykBws9GPNTneGdS9CaBr3gH+w73E=;
        b=YZatgLodGOYwuC0D1DAJjPG7GDbUqMVcZFnLZ8vU+qgwdXBMXYEMa7HhnkmBjcykY6
         6Zw2TcmTBeGFTEuHr5EgftSWSfiAm/Pwg6xqqM3rNjrpvD7Q0uiNS/O62Ty+iIGVtyzZ
         mGqMkgOJ6gJZ2ONI7UTFPphz1G2HNzQ8rSXuweJ1PPbJb3brjPCr+reywTfnsqmKdTXK
         +XPi86JuBapOCgcnLeFnfvsFiuqM7kt8tk8I7kSSc1j9RZYsPcqGPg9cNcTNZV5b3dkV
         +0QRvMJCM5r1NLl99tJLW58C+SlceveTb8jaBJHHsdWG+w+nkxBnDxUtyH5jSyXGKFBc
         VcpA==
X-Gm-Message-State: AOAM5332lGmXFxkqZj9ueCT0XFpxNvgRRo8Vjn0NBlbuTFXgdN/F7hHp
        LgIEGggwf3EgEqFT9fBlRx4=
X-Google-Smtp-Source: ABdhPJxkgzx6LvDOB8/h1yWfws2t38vUzoT6ApPSm7SAhZKEC6ZAfU9CQukYAfGqOAp/IU0T3hOufQ==
X-Received: by 2002:a1c:1f8d:: with SMTP id f135mr26551711wmf.109.1620699078858;
        Mon, 10 May 2021 19:11:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id l18sm25697583wrt.97.2021.05.10.19.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:11:18 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC PATCH net-next 3/3] net: mdio: ipq8064: enlarge sleep after read/write operation
Date:   Tue, 11 May 2021 04:11:10 +0200
Message-Id: <20210511021110.17522-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511021110.17522-1-ansuelsmth@gmail.com>
References: <20210511021110.17522-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the use of the qca8k dsa driver, some problem arised related to
port status detection. With a load on a specific port (for example a
simple speed test), the driver starts to behave in a strange way and
garbage data is produced. To address this, enlarge the sleep delay and
address a bug for the reg offset 31 that require additional delay for
this specific reg.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 14b3c310af73..bd1aea2d5a26 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -65,7 +65,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+	usleep_range(10, 13);
 
 	err = ipq8064_mdio_wait_busy(priv);
 	if (err)
@@ -91,7 +91,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
 	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
-	usleep_range(8, 10);
+
+	/* For the specific reg 31 extra time is needed or the next
+	 * read will produce garbage data.
+	 */
+	if (reg_offset == 31)
+		usleep_range(30, 43);
+	else
+		usleep_range(10, 13);
 
 	return ipq8064_mdio_wait_busy(priv);
 }
-- 
2.30.2

