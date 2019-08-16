Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2790913
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfHPT5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:57:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33471 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfHPT5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:57:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so2622837wrr.0
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=to0/oglrdrCKf5DxwkCjZQ1goRlkhYxnjsj8QSAzCfE=;
        b=gvCBgfSq4wOg96G0/GHPFfRaqih00f/87N/HHH7DIwQHiGQ6nSzE0FpX2fSdg3NFdX
         3CJYo5TLMXtTXr50tog0dqGkGHCV+8zDckxnVy8bmMYdde6VIVlW9f6qKr5L9Kt3tTpx
         u0IShBN0a/KSpKq1ksdfF7uXDUxYqxd7472qU9/kOoOlOdhXKT41Qk8zCOXZqZUQ9LBr
         gQouSkLF5Dpkp4KNVJzEM5SJkaoqjVVBVYs6RfpWTf0DBq5N+RlRPtascQNhi6j0FQ7G
         6a/KLA/jxjjmJDMmbog3RHoI3oe1Jn+EqHM/wbU1aLy8M/kYYVxmZH+q+4cXlt/gmu0E
         5RmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=to0/oglrdrCKf5DxwkCjZQ1goRlkhYxnjsj8QSAzCfE=;
        b=ZAckvxhn+mS8CAiIlphtvzNw1Qf7oI8KxVd102RVU+IzYvAiF6fyx785PpuMKWPwT0
         6ZIVY1wXZhqHPHZtjOFl3/5bE0AZD++jpuWo8r2JQQB9xeJSNJmul+rc6+osdQof1bUn
         Xy4nF3hympC8ipLZTxzwX2mYpMmzLf2tAZjlMBTPscdKo42+2RNEHQ0rL8kJzfOxBGkB
         lDuOQy0/svXkrUHnqClCMkHrnDi2QMc+zoXz++OGZKWN+Aic4IoFsmC6j/5UKwmzKdw9
         PKHylO65pX8Oe67k2M78wxRIHOLf9553SQQ8gNXCvh60n4utMXwDYTY1mHbmrbeoFxpl
         54nw==
X-Gm-Message-State: APjAAAVzAjJBUIsp43/yu5glgfnj6zi2MbKz+gwrs6kL1DTP4Mx0Gq1e
        yVMeZPzMIWS80cMxeyG4/m7WEjBo
X-Google-Smtp-Source: APXvYqzGWkwZxpd1BcCUem58jwAIr0fN+6YUqAS1ZGbUbaPrZN5aaj3nEmAUz/3igfGROUOl3uqjSg==
X-Received: by 2002:adf:e452:: with SMTP id t18mr12673379wrm.0.1565985465429;
        Fri, 16 Aug 2019 12:57:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id r16sm14143581wrc.81.2019.08.16.12.57.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:57:44 -0700 (PDT)
Subject: [PATCH net-next 2/2] net: phy: realtek: support NBase-T MMD EEE
 registers on RTL8125
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
Message-ID: <234b7424-8df8-354c-bfca-563d3a07fcc6@gmail.com>
Date:   Fri, 16 Aug 2019 21:57:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emulate the 802.3bz MMD EEE registers for 2.5Gbps EEE on RTL8125.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 45 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index fa662099f..677c45985 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -305,6 +305,47 @@ static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	return ret;
 }
 
+static int rtl8125_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
+{
+	int ret = rtlgen_read_mmd(phydev, devnum, regnum);
+
+	if (ret != -EOPNOTSUPP)
+		return ret;
+
+	if (devnum == MDIO_MMD_PCS && regnum == MDIO_PCS_EEE_ABLE2) {
+		rtl821x_write_page(phydev, 0xa6e);
+		ret = __phy_read(phydev, 0x16);
+		rtl821x_write_page(phydev, 0);
+	} else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV2) {
+		rtl821x_write_page(phydev, 0xa6d);
+		ret = __phy_read(phydev, 0x12);
+		rtl821x_write_page(phydev, 0);
+	} else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_LPABLE2) {
+		rtl821x_write_page(phydev, 0xa6d);
+		ret = __phy_read(phydev, 0x10);
+		rtl821x_write_page(phydev, 0);
+	}
+
+	return ret;
+}
+
+static int rtl8125_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+			     u16 val)
+{
+	int ret = rtlgen_write_mmd(phydev, devnum, regnum, val);
+
+	if (ret != -EOPNOTSUPP)
+		return ret;
+
+	if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV2) {
+		rtl821x_write_page(phydev, 0xa6d);
+		ret = __phy_write(phydev, 0x12, val);
+		rtl821x_write_page(phydev, 0);
+	}
+
+	return ret;
+}
+
 static int rtl8125_get_features(struct phy_device *phydev)
 {
 	int val;
@@ -473,8 +514,8 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtlgen_read_mmd,
-		.write_mmd	= rtlgen_write_mmd,
+		.read_mmd	= rtl8125_read_mmd,
+		.write_mmd	= rtl8125_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.22.1


