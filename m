Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F341CC66B
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfJDXTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:49 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41937 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731387AbfJDXTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:49 -0400
Received: by mail-qk1-f194.google.com with SMTP id p10so7365128qkg.8
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TerU2gfNzio93w4tFn9guwsNAHFZKIhJdcV4fi72+BY=;
        b=iJ1mi9L3kxPDze+XW/zAy3XtSeHfixmbFUxVnSONHZ0AWKT0rbwkRtRuTVLuPA16vj
         vnWM2QfuInU9rS9lDsM/VNozV0rFvTu69wklqC2jut6HpZ883wC2zb/jBYIeytyyJD/L
         TrI4IyNXs4FcCgZSpeNTC8UJPSakN7MwUKYXWEqYrcakoCoKYvcNxOnBkNuVpReRfMV3
         jAD5aCNpUSXTqGjCBkZ5Y95CSlIe1dA/OBcYTkAFdA4uOdK8vK53jxai9kWqKvgTjewg
         17XDvXXe/gXM823eXRw69kprFbTODfcZ244InYg5Pa1Tpr+FyOOtGFT+qwUedyyPjupE
         ZB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TerU2gfNzio93w4tFn9guwsNAHFZKIhJdcV4fi72+BY=;
        b=I1Zq048vx9/i7v4L4KzxZZOBHa98+0ecv3JCUa8jSost88230JVGPthfX5NmDTYyAr
         g6igLjfxdYDOSFEYkYoLYosYkOy5fo0Sa2Nhn31pMbtnWCAbLVAGrz705FWPMWLoCa9b
         p0EILZiKAuZEtuW7gmOWcJp/mqicgxxcZvuVfXm6O9qKck1jNmXPKqOr5jkmAgJkSv/D
         yQZssijaILSxapD/W2nq0AiR6jXaZWXYnXOm5hEb+m38lQdeXUbgF3cjZqu11d3OYvFl
         s02LLHPTo3M6ya/XHlbGenVGM4v4xcnbP97YTAyF21QdWjdKH4nc9OL3JgNBDug6P8At
         iTPg==
X-Gm-Message-State: APjAAAUT9s+XNrQx3qjWL+UAR3AHMVsv/lPXkC//92vsyUy6k1/8QNO4
        KaDEC7fb+jt8laI/sk5hFPuTJg==
X-Google-Smtp-Source: APXvYqyYcBZIKglRFmyQBlRIXrpGA/sOxoYqvlbEOnuqafz/RLJ7j/difi9OYH5jhU9cmbkV32FWPA==
X-Received: by 2002:a37:a704:: with SMTP id q4mr2257869qke.385.1570231187393;
        Fri, 04 Oct 2019 16:19:47 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:46 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 3/6] net/tls: add skeleton of MIB statistics
Date:   Fri,  4 Oct 2019 16:19:24 -0700
Message-Id: <20191004231927.21134-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a skeleton structure for adding TLS statistics.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls.rst |  6 ++++++
 include/net/netns/mib.h          |  3 +++
 include/net/snmp.h               |  6 ++++++
 include/net/tls.h                | 13 +++++++++++
 include/uapi/linux/snmp.h        |  7 ++++++
 net/tls/Makefile                 |  2 +-
 net/tls/tls_main.c               | 37 ++++++++++++++++++++++++++++++++
 net/tls/tls_proc.c               | 37 ++++++++++++++++++++++++++++++++
 8 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 net/tls/tls_proc.c

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index 5bcbf75e2025..a6ee595630ed 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -213,3 +213,9 @@ A patchset to OpenSSL to use ktls as the record layer is
 of calling send directly after a handshake using gnutls.
 Since it doesn't implement a full record layer, control
 messages are not supported.
+
+Statistics
+==========
+
+TLS implementation exposes the following per-namespace statistics
+(``/proc/net/tls_stat``):
diff --git a/include/net/netns/mib.h b/include/net/netns/mib.h
index 830bdf345b17..b5fdb108d602 100644
--- a/include/net/netns/mib.h
+++ b/include/net/netns/mib.h
@@ -24,6 +24,9 @@ struct netns_mib {
 #ifdef CONFIG_XFRM_STATISTICS
 	DEFINE_SNMP_STAT(struct linux_xfrm_mib, xfrm_statistics);
 #endif
+#if IS_ENABLED(CONFIG_TLS)
+	DEFINE_SNMP_STAT(struct linux_tls_mib, tls_statistics);
+#endif
 };
 
 #endif
diff --git a/include/net/snmp.h b/include/net/snmp.h
index cb8ced4380a6..468a67836e2f 100644
--- a/include/net/snmp.h
+++ b/include/net/snmp.h
@@ -111,6 +111,12 @@ struct linux_xfrm_mib {
 	unsigned long	mibs[LINUX_MIB_XFRMMAX];
 };
 
+/* Linux TLS */
+#define LINUX_MIB_TLSMAX	__LINUX_MIB_TLSMAX
+struct linux_tls_mib {
+	unsigned long	mibs[LINUX_MIB_TLSMAX];
+};
+
 #define DEFINE_SNMP_STAT(type, name)	\
 	__typeof__(type) __percpu *name
 #define DEFINE_SNMP_STAT_ATOMIC(type, name)	\
