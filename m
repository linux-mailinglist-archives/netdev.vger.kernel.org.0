Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26CF6BDA2F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCPUde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCPUdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:33:32 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C581BCE;
        Thu, 16 Mar 2023 13:33:31 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id x8so2080781qvr.9;
        Thu, 16 Mar 2023 13:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678998810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rM0EAkK+6/Z7xETwhsA2NYPRZsQ9EnkWbH0Y0cmhj50=;
        b=OQ/yAxQERJtglA2+oDVP5HgxwZiVdnUZAgC+ys7kij/zZB/h9lnq/YQMu7PfXkE2EX
         LHubJRFtweOJV6Nqkbj96XtRbuebQrj0qpw/HIBc/0+r4SBZilqUR9mPXTtY1fnuABSl
         7nD+VFhznjVEJydC9JRX8xJ/9d3HGEO7MyR1t7hVa6MeEVbwrRpWb4jIlRL7MFArAk5I
         QqfgRnoejWjeY4mAaYIhkF6C4vKa0fd5Th/9PxFzHrftuuUjgZv5GGidxNA5g7zjb18p
         dP2+XKP7Wq1p2EnT1uPLFEgFx0oRcraVtxQW/sLbBepPV8AwlLpx+pcrCt/KihjdKCgh
         WtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678998810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rM0EAkK+6/Z7xETwhsA2NYPRZsQ9EnkWbH0Y0cmhj50=;
        b=mpt67nn2lFS7stamUw00bBTVnxbIA1ZIsPz3RXPpeXpwCDtipshJ43NnSE3pVP2H9l
         fThNF/uy3cBQ+69NJ8pd6LybfPHVOClScSEeQl0xQ274UKtsiRK3QBNz0/La1j8ZyNk8
         3Nz2BeNFCk5KcU8fNPnILrNpBrx6eKW1MzUopJe0lKy44bxxehnOh8Hvccpzc0JcmA/T
         lmFtJActv3Jpmi4m8m2nKqqKBI4jV9y/MtnWJZ9O4R1LKoB2JaTmqjVQgLn95BwZ2+XJ
         AwwMwDFQjTif9xaVOdg3OF5aToVn/4snS2tYa8Cikdj8rKAVkNn7OrXWiudzBfvPrN1v
         81rA==
X-Gm-Message-State: AO0yUKUPzY8HM0mbgTgcyDuUa8BntMBCs/+gvb9WYyggu2HfFu9zbm/n
        tn68bKOP+OitOlEKAep+ASPqumfkQiw=
X-Google-Smtp-Source: AK7set/q0VZYyLLg+NnyxMmqB8F03eFq6ljiqK/LUe98yJurxina7rciWpouU0yVLt7CxCJrithvJA==
X-Received: by 2002:ad4:5fce:0:b0:579:5dbc:ab8b with SMTP id jq14-20020ad45fce000000b005795dbcab8bmr34418941qvb.52.1678998809801;
        Thu, 16 Mar 2023 13:33:29 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m124-20020a375882000000b0073b8745fd39sm213514qkb.110.2023.03.16.13.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 13:33:29 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: Ensure state transitions are processed from phy_stop()
Date:   Thu, 16 Mar 2023 13:33:24 -0700
Message-Id: <20230316203325.2026217-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the phy_disconnect() -> phy_stop() path, we will be forcibly setting
the PHY state machine to PHY_HALTED. This invalidates the old_state !=
phydev->state condition in phy_state_machine() such that we will neither
display the state change for debugging, nor will we invoke the
link_change_notify() callback.

Factor the code by introducing phy_process_state_change(), and ensure
that we process the state change from phy_stop() as well.

Fixes: 5c5f626bcace ("net: phy: improve handling link_change_notify callback")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b33e55a7364e..99a07eb54c44 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -57,6 +57,18 @@ static const char *phy_state_to_str(enum phy_state st)
 	return NULL;
 }
 
+static void phy_process_state_change(struct phy_device *phydev,
+				     enum phy_state old_state)
+{
+	if (old_state != phydev->state) {
+		phydev_dbg(phydev, "PHY state change %s -> %s\n",
+			   phy_state_to_str(old_state),
+			   phy_state_to_str(phydev->state));
+		if (phydev->drv && phydev->drv->link_change_notify)
+			phydev->drv->link_change_notify(phydev);
+	}
+}
+
 static void phy_link_up(struct phy_device *phydev)
 {
 	phydev->phy_link_change(phydev, true);
@@ -1301,6 +1313,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
 void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
+	enum phy_state old_state;
 
 	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
@@ -1309,6 +1322,7 @@ void phy_stop(struct phy_device *phydev)
 	}
 
 	mutex_lock(&phydev->lock);
+	old_state = phydev->state;
 
 	if (phydev->state == PHY_CABLETEST) {
 		phy_abort_cable_test(phydev);
@@ -1319,6 +1333,7 @@ void phy_stop(struct phy_device *phydev)
 		sfp_upstream_stop(phydev->sfp_bus);
 
 	phydev->state = PHY_HALTED;
+	phy_process_state_change(phydev, old_state);
 
 	mutex_unlock(&phydev->lock);
 
@@ -1436,13 +1451,7 @@ void phy_state_machine(struct work_struct *work)
 	if (err < 0)
 		phy_error(phydev);
 
-	if (old_state != phydev->state) {
-		phydev_dbg(phydev, "PHY state change %s -> %s\n",
-			   phy_state_to_str(old_state),
-			   phy_state_to_str(phydev->state));
-		if (phydev->drv && phydev->drv->link_change_notify)
-			phydev->drv->link_change_notify(phydev);
-	}
+	phy_process_state_change(phydev, old_state);
 
 	/* Only re-schedule a PHY state machine change if we are polling the
 	 * PHY, if PHY_MAC_INTERRUPT is set, then we will be moving
-- 
2.34.1

