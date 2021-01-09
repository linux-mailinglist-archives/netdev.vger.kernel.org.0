Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0312EFBF6
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAIAC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAIAC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:02:58 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF7FC0613CF
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:18 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id w1so16686269ejf.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bLjepiV/KQcXR1wVYk7VqLA3Gpev3YDcHbC37fcUGKM=;
        b=eVqGETkaclpPYYo9DUNTDf6xEWgODr47VJ1gqnWjTr53wH6PAKAoKkRzOn6Qbe+WUq
         3EccYIy8WhnwsMljBbNFCkAv04SQHuMP9N9KNvp1mM8vtHOFZNtv98/PFjmFEUoxUC79
         q6Y+jShspZhOEdgxqqXFWFmnH1XFBP3ZaMhNKJfD1NttssnZkq6sEtuiKU/0AzKBeWFJ
         wAXbAs6yobJuNvrZUDNrB+7SffUo6DgTaKSS+TOm8On4l4wdMS4LEb2NL/HcgnYRi3O/
         GhR5mzFVFpzXLHFb4ipnYy0JVOiXrN1I+TLxtZarfzlAWvvFw38+csjg8UGHDSceF19L
         tsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bLjepiV/KQcXR1wVYk7VqLA3Gpev3YDcHbC37fcUGKM=;
        b=hYezPn86ORc0Skc9oZWuok7BUtNC9gFVVvSxXaV4mZg2i8sc9kdoWjPY9TMVADWcub
         7b5W0Wen3gm+TGxtoK6C/M6hsGtEPd/lqcoluSp581qTnPDXV0uXwFPtyDDk45Tmv/bS
         Gi3iezxlQUWYgBcovylaiQ5rLlNiHGyFdmebTAe7w/XnPVIT5vvKkDu9tInw6TkLgQtL
         elq8dwsiiD79l/gjdDYTlx9tzAwSpj6o9PoVwYQ7WlqtKjayKiLFC4nnTSZHGgv6nk/A
         7899iu5XFD5pD7IRwfb+/22xGbi71LPZQmp8dKTdYIRASEQLSxqZuGkH+yNUgKEUXfbT
         fsvg==
X-Gm-Message-State: AOAM532AuyeNejkQu6qelx+92PjGa9EDr5dONvlJos8yCHwsDDMzzvBQ
        j3DygrCrS73Vna+sj4cdcXA=
X-Google-Smtp-Source: ABdhPJwHOgpaUXl1L5TFdMlpoyjF+kzezZFO0Eh0/jX0mNyylLAXyEm4eLu4dFBqkcduUL1AjWf13Q==
X-Received: by 2002:a17:906:605:: with SMTP id s5mr4293192ejb.280.1610150537156;
        Fri, 08 Jan 2021 16:02:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:16 -0800 (PST)
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
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 04/11] net: switchdev: delete switchdev_port_obj_add_now
Date:   Sat,  9 Jan 2021 02:01:49 +0200
Message-Id: <20210109000156.1246735-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
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
Changes in v4:
None.

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

