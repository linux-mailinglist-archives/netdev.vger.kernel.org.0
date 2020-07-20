Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D0122564F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgGTDuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgGTDuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:50:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E193C0619D2;
        Sun, 19 Jul 2020 20:50:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so9497035pjb.2;
        Sun, 19 Jul 2020 20:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lw+oOKOJaV4TI1IElc9yfOKZ42IGzfQCZ2yv/p89pIs=;
        b=kqt6EfIddKPhgkHCJ75/E0ksSXaRBk9W9LuhO5ld6rboN0fXtk5YeIROqlLh5lZejH
         c+dMDbaozVkBx34iXYxxVLkywYfB0Z+eVqgtYa5goaRxj07XpvOmU7e8aR+iJKo2HIL3
         eRGuDeYioNkZpDAnnQyah28HnrjCGU7ruMdVNDUQOOPjj59jGtXRC6ncVUxwEp/J8q48
         9ivocaV1APnAbO1ESppbmJbgWE5ev5Z+QOQZJXVLaIDSQqHei7YskA0XKQAu4wg5PDkH
         qi0ESS4VpwzlxewjdeDwnSzQjbEEFqiDrIxkMBshYYSH1yY73p5ozY9GYACSzLGiepS6
         OF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lw+oOKOJaV4TI1IElc9yfOKZ42IGzfQCZ2yv/p89pIs=;
        b=KR3XA0TaoGsYpvQVdW3fPj+rL4qkxWc6M8zDyWJPzRnS9524mH4vYCBAIwHwm0ibEm
         e3ZoC1xs/1vouXy3hT9yDdPhe3f292Sq1Oucm9WcmcpcNHOf2BMe1At9+y9mR0h5eQPr
         jFGCR9Zg5faOO3QryzlEz0yGoktQYZDqdDQi7umgYZMKiSm4Ve+T5pYoFMH95a7CkzjD
         aAla6+xjKb/TPnJ95N6ADW2OHb/yoevjaUDO5JdtCUm5U/YloWymJDCTsN+WL4unX/Uv
         s1FLGHnJZnuqojx/iySom6t8UgoDY7ghiVtiu+UU2ZcQS+d2lsbPADQIcpG9vCxNjar4
         NAFQ==
X-Gm-Message-State: AOAM532RdSOkrrFQbafVFgeTX1Cnh3Epmw/4jyrS06Bl2UyHPtqjk8QA
        helHQHyHjzJWKGKdd0x4GLHLudSm
X-Google-Smtp-Source: ABdhPJxgMYNcDrPDnhYzDqhIK1CoVh64KeziRGoXqkOyMCOQViACnZR1JZyIT56u7f37vniG29BHQA==
X-Received: by 2002:a17:90a:3769:: with SMTP id u96mr22310119pjb.198.1595217004362;
        Sun, 19 Jul 2020 20:50:04 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z11sm15183445pfj.104.2020.07.19.20.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 20:50:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list), olteanv@gmail.com
Subject: [PATCH net-next v2 2/4] net: dsa: Add wrappers for overloaded ndo_ops
Date:   Sun, 19 Jul 2020 20:49:52 -0700
Message-Id: <20200720034954.66895-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720034954.66895-1-f.fainelli@gmail.com>
References: <20200720034954.66895-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for the dsa_netdevice_ops structure which is a subset of
the net_device_ops structure for the specific operations that we care
about overlaying on top of the DSA CPU port net_device and provide
inline stubs that take core managing whether DSA code is reachable.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6fa418ff1175..343642ca4f63 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -86,6 +86,18 @@ struct dsa_device_ops {
 	enum dsa_tag_protocol proto;
 };
 
+/* This structure defines the control interfaces that are overlayed by the
+ * DSA layer on top of the DSA CPU/management net_device instance. This is
+ * used by the core net_device layer while calling various net_device_ops
+ * function pointers.
+ */
+struct dsa_netdevice_ops {
+	int (*ndo_do_ioctl)(struct net_device *dev, struct ifreq *ifr,
+			    int cmd);
+	int (*ndo_get_phys_port_name)(struct net_device *dev, char *name,
+				      size_t len);
+};
+
 #define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
 #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
@@ -217,6 +229,7 @@ struct dsa_port {
 	/*
 	 * Original copy of the master netdev net_device_ops
 	 */
+	const struct dsa_netdevice_ops *netdev_ops;
 	const struct net_device_ops *orig_ndo_ops;
 
 	bool setup;
@@ -679,6 +692,63 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 	return false;
 }
 
+#if IS_ENABLED(CONFIG_NET_DSA)
+static inline int __dsa_netdevice_ops_check(struct net_device *dev)
+{
+	int err = -EOPNOTSUPP;
+
+	if (!dev->dsa_ptr)
+		return err;
+
+	if (!dev->dsa_ptr->netdev_ops)
+		return err;
+
+	return 0;
+}
+
+static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
+				   int cmd)
+{
+	const struct dsa_netdevice_ops *ops;
+	int err;
+
+	err = __dsa_netdevice_ops_check(dev);
+	if (err)
+		return err;
+
+	ops = dev->dsa_ptr->netdev_ops;
+
+	return ops->ndo_do_ioctl(dev, ifr, cmd);
+}
+
+static inline int dsa_ndo_get_phys_port_name(struct net_device *dev,
+					     char *name, size_t len)
+{
+	const struct dsa_netdevice_ops *ops;
+	int err;
+
+	err = __dsa_netdevice_ops_check(dev);
+	if (err)
+		return err;
+
+	ops = dev->dsa_ptr->netdev_ops;
+
+	return ops->ndo_get_phys_port_name(dev, name, len);
+}
+#else
+static inline int dsa_ndo_do_ioctl(struct net_device *dev, struct ifreq *ifr,
+				   int cmd)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int dsa_ndo_get_phys_port_name(struct net_device *dev,
+					     char *name, size_t len)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
-- 
2.25.1

