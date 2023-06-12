Return-Path: <netdev+bounces-10197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1DB72CC62
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B4331C20B50
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976452260D;
	Mon, 12 Jun 2023 17:23:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C1821CFB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:17 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B849B2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-651e298be0aso2596452b3a.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590595; x=1689182595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PIJi+YaipsBqXx9Jn519PmEfcm6UsBy0hXGpFTQSxa0=;
        b=Q9gQPtZnpP4Lg8G/Hfh00v+xgId8RFOBZEXFS9J93Xo2PWq2Zamz/qyXckGdQp0T91
         gzisalXdK2EqtU865ZpLTAPZnQeAdrnzNSjqPSMwTX2gWd1CISUffMMCksHe5D1A9YU6
         B0Dt7aIIBU7eFDqcXxNk6OpbeCAyu0VohmXMKmqrsJvJggYTykORnZzX11+bEhnazrhZ
         w5baAROukc7pEV63XRoruQrsk9+e+KLmTZK0uednJonBHoTahirMrRY3fwd3qDIEsJt2
         MdBesAIm20GZgrCgHtzC7MQLw8ymZ0eYL6Cx50Xt9ufJRnNfQEHoWYLjV97RF1cz52gh
         U/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590595; x=1689182595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIJi+YaipsBqXx9Jn519PmEfcm6UsBy0hXGpFTQSxa0=;
        b=iKfxOPA+EK1CsC1LHHAFBegkV84hrkakS+3Zbq/4qhXnTes2TP8TGt4aLVUXWQOlEv
         Yig/ZjOY8WrMabGfbPjsTf6Bj8NQz2StpSMZm8GBHmboWEziz1iUMZaRmWabkEpCgHj7
         SElU85aTBUpLGnm17mpB4GsIv5eK2tRNNAonkTFiC6YICGy6SCTehF7637MTSEA8ZwA1
         w+f3DiKIAyx10Yw9bnSlANl90Rb8fNfKjpX6hVnas83P76DLmgssA8TPRaXixAD/0I+t
         naZ7EoAWzh31jwMUbP6FmlKKVdeViiWIKVYp7zMzbgDTPt9ggjdsLUoRL5+kUBYlh+qn
         qWpg==
X-Gm-Message-State: AC+VfDz6OaqeCDnSqQaQ12BCiIwhVJ8WoC6FIP1ILXzavOroaDyyhpFt
	82iRQTzYfPhApHIOjaIuDtVfWwg=
X-Google-Smtp-Source: ACHHUZ5OvXDyWAez+dzRc+UAzo44mIDfjoWrK4ycPztDNKvr+BddKBvufx4U9eLykvv4HGyjeajcvQU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:18a1:b0:654:8eb9:4607 with SMTP id
 x33-20020a056a0018a100b006548eb94607mr3157117pfh.4.1686590595480; Mon, 12 Jun
 2023 10:23:15 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:04 -0700
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-5-sdf@google.com>
Subject: [RFC bpf-next 4/7] bpf: implement devtx timestamp kfunc
From: Stanislav Fomichev <sdf@google.com>
To: bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Two kfuncs, one per hook point:

1. at submit time - bpf_devtx_sb_request_timestamp - to request HW
   to put TX timestamp into TX completion descriptors

2. at completion time - bpf_devtx_cp_timestamp - to read out
   TX timestamp

Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/netdevice.h |  4 +++
 include/net/offload.h     | 10 +++++++
 kernel/bpf/offload.c      |  8 ++++++
 net/core/devtx.c          | 58 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e08e3fd39dfc..6e42e62fd1bc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1651,10 +1651,14 @@ struct net_device_ops {
 						  bool cycles);
 };
 
