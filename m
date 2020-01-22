Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78A8144A37
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAVDMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:12:07 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:48198 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgAVDMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:12:07 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v2eE020009;
        Tue, 21 Jan 2020 16:57:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=FX1uFqalxfDsVnErVL0hDSqSWP1nHgs75D6ZE9NvEfc=;
 b=d/mQmVAdilWGDZVaUXSsCI84MK0GMXTzW9tYtp3CI6vkuOhmizVHpIegnq5vsvsYjge1
 UjLat6IXG27xxEQHH+YySP+4Lw3CPSj2pyTWuc43YEsZ9fAvFh1+2xoc0zB3CPeKB58k
 l/rXFOX8SmPUZHsx3xHeBUjiKPUktrQPlpNpmZSnCb1BscR6n49zlxZ39UP+92zWtN7c
 KD8HOOuTAZtDRPSF2uQBQxdXSDtzN+iv23220XW4Pgc2N14hIACaFJWE2J/tyb/+TKB0
 5J/h04C/YCTYCUgmtal3cPq4v6KahPyb3+E+VstnGIuHtrUDBnc/boqgHbh9KSMUnFBJ aQ== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2xkyfq8e4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:02 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00064HAZD600@ma1-mtap-s03.corp.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00500GU2WL00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:59 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: ed3e5ef442236977e57274b3b0ea5602
X-Va-R-CD: 4c9e62fa76176fe31a4ea587a70c1c88
X-Va-CD: 0
X-Va-ID: 9ec772a6-9480-473f-b4db-34472d414ad9
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: ed3e5ef442236977e57274b3b0ea5602
X-V-R-CD: 4c9e62fa76176fe31a4ea587a70c1c88
X-V-CD: 0
X-V-ID: 8759a21f-dc6f-43be-886e-e2259b82bab9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H0011NHAZ4Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:59 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 01/19] mptcp: Add MPTCP socket stubs
Date:   Tue, 21 Jan 2020 16:56:15 -0800
Message-id: <20200122005633.21229-2-cpaasch@apple.com>
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

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

Implements the infrastructure for MPTCP sockets.

MPTCP sockets open one in-kernel TCP socket per subflow. These subflow
sockets are only managed by the MPTCP socket that owns them and are not
visible from userspace. This commit allows a userspace program to open
an MPTCP socket with:

  sock = socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);

The resulting socket is simply a wrapper around a single regular TCP
socket, without any of the MPTCP protocol implemented over the wire.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 MAINTAINERS          |   1 +
 include/net/mptcp.h  |  16 +++++
 net/Kconfig          |   1 +
 net/Makefile         |   1 +
 net/ipv4/tcp.c       |   2 +
 net/ipv6/tcp_ipv6.c  |   7 +++
 net/mptcp/Kconfig    |  16 +++++
 net/mptcp/Makefile   |   4 ++
 net/mptcp/protocol.c | 142 +++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  22 +++++++
 10 files changed, 212 insertions(+)
 create mode 100644 net/mptcp/Kconfig
 create mode 100644 net/mptcp/Makefile
 create mode 100644 net/mptcp/protocol.c
 create mode 100644 net/mptcp/protocol.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 702382b89c37..4be9c1b50183 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11583,6 +11583,7 @@ W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
 S:	Maintained
 F:	include/net/mptcp.h
