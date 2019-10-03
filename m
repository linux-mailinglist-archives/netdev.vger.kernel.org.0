Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAFDCAE0D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbfJCSTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:50 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46341 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387866AbfJCSTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:46 -0400
Received: by mail-qt1-f196.google.com with SMTP id u22so4879080qtq.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUpHVL3k9nXEj/atCjrfVz2w2smZQzq3cOO4fsLENz8=;
        b=SuMyLF+iFRUjyWid7nW8oQ8sAwdh66BTl1ojlz/hnTc1DsoVuoqaLCDO8+YwCD0GdT
         PwJcbAD4rabKGsNNXDASRbjNX6pETLx6mGTaJ2PojTYXYPo4OO//agOnogTQUddcDlxv
         muvG8bTfcgcqxzYlZDSzjpdgsVJk7O0JhCi7qh9/K18vYvpZO59DVusdjS5Ad40wKl/X
         m/FVPCDb60+nWwmGbpwMEJnee1+iUcQt4kFGv1M2FeFCdZ17Hsp93hTe0Fi1ebPo550p
         t7u2l6xu9buu0kocTYhnA0U2+lzHbUXiZaCUju41vU5BaUVGkhGjiryCiqShA6TgsNXS
         iWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUpHVL3k9nXEj/atCjrfVz2w2smZQzq3cOO4fsLENz8=;
        b=SF7atl87bd+cc/I2ugDbXvcJDhR+6xrsq9PREw3HxE3fUuviDwLhO5hWTCKIozTtPi
         5j5LUjlfmFuuyB7uMxhLPVkrCGjdPDgaD1+w1Rtg0zL6HTARKsyaOR8ry5d21wvcwgLR
         Mi5ilZ8KAmGolVwdP/D/VN1YxSjx6Ixhc47erP9/3iXUvqgjHfeS1X/+LR8QmMO1pKiB
         qVVtalQPX0FfkRYe5mC+jYDACDpqcPNlKq23Kwqw6lXc2CXlT/RTWzrXkJlhhWIglJ0M
         FYTQLJj/8VLa5dZReRufkc0DbuzHN5rcluVIqpdGbVs5zCQA2acuvoGawBq+zMhW7cRX
         SY2w==
X-Gm-Message-State: APjAAAXpzxZbbU/X7IREZOCUxjf8ev+z2ROp8JULd0bOdnVJ+KuJgYri
        38goVsMIIME2XGzsdqPRKvKUyg==
X-Google-Smtp-Source: APXvYqw84C79M+WhAVvl05i/fgcdtPYeNrM7zi+CoA57fJtxog/orMC/kdSh6oAjZc4bsaP303qdfQ==
X-Received: by 2002:aed:2da4:: with SMTP id i33mr11078543qtd.320.1570126785053;
        Thu, 03 Oct 2019 11:19:45 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:44 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 4/6] net/tls: move TOE-related code to a separate file
Date:   Thu,  3 Oct 2019 11:18:57 -0700
Message-Id: <20191003181859.24958-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tls_hw_* functions to a new, separate source file
to avoid confusion with normal, non-TOE offload.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls.h     |   3 +
 include/net/tls_toe.h |   4 ++
 net/tls/Makefile      |   2 +-
 net/tls/tls_main.c    | 105 +------------------------------
 net/tls/tls_toe.c     | 139 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 150 insertions(+), 103 deletions(-)
 create mode 100644 net/tls/tls_toe.c

