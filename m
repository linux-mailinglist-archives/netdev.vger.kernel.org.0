Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB8573538
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiGMLSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiGMLSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:18:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B533100CEE
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657711109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9jsaBAn6wtBTsWqUwNNR/1YQePbJoUZIk07ulDT2Uw=;
        b=YnyGIMYx1Q5u7omYXZfXVxvXkw7Bn0clBeasN2lbcbwcpOi7vHn5ESdLVfZqQdIneOqMi5
        LzDpo8NXUpJ6e4DMljYDjDFwIYw0FifTXa1T6LhXDlQeYXZIoS33fKJo3VMK6gankZIKx0
        Yu+wQXb1chcaT5YVka64zICqBQ9D07Y=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-b6sfjqDmOa2iJ7rl0yoXRA-1; Wed, 13 Jul 2022 07:18:28 -0400
X-MC-Unique: b6sfjqDmOa2iJ7rl0yoXRA-1
Received: by mail-ed1-f70.google.com with SMTP id o13-20020a056402438d00b0043aa846b2d2so8101506edc.8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9jsaBAn6wtBTsWqUwNNR/1YQePbJoUZIk07ulDT2Uw=;
        b=gAibdA1HT7YtsWoMAeCKD5+Ywy0Wch6nnT1H8iRyNjOO7dgLSR+x76pQM84QKQaQiN
         s2TWHP6f70m85Dp/UDqvb+rFJNVTCMIMalyAOOzT8dzUdDX7QLEsAxX3Bi72rYmnLwSv
         44t3fVOS/BNRPSt5DdAQsmsrTceSw+8l+WkwaRmCm0FKM26hawfFbjSdogH3arU3Mu4w
         2uZzY/wMXC1gzw/VrWT51nsEVQ6hPZ0y29YhWd8z2r2790PboydTcgf4/1X052Lthytl
         ufDi9byAngqOyMV1d1dDuD7GhHu7q5MIP4OjANqQocjut84uok8WkEBYt7viL97ysV+n
         yrXw==
X-Gm-Message-State: AJIora94THZWV3iD+gMGZDZunAxcgmmDdqrjOLnAHUELwWZofSAanwO6
        XkMO3OWqOqUvrrqayjjWbrqopncAhTnUZqnM3Vgh4NE0rCTtk8F6acnNpU2sAVT2u5Oh++H6rEH
        Zt5zLuICTSbnRjhz3
X-Received: by 2002:a17:906:149:b0:712:c9:7981 with SMTP id 9-20020a170906014900b0071200c97981mr2887994ejh.218.1657711105359;
        Wed, 13 Jul 2022 04:18:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1te/ajeNjxiFGlAqADULantLtM8t2h0ppxDuqVUdOm+9mP2gmmnpL+ygeIfuvRq4o5c+z1fyA==
X-Received: by 2002:a17:906:149:b0:712:c9:7981 with SMTP id 9-20020a170906014900b0071200c97981mr2887900ejh.218.1657711104296;
        Wed, 13 Jul 2022 04:18:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id fd9-20020a1709072a0900b006fed062c68esm4807773ejc.182.2022.07.13.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:18:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3E4794D990D; Wed, 13 Jul 2022 13:14:37 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC PATCH 09/17] bpf: Introduce pkt_uid member for PTR_TO_PACKET
Date:   Wed, 13 Jul 2022 13:14:17 +0200
Message-Id: <20220713111430.134810-10-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Add a new member in PTR_TO_PACKET specific register state, namely
pkt_uid. This is used to classify packet pointers into different sets,
and the invariant is that any pkt pointers not belonging to the same
set, i.e. not sharing same pkt_uid, won't be allowed for comparison with
each other. During range propagation in __find_good_pkt_pointers, we now
need to take care to skip packet pointers with a different pkt_uid.

