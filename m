Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F31818E730
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgCVG4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41095 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgCVG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id b1so5413121pgm.8;
        Sat, 21 Mar 2020 23:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jf5GGrEQTGb8qy20DRd06krh9Gv2NQ77lLVuvNYspJ0=;
        b=USb1Zbua/Nbj3QYyOtxhdvR25BtThwYDttmhFBibvLYfRBQLgyvjBklUJ9t+eo3PlT
         rvQhQGaLkvxpapFqkBiUsRU+g6dOLi+UPoCl4nxhQffFYDUq1pUa/GQXeism6H8xKCg3
         Aje75iNDCkPwhi8c5dXGB0Y/BMlRAuVpsmQs/BsZjyZ7dlL3lE7G1P5iHLoTDsGz4Gzh
         yI/hg2JxsgadOWLGHO9s5POz3TLu/6s/WQGMvPg2G1VtNAUv+qt+CWOd/faR4nOJIb6u
         LEj6NiVMyB9/EFSiHpdMGeio/h/ZVqu4yMieXJJ+QVtQWa8BS2e3QMbF5qOgCb3eib75
         b1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jf5GGrEQTGb8qy20DRd06krh9Gv2NQ77lLVuvNYspJ0=;
        b=gjS0eYqhZ01T0HGJ4J/cIbrF6fVuwPWMB24cyPB7G4uUpejxWDGOJ/Ex5Mh9KFwV7x
         fqwjqroE37QyT8Svq2/Sqa8qIhaCloMWw9mHFNn+ZBseHjb8LOg6vT7UJZJCx4H0DhET
         6b2gS4SfCOI2wYI3ll2Ilwrv/VmUuuTQDgIl6gq27PP1s3GnkdNxNNYmU6vVSJn3smtt
         5SVvTuB+b5y+6YERi6VM01QSImgiz69uniyLd3haJGg80XEd28QnsyewnNWE+B5QITzh
         2dV2n5wD9fwXHK2FtruaRVRVrFyl+RVtOaRabdLp6fkSJflDJFc3EWXUjdCEUkon6Cmu
         We9Q==
X-Gm-Message-State: ANhLgQ3IjDPi2ME/TDrEjk7HlN/i6ig2o/XuvyVcj2E8wxOYp7CG3TIx
        pbLBvI1XrIVrmGS9PzBCcGb0DNYC
X-Google-Smtp-Source: ADFU+vvmbvx+amkArGwH0mxbuaEJtzRLM51q1s6npigOIDIX9nq/1Ozz912JBDiWeccSsr+u0IssFA==
X-Received: by 2002:a65:4806:: with SMTP id h6mr14469728pgs.295.1584860174907;
        Sat, 21 Mar 2020 23:56:14 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id c1sm8744939pje.24.2020.03.21.23.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:14 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 3/9] net: phy: introduce phy_read_mmd_poll_timeout macro
Date:   Sun, 22 Mar 2020 14:55:49 +0800
Message-Id: <20200322065555.17742-4-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
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