+F:	net/mptcp/
 
 NETWORKING [TCP]
 M:	Eric Dumazet <edumazet@google.com>
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0573ae75c3db..98ba22379117 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -28,6 +28,8 @@ struct mptcp_ext {
 
 #ifdef CONFIG_MPTCP
 
+void mptcp_init(void);
+
 /* move the skb extension owership, with the assumption that 'to' is
  * newly allocated
  */
@@ -70,6 +72,10 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 
 #else
 
+static inline void mptcp_init(void)
+{
+}
+
 static inline void mptcp_skb_ext_move(struct sk_buff *to,
 				      const struct sk_buff *from)
 {
@@ -82,4 +88,14 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 }
 
 #endif /* CONFIG_MPTCP */
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+int mptcpv6_init(void);
+#elif IS_ENABLED(CONFIG_IPV6)
+static inline int mptcpv6_init(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* __NET_MPTCP_H */
diff --git a/net/Kconfig b/net/Kconfig
index 54916b7adb9b..b0937a700f01 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -91,6 +91,7 @@ if INET
 source "net/ipv4/Kconfig"
 source "net/ipv6/Kconfig"
 source "net/netlabel/Kconfig"
+source "net/mptcp/Kconfig"
 
 endif # if INET
 
diff --git a/net/Makefile b/net/Makefile
index 848303d98d3d..07ea48160874 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -87,3 +87,4 @@ endif
 obj-$(CONFIG_QRTR)		+= qrtr/
 obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
+obj-$(CONFIG_MPTCP)		+= mptcp/
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6711a97de3ce..7dfb78caedaf 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -271,6 +271,7 @@
 #include <net/icmp.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
+#include <net/mptcp.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/sock.h>
@@ -4021,4 +4022,5 @@ void __init tcp_init(void)
 	tcp_metrics_init();
 	BUG_ON(tcp_register_congestion_control(&tcp_reno) != 0);
 	tcp_tasklet_init();
+	mptcp_init();
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5b5260103b65..60068ffde1d9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2163,9 +2163,16 @@ int __init tcpv6_init(void)
 	ret = register_pernet_subsys(&tcpv6_net_ops);
 	if (ret)
 		goto out_tcpv6_protosw;
+
+	ret = mptcpv6_init();
+	if (ret)
+		goto out_tcpv6_pernet_subsys;
+
 out:
 	return ret;
 
+out_tcpv6_pernet_subsys:
+	unregister_pernet_subsys(&tcpv6_net_ops);
 out_tcpv6_protosw:
 	inet6_unregister_protosw(&tcpv6_protosw);
 out_tcpv6_protocol:
diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
new file mode 100644
index 000000000000..c1a99f07a4cd
--- /dev/null
+++ b/net/mptcp/Kconfig
@@ -0,0 +1,16 @@
+
+config MPTCP
+	bool "MPTCP: Multipath TCP"
+	depends on INET
+	select SKB_EXTENSIONS
+	help
+	  Multipath TCP (MPTCP) connections send and receive data over multiple
+	  subflows in order to utilize multiple network paths. Each subflow
+	  uses the TCP protocol, and TCP options carry header information for
+	  MPTCP.
+
+config MPTCP_IPV6
+	bool "MPTCP: IPv6 support for Multipath TCP"
+	depends on MPTCP
+	select IPV6
+	default y
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
new file mode 100644
index 000000000000..659129d1fcbf
--- /dev/null
+++ b/net/mptcp/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_MPTCP) += mptcp.o
+
+mptcp-y := protocol.o
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
new file mode 100644
index 000000000000..5e24e7cf7d70
--- /dev/null
+++ b/net/mptcp/protocol.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#define pr_fmt(fmt) "MPTCP: " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <net/sock.h>
+#include <net/inet_common.h>
+#include <net/inet_hashtables.h>
+#include <net/protocol.h>
+#include <net/tcp.h>
+#include <net/mptcp.h>
+#include "protocol.h"
+
+static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *subflow = msk->subflow;
+
+	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
+		return -EOPNOTSUPP;
+
+	return sock_sendmsg(subflow, msg);
+}
+
+static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			 int nonblock, int flags, int *addr_len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *subflow = msk->subflow;
+
+	if (msg->msg_flags & ~(MSG_WAITALL | MSG_DONTWAIT))
+		return -EOPNOTSUPP;
+
+	return sock_recvmsg(subflow, msg, flags);
+}
+
+static int mptcp_init_sock(struct sock *sk)
+{
+	return 0;
+}
+
+static void mptcp_close(struct sock *sk, long timeout)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	inet_sk_state_store(sk, TCP_CLOSE);
+
+	if (msk->subflow) {
+		pr_debug("subflow=%p", msk->subflow->sk);
+		sock_release(msk->subflow);
+	}
+
+	sock_orphan(sk);
+	sock_put(sk);
+}
+
+static int mptcp_connect(struct sock *sk, struct sockaddr *saddr, int len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	int err;
+
+	saddr->sa_family = AF_INET;
+
+	pr_debug("msk=%p, subflow=%p", msk, msk->subflow->sk);
+
+	err = kernel_connect(msk->subflow, saddr, len, 0);
+
+	sk->sk_state = TCP_ESTABLISHED;
+
+	return err;
+}
+
+static struct proto mptcp_prot = {
+	.name		= "MPTCP",
+	.owner		= THIS_MODULE,
+	.init		= mptcp_init_sock,
+	.close		= mptcp_close,
+	.accept		= inet_csk_accept,
+	.connect	= mptcp_connect,
+	.shutdown	= tcp_shutdown,
+	.sendmsg	= mptcp_sendmsg,
+	.recvmsg	= mptcp_recvmsg,
+	.hash		= inet_hash,
+	.unhash		= inet_unhash,
+	.get_port	= inet_csk_get_port,
+	.obj_size	= sizeof(struct mptcp_sock),
+	.no_autobind	= true,
+};
+
+static struct inet_protosw mptcp_protosw = {
+	.type		= SOCK_STREAM,
+	.protocol	= IPPROTO_MPTCP,
+	.prot		= &mptcp_prot,
+	.ops		= &inet_stream_ops,
+};
+
+void __init mptcp_init(void)
+{
+	if (proto_register(&mptcp_prot, 1) != 0)
+		panic("Failed to register MPTCP proto.\n");
+
+	inet_register_protosw(&mptcp_protosw);
+}
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static struct proto mptcp_v6_prot;
+
+static struct inet_protosw mptcp_v6_protosw = {
+	.type		= SOCK_STREAM,
+	.protocol	= IPPROTO_MPTCP,
+	.prot		= &mptcp_v6_prot,
+	.ops		= &inet6_stream_ops,
+	.flags		= INET_PROTOSW_ICSK,
+};
+
+int mptcpv6_init(void)
+{
+	int err;
+
+	mptcp_v6_prot = mptcp_prot;
+	strcpy(mptcp_v6_prot.name, "MPTCPv6");
+	mptcp_v6_prot.slab = NULL;
+	mptcp_v6_prot.obj_size = sizeof(struct mptcp_sock) +
+				 sizeof(struct ipv6_pinfo);
+
+	err = proto_register(&mptcp_v6_prot, 1);
+	if (err)
+		return err;
+
+	err = inet6_register_protosw(&mptcp_v6_protosw);
+	if (err)
+		proto_unregister(&mptcp_v6_prot);
+
+	return err;
+}
+#endif
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
new file mode 100644
index 000000000000..ee04a01bffd3
--- /dev/null
+++ b/net/mptcp/protocol.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#ifndef __MPTCP_PROTOCOL_H
+#define __MPTCP_PROTOCOL_H
+
+/* MPTCP connection sock */
+struct mptcp_sock {
+	/* inet_connection_sock must be the first member */
+	struct inet_connection_sock sk;
+	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
+};
+
+static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
+{
+	return (struct mptcp_sock *)sk;
+}
+
+#endif /* __MPTCP_PROTOCOL_H */
-- 
2.23.0

