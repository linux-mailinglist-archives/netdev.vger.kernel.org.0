Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6221D8ABD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgERWYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbgERWYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:24:31 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B50C061A0C;
        Mon, 18 May 2020 15:24:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so469614pjh.2;
        Mon, 18 May 2020 15:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SUpX7LOtT8qVPRv32tcbyWPkW2QMH3nqgiPbBsuq44A=;
        b=UZl73Uph8yOVkais49jw+Nq2D5YvYYGWrD6uIFWyo6GBl24/D004NdRse5eWjizF1J
         QDb6ey3Uw5n+I7iwaMwiUeYv+Qau+6DPCFXBBgJpRUzBqR1wKp7x9vFfjtdBRDS3b2QO
         0JaAPXd67uf2z61kcOfDe3nrR/XIKncFhl6jMaiTtbA1HtS0vNrYxXt6ok1tYO3xvT6a
         JqAUJCSSRP52eDxDc9YdKWlTksMA5p+9v8/mwZWwKQQN67kJm5vnXhUZ9VFRwzFAFem7
         dDSqGaQ4W6Z/sWOsb5Y+rw3JWWUSx/V/GiLwUpJ3Pi8MLCZhiAPmO+DbNJUVO2qf5k8m
         KxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SUpX7LOtT8qVPRv32tcbyWPkW2QMH3nqgiPbBsuq44A=;
        b=caE+fGyA8PLsrjgY2Qsa1yzOPe+K4ULc7xv95pAO2YnPMwcHgHqb0zzM9FFIVPK1fZ
         3Uhyg3A7qJuq6rMKZ78ZiU1qztAoJNWlFPMA1qCkRpULfxONJ6AjB77cz3oQERV/ZQ/J
         7WEtPN5Vu3C027rP4WZZUsp+Gu4Q3F0xIWWd2B982Xg0tVZv6JVhSROPRYCRzHzXDUxP
         fK5L1Yw2F1DMVN4JJWy1wfiSE5B2doLqXg5aAWQfKbhqinB/Pnq4S/1sdl+E3i2sNtFG
         vJaQFomPIurqopBCecSSMd1eufia48GX8btZC05CS0PcstgGGaFVUJPaKJ1sD5lBc7Y9
         2KYQ==
X-Gm-Message-State: AOAM532d6TQ04nepl+iUpwG5c8zWF2JqtIMCmq4Z4sI0WVuHOq638AeI
        GNogyGgt1wmE3s28Bpniu2kTscWR
X-Google-Smtp-Source: ABdhPJxhBEouMty1ELdMK3bBnrYPG7USEfr3XojqI61IcwORmFGbsKWhVedHwUNjAjMOMgLC4thIcQ==
X-Received: by 2002:a17:90b:888:: with SMTP id bj8mr1684834pjb.148.1589840669382;
        Mon, 18 May 2020 15:24:29 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w73sm9583175pfd.113.2020.05.18.15.24.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 15:24:28 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next] net: phy: simplify phy_link_change arguments
Date:   Mon, 18 May 2020 15:23:59 -0700
Message-Id: <1589840639-34074-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function was introduced to allow for different handling of
link up and link down events particularly with regard to the
netif_carrier. The third argument do_carrier allowed the flag to
be left unchanged.

Since then the phylink has introduced an implementation that
completely ignores the third parameter since it never wants to
change the flag and the phylib always sets the third parameter
to true so the flag is always changed.

Therefore the third argument (i.e. do_carrier) is no longer
necessary and can be removed. This also means that the phylib
phy_link_down() function no longer needs its second argument.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/phy/phy.c        | 12 ++++++------
 drivers/net/phy/phy_device.c | 12 +++++-------
 drivers/net/phy/phylink.c    |  3 +--
 include/linux/phy.h          |  2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d4bbf79dab6c..d584701187db 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -58,13 +58,13 @@ static const char *phy_state_to_str(enum phy_state st)
 
 static void phy_link_up(struct phy_device *phydev)
 {
-	phydev->phy_link_change(phydev, true, true);
+	phydev->phy_link_change(phydev, true);
 	phy_led_trigger_change_speed(phydev);
 }
 
-static void phy_link_down(struct phy_device *phydev, bool do_carrier)
+static void phy_link_down(struct phy_device *phydev)
 {
-	phydev->phy_link_change(phydev, false, do_carrier);
+	phydev->phy_link_change(phydev, false);
 	phy_led_trigger_change_speed(phydev);
 }
 
@@ -524,7 +524,7 @@ int phy_start_cable_test(struct phy_device *phydev,
 		goto out;
 
 	/* Mark the carrier down until the test is complete */
-	phy_link_down(phydev, true);
+	phy_link_down(phydev);
 
 	netif_testing_on(dev);
 	err = phydev->drv->cable_test_start(phydev);
@@ -595,7 +595,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
 		phydev->state = PHY_NOLINK;
-		phy_link_down(phydev, true);
+		phy_link_down(phydev);
 	}
 
 	return 0;
@@ -999,7 +999,7 @@ void phy_state_machine(struct work_struct *work)
 	case PHY_HALTED:
 		if (phydev->link) {
 			phydev->link = 0;
-			phy_link_down(phydev, true);
+			phy_link_down(phydev);
 		}
 		do_suspend = true;
 		break;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c3a107cf578e..7481135d27ab 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -916,16 +916,14 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 }
 EXPORT_SYMBOL(phy_find_first);
 
-static void phy_link_change(struct phy_device *phydev, bool up, bool do_carrier)
+static void phy_link_change(struct phy_device *phydev, bool up)
 {
 	struct net_device *netdev = phydev->attached_dev;
 
-	if (do_carrier) {
-		if (up)
-			netif_carrier_on(netdev);
-		else
-			netif_carrier_off(netdev);
-	}
+	if (up)
+		netif_carrier_on(netdev);
+	else
+		netif_carrier_off(netdev);
 	phydev->adjust_link(netdev);
 	if (phydev->mii_ts && phydev->mii_ts->link_state)
 		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0f23bec431c1..b6b1f77bba58 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -803,8 +803,7 @@ void phylink_destroy(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_destroy);
 
-static void phylink_phy_change(struct phy_device *phydev, bool up,
-			       bool do_carrier)
+static void phylink_phy_change(struct phy_device *phydev, bool up)
 {
 	struct phylink *pl = phydev->phylink;
 	bool tx_pause, rx_pause;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5d8ff5428010..467aa8bf9f64 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -543,7 +543,7 @@ struct phy_device {
 	u8 mdix;
 	u8 mdix_ctrl;
 
-	void (*phy_link_change)(struct phy_device *, bool up, bool do_carrier);
+	void (*phy_link_change)(struct phy_device *phydev, bool up);
 	void (*adjust_link)(struct net_device *dev);
 
 #if IS_ENABLED(CONFIG_MACSEC)
-- 
2.7.4

