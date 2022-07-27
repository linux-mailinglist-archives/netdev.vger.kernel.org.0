Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD71582051
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiG0Goo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiG0GoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:44:11 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0E41994
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:49 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p10so18232884lfd.9
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9YzF/moGV0ykdIvPXLa6CisfKYdf2yrfdtDijEUJPuI=;
        b=kZw2qp1fqzn/11TXztXmeboNZn+S/94NltYlqBuJzWhuN6PSawQ6kygf2qfhUEuxOn
         jZ39zJQCcC/KfT0/sLA8dxxzyKDDuSnxT3E4ycdOqRPKrBd+wPVSjvD4FpJ/UaYtUzfN
         jyD1IG61jopdRT5jfxqPJFi+zGSv0t8R0IH/YKCfNn4rGlagjYqJ9mtEHvAX/qHRAvmG
         LvLYTYAnJRZrviGu+JwpmjH+EQkZeBlKqEayJcfGMIg/A8DlRizFnt1BrvC+x5JaNsh/
         bkS+08klYM8jOOCQfUQbi98cIG3foD7iYgmWNOQXVSU0N7NmuPFTDHsvCniJAETgzTcA
         89Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9YzF/moGV0ykdIvPXLa6CisfKYdf2yrfdtDijEUJPuI=;
        b=SNfjqXeWd2U1es4GCvlTWimx25u3prYSgqP5TkTABloXsub2oAPDHkqc5UpcYggBXJ
         lunuiX2XyuEm/edKfGCKJXa9b4J3duKudidmr7hAzOXNP+zKn5LdmedB/X2WNBKQOs01
         smDqTqtBsNCSW9W1efYY3MjtQk/ktKOP6ijR5OKqScO2xe6D+sNkpjtc5BEBRD/CF3R1
         jUupet7fefPG0C2U3B2uXozYfjEl6a34u2wSyUl0wzut6RvtxuqpBHzBZq4VpKJCLVEw
         sQplYP6SBe9d57V11wlo2VJRZp3GIZ3h41Lb5jLfKv6UXpQnpRgbnj9fugMbAl0j05Xg
         fGTA==
X-Gm-Message-State: AJIora/zLEGSj+BZ0j/eCNRDBr2DlIeF5iDQ/zoFBMLH9RV5LBAP6Fdn
        Iw3dOHHNKxLq8YkQZGqxCdnp2A==
X-Google-Smtp-Source: AGRyM1tTz/84Id/kCPHS/5up9fpPurIKbeeCVAo2XxHNrBTI9XHmL66WhjTosvTu54j7SvnhOBkQeg==
X-Received: by 2002:a05:6512:39c8:b0:48a:7816:1f7f with SMTP id k8-20020a05651239c800b0048a78161f7fmr7251843lfu.571.1658904227638;
        Tue, 26 Jul 2022 23:43:47 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:47 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
Date:   Wed, 27 Jul 2022 08:43:19 +0200
Message-Id: <20220727064321.2953971-7-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220727064321.2953971-1-mw@semihalf.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper function which allows getting the struct net_device pointer
associated with a given device tree node can be more generic and
also support alternative hardware description. Switch to fwnode_
and update the only existing caller in DSA subsystem.
For that purpose use newly added fwnode_dev_node_match helper routine.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/etherdevice.h |  1 +
 include/linux/of_net.h      |  6 -----
 net/core/net-sysfs.c        | 25 ++++++--------------
 net/dsa/dsa2.c              |  3 ++-
 4 files changed, 10 insertions(+), 25 deletions(-)

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
index d61afd21aab5..fc972545aaea 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
@@ -1935,38 +1936,26 @@ static struct class net_class __ro_after_init = {
 	.get_ownership = net_get_ownership,
 };
 
-#ifdef CONFIG_OF
-static int of_dev_node_match(struct device *dev, const void *data)
-{
-	for (; dev; dev = dev->parent) {
-		if (dev->of_node == data)
-			return 1;
-	}
-
-	return 0;
-}
-
 /*
- * of_find_net_device_by_node - lookup the net device for the device node
- * @np: OF device node
+ * fwnode_find_net_device_by_node - lookup the net device for the device fwnode
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
+	dev = class_find_device(&net_class, NULL, fwnode, fwnode_find_parent_dev_match);
 	if (!dev)
 		return NULL;
 
 	return to_net_dev(dev);
 }
-EXPORT_SYMBOL(of_find_net_device_by_node);
-#endif
+EXPORT_SYMBOL(fwnode_find_net_device_by_node);
 
 /* Delete sysfs entries but hold kobject reference until after all
  * netdev references are gone.
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 82fb3b009fb4..bba416eba9c2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/etherdevice.h>
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
@@ -1498,7 +1499,7 @@ static int dsa_port_parse_fw(struct dsa_port *dp, struct fwnode_handle *fwnode)
 		struct net_device *master;
 		const char *user_protocol;
 
-		master = of_find_net_device_by_node(to_of_node(ethernet));
+		master = fwnode_find_net_device_by_node(ethernet);
 		fwnode_handle_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
-- 
2.29.0

