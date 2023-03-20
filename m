Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506616C23C5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjCTVfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCTVff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:35:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52E61C30E;
        Mon, 20 Mar 2023 14:35:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j13so13602111pjd.1;
        Mon, 20 Mar 2023 14:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679348103;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wxcmHlfAenV2U41coeShonsYsA39MjpAEzY31lGo8mY=;
        b=pZlSE0mjG9rsBJ1CyuI5jN5dpQHi1nX0XxG7ABXqL+BeO4qjKcGG/0iQ6RlafToWbt
         ztuHMibXwJVyFOiygNzxgxth0y+1s4ZgcF1Mz2TFAOrMkYwh8Tb/VAe4JXLf7Cw+gJXF
         NNFlLWuoYql56KzEfdQW4ZFrKSb5s4ZxxeuG2GZOwOyZWCzVHWUm2gR0tPx2MGXJSoap
         zaTnX6BnBGwH5eziMk8wTCToOGVQ+np2I7+j2O2D8v/u8e8RZQY4Mvd5wnz2hyDEl5AB
         xywZblSKB/frBFClIz5zmo6iOj3z6Yf73E47U5w6WLzYBcxH1Sl9HneSzqUCzmSM0l8S
         BgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679348103;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wxcmHlfAenV2U41coeShonsYsA39MjpAEzY31lGo8mY=;
        b=lqN0OqI39IgS/VlhvsJmWArG25YQaSY3yNCfz0ypW7Isk2dnjO9UB7T7jmQfbeWrte
         sYC072JQVlnpqTPESCJOu/96muRq65TdX0MW3N51u3Geh2KBNaS7AxA92mTKCxd8UTG6
         cUpkL4x0NDHbHDKvV/108wYmbne+V4AY6nDdkJ9/NbmpWvjjPBNxb1xurTvjeJoLq4KZ
         MeTtEglDIF/kzwEAuuurrfx51nBfHI3j1tjNC5yb7qgovgs/QH5d7OGbo1a1knmXEzR6
         zDmuVibDh53FBw5lZj1OAvdXLR4oIsnhwHk0lgtEr+JmXPEAUYNQrltCH9sSEmI5HvUH
         efxg==
X-Gm-Message-State: AO0yUKWvAmQ+BA8OYYOiUJfx83yc7482PJXzlpK83Oy3sIhmO96DI1j4
        2uJsntDBBJ2/SNE++Gr8NPGHt3TdzLw=
X-Google-Smtp-Source: AK7set9DwfMdviJ898W6mFizRhsl120BeKzmOjdleo7zjhlJfui5v/L5/gz8VbjlCgNt55ap41t7Ww==
X-Received: by 2002:a05:6a20:8c08:b0:da:717f:9539 with SMTP id j8-20020a056a208c0800b000da717f9539mr1624pzh.5.1679348103369;
        Mon, 20 Mar 2023 14:35:03 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6-20020aa78546000000b005cdc64a287dsm6802519pfn.115.2023.03.20.14.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 14:35:02 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: Improved phy_error() with function and error code
Date:   Mon, 20 Mar 2023 14:34:51 -0700
Message-Id: <20230320213451.2579608-1-f.fainelli@gmail.com>
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

When the PHY library calls phy_error() something bad has happened, and
we halt the PHY state machine. To facilitate debugging, introduce
phy_error_precise() which allows us to provide useful information about
the calling function and the error actually returned to facilitate
debugging.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy.c | 21 ++++++++++++++-------
 include/linux/phy.h   |  6 +++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b33e55a7364e..a84f7873700d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1170,17 +1170,20 @@ void phy_stop_machine(struct phy_device *phydev)
 }
 
 /**
- * phy_error - enter HALTED state for this PHY device
+ * phy_error_precise - enter HALTED state for this PHY device
  * @phydev: target phy_device struct
+ * @func: symbolic function name that returned the error
+ * @err: return code from the function that caused the error
  *
  * Moves the PHY to the HALTED state in response to a read
  * or write error, and tells the controller the link is down.
  * Must not be called from interrupt context, or while the
  * phydev->lock is held.
  */
-void phy_error(struct phy_device *phydev)
+void phy_error_precise(struct phy_device *phydev, const void *func,
+		       int err)
 {
-	WARN_ON(1);
+	WARN(1, "%pS: returned: %d\n", func, err);
 
 	mutex_lock(&phydev->lock);
 	phydev->state = PHY_HALTED;
@@ -1188,7 +1191,7 @@ void phy_error(struct phy_device *phydev)
 
 	phy_trigger_machine(phydev);
 }
-EXPORT_SYMBOL(phy_error);
+EXPORT_SYMBOL(phy_error_precise);
 
 /**
  * phy_disable_interrupts - Disable the PHY interrupts from the PHY side
@@ -1378,6 +1381,7 @@ void phy_state_machine(struct work_struct *work)
 	struct net_device *dev = phydev->attached_dev;
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
+	const void *func = NULL;
 	bool finished = false;
 	int err = 0;
 
@@ -1396,6 +1400,7 @@ void phy_state_machine(struct work_struct *work)
 	case PHY_NOLINK:
 	case PHY_RUNNING:
 		err = phy_check_link_status(phydev);
+		func = &phy_check_link_status;
 		break;
 	case PHY_CABLETEST:
 		err = phydev->drv->cable_test_get_status(phydev, &finished);
@@ -1425,16 +1430,18 @@ void phy_state_machine(struct work_struct *work)
 
 	mutex_unlock(&phydev->lock);
 
-	if (needs_aneg)
+	if (needs_aneg) {
 		err = phy_start_aneg(phydev);
-	else if (do_suspend)
+		func = &phy_start_aneg;
+	} else if (do_suspend) {
 		phy_suspend(phydev);
+	}
 
 	if (err == -ENODEV)
 		return;
 
 	if (err < 0)
-		phy_error(phydev);
+		phy_error_precise(phydev, func, err);
 
 	if (old_state != phydev->state) {
 		phydev_dbg(phydev, "PHY state change %s -> %s\n",
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fefd5091bc24..dc77b09908da 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1793,7 +1793,11 @@ void phy_drivers_unregister(struct phy_driver *drv, int n);
 int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
 int phy_drivers_register(struct phy_driver *new_driver, int n,
 			 struct module *owner);
-void phy_error(struct phy_device *phydev);
+void phy_error_precise(struct phy_device *phydev, const void *func, int err);
+static inline void phy_error(struct phy_device *phydev)
+{
+	phy_error_precise(phydev, (const void *)_RET_IP_, -EIO);
+}
 void phy_state_machine(struct work_struct *work);
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
 void phy_trigger_machine(struct phy_device *phydev);
-- 
2.34.1

