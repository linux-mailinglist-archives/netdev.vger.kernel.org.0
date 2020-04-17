Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B23A1AE4E3
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgDQSiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgDQSiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 14:38:15 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAFCC061A0C;
        Fri, 17 Apr 2020 11:38:15 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p8so1514792pgi.5;
        Fri, 17 Apr 2020 11:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l4ymR3rP3ebjknnAHpxFsTgWKlyKO3VmlyIU0nWQg9M=;
        b=PMurcRxCPBrnoaYcHjSl290MvaIU6M1dYt27aEs2rTXk3yop59P2+eV2kAddC5qpMr
         EA35ZcE4nuTtW4UPjMa5jBrx4OjZqQESsf9n3sIJfCU58ltQcP38ql8lm7hhRJCWlbj4
         XQ9kfXWrBMFBvKSLX6C5zD+gQ56oNbFQO3PG6GvKwZHNoKDkGy+vcy+jpVuXm3Zq+ihT
         rS3U/2U3tWlGGui/KYvblo8JOK5zDAJEcXLXuemxYzqN8IkYzWzCEgpIKvWg7Lt5/nwG
         bRJDDAvYl/kDisWS+cVRuQJPlfIagvDujTshCXxJfF16UwtgSCSlJPAzZQLvi7QaXEkp
         b2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l4ymR3rP3ebjknnAHpxFsTgWKlyKO3VmlyIU0nWQg9M=;
        b=K7CX3BpCYtUZbAYdE+cHQXVf+w1ydsetaczHexUIRQ+Zz4SC3uoXpC+eARD7VyVxVs
         9UKRi+Htwq6NtziDnms0MfxSOAILsjdeIqlQH2/WQs3LwrrIUqTjlIb+V4tLvtTXJjKB
         lZoVD1eWvyYWc1QRcotcpfYRntu0kMwXgFuw9sxW2v01gTwHpHufnusHa+xArC03sZ/2
         fEiiBH7O5ioO25PvWvoY2fY8J6fZE7ivmfgr2BXAVTMHwxH9ddg68o8yEVaj5GdX/sg3
         kJxQJmoPbyOEbNOP7e/3AlHS9jQoFBGiHhVmwCInDe7QmrGtiS29SW/21jJbb2k9vQoZ
         Yrsg==
X-Gm-Message-State: AGi0PuarUKXICOVOdow3Tn1lKfTcDGhJP9wKnnlXuggVyepltpPOXDzz
        7MkY3Quoz7G6b1PVyMluV6hEFX0/
X-Google-Smtp-Source: APiQypKnZF+XANLa4RkZ2DTB7ARbXTKsAeMHSnGVQ3KGnYiGa3AxyjqRnVrS/GWscFtd03G09FcFMA==
X-Received: by 2002:a63:575f:: with SMTP id h31mr3847957pgm.200.1587148694441;
        Fri, 17 Apr 2020 11:38:14 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 135sm17728608pfx.58.2020.04.17.11.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 11:38:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Tao Ren <taoren@fb.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: broadcom: Add support for BCM53125 internal PHYs
Date:   Fri, 17 Apr 2020 11:38:02 -0700
Message-Id: <20200417183805.8702-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM53125 has internal Gigabit PHYs which support interrupts as well as
statistics, make it possible to configure both of those features with a
PHY driver entry.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 14 ++++++++++++++
 include/linux/brcmphy.h    |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index ae4873f2f86e..97201d5cf007 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -781,6 +781,19 @@ static struct phy_driver broadcom_drivers[] = {
 	.get_strings	= bcm_phy_get_strings,
 	.get_stats	= bcm53xx_phy_get_stats,
 	.probe		= bcm53xx_phy_probe,
+}, {
+	.phy_id		= PHY_ID_BCM53125,
+	.phy_id_mask	= 0xfffffff0,
+	.name		= "Broadcom BCM53125",
+	.flags		= PHY_IS_INTERNAL,
+	/* PHY_GBIT_FEATURES */
+	.get_sset_count	= bcm_phy_get_sset_count,
+	.get_strings	= bcm_phy_get_strings,
+	.get_stats	= bcm53xx_phy_get_stats,
+	.probe		= bcm53xx_phy_probe,
+	.config_init	= bcm54xx_config_init,
+	.ack_interrupt	= bcm_phy_ack_intr,
+	.config_intr	= bcm_phy_config_intr,
 }, {
 	.phy_id         = PHY_ID_BCM89610,
 	.phy_id_mask    = 0xfffffff0,
@@ -810,6 +823,7 @@ static struct mdio_device_id __maybe_unused broadcom_tbl[] = {
 	{ PHY_ID_BCMAC131, 0xfffffff0 },
 	{ PHY_ID_BCM5241, 0xfffffff0 },
 	{ PHY_ID_BCM5395, 0xfffffff0 },
+	{ PHY_ID_BCM53125, 0xfffffff0 },
 	{ PHY_ID_BCM89610, 0xfffffff0 },
 	{ }
 };
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 6462c5447872..7e1d857c8468 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -15,6 +15,7 @@
 #define PHY_ID_BCMAC131			0x0143bc70
 #define PHY_ID_BCM5481			0x0143bca0
 #define PHY_ID_BCM5395			0x0143bcf0
+#define PHY_ID_BCM53125			0x03625f20
 #define PHY_ID_BCM54810			0x03625d00
 #define PHY_ID_BCM5482			0x0143bcb0
 #define PHY_ID_BCM5411			0x00206070
-- 
2.19.1

