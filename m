Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713DB3A72CD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhFOANY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhFOANX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:13:23 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B9CC061767
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:11:06 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id d196so35156854qkg.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TACdUTCIKvHAgde/HOdgZh0/guNGE5ijibhGgzI7NgU=;
        b=AvIvWZy4rxNx5o8X9TcbtC5Itn9uQofT/6ktlXQ26s928sOHRYXNpq4eZgVmGs6o0x
         h4zO4/K+brWKo87pQSL8v5lIAVsRzrEMO1hQ9JYhKScQHMu88+iyq0UqQ+FyV8CkByqX
         AFtdXgE2VgV2Ls+OP+wiBelsvhkrG9mjeph9YRwQR2npU4iw75tHP/GjJoSgVE/2KJ3I
         Ya/o1YmuLomIE7Oh5ixDWf9NxKT7dNWvYjRKx+SLVOzWjxJjZgT4ClzU8pYzDjNNGcog
         eVDgyz2TKIQDuMunjWtr89D6X79q8QugSpobguf6aGHajiYu+VtPwMeszp4omCGkQLkU
         dM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TACdUTCIKvHAgde/HOdgZh0/guNGE5ijibhGgzI7NgU=;
        b=CN/U1HJL6yt0vXdi3ZmsaAE1Iw4NH1DBB8OL3ydXJtBTGY8puR8ogCIuYaABIb9wen
         aw7QAAkF6gtilP8a+09261JnCO9VuDr1QcthkUHWQfNXRC7IwKdslPf8MriDDjN+p52Q
         MaUHL6/V6PQaTlOT41VGnGCUqIW/CunngnGC5fy2O9yi+PyRKWY788ST85u94N5oYrCM
         RkRdWkxQFvpYxG0ImOnlurL7JGhaFmUQzK7idGKTl6lO/X7acw651X2+zq5mkWiUX5dx
         0SSIoSc81A+MJzeCmMrF/nCfwgUmdW2cwqTKaN5WN8dMaDnmSFLf8rGabCsFM1zALL4u
         MBsw==
X-Gm-Message-State: AOAM531TQvDnWn6A8x9DKnoJiOFR6F7inZP1/0BNyUyX5Io5oyfSt46Y
        ZAzYWEhYHxcM15nRs797rFRD0pecyL0=
X-Google-Smtp-Source: ABdhPJx7X1K/rUrcsCbTSeQkQK2zdNDTULr1nBGZgX85eM1BRksVe6bna8LI77tx3m4nwH8xZbaChw==
X-Received: by 2002:a05:620a:130e:: with SMTP id o14mr18805035qkj.296.1623715865721;
        Mon, 14 Jun 2021 17:11:05 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:592b:4d3c:3a31:b1fe])
        by smtp.gmail.com with ESMTPSA id e1sm11153087qti.27.2021.06.14.17.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:11:05 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH net-next v6 1/3] net: flow_dissector: extend bpf flow dissector support with vnet hdr
Date:   Mon, 14 Jun 2021 20:10:58 -0400
Message-Id: <20210615001100.1008325-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
References: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Amend the bpf flow dissector program type to be able to process
virtio-net headers. Do this to enable bpf flow dissector programs to
perform virtio-net header validation. The next patch in this series
will add a flow dissection hook in virtio_net_hdr_to_skb and make use
of this extended functionality. That commit message has more
background on the use case.

Add two new members to struct bpf_flow_keys: a pointer to struct
virtio_net_hdr, and vhdr_is_little_endian. The latter is required to
inform the BPF program of the endianness of the virtio-net header
fields, to handle the case of a version 1+ header on a big endian
machine.

Changes
v6:
  - Move bpf_flow_dissector_btf_ids, check_flow_keys_access() to
    filter.c
  - Verify (off % size == 0) in check_flow_keys_access()
  - Check bpf_flow_dissector_btf_ids[0] is nonzero in
    check_flow_keys_access()
v5:
  - Use PTR_TO_BTF_ID_OR_NULL instead of defining new
    PTR_TO_VNET_HDR_OR_NULL
  - Make check_flow_keys_access() disallow writes to keys->vhdr
  - Make check_flow_keys_access() check loading keys->vhdr is in
    sizeof(__u64)
  - Use BPF_REG_AX instead of BPF_REG_TMP as scratch reg
  - Describe parameter vhdr_is_little_endian in __skb_flow_dissect
    documentation
