Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161D63A3358
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFJSlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhFJSlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:41:00 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0918DC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:39:04 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id j189so28425317qkf.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFmTkGTIHCINZ/3J5yi+ATRjCiczBAwnCuY2zQ5v0+k=;
        b=OxYdUv+kM1uV+eAkHjzV3QrNMKO6p1EqEHRgs/7IvL48G2EgRwSyfq1FHx66q/ijqI
         v122W0f3ghnXNeb2EeQXsgsfeKd+B2cs60UZNQquNKs8wduIx6VZyoXa/yA1ySHbrGJn
         j2GvIyXAym5r3D2hFmM2ggxBxo4EfAkI0foKQOH2V7FL2aQcvhKiKfOKXc4eaK9q060q
         GBSr5iLJrAN0dmBH/qIKVz5Izr12ugf/I2rGZmBhdv3RkmqBVE4LA1rQ+q6GPeexEL3F
         FIAYirIFg7NE8XTt/OhtC1ELdu6fX1B78MEjmMCB57uA/wsYFHcTtuEhsp/FvTmYP6vF
         6Q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFmTkGTIHCINZ/3J5yi+ATRjCiczBAwnCuY2zQ5v0+k=;
        b=F/iaVVuJWNpmjS8ZW2lv72P6kUW1gdYbXf6/ErWSYAirZbz6Hmk8n5VE+pNE6rqTYn
         Btr7tUFwbeNuRikZIVInX+6ssyciL1eOdU0GObR5pVDsNVjofRvP4L3LddPMVLWb+uYw
         suJdw4IrKyEnsvWBBQuMG+aoDQ414/Hy8GRmnptX9eqVuMamP4ynxRmqL4Rf2WzirtAR
         /kzHiZgQgtIua2Scj0x6FYyqVHr3HLK4A79Kkaj1JnbBXtBwAVgQ/mKd79HiOPQGwo/7
         fYvfufufLiivp/yws/sVaNERGqOj7MJrYLBJB/CVmMbWEFuwR916wQ7zbrmbAw1b3RwH
         BVzA==
X-Gm-Message-State: AOAM532594TiiQsSvgbc7y9L5per7Lq+lOsBorvq4ErT7OZZbQz3z7wV
        VVOTMHzsIGhNs4oVwDml5XjuAxTg2UQ=
X-Google-Smtp-Source: ABdhPJzxjHkHmvufoISBAZndOydoITVcmJ1CgyMj31cl91cHOM7P5KdST42TJZnl19DeeYyuepK6yA==
X-Received: by 2002:a37:a24e:: with SMTP id l75mr884439qke.175.1623350343044;
        Thu, 10 Jun 2021 11:39:03 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:840f:b35f:63b2:482e])
        by smtp.gmail.com with ESMTPSA id a134sm2760350qkg.114.2021.06.10.11.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:39:02 -0700 (PDT)
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
Subject: [PATCH net-next v5 1/3] net: flow_dissector: extend bpf flow dissector support with vnet hdr
Date:   Thu, 10 Jun 2021 14:38:51 -0400
Message-Id: <20210610183853.3530712-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
References: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
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
 include/linux/skbuff.h          | 35 ++++++++++++++++++-----
 include/uapi/linux/bpf.h        |  2 ++
 kernel/bpf/verifier.c           | 50 ++++++++++++++++++++++++++++++---
 net/bpf/test_run.c              |  2 +-
 net/core/filter.c               | 26 +++++++++++++++++
 net/core/flow_dissector.c       | 18 +++++++++---
 tools/include/uapi/linux/bpf.h  |  2 ++
 8 files changed, 120 insertions(+), 17 deletions(-)

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
index 331b170d9fcc..989a4e3dabef 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22,6 +22,7 @@
 #include <linux/error-injection.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
+#include <linux/virtio_net.h>
 
 #include "disasm.h"
 
@@ -3373,7 +3374,7 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 }
 
 static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
-				  int size)
+				  int size, enum bpf_access_type t)
 {
 	if (size < 0 || off < 0 ||
 	    (u64)off + size > sizeof(struct bpf_flow_keys)) {
@@ -3381,6 +3382,35 @@ static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
 			off, size);
 		return -EACCES;
 	}
+
+	switch (off) {
+	case offsetof(struct bpf_flow_keys, vhdr):
+		if (t == BPF_WRITE) {
+			verbose(env,
+				"invalid write to flow keys off=%d size=%d\n",
+				off, size);
+			return -EACCES;
+		}
+
+		if (size != sizeof(__u64)) {
+			verbose(env,
+				"invalid access to flow keys off=%d size=%d\n",
+				off, size);
+			return -EACCES;
+		}
+
+		break;
+	case offsetof(struct bpf_flow_keys, vhdr_is_little_endian):
+		if (t == BPF_WRITE) {
+			verbose(env,
+				"invalid write to flow keys off=%d size=%d\n",
+				off, size);
+			return -EACCES;
+		}
+
+		break;
+	}
+
 	return 0;
 }
 
@@ -4053,6 +4083,8 @@ static int check_stack_access_within_bounds(
 	return err;
 }
 
+BTF_ID_LIST_SINGLE(bpf_flow_dissector_btf_ids, struct, virtio_net_hdr);
+
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
  * if t==read, value_regno is a register which will receive the value from memory
@@ -4217,9 +4249,19 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			return -EACCES;
 		}
 
-		err = check_flow_keys_access(env, off, size);
-		if (!err && t == BPF_READ && value_regno >= 0)
-			mark_reg_unknown(env, regs, value_regno);
+		err = check_flow_keys_access(env, off, size, t);
+		if (!err && t == BPF_READ && value_regno >= 0) {
+			if (off == offsetof(struct bpf_flow_keys, vhdr)) {
+				mark_reg_known_zero(env, regs, value_regno);
+				regs[value_regno].type = PTR_TO_BTF_ID_OR_NULL;
+				regs[value_regno].btf = btf_vmlinux;
+				regs[value_regno].btf_id = bpf_flow_dissector_btf_ids[0];
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
index 239de1306de9..95ff6fb31590 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8358,6 +8358,8 @@ static bool flow_dissector_is_valid_access(int off, int size,
 			return false;
 		info->reg_type = PTR_TO_FLOW_KEYS;
 		return true;
+	case bpf_ctx_range(struct __sk_buff, len):
+		return size == size_default;
 	default:
 		return false;
 	}
@@ -8390,6 +8392,30 @@ static u32 flow_dissector_convert_ctx_access(enum bpf_access_type type,
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
index 3ed7c98a98e1..d3df4339e0ae 100644
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

