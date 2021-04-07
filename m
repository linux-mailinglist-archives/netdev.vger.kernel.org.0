Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F135643C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 08:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349013AbhDGGna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 02:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhDGGna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 02:43:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56ABC061756
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 23:43:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nh5so7031464pjb.5
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 23:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WEn9QVphw8RK8g5EKw0fb5Yg1WrOpjdfFOTL3+k1LMA=;
        b=ETxrQ/ACNaZ7H4S8o7GeKmK/jJ9aPEtFLfQEhMWRjwRPKDnMABVgiEIGAF/h+Z4piP
         lJAbkdmHPL4LCoijgRBFKMO2Tg7amPlPgXw7mDw6Mj8cBb4ITkPYaiVGGPzikXixLF93
         Kt2N0xTEzqWi/HN4s6Zhrk+1X306hwH1RXysr7vU8k2Ldnx5drB0yRcBzIqINvQV9LXZ
         +7h0icVgykwSs4dc10LfRDNKdmwaD2lw88nFw3w/PaVaxrodHdl5e5JsNagwogDloe87
         CQC/wYgnrwxn+HZayvfFWf5SrsbwVODgvjtlkBQYtZlMdKKgp2MXIDJRsOcDk6t8wUGM
         oWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WEn9QVphw8RK8g5EKw0fb5Yg1WrOpjdfFOTL3+k1LMA=;
        b=meJkGh/H3LU62h/uo/wJ9XJRE40CQ7xAPs+vJIouX5+V/GjWSdFTop5Hfr2YYAHJj+
         BX1+HZGsLPqBJ9b23tfPo8eBRNrLtlkqgILUpFLWfRS9w4Dy4DANqII22X6tmDT34Y/3
         pdSgYkUFctBVSEsQOu5riZFyX8dIgCCFGIwStQT7tFZRp48quTXaXwaSi6Tm3WDsUCE1
         f2WuEtk+MUA94MigS5r3R5PtK/iXzKdUKzDCoEqbAzhmgxV/r+dhO2TQORoryuqnd2Lm
         plwDG5OFZk7zGJ3OHlDP3tTgemTpshZoWiZWFTZuVG/h9DD0Q+gbvkBWJ8QMyVkMJWPR
         Jh0g==
X-Gm-Message-State: AOAM532SLKZnoikJvQSjn+aUA+a6ncmv906y8SOkneCbGbTnMf0ERKd1
        LIN1/1RqBRemmxuM4xdVkg0=
X-Google-Smtp-Source: ABdhPJzCx3ZpR9IP4drymN/+eyTCpDJG026iU+3iUPhiohg8ZJnfRjXl/FBCWriKiZn3YzqOhQjQWA==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr1920323pjb.18.1617777799265;
        Tue, 06 Apr 2021 23:43:19 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id c2sm20581024pfb.121.2021.04.06.23.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 23:43:18 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrei Vagin <avagin@gmail.com>
Subject: [PATCH net-next] net: remove the new_ifindex argument from dev_change_net_namespace
Date:   Tue,  6 Apr 2021 23:40:51 -0700
Message-Id: <20210407064051.248174-1-avagin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is only one place where we want to specify new_ifindex. In all
other cases, callers pass 0 as new_ifindex. It looks reasonable to add a
low-level function with new_ifindex and to convert
dev_change_net_namespace to a static inline wrapper.