v4:
  - Add virtio_net_hdr pointer to struct bpf_flow_keys
  - Add vhdr_is_little_endian to struct bpf_flow_keys
v2:
  - Describe parameter vhdr in __skb_flow_dissect documentation

Signed-off-by: Tanner Love <tannerlove@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Petar Penkov <ppenkov@google.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/bonding/bond_main.c |  2 +-
 include/linux/bpf.h             |  3 ++
 include/linux/skbuff.h          | 35 ++++++++++++++++-----
 include/uapi/linux/bpf.h        |  2 ++
 kernel/bpf/verifier.c           | 35 ++++++++++++---------
 net/bpf/test_run.c              |  2 +-
 net/core/filter.c               | 56 +++++++++++++++++++++++++++++++++
 net/core/flow_dissector.c       | 18 ++++++++---
 tools/include/uapi/linux/bpf.h  |  2 ++
 9 files changed, 127 insertions(+), 28 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index eb79a9f05914..36993636d56d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3554,7 +3554,7 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 	case BOND_XMIT_POLICY_ENCAP34:
 		memset(fk, 0, sizeof(*fk));
 		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
-					  fk, NULL, 0, 0, 0, 0);
+					  fk, NULL, 0, 0, 0, 0, NULL, false);
 	default:
 		break;
 	}
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9dc44ba97584..f08dee59b099 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1515,6 +1515,9 @@ static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
 		attr->numa_node : NUMA_NO_NODE;
 }
 
+int check_flow_keys_access(int off, int size, enum bpf_access_type t,
+			   struct bpf_insn_access_aux *info);
+
 struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type);
 int array_map_alloc_check(union bpf_attr *attr);
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b2db9cd9a73f..4e390cd8f72a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1314,21 +1314,27 @@ void skb_flow_dissector_init(struct flow_dissector *flow_dissector,
 			     unsigned int key_count);
 
 struct bpf_flow_dissector;
+struct virtio_net_hdr;
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
-		      __be16 proto, int nhoff, int hlen, unsigned int flags);
+		      __be16 proto, int nhoff, int hlen, unsigned int flags,
+		      const struct virtio_net_hdr *vhdr,
+		      bool vhdr_is_little_endian);
 
 bool __skb_flow_dissect(const struct net *net,
 			const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
 			void *target_container, const void *data,
-			__be16 proto, int nhoff, int hlen, unsigned int flags);
+			__be16 proto, int nhoff, int hlen, unsigned int flags,
+			const struct virtio_net_hdr *vhdr,
+			bool vhdr_is_little_endian);
 
 static inline bool skb_flow_dissect(const struct sk_buff *skb,
 				    struct flow_dissector *flow_dissector,
 				    void *target_container, unsigned int flags)
 {
 	return __skb_flow_dissect(NULL, skb, flow_dissector,
-				  target_container, NULL, 0, 0, 0, flags);
+				  target_container, NULL, 0, 0, 0, flags, NULL,
+				  false);
 }
 
 static inline bool skb_flow_dissect_flow_keys(const struct sk_buff *skb,
@@ -1337,7 +1343,22 @@ static inline bool skb_flow_dissect_flow_keys(const struct sk_buff *skb,
 {
 	memset(flow, 0, sizeof(*flow));
 	return __skb_flow_dissect(NULL, skb, &flow_keys_dissector,
-				  flow, NULL, 0, 0, 0, flags);
+				  flow, NULL, 0, 0, 0, flags, NULL, false);
+}
+
+static inline bool
+__skb_flow_dissect_flow_keys_basic(const struct net *net,
+				   const struct sk_buff *skb,
+				   struct flow_keys_basic *flow,
+				   const void *data, __be16 proto,
+				   int nhoff, int hlen, unsigned int flags,
+				   const struct virtio_net_hdr *vhdr,
+				   bool vhdr_is_little_endian)
+{
+	memset(flow, 0, sizeof(*flow));
+	return __skb_flow_dissect(net, skb, &flow_keys_basic_dissector, flow,
+				  data, proto, nhoff, hlen, flags, vhdr,
+				  vhdr_is_little_endian);
 }
 
 static inline bool
@@ -1347,9 +1368,9 @@ skb_flow_dissect_flow_keys_basic(const struct net *net,
 				 const void *data, __be16 proto,
 				 int nhoff, int hlen, unsigned int flags)
 {
-	memset(flow, 0, sizeof(*flow));
-	return __skb_flow_dissect(net, skb, &flow_keys_basic_dissector, flow,
-				  data, proto, nhoff, hlen, flags);
+	return __skb_flow_dissect_flow_keys_basic(net, skb, flow, data, proto,
+						  nhoff, hlen, flags, NULL,
+						  false);
 }
 
 void skb_flow_dissect_meta(const struct sk_buff *skb,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 418b9b813d65..e1ac34548f9a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
 	};
 	__u32	flags;
 	__be32	flow_label;
+	__bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
+	__u8	vhdr_is_little_endian;
 };
 
 struct bpf_func_info {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 331b170d9fcc..a037476954f5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22,6 +22,7 @@
 #include <linux/error-injection.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
+#include <linux/virtio_net.h>
 
 #include "disasm.h"
 
@@ -3372,18 +3373,6 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 	return -EACCES;
 }
 
