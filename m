Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2904181D2
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfEHVwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:52:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43259 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfEHVwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:52:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id u27so13642lfg.10;
        Wed, 08 May 2019 14:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d18b4qWh4HEgcu9wcn/OtecpmPx7NVhpCmeccDtOwuY=;
        b=Lt7bJnDBzGiz370T8FOk2I9C3A2+FarSZXJjYhRZatAdfVga39QIRPOOGVnsyGs6uP
         mOV4+uMPBI94/+dg2apRA2rnZV0pvKqwRRbzT2pltns/+ajxhtxu/Udjtm3T3jLIz0x5
         oDLdIoHH8kywuRzSOWJyrzbq4FVnZCBmYPKLPUFZo9XhLX4Aq7BzdBpADaE5cCjQIbOu
         4WYSwc43nkoLYqUBmhZEsx7nLkDjvz4nZlJ1vut4+r4rXQSRQKo7/W2ccHK92kKEP1hd
         eZwplAFZbCjMypEPqzJtD9kWlTPrwp+MPc6gw5WE+AU4C9CY+z8HThO5W/HGSHSNtSuE
         Jb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d18b4qWh4HEgcu9wcn/OtecpmPx7NVhpCmeccDtOwuY=;
        b=Jy7gzXMFAInkvXj5q6mUdP4Cib8E1S9gYXlxo2CnbkDla6tyNjKMFlbq/fXX1Gkkkg
         ux4fKNqY91EhG8YJAmRsgV8aycdYGHB72zdY1635/q0E9YspNMmaaXckHI9FjeLkMA/Y
         jdnEjiX0MJFd6Elxj2j1nnmEJsq9VmO/6Gd/ySOU1yp93NffhQxiE32ye8JL9IFLIOxa
         JIjwJ3chwmAAQz7hy8DBhhHksW1ZXaftgq66r35Jkm49y4QPQivPHUT7qllIkLtvYAcz
         vtgupZW8A8NMwaBZh1XJybFZXMC8AEVHnwk8pwFoTjhwxuE4RwYGdl8OKI3LoXaCUiC0
         K8YQ==
X-Gm-Message-State: APjAAAVnM7CK9RB+0VzfR+DGbI5NyZnqUeYRyxQbj1HrLkDnlGiLxG3d
        sbDEL3bgltOM7u7OfmCXuP4=
X-Google-Smtp-Source: APXvYqwE86+xTrNYoh9mO07ThJZjjH/w7wrrJMBEcGpcgybBv1dl6BSjQWtEuD9HOyG1Zt8+/h+WyA==
X-Received: by 2002:a19:189:: with SMTP id 131mr237509lfb.74.1557352360316;
        Wed, 08 May 2019 14:52:40 -0700 (PDT)
Received: from localhost.localdomain ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id l5sm28279lfh.70.2019.05.08.14.52.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 14:52:39 -0700 (PDT)
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Serge Semin <Sergey.Semin@t-platforms.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] net: phy: realtek: Change TX-delay setting for RGMII modes only
Date:   Thu,  9 May 2019 00:51:17 +0300
Message-Id: <20190508215115.19802-3-fancer.lancer@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190508215115.19802-1-fancer.lancer@gmail.com>
References: <20190508215115.19802-1-fancer.lancer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's prone to problems if delay is cleared out for other than RGMII
modes. So lets set/clear the TX-delay in the config register only
if actually RGMII-like interface mode is requested. This only
concerns rtl8211f chips.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>

---
Changelog v3
- Accept id and rxid interface mode by clearing the TX_DELAY bit
  in this case.

Changelog v4
- Rebase onto net-next
---
 drivers/net/phy/realtek.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index cfbc0ca61123..761ce3b1e7bd 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -161,12 +161,23 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
-	u16 val = 0;
+	u16 val;
 
-	/* enable TX-delay for rgmii-id and rgmii-txid, otherwise disable it */
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+	/* enable TX-delay for rgmii-{id,txid}, and disable it for rgmii and
+	 * rgmii-rxid. The RX-delay can be enabled by the external RXDLY pin.
+	 */
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = 0;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
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

