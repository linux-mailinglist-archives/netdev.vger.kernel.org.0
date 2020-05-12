Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7F41CE99C
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgELAYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728300AbgELAYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:24:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE82C061A0C;
        Mon, 11 May 2020 17:24:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d22so5332968pgk.3;
        Mon, 11 May 2020 17:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q1TTeTKlhnttO6k3fBa4KDCJqO3Jun9k/dqcX8QhlFY=;
        b=h8XalJfwHQ7HZUkXe3iBQO/n7SFz1H1vOohKtw+cv30hzDS3nncjlGiO+YXltkjIb+
         PdL7hCob3cx88JPjqOkV2rmfrp8gIndnUYLS+QPsfJxmJqae25BmqhAeiGA0v8hSDj14
         tvwwqiHrHOatrLPgxN9h3s8s0e7YYdK7fKolPwXtiyAxoVl/Oe1m2aIem3gzRHkXcozq
         YKMeJ3IXZI+EEj8w+h4PU3htccGno7HM5PUHzNBAd1pkn1d49XxKHaiwnVaHmBm9f2q8
         fxQz4QLVGnsPMZfdy+0TJ2x0BnmhGgeN5DSirZwpXbBykk5kxMDb9pBAjJlo+RDqBgIe
         kmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q1TTeTKlhnttO6k3fBa4KDCJqO3Jun9k/dqcX8QhlFY=;
        b=YXxmPSZKxNZW9PQvMGzd/6w7TsgZEr2a9Pi3Td/vr8IwGazT4mgj9hA/xb1F12gPR7
         XZek5UrPK5bgtjupUIFW97HLZqMojcAB3ZJJZ4AeKIxv5P+VN1Axz9b7Ru/wJdofqqQZ
         MWyA3szeNda8DM7ONZiZFg3y6X0hxv45G1N9hXyNcrf2qbLO2WEw/EGiu+WjOEfAGH3s
         qt9iOoJpxQDv4lm7aQ2ZI9uyzzuVlbTqBtbYqNhNPP+waygMbfZaQTYY13BZB27N58nr
         aAYUmSyE50eOJCjpU3W7WRoXi4BCu7SV37yMjxwhaLaL+zP7wVSxzZKnVvVkB6wfVQ9H
         Ia1A==
X-Gm-Message-State: AGi0PuZEq2Lon1YbODMx2Z2Uiu1UUW1r2xksvDy2ZJnYgLLHX9dBUhO0
        ZeLUNf9TKQdnfHbzCz8PVfU=
X-Google-Smtp-Source: APiQypLsYv0JqBt0Rw1BEGsILGIkNZePZR8RtpvyxdyEk8DMKu2d2ZjLg7fiW9TSSRkJL7mbJTdFSg==
X-Received: by 2002:a62:1789:: with SMTP id 131mr19086699pfx.287.1589243085718;
        Mon, 11 May 2020 17:24:45 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm9062112pgm.18.2020.05.11.17.24.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:24:45 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 3/4] net: ethernet: introduce phy_set_pause
Date:   Mon, 11 May 2020 17:24:09 -0700
Message-Id: <1589243050-18217-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces the phy_set_pause function to the phylib as
a helper to support the set_pauseparam ethtool method.

It is hoped that the new behavior introduced by this function will
be widely embraced and the phy_set_sym_pause and phy_set_asym_pause
functions can be deprecated. Those functions are retained for all
existing users and for any desenting opinions on my interpretation
of the functionality.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/phy/phy_device.c | 31 +++++++++++++++++++++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 48ab9efa0166..e6dafb3c3e5f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2614,6 +2614,37 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
 EXPORT_SYMBOL(phy_set_asym_pause);
 
 /**
+ * phy_set_pause - Configure Pause and Asym Pause with autoneg
+ * @phydev: target phy_device struct
+ * @rx: Receiver Pause is supported
+ * @tx: Transmit Pause is supported
+ * @autoneg: Auto neg should be used
+ *
+ * Description: Configure advertised Pause support depending on if
+ * receiver pause and pause auto neg is supported. Generally called
+ * from the set_pauseparam ethtool_ops.
+ *
+ * Note: Since pause is really a MAC level function it should be
+ * notified via adjust_link to update its pause functions.
+ */
+void phy_set_pause(struct phy_device *phydev, bool rx, bool tx, bool autoneg)
+{
+	linkmode_set_pause(phydev->advertising, tx, rx, autoneg);
+
+	/* Reset the state of an already running link to force a new
+	 * link up event when advertising doesn't change or when PHY
+	 * autoneg is disabled.
+	 */
+	mutex_lock(&phydev->lock);
+	if (phydev->state == PHY_RUNNING)
+		phydev->state = PHY_UP;
+	mutex_unlock(&phydev->lock);
+
+	phy_start_aneg(phydev);
+}
+EXPORT_SYMBOL(phy_set_pause);
+
+/**
  * phy_validate_pause - Test if the PHY/MAC support the pause configuration
  * @phydev: phy_device struct
  * @pp: requested pause configuration
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5d8ff5428010..71e484424e68 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1403,6 +1403,7 @@ void phy_support_asym_pause(struct phy_device *phydev);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 		       bool autoneg);
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
+void phy_set_pause(struct phy_device *phydev, bool rx, bool tx, bool autoneg);
 bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp);
 void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
-- 
2.7.4

