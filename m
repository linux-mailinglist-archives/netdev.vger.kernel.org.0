Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D1224837
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 05:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgGRDFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 23:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRDFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 23:05:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150BDC0619D2;
        Fri, 17 Jul 2020 20:05:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ls15so7346602pjb.1;
        Fri, 17 Jul 2020 20:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W20ytYA3X/k7rmwSz93Mvopa1eYrBMJqygg51JZZkkM=;
        b=eaOjvQYYSV4X5A4iQRH/J2gq9tXMSCxuyLPa7JrRUT4AIgzM2+K6SZJTrEJK1ehoWm
         fYc0EybySRMaSbjWsyE8Wh8gikZGJ4ZeNoSIxTiJzOAiW8Nhdb4yBHWdTbkMHHLrWBcr
         Dk1Fch+9NZIq4UpwoVjBb1vDqzimitjO6f6LYEMyabrRvZd7AdYVEO/8kXQUOoWsdbtA
         Vqe3wGDLRzvOyBWVy9l/wlVmhBdv44QJId4zM3hu3uhhCX/vm9YbrknRSEyfL/foSqv0
         LGhLaS0Q3k3+npt16S93E2kigDvq7zp9iNNP6LGkBIaThXbRuMci7Q7u6IYHMhmqAzlj
         ae8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W20ytYA3X/k7rmwSz93Mvopa1eYrBMJqygg51JZZkkM=;
        b=jjOCNoeCvdhSR6noQXlrasH7AcYixcuCmQiXMTQf8bh1jXPKx8XcDBzkluWrit35Mj
         VpzLkw00E1dS3hBfikFcmuOGom33gUDLxPTUAw1XZ2x6C93wM4lqFcEbXzTLljPfEE75
         gFQLPih10YODxBiY81+hRbV6JHiVwmU22RPaegH1u162/TBw2PyXQdCuB0FUk5djF03S
         UIKGda/desQBVtgnmkznLuk/AC/5PJpDZPIWk3s4svYhcOLQmOPgALBUaykhAUI/tVIM
         s2k1GTRrfiW2w9NoJ9YYmu1/ydn+H44+yO2BKIZz3XPiQZak8yMLVgXZHGVRo6s1WKNa
         G9jg==
X-Gm-Message-State: AOAM530Tjvwh2zAT/Dnsx8XZvbzogFegMRhDJHwKY76g6GwXGdIkRIZf
        dwbnc7cE62o38InAXmjrQpeN9Vc5
X-Google-Smtp-Source: ABdhPJwwuDIvsFbj9d2rF7m4bZ9DvYfGFDbyRDDv3SH1Xsi378gV983IiFpU6eJ4B8IHIhxh8DDttQ==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr9802481plf.191.1595041547190;
        Fri, 17 Jul 2020 20:05:47 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c9sm617331pjr.35.2020.07.17.20.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 20:05:46 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/4] net: dsa: Add wrappers for overloaded ndo_ops
Date:   Fri, 17 Jul 2020 20:05:31 -0700
Message-Id: <20200718030533.171556-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200718030533.171556-1-f.fainelli@gmail.com>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
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
 include/net/dsa.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6fa418ff1175..681ba2752514 100644
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
@@ -679,6 +692,34 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 	return false;
 }
 
+#if IS_ENABLED(CONFIG_NET_DSA)
+#define dsa_build_ndo_op(name, arg1_type, arg1_name, arg2_type, arg2_name) \
+static int inline dsa_##name(struct net_device *dev, arg1_type arg1_name, \
+			     arg2_type arg2_name)	\
+{							\
+	const struct dsa_netdevice_ops *ops;		\
+	int err = -EOPNOTSUPP;				\
+							\
+	if (!dev->dsa_ptr)				\
+		return err;				\
+							\
+	ops = dev->dsa_ptr->netdev_ops;			\
+	if (!ops || !ops->name)				\
+		return err;				\
+							\
+	return ops->name(dev, arg1_name, arg2_name);	\
+}
+#else
+#define dsa_build_ndo_op(name, ...)			\
+static inline int dsa_##name(struct net_device *dev, ...) \
+{							\
+	return -EOPNOTSUPP;				\
+}
+#endif
+
+dsa_build_ndo_op(ndo_do_ioctl, struct ifreq *, ifr, int, cmd);
+dsa_build_ndo_op(ndo_get_phys_port_name, char *, name, size_t, len);
+
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
-- 
2.25.1

