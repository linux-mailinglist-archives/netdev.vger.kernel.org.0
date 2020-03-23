Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688D018F82E
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgCWPGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:39 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35674 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id g6so6031935plt.2;
        Mon, 23 Mar 2020 08:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QyLLQh4P4dJqNnMm7BJBkrejcs2c7VMgmgImcGrT3yg=;
        b=lgEAuSmSe1JBlVHjD/ekRSbfGdLKu++79JD5kGWu9enrz8PHu+PEQwgQHebhymAzIm
         DhxDpH2GofbNnHN+2VTaUy37RM7tw4Is7aXM7EQd9/ddEh8eJAvE4eKAqTn00MQuBENF
         /d9LgVQaFQ3ByU77W0zcJMiP128nbNZ5fg+p7h3oALoc0WuUDMT5nJtaabJMNhu2Ik3Q
         TeesF0Ig0Hmzz24z8tIo3XjO+hYcZy3W2vtJR7YI4vwdaFEYmICAgRZuvrXDY2RFq+/V
         cSMt1m8bAkuwQwT9hBKx91KJHSsX4jzbq47i3xU4Bt4yEDWp7zFUAEf1CfrA6pb1ScUC
         pHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QyLLQh4P4dJqNnMm7BJBkrejcs2c7VMgmgImcGrT3yg=;
        b=VECVSJK+Bio4IHkiu+y2vjaJMOhWqKIy+Nuw2DyFE6qx8IzPne31/0Pgew8tD6gWG6
         TFuu3j4to5sWNAkswW5UDaDM5HqHMwyntTeRNsyJKamiQoxMx3QTsglGgl03mAXiEeyC
         yFwikvoHotbCASe6emMB1WmXW94rLw5yF/aJWuYHE2pmVO2CLQw5Nm+5hrqyz/eIcgCf
         0E2wQzjBt0b9bB+ffE4dz/UcJG0+Ba1zRoGCvzYTeqonWSvw2zpDCDOQcYnNHhklvOlo
         E5NSLWrhH1hL6cHXsiTsD5cSOkYCCgpry1uixR/TiXLqMbqSEjN8DfZix7CKscUkFmPi
         oPLQ==
X-Gm-Message-State: ANhLgQ1HJutsqwRPluqyd1BCCERypUOBDLx/Jg1K2S9wWkxPZxiWT//O
        3SUMwiyXbHp4FZ48ni75Qts=
X-Google-Smtp-Source: ADFU+vvYtChrhw/oVd7fxzTKtdnlhOVC8RjZJLGEV+UZEISuAL7ucrb/iIt/S6JEKl3rOZU7oOUuQg==
X-Received: by 2002:a17:902:8f8e:: with SMTP id z14mr22423787plo.195.1584975996882;
        Mon, 23 Mar 2020 08:06:36 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id bx1sm12827062pjb.5.2020.03.23.08.06.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:36 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 03/10] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Mon, 23 Mar 2020 23:05:53 +0800
Message-Id: <20200323150600.21382-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323150600.21382-1-zhengdejin5@gmail.com>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v6 -> v7:
	- adapt to a newly added parameter sleep_before_read.
	- add prefix with double underscores for the variable ret to avoid
	  any variable re-declaration or shadowing.
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

 include/linux/phy.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36d9dea04016..c172747b4ab2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -24,6 +24,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/irqreturn.h>
+#include <linux/iopoll.h>
 
 #include <linux/atomic.h>
 
@@ -784,6 +785,19 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
+#define phy_read_mmd_poll_timeout(phydev, devaddr, regnum, val, cond, \
+				  sleep_us, timeout_us, sleep_before_read) \
+({ \
+	int __ret = read_poll_timeout(phy_read_mmd, val, (cond) || val < 0, \
+				  sleep_us, timeout_us, sleep_before_read, \
+				  phydev, devaddr, regnum); \
+	if (val <  0) \
+		__ret = val; \
+	if (__ret) \
+		phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
+	__ret; \
+})
+
 /**
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
-- 
2.25.0

