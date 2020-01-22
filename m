Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7AFB1449F1
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAVCjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:39:22 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:47704 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbgAVCjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:39:22 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v2eK020009;
        Tue, 21 Jan 2020 16:57:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=/vHaqNOJUr6x7jbpQRexD3xzVPYtFNp5ZrzV4FKpNbs=;
 b=uG0UpVKmAeXBjVknsYpISDuhA1tJo2tb8JDWXsi2/p4DjCNdOxbq6ysIiWFxmfJM3zPC
 8yH1KUtRT8iIkHDhKZHhVfSiTSF1UVmgu7IyedkGqeYyaRC6Xvp8FnV7bJnxyNqHF0PY
 GRMAcz+GffzLrfHXTkR7emlC7sr29r507WqowI+ZrnhdO9/IpLWJBIz7KKoaoH3Te+wu
 rTZMQC8ERW6OHQcigpSJ4frcCoAkNo9MRsl5fBQjZYjxS8Fsdn6rtSiizKhhn823wNqF
 ggWHg1USankggiSQtwhh9fUtUUj58lfr3sxXXssBDNcOWn94N3OkeT7OV2MdA9ThCaaa Yg== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2xkyfq8e4a-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:04 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00064HAZD600@ma1-mtap-s03.corp.apple.com>; Tue,
 21 Jan 2020 16:57:03 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: d36fbbd85c5e341840c93f4d915021fa
X-Va-R-CD: e0a733c2d42bf462324452628d481b4c
X-Va-CD: 0
X-Va-ID: d6e559b7-cd00-46c0-b556-0f45292c19a4
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: d36fbbd85c5e341840c93f4d915021fa
X-V-R-CD: e0a733c2d42bf462324452628d481b4c
X-V-CD: 0
X-V-ID: 94ad6a18-3510-47dc-952e-7043d38af389
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DSSHB0DC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Matthieu Baerts <matthieu.baerts@tessares.net>,
        Peter Krystad <peter.krystad@linux.intel.com>
Subject: [PATCH net-next v3 14/19] mptcp: new sysctl to control the activation
 per NS
Date:   Tue, 21 Jan 2020 16:56:28 -0800
Message-id: <20200122005633.21229-15-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

New MPTCP sockets will return -ENOPROTOOPT if MPTCP support is disabled
for the current net namespace.

We are providing here a way to control access to the feature for those
that need to turn it on or off.

The value of this new sysctl can be different per namespace. We can then
restrict the usage of MPTCP to the selected NS. In case of serious
issues with MPTCP, administrators can now easily turn MPTCP off.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/ctrl.c     | 130 +++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c |  16 ++++--
 net/mptcp/protocol.h |   3 +
 4 files changed, 146 insertions(+), 5 deletions(-)
 create mode 100644 net/mptcp/ctrl.c

diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 178ae81d8b66..4e98d9edfd0a 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o subflow.o options.o token.o crypto.o
+mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o
diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
new file mode 100644
index 000000000000..8e39585d37f3
--- /dev/null
+++ b/net/mptcp/ctrl.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2019, Tessares SA.
+ */
+
+#include <linux/sysctl.h>
+
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
+#include "protocol.h"
+
+#define MPTCP_SYSCTL_PATH "net/mptcp"
+
+static int mptcp_pernet_id;
+struct mptcp_pernet {
+	struct ctl_table_header *ctl_table_hdr;
+
+	int mptcp_enabled;
+};
+
+static struct mptcp_pernet *mptcp_get_pernet(struct net *net)
+{
+	return net_generic(net, mptcp_pernet_id);
+}
+
+int mptcp_is_enabled(struct net *net)
+{
+	return mptcp_get_pernet(net)->mptcp_enabled;
+}
+
+static struct ctl_table mptcp_sysctl_table[] = {
+	{
+		.procname = "enabled",
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		/* users with CAP_NET_ADMIN or root (not and) can change this
+		 * value, same as other sysctl or the 'net' tree.
+		 */
+		.proc_handler = proc_dointvec,
+	},
+	{}
+};
+
+static void mptcp_pernet_set_defaults(struct mptcp_pernet *pernet)
+{
+	pernet->mptcp_enabled = 1;
+}
+
+static int mptcp_pernet_new_table(struct net *net, struct mptcp_pernet *pernet)
+{
+	struct ctl_table_header *hdr;
+	struct ctl_table *table;
+
+	table = mptcp_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(table, sizeof(mptcp_sysctl_table), GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
+
+	table[0].data = &pernet->mptcp_enabled;
+
+	hdr = register_net_sysctl(net, MPTCP_SYSCTL_PATH, table);
+	if (!hdr)
+		goto err_reg;
+
+	pernet->ctl_table_hdr = hdr;
+
+	return 0;
+
+err_reg:
+	if (!net_eq(net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static void mptcp_pernet_del_table(struct mptcp_pernet *pernet)
+{
+	struct ctl_table *table = pernet->ctl_table_hdr->ctl_table_arg;
+
+	unregister_net_sysctl_table(pernet->ctl_table_hdr);
+
+	kfree(table);
+}
+
+static int __net_init mptcp_net_init(struct net *net)
+{
+	struct mptcp_pernet *pernet = mptcp_get_pernet(net);
+
+	mptcp_pernet_set_defaults(pernet);
+
+	return mptcp_pernet_new_table(net, pernet);
+}
+
+/* Note: the callback will only be called per extra netns */
+static void __net_exit mptcp_net_exit(struct net *net)
+{
+	struct mptcp_pernet *pernet = mptcp_get_pernet(net);
+
+	mptcp_pernet_del_table(pernet);
+}
+
+static struct pernet_operations mptcp_pernet_ops = {
+	.init = mptcp_net_init,
+	.exit = mptcp_net_exit,
+	.id = &mptcp_pernet_id,
+	.size = sizeof(struct mptcp_pernet),
+};
+
+void __init mptcp_init(void)
+{
+	mptcp_proto_init();
+
+	if (register_pernet_subsys(&mptcp_pernet_ops) < 0)
+		panic("Failed to register MPTCP pernet subsystem.\n");
+}
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+int __init mptcpv6_init(void)
+{
+	int err;
+
+	err = mptcp_proto_v6_init();
+
+	return err;
+}
+#endif
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0b21ae25bd0f..45e482864a19 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -522,7 +522,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	}
 }
 
-static int mptcp_init_sock(struct sock *sk)
+static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
@@ -532,6 +532,14 @@ static int mptcp_init_sock(struct sock *sk)
 	return 0;
 }
 
+static int mptcp_init_sock(struct sock *sk)
+{
+	if (!mptcp_is_enabled(sock_net(sk)))
+		return -ENOPROTOOPT;
+
+	return __mptcp_init_sock(sk);
+}
+
 static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 {
 	lock_sock(ssk);
@@ -640,7 +648,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			return NULL;
 		}
 
-		mptcp_init_sock(new_mptcp_sock);
+		__mptcp_init_sock(new_mptcp_sock);
 
 		msk = mptcp_sk(new_mptcp_sock);
 		msk->remote_key = subflow->remote_key;
@@ -1078,7 +1086,7 @@ static struct inet_protosw mptcp_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-void __init mptcp_init(void)
+void mptcp_proto_init(void)
 {
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
 	mptcp_stream_ops = inet_stream_ops;
@@ -1116,7 +1124,7 @@ static struct inet_protosw mptcp_v6_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-int mptcpv6_init(void)
+int mptcp_proto_v6_init(void)
 {
 	int err;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 59a83eb64d37..a8fad7d78565 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -179,6 +179,9 @@ extern const struct inet_connection_sock_af_ops ipv6_specific;
 #endif
 
 void mptcp_proto_init(void);
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+int mptcp_proto_v6_init(void);
+#endif
 
 struct mptcp_read_arg {
 	struct msghdr *msg;
-- 
2.23.0

