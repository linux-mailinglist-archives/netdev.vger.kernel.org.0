Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40704249209
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgHSAvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHSAvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:51:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC83C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 17:51:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l13so24292909ybf.5
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 17:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2B8gPcWfCuvjs7NtY/xIdswfBWxy6UYIcx6zXU1X2MU=;
        b=EoDBIFtdMVhAJVdt/vjeX//CgeKHkZP3JvE3bRqQuTebWKB4zGFFRVGCSr24wKNSSV
         oToBubOZGzmoSWQvTJLSmaZXioDniFV+sgTG1Bjr/XxslPgacVVmCWifLq7Ico6L6LRL
         2HXgtsRzwfPA/AaZDt3p9uYtXZbLxL7ywEz/p8kzaOhJzdQz6qkn3u4QtoVZSYFbxxme
         dqLBU9uqVzQWX2UzmBQRlxJ1SJXj+kQxYf/3q8xpVquk3H6UPmXT0016/nrFt9AnGY1n
         3gW5HuBFcJji7W4ii89OQkryH6jHd8Xu2VMGABqqo5n42LGisLBelIOBMdCFyVhaZXiC
         IEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2B8gPcWfCuvjs7NtY/xIdswfBWxy6UYIcx6zXU1X2MU=;
        b=PXT5+5uJoGd4SUBDgkeF20PXCbGojzCl2KIw2jE+x2GYYy3LoWiW4R/orRiUw5LBIO
         4Jb/Oo4yWhLYsYRES5CIShC3aGniTZP9eQHlvhMLIEeltecUlEGlcmjq8y1Vx03A4cGJ
         vWnMuiGbcIEoaCudHw35WKTPDs+K5RRiBKN38qntNUaORLi0tZb3Lwsm///iAmCgKR2I
         SpmoYyhb1e1otbV0HIQVbsYtPtdZahVauq4jN4vGkt2mXKqCdYgqjGHONIqLEPWKSJjT
         JMqcN6PjVWlRPIPbZShxRd6gtI1YGadiLGdDK/EN9jaLVjb+wZ/gzQpc//Tc3sDxClur
         2tbQ==
X-Gm-Message-State: AOAM531U8eVHA7jfRxfpsNSQFA5DnwqLWCCHSuLrwTXi+6HEPqVwOMdB
        xz/IA2XjM1rkRnYSRNJgQHZnxJnuxdbB1S/Zv1pLDaoxqaoPhvHM4NtgCYiuEFlcqOeVFdJaiL4
        RguycfjTLSJF6f9gcc0mGL2Rz25fGcwjIxboBnx7MbjP9J8fyx97yP5ybKsTQTwY1
X-Google-Smtp-Source: ABdhPJyTrzL+r5wdr5bjAI73sza1jNMJbAXXfpYpd8zlvHj870rc8qW7GJYBr9GfZ5FBXHjmuik6SDi0rMtW
X-Received: by 2002:a25:e74f:: with SMTP id e76mr31190507ybh.337.1597798289731;
 Tue, 18 Aug 2020 17:51:29 -0700 (PDT)
Date:   Tue, 18 Aug 2020 17:51:23 -0700
Message-Id: <20200819005123.1867051-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH next] net: add option to not create fall-back tunnels in
 root-ns as well
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
not create fallback tunnels for non-default namespaces") to create
fall-back only in root-ns. This patch enhances that behavior to provide
option not to create fallback tunnels in root-ns as well. Since modules
that create fallback tunnels could be built-in and setting the sysctl
value after booting is pointless, so added a config option which defaults
to zero (to preserve backward compatibility) but also takes values "1" and
"2" which don't create fallback tunnels in non-root namespaces
only and no-where respectively.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Maciej Zenczykowski <maze@google.com>
Cc: Jian Yang <jianyang@google.com>
---
 Documentation/admin-guide/sysctl/net.rst | 21 ++++++++++++++-------
 include/linux/netdevice.h                |  7 ++++++-
 net/Kconfig                              | 11 +++++++++++
 net/core/sysctl_net_core.c               |  4 ++--
 4 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 42cd04bca548..aa1f5727d291 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -321,13 +321,20 @@ fb_tunnels_only_for_init_net
 ----------------------------
 
 Controls if fallback tunnels (like tunl0, gre0, gretap0, erspan0,
-sit0, ip6tnl0, ip6gre0) are automatically created when a new
-network namespace is created, if corresponding tunnel is present
-in initial network namespace.
-If set to 1, these devices are not automatically created, and
-user space is responsible for creating them if needed.
-
-Default : 0  (for compatibility reasons)
+sit0, ip6tnl0, ip6gre0) are automatically created. There are 3
+possibiltieis.
+(a) value = 0; respective fallback tunnels are created when module is
+loaded in every net namespaces (backward compatible behavior).
+(b) value = 1; respective fallback tunnels are created only in root
+net namespace and every other net namespace will not have them.
+(c) value = 2; fallback tunnels are not created when a module is
+loaded in any of the net namespace.
+
+Not creating fallback tunnels gives control to userspace to create
+whatever is needed and avoid creating devices which are not used.
+
+Default: The value of this sysctl is set via config item SYSCTL_FB_TUNNEL
+and is set to "0" by default. (for compatibility reasons)
 
 devconf_inherit_init_net
 ------------------------
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..327a302c8c26 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -640,9 +640,14 @@ struct netdev_queue {
 extern int sysctl_fb_tunnels_only_for_init_net;
 extern int sysctl_devconf_inherit_init_net;
 
+/*
+ * sysctl_fb_tunnels_only_for_init_net	== 0 : For all netns
+ *					== 1 : For initns only
+ *					== 2 : For none.
+ */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return net == &init_net ||
+	return (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1) ||
 	       !IS_ENABLED(CONFIG_SYSCTL) ||
 	       !sysctl_fb_tunnels_only_for_init_net;
 }
diff --git a/net/Kconfig b/net/Kconfig
index 3831206977a1..a57671e8a324 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -460,6 +460,17 @@ config ETHTOOL_NETLINK
 	  netlink. It provides better extensibility and some new features,
 	  e.g. notification messages.
 
+config SYSCTL_FB_TUNNEL
+	int "Value for sysctl_fb_tunnels_only_for_init_net"
+	range 0 2
+	default 0
+	help
+	  A sysctl value for sysctl_fb_tunnels_only_for_init_net. The value "0"
+	  is for backward compatibility and creates fall-back tunnels in root-ns
+	  as well as any newly created net namespaces. The value "1" restricts
+	  this these fallback tunnels to only root-ns while value "2" does not
+	  create these tunnels anywhere.
+
 endif   # if NET
 
 # Used by archs to tell that they support BPF JIT compiler plus which flavour.
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 6ada114bbcca..06b98cb2e21d 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -32,7 +32,7 @@ static long long_max __maybe_unused = LONG_MAX;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
-int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
+int sysctl_fb_tunnels_only_for_init_net __read_mostly = CONFIG_SYSCTL_FB_TUNNEL;
 EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 
 /* 0 - Keep current behavior:
@@ -546,7 +546,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "devconf_inherit_init_net",
-- 
2.28.0.220.ged08abb693-goog