This change is necessary so that we can dequeue multiple XDP frames in a
single program, obtain packet pointers using their xdp_md fake struct,
and prevent confusion wrt comparison of packet pointers pointing into
different frames. Attaching a pkt_uid to the PTR_TO_PACKET type prevents
these, and also allows user to see which frame a packet pointer belongs
to in the verbose verifier log (by matching pkt_uid and ref_obj_id of
the referenced xdp_md obtained from bpf_packet_dequeue).

regsafe is updated to match non-zero pkt_uid using the idmap to ensure
it rejects distinct pkt_uid pkt pointers.

We also replace memset of reg->raw to set range to 0. In commit
0962590e5533 ("bpf: fix partial copy of map_ptr when dst is scalar"),
the copying was changed to use raw so that all possible members of type
specific register state are copied, since at that point the type of
register is not known. But inside the reg_is_pkt_pointer block, there is
no need to memset the whole 'raw' struct, since we also have a pkt_uid
member that we now want to preserve after copying from one register to
another, for pkt pointers. A test for this case has been included to
prevent regressions.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf_verifier.h |  8 ++++-
 kernel/bpf/verifier.c        | 59 +++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 2e3bad8640dc..93b69dbf3d19 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -50,7 +50,13 @@ struct bpf_reg_state {
 	s32 off;
 	union {
 		/* valid when type == PTR_TO_PACKET */
-		int range;
+		struct {
+			int range;
+			/* To distinguish packet pointers backed by different
+			 * packets, to prevent pkt pointer comparisons.
+			 */
+			u32 pkt_uid;
+		};
 
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
 		 *   PTR_TO_MAP_VALUE_OR_NULL
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 68f98d76bc78..f319e9392587 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -431,6 +431,12 @@ static bool type_is_pkt_pointer(enum bpf_reg_type type)
 	       type == PTR_TO_PACKET_META;
 }
 
+static bool type_is_pkt_pointer_any(enum bpf_reg_type type)
+{
+	return type_is_pkt_pointer(type) ||
+	       type == PTR_TO_PACKET_END;
+}
+
 static bool type_is_sk_pointer(enum bpf_reg_type type)
 {
 	return type == PTR_TO_SOCKET ||
@@ -861,6 +867,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose_a("off=%d", reg->off);
 			if (type_is_pkt_pointer(t))
 				verbose_a("r=%d", reg->range);
+			if (type_is_pkt_pointer_any(t) && reg->pkt_uid)
+				verbose_a("pkt_uid=%d", reg->pkt_uid);
 			else if (base_type(t) == CONST_PTR_TO_MAP ||
 				 base_type(t) == PTR_TO_MAP_KEY ||
 				 base_type(t) == PTR_TO_MAP_VALUE)
@@ -1394,8 +1402,7 @@ static bool reg_is_pkt_pointer(const struct bpf_reg_state *reg)
 
 static bool reg_is_pkt_pointer_any(const struct bpf_reg_state *reg)
 {
-	return reg_is_pkt_pointer(reg) ||
-	       reg->type == PTR_TO_PACKET_END;
+	return type_is_pkt_pointer_any(reg->type);
 }
 
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
@@ -6575,14 +6582,17 @@ static void release_reg_references(struct bpf_verifier_env *env,
 	struct bpf_reg_state *regs = state->regs, *reg;
 	int i;
 
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (regs[i].ref_obj_id == ref_obj_id)
+	for (i = 0; i < MAX_BPF_REG; i++) {
+		if (regs[i].ref_obj_id == ref_obj_id ||
+		    (reg_is_pkt_pointer_any(&regs[i]) && regs[i].pkt_uid == ref_obj_id))
 			mark_reg_unknown(env, regs, i);
+	}
 
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg->ref_obj_id == ref_obj_id)
+		if (reg->ref_obj_id == ref_obj_id ||
+		    (reg_is_pkt_pointer_any(reg) && reg->pkt_uid == ref_obj_id))
 			__mark_reg_unknown(env, reg);
 	}
 }
