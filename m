Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76055204F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiFTPMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243179AbiFTPMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:12 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01613E7E
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:52 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id b7so12237167ljr.6
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t4fm7chK+9HP+V4kfjA7VXym1QH3FPQZTxUsVRysYlI=;
        b=GC02YJZFg88R2E6b7Wy1WLcpX7Ar2kvhBGaz/xonS8B5DjkgBc2uwF6qOcPbPkBIE/
         6bpk0yfhSgNWi0ygLzCSnaJ7KOh7HuFYVvqdVbQwX709iQGr3ro2PElbJC54njuEgtCu
         i2tupv/SHrxy3o9t875X8LbtPxLNGfUJqy+/ff9966/cFdEJcXB2F9v+M/mfH+exNX3N
         mRPMTu1qSpRGj8giJ9pmfaoSugiOKJw6BDvp/9XU5DF/uGpxrNtmrmaFr1c7kzxAxN4e
         davPWJ20AqSd9nu1kiPF/smDxl4EwtiozhanuxLeF9Gu4RLy7p6ta4DePU//03kyur8v
         nGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t4fm7chK+9HP+V4kfjA7VXym1QH3FPQZTxUsVRysYlI=;
        b=51DXCXoEjBJs4edtve0yVnatIzACpM1F9l8zbHXV4wGdpj8T6hhilmxotIbXzE1QNU
         V/nmkvI00HMDhdKJxu0hAn/ISa2tDx1EtVo9ncQ1Zu7gY5BEVDWzkUMJ67K2A8qprp+d
         6t89Ld9KQsFgDRnoYMMfdVOr6gGw/1Evl8lyU8F4I09VULdjm/u6gwFhnUhvEZVyPACI
         Kk5ZaQCY7It/RkMNhEV1eqimM3XmyX+RgwoWxk2JlIm5dY8p2ES34nKJPMOcVJw8gEeR
         a8E6sblcZNHbR9P2BtZPawQubAHPsNJi574SXW8OLjYRvCTD4YwrDdCXHJZhbbuq8dDn
         4n+A==
X-Gm-Message-State: AJIora+zHT/TTROu+pMWSYBw0a1+zQg0wFjcn9MGMopUv+EID0Mv9CCz
        twMSpyjqUcaWi0+yVrGw4/VEaA==
X-Google-Smtp-Source: AGRyM1uYOZ02rYHZJgaSORea5LGhaa+Fo4kElEGhfJGAzyML5aZG9cH/D2CN0E16ZUk+OzgFKnWGqg==
X-Received: by 2002:a05:651c:244:b0:255:32c8:dd42 with SMTP id x4-20020a05651c024400b0025532c8dd42mr11790566ljn.101.1655737370158;
        Mon, 20 Jun 2022 08:02:50 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:49 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 05/12] net: core: switch to fwnode_find_net_device_by_node()
Date:   Mon, 20 Jun 2022 17:02:18 +0200
Message-Id: <20220620150225.1307946-6-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper function which allows getting the struct net_device pointer
associated with a given device tree node can be more generic and
also support alternative hardware description. Switch to fwnode_
and update the only existing caller in DSA subsystem.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/etherdevice.h |  1 +
 include/linux/of_net.h      |  6 ------
 net/core/net-sysfs.c        | 18 ++++++++----------
 net/dsa/dsa2.c              |  3 ++-
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 92b10e67d5f8..a335775af244 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -35,6 +35,7 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf);
 int device_get_mac_address(struct device *dev, char *addr);
 int device_get_ethdev_address(struct device *dev, struct net_device *netdev);
 int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr);
+struct net_device *fwnode_find_net_device_by_node(struct fwnode_handle *fwnode);
 
 u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 len);
 __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 0484b613ca64..f672f831292d 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -15,7 +15,6 @@ struct net_device;
 extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern int of_get_mac_address(struct device_node *np, u8 *mac);
 int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
-extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
 static inline int of_get_phy_mode(struct device_node *np,
 				  phy_interface_t *interface)
@@ -32,11 +31,6 @@ static inline int of_get_ethdev_address(struct device_node *np, struct net_devic
 {
 	return -ENODEV;
 }
-
-static inline struct net_device *of_find_net_device_by_node(struct device_node *np)
-{
-	return NULL;
-}
 #endif
 
 #endif /* __LINUX_OF_NET_H */
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index d49fc974e630..837f67f1f3a4 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
@@ -1934,11 +1935,10 @@ static struct class net_class __ro_after_init = {
 	.get_ownership = net_get_ownership,
 };
 
-#ifdef CONFIG_OF
-static int of_dev_node_match(struct device *dev, const void *data)
+static int fwnode_dev_node_match(struct device *dev, const void *data)
 {
 	for (; dev; dev = dev->parent) {
-		if (dev->of_node == data)
+		if (dev->fwnode == data)
 			return 1;
 	}
 
@@ -1946,26 +1946,24 @@ static int of_dev_node_match(struct device *dev, const void *data)
 }
 
 /*
- * of_find_net_device_by_node - lookup the net device for the device node
- * @np: OF device node
+ * fwnode_find_net_device_by_node - lookup the net device for the device node
+ * @fwnode: firmware node
  *
- * Looks up the net_device structure corresponding with the device node.
+ * Looks up the net_device structure corresponding with the fwnode.
  * If successful, returns a pointer to the net_device with the embedded
  * struct device refcount incremented by one, or NULL on failure. The
  * refcount must be dropped when done with the net_device.
  */
-struct net_device *of_find_net_device_by_node(struct device_node *np)
+struct net_device *fwnode_find_net_device_by_node(struct fwnode_handle *fwnode)
 {
 	struct device *dev;
 
-	dev = class_find_device(&net_class, NULL, np, of_dev_node_match);
+	dev = class_find_device(&net_class, NULL, fwnode, fwnode_dev_node_match);
 	if (!dev)
 		return NULL;
 
 	return to_net_dev(dev);
 }
-EXPORT_SYMBOL(of_find_net_device_by_node);
-#endif
 
 /* Delete sysfs entries but hold kobject reference until after all
  * netdev references are gone.
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 039022bf914b..5e11d66f9057 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/etherdevice.h>
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
@@ -1500,7 +1501,7 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct fwnode_handle *fwnode)
 		struct net_device *master;
 		const char *user_protocol;
 
-		master = of_find_net_device_by_node(to_of_node(ethernet));
+		master = fwnode_find_net_device_by_node(ethernet);
 		fwnode_handle_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
-- 
2.29.0

