Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B058E889
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfHOJrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:47:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39824 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfHOJrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:47:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id i63so771140wmg.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 02:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TkCpQzt0O3mAU4bSRFh9V9Ndb1XFdaaoT4NDtQM1d/Y=;
        b=Gv8AVKF2uFLjWA50ZTHuEiNRtQ0roWwZwWQN9kZ2LNScs4yEhKZJiF1X+MWx1bcVht
         FtPx1ISHclWpSs3uwzuEDu7rpa+unVsMr9L0CfYZnZZZkD7hoAQVB/jJgPoIsaTNGTL7
         jieVX5L1Wp3uKvarjRk2kqND2c24AjnMbzWH2NJIkjaMLlcZgkL8uzgX0qgmZM/J5cmO
         77wRAPdH1nsaoA/oP9DacpQwO+WB/68/uiio+O+ktCyBZybDkw+GcPNQ5/OsexlLhEk4
         HZ3ms3GdoziM++Ite3fDJvzFdimd1oKDX4cr2437mqRO5Z8wSP2bw0eVtIAKKKfBzmSM
         DM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkCpQzt0O3mAU4bSRFh9V9Ndb1XFdaaoT4NDtQM1d/Y=;
        b=QBUEydrpQCGXmqMjsiCJE5fe+FJcUkzQDF0RFSNn+zgNZDNKx+VDsQoMqmYijpXSOh
         A4obAtJIdk7LQqKmB9rwQSc4HrIbAXsj1W2qPhMDGmS3bBUS9IFulglG/sCKhuNcQ8Sm
         qzmO+8VzBMbYgjUkp7aYYuBExhSWUYVOcSjEI0Luqv9EA5vUf2cHuku8klkU2xNYKLhf
         LI7IxYyxBvGbHT+hvbjx23fv16/GJWBYpBi5x84RHMtu3QfPcXlgPEOYkykPMv9CFvOE
         DVsQ02hf+71huuL0xlK8ggU4dRW4lzZ+qnkKpaSp3EtPYmZU9dc7QVIQSP35hWVDnKL3
         M82Q==
X-Gm-Message-State: APjAAAVH6w4w+xEQVkE72zOq2URLt3MvWXmvtEy5/islJ9JvtAySUbKQ
        utfZ7hyGh7lZ41YYb18bWKjIaKc4
X-Google-Smtp-Source: APXvYqyYe09c4dSgW4hd/peLzEWP6FdE79HIOh2ZvVMpmv0c3VLQMVv+SahyRIK2vSUMzLHjMewBFw==
X-Received: by 2002:a05:600c:2487:: with SMTP id 7mr1916056wms.141.1565862460830;
        Thu, 15 Aug 2019 02:47:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:7cbb:1cda:9a01:259c? (p200300EA8F2F32007CBB1CDA9A01259C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:7cbb:1cda:9a01:259c])
        by smtp.googlemail.com with ESMTPSA id 91sm6784721wrp.3.2019.08.15.02.47.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:47:40 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: realtek: add support for EEE registers
 on integrated PHY's
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
Message-ID: <aea026ee-6d39-e036-ccb8-91245bfdfe5b@gmail.com>
Date:   Thu, 15 Aug 2019 11:46:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE-related registers on newer integrated PHY's have the standard
layout, but are accessible not via MMD but via vendor-specific
registers. Emulating the standard MMD registers allows to use the
generic functions for EEE control.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index c49a1fb13..2635ad1ff 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -266,6 +266,45 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+static int rtlgen_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
+{
+	int ret;
+
+	if (devnum == MDIO_MMD_PCS && regnum == MDIO_PCS_EEE_ABLE) {
+		rtl821x_write_page(phydev, 0xa5c);
+		ret = __phy_read(phydev, 0x12);
+		rtl821x_write_page(phydev, 0);
+	} else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV) {
+		rtl821x_write_page(phydev, 0xa5d);
+		ret = __phy_read(phydev, 0x10);
+		rtl821x_write_page(phydev, 0);
+	} else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_LPABLE) {
+		rtl821x_write_page(phydev, 0xa5d);
+		ret = __phy_read(phydev, 0x11);
+		rtl821x_write_page(phydev, 0);
+	} else {
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+			    u16 val)
+{
+	int ret;
+
+	if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV) {
+		rtl821x_write_page(phydev, 0xa5d);
+		ret = __phy_write(phydev, 0x10, val);
+		rtl821x_write_page(phydev, 0);
+	} else {
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
 static int rtl8125_get_features(struct phy_device *phydev)
 {
 	int val;
@@ -422,6 +461,8 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.read_mmd	= rtlgen_read_mmd,
+		.write_mmd	= rtlgen_write_mmd,
 	}, {
 		.name		= "RTL8125 2.5Gbps internal",
 		.match_phy_device = rtl8125_match_phy_device,
@@ -432,6 +473,8 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.read_mmd	= rtlgen_read_mmd,
+		.write_mmd	= rtlgen_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.22.1


