Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388CB18EE38
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgCWC5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35565 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id u68so6784047pfb.2;
        Sun, 22 Mar 2020 19:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XPNpREPrKXsdscJCtGIsFykCiZzhn9WW7+8w0rGQ9A4=;
        b=IApyGohZoFvLgK6DbM4qeGYTrqNTPHBgg65x6HQnmkoR6Lp6HPFxVpT15q5wvFGgnE
         WO7qNfuzWrGBCUdGPjLQn2os4DFelBRs4FLu4GsN3rhU6n/EHw0yGi09sieQsCrDGYrA
         rkXk/5Svg3OXU8qwAB4M2KKscFCz9djHSjqW98ScTH5UqzPtKo/FdG0aryUHrQy7jlLs
         KY5kXl3wDnlFmKtZFJKs5DGKE8l21HdLtNUZqDqOSFxlJPKrt/syQQtjDUkPUFYTIQyd
         UmFH4MIST7JLDrgKhCey0Mi8x77SCRQcgI1gL1QfN9+XXNq7Y43sRddFhD1EimIJKAbc
         2yDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XPNpREPrKXsdscJCtGIsFykCiZzhn9WW7+8w0rGQ9A4=;
        b=AmdBz48yGAgzoAdmfor5H07P0SkDIuz/B7qvrXRPsw31g5eHtrJTojak6hnduuKXEN
         +/HqSHBkEpvjYT3AjzCT44nK9LKFxrcQbkkVrNGNPaGinXUY0Ko4PbvpVI7TcYgdATSN
         RVKuyScB03xBaS+9POIKtcgahUH42bbd+wmF9E8+8ERIFm7B3NFtCqT4M06nhxdPTfsu
         XGOj+vG6zKZDeqQvD2GYHqKTS/FWm69+MmD2wzSLpzg8UXykkaeF7Kaer3rajdSAe3Dn
         RU2gh8sbHQE0Vean9CD4a6nGjM42+oBq5SayiyxIEmIdATXZwPtwPSfgKgUBwyyEnjw2
         /WrA==
X-Gm-Message-State: ANhLgQ1ER3e1+OJc/RQaOJMqQ1lTuvR3ElU94xom0y3SmUvKY88DvsLt
        qPdOK7/q89BaWEzq0DNloho=
X-Google-Smtp-Source: ADFU+vtAdouusdfXsITnRRrZHpdMhP9G8zf7UdP+zkETppWYMIaJJw0JohSxx9vjumWLhnptEzipjQ==
X-Received: by 2002:a63:2166:: with SMTP id s38mr18848174pgm.83.1584932231771;
        Sun, 22 Mar 2020 19:57:11 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id h4sm2622405pgk.72.2020.03.22.19.57.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:11 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 03/10] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Mon, 23 Mar 2020 10:56:26 +0800
Message-Id: <20200323025633.6069-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it is sometimes necessary to poll a phy register by phy_read_mmd()
function until its value satisfies some condition. introduce
phy_read_mmd_poll_timeout() macros that do this.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- no changed
v4 -> v5:
	- no changed
v3 -> v4:
	- deal with precedence issues for parameter cond.
v2 -> v3:
	- modify the parameter order of newly added functions.
	  phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, \
				     phydev, devaddr, regnum)
				||
				\/
	  phy_read_mmd_poll_timeout(phydev, devaddr regnum, val, cond, \
				    sleep_us, timeout_us)
v1 -> v2:
	- passed a phydev, device address and a reg to replace args...
	  parameter in phy_read_mmd_poll_timeout() by Andrew Lunn 's
	  suggestion. Andrew Lunn <andrew@lunn.ch>, Thanks very much for
	  your help!
	- handle phy_read_mmd return an error(the return value < 0) in
	  phy_read_mmd_poll_timeout(). Thanks Andrew again.


 include/linux/phy.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36d9dea04016..42a5ec9288d5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -24,6 +24,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/irqreturn.h>
+#include <linux/iopoll.h>
 
 #include <linux/atomic.h>
 
@@ -784,6 +785,20 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
+#define phy_read_mmd_poll_timeout(phydev, devaddr, regnum, val, cond, \
+				  sleep_us, timeout_us) \
+({ \
+	int ret = 0; \
+	ret = read_poll_timeout(phy_read_mmd, val, (cond) || val < 0, \
+				sleep_us, timeout_us, phydev, devaddr, \
+				regnum); \
+	if (val <  0) \
+		ret = val; \
+	if (ret) \
+		phydev_err(phydev, "%s failed: %d\n", __func__, ret); \
+	ret; \
+})
+
 /**
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
-- 
2.25.0