Fixes: eeb85a14ee34 ("net: Allow to specify ifindex when device is moved to another namespace")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 drivers/net/hyperv/netvsc_drv.c |  2 +-
 include/linux/netdevice.h       |  8 +++++++-
 net/core/dev.c                  | 10 +++++-----
 net/core/rtnetlink.c            |  4 ++--
 net/ieee802154/core.c           |  4 ++--
 net/wireless/core.c             |  4 ++--
 6 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8c0c70e1da77..7349a70af083 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2354,7 +2354,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	 */
 	if (!net_eq(dev_net(ndev), dev_net(vf_netdev))) {
 		ret = dev_change_net_namespace(vf_netdev,
-					       dev_net(ndev), "eth%d", 0);
+					       dev_net(ndev), "eth%d");
 		if (ret)
 			netdev_err(vf_netdev,
 				   "could not move to same namespace as %s: %d\n",
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b482236c0e99..5cbc950b34df 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4026,8 +4026,14 @@ void __dev_notify_flags(struct net_device *, unsigned int old_flags,
 int dev_change_name(struct net_device *, const char *);
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
+int __dev_change_net_namespace(struct net_device *dev, struct net *net,
+			       const char *pat, int new_ifindex);
+static inline
 int dev_change_net_namespace(struct net_device *dev, struct net *net,
-			     const char *pat, int new_ifindex);
+			     const char *pat)
+{
+	return __dev_change_net_namespace(dev, net, pat, 0);
+}
 int __dev_set_mtu(struct net_device *, int);
 int dev_validate_mtu(struct net_device *dev, int mtu,
 		     struct netlink_ext_ack *extack);
diff --git a/net/core/dev.c b/net/core/dev.c
index 9d1a8fac793f..33ff4a944109 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11062,7 +11062,7 @@ void unregister_netdev(struct net_device *dev)
 EXPORT_SYMBOL(unregister_netdev);
 
 /**
- *	dev_change_net_namespace - move device to different nethost namespace
+ *	__dev_change_net_namespace - move device to different nethost namespace
  *	@dev: device
  *	@net: network namespace
  *	@pat: If not NULL name pattern to try if the current device name
@@ -11077,8 +11077,8 @@ EXPORT_SYMBOL(unregister_netdev);
  *	Callers must hold the rtnl semaphore.
  */
 
-int dev_change_net_namespace(struct net_device *dev, struct net *net,
-			     const char *pat, int new_ifindex)
+int __dev_change_net_namespace(struct net_device *dev, struct net *net,
+			       const char *pat, int new_ifindex)
 {
 	struct net *net_old = dev_net(dev);
 	int err, new_nsid;
@@ -11202,7 +11202,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net,
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(dev_change_net_namespace);
+EXPORT_SYMBOL_GPL(__dev_change_net_namespace);
 
 static int dev_cpu_dead(unsigned int oldcpu)
 {
@@ -11458,7 +11458,7 @@ static void __net_exit default_device_exit(struct net *net)
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
 		if (__dev_get_by_name(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
-		err = dev_change_net_namespace(dev, &init_net, fb_name, 0);
+		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",
 				 __func__, dev->name, err);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9108a7e6c0c0..9f1f55785a6f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2619,7 +2619,7 @@ static int do_setlink(const struct sk_buff *skb,
 		else
 			new_ifindex = 0;
 
-		err = dev_change_net_namespace(dev, net, ifname, new_ifindex);
+		err = __dev_change_net_namespace(dev, net, ifname, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
@@ -3461,7 +3461,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto out_unregister;
 	if (link_net) {
-		err = dev_change_net_namespace(dev, dest_net, ifname, 0);
+		err = dev_change_net_namespace(dev, dest_net, ifname);
 		if (err < 0)
 			goto out_unregister;
 	}
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index ec3068937fc3..de259b5170ab 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -205,7 +205,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		if (!wpan_dev->netdev)
 			continue;
 		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
-		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d", 0);
+		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
 		if (err)
 			break;
 		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
@@ -222,7 +222,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 				continue;
 			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
-						       "wpan%d", 0);
+						       "wpan%d");
 			WARN_ON(err);
 			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
 		}
diff --git a/net/wireless/core.c b/net/wireless/core.c
index fabb677b7d58..a2785379df6e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -165,7 +165,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		if (!wdev->netdev)
 			continue;
 		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
-		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d", 0);
+		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
 			break;
 		wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
@@ -182,7 +182,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 				continue;
 			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wdev->netdev, net,
-							"wlan%d", 0);
+							"wlan%d");
 			WARN_ON(err);
 			wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
 		}
-- 
2.29.2

