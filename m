Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133BE6C7286
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjCWVqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCWVqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:46:07 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5416AE4;
        Thu, 23 Mar 2023 14:46:06 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id t13so504702qvn.2;
        Thu, 23 Mar 2023 14:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679607964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zxSH+iJCp59mbNx4VuE10L0ZYm9bSYlFTX0WmblXlYQ=;
        b=DLqoqDICQ9GOuotVlBUh31SIpQy9oP5vA7KCSZsRljF+MtadphfaFfWZX86wpFvxTj
         4qV2asoVGoXg58MqXK+luDWoPjzFojG+AAUnoX5zZDWrAo8gS3awoTohiVfHw0fPerIQ
         FnxIskPkKt5KXZiFGAgUO+pQylPQa3/pN3VQ/fHTNmGe8mjW5fIX7lpJMjoQyAc20LuR
         VoY1LFd1QPKM+FwS6/QtplgT94RcxBf9sljA6BqQTylPiZRTZEWNZVJZzpRZtMnwX2en
         GUBS32mj1v8+IIeSNEItqsFwFCB9slOixX1HQ3MfpiwK37KKSppppwq5CG2p2AfNCXSv
         NG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679607964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zxSH+iJCp59mbNx4VuE10L0ZYm9bSYlFTX0WmblXlYQ=;
        b=OOV/W0QraEIiWZvVryqnrc8tLUSG9d7TKrUAZVKvXa9tV1N/UXgiHWgnUBJxZF5v8H
         7NbnLahbHW6221mUj9LW+WYY2S0y7iHs8dH8HEztRM1bbCkiuDjh5l7UG967xodYUpWd
         bGWk2I6POrjfKIHiWy1690epC8HFsADhHCJnbeSvNHxMQP/OPvc2EwRo+M6zC/XJF4c0
         PWqT3HjdKn2d/p8XvKhM4HZTD6OZYxjTo9sAOpO1n/+hSn0NQgK5deyySU7X8CLScq1S
         jyRuJFhlEp52tuy2++XDsViXdd5M2GnbiMLdZU+aZdcd1K4bbKtPHhAsHcIHSIz0ueuJ
         S8kg==
X-Gm-Message-State: AAQBX9fZKM2lUA1JYByPEJWM6L0oBeY9nqGXQNiiDsIzFGqzzbJ9KW83
        3/WffNM0s7y8LTzzs7fCPVvC8sag/JE=
X-Google-Smtp-Source: AKy350aJUKTlm48O2hDeiMLRV0uQ3YByml5TvkHGDYoACfYx/phl5YJbt/UUKpcR/efF+fDmD8SfzQ==
X-Received: by 2002:a05:6214:cc6:b0:5b6:fbc5:fb4f with SMTP id 6-20020a0562140cc600b005b6fbc5fb4fmr1007776qvx.3.1679607964536;
        Thu, 23 Mar 2023 14:46:04 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020a0cf9c9000000b005dd8b9345desm176779qvo.118.2023.03.23.14.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 14:46:04 -0700 (PDT)
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
Subject: [PATCH net-next v2] net: phy: Improved PHY error reporting in state machine
Date:   Thu, 23 Mar 2023 14:45:59 -0700
Message-Id: <20230323214559.3249977-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the PHY library calls phy_error() something bad has happened, and
we halt the PHY state machine. Calling phy_error() from the main state
machine however is not precise enough to know whether the issue is
reading the link status or starting auto-negotiation.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- only call phy_error_precise() in phy_state_machine

 drivers/net/phy/phy.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b33e55a7364e..bcaf58636199 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1169,6 +1169,22 @@ void phy_stop_machine(struct phy_device *phydev)
 	mutex_unlock(&phydev->lock);
 }
 
+static void phy_process_error(struct phy_device *phydev)
+{
+	mutex_lock(&phydev->lock);
+	phydev->state = PHY_HALTED;
+	mutex_unlock(&phydev->lock);
+
+	phy_trigger_machine(phydev);
+}
+
+static void phy_error_precise(struct phy_device *phydev,
+			      const void *func, int err)
+{
+	WARN(1, "%pS: returned: %d\n", func, err);
+	phy_process_error(phydev);
+}
+
 /**
  * phy_error - enter HALTED state for this PHY device
  * @phydev: target phy_device struct
@@ -1181,12 +1197,7 @@ void phy_stop_machine(struct phy_device *phydev)
 void phy_error(struct phy_device *phydev)
 {
 	WARN_ON(1);
-
-	mutex_lock(&phydev->lock);
-	phydev->state = PHY_HALTED;
-	mutex_unlock(&phydev->lock);
-
-	phy_trigger_machine(phydev);
+	phy_process_error(phydev);
 }
 EXPORT_SYMBOL(phy_error);
 
@@ -1378,6 +1389,7 @@ void phy_state_machine(struct work_struct *work)
 	struct net_device *dev = phydev->attached_dev;
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
+	const void *func = NULL;
 	bool finished = false;
 	int err = 0;
 
@@ -1396,6 +1408,7 @@ void phy_state_machine(struct work_struct *work)
 	case PHY_NOLINK:
 	case PHY_RUNNING:
 		err = phy_check_link_status(phydev);
+		func = &phy_check_link_status;
 		break;
 	case PHY_CABLETEST:
 		err = phydev->drv->cable_test_get_status(phydev, &finished);
@@ -1425,16 +1438,18 @@ void phy_state_machine(struct work_struct *work)
 
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
-- 
2.34.1

