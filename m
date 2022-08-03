Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8B5890B4
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiHCQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbiHCQlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:41:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A163FA2F;
        Wed,  3 Aug 2022 09:40:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d20so9534936pfq.5;
        Wed, 03 Aug 2022 09:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bsiUbd/vDuPDnl7sEdaZyJkbZg+kaW5QRqCv78tgHDM=;
        b=GYEYC8qcPPFmQ52HDDIu4DivNGsVAVNW8o4YPnmZ7n/GyOoBw91riQGtfi6PnsJRJ1
         AB23JUfS2SAnya/q7Wu7gbIQOj/OHV4GV583VjJMqYI9drWTfxEVwEzPqS841ciKsutj
         51mBzmaDP5HrrRL9GbXjnLkF98A4swDKsZJQStTyz5om4JYrzK77xaQsLsQ/yxtX/UjS
         6Ew/W00h7Ela0mzkUY/wPcewZzN0zKo85DiL90++pjM0R3bUcLlVChPJEy+Zgmq+cK5d
         73bZBzM2dzfZaKM5OofxhIUQuXeC3pg+SiiIvHwtdyPna4lWlUowC2+1b/PTorIYKzs1
         RUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bsiUbd/vDuPDnl7sEdaZyJkbZg+kaW5QRqCv78tgHDM=;
        b=lFmpNdAxlYOAcaSEr/4Ee8W05FhbTTMhSwbKEpb4cw6+5Mx3bKAKIzjFh4uKMBAETw
         k24h7vcK9pduOyfFb6lHWbxrdbBpxdUrFLPGzxftvXC5F2eTeFFYN9cDeZuKBdmCgGTr
         tGoen+6kaGUJvhFJVzfRj9kX5xYQOOZN8TYcEHDnzuTP6jU+cmcUzhGBnkLUTGggi7Wt
         HX/xVy9QBInIuZ3/YGK5C6WtAKH/Kt8Qu9YrJ0objWkWleIKwFLE8HnP1XMI3+ltoSOZ
         Bo1BVR7sdRG8yUyPJGQYmha0k2V72ULkCNQ2p3fmUei8H+nqH8tHkdS/tDX9LSZawEww
         tawg==
X-Gm-Message-State: ACgBeo0ALlZ2Bs7O/Mfxh24zT7UNxvRBPPowzVwXpMiRva1bBv65lu8t
        DCvzAI2lIrQvBgKGby4Edds=
X-Google-Smtp-Source: AA6agR6il3c5AUGJNpCHtvZtYsJgb/hEDyGfySo/m3A5b87L+XS9qQPhbCPBJVZLb6lKr1MwBVP3pg==
X-Received: by 2002:aa7:941a:0:b0:52d:e57c:cf43 with SMTP id x26-20020aa7941a000000b0052de57ccf43mr7752613pfo.77.1659544858205;
        Wed, 03 Aug 2022 09:40:58 -0700 (PDT)
