Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA118BCC7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgCSQj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:39:56 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39771 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgCSQj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:39:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id m1so1287581pll.6;
        Thu, 19 Mar 2020 09:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TP36WZMHYSYzMNBK89obe9dIGjZsMZr6pVHpLGOr37M=;
        b=c5jG3cC2PDZynDJFpg1UdGbPIbEs3G4GKB+aePRb4flbBf3k5U6mLsrpmodcqlfau1
         vX0mdiYFyHFc29c0wWqvrNdmKDU0FzMIfB0vRnSKbWuhju9ctQHXrPlehbO8svmjEmSP
         /d5mmwXcUinUJKEeELr+cCfnw98pGgeCnK3kXLvryM19Cj6u/v7nZv+SgwRpJ3MhhkFA
         6dajzfXt1dujQJvphafglIGQvCrKQYVumf0240saO+HY1GWzt+eZR/+UC3BEIjxlIMAW
         ERjra8OapWk5DbYsn+AmSPQEOswy+vmRhlOhwo2Lp80Xqx9drHsD0KBbKPa9v+pqEu8a
         tlmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TP36WZMHYSYzMNBK89obe9dIGjZsMZr6pVHpLGOr37M=;
        b=JzIrhkNfZ4WSbTPjBezCz7e9GHkRWZNBANWP2rGDZOZC8SjR/m2gBPa6XFa6cpliIR
         1ZzOGzmgMOW6kgIbW/xXPffJWHvSJ5pO8yEbwyduSAnJnhbSDCZwug+FFtv8/kJ+u6TM
         PI386FjCSjeac3yxuQ25ysd0Kt+6Zly34sNToJXCM9bJ09WNHQnfAlROHriJxuwj/sNe
         CdOKQvtyfi3+v2AS9GSQExi5P/fVUQ9XmuL48BnkdvYnTHRPHTLKkjIj3mdIQ5d5cE1S
         DyLH+pFjVfqceYLnywsiU05KDfqcHLNLCIdZEWj/2uAUaqWRalem2GTMjJfKoWl7sQBg
         w3sw==
X-Gm-Message-State: ANhLgQ3f4ayN8CMiBhLOSRwqbhQgPlPqTKsyIziXb9MCnVaeTEU/vWE6
        MPsrkK3gaFOHN0LzzY4ZMWg=
X-Google-Smtp-Source: ADFU+vsS7JCuxPrSCnZxWqaJzvuhJS9LEo2ew7RUys6oS/VJZ9SrXr9UP2kzKp3orFj9vHMFDesIZA==
X-Received: by 2002:a17:90a:d081:: with SMTP id k1mr4982443pju.57.1584635995324;
        Thu, 19 Mar 2020 09:39:55 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id f19sm2897699pgf.33.2020.03.19.09.39.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:39:54 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 3/7] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Fri, 20 Mar 2020 00:39:06 +0800
Message-Id: <20200319163910.14733-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200319163910.14733-1-zhengdejin5@gmail.com>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it is sometimes necessary to poll a phy register by phy_read_mmd()
function until its value satisfies some condition. introduce
phy_read_mmd_poll_timeout() macros that do this.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36d9dea04016..a30e9008647f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -24,6 +24,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/irqreturn.h>
+#include <linux/iopoll.h>
 
 #include <linux/atomic.h>
 
@@ -784,6 +785,9 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
+#define phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, args...) \
+	read_poll_timeout(phy_read_mmd, val, cond, sleep_us, timeout_us, args)
+
 /**
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
-- 
2.25.0

