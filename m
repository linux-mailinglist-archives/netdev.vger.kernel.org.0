Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C8D66CE10
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjAPRxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbjAPRwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:52:45 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF053B65E
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:06 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id s22so30684180ljp.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBUWzvDNamFGOC4iHjWn4zwEVY2qfQxl959ozP5DmYU=;
        b=U8jkVa+yYUfb1cCQseahksgWBpJukt1b1CaGFB+iPybFlVBjpECij+I2ZT4ata0oK0
         kden32bhaDCCV4Ys+ariMdMSE72FyHU0IEYhws6Opat0vHBpv6NKEsiD/qI6mBsbwzxH
         xvrFiaCNHxPAZwsIlLTynN5pIZSKI0sWGJpTfj8pkM70sTZyXkndUy9JSkKfx0+LUu8z
         kc77vOo7mHxmgYrLnzVNM3+LOivOjEQ/QvRewiHQfXQrMOK1a+2iXuFUstPp5L1iChbx
         mOj9XY2URHfAwUdP9gloI3NqSSwb1dkVKGUJCiPaIt/HiVdwXy+7g3rI/ohGj0L6eQ5c
         0gxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RBUWzvDNamFGOC4iHjWn4zwEVY2qfQxl959ozP5DmYU=;
        b=N7+OYM7Z+ko8hy2u/PwwsE8q1qB8HZSUmUTzZQjWUmFe/+b89uGx9bS+XaF2aBdR72
         hJOMSGATjpexqjwQszHxdhksqunN+oDxX9Zzf65qfcNYFJqYY5f4aDLjIGzv7Mq/jUgA
         F8rhlrIYz6YFXmDULslJjIwS/D3JbPp5SGAoesbJhM44Fkzu1psbYhuCkYro4UrPPZ3d
         174zBu7GztuGHt6HIaEudZwYT4O3UlaVv3WavpNmx/IrWdBs56J+Nhhud7BlbQO3tDQV
         MjVpPKY7HpEbxU7Khvf4ff47u3jg/izb/dLbKdxqYI/uP6dqUuSEX6hKxErcSZyUMB95
         wNoQ==
X-Gm-Message-State: AFqh2kpvMAzW1kpWtKJvWK/i0hfzBZjtLWiOXio3f8wGRYculCPnWVwA
        Bbit50haMxm2hrIij1mJERnUBw==
X-Google-Smtp-Source: AMrXdXtXXluHetGVDb9ihfasqH/ZvEunGrnR+uMrcj5mIztAAZ+L/N9e9JpuKfcIdjjKClxsIUUAbQ==
X-Received: by 2002:a2e:960b:0:b0:286:6412:7060 with SMTP id v11-20020a2e960b000000b0028664127060mr185195ljh.15.1673890505233;
        Mon, 16 Jan 2023 09:35:05 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id k20-20020a2e8894000000b0028b7f51414fsm707333lji.80.2023.01.16.09.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:35:04 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, mw@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: [net-next: PATCH v4 6/8] net: core: switch to fwnode_find_net_device_by_node()
Date:   Mon, 16 Jan 2023 18:34:18 +0100
Message-Id: <20230116173420.1278704-7-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20230116173420.1278704-1-mw@semihalf.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper function which allows getting the struct net_device pointer
associated with a given device tree node can be more generic and
also support alternative hardware description. Switch to fwnode_
and update the only existing caller (in the DSA subsystem).
For that purpose use newly added fwnode_find_parent_dev_match routine.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/etherdevice.h |  1 +
 include/linux/of_net.h      |  6 -----
 net/core/net-sysfs.c        | 25 ++++++--------------
 net/dsa/dsa.c               |  5 ++--
 4 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index a541f0c4f146..3d475ee4a2d7 100644
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
index d88715a0b3a5..8a677f44c270 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -16,7 +16,6 @@ extern int of_get_phy_mode(struct device_node *np, phy_interface_t *interface);
 extern int of_get_mac_address(struct device_node *np, u8 *mac);
 extern int of_get_mac_address_nvmem(struct device_node *np, u8 *mac);
 int of_get_ethdev_address(struct device_node *np, struct net_device *dev);
-extern struct net_device *of_find_net_device_by_node(struct device_node *np);
 #else
 static inline int of_get_phy_mode(struct device_node *np,
 				  phy_interface_t *interface)
@@ -38,11 +37,6 @@ static inline int of_get_ethdev_address(struct device_node *np, struct net_devic
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
index ca55dd747d6c..652ba785e6f7 100644
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
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index d1ca3bb03858..55f22a58556b 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -9,6 +9,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -374,7 +375,7 @@ struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst)
 	if (IS_ERR(ethernet))
 		return NULL;
 
-	master = of_find_net_device_by_node(to_of_node(ethernet));
+	master = fwnode_find_net_device_by_node(ethernet);
 	fwnode_handle_put(ethernet);
 
 	return master;
@@ -1233,7 +1234,7 @@ static int dsa_port_parse_fw(struct dsa_port *dp, struct fwnode_handle *fwnode)
 		struct net_device *master;
 		const char *user_protocol;
 
-		master = of_find_net_device_by_node(to_of_node(ethernet));
+		master = fwnode_find_net_device_by_node(ethernet);
 		fwnode_handle_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
-- 
2.29.0

