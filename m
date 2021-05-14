Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1D538128D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhENVGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhENVGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:06:06 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB10C061361;
        Fri, 14 May 2021 14:03:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lg14so549912ejb.9;
        Fri, 14 May 2021 14:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DuIZvkVyxl0vo+4ykBws9GPNTneGdS9CaBr3gH+w73E=;
        b=sc7EZNWCUByl4ePiwgGpHBKYBaDZi/cH44mbVm+BUFNkpbt3qtbaFKN0jidLehegWI
         P6/2efXFcwibqEV8dqYV+f5QV2XUCkt7jE0TXbdRAV/w74n2QT0eXp3jN9yQWpxgMHQ8
         gtuDb51v0Oe00EobGXWSa00+DlO5iuDarousBf3ApE6RoQSVuYFKdKHznPDPyhXTwkqq
         9IsWSOFPNUguoAEpYRkz6CgPzqBa3vYKKupRMPOymI3VygHhEVmd8yg3CcSc91Iusb1Q
         GmFygDmDUmcFAWVpNQMCxsz+xd2QS5DM8DDunw8vgafONKuCEz22OwwHkW3AbDkzAvCt
         9o2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DuIZvkVyxl0vo+4ykBws9GPNTneGdS9CaBr3gH+w73E=;
        b=QXGyylnl1oVmgp3fmPmHwUXMJ77i9mUbKuQUK0Y/zcvhVZ27HtvUXYrknhhb6IxMrD
         4ZBa6Cga+2Mu1hrCfJgNaAJ8r5zqdkmGZrezY+AiHyhD5RWNHmjqwY/ndh4kfSu3U2BU
         7drnnNmq2bs+ebgoX+VeOMrFi2VdsDZEhoMD5w2cTNiAuWVX9xuBIsBFpDziH6xToJED
         +KRP/Gme2AW92XKDV1nxlZgGxwpsuplGHaVj1B7umJlrbNii4KomX9rKmxl8wcwZiexc
         4P0UOlsY9j4xuVJZAG4NeDjj/VzreqMK+iTgrWdRTg5hqnyuFpkhkapmzMgWKL8P7/lZ
         cNhQ==
X-Gm-Message-State: AOAM533cVSjzhzTTkzZp5VQtFNxLbF421XI6ksEYhSshRur7j4WEj1H8
        fTGvzqJA9MEd9AwnvecRf1o=
X-Google-Smtp-Source: ABdhPJyB48CHxHQu+e51fgG6b4y+BQUivEKolcF9s+7qXmdtr4n2v6BWhFdQ2N9jK4vuUKq3Eue6bQ==
X-Received: by 2002:a17:907:161f:: with SMTP id hb31mr50946633ejc.514.1621026237411;
        Fri, 14 May 2021 14:03:57 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f7sm5428330edd.5.2021.05.14.14.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:03:57 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [net-next 3/3] net: mdio: ipq8064: enlarge sleep after read/write operation
Date:   Fri, 14 May 2021 23:03:51 +0200
Message-Id: <20210514210351.22240-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210351.22240-1-ansuelsmth@gmail.com>
References: <20210514210351.22240-1-ansuelsmth@gmail.com>
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