-static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
-				  int size)
-{
-	if (size < 0 || off < 0 ||
-	    (u64)off + size > sizeof(struct bpf_flow_keys)) {
-		verbose(env, "invalid access to flow keys off=%d size=%d\n",
-			off, size);
-		return -EACCES;
-	}
-	return 0;
-}
-
 static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 			     u32 regno, int off, int size,
 			     enum bpf_access_type t)
@@ -4210,6 +4199,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_FLOW_KEYS) {
+		struct bpf_insn_access_aux info = {};
+
 		if (t == BPF_WRITE && value_regno >= 0 &&
 		    is_pointer_value(env, value_regno)) {
 			verbose(env, "R%d leaks addr into flow keys\n",
@@ -4217,9 +4208,23 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			return -EACCES;
 		}
 
-		err = check_flow_keys_access(env, off, size);
-		if (!err && t == BPF_READ && value_regno >= 0)
-			mark_reg_unknown(env, regs, value_regno);
+		err = check_flow_keys_access(off, size, t, &info);
+		if (err) {
+			verbose(env,
+				"invalid access to flow keys off=%d size=%d\n",
+				off, size);
+		} else if (t == BPF_READ && value_regno >= 0) {
+			if (off == offsetof(struct bpf_flow_keys, vhdr)) {
+				mark_reg_known_zero(env, regs, value_regno);
+				regs[value_regno].type = PTR_TO_BTF_ID_OR_NULL;
+				regs[value_regno].btf = btf_vmlinux;
+				regs[value_regno].btf_id = info.btf_id;
+				/* required for dropping or_null */
+				regs[value_regno].id = ++env->id_gen;
+			} else {
+				mark_reg_unknown(env, regs, value_regno);
+			}
+		}
 	} else if (type_is_sk_pointer(reg->type)) {
 		if (t == BPF_WRITE) {
 			verbose(env, "R%d cannot write into %s\n",
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index aa47af349ba8..a11c5ce99ccb 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -797,7 +797,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	bpf_test_timer_enter(&t);
 	do {
 		retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
-					  size, flags);
+					  size, flags, NULL, false);
 	} while (bpf_test_timer_continue(&t, repeat, &ret, &duration));
 	bpf_test_timer_leave(&t);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 239de1306de9..f5be14b947cd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8329,6 +8329,36 @@ static bool sk_msg_is_valid_access(int off, int size,
 	return true;
 }
 
+BTF_ID_LIST_SINGLE(bpf_flow_dissector_btf_ids, struct, virtio_net_hdr);
+
+int check_flow_keys_access(int off, int size, enum bpf_access_type t,
+			   struct bpf_insn_access_aux *info)
+{
+	if (size < 0 || off < 0 ||
+	    (u64)off + size > sizeof(struct bpf_flow_keys))
+		return -EACCES;
+
+	switch (off) {
+	case bpf_ctx_range_ptr(struct bpf_flow_keys, vhdr):
+		if (t == BPF_WRITE || off % size != 0 || size != sizeof(__u64))
+			return -EACCES;
+
+		if (!bpf_flow_dissector_btf_ids[0])
+			return -EINVAL;
+
+		info->btf_id = bpf_flow_dissector_btf_ids[0];
+
+		break;
+	case offsetof(struct bpf_flow_keys, vhdr_is_little_endian):
+		if (t == BPF_WRITE)
+			return -EACCES;
+
+		break;
+	}
+
+	return 0;
+}
+
 static bool flow_dissector_is_valid_access(int off, int size,
 					   enum bpf_access_type type,
 					   const struct bpf_prog *prog,
@@ -8358,6 +8388,8 @@ static bool flow_dissector_is_valid_access(int off, int size,
 			return false;
 		info->reg_type = PTR_TO_FLOW_KEYS;
 		return true;
+	case bpf_ctx_range(struct __sk_buff, len):
+		return size == size_default;
 	default:
 		return false;
 	}
@@ -8390,6 +8422,30 @@ static u32 flow_dissector_convert_ctx_access(enum bpf_access_type type,
 				      si->dst_reg, si->src_reg,
 				      offsetof(struct bpf_flow_dissector, flow_keys));
 		break;
+
+	case offsetof(struct __sk_buff, len):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, skb),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, skb));
+		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, 0, 4);
+		/* bpf_flow_dissector->skb == NULL */
+		/* dst_reg = bpf_flow_dissector->data_end */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, data_end),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, data_end));
+		/* AX = bpf_flow_dissector->data */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, data),
+				      BPF_REG_AX, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, data));
+		/* dst_reg -= bpf_flow_dissector->data */
+		*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_AX);
+		*insn++ = BPF_JMP_A(1);
+		/* bpf_flow_dissector->skb != NULL */
+		/* bpf_flow_dissector->skb->len */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct sk_buff, len));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2aadbfc5193b..afbfef4402f5 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -28,6 +28,7 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <uapi/linux/batadv_packet.h>
 #include <linux/bpf.h>
