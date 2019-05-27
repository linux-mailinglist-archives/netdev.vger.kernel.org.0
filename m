Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0312BA24
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfE0S37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:29:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46569 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfE0S37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:29:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so17634287wrr.13
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=73PxR/ELeZRseGxCRelnYrCbW+mWlziw7mrV5b4jkGA=;
        b=OYyWvMXA4bg8J33rmAAX68gcNeiYTE1Ol78uX50WSVB8Mwrx7As3RfQ4b8A6A1LCUg
         VYicuk9HMLe+C13rCxe9XPP+BEexjelMecy09NELTlP5/VAGR5FiPs8N81JlYfwS//2M
         dyLRFDDrLNXKLB8nTUNLqsy6NZ5u6gng+ChXdENT7a49zPhp5caeJMdwe48dhaKvgXcC
         g1+mdCU/WpfO88VbZT7URnUoq09fvZHiDftrkFmWQEjD4IlirXlX/vL99VP75HlcDm4K
         x2nfcNeRuyvDGuNRukguiRTv6V8VEYLdvwZaw5dKxJvSF8qdHuZkJNNCAq7nQ2aBSJ8L
         Q1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73PxR/ELeZRseGxCRelnYrCbW+mWlziw7mrV5b4jkGA=;
        b=N8dwz9cvVBkzj0bloLeIFW299VGLwBTnXv1jLxESBK8wNPoYBi76n9s8jy3weQQ1n4
         UnhgjNn1gC6Rwky2PxGwR6+gQfM9jTjugqb+dHcYBYKapUDN/YlqDraGa6TybQ5ZfdS4
         0NuDXdjM6ZO+NgsFmXPHOnrRHZPZau3+yn2W94cgHx/Z0wZ6XFukO5gZS4IfqryCTZio
         LcMs+Cy1DpQ/jphenzawMHYuAAhT69glSnho4xGIjgB70Hv3jDJPrpg/UKqnVNgwio8z
         b6mYI/+y1Z36yBCsagrIVGGNQgBINaqkK32KNqVG/dRny3ymPg/3214/TNgFBH6s7m/R
         YmWw==
X-Gm-Message-State: APjAAAVs7N8KRvIBpm5UiXVmxTin3bxDzuHygqR+ZWyIDyATIanJZNR4
        tfE6GyWnM78C2MwKI3ala3IBEAMG
X-Google-Smtp-Source: APXvYqzz1UW+C22TBHTMa4JusEpLnLuD5cDqdWDRqf5Xg5SCJUdtQShIxgNZsb0UPGGYZrt6OwSNXg==
X-Received: by 2002:adf:f951:: with SMTP id q17mr9457685wrr.173.1558981797637;
        Mon, 27 May 2019 11:29:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:485f:6c34:28a2:1d35? (p200300EA8BE97A00485F6C3428A21D35.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:485f:6c34:28a2:1d35])
        by smtp.googlemail.com with ESMTPSA id x22sm452147wmi.4.2019.05.27.11.29.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 11:29:57 -0700 (PDT)
Subject: [PATCH net-next 1/3] net: phy: export phy_queue_state_machine
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
Message-ID: <ce95f8fa-29b2-53d0-6f69-72f9196aa7cb@gmail.com>
Date:   Mon, 27 May 2019 20:28:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We face the issue that link change interrupt and link status may be
reported by different layers. As a result the link change interrupt
may occur before the link status changes.
Export phy_queue_state_machine to allow PHY drivers to specify a
delay between link status change interrupt and link status check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 8 +++++---
 include/linux/phy.h   | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e88854292..20955836c 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -29,6 +29,8 @@
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
 
+#define PHY_STATE_TIME	HZ
+
 #define PHY_STATE_STR(_state)			\
 	case PHY_##_state:			\
 		return __stringify(_state);	\
@@ -478,12 +480,12 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 }
 EXPORT_SYMBOL(phy_mii_ioctl);
 
-static void phy_queue_state_machine(struct phy_device *phydev,
-				    unsigned int secs)
+void phy_queue_state_machine(struct phy_device *phydev, unsigned int jiffies)
 {
 	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
-			 secs * HZ);
+			 jiffies);
 }
+EXPORT_SYMBOL(phy_queue_state_machine);
 
 static void phy_trigger_machine(struct phy_device *phydev)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7180b1d1e..b133d59f3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -188,7 +188,6 @@ static inline const char *phy_modes(phy_interface_t interface)
 
 
 #define PHY_INIT_TIMEOUT	100000
-#define PHY_STATE_TIME		1
 #define PHY_FORCE_TIMEOUT	10
 
 #define PHY_MAX_ADDR	32
@@ -1137,6 +1136,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
 int phy_drivers_register(struct phy_driver *new_driver, int n,
 			 struct module *owner);
 void phy_state_machine(struct work_struct *work);
+void phy_queue_state_machine(struct phy_device *phydev, unsigned int jiffies);
 void phy_mac_interrupt(struct phy_device *phydev);
 void phy_start_machine(struct phy_device *phydev);
 void phy_stop_machine(struct phy_device *phydev);
-- 
2.21.0


