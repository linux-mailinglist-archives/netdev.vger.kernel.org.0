Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F421339FD03
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhFHREi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhFHREh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:04:37 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D823C061787
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 10:02:30 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id u30so20856778qke.7
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JGxaUJOMZsEl22MbJlc4hTRXpuxV9+kJ6YryUvDAxmU=;
        b=vMPLNTRIquel3pOI6VpyRmi4dDuS3lVxrl52FpV5LajyW6QY7pLnApiIOM2MhjuGE7
         LiGcQKTKjVtz1JcD8U95ebr0tEci+V5Kn5y56EPapI/6E+vDgjeYiaXAwGUlKrzL3h8m
         4ysPXlpg5arXPVw3I7OSgoNatw0Qjv2BHilM5G501393YKI800UHVSEnofBcr/Sws6yj
         wXX81XiFNKDUWrCTTrk5D4Z6V83dZpm1SCCbVCJV3YGV68apdd5CdPDikZYA7IaWCZtw
         0lka0EZCKdXvEv5L1XhVjOjBfCQlUk6Kqs3aBnzflf2sgOKLhU7tpX0BgnzFldq0KmWQ
         Xc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JGxaUJOMZsEl22MbJlc4hTRXpuxV9+kJ6YryUvDAxmU=;
        b=Omf734H7AdFSEq/DAQ48uOBNENK42bBw6XSbzSZ/SQL5NMWgTRhXDKJ7BgkzRDhygZ
         PtT1huyWzH3WVTQMD26n6aFTw4RHEomp4hi0Xl2ewO6KQMEOChlNH68FRx4y6yk4FuB4
         c8jfGA2vRP7XgdBWIqG7TTnqBcNCuKaT+5CgFAvyjtNzTco2R1qnSUq3hudIlvktNRAa
         bxXNlEPVWW73V0hPHYE2KRIIj7OfVt1R138m5STtr0xS6AIailKgdTb6N9xB3j5mh0Nb
         ECqcyWsqVMJynt6WDul9JkHqQcxJ4/WaxHRLs1hr6gIB35CQnQcM+AY4JT6JCwy44bb3
         giqg==
X-Gm-Message-State: AOAM530Cj6zZkvVJSSjRl5VlaWk57zG5qeFXPuOz7Z5MrP7LExFh+DM5
        9s7ve7gahihCuL9AmO+v6W6/ttIf85U=
X-Google-Smtp-Source: ABdhPJyk9KPdkgou8NdV8r0naD4RFvuECw5aPH1AnA6G30EJZvh2yM9COwPB0sbmdw2anIKzZSg9MA==
X-Received: by 2002:a05:620a:408f:: with SMTP id f15mr22386126qko.398.1623171749440;
        Tue, 08 Jun 2021 10:02:29 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:9f44:8134:602c:7e3e])
        by smtp.gmail.com with ESMTPSA id 97sm10969017qte.20.2021.06.08.10.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 10:02:29 -0700 (PDT)
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
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH net-next v4 1/3] net: flow_dissector: extend bpf flow dissector support with vnet hdr
Date:   Tue,  8 Jun 2021 13:02:22 -0400
Message-Id: <20210608170224.1138264-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
In-Reply-To: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
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
 include/linux/bpf.h             |  2 ++
 include/linux/skbuff.h          | 35 +++++++++++++++++++-----
 include/uapi/linux/bpf.h        |  2 ++
 kernel/bpf/verifier.c           | 48 +++++++++++++++++++++++++++++++--
 net/bpf/test_run.c              |  2 +-
 net/core/filter.c               | 26 ++++++++++++++++++
 net/core/flow_dissector.c       | 16 ++++++++---
 tools/include/uapi/linux/bpf.h  |  2 ++
 9 files changed, 120 insertions(+), 15 deletions(-)

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
index 9dc44ba97584..a333e6177de1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -430,6 +430,8 @@ enum bpf_reg_type {
 	PTR_TO_PERCPU_BTF_ID,	 /* reg points to a percpu kernel variable */
 	PTR_TO_FUNC,		 /* reg points to a bpf program function */
 	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
+	PTR_TO_VNET_HDR,	 /* reg points to struct virtio_net_hdr */
+	PTR_TO_VNET_HDR_OR_NULL, /* reg points to virtio_net_hdr or NULL */
 	__BPF_REG_TYPE_MAX,
 };
 
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
index 331b170d9fcc..2962b537da28 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22,6 +22,7 @@
 #include <linux/error-injection.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
+#include <linux/virtio_net.h>
 
 #include "disasm.h"
 
@@ -441,7 +442,8 @@ static bool reg_type_not_null(enum bpf_reg_type type)
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_MAP_VALUE ||
 		type == PTR_TO_MAP_KEY ||
