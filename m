Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B9C21DF0D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgGMRrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgGMRrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D10C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:17 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so18955465ljn.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HcHBwnvbK/ZEAWghrBP98aUipgfIWV3+AoVVPtvwDmA=;
        b=Ujiga2PpuLTYAiGTA+OvFxcvBO+K2VeA1yHrIaOaI/+x2hfQgL20SemEkb6oEloW4u
         ZpnOGIukTzqtjn7hcc4m1J5fS+84DMc8vOUEsHSfrY0GN5za/BJa0PxRo3GOeUhF/KId
         RKZOpQw8p27cf5ql6Nc1s+RE1a9DYGV7UNrVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HcHBwnvbK/ZEAWghrBP98aUipgfIWV3+AoVVPtvwDmA=;
        b=NqsNv+Tv7nZtT7E1t9ZOBPjMftaIr7Ekn7i9Uop/nMaQ5ND3np092WJpmjhzRgRY+X
         MuOuuN4ia5uuGhTU0CEHppe94LbU4QqF6m2etuS3YiU8vR8uKLZ8XD6FKMU78PppQKv6
         Ilj7Dlf30NQFIOgl0wotCJCWv8Qjtm8k37lIEKQc9VpE6QKUAezX70+/XjGQNsNv64Ev
         iHqkTiJspFwQS1jHM0jlgEGEbkdv3rU0nU4zzfg4iyQIIgi9xNUVW3tzt9nqXpFql0d7
         y9G+wFLNcco9PuQwf4WSiLNlj+DS5iEhOeqUia4R8vj8LJvPvGKMGTCaiqjzCZwtbYGp
         ZiJg==
X-Gm-Message-State: AOAM533POhlu12Q6y1cnuisQg1YXviCv/wRXc4k8qsZZbXonXMMtq9S/
        lUFblN6ute17pHSux+1jdBAvaA==
X-Google-Smtp-Source: ABdhPJwQ9wQS9/jXKGvkcYbCaq2AMZikKQvOmFSJ7Tr+RFkFuc64s8+zqiyK9UNWy2q7FatnmHJPYw==
X-Received: by 2002:a2e:8992:: with SMTP id c18mr380078lji.388.1594662436085;
        Mon, 13 Jul 2020 10:47:16 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id f13sm4762032lfs.29.2020.07.13.10.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:15 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 11/16] bpf: Sync linux/bpf.h to tools/
Date:   Mon, 13 Jul 2020 19:46:49 +0200
Message-Id: <20200713174654.642628-12-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newly added program, context type and helper is used by tests in a
subsequent patch. Synchronize the header file.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v4:
    - Update after changes to bpf.h in earlier patch.
    
    v3:
    - Update after changes to bpf.h in earlier patch.
    
    v2:
    - Update after changes to bpf.h in earlier patch.

 tools/include/uapi/linux/bpf.h | 77 ++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 548a749aebb3..e2ffeb150d0f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -189,6 +189,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_STRUCT_OPS,
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
+	BPF_PROG_TYPE_SK_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -227,6 +228,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
 	BPF_CGROUP_INET_SOCK_RELEASE,
+	BPF_SK_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3068,6 +3070,10 @@ union bpf_attr {
  *
  * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
  *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
+ *		**BPF_PROG_TYPE_SCHED_ACT** programs.
+ *
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
  *		will cause *skb* to be delivered to the specified socket.
@@ -3093,6 +3099,56 @@ union bpf_attr {
  *		**-ESOCKTNOSUPPORT** if the socket type is not supported
  *		(reuseport).
  *
+ * long bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
+ *
+ *		Select the *sk* as a result of a socket lookup.
+ *
+ *		For the operation to succeed passed socket must be compatible
+ *		with the packet description provided by the *ctx* object.
+ *
+ *		L4 protocol (**IPPROTO_TCP** or **IPPROTO_UDP**) must
+ *		be an exact match. While IP family (**AF_INET** or
+ *		**AF_INET6**) must be compatible, that is IPv6 sockets
+ *		that are not v6-only can be selected for IPv4 packets.
+ *
+ *		Only TCP listeners and UDP unconnected sockets can be
+ *		selected. *sk* can also be NULL to reset any previous
+ *		selection.
+ *
+ *		*flags* argument can combination of following values:
+ *
+ *		* **BPF_SK_LOOKUP_F_REPLACE** to override the previous
+ *		  socket selection, potentially done by a BPF program
+ *		  that ran before us.
+ *
+ *		* **BPF_SK_LOOKUP_F_NO_REUSEPORT** to skip
+ *		  load-balancing within reuseport group for the socket
+ *		  being selected.
+ *
+ *		On success *ctx->sk* will point to the selected socket.
+ *
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EAFNOSUPPORT** if socket family (*sk->family*) is
+ *		  not compatible with packet family (*ctx->family*).
+ *
+ *		* **-EEXIST** if socket has been already selected,
+ *		  potentially by another program, and
+ *		  **BPF_SK_LOOKUP_F_REPLACE** flag was not specified.
+ *
+ *		* **-EINVAL** if unsupported flags were specified.
+ *
+ *		* **-EPROTOTYPE** if socket L4 protocol
+ *		  (*sk->protocol*) doesn't match packet protocol
+ *		  (*ctx->protocol*).
+ *
+ *		* **-ESOCKTNOSUPPORT** if socket is not in allowed
+ *		  state (TCP listening or UDP unconnected).
+ *
  * u64 bpf_ktime_get_boot_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
@@ -3605,6 +3661,12 @@ enum {
 	BPF_RINGBUF_HDR_SZ		= 8,
 };
 
+/* BPF_FUNC_sk_assign flags in bpf_sk_lookup context. */
+enum {
+	BPF_SK_LOOKUP_F_REPLACE		= (1ULL << 0),
+	BPF_SK_LOOKUP_F_NO_REUSEPORT	= (1ULL << 1),
+};
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
@@ -4334,4 +4396,19 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
+struct bpf_sk_lookup {
+	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+
+	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
+	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
+	__u32 remote_ip4;	/* Network byte order */
+	__u32 remote_ip6[4];	/* Network byte order */
+	__u32 remote_port;	/* Network byte order */
+	__u32 local_ip4;	/* Network byte order */
+	__u32 local_ip6[4];	/* Network byte order */
+	__u32 local_port;	/* Host byte order */
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.25.4

