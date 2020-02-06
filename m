Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D64154C1C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBFTX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:23:56 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41578 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgBFTX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:23:56 -0500
Received: by mail-pl1-f193.google.com with SMTP id t14so2730903plr.8;
        Thu, 06 Feb 2020 11:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nf9jca+hMQs7Cat5Jz2CzrqqiXuLOSBdlIq3cfbrt0Y=;
        b=o+igVjrUCEk9msksxFBcXk9Q+L11WU67C1VVsy6UaVs0g/1ubFuji25ig5OqemOH6J
         KSPfMbN7+mSVRSe0jgApAr37A8Laolj0tnrWCc8m7JlCR0lOcsAAi/Sd9jdQlLyDVqLv
         gjaPgMU9TNMshy6HinckZZnq4hpNtxXD4WdjGjfVeA912uwX1KcB2ZyF1E0Y2/+rJLv9
         CM1PypQ4zqv3ac/SL+4kz/wmJJCKP7az4ox+ukvPsOwzMUm2ZQKpgSOb4EnWae9CRc/0
         noOpOfVqK9ToBDh3JNukCWhwR/ezFKe6DKu8srrL8j5BBWSvxHSjSQfHo4MVgdYavYYp
         TkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nf9jca+hMQs7Cat5Jz2CzrqqiXuLOSBdlIq3cfbrt0Y=;
        b=HQ0MQAriN7QqvV9yp0cccvOjPepnBVXJygk7TloTg6dUhSjY6xub37W2hFjnIMBpB+
         /qUbCvPJw0l6iv/ok2eQyI62IoZSA06oafOlTnjyJCl3zNJTVbal4IIfhpwYxxGSCvFo
         sN9W+M8PHnGakP5IyjTyfN2YP21B3SNV0UccYkKOfhvpuM63TqVMpmuim9nSE8zW+zEg
         59z5l52UpAFdIScB/0+KxJW2r1uW4b9eYx2V8Zke69/MI8en6DqCmyVWdlNoHMMzPo8x
         gMOdqDZ2LtJJXBnZKgAoRFo+abBX3thsGB6q/boBAN3hY6eB/1QCpOlkMuB247xLmRxy
         TxKg==
X-Gm-Message-State: APjAAAVydKLtcXkjIrI84aIwKzSfK9naQ7m7Hl9mkaaJW1dMsDeu8a2a
        oNP5bXeJkbzZNoJnTGsJTtVzDegF
X-Google-Smtp-Source: APXvYqxxvSpSuR5gMDf2ApuoNK5fINQtOs2zbk3AK9+Tt35oqUihS/rk23F3BtcNnfKaeYn9fJJrDg==
X-Received: by 2002:a17:90b:4015:: with SMTP id ie21mr6396030pjb.1.1581017035236;
        Thu, 06 Feb 2020 11:23:55 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f18sm204715pgn.2.2020.02.06.11.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:23:54 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port
Date:   Thu,  6 Feb 2020 11:23:52 -0800
Message-Id: <20200206192352.19939-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 7445 switch clocking profiles do not allow us to run the IMP port at
2Gb/sec in a way that it is reliable and consistent. Make sure that the
setting is only applied to the 7278 family.

Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3e8635311d0d..d1955543acd1 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -68,7 +68,9 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS | GMII_SPEED_UP_2G);
+		reg |= (MII_SW_OR | LINK_STS);
+		if (priv->type == BCM7278_DEVICE_ID)
+			reg |= GMII_SPEED_UP_2G;
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.17.1

