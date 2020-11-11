Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008DC2AF9EA
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgKKUn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKUn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:43:57 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2686C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:43:57 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id q10so2425668pfn.0
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rEH17xnTXd75N7H9g32Hqh48e9pbD8kKJDWmdRHO3/M=;
        b=YDppMtdLAyhIv8qXrYlbi8uHBu92EKdBJIay365dhCDmgJkMv4ho9C3D1qJWjn1lhm
         /P3g+0hkxuP0AqQbFjsONTfzAgs7vrMHQD1/r4ng6OTjNEwbpczXyW+7LziBkXcShO6J
         40XdBtZppjIEQkE/25py3aOgIGVGrm5xABQNDQ+ckdN/IbR854l2jmgwNJTtu+Qb8IJY
         UGo6rlD5CsOWXAQ+WdVYFGJlSA8I/SrkKnKowi+1MzzR+2K9ukBhjnes5//53SIjBymC
         0mMiakNiTMYBZzaYIWjah1xOzyDTx5Z+RpJDR/ILIDt4la2PPdqJZrCvU3dUfl/38m7Q
         5GJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rEH17xnTXd75N7H9g32Hqh48e9pbD8kKJDWmdRHO3/M=;
        b=rvY3v7nWpK0A2uTy1SMCJEsbcq55G3yMjihyKojCExDoEDdn9hxLVwC0qcDZ+dHtee
         09r2WmtAvaLGYqdYS1Du8ySfPfTUkU2v3mDD8PXJIpRmCPrf/Dic6fGH3lXzrHRp/x0u
         hMktPcVu7D3upSHfjlG/9FQ0p0560ES34owB1FE9zs5Y6ip6eTiw60iW4DkymXW8uG7K
         YzjeVpkt7qcil2ioKfhE5Hs4XWzdS6xKXu8hv59ATrfYCWqj0Zpq3PO2eUkpBoRJRpTu
         uKFft3D7ItkYxM+ayreiryNUH7FgR8wtXYRKZIGFpeWtLjpCc6IGsY3WwpbBv/Zmed51
         wYkw==
X-Gm-Message-State: AOAM532nvu1ftXUqKbKzMQqZoNNgTaEf0JnPKJkmTuw8U9LLcL3bodHO
        TXrPnCedJ3BPOpb1meJZ3oydIs/tMIM=
X-Google-Smtp-Source: ABdhPJyoswiw1b6+8W0LRT22lK9GInsqPEWIR4NPKJ8Crd2VKLa9V3QGand33+VLPontw/ekSDvtXQ==
X-Received: by 2002:a63:4e4c:: with SMTP id o12mr7611450pgl.348.1605127437306;
        Wed, 11 Nov 2020 12:43:57 -0800 (PST)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef8:759])
        by smtp.gmail.com with ESMTPSA id fh22sm3360844pjb.45.2020.11.11.12.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 12:43:56 -0800 (PST)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
Date:   Wed, 11 Nov 2020 12:43:08 -0800
Message-Id: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
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
---
 Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
 drivers/net/loopback.c                   |  7 +++++++
 include/linux/netdevice.h                |  1 +
 net/core/sysctl_net_core.c               | 14 ++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f2ab8a5b6a4b..6902232ff57a 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -268,6 +268,17 @@ Maximum number of microseconds in one NAPI polling cycle. Polling
 will exit when either netdev_budget_usecs have elapsed during the
 poll cycle or the number of packets processed reaches netdev_budget.
 
+netdev_loopback_state
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
index a1c77cc00416..76dc92ac65a2 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct net *net)
 
 	BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
 	net->loopback_dev = dev;
+
+	if (sysctl_netdev_loopback_state) {
+		/* Bring loopback device UP */
+		rtnl_lock();
+		dev_open(dev, NULL);
+		rtnl_unlock();
+	}
 	return 0;
 
 out_free_netdev:
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7ce648a564f7..27c0a7e8a8ea 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -625,6 +625,7 @@ struct netdev_queue {
 
 extern int sysctl_fb_tunnels_only_for_init_net;
 extern int sysctl_devconf_inherit_init_net;
+extern int sysctl_netdev_loopback_state;
 
 /*
  * sysctl_fb_tunnels_only_for_init_net == 0 : For all netns
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d86d8d11cfe4..d2cf435f5991 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -35,6 +35,11 @@ static int net_msg_warn;	/* Unused, but still a sysctl */
 int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
 EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 
+/* 0 - default (backward compatible) state: DOWN by default
+ * 1 - UP by default (for all new network namespaces)
+ */
+int sysctl_netdev_loopback_state __read_mostly;
+
 /* 0 - Keep current behavior:
  *     IPv4: inherit all current settings from init_net
  *     IPv6: reset all settings to default
@@ -507,6 +512,15 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= set_default_qdisc
 	},
 #endif
+	{
+		.procname	= "netdev_loopback_state",
+		.data		= &sysctl_netdev_loopback_state,
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
2.29.2.222.g5d2a92d10f8-goog