diff --git a/include/net/tls.h b/include/net/tls.h
index 38086ade65ce..24c37bffc961 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -43,6 +43,7 @@
 #include <linux/netdevice.h>
 #include <linux/rcupdate.h>
 
+#include <net/net_namespace.h>
 #include <net/tcp.h>
 #include <net/strparser.h>
 #include <crypto/aead.h>
@@ -73,6 +74,15 @@
  */
 #define TLS_AES_CCM_IV_B0_BYTE		2
 
+#define __TLS_INC_STATS(net, field)				\
+	__SNMP_INC_STATS((net)->mib.tls_statistics, field)
+#define TLS_INC_STATS(net, field)				\
+	SNMP_INC_STATS((net)->mib.tls_statistics, field)
+#define __TLS_DEC_STATS(net, field)				\
+	__SNMP_DEC_STATS((net)->mib.tls_statistics, field)
+#define TLS_DEC_STATS(net, field)				\
+	SNMP_DEC_STATS((net)->mib.tls_statistics, field)
+
 enum {
 	TLS_BASE,
 	TLS_SW,
@@ -605,6 +615,9 @@ static inline bool tls_offload_tx_resync_pending(struct sock *sk)
 	return ret;
 }
 
+int __net_init tls_proc_init(struct net *net);
+void __net_exit tls_proc_fini(struct net *net);
+
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 549a31c29f7d..4abd57948ad4 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -323,4 +323,11 @@ enum
 	__LINUX_MIB_XFRMMAX
 };
 
+/* linux TLS mib definitions */
+enum
+{
+	LINUX_MIB_TLSNUM = 0,
+	__LINUX_MIB_TLSMAX
+};
+
 #endif	/* _LINUX_SNMP_H */
diff --git a/net/tls/Makefile b/net/tls/Makefile
index 0606d43d7582..f1ffbfe8968d 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o trace.o
+tls-y := tls_main.o tls_sw.o tls_proc.o trace.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 237e58e4928a..686eba0df590 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -41,6 +41,7 @@
 #include <linux/inetdevice.h>
 #include <linux/inet_diag.h>
 
+#include <net/snmp.h>
 #include <net/tls.h>
 #include <net/tls_toe.h>
 
@@ -795,6 +796,35 @@ static size_t tls_get_info_size(const struct sock *sk)
 	return size;
 }
 
+static int __net_init tls_init_net(struct net *net)
+{
+	int err;
+
+	net->mib.tls_statistics = alloc_percpu(struct linux_tls_mib);
+	if (!net->mib.tls_statistics)
+		return -ENOMEM;
+
+	err = tls_proc_init(net);
+	if (err)
+		goto err_free_stats;
+
+	return 0;
+err_free_stats:
+	free_percpu(net->mib.tls_statistics);
+	return err;
+}
+
+static void __net_exit tls_exit_net(struct net *net)
+{
+	tls_proc_fini(net);
+	free_percpu(net->mib.tls_statistics);
+}
+
+static struct pernet_operations tls_proc_ops = {
+	.init = tls_init_net,
+	.exit = tls_exit_net,
+};
+
 static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
 	.owner			= THIS_MODULE,
@@ -806,6 +836,12 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 
 static int __init tls_register(void)
 {
+	int err;
+
+	err = register_pernet_subsys(&tls_proc_ops);
+	if (err)
+		return err;
+
 	tls_sw_proto_ops = inet_stream_ops;
 	tls_sw_proto_ops.splice_read = tls_sw_splice_read;
 
@@ -819,6 +855,7 @@ static void __exit tls_unregister(void)
 {
 	tcp_unregister_ulp(&tcp_tls_ulp_ops);
 	tls_device_cleanup();
+	unregister_pernet_subsys(&tls_proc_ops);
 }
 
 module_init(tls_register);
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
new file mode 100644
index 000000000000..4ecc7c35d2f7
--- /dev/null
+++ b/net/tls/tls_proc.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <net/snmp.h>
+#include <net/tls.h>
+
+static const struct snmp_mib tls_mib_list[] = {
+	SNMP_MIB_SENTINEL
+};
+
+static int tls_statistics_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned long buf[LINUX_MIB_TLSMAX] = {};
+	struct net *net = seq->private;
+	int i;
+
+	snmp_get_cpu_field_batch(buf, tls_mib_list, net->mib.tls_statistics);
+	for (i = 0; tls_mib_list[i].name; i++)
+		seq_printf(seq, "%-32s\t%lu\n", tls_mib_list[i].name, buf[i]);
+
+	return 0;
+}
+
+int __net_init tls_proc_init(struct net *net)
+{
+	if (!proc_create_net_single("tls_stat", 0444, net->proc_net,
+				    tls_statistics_seq_show, NULL))
+		return -ENOMEM;
+	return 0;
+}
+
+void __net_exit tls_proc_fini(struct net *net)
+{
+	remove_proc_entry("tls_stat", net->proc_net);
+}
-- 
2.21.0

