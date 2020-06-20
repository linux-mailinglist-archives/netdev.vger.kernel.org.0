Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2EE2024A2
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 16:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgFTOzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 10:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgFTOzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 10:55:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D70C06174E;
        Sat, 20 Jun 2020 07:55:47 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h10so5896732pgq.10;
        Sat, 20 Jun 2020 07:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xkN3Nqs8Mpsz6zRUijdY174ENwikcs7qGuesYlxrSjI=;
        b=c/vKfuiFIYojCAck+RLxL9ApV//jFDePhwZZufsSsKLeVX2tc3rZjPSv9S6T3+/qs0
         rOjdJn+yllo8QXwVEGYTYZzGsUNfAKpzXansURtgu+hmoq1GVEq/eLxBw09xnIcnf9n4
         zOyjsUVhcZ5iaN/rDcm48u+nmTon9MjhPXvzH3vLgGvMHIcCW31oyKyogqU6dMyWw/GT
         47YgGRxjeoHIVLSDYBIFoxo6+25/IBe7MwRYW4ZpveMMTT33bgb3SBpDhxgZhPYxlRxR
         Yr4gVupt0LKAIa0t5y+EB4tT4fl5YLeIoXJEOGm94NLI1uirUAtZ4QQzJuXGl52npimw
         7ciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xkN3Nqs8Mpsz6zRUijdY174ENwikcs7qGuesYlxrSjI=;
        b=gKydBitcVjpZZBEv69jtHwi6D2XwibXyz0pnGMm4IYatYBvdd/8HPAH42Va4E9f+xS
         TLCEXw/io8SEeoQSWsqWJkyF2iRKhF5zxKGC0hQ6o4sh+BH82LPRWtT4LNR1xSzQPe4P
         4xp8ASXb8uRoRCVI+UX+ewv7l2JS8lEIbvsKpO8TI+RhHwzbbJMkTnZOXwtGmJL4rHSj
         DdrHaPPHe/W5ZkChggieDqUxkAIX6tobODn7UWcNRCKKUPJ9fNxmfNPqx/A7AzkkI//h
         AybQG+C7lXkUFt75nCrrWpHhfHyjg8TWAS3R3v6xYSCyANtAFjBYrqpeMcHzvEca2psx
         kpQw==
X-Gm-Message-State: AOAM532d0zeVQFFu2KoWOFxHqQSPc/vgUWpYpyx/5b2/pvWk1HtAj2+P
        H1p67oPuGzsQ2wpWDuD1qb0=
X-Google-Smtp-Source: ABdhPJxoPCcBLGeMiQ3QpPlJ+//5f8iSdU9r8eqC7Jpu/JZB1aaxjUp2Hbfe1EnTu8/kyNksRqGcHw==
X-Received: by 2002:a62:7f44:: with SMTP id a65mr12781340pfd.258.1592664945810;
        Sat, 20 Jun 2020 07:55:45 -0700 (PDT)
Received: from localhost ([144.34.193.30])
        by smtp.gmail.com with ESMTPSA id b29sm9205138pfr.159.2020.06.20.07.55.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Jun 2020 07:55:45 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: [PATCH net v3] net: phy: smsc: fix printing too many logs
Date:   Sat, 20 Jun 2020 22:55:34 +0800
Message-Id: <20200620145534.10475-1-zhengdejin5@gmail.com>
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

When wait 640 ms for check ENERGYON bit, the timeout should not be
regarded as an actual error and an error message also should not be
printed. due to a hardware bug in LAN87XX device, it leads to unstable
detection of plugging in Ethernet cable when LAN87xx is in Energy Detect
Power-Down mode. the workaround for it involves, when the link is down,
and at each read_status() call:

- disable EDPD mode, forcing the PHY out of low-power mode
- waiting 640ms to see if we have any energy detected from the media
- re-enable entry to EDPD mode

This is presumably enough to allow the PHY to notice that a cable is
connected, and resume normal operations to negotiate with the partner.
The problem is that when no media is detected, the 640ms wait times
out and this commit was modified to prints an error message. it is an
inappropriate conversion by used phy_read_poll_timeout() to introduce
this bug. so fix this issue by use read_poll_timeout() to replace
phy_read_poll_timeout().

Fixes: 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout() to simplify the code")
Reported-by: Kevin Groeneveld <kgroeneveld@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v2 -> v3:
	- modify commit message to why need this patch. And many thanks
	  to Andrew and Russell for their comments.
v1 -> v2:
	- add more commit message spell out what the change does.

 drivers/net/phy/smsc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 93da7d3d0954..74568ae16125 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -122,10 +122,13 @@ static int lan87xx_read_status(struct phy_device *phydev)
 		if (rc < 0)
 			return rc;
 
-		/* Wait max 640 ms to detect energy */
-		phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
-				      rc & MII_LAN83C185_ENERGYON, 10000,
-				      640000, true);
+		/* Wait max 640 ms to detect energy and the timeout is not
+		 * an actual error.
+		 */
+		read_poll_timeout(phy_read, rc,
+				  rc & MII_LAN83C185_ENERGYON || rc < 0,
+				  10000, 640000, true, phydev,
+				  MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
 
-- 
2.25.0

