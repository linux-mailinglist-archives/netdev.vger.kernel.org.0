Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6588718CEEA
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgCTNey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:34:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34160 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:34:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id a23so2509574plm.1;
        Fri, 20 Mar 2020 06:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PL0PTIOm3HjsIV7LXQhTZaFywor65IsPC9pHNSkg178=;
        b=P0+wk6m1kvn6tYz9FMfXB7JmGXxMGQRhtcof3deUdfIaovAqsHRfJ91C8duEg5kBm9
         +bfcajDkSh+qJ498bnZ1zQACFmGcd5IxkhijQHtihO5WXy+fMSl9tw4y+JUCUaioHeYu
         GvyZSM+sg16TA5H+a6P5l2YcrWB2NJTCRLG9dRLatKUljP8LJkEVx4c7UQ5PaR16jCD5
         4IA+rkQ7XQk4LtvgJV8OqqHn5qy84vGOlNW0GmvxzLCmIlVNj5e7PNu7p9aMMLMryjgU
         2KpRZRDd0Q37pmuc4TLvYQV4V0Adtxu5A88L7e9dsbPMYyemQdG4zN+CTgCvJeHVeQjY
         VodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PL0PTIOm3HjsIV7LXQhTZaFywor65IsPC9pHNSkg178=;
        b=V9I/wU2YHx5Qly6cCdME8ero3O29vlUuL9BKFxLYRhKxbf2glICh4JKSaW1CQzvXl8
         /Fj6CN29pn4v2qp1bmuwUIXckMaIqnWsgVqNyTk85J9D2pPjH/KWj4Urqhj3CjuGH60s
         14OO8oQUeWPsyY+TJB9gogXEYw9wralkXBVv06umzoHJzJPrN4C52H4igtzvlBKfsxj8
         tS8k9nrnGe9HoArJXF3zOjLp8q7Z4Z0rRLYm9R91i3eTpfaYRQJq+e8OHBhGISr2T1th
         ZH8TmYXGRTPNd1soTYZ5+rpAxlsRrcMpeHw9lUmd8Et0JXfuS2hat2GcvjLSDzNf2la6
         OgWA==
X-Gm-Message-State: ANhLgQ1d17fLFd6T+2Xw9gOH1pjEch49P5mr2Ugf0gld1auChu20sY3F
        6fEK9hIAcLc4ikAB4dHG4SM=
X-Google-Smtp-Source: ADFU+vssmLcrhF+u23k+YS2vxuAzD5YXcWjLuVq+kOp09b+JoluRoQFZ9vPMiRYHfuc4eKZHXbf7yg==
X-Received: by 2002:a17:90a:804c:: with SMTP id e12mr9207405pjw.19.1584711292048;
        Fri, 20 Mar 2020 06:34:52 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id nu13sm4997294pjb.22.2020.03.20.06.34.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:34:51 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 3/7] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Fri, 20 Mar 2020 21:34:27 +0800
Message-Id: <20200320133431.9354-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
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
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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
index 36d9dea04016..bb351f8b8769 100644
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
 
+#define phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, \
+				  phydev, devad, regnum) \
+({ \
+	int ret = 0; \
+	ret = read_poll_timeout(phy_read_mmd, val, cond || val < 0, sleep_us, \
+				timeout_us, phydev, devad, regnum); \
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

