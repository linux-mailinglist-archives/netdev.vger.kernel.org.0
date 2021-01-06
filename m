Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268ED2EC6BC
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbhAFXS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbhAFXSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:18:55 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF38FC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:17:53 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ce23so7273523ejb.8
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EI1wC9Xkqmpzjm/YrEjem0fZLb6nFmO7JkSvvcJ589s=;
        b=WIU1X/MNDdWK9IreQuDVOm9p6tii8JTaRYi+MZ9gibK73q4Ho2F7gdKVd6Lxv4+/TE
         YvQsrIVZYGhSA6Ft+eeQPU0GwR+mh38hOMLaArMbZ1ZRaMYNKAC1Jldgn8jj1IyLICr6
         uYVczxBSkqFSRpNZj92MCFMEqsgEwfdzj6+E5tZdJ5c3aG6lOF8/e3Ap2VTlfWxF3WU2
         QzvF8D5SQU4lOZuxSZS9SB41iADOinWWdHgofRXRFSkqyHq3m/utGu02f8R97h2bkJPY
         JRLTFADr3mKDKrzw84GimKF9gzxnQ6i8m9ZU0UuS3uHJx10pnUDCDEw2RrSfXSRAdrk/
         1z1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EI1wC9Xkqmpzjm/YrEjem0fZLb6nFmO7JkSvvcJ589s=;
        b=RxtJa5r1zRb1ThfeZSlrHQEFUZSnKtLW2V1AXYoZAtcSMQPO+cyoQCMvfJyr4DbGqv
         GxfYE2UhWgixu+muEOW9OEWh2HrZRkL/xks9kczOZ6spdSytQ9Ri//+HUXJwFUJ8NpBi
         4AcNYLqly0JsWifnFJxQMTPFqugAGoYN9ZRafonmXKd1BvKEzdcsyNmJlNfQAwY3z+qB
         WLfkSPtMympxebC+plpoZyaCrGOELXx9d9Kd3Cddvn4d8gV3I1PF+A3lljX8DZSrOQNK
         Pys295+uLBCflvPF/LMjC+x00jAANAmuGSX6ZUw/8pKOVPgSzvEN5KhONNPpFwbZfvxY
         IOPQ==
X-Gm-Message-State: AOAM533KXe5baWxvBoU8v37dGhugfWsEqzPeE6OX/P01iXIj/Pu+1cWf
        AarOmc6oiFRT+ZYFRuGeDtI=
X-Google-Smtp-Source: ABdhPJxqChjizXmHX17T2+IE7H4WTLyBiv8cBGJ68hJbx+x1aX1ug/5eZDpwt2Jx9Iyj7FBVi/ovYQ==
X-Received: by 2002:a17:906:7146:: with SMTP id z6mr4337237ejj.379.1609975072510;
        Wed, 06 Jan 2021 15:17:52 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:17:52 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 04/11] net: switchdev: delete switchdev_port_obj_add_now
Date:   Thu,  7 Jan 2021 01:17:21 +0200
Message-Id: <20210106231728.1363126-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After the removal of the transactional model inside
switchdev_port_obj_add_now, it has no added value and we can just call
switchdev_port_obj_notify directly, bypassing this function. Let's
delete it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/switchdev/switchdev.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index a575bb33ee6c..3509d362056d 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -242,23 +242,15 @@ static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 	return 0;
 }
 
-static int switchdev_port_obj_add_now(struct net_device *dev,
-				      const struct switchdev_obj *obj,
-				      struct netlink_ext_ack *extack)
-{
-	ASSERT_RTNL();
-
-	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					 dev, obj, extack);
-}
-
 static void switchdev_port_obj_add_deferred(struct net_device *dev,
 					    const void *data)
 {
 	const struct switchdev_obj *obj = data;
 	int err;
 
-	err = switchdev_port_obj_add_now(dev, obj, NULL);
+	ASSERT_RTNL();
+	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
+					dev, obj, NULL);
 	if (err && err != -EOPNOTSUPP)
 		netdev_err(dev, "failed (err=%d) to add object (id=%d)\n",
 			   err, obj->id);
@@ -290,7 +282,8 @@ int switchdev_port_obj_add(struct net_device *dev,
 	if (obj->flags & SWITCHDEV_F_DEFER)
 		return switchdev_port_obj_add_defer(dev, obj);
 	ASSERT_RTNL();
-	return switchdev_port_obj_add_now(dev, obj, extack);
+	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
+					 dev, obj, extack);
 }
 EXPORT_SYMBOL_GPL(switchdev_port_obj_add);
 
-- 
2.25.1

