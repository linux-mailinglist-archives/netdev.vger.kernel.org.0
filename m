Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6BD18EB0D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgCVRuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:50:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42033 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCVRuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:50:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id t3so4853600plz.9;
        Sun, 22 Mar 2020 10:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/YhBDotZNiUkpqK45eTrgb3dFMB1KDWG5QBFRlQzbfM=;
        b=Y6oLeb7XdV3SgVAK5PbJRcvZ2+K1yOxt5UvbgsxZYszMis6QthDllZB4/n7rw2wlG3
         bSiQe3f/RPF/Kxtlt2dLkFIOgn6eppA8xkzvG14Ww1mbuARoa8O1XgCB20KTMCERhh4L
         d8Y72xV0LwUhTmHDCMKsrQM/t8IY7017EXjYHukMiw/lu4reMK4QVbd0tbxcHAV7wYDg
         ZAQuErck+REWqOAVGtqXdycqpCDElESqSFpnr7LAWxFaEobEk15gjrsNDg74532dvKtq
         4tJdMYgfc0h15Ja4W6ds212iN35VW1QEHvZujR7z6n9CzHoGmB4GsI2L04oE/g4A1uV/
         y3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/YhBDotZNiUkpqK45eTrgb3dFMB1KDWG5QBFRlQzbfM=;
        b=uHXwjGBxJNv3B3auJYzl81cUs0ZXuFAUXgl94h2P/R8jZ+p8dQMN6i86SSyLbA0Vst
         xm87tkEGmnYt7joeLdPXy1YjkUvZMW6QEvIbmkr0/dKkb3/P9oaKT5t229jq2Z/GpFZf
         PI4HGG2J7phsUTJim7NYpcSY60xFoDHJUgq+e+tZxhkutLEmUegn3HcixF46bl840t9a
         x8+OLmZ1q46JWOhcSct0NAvOZgzonP5+tgEmuAFDZwCvv6bwbY/DwfEh9EHkuyZilmnb
         UhStnq89HSc5WupYK6p+j0lGTGflasxOuyoKj8i4ruPr242sCl7Jr5UoJO6znIeFKcCf
         qf/Q==
X-Gm-Message-State: ANhLgQ2mH6+eFaGp5rPypjS2rmN4U1h8x7pIsUud83cdKJZhAJmNRYkw
        /SwJX7SKhq0VyOB9oW55wW4=
X-Google-Smtp-Source: ADFU+vsUwW2kD/BfkehLGAKKgAL+HFOhety1BX46RhwuHdVRlUcXWeJm2uamduuqRrwuXxcoWYV3+w==
X-Received: by 2002:a17:90a:228c:: with SMTP id s12mr20944474pjc.68.1584899404058;
        Sun, 22 Mar 2020 10:50:04 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id e187sm10433716pfe.143.2020.03.22.10.50.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:50:03 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 03/10] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Mon, 23 Mar 2020 01:49:36 +0800
Message-Id: <20200322174943.26332-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322174943.26332-1-zhengdejin5@gmail.com>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
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

