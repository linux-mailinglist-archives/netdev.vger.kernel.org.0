Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DA616EA3
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 03:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfEHBbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 21:31:53 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38745 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfEHBbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 21:31:52 -0400
Received: by mail-lj1-f194.google.com with SMTP id u21so6870231lja.5;
        Tue, 07 May 2019 18:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjMogtNPKT5H0aiWeRHzCcjZHYFmzQifxVV8XzOxYkA=;
        b=RPL3eSp7Yl9g8rF3MP0M1gKnkci04GjhrhxB2k+L0U9kln6sGcZImQbF6ee48bfLsg
         dnAEbnd7+QQTpYJ7zjqRavM4Ig1k3bJ9CVccx3jM6gJQi/aGzwOBdRu8WlhTXp/I7uWa
         6VnAPdXikjsT6hyOhfjnTbPbNaG2BYZujyW7G/ntDePbVVHwBdK0npgG/+nmcYWbFvSg
         P8hF7SdSW0UVDsoBAKpzQ6Hg28lv23umAMMzfhWvDl3InlKI8eybmq9LQR/t5d8NOJQc
         1Bs1HGlzUUIBnd+e+ZWzjTgw0U+F2cCDZKiA4x09WwRJ+Oz5SqhOl1SPKjO7t7cmvDpC
         EaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjMogtNPKT5H0aiWeRHzCcjZHYFmzQifxVV8XzOxYkA=;
        b=rDmmS95M90qwUT68SMgBWwOISy6OkbsWyt5mSHwBFZtdLdZb6qaNyapPkESssy1kem
         q6mLknChwI8QVwvSrPdroZx+BGmxTFyBOx06EYoZ/xd1O5L+8EObJ5DX814THnGfrOqe
         XBb6QqiyRHdWhPqSlIjmZLfQFz5nEsp/yGh8IgHB7MAaAcp1H8o0zOtrjp/hZ2RqBmMF
         +VQU+Gk65GnFFPz4AFmublEUXbq+LjftA6YxjIuhM96t1atnOt8OHENcV37DBUpaIfjN
         SvTuGipypnj3OuHXJhjqynipKYZJ3+dzKLYeig+RfTfTOXWzzTvkmf+vhSdPGCy1/YoN
         BKng==
X-Gm-Message-State: APjAAAX9gkQ9qna9nrxtPU/CBzIms3kZ+zmICqxwt5JnJr0BmuSTVQwB
        wTcemsIWEVO4wuimWrCxjg0=
X-Google-Smtp-Source: APXvYqzxFEly85eGTyFvfq1KCO0DhruebaUYoNx8Y3lFOBjq5Sxad0FyhMwV7GRbIGg8b8zy7PFtRQ==
X-Received: by 2002:a2e:9e9a:: with SMTP id f26mr17999900ljk.170.1557279110540;
        Tue, 07 May 2019 18:31:50 -0700 (PDT)
Received: from localhost.localdomain ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id o1sm3524339ljd.74.2019.05.07.18.31.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 18:31:49 -0700 (PDT)
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Serge Semin <Sergey.Semin@t-platforms.ru>,
        Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] net: phy: realtek: Change TX-delay setting for RGMII modes only
Date:   Wed,  8 May 2019 04:29:22 +0300
Message-Id: <20190508012920.13710-3-fancer.lancer@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190508012920.13710-1-fancer.lancer@gmail.com>
References: <20190508012920.13710-1-fancer.lancer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's prone to problems if delay is cleared out for other than RGMII
modes. So lets set/clear the TX-delay in the config register only
if actually RGMII-like interface mode is requested.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>

---
Changelog v3
- Accept RGMII_RXID interface mode by clearing the TX_DELAY bit
  in this case.
---
 drivers/net/phy/realtek.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index d27f072f227b..134b5fc7926d 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -164,16 +164,27 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	int ret;
-	u16 val = 0;
+	u16 val;
 
 	ret = genphy_config_init(phydev);
 	if (ret < 0)
 		return ret;
 
-	/* enable TX-delay for rgmii-id and rgmii-txid, otherwise disable it */
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+	/* enable TX-delay for rgmii-txid, and disable it for rgmii and
+	 * rgmii-rxid. The last one might be enabled by external RXDLY pin
+	 * strapping.
+	 */
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = 0;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		val = RTL8211F_TX_DELAY;
+		break;
+	default: /* the rest of the modes imply leaving delay as is. */
+		return 0;
+	}
 
 	return phy_modify_paged(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY, val);
 }
-- 
2.21.0

