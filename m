Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F567214DF1
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgGEQQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGEQQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:16:58 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CD2C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:16:58 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d15so32471567edm.10
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UQT91UzsRL4+ndcEDa8t2SI2HArH2KSlMIdpJT+MHLE=;
        b=Aa6QVsP5mvs+iYRXQsFBJVJjt9h+degnxZS+3xurOYKwXoYUMFTRHz4jMqLcK0bmqw
         cOYzHpaV86/cIZfM9/N3a8B9OZCZqfcy07V8gS/7aan2tsLmxXIbMHjz8zJaeaeNXyo8
         zzgUic0tTeLNiIHBL4WHmAdmKDNRx+q8+gncz2FPHciDk330vdKbzBH73zaYWTt+lktw
         1PK3N/GH0XXV55oXtHTTcgvo9xuAGOYS5Q8kjlDBbL3bJCoWESIKPRJn73+Eww5RCZzZ
         sAa9RVM+a9UXy4XBwuQ5O1AmMqR1Af/IL6nghj+U8HkYBvB/z/29/ycomjP6tW9DAHj4
         sBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UQT91UzsRL4+ndcEDa8t2SI2HArH2KSlMIdpJT+MHLE=;
        b=iKRsqpCG4DaC/Tny3hKY96ZehBYE9jR653Fi5ZI/xfuUXIVSDl00VgAKjDp60T9T9u
         wlYCfIjPwrWEBtFAW/xtFmqMOdUH53kk8MclbXsfGSW1cl25lgYswTQzhqcCAY/BC2q+
         6VzHDge6ATQIU8SjLgNPHn34uO/0lnmQfvjasMro+nuHAMyKh4dUDDGhVgpai7HClKYH
         dzWNKY663STc7nOjIIefAJPMtvD5Y3q0BI7FHkO6VLb6MMS1qkCDepQ/t02coE4jw5LS
         am85hQ0HjrRU6xyI0QSx6BMG7NnuK6qhk3/XtoQO9os/Cbet0qISiYRiyaQCaXp063Lw
         rPMA==
X-Gm-Message-State: AOAM530y+QPC9L+MbKpy/YYV4aqbUpL4sqVDMw2YTdtVK4pHtAPLuXJ1
        d6ika6vf1o6OtzFx0AgNcQw=
X-Google-Smtp-Source: ABdhPJw7qWsRTdcadSuV6n5ZpUryUqTABVY4brbWJQhN96IObECT5qd1JqG3aaXNnwFhNrGxdn6F3g==
X-Received: by 2002:a50:fd12:: with SMTP id i18mr52497549eds.371.1593965817025;
        Sun, 05 Jul 2020 09:16:57 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x4sm14406126eju.2.2020.07.05.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 09:16:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next 1/6] net: dsa: felix: clarify the intention of writes to MII_BMCR
Date:   Sun,  5 Jul 2020 19:16:21 +0300
Message-Id: <20200705161626.3797968-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200705161626.3797968-1-olteanv@gmail.com>
References: <20200705161626.3797968-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The driver appears to write to BMCR_SPEED and BMCR_DUPLEX, fields which
are read-only, since they are actually configured through the
vendor-specific IF_MODE (0x14) register.

But the reason we're writing back the read-only values of MII_BMCR is to
alter these writable fields:

BMCR_RESET
BMCR_LOOPBACK
BMCR_ANENABLE
BMCR_PDOWN
BMCR_ISOLATE
BMCR_ANRESTART

In particular, the only field which is really relevant to this driver is
BMCR_ANENABLE. Clarify that intention by spelling it out, using
phy_set_bits and phy_clear_bits.

The driver also made a few writes to BMCR_RESET and BMCR_ANRESTART which
are unnecessary and may temporarily disrupt the link to the PHY. Remove
them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2067776773f7..9f4c8343652f 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -815,7 +815,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 		phy_write(pcs, ENETC_PCS_LINK_TIMER2,
 			  ENETC_PCS_LINK_TIMER2_VAL);
 
-		phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
+		phy_set_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 	} else {
 		int speed;
 
@@ -845,10 +845,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 			  ENETC_PCS_IF_MODE_SGMII_EN |
 			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
 
-		/* Yes, not a mistake: speed is given by IF_MODE. */
-		phy_write(pcs, MII_BMCR, BMCR_RESET |
-					 BMCR_SPEED1000 |
-					 BMCR_FULLDPLX);
+		phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 	}
 }
 
@@ -882,9 +879,7 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
 		  ENETC_PCS_IF_MODE_SGMII_EN |
 		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
 
-	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 |
-				 BMCR_FULLDPLX |
-				 BMCR_RESET);
+	phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 }
 
 static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
-- 
2.25.1

