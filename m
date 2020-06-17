Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F89A1FD49F
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgFQSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgFQSeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:34:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0855CC06174E;
        Wed, 17 Jun 2020 11:34:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h22so1490492pjf.1;
        Wed, 17 Jun 2020 11:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o+F/tus9nfWB/lkL+XDSGiyd9Zu1ZndCCBPnUaGr8l0=;
        b=uLfkhUyOKJ6uQejo3Uev90lS4/JK9YhrGIrm6FcdP0tQiroJyaJaXlGAQVb22Nr1hh
         ASyYM1eoPc8X1j2MLOqe1xuSnYvuSSH5tLZcgxJ9PJjbLbSpFAmhxUZGhl0/ccc25DPA
         AkCpFoCS18lBFqEXNwj5Mp2F/1i4wPbrsBfQ+qd30gFQmyHBNesEQgSKbRRh8M8PUSmR
         PU/tM33er5KmIT4RIkdmvW9jtJjskKazBz/zrY1ibpaVJCnDJEW6ALeBw7nJYA3b3xWd
         IxDIYThDAIFPON165gIhpkufZJAWXvah5VVouHbPyIYuRRWpo8LMZ4WszcTd3NObMR6+
         Q93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o+F/tus9nfWB/lkL+XDSGiyd9Zu1ZndCCBPnUaGr8l0=;
        b=gcL823o1V6i7rkYGr82DZwpNzpdMIMJZwA838Ldko+q6A1078ppoNpcg3dL/YJUcvv
         iMeOiJ6B1vFgh9NR/AaC8LuexfKMsk6H4H4+hmTU0U4FMY1stIpRJ/GKlJSFzLc3Dli3
         aCIGr7sKWQEe1iNa3ngt9G73aP+Rskl8A4z1XiBD5kensmS3OmMqD/wTGlvjUOYYunC3
         Q66rU/KtdZ8HOa77vksEmbGUehYL8yj5bHGKqyuRSdTqYYKBA0pvgHn77JSE6bwZJUhD
         Iyrx9QHLOZIchoObPFXqOmg1RqhvNf9By0bpNIwx9AF3mRmGMWApfzW3sFkTkajAMMuf
         /Hfg==
X-Gm-Message-State: AOAM532M3l+JalgbzV91kg3OPnNjd1JFUrW8yZDbX4miYv4iofFAPn0w
        aSR3WanxGT2l99xNC3CVX4Q=
X-Google-Smtp-Source: ABdhPJwV4TA0oCueMlz9zIR8iM9tXELvIZhmCGHP3+JtTYDJjM1/jEM87S18slo5FC476bCbuOFj7A==
X-Received: by 2002:a17:90a:930f:: with SMTP id p15mr383155pjo.85.1592418852544;
        Wed, 17 Jun 2020 11:34:12 -0700 (PDT)
Received: from localhost ([144.34.193.30])
        by smtp.gmail.com with ESMTPSA id u74sm444372pgc.58.2020.06.17.11.34.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 11:34:12 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: [PATCH net v2] net: phy: smsc: fix printing too many logs
Date:   Thu, 18 Jun 2020 02:34:00 +0800
Message-Id: <20200617183400.19386-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout()
to simplify the code") will print a lot of logs as follows when Ethernet
cable is not connected:

[    4.473105] SMSC LAN8710/LAN8720 2188000.ethernet-1:00: lan87xx_read_status failed: -110

The commit will change the original behavior in smsc driver.
It does not has any error message whether it is timeout or
phy_read() fails, but this commit will changed it and print some
error messages by phy_read_poll_timeout() when it is timeout or
phy_read() fails. so use the read_poll_timeout() function to replace
phy_read_poll_timeout() for fix this issue. the read_poll_timeout()
function does not print any log when it goes wrong.

the original codes is that:

	/* Wait max 640 ms to detect energy */
	for (i = 0; i < 64; i++) {
	        /* Sleep to allow link test pulses to be sent */
	        msleep(10);
	        rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
	        if (rc < 0)
	                return rc;
	        if (rc & MII_LAN83C185_ENERGYON)
	                break;
	}

the commit 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout()
to simplify the code") modify it as this:

	phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS,
	                      rc & MII_LAN83C185_ENERGYON, 10000,
	                      640000, true);
	if (rc < 0)
	        return rc;

the phy_read_poll_timeout() will print a error log by phydev_err()
when timeout or rc < 0. read_poll_timeout() just return timeout
error and does not print any error log.

 #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
                                timeout_us, sleep_before_read) \
({ \
        int __ret = read_poll_timeout(phy_read, val, (cond) || val < 0, \
                sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
        if (val <  0) \
                __ret = val; \
        if (__ret) \
                phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
        __ret; \
})

So use read_poll_timeout() to replace phy_read_poll_timeout() for
be consistent with the original code and fix this issue.

Fixes: 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout() to simplify the code")
Reported-by: Kevin Groeneveld <kgroeneveld@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- add more commit message spell out why has this commit
	  and how to modify it.

 drivers/net/phy/smsc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 93da7d3d0954..36c5a57917b8 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -123,9 +123,10 @@ static int lan87xx_read_status(struct phy_device *phydev)
 			return rc;
 
 		/* Wait max 640 ms to detect energy */
-		phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
-				      rc & MII_LAN83C185_ENERGYON, 10000,
-				      640000, true);
+		read_poll_timeout(phy_read, rc,
+				  rc & MII_LAN83C185_ENERGYON || rc < 0,
+				  10000, 640000, true, phydev,
+				  MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
 
-- 
2.25.0

