Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4241D2B7205
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgKQXPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQXPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:15:20 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01CFC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 15:15:18 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 5so4346415plj.8
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 15:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdXr6BFuVDXSUamzHAWUyYcZDG79JOhxL0Hlm/0RVrw=;
        b=DFUeQNdYg/y1fZp7IGak5aPrq6IYcvL9mmQTpxRHg875eQhtzqDwth0MKsp82L6ds0
         hFw5TI0rIYi2kl6nLC/Qoo01boioUWDHEQLx10rnznk6vSZgMnuuoUTS8hjkrgVLIeOd
         NOa8vQPp6KBfzWjeVA6qGAUExEQGAUicN4IKKBc7k3nrGV+jGuui+mCkjXWwFYplrJyA
         BtyL1Z6eb7+jbAF5B3EKVT2G96KQbuzp6MJlXckOyde3ZIqtpHqKDeXh3PMsw58NunZB
         kV3NCxPU3WOmget4w2doQN4RieMQ3xO2svQ7HSILFZHSE6M6cj2UoPkU4ZmTkCohwJwF
         /v6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdXr6BFuVDXSUamzHAWUyYcZDG79JOhxL0Hlm/0RVrw=;
        b=LWh8lHRwTEsr6/pOxPKR2llEO1BQfgIVFzO/435qwXpF9RGUp/el+uYSnJAtOOfxsz
         YNwZ6+1Si/3Zw/KkP7Iu3hIX5ttRsunVrXyIXZElpfSQd6QwI7LfHG1WtCdVMFfzaesq
         WaJQhaSQGYXbOd4wq0VGCDDBWfOw+Cm0WimS/jnS+z/GlafvpK5f0qx4l0Urw+s2DG9z
         TkGxGMKci0EEBVDvomJuYrmNTFnyaSWdtPNPAkyHYFDqgPdTzez4S/WL5e9HnrGAsIAq
         4J3TuEjMvPDHBnDcVQRwECWOFxF80bn3zerlX8cBt4g8XfI5AqwqYV+4snuBzJ8/WrDj
         XUwA==
X-Gm-Message-State: AOAM531pnxkMpsYVCk8BY6/n5lzeXtGI8ED3cxiP1DjZoP+NhGP3FWbb
        tPh/S/QiN6Il2jj/tCtRtLg=
X-Google-Smtp-Source: ABdhPJwyFe+wReNvQjlw+PIpJo9wAZFtDfl8xMHau2sqNfuYfYiyY0xVR0VNshgCQd9M2w/Vq+2OEQ==
X-Received: by 2002:a17:90a:4742:: with SMTP id y2mr1311557pjg.228.1605654918388;
        Tue, 17 Nov 2020 15:15:18 -0800 (PST)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef8:759])
        by smtp.gmail.com with ESMTPSA id j19sm24493910pfd.189.2020.11.17.15.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 15:15:17 -0800 (PST)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v2] net-loopback: allow lo dev initial state to be controlled
Date:   Tue, 17 Nov 2020 15:14:12 -0800
Message-Id: <20201117231412.2054663-1-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

Traditionally loopback devices comes up with initial state as DOWN for
any new network-namespace. This would mean that anyone needing this
device (which is mostly true except sandboxes where networking in not
needed at all), would have to bring this UP by issuing something like
'ip link set lo up' which can be avoided if the initial state can be set
as UP. Also ICMP error propagation needs loopback to be UP.

The default value for this sysctl is set to ZERO which will preserve the
backward compatible behavior for the root-netns while changing the
sysctl will only alter the behavior of the newer network namespaces.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: Jian Yang <jianyang@google.com>
Reported-by: kernel test robot <lkp@intel.com>
---
v2:
  * Updated sysctl name from `netdev_loopback_state` to `loopback_init_state`
  * Fixed the linking error when CONFIG_SYSCTL is not defined

 Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
 drivers/net/loopback.c                   |  9 +++++++++
 include/linux/netdevice.h                |  1 +
 net/core/sysctl_net_core.c               | 14 ++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f2ab8a5b6a4b..76698371d86e 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -268,6 +268,17 @@ Maximum number of microseconds in one NAPI polling cycle. Polling
 will exit when either netdev_budget_usecs have elapsed during the
 poll cycle or the number of packets processed reaches netdev_budget.
 
+loopback_init_state
+---------------------
+
+Controls the loopback device initial state for any new network namespaces. By
+default, we keep the initial state as DOWN.
+
+If set to 1, the loopback device will be brought UP during namespace creation.
+This will only apply to all new network namespaces.
+
+Default : 0  (for compatibility reasons)
+
 netdev_max_backlog
 ------------------
 
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..bf6f20095ebe 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -219,6 +219,15 @@ static __net_init int loopback_net_init(struct net *net)
 
 	BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
 	net->loopback_dev = dev;
+
+#ifdef CONFIG_SYSCTL
+	if (sysctl_loopback_init_state) {
+		/* Bring loopback device UP */
+		rtnl_lock();
+		dev_open(dev, NULL);
+		rtnl_unlock();
+	}
+#endif
 	return 0;
 
 out_free_netdev:
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7ce648a564f7..172a6f9eb517 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -625,6 +625,7 @@ struct netdev_queue {
 
 extern int sysctl_fb_tunnels_only_for_init_net;
 extern int sysctl_devconf_inherit_init_net;
+extern int sysctl_loopback_init_state;
 
 /*
  * sysctl_fb_tunnels_only_for_init_net == 0 : For all netns
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d86d8d11cfe4..224f4c3c6c87 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -35,6 +35,11 @@ static int net_msg_warn;	/* Unused, but still a sysctl */
 int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
 EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 
+/* 0 - default (backward compatible) state: DOWN by default
+ * 1 - UP by default (for all new network namespaces)
+ */
+int sysctl_loopback_init_state __read_mostly;
+
 /* 0 - Keep current behavior:
  *     IPv4: inherit all current settings from init_net
  *     IPv6: reset all settings to default
@@ -507,6 +512,15 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= set_default_qdisc
 	},
 #endif
+	{
+		.procname	= "loopback_init_state",
+		.data		= &sysctl_loopback_init_state,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 #endif /* CONFIG_NET */
 	{
 		.procname	= "netdev_budget",
-- 
2.29.2.299.gdc1121823c-goog