diff --git a/include/net/tls.h b/include/net/tls.h
index 57865c944095..5c48cb9e0c18 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -308,7 +308,10 @@ struct tls_offload_context_rx {
 #define TLS_OFFLOAD_CONTEXT_SIZE_RX					\
 	(sizeof(struct tls_offload_context_rx) + TLS_DRIVER_STATE_SIZE_RX)
 
+struct tls_context *tls_ctx_create(struct sock *sk);
 void tls_ctx_free(struct sock *sk, struct tls_context *ctx);
+void update_sk_prot(struct sock *sk, struct tls_context *ctx);
+
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
diff --git a/include/net/tls_toe.h b/include/net/tls_toe.h
index b56d30a5bd6d..3bb39c795aed 100644
--- a/include/net/tls_toe.h
+++ b/include/net/tls_toe.h
@@ -69,5 +69,9 @@ struct tls_toe_device {
 	struct kref kref;
 };
 
+int tls_hw_prot(struct sock *sk);
+int tls_hw_hash(struct sock *sk);
+void tls_hw_unhash(struct sock *sk);
+
 void tls_toe_register_device(struct tls_toe_device *device);
 void tls_toe_unregister_device(struct tls_toe_device *device);
diff --git a/net/tls/Makefile b/net/tls/Makefile
index ef0dc74ce8f9..322250e912db 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -5,6 +5,6 @@
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o
+tls-y := tls_main.o tls_sw.o tls_toe.o
 
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7bc2ad26316f..9d0cf14b2f7e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -59,14 +59,12 @@ static struct proto *saved_tcpv6_prot;
 static DEFINE_MUTEX(tcpv6_prot_mutex);
 static struct proto *saved_tcpv4_prot;
 static DEFINE_MUTEX(tcpv4_prot_mutex);
-static LIST_HEAD(device_list);
-static DEFINE_SPINLOCK(device_spinlock);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
 static struct proto_ops tls_sw_proto_ops;
 static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 			 struct proto *base);
 
-static void update_sk_prot(struct sock *sk, struct tls_context *ctx)
+void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
 
@@ -604,7 +602,7 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
 	return do_tls_setsockopt(sk, optname, optval, optlen);
 }
 
-static struct tls_context *create_ctx(struct sock *sk)
+struct tls_context *tls_ctx_create(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tls_context *ctx;
@@ -644,87 +642,6 @@ static void tls_build_proto(struct sock *sk)
 	}
 }
 