Received: from localhost (fwdproxy-prn-013.fbsv.net. [2a03:2880:ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id h23-20020a17090a055700b001f3162e4e55sm1842447pjf.35.2022.08.03.09.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:40:57 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next 3/6] net: Add UDP ULP operations, initialization and handling prototype functions.
Date:   Wed,  3 Aug 2022 09:40:42 -0700
Message-Id: <20220803164045.3585187-4-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803164045.3585187-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
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

Define functions to add UDP ULP handling, registration with UDP protocol
and supporting data structures. Create structure for QUIC ULP and add empty
prototype functions to support it.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
---
 include/net/inet_sock.h  |   2 +
 include/net/udp.h        |  33 +++++++
 include/uapi/linux/udp.h |   1 +
 net/Kconfig              |   1 +
 net/Makefile             |   1 +
 net/ipv4/Makefile        |   3 +-
 net/ipv4/udp.c           |   6 ++
 net/ipv4/udp_ulp.c       | 190 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 236 insertions(+), 1 deletion(-)
 create mode 100644 net/ipv4/udp_ulp.c

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 6395f6b9a5d2..e9c44b3ccffe 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -238,6 +238,8 @@ struct inet_sock {
 	__be32			mc_addr;
 	struct ip_mc_socklist __rcu	*mc_list;
 	struct inet_cork_full	cork;
+	const struct udp_ulp_ops	*udp_ulp_ops;
+	void __rcu		*ulp_data;
 };
 
 #define IPCORK_OPT	1	/* ip-options has been held in ipcork.opt */
diff --git a/include/net/udp.h b/include/net/udp.h
index 8dd4aa1485a6..f50011a20c92 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -523,4 +523,37 @@ struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
 int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 #endif
 
+/*
+ * Interface for adding Upper Level Protocols over UDP
+ */
+
+#define UDP_ULP_NAME_MAX	16
+#define UDP_ULP_MAX		128
+
+struct udp_ulp_ops {
+	struct list_head	list;
+
+	/* initialize ulp */
+	int (*init)(struct sock *sk);
+	/* cleanup ulp */
+	void (*release)(struct sock *sk);
+
+	char		name[UDP_ULP_NAME_MAX];
+	struct module	*owner;
+};
+
+int udp_register_ulp(struct udp_ulp_ops *type);
+void udp_unregister_ulp(struct udp_ulp_ops *type);
+int udp_set_ulp(struct sock *sk, const char *name);
+void udp_get_available_ulp(char *buf, size_t len);
+void udp_cleanup_ulp(struct sock *sk);
+int udp_setsockopt_ulp(struct sock *sk, sockptr_t optval,
+		       unsigned int optlen);
+int udp_getsockopt_ulp(struct sock *sk, char __user *optval,
+		       int __user *optlen);
+
+#define MODULE_ALIAS_UDP_ULP(name)\
+	__MODULE_INFO(alias, alias_userspace, name);\
+	__MODULE_INFO(alias, alias_udp_ulp, "udp-ulp-" name)
+
 #endif	/* _UDP_H */
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 0ee4c598e70b..893691f0108a 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -34,6 +34,7 @@ struct udphdr {
 #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
 #define UDP_SEGMENT	103	/* Set GSO segmentation size */
 #define UDP_GRO		104	/* This socket can receive UDP GRO packets */
+#define UDP_ULP		105	/* Attach ULP to a UDP socket */
 #define UDP_QUIC_ADD_TX_CONNECTION	106 /* Add QUIC Tx crypto offload */
 #define UDP_QUIC_DEL_TX_CONNECTION	107 /* Del QUIC Tx crypto offload */
 #define UDP_QUIC_ENCRYPT		108 /* QUIC encryption parameters */
diff --git a/net/Kconfig b/net/Kconfig
index 6b78f695caa6..93e3b1308aec 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -63,6 +63,7 @@ menu "Networking options"
 source "net/packet/Kconfig"
 source "net/unix/Kconfig"
 source "net/tls/Kconfig"
+source "net/quic/Kconfig"
 source "net/xfrm/Kconfig"
 source "net/iucv/Kconfig"
 source "net/smc/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index fbfeb8a0bb37..28565bfe29cb 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -16,6 +16,7 @@ obj-y				+= ethernet/ 802/ sched/ netlink/ bpf/ ethtool/
 obj-$(CONFIG_NETFILTER)		+= netfilter/
 obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_TLS)		+= tls/
+obj-$(CONFIG_QUIC)		+= quic/
 obj-$(CONFIG_XFRM)		+= xfrm/
 obj-$(CONFIG_UNIX_SCM)		+= unix/
 obj-y				+= ipv6/
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index bbdd9c44f14e..88d3baf4af95 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -14,7 +14,8 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     udp_offload.o arp.o icmp.o devinet.o af_inet.o igmp.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o \
-	     metrics.o netlink.o nexthop.o udp_tunnel_stub.o
+	     metrics.o netlink.o nexthop.o udp_tunnel_stub.o \
+	     udp_ulp.o
 
 obj-$(CONFIG_BPFILTER) += bpfilter/
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa9f2ec3dc46..e4a5f66b3141 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2778,6 +2778,9 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		up->pcflag |= UDPLITE_RECV_CC;
 		break;
 
+	case UDP_ULP:
+		return udp_setsockopt_ulp(sk, optval, optlen);
+
 	default:
 		err = -ENOPROTOOPT;
 		break;
@@ -2846,6 +2849,9 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->pcrlen;
 		break;
 
+	case UDP_ULP:
+		return udp_getsockopt_ulp(sk, optval, optlen);
+
 	default:
 		return -ENOPROTOOPT;
 	}