+#include <linux/virtio_net.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_labels.h>
@@ -864,7 +865,9 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 }
 
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
-		      __be16 proto, int nhoff, int hlen, unsigned int flags)
+		      __be16 proto, int nhoff, int hlen, unsigned int flags,
+		      const struct virtio_net_hdr *vhdr,
+		      bool vhdr_is_little_endian)
 {
 	struct bpf_flow_keys *flow_keys = ctx->flow_keys;
 	u32 result;
@@ -874,6 +877,8 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 	flow_keys->n_proto = proto;
 	flow_keys->nhoff = nhoff;
 	flow_keys->thoff = flow_keys->nhoff;
+	flow_keys->vhdr = vhdr;
+	flow_keys->vhdr_is_little_endian = vhdr_is_little_endian;
 
 	BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG !=
 		     (int)FLOW_DISSECTOR_F_PARSE_1ST_FRAG);
@@ -904,6 +909,8 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
  * @hlen: packet header length, if @data is NULL use skb_headlen(skb)
  * @flags: flags that control the dissection process, e.g.
  *         FLOW_DISSECTOR_F_STOP_AT_ENCAP.
+ * @vhdr: virtio_net_header to include in kernel context for BPF flow dissector
+ * @vhdr_is_little_endian: whether virtio_net_hdr fields are little endian
  *
  * The function will try to retrieve individual keys into target specified
  * by flow_dissector from either the skbuff or a raw buffer specified by the
@@ -915,7 +922,9 @@ bool __skb_flow_dissect(const struct net *net,
 			const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
 			void *target_container, const void *data,
-			__be16 proto, int nhoff, int hlen, unsigned int flags)
+			__be16 proto, int nhoff, int hlen, unsigned int flags,
+			const struct virtio_net_hdr *vhdr,
+			bool vhdr_is_little_endian)
 {
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
@@ -1012,7 +1021,8 @@ bool __skb_flow_dissect(const struct net *net,
 
 			prog = READ_ONCE(run_array->items[0].prog);
 			ret = bpf_flow_dissect(prog, &ctx, n_proto, nhoff,
-					       hlen, flags);
+					       hlen, flags, vhdr,
+					       vhdr_is_little_endian);
 			__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
 						 target_container);
 			rcu_read_unlock();
@@ -1610,7 +1620,7 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
 	memset(&keys, 0, sizeof(keys));
 	__skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
 			   &keys, NULL, 0, 0, 0,
-			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL, NULL, false);
 
 	return __flow_hash_from_keys(&keys, &hashrnd);
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 418b9b813d65..e1ac34548f9a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
 	};
 	__u32	flags;
 	__be32	flow_label;
+	__bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
+	__u8	vhdr_is_little_endian;
 };
 
 struct bpf_func_info {
-- 
2.32.0.272.g935e593368-goog