+struct devtx_frame;
+
 struct xdp_metadata_ops {
 	int	(*xmo_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
 	int	(*xmo_rx_hash)(const struct xdp_md *ctx, u32 *hash,
 			       enum xdp_rss_hash_type *rss_type);
+	int	(*xmo_sb_request_timestamp)(const struct devtx_frame *ctx);
+	int	(*xmo_cp_timestamp)(const struct devtx_frame *ctx, u64 *timestamp);
 };
 
 /**
diff --git a/include/net/offload.h b/include/net/offload.h
index 264a35881473..36899b64f4c8 100644
--- a/include/net/offload.h
+++ b/include/net/offload.h
@@ -10,9 +10,19 @@
 	NETDEV_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
 			      bpf_xdp_metadata_rx_hash)
 
+#define DEVTX_SB_KFUNC_xxx	\
+	NETDEV_METADATA_KFUNC(DEVTX_SB_KFUNC_REQUEST_TIMESTAMP, \
+			      bpf_devtx_sb_request_timestamp)
+
+#define DEVTX_CP_KFUNC_xxx	\
+	NETDEV_METADATA_KFUNC(DEVTX_CP_KFUNC_TIMESTAMP, \
+			      bpf_devtx_cp_timestamp)
+
 enum {
 #define NETDEV_METADATA_KFUNC(name, _) name,
 XDP_METADATA_KFUNC_xxx
+DEVTX_SB_KFUNC_xxx
+DEVTX_CP_KFUNC_xxx
 #undef NETDEV_METADATA_KFUNC
 MAX_NETDEV_METADATA_KFUNC,
 };
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 9cfe96422c80..91dc7b7e3684 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -854,6 +854,10 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
 		p = ops->xmo_rx_timestamp;
 	else if (func_id == bpf_dev_bound_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
 		p = ops->xmo_rx_hash;
+	else if (func_id == bpf_dev_bound_kfunc_id(DEVTX_SB_KFUNC_REQUEST_TIMESTAMP))
+		p = ops->xmo_sb_request_timestamp;
+	else if (func_id == bpf_dev_bound_kfunc_id(DEVTX_CP_KFUNC_TIMESTAMP))
+		p = ops->xmo_cp_timestamp;
 out:
 	up_read(&bpf_devs_lock);
 
@@ -863,12 +867,16 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
 BTF_SET_START(dev_bound_kfunc_ids)
 #define NETDEV_METADATA_KFUNC(name, str) BTF_ID(func, str)
 XDP_METADATA_KFUNC_xxx
+DEVTX_SB_KFUNC_xxx
+DEVTX_CP_KFUNC_xxx
 #undef NETDEV_METADATA_KFUNC
 BTF_SET_END(dev_bound_kfunc_ids)
 
 BTF_ID_LIST(dev_bound_kfunc_ids_unsorted)
 #define NETDEV_METADATA_KFUNC(name, str) BTF_ID(func, str)
 XDP_METADATA_KFUNC_xxx
+DEVTX_SB_KFUNC_xxx
+DEVTX_CP_KFUNC_xxx
 #undef NETDEV_METADATA_KFUNC
 
 u32 bpf_dev_bound_kfunc_id(int id)
diff --git a/net/core/devtx.c b/net/core/devtx.c
index b7cbc26d1c01..2b37c31f0912 100644
--- a/net/core/devtx.c
+++ b/net/core/devtx.c
@@ -162,6 +162,30 @@ __bpf_kfunc int bpf_devtx_cp_attach(int ifindex, int prog_fd)
 	return ret;
 }
 
+/**
+ * bpf_devtx_sb_request_timestamp - Request TX timestamp on the packet.
+ * Callable only from the devtx-submit hook.
+ * @ctx: devtx context pointer.
+ *
+ * Returns 0 on success or ``-errno`` on error.
+ */
+__bpf_kfunc int bpf_devtx_sb_request_timestamp(const struct devtx_frame *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+/**
+ * bpf_devtx_cp_timestamp - Read TX timestamp of the packet. Callable
+ * only from the devtx-complete hook.
+ * @ctx: devtx context pointer.
+ *
+ * Returns 0 on success or ``-errno`` on error.
+ */
+__bpf_kfunc int bpf_devtx_cp_timestamp(const struct devtx_frame *ctx, __u64 *timestamp)
+{
+	return -EOPNOTSUPP;
+}
+
 __diag_pop();
 
 bool is_devtx_kfunc(u32 kfunc_id)
@@ -187,6 +211,28 @@ static const struct btf_kfunc_id_set bpf_devtx_syscall_kfunc_set = {
 	.set   = &bpf_devtx_syscall_kfunc_ids,
 };
 
+BTF_SET8_START(devtx_sb_kfunc_ids)
+#define NETDEV_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
+DEVTX_SB_KFUNC_xxx
+#undef NETDEV_METADATA_KFUNC
+BTF_SET8_END(devtx_sb_kfunc_ids)
+
+static const struct btf_kfunc_id_set devtx_sb_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &devtx_sb_kfunc_ids,
+};
+
+BTF_SET8_START(devtx_cp_kfunc_ids)
+#define NETDEV_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
+DEVTX_CP_KFUNC_xxx
+#undef NETDEV_METADATA_KFUNC
+BTF_SET8_END(devtx_cp_kfunc_ids)
+
+static const struct btf_kfunc_id_set devtx_cp_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &devtx_cp_kfunc_ids,
+};
+
 static int __init devtx_init(void)
 {
 	int ret;
@@ -197,6 +243,18 @@ static int __init devtx_init(void)
 		return ret;
 	}
 
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &devtx_sb_kfunc_set);
+	if (ret) {
+		pr_warn("failed to register devtx_sb kfuncs: %d", ret);
+		return ret;
+	}
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &devtx_cp_kfunc_set);
+	if (ret) {
+		pr_warn("failed to register devtx_cp completion kfuncs: %d", ret);
+		return ret;
+	}
+
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_devtx_syscall_kfunc_set);
 	if (ret) {
 		pr_warn("failed to register syscall kfuncs: %d", ret);
-- 
2.41.0.162.gfafddb0af9-goog


