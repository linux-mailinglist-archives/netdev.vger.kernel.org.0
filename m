Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A507A2EBE4B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbhAFNLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbhAFNLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:11:12 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56013C06135A
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:10:22 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id cw27so4335536edb.5
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w1CahSqZ79T9ixPYxdCW61xuCByHKb2pPQgznyLxH+0=;
        b=cVt3zChfK7Vh5I+f85sBlMiQ4MhS/QZnVxi4nFcOYEFE5FnMLdjYSkxA3hcFuKp0He
         gmg6ZJDZO/Ip+Nc4f5it/mbmiUiBMJ1uxoKRJqtaLdUuye+D/Hj7GNaYFjGOQLzrm9tw
         kUDvUQM1ecmpMQJnTmZRvM1sLtgDOau6iK6p+HBzJEiw/MbTfZ7BaU2qJ4G+tFsFBeDL
         Obvt/EkOj7cgwZFuP+/0/6SR4cieonfriFtBNnb0HyQo41DNgEJGeHB54AISXyE26qVy
         qI9/vOHsPVyon6BlTCpqsZAVCQb9qT1VV45tdkHsZSu/+R0cGRoJhtU2FRMjxfdhALjP
         zPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w1CahSqZ79T9ixPYxdCW61xuCByHKb2pPQgznyLxH+0=;
        b=L3+iv/JDJeRZmirnSLQUMDAlw3gwKzCT8EVc48d597T/s4pNpKTNUajVKB1lZKy/sf
         uWGoWrwZs6dHtYZuhE3k6ReisbxC3j6zxM7PyiQZIBg76gjpITEaw4+P+sVpdXq1g05L
         0AfO3tkGTBk0V5//gGtQIiUFw7sua3mT3IHvSJJhM5AGVFeKNo9pIIWtC1tVCqwn9c1S
         qyzMDqz4PWmgPYf+GogmXAXB69hJLplVKGZ8nXZ+4jeiFYls7yfI0vARR5bsdXv06xzE
         rySI356RoTRx9fQGMUNTGCbdZFVvwVMIzkduDQr9OyPvzQXcQJYhGBK/z83FlGxFO/N+
         ZL8Q==
X-Gm-Message-State: AOAM531qcxLX/drjk+6z78T8NwJ7LwYwBuzZTcyUYkjss8j4fuW/lKKw
        o7TpkfUA8fL8MKBXOUMG1wU=
X-Google-Smtp-Source: ABdhPJygNTlG9VzHtmaEJbV1UlesMvrGBEYB2NF8quc40Z+uZ2V/MWkPtW5eU0mIPKJm7vM5q7X3cA==
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr3886675edb.225.1609938621117;
        Wed, 06 Jan 2021 05:10:21 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm1241858ejx.59.2021.01.06.05.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:10:20 -0800 (PST)
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
Subject: [PATCH v2 net-next 03/10] net: switchdev: delete switchdev_port_obj_add_now
Date:   Wed,  6 Jan 2021 15:09:59 +0200
Message-Id: <20210106131006.577312-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106131006.577312-1-olteanv@gmail.com>
References: <20210106131006.577312-1-olteanv@gmail.com>
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
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
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

