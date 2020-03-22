Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A994B18E619
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgCVCtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:49:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34212 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCVCtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:49:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so5268660pgn.1;
        Sat, 21 Mar 2020 19:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FS355/DlagMHd1BrxDh8ix1dGSAXXztsH4fyn/7Ndgs=;
        b=Sggf9bSJmr839qR715Pf5DDl3Hzw4Sq1ViaqXU5gxpE8IuAZ2fu5mVqOMi6pfA/MnD
         WQccCGLrxVfkFjmsJwP7Rk3K7nADBNEXogYu83hnEyt48tBsZNV3M/fumvKMjJzkIMKZ
         E+Hy1qNJgMAyUXcb2uru+4upn+ccArcbvOatW1eR+USW1rRIufwbF96j+BFd9MmoFW8/
         UUzWPuuhizQmCXSaHRSPuYxYVG9xFjatyFOoRYOx7oMNhhcZq5eMUdbMrL+MSq8OHd9u
         WyTGaj4EbM9QQc8pX7H2h26D6t8T/bbjUWrQaZG6yb14qFDORBtysQPoOPV/VLgP9ich
         zPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FS355/DlagMHd1BrxDh8ix1dGSAXXztsH4fyn/7Ndgs=;
        b=fy3jQaMjlqho33Je9sVL3z/Cxeq2MgS7K9nprJpRPrWQM3gTGgBYgFLjm76gHNAgEw
         U+ERpm5UQje9UKJ71/aIRGqy3lROta8X2E4QoUd6V0aonuvVhUaH5314xLWEJJz2JGYN
         FzCNAW0uIXOMLMOXSPhKvGUbkXPOZWX6fMozaRXBZ6ct9xpkUs1ulC7xe/Ivyvj4i0Vz
         1LQCBpkaZEmPHGKWubPtyHF90XzK8o5mr1l3pJ0YG+gnmVRiQnzEwmL2PxXt8gqXQDGD
         Ns3BUgRZsZCAPkxBmbvYMESsep4U4fDeKD4QzEYxiFA7UnsIHYQ7cLYo9Z2nvdK43thO
         iu/Q==
X-Gm-Message-State: ANhLgQ3uw4DBcjYEQnsItjxpG218XnQEoOskj6eSR69HwW6k+v+VPNhD
        9AKP7ikZCvr9mEo5o1nDk3o=
X-Google-Smtp-Source: ADFU+vsSdmc1359ap+obd/TmugKlDLH1ls5odN6bT1vvKREcdbZfZhv5xF1ZWWL5GFq019eVrCZdbQ==
X-Received: by 2002:aa7:92da:: with SMTP id k26mr17668594pfa.139.1584845373549;
        Sat, 21 Mar 2020 19:49:33 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id h64sm9178931pfg.191.2020.03.21.19.49.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:49:33 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 3/7] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Sun, 22 Mar 2020 10:48:30 +0800
Message-Id: <20200322024834.31402-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322024834.31402-1-zhengdejin5@gmail.com>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
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
index 36d9dea04016..29718865242d 100644
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
+				  sleep_us, timeout_us) \
+({ \
+	int ret = 0; \
+	ret = read_poll_timeout(phy_read_mmd, val, cond || val < 0, sleep_us, \
+				timeout_us, phydev, devaddr, regnum); \
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

