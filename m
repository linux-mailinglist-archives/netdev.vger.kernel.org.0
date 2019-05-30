Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1FD2FC03
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfE3NLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 09:11:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40244 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3NLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 09:11:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id t4so4180156wrx.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 06:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=piB9jdynNJaNLZKNwDCODiQ8uSsXv/KDdMO4x/oeSU0=;
        b=cJukUsieK08kftQYnpHnWDmPqvSNVUetEBlxr3WF0moSs/9yAhzx27LuCdqPCRUYBT
         CpGiSezSbhIEfbbBM/kOol+Yhdwdl12OnRHLi118Y65TY8h/ZjotdymJ0217A2xYh1iU
         sYqyymGBhtR/3DOlcHKXaNkqtNRc6I5eNo93U518XY0z+afILcA4XzA0R4zHfr8zZivx
         Ltg7bsbDSw0BkZoSHEbDEevUG0VUQwiXmJA19ElB+ReI7JFojm/IgSxFkiUH3bJa9DCe
         a1FM60bRVdWWUQlZuKONUBxzeFu9oI7RHF1q2ZBuzM50qv+2dnhNsFSPx1nmQimPltci
         1bOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=piB9jdynNJaNLZKNwDCODiQ8uSsXv/KDdMO4x/oeSU0=;
        b=DfOxogS8dU2nhvA0F44JTWSNLNnU8JkZuvDAnW291N5JbYZUtOrYfZak/EJC4amrF9
         /43NGkW05jV6jvk4ZxzP+3qZimVXVPCWMGxYx9qvj1K9VrVp3t4EIwyX38+lWLrNQM3n
         +JaMhdR3hzAA0B6JOem+yntv2pf7I+nfaaUcEuRwQWnhHKeQaNKtvss6jbeOmceTPvW8
         ihQiMwvxgHu0CHO4TgREqGmp83UJBHNOP0UIRp4RSSkRkiGzH/F9NAcFkHZH4QpNJcMo
         dw/sAu6MQJvqQzclWIpBCu+Vl2BwvnWGZBOWpGswzAa9w6TAmuhNrM8TgUS2AYVve0nb
         b+Sw==
X-Gm-Message-State: APjAAAVW7lcEVyijylkz5kGjX+LKi1IzXdWztpkvDTdA1ao4cBJboZ1W
        hTQkFHCzrtwk9weNV7bW0ABTSvCY
X-Google-Smtp-Source: APXvYqzbYaAt8i1RZTA/lrUXb5RqaT64IExhOYdHt/D3ogz3h+hLHznpQUSCqK+cszH0YJa0K+ik2Q==
X-Received: by 2002:adf:f743:: with SMTP id z3mr2531511wrp.129.1559221882466;
        Thu, 30 May 2019 06:11:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:7d95:5542:24c5:5635? (p200300EA8BF3BD007D95554224C55635.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:7d95:5542:24c5:5635])
        by smtp.googlemail.com with ESMTPSA id z193sm4390255wmc.20.2019.05.30.06.11.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 06:11:21 -0700 (PDT)
Subject: [PATCH net-next v2 3/3] net: phy: export phy_queue_state_machine
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Message-ID: <2392b0dc-93dd-f23e-cf1c-115e17652850@gmail.com>
Date:   Thu, 30 May 2019 15:11:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We face the issue that link change interrupt and link status may be
reported by different PHY layers. As a result the link change
interrupt may occur before the link status changes.
Export phy_queue_state_machine to allow PHY drivers to specify a
delay between link status change interrupt and link status check.

v2:
- change jiffies parameter type to unsigned long

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 8 +++++---
 include/linux/phy.h   | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 068f0a126..74dfd424c 100644
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
+void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 {
 	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
-			 secs * HZ);
+			 jiffies);
 }
+EXPORT_SYMBOL(phy_queue_state_machine);
 
 static void phy_trigger_machine(struct phy_device *phydev)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 16cd33915..dc4b51060 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -188,7 +188,6 @@ static inline const char *phy_modes(phy_interface_t interface)
 
 
 #define PHY_INIT_TIMEOUT	100000
-#define PHY_STATE_TIME		1
 #define PHY_FORCE_TIMEOUT	10
 
 #define PHY_MAX_ADDR	32
@@ -1140,6 +1139,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
 int phy_drivers_register(struct phy_driver *new_driver, int n,
 			 struct module *owner);
 void phy_state_machine(struct work_struct *work);
+void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
 void phy_mac_interrupt(struct phy_device *phydev);
 void phy_start_machine(struct phy_device *phydev);
 void phy_stop_machine(struct phy_device *phydev);
-- 
2.21.0