-		type == PTR_TO_SOCK_COMMON;
+		type == PTR_TO_SOCK_COMMON ||
+		type == PTR_TO_VNET_HDR;
 }
 
 static bool reg_type_may_be_null(enum bpf_reg_type type)
@@ -453,7 +455,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
 	       type == PTR_TO_BTF_ID_OR_NULL ||
 	       type == PTR_TO_MEM_OR_NULL ||
 	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
-	       type == PTR_TO_RDWR_BUF_OR_NULL;
+	       type == PTR_TO_RDWR_BUF_OR_NULL ||
+	       type == PTR_TO_VNET_HDR_OR_NULL;
 }
 
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -576,6 +579,8 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_RDWR_BUF_OR_NULL] = "rdwr_buf_or_null",
 	[PTR_TO_FUNC]		= "func",
 	[PTR_TO_MAP_KEY]	= "map_key",
+	[PTR_TO_VNET_HDR]	= "virtio_net_hdr",
+	[PTR_TO_VNET_HDR_OR_NULL] = "virtio_net_hdr_or_null",
 };
 
 static char slot_type_char[] = {
@@ -1166,6 +1171,9 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 	case PTR_TO_RDWR_BUF_OR_NULL:
 		reg->type = PTR_TO_RDWR_BUF;
 		break;
+	case PTR_TO_VNET_HDR_OR_NULL:
+		reg->type = PTR_TO_VNET_HDR;
+		break;
 	default:
 		WARN_ONCE(1, "unknown nullable register type");
 	}
@@ -2528,6 +2536,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_MEM_OR_NULL:
 	case PTR_TO_FUNC:
 	case PTR_TO_MAP_KEY:
+	case PTR_TO_VNET_HDR:
+	case PTR_TO_VNET_HDR_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -3384,6 +3394,18 @@ static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
 	return 0;
 }
 
+static int check_virtio_net_hdr_access(struct bpf_verifier_env *env, int off,
+				       int size)
+{
+	if (size < 0 || off < 0 ||
+	    (u64)off + size > sizeof(struct virtio_net_hdr)) {
+		verbose(env, "invalid access to virtio_net_hdr off=%d size=%d\n",
+			off, size);
+		return -EACCES;
+	}
+	return 0;
+}
+
 static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 			     u32 regno, int off, int size,
 			     enum bpf_access_type t)
@@ -3568,6 +3590,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_XDP_SOCK:
 		pointer_desc = "xdp_sock ";
 		break;
+	case PTR_TO_VNET_HDR:
+		pointer_desc = "virtio_net_hdr ";
+		break;
 	default:
 		break;
 	}
@@ -4218,6 +4243,23 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		}
 
 		err = check_flow_keys_access(env, off, size);
+		if (!err && t == BPF_READ && value_regno >= 0) {
+			if (off == offsetof(struct bpf_flow_keys, vhdr)) {
+				regs[value_regno].type = PTR_TO_VNET_HDR_OR_NULL;
+				/* required for dropping or_null */
+				regs[value_regno].id = ++env->id_gen;
+			} else {
+				mark_reg_unknown(env, regs, value_regno);
+			}
+		}
+	} else if (reg->type == PTR_TO_VNET_HDR) {
+		if (t == BPF_WRITE) {
+			verbose(env, "R%d cannot write into %s\n",
+				regno, reg_type_str[reg->type]);
+			return -EACCES;
+		}
+
+		err = check_virtio_net_hdr_access(env, off, size);
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (type_is_sk_pointer(reg->type)) {
@@ -9989,6 +10031,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_VNET_HDR:
+	case PTR_TO_VNET_HDR_OR_NULL:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
 		 */
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
index 239de1306de9..58a8a43380ee 100644
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
+		/* TMP = bpf_flow_dissector->data */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, data),
+				      BPF_REG_TMP, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, data));
+		/* dst_reg -= bpf_flow_dissector->data */
+		*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_TMP);
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
index 3ed7c98a98e1..4bdad2b1d3a0 100644
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
@@ -915,7 +920,9 @@ bool __skb_flow_dissect(const struct net *net,
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
@@ -1012,7 +1019,8 @@ bool __skb_flow_dissect(const struct net *net,
 
 			prog = READ_ONCE(run_array->items[0].prog);
 			ret = bpf_flow_dissect(prog, &ctx, n_proto, nhoff,
-					       hlen, flags);
+					       hlen, flags, vhdr,
+					       vhdr_is_little_endian);
 			__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
 						 target_container);
 			rcu_read_unlock();
@@ -1610,7 +1618,7 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
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
2.32.0.rc1.229.g3e70b5a671-goog

