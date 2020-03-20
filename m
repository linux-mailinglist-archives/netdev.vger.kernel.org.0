Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A4418CEE6
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCTNeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:34:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36491 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:34:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id g2so2502259plo.3;
        Fri, 20 Mar 2020 06:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHfjWqMdgmsvCcyiUh0cLQzMtqfoMY+xsY6uvUQyywo=;
        b=FtKjXXFVeA5dFw1V5/sd9FWWkr8zptffNctgijVpRX80w9SjS6sW0stYT8jaOckebc
         HxEDhTxnrug9CF2c9mwIeqRQd44UnnRDr0EG1MueRCEZBp3Xx2JUpt76hVmdrQ/hepEq
         gldWEyqsL26VIfAmsi1S+F4/N1p/ed0xw2Nhxdwy4qPRUWceu2JRXfYTmOV8n/AO+9Sj
         9nXCTIC1YkrqBXoQuI4xEL93Husa/ks7QUJlVMYbEgYYN9tNyfo7/zA8tSin1xvF7gGl
         7RHbRtwH1mFZUcKrEWNBDvRn/luhdlDyy8ce4gSMaF+4XAQJlFxniutSK6BmiZcteUfY
         9Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zHfjWqMdgmsvCcyiUh0cLQzMtqfoMY+xsY6uvUQyywo=;
        b=XJCa5Vr355/QCXrXWfdMmGHDg4zbfHzZkbcGqU3ruDjOoMnU7EAndXYTnfVO2gmJr4
         xqjW/nahOJDrUNuqEKrlgpmoCeg23rzo4bOvXosfClEqz8tuPFZWoIO6wJC4C9F/tT+M
         lvcjTKnBPiRQcIjZhLrI0garRiGHb8AIS/poJxXQfBUisj8kVK4xONtJGrsTaQrukgSj
         FHvTnGMf4PiIMMgtdgQ3OJD5fMGDcKCigRroR4AK1LLGTMo/Psuy6G8kXE5/dQpEuLuC
         mbyx3fQDQhMQ8Zo2zoUzgU9dA3hECpVrw8apMgIUkX8mGO4itPSFxaHM7cXsNFB/0fZK
         hX+g==
X-Gm-Message-State: ANhLgQ1ddpWPOfb1j63RdO33ssLaIURS2KCzY6MxLfAzGgh0w8g2jCHD
        6HhCj6PkdnxSKjz8LFSZubY=
X-Google-Smtp-Source: ADFU+vsdUG8xJZPjbd9NuUg+9anBhtR+VYfYiOnvvdVKpSHuosCbkgmQRVDBZNalchdDxqEVlbQryA==
X-Received: by 2002:a17:902:e788:: with SMTP id cp8mr8323611plb.343.1584711283582;
        Fri, 20 Mar 2020 06:34:43 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id h15sm5278912pgd.19.2020.03.20.06.34.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:34:43 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 1/7] iopoll: introduce read_poll_timeout macro
Date:   Fri, 20 Mar 2020 21:34:25 +0800
Message-Id: <20200320133431.9354-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this macro is an extension of readx_poll_timeout macro. the accessor
function op just supports only one parameter in the readx_poll_timeout
macro, but this macro can supports multiple variable parameters for
it. so functions like phy_read(struct phy_device *phydev, u32 regnum)
and phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
also use this poll timeout framework.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	no changed

 include/linux/iopoll.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index 35e15dfd4155..7d44a2e20267 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -13,6 +13,46 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
+/**
+ * read_poll_timeout - Periodically poll an address until a condition is
+ *			met or a timeout occurs
+ * @op: accessor function (takes @args as its arguments)
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @sleep_us: Maximum time to sleep between reads in us (0
+ *            tight-loops).  Should be less than ~20ms since usleep_range
+ *            is used (see Documentation/timers/timers-howto.rst).
+ * @timeout_us: Timeout in us, 0 means never timeout
+ * @args: arguments for @op poll
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @args is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define read_poll_timeout(op, val, cond, sleep_us, timeout_us, args...)	\
+({ \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __sleep_us = (sleep_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
+	might_sleep_if((__sleep_us) != 0); \
+	for (;;) { \
+		(val) = op(args); \
+		if (cond) \
+			break; \
+		if (__timeout_us && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
+			(val) = op(args); \
+			break; \
+		} \
+		if (__sleep_us) \
+			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
 /**
  * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
  * @op: accessor function (takes @addr as its only argument)
-- 
2.25.0

