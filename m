Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E55D5BBA3D
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiIQUSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 16:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIQUST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 16:18:19 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D1A2ED44;
        Sat, 17 Sep 2022 13:18:18 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id h28so18150612qka.0;
        Sat, 17 Sep 2022 13:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=W7xcUTJ+Xi3/2c+HEMlnIJrwY7Px5v+GX+wSId5EDcY=;
        b=MWAjhl+xoCtoaOvlX5qq05l39uxVSoxvIlUaU55ko4WaCeYDNkn0oncD0EiX46yoQt
         ccbjdN3leY+2tL2T1iPG0AqZri5cOUHdEloinZbEdwtjquCkGvhnn6olCwK9n6KsuZc9
         PfzXa7Z7yvrCO3hT97TvsXKKFkl9MwxaWwpfFP3ODGWKl7nlHsnh2OpBrCQw7O6inAho
         8Bl/kbDWxvu9mez4VtcPkke48/0Chbnh/gzTRZtox9jwpEeuNfWbOc7DWXTxRSsLtBVz
         hgpo8sQOTKAOI+JTFU9jiRXpul6ILHO7TxsHOtmbdgSRAf0vEleLgFrP1p2S301/TlZV
         QoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=W7xcUTJ+Xi3/2c+HEMlnIJrwY7Px5v+GX+wSId5EDcY=;
        b=wat/1XZnmMB8jB0nzHLFiRgl24KkLCia6XqtMsXCHxyRfJmhIFAbPRHr06bxp6sA+m
         QNsS1Fn6GLCt44e9LnTzKqgWEpkikKFZlEtJsbTKrgnb4KTYX2Zi08x3FcWP4Euu/Evw
         4/CqLXxJodszqN7OqjEZdfgie7CC4ypayDi65plCTTXwg05VRw065sYF/SxtzPF9G1+L
         lus+7aybSdjsiLpILtrjyxhDbqKnCFG/TOKtOepeMGfY7tm4/a5zLgpqMH2kKfdvwQ5L
         A+ePE9PyNbLQtqWF4tI7NzvW/gPzjJuZZOgi0zT3uY7BI0oYjLMUo2YmJf5asKwqc08M
         U1yQ==
X-Gm-Message-State: ACrzQf3dsQh/oGFDT8s1iWUXeD4AecKax4XXJ0VmV5nDmdMmRBe3WATb
        qZtm+vGmApyG/r1j/eEnCLo=
X-Google-Smtp-Source: AMsMyM6iUxZzKpNhK/xvKNJBH21tgFbn0d8acYZSQ3UJuauQl/86HAVdFvqViqcHMOKe4c6+4ROcrA==
X-Received: by 2002:a05:620a:2681:b0:6b5:b60c:1e66 with SMTP id c1-20020a05620a268100b006b5b60c1e66mr8303008qkp.99.1663445897521;
        Sat, 17 Sep 2022 13:18:17 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id s21-20020a05620a0bd500b006bb7ccf6855sm10374577qki.76.2022.09.17.13.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 13:18:17 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, aroulin@nvidia.com,
        sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 4/5] net: bridge: handle link-type-specific changes in the bridge module
Date:   Sat, 17 Sep 2022 16:18:00 -0400
Message-Id: <8ef43d44ebdebe90783325cb68edb70a7c80c038.1663445339.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a handler to bridge module for handling vlan-specific
events.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
---
 net/bridge/br.c         |  5 +++++
 net/bridge/br_private.h |  7 +++++++
 net/bridge/br_vlan.c    | 18 ++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 96e91d69a9a8..62e939c6a3f0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -51,6 +51,11 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 		}
 	}
 
+	if (is_vlan_dev(dev)) {
+		br_vlan_device_event(dev, event, ptr);
+		return NOTIFY_DONE;
+	}
+
 	/* not a port of a bridge */
 	p = br_port_get_rtnl(dev);
 	if (!p)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..a9a08e49c76c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1470,6 +1470,8 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 void br_vlan_port_event(struct net_bridge_port *p, unsigned long event);
 int br_vlan_bridge_event(struct net_device *dev, unsigned long event,
 			 void *ptr);
+void br_vlan_device_event(struct net_device *dev, unsigned long event,
+ 			  void *ptr);
 void br_vlan_rtnl_init(void);
 void br_vlan_rtnl_uninit(void);
 void br_vlan_notify(const struct net_bridge *br,
@@ -1701,6 +1703,11 @@ static inline int br_vlan_bridge_event(struct net_device *dev,
 	return 0;
 }
 
+static void br_vlan_device_event(struct net_device *dev,
+				 unsigned long event, void *ptr)
+{
+}
+
 static inline void br_vlan_rtnl_init(void)
 {
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc991409..ba4e3c7a5f03 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/notifier_info.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <net/switchdev.h>
@@ -1768,6 +1769,23 @@ void br_vlan_port_event(struct net_bridge_port *p, unsigned long event)
 	}
 }
 
+void br_vlan_device_event(struct net_device *dev,
+			  unsigned long event, void *ptr)
+{
+	struct netdev_notifier_change_details_info *details;
+	struct net_device *br_dev;
+
+	switch (event) {
+	case NETDEV_CHANGE_DETAILS:
+		details = ptr;
+		if (!netif_is_bridge_master(vlan_dev_priv(dev)->real_dev))
+			break;
+		br_dev = vlan_dev_priv(dev)->real_dev;
+		br_vlan_upper_change(br_dev, dev, details->vlan.bridge_binding);
+		break;
+	}
+}
+
 static bool br_vlan_stats_fill(struct sk_buff *skb,
 			       const struct net_bridge_vlan *v)
 {
-- 
2.34.1

