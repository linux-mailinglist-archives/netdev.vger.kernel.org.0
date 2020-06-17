Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1AE1FD111
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 17:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgFQPdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 11:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgFQPdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 11:33:51 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39B5C06174E;
        Wed, 17 Jun 2020 08:33:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z63so1316485pfb.1;
        Wed, 17 Jun 2020 08:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XYCr6Zy0SFc/eo2kKcuSj+TDFOwpW8ayTc9YaNvQW4=;
        b=jL7+9eMJJS22Gqpqh5AtGiabAxqRW3TL1kfyDKeARpjfoLdm5DlqJPm2YFc7Uf2c8e
         iiXwaEi5/fNkce1wIJhXRk5+bQ1nCxWhul9bHB4167Y9RMJMWBw2YopUQUWoSDLXDuZS
         +rY9HipdU7tLK1LoKHontQjuq9r+qSThpIrGluB/AKf7YfFg9jNJtlnXehv7kzDxTm9R
         4QbAp+jlWm3Z+fCjTP6ye3jh32Tc6LNPVgR7Lo/ykgiuJaRgmIEtz5Y2sKstd+Xh3hxo
         e8ePuyiGn6mK8Zba3CyfQtU/sMJ1zad3OTRRdBXTlNjWAmXL5WxVq+7IIewimQzUzQUw
         mLVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XYCr6Zy0SFc/eo2kKcuSj+TDFOwpW8ayTc9YaNvQW4=;
        b=uMBjfvJti32wVXU6Conak5YaUsyuyAvUtCOq9v/WGWdjQw0WWHQ6ekHbx0I/B9b6YO
         OWCa4g6+ELSTwExuL6R/ZIatS+MkJ+eHQCppLB+vNmRDfg/0L9ohfiYQAnTGAVsSKk5K
         3eRfb0fLdRT68E0UL/E6LkIkKRZQxvHovFjUbrG7zn1ef8v54Vf/hsBn0+rDfVKGUonL
         988oSNre1yr0TX6jHZfC+0BpSc6foZSDFXMjX7hC3VPMmsjwAgupANTEc1CAXSTyvq45
         G5MptyS7x1zVdl75qJkC5F3aziyja3OYeGfyGKoHvf4g9Wm92z60aS/O10BaGXh6JodR
         pQWw==
X-Gm-Message-State: AOAM532wQKLf05fjYaOTlZUZFXTS3wsjx7JiyWwYTlnjwLMLQB5MM/2M
        Q8/3ymvpSnY2379FNqs3z1c0QsF7oR8=
X-Google-Smtp-Source: ABdhPJy0mCD2xf2PUcMQKbv+6h9HAiiov65Br/IND4/ngNnMk7XnTejRwTuypmQ49c+OUM7F+J5fRQ==
X-Received: by 2002:aa7:9404:: with SMTP id x4mr7284949pfo.158.1592408031222;
        Wed, 17 Jun 2020 08:33:51 -0700 (PDT)
Received: from localhost ([144.34.193.30])
        by smtp.gmail.com with ESMTPSA id g17sm24275pju.11.2020.06.17.08.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 08:33:50 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: [PATCH net v1] net: phy: smsc: fix printing too many logs
Date:   Wed, 17 Jun 2020 23:33:40 +0800
Message-Id: <20200617153340.17371-1-zhengdejin5@gmail.com>
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

So fix it by read_poll_timeout().

Fixes: 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout() to simplify the code")
Reported-by: Kevin Groeneveld <kgroeneveld@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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

