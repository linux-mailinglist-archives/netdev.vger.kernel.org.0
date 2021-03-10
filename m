Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56989334733
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhCJSxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbhCJSwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 13:52:30 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478CDC061760;
        Wed, 10 Mar 2021 10:52:30 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t29so12603281pfg.11;
        Wed, 10 Mar 2021 10:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4YgXo58fsodWY8tVLTSwbceSR+eDpGyOkcHxaohODI=;
        b=fjUeoiq4Y8MmY6pgSelBOCkJcqPMN9ezCduROyqUWvgCFUpDyM/8ZCs9M3YkGOaBSj
         qfoRF7QEJW9fKXn7vkkpAmpCxxMtOW/bAnx1UutYX1DuYOv2cK9HKLmtnIPWCAWSpdt2
         xa9Bn70UFJEfoklbgDw6Vu1RjMQVwT43O0dOm0VpWDto48LA1tlLIf5OaAQemVImOwUQ
         yqQzNtX/Jht9xlQblQ7wBhDKnkhvxzsF36myRWsqGFpMn1W5qdBZEZSiIy39INczyLMd
         iWsFCMCHfSVik2JEC8km7bITNNe6DQwVFD/x7Rtrbaul6it20FXIBy98xAHl3OVIGapL
         b1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4YgXo58fsodWY8tVLTSwbceSR+eDpGyOkcHxaohODI=;
        b=mzX3fdQg+Cqr0A68JM3yyZAi01CmbTQm+gliAz9uB7CM2DWqI7oO3P1HZ3kWD4Ri+7
         eI/JuUMeWR0Ej+I1+8r+oexahCOdUT+SAarmmw5BH5bm02dnZ3P9OFU5oZgCsM99ZV8P
         mPJJPb6DnscBXYoctIKErAO4iPBWarl5UrR/omhZLxcOzVOAkWZ0RmECRwwRwOmCHg55
         puUZzFg3T1gwHP3Fk4ByskY3XxRcQqPidwqy7H7Zi6Rc905osTNQi7y74Re1yBe8h50L
         Pdv9ctkavtVbMaWFEvHoVRexXocZt4c1B7uR+/8eVHJZpgX61USSZm6HdhS83sxqO/yE
         UrwA==
X-Gm-Message-State: AOAM530ra7XaZOCpMN6J2fWSXtHEVxeOYchSp4MAxUYRnAmCWFhJiWpC
        X7uC+p0070Y8IvJx1jcnRV2li0UVdqk=
X-Google-Smtp-Source: ABdhPJwnBKtvdjeC0kNlFIqmnIemBXZqmUH4/foXLjlOve1bh7fz81mJH2FY45NbNfpzTHeU9+7DTQ==
X-Received: by 2002:a63:7885:: with SMTP id t127mr3836844pgc.237.1615402349384;
        Wed, 10 Mar 2021 10:52:29 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b140sm243040pfb.98.2021.03.10.10.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 10:52:28 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: b53: Add debug prints in b53_vlan_enable()
Date:   Wed, 10 Mar 2021 10:52:26 -0800
Message-Id: <20210310185227.2685058-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having dynamic debug prints in b53_vlan_enable() has been helpful to
uncover a recent but update the function to indicate the port being
configured (or -1 for initial setup) and include the global VLAN enabled
and VLAN filtering enable status.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a162499bcafc..9bd51c2a51d2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -349,7 +349,7 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 	b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
 }
 
-static void b53_enable_vlan(struct b53_device *dev, bool enable,
+static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 			    bool enable_filtering)
 {
 	u8 mgmt, vc0, vc1, vc4 = 0, vc5;
@@ -431,6 +431,9 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, mgmt);
 
 	dev->vlan_enabled = enable;
+
+	dev_dbg(dev->dev, "Port %d VLAN enabled: %d, filtering: %d\n",
+		port, enable, enable_filtering);
 }
 
 static int b53_set_jumbo(struct b53_device *dev, bool enable, bool allow_10_100)
@@ -743,7 +746,7 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_do_vlan_op(dev, VTA_CMD_CLEAR);
 	}
 
-	b53_enable_vlan(dev, dev->vlan_enabled, ds->vlan_filtering);
+	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
 
 	b53_for_each_port(dev, i)
 		b53_write16(dev, B53_VLAN_PAGE,
@@ -1429,7 +1432,7 @@ int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 {
 	struct b53_device *dev = ds->priv;
 
-	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
+	b53_enable_vlan(dev, port, dev->vlan_enabled, vlan_filtering);
 
 	return 0;
 }
@@ -1454,7 +1457,7 @@ static int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	if (vlan->vid >= dev->num_vlans)
 		return -ERANGE;
 
-	b53_enable_vlan(dev, true, ds->vlan_filtering);
+	b53_enable_vlan(dev, port, true, ds->vlan_filtering);
 
 	return 0;
 }
-- 
2.25.1