diff --git a/net/ipv4/udp_ulp.c b/net/ipv4/udp_ulp.c
new file mode 100644
index 000000000000..3801ed7ad17d
--- /dev/null
+++ b/net/ipv4/udp_ulp.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Pluggable UDP upper layer protocol support, based on pluggable TCP upper
+ * layer protocol support.
+ *
+ * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016-2017, Dave Watson <davejwatson@fb.com>. All rights reserved.
+ */
+
+#include <linux/gfp.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/skmsg.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+static DEFINE_SPINLOCK(udp_ulp_list_lock);
+static LIST_HEAD(udp_ulp_list);
+
+/* Simple linear search, don't expect many entries! */
+static struct udp_ulp_ops *udp_ulp_find(const char *name)
+{
+	struct udp_ulp_ops *e;
+
+	list_for_each_entry_rcu(e, &udp_ulp_list, list,
+				lockdep_is_held(&udp_ulp_list_lock)) {
+		if (strcmp(e->name, name) == 0)
+			return e;
+	}
+
+	return NULL;
+}
+
+static const struct udp_ulp_ops *__udp_ulp_find_autoload(const char *name)
+{
+	const struct udp_ulp_ops *ulp = NULL;
+
+	rcu_read_lock();
+	ulp = udp_ulp_find(name);
+
+#ifdef CONFIG_MODULES
+	if (!ulp && capable(CAP_NET_ADMIN)) {
+		rcu_read_unlock();
+		request_module("udp-ulp-%s", name);
+		rcu_read_lock();
+		ulp = udp_ulp_find(name);
+	}
+#endif
+	if (!ulp || !try_module_get(ulp->owner))
+		ulp = NULL;
+
+	rcu_read_unlock();
+	return ulp;
+}
+
+/* Attach new upper layer protocol to the list
+ * of available protocols.
+ */
+int udp_register_ulp(struct udp_ulp_ops *ulp)
+{
+	int ret = 0;
+
+	spin_lock(&udp_ulp_list_lock);
+	if (udp_ulp_find(ulp->name))
+		ret = -EEXIST;
+	else
+		list_add_tail_rcu(&ulp->list, &udp_ulp_list);
+
+	spin_unlock(&udp_ulp_list_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(udp_register_ulp);
+
+void udp_unregister_ulp(struct udp_ulp_ops *ulp)
+{
+	spin_lock(&udp_ulp_list_lock);
+	list_del_rcu(&ulp->list);
+	spin_unlock(&udp_ulp_list_lock);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(udp_unregister_ulp);
+
+void udp_cleanup_ulp(struct sock *sk)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	/* No sock_owned_by_me() check here as at the time the
+	 * stack calls this function, the socket is dead and
+	 * about to be destroyed.
+	 */
+	if (!inet->udp_ulp_ops)
+		return;
+
+	if (inet->udp_ulp_ops->release)
+		inet->udp_ulp_ops->release(sk);
+	module_put(inet->udp_ulp_ops->owner);
+
+	inet->udp_ulp_ops = NULL;
+}
+
+static int __udp_set_ulp(struct sock *sk, const struct udp_ulp_ops *ulp_ops)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	int err;
+
+	err = -EEXIST;
+	if (inet->udp_ulp_ops)
+		goto out_err;
+
+	err = ulp_ops->init(sk);
+	if (err)
+		goto out_err;
+
+	inet->udp_ulp_ops = ulp_ops;
+	return 0;
+
+out_err:
+	module_put(ulp_ops->owner);
+	return err;
+}
+
+int udp_set_ulp(struct sock *sk, const char *name)
+{
+	struct sk_psock *psock = sk_psock_get(sk);
+	const struct udp_ulp_ops *ulp_ops;
+
+	if (psock){
+		sk_psock_put(sk, psock);
+		return -EINVAL;
+	}
+
+	sock_owned_by_me(sk);
+	ulp_ops = __udp_ulp_find_autoload(name);
+	if (!ulp_ops)
+		return -ENOENT;
+
+	return __udp_set_ulp(sk, ulp_ops);
+}
+
+int udp_setsockopt_ulp(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	char name[UDP_ULP_NAME_MAX];
+	int val, err;
+
+	if (!optlen || optlen > UDP_ULP_NAME_MAX)
+		return -EINVAL;
+
+	val = strncpy_from_sockptr(name, optval, optlen);
+	if (val < 0)
+		return -EFAULT;
+
+	if (val == UDP_ULP_NAME_MAX)
+		return -EINVAL;
+
+	name[val] = 0;
+	lock_sock(sk);
+	err = udp_set_ulp(sk, name);
+	release_sock(sk);
+	return err;
+}
+
+int udp_getsockopt_ulp(struct sock *sk, char __user *optval, int __user *optlen)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	len = min_t(unsigned int, len, UDP_ULP_NAME_MAX);
+	if (len < 0)
+		return -EINVAL;
+
+	if (!inet->udp_ulp_ops) {
+		if (put_user(0, optlen))
+			return -EFAULT;
+		return 0;
+	}
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, inet->udp_ulp_ops->name, len))
+		return -EFAULT;
+
+	return 0;
+}
-- 
2.30.2