@@ -8200,7 +8210,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		if (reg_is_pkt_pointer(ptr_reg)) {
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
-			memset(&dst_reg->raw, 0, sizeof(dst_reg->raw));
+			dst_reg->range = 0;
 		}
 		break;
 	case BPF_SUB:
@@ -8260,7 +8270,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
 			if (smin_val < 0)
-				memset(&dst_reg->raw, 0, sizeof(dst_reg->raw));
+				dst_reg->range = 0;
 		}
 		break;
 	case BPF_AND:
@@ -9287,7 +9297,8 @@ static void __find_good_pkt_pointers(struct bpf_func_state *state,
 
 	for (i = 0; i < MAX_BPF_REG; i++) {
 		reg = &state->regs[i];
-		if (reg->type == type && reg->id == dst_reg->id)
+		if (reg->type == type && reg->id == dst_reg->id &&
+		    reg->pkt_uid == dst_reg->pkt_uid)
 			/* keep the maximum range already checked */
 			reg->range = max(reg->range, new_range);
 	}
@@ -9295,7 +9306,8 @@ static void __find_good_pkt_pointers(struct bpf_func_state *state,
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg->type == type && reg->id == dst_reg->id)
+		if (reg->type == type && reg->id == dst_reg->id &&
+		    reg->pkt_uid == dst_reg->pkt_uid)
 			reg->range = max(reg->range, new_range);
 	}
 }
@@ -9910,6 +9922,14 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
 		__mark_ptr_or_null_regs(vstate->frame[i], id, is_null);
 }
 
+static bool is_bad_pkt_comparison(const struct bpf_reg_state *dst_reg,
+				  const struct bpf_reg_state *src_reg)
+{
+	if (!reg_is_pkt_pointer_any(dst_reg) || !reg_is_pkt_pointer_any(src_reg))
+		return false;
+	return dst_reg->pkt_uid != src_reg->pkt_uid;
+}
+
 static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 				   struct bpf_reg_state *dst_reg,
 				   struct bpf_reg_state *src_reg,
@@ -9923,6 +9943,9 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 	if (BPF_CLASS(insn->code) == BPF_JMP32)
 		return false;
 
+	if (is_bad_pkt_comparison(dst_reg, src_reg))
+		return false;
+
 	switch (BPF_OP(insn->code)) {
 	case BPF_JGT:
 		if ((dst_reg->type == PTR_TO_PACKET &&
@@ -10220,11 +10243,17 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		mark_ptr_or_null_regs(other_branch, insn->dst_reg,
 				      opcode == BPF_JEQ);
 	} else if (!try_match_pkt_pointers(insn, dst_reg, &regs[insn->src_reg],
-					   this_branch, other_branch) &&
-		   is_pointer_value(env, insn->dst_reg)) {
-		verbose(env, "R%d pointer comparison prohibited\n",
-			insn->dst_reg);
-		return -EACCES;
+					   this_branch, other_branch)) {
+		if (is_pointer_value(env, insn->dst_reg)) {
+			verbose(env, "R%d pointer comparison prohibited\n",
+				insn->dst_reg);
+			return -EACCES;
+		}
+		if (is_bad_pkt_comparison(dst_reg, &regs[insn->src_reg])) {
+			verbose(env, "R%d, R%d pkt pointer comparison prohibited\n",
+				insn->dst_reg, insn->src_reg);
+			return -EACCES;
+		}
 	}
 	if (env->log.level & BPF_LOG_LEVEL)
 		print_insn_state(env, this_branch->frame[this_branch->curframe]);
@@ -11514,6 +11543,8 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		/* id relations must be preserved */
 		if (rold->id && !check_ids(rold->id, rcur->id, idmap))
 			return false;
+		if (rold->pkt_uid && !check_ids(rold->pkt_uid, rcur->pkt_uid, idmap))
+			return false;
 		/* new val must satisfy old val knowledge */
 		return range_within(rold, rcur) &&
 		       tnum_in(rold->var_off, rcur->var_off);
-- 
2.37.0