-static void tls_hw_sk_destruct(struct sock *sk)
-{
-	struct tls_context *ctx = tls_get_ctx(sk);
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	ctx->sk_destruct(sk);
-	/* Free ctx */
-	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
-	tls_ctx_free(sk, ctx);
-}
-
-static int tls_hw_prot(struct sock *sk)
-{
-	struct tls_toe_device *dev;
-	struct tls_context *ctx;
-	int rc = 0;
-
-	spin_lock_bh(&device_spinlock);
-	list_for_each_entry(dev, &device_list, dev_list) {
-		if (dev->feature && dev->feature(dev)) {
-			ctx = create_ctx(sk);
-			if (!ctx)
-				goto out;
-
-			ctx->sk_destruct = sk->sk_destruct;
-			sk->sk_destruct = tls_hw_sk_destruct;
-			ctx->rx_conf = TLS_HW_RECORD;
-			ctx->tx_conf = TLS_HW_RECORD;
-			update_sk_prot(sk, ctx);
-			rc = 1;
-			break;
-		}
-	}
-out:
-	spin_unlock_bh(&device_spinlock);
-	return rc;
-}
-
-static void tls_hw_unhash(struct sock *sk)
-{
-	struct tls_context *ctx = tls_get_ctx(sk);
-	struct tls_toe_device *dev;
-
-	spin_lock_bh(&device_spinlock);
-	list_for_each_entry(dev, &device_list, dev_list) {
-		if (dev->unhash) {
-			kref_get(&dev->kref);
-			spin_unlock_bh(&device_spinlock);
-			dev->unhash(dev, sk);
-			kref_put(&dev->kref, dev->release);
-			spin_lock_bh(&device_spinlock);
-		}
-	}
-	spin_unlock_bh(&device_spinlock);
-	ctx->sk_proto->unhash(sk);
-}
-
-static int tls_hw_hash(struct sock *sk)
-{
-	struct tls_context *ctx = tls_get_ctx(sk);
-	struct tls_toe_device *dev;
-	int err;
-
-	err = ctx->sk_proto->hash(sk);
-	spin_lock_bh(&device_spinlock);
-	list_for_each_entry(dev, &device_list, dev_list) {
-		if (dev->hash) {
-			kref_get(&dev->kref);
-			spin_unlock_bh(&device_spinlock);
-			err |= dev->hash(dev, sk);
-			kref_put(&dev->kref, dev->release);
-			spin_lock_bh(&device_spinlock);
-		}
-	}
-	spin_unlock_bh(&device_spinlock);
-
-	if (err)
-		tls_hw_unhash(sk);
-	return err;
-}
-
 static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 			 struct proto *base)
 {
@@ -789,7 +706,7 @@ static int tls_init(struct sock *sk)
 
 	/* allocate tls context */
 	write_lock_bh(&sk->sk_callback_lock);
-	ctx = create_ctx(sk);
+	ctx = tls_ctx_create(sk);
 	if (!ctx) {
 		rc = -ENOMEM;
 		goto out;
@@ -875,22 +792,6 @@ static size_t tls_get_info_size(const struct sock *sk)
 	return size;
 }
 
-void tls_toe_register_device(struct tls_toe_device *device)
-{
-	spin_lock_bh(&device_spinlock);
-	list_add_tail(&device->dev_list, &device_list);
-	spin_unlock_bh(&device_spinlock);
-}
-EXPORT_SYMBOL(tls_toe_register_device);
-
-void tls_toe_unregister_device(struct tls_toe_device *device)
-{
-	spin_lock_bh(&device_spinlock);
-	list_del(&device->dev_list);
-	spin_unlock_bh(&device_spinlock);
-}
-EXPORT_SYMBOL(tls_toe_unregister_device);
-
 static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
 	.owner			= THIS_MODULE,
diff --git a/net/tls/tls_toe.c b/net/tls/tls_toe.c
new file mode 100644
index 000000000000..89a7014a05f7
--- /dev/null
+++ b/net/tls/tls_toe.c
@@ -0,0 +1,139 @@
+/*
+ * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016-2017, Dave Watson <davejwatson@fb.com>. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+#include <net/inet_connection_sock.h>
+#include <net/tls.h>
+#include <net/tls_toe.h>
+
+static LIST_HEAD(device_list);
+static DEFINE_SPINLOCK(device_spinlock);
+
+static void tls_hw_sk_destruct(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tls_context *ctx = tls_get_ctx(sk);
+
+	ctx->sk_destruct(sk);
+	/* Free ctx */
+	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
+	tls_ctx_free(sk, ctx);
+}
+
+int tls_hw_prot(struct sock *sk)
+{
+	struct tls_toe_device *dev;
+	struct tls_context *ctx;
+	int rc = 0;
+
+	spin_lock_bh(&device_spinlock);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->feature && dev->feature(dev)) {
+			ctx = tls_ctx_create(sk);
+			if (!ctx)
+				goto out;
+
+			ctx->sk_destruct = sk->sk_destruct;
+			sk->sk_destruct = tls_hw_sk_destruct;
+			ctx->rx_conf = TLS_HW_RECORD;
+			ctx->tx_conf = TLS_HW_RECORD;
+			update_sk_prot(sk, ctx);
+			rc = 1;
+			break;
+		}
+	}
+out:
+	spin_unlock_bh(&device_spinlock);
+	return rc;
+}
+
+void tls_hw_unhash(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_toe_device *dev;
+
+	spin_lock_bh(&device_spinlock);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->unhash) {
+			kref_get(&dev->kref);
+			spin_unlock_bh(&device_spinlock);
+			dev->unhash(dev, sk);
+			kref_put(&dev->kref, dev->release);
+			spin_lock_bh(&device_spinlock);
+		}
+	}
+	spin_unlock_bh(&device_spinlock);
+	ctx->sk_proto->unhash(sk);
+}
+
+int tls_hw_hash(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_toe_device *dev;
+	int err;
+
+	err = ctx->sk_proto->hash(sk);
+	spin_lock_bh(&device_spinlock);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->hash) {
+			kref_get(&dev->kref);
+			spin_unlock_bh(&device_spinlock);
+			err |= dev->hash(dev, sk);
+			kref_put(&dev->kref, dev->release);
+			spin_lock_bh(&device_spinlock);
+		}
+	}
+	spin_unlock_bh(&device_spinlock);
+
+	if (err)
+		tls_hw_unhash(sk);
+	return err;
+}
+
+void tls_toe_register_device(struct tls_toe_device *device)
+{
+	spin_lock_bh(&device_spinlock);
+	list_add_tail(&device->dev_list, &device_list);
+	spin_unlock_bh(&device_spinlock);
+}
+EXPORT_SYMBOL(tls_toe_register_device);
+
+void tls_toe_unregister_device(struct tls_toe_device *device)
+{
+	spin_lock_bh(&device_spinlock);
+	list_del(&device->dev_list);
+	spin_unlock_bh(&device_spinlock);
+}
+EXPORT_SYMBOL(tls_toe_unregister_device);
-- 
2.21.0

