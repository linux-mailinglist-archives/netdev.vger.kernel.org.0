Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B192523BC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 00:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHYWmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 18:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHYWmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 18:42:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCA0C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 15:42:14 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m16so213589pgl.16
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 15:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=9uc00Wz7XSZ3tyAHvu/QE0CyxK6MoqL86Cfe397flPk=;
        b=Ys/6pqj3i1tuA0fpEeHJRP9TMvdorph9J+PM1ustQgprEVtD0UjYJnYEDc/5JuoWtz
         g2mjcAhJndXli50qR2CP/fAxIePX0muUy0bzt4f+HOEbwKyGkZzi7Xtk5d5hgm7S9yqU
         ohZu5r2tgA75+kdHlLRl0a+Eq56qO0Ddfyts8HqDzoc55Rp70Aa9AOdju0a/TSdrxQce
         rSyjhCxkEcnO7qzsKAlJ5XUpu2EmuYt53LxmW5/Rs7wZN2kNNdM8PfVoCeH/fT61ptD8
         ciNt1BM8+vHuy7vafl1xCUYo2ocro8L0c22wAY22tSkTijv5WH51ruTxEmUndOEbeMWI
         YjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=9uc00Wz7XSZ3tyAHvu/QE0CyxK6MoqL86Cfe397flPk=;
        b=NFKbibIC03DuJ3w1QBQzW+iGMssGyZCytxoWi9VInbtKfQQrLrlY9aE1Vnj/JB23gM
         GjpvEwbj9pgWUVekNiNu55B1uwOIZz4DmqI+Mlg8AukZQHWoW4HyKFTKvpxMzmV+2lWA
         FciItiwiCM6IaPNVXrEdRE/M3cbgvC76qe6kvFhyHbSWSNNPCdAQaXG3U8Gmda4Vnz+D
         nWPAMZeMvFIo7yZZSt04YjL5yfy+eRN8KSet6HcSNPZpPBfpD3rMscSAgS/tBg0Wh1IT
         DO7AeULr0/6b5TMQiwZ0hLbx7IJMvgkHpBeHlEqVPwagU5peqw8UEq9MNRDy3SX9f3+l
         B4cw==
X-Gm-Message-State: AOAM5304Bor4NTjWYUBwSnGQn+mHX8gi7tJ6ORmqhHjVygG5xJ8jjqdu
        sRiJpULaRk3v5qXv0pBG0mrNQX5UkLHSJoqcNDJh0rHxij0cpa/0M6vyi2dcW0sF2PoXbFU0QIr
        8Z7lkakCI5/tnStMj7blewURBy4jKXtqQ8VWPCB8M1TK6MpsulJgchWMzNZLtJuzU
X-Google-Smtp-Source: ABdhPJx8BSACHOMoKBZnhy7zgTAOLqm+gR1iHRyBdaVV+nJjr/TV3tF3fhckhVPkQZc7TRBJhqnJ5NwNTrtn
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:e398])
 (user=maheshb job=sendgmr) by 2002:a17:90b:4595:: with SMTP id
 hd21mr543656pjb.0.1598395332532; Tue, 25 Aug 2020 15:42:12 -0700 (PDT)
Date:   Tue, 25 Aug 2020 15:42:08 -0700
Message-Id: <20200825224208.1268641-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCHv2 next] net: add option to not create fall-back tunnels in
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
value after booting is pointless, so added a kernel cmdline options to
change this default. The default setting is preseved for backward
compatibility. The kernel command line option of fb_tunnels=initns will
set the sysctl value to 1 and will create fallback tunnels only in initns
while kernel cmdline fb_tunnels=none will set the sysctl value to 2 and
fallback tunnels are skipped in every netns.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Maciej Zenczykowski <maze@google.com>
Cc: Jian Yang <jianyang@google.com>
---
v1->v2
  Removed the Kconfig option which would force rebuild and replaced with
  kcmd-line option

 .../admin-guide/kernel-parameters.txt         |  5 +++++
 Documentation/admin-guide/sysctl/net.rst      | 20 +++++++++++++------
 include/linux/netdevice.h                     |  7 ++++++-
 net/core/sysctl_net_core.c                    | 17 ++++++++++++++--
 4 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a1068742a6df..09a51598c792 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -801,6 +801,11 @@
 
 	debug_objects	[KNL] Enable object debugging
 
+	fb_tunnels=	[NET]
+			Format: { initns | none }
+			See Documentation/admin-guide/sysctl/net.rst for
+			fb_tunnels_only_for_init_ns
+
 	no_debug_objects
 			[KNL] Disable object debugging
 
diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 42cd04bca548..57fd6ce68fe0 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -300,7 +300,6 @@ Note:
       0:    0     1     2     3     4     5     6     7
   RSS hash key:
   84:50:f4:00:a8:15:d1:a7:e9:7f:1d:60:35:c7:47:25:42:97:74:ca:56:bb:b6:a1:d8:43:e3:c9:0c:fd:17:55:c2:3a:4d:69:ed:f1:42:89
-
 netdev_tstamp_prequeue
 ----------------------
 
@@ -321,11 +320,20 @@ fb_tunnels_only_for_init_net
 ----------------------------
 
 Controls if fallback tunnels (like tunl0, gre0, gretap0, erspan0,
-sit0, ip6tnl0, ip6gre0) are automatically created when a new
-network namespace is created, if corresponding tunnel is present
-in initial network namespace.
-If set to 1, these devices are not automatically created, and
-user space is responsible for creating them if needed.
+sit0, ip6tnl0, ip6gre0) are automatically created. There are 3 possibilities
+(a) value = 0; respective fallback tunnels are created when module is
+loaded in every net namespaces (backward compatible behavior).
+(b) value = 1; [kcmd value: initns] respective fallback tunnels are
+created only in init net namespace and every other net namespace will
+not have them.
+(c) value = 2; [kcmd value: none] fallback tunnels are not created
+when a module is loaded in any of the net namespace. Setting value to
+"2" is pointless after boot if these modules are built-in, so there is
+a kernel command-line option that can change this default. Please refer to
+Documentation/admin-guide/kernel-parameters.txt for additional details.
+
+Not creating fallback tunnels gives control to userspace to create
+whatever is needed only and avoid creating devices which are redundant.
 
 Default : 0  (for compatibility reasons)
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..7efcdb9ee4ff 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -640,9 +640,14 @@ struct netdev_queue {
 extern int sysctl_fb_tunnels_only_for_init_net;
 extern int sysctl_devconf_inherit_init_net;
 
+/*
+ * sysctl_fb_tunnels_only_for_init_net == 0 : For all netns
+ *                                     == 1 : For initns only
+ *                                     == 2 : For none.
+ */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return net == &init_net ||
+	return (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1) ||
 	       !IS_ENABLED(CONFIG_SYSCTL) ||
 	       !sysctl_fb_tunnels_only_for_init_net;
 }
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 6ada114bbcca..d86d8d11cfe4 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -22,7 +22,7 @@
 #include <net/busy_poll.h>
 #include <net/pkt_sched.h>
 
-static int two __maybe_unused = 2;
+static int two = 2;
 static int three = 3;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
@@ -546,7 +546,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "devconf_inherit_init_net",
@@ -587,6 +587,19 @@ static struct ctl_table netns_core_table[] = {
 	{ }
 };
 
+static int __init fb_tunnels_only_for_init_net_sysctl_setup(char *str)
+{
+	/* fallback tunnels for initns only */
+	if (!strncmp(str, "initns", 6))
+		sysctl_fb_tunnels_only_for_init_net = 1;
+	/* no fallback tunnels anywhere */
+	else if (!strncmp(str, "none", 4))
+		sysctl_fb_tunnels_only_for_init_net = 2;
+
+	return 1;
+}
+__setup("fb_tunnels=", fb_tunnels_only_for_init_net_sysctl_setup);
+
 static __net_init int sysctl_core_net_init(struct net *net)
 {
 	struct ctl_table *tbl;
-- 
2.28.0.297.g1956fa8f8d-goog

