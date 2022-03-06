Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4084CEEAE
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiCFXoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiCFXoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:44:16 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26624091B;
        Sun,  6 Mar 2022 15:43:21 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id z16so12287168pfh.3;
        Sun, 06 Mar 2022 15:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/1xcdTbkMMBdSKTr166+hix38bor1ITd/OdvOt4zm1I=;
        b=kWfhBnv1mR/Q7Z/cNCua8julakqqYaLhjsyodjh0lBvi/93mQTJFXWV9JEbVrlyr7x
         K2XkkSek6viYiKBo/vYMM8VCmwwTp6nV9POWWWD2pkFnhbVLsrNOafXuE1DZ0x8djXoX
         acOxti5Zkgu0oqS6REYslj72HYokkmKEUGYwbaMM4rzPS/mHNwuimcN6aMtQ6BEa+Fiy
         mmXvXUzYLecdl1uYN8ETpeDaLMtzMwLiJui1T1BcxwAB/47s5YErt3jTh3ffGaw/pLWS
         q5ffZqhaxz+wIe0iVCke5wtbgNi14GPyZUqipuFnn8WprVD6l5PWc3MVkG9fp5GCb1tV
         sIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1xcdTbkMMBdSKTr166+hix38bor1ITd/OdvOt4zm1I=;
        b=u2J7UNBb8cUb6LPd7+ejUyKq/8WPLW3x8UNSijhx8Xi5Xaxvvjc4Lg4b/NvmY+kNHe
         gMxGVCOD74v+pmtCvgMLNp+tR3GygxA78Bu9LyTgHPAtZ2QWe6yC1b/4DxVh8GkW73QL
         1kvmP2UwI5PD6Tf37ZhyaYhxTYJneH2fGBjtlzi+iex94TiqrK7unC70kVHSdOnjAkn9
         wUj/VuODgwqfImC4K/awNLqfMqglbn6JpjPFFeiOZFBzXHxsdCeLfEIXGpSZXhwIjRw/
         A2E4QEW63FQpUvEM6k8UaMrpionzEx1RmELfLZmSxfOf1Qs1vGTkfd8LGMAdbS3TLRv8
         33JA==
X-Gm-Message-State: AOAM5304zeMe1OJzeYwaEMP150tCqpwd8gMxd5J26dFm4zkips85bLUi
        8WRPlFPT7Mjk24HULqOTfsXAbtAlO34=
X-Google-Smtp-Source: ABdhPJz+TO0N3hPDmasYgHPVc0GjHABKLPWweXbCvjBCjQZgZpglGI1e4ISsbN5rxcpsEB9QlKdy9g==
X-Received: by 2002:a63:4864:0:b0:378:badd:b786 with SMTP id x36-20020a634864000000b00378baddb786mr7668735pgk.512.1646610201018;
        Sun, 06 Mar 2022 15:43:21 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id s8-20020a056a0008c800b004f664655937sm13984919pfu.157.2022.03.06.15.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:43:20 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 2/5] bpf: Introduce pkt_uid concept for PTR_TO_PACKET
Date:   Mon,  7 Mar 2022 05:13:08 +0530
Message-Id: <20220306234311.452206-3-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306234311.452206-1-memxor@gmail.com>
References: <20220306234311.452206-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7096; h=from:subject; bh=1r3cqsm4DN2Zvo68UgHRNdowV7LtN0+dv3/iFHXLB2c=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiJUWoZMfvQPzkb9ZuQ+yeRrvDU0UgfmlES3VoS8JC 5yMyJY6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYiVFqAAKCRBM4MiGSL8RysPfD/ 4lGrXjWqMdlaZKnNMavl/4jH4zUH7Y+AawB/FZnUyxXLUtu3dZUHQkTJ9rCxe0XOaruHghx9fLtSC6 aSbktlterKvVuTWQ36RLlveChPyPFHSwlLy9Q3sgKogytmzWxSpGjiumTGyYQVe12Aw1vjncNtHn5j Y0muRe8wOcEsfyT1vsibsFNISfly0JugvMbYdydveP72Ng6XYeKjBUNqP/CsaWKL1rASGwmagqIrXV 93hFNfDF9VI339VxsDJNen48B+QFau2T8f1bbFh73jUNgzdvI6yxUqbiolDU6KCXhNj3mQGRs/9DpX ySAh1KdIXv/cQe96OVPA4k2pPW1JtH0262Tjf9QmXakK3I/KgkIctxwYuotGTwj/pvk3XiYbD7TQNd 7FGNoAS3pnYJFvevqidGiH+5A/BdFTCMIpZ/A8f7JznrwnpjkAlue2a7ds5Rzc9oOX4VDJvdjK+SSs 1bvicxUATC9mTg/FoZZq+PpQe//I9XHn4tb74Dkbvdysh3KCYBBRQQmkoDy6OfKYkoXCvndCvqJ+jy w0m8vcvCWGBjKLsV1slsfV3oxyz+q7FrVDbWhE0M8cA/OpUvzk1q6gyNoPRGaWvnKjyC1zYZcwSvue A51q0cfYEcSpU0HNN/gQ8ajoP5W5YNqWHQtXwg6/VGlGmVP0u4F/iSIqHP+Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new member in PTR_TO_PACKET specific register state, namely
pkt_uid. This is used to classify packet pointers into different sets,
and the invariant is that any pkt pointers not belonging to the same
set, i.e. not sharing same pkt_uid, won't be allowed for comparison with
each other. During range propagation in __find_good_pkt_pointers, we now
need to take care to skip packet pointers with a different pkt_uid.

This can be used to set for a packet pointer returned from a helper
'bpf_packet_pointer' in the next patch, that encodes the range from the
len parameter it gets. Generating a distinct pkt_uid means this pointer
cannot be compared with other packet pointers and its range cannot be
manipulated.

Note that for helpers which change underlying packet data, we don't make
any distinction based on pkt_uid for clear_all_pkt_pointers, since even
though the pkt_uid is different, they all point into ctx.

regsafe is updated to match non-zero pkt_uid using the idmap to ensure
it rejects distinct pkt_uid pkt pointers.

We also replace memset of reg->raw to set range to 0, but it is helpful
to elaborate on why replacing it with reg->range = 0 is correct. In
commit 0962590e5533 ("bpf: fix partial copy of map_ptr when dst is scalar"),
the copying was changed to use raw so that all possible members of type
specific register state are copied, since at that point the type of
register is not known. But inside the reg_is_pkt_pointer block, there is
no need to memset the whole 'raw' struct, since we also have a pkt_uid
member that we now want to preserve after copying from one register to
another, for pkt pointers. A test for this case has been included to
prevent regressions.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf_verifier.h |  9 ++++++-
 kernel/bpf/verifier.c        | 47 ++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c1fc4af47f69..0379f953cf22 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -50,7 +50,14 @@ struct bpf_reg_state {
 	s32 off;
 	union {
 		/* valid when type == PTR_TO_PACKET */
-		int range;
+		struct {
+			int range;
+			/* This is used to tag some PTR_TO_PACKET so that they
+			 * cannot be compared existing PTR_TO_PACKET with
+			 * different pkt_uid.
+			 */
+			u32 pkt_uid;
+		};
 
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
 		 *   PTR_TO_MAP_VALUE_OR_NULL
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0373d5bd240f..88ac2c833bed 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -712,8 +712,14 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose_a("ref_obj_id=%d", reg->ref_obj_id);
 			if (t != SCALAR_VALUE)
 				verbose_a("off=%d", reg->off);
-			if (type_is_pkt_pointer(t))
+			if (type_is_pkt_pointer(t)) {
 				verbose_a("r=%d", reg->range);
+				/* pkt_uid is only set for PTR_TO_PACKET, so
+				 * type_is_pkt_pointer check is enough.
+				 */
+				if (reg->pkt_uid)
+					verbose_a("pkt_uid=%d", reg->pkt_uid);
+			}
 			else if (base_type(t) == CONST_PTR_TO_MAP ||
 				 base_type(t) == PTR_TO_MAP_KEY ||
 				 base_type(t) == PTR_TO_MAP_VALUE)
@@ -7604,7 +7610,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		if (reg_is_pkt_pointer(ptr_reg)) {
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
-			memset(&dst_reg->raw, 0, sizeof(dst_reg->raw));
+			dst_reg->range = 0;
 		}
 		break;
 	case BPF_SUB:
@@ -7664,7 +7670,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
 			if (smin_val < 0)
-				memset(&dst_reg->raw, 0, sizeof(dst_reg->raw));
+				dst_reg->range = 0;
 		}
 		break;
 	case BPF_AND:
@@ -8701,7 +8707,8 @@ static void __find_good_pkt_pointers(struct bpf_func_state *state,
 
 	for (i = 0; i < MAX_BPF_REG; i++) {
 		reg = &state->regs[i];
-		if (reg->type == type && reg->id == dst_reg->id)
+		if (reg->type == type && reg->id == dst_reg->id &&
+		    reg->pkt_uid == dst_reg->pkt_uid)
 			/* keep the maximum range already checked */
 			reg->range = max(reg->range, new_range);
 	}
@@ -8709,7 +8716,8 @@ static void __find_good_pkt_pointers(struct bpf_func_state *state,
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg->type == type && reg->id == dst_reg->id)
+		if (reg->type == type && reg->id == dst_reg->id &&
+		    reg->pkt_uid == dst_reg->pkt_uid)
 			reg->range = max(reg->range, new_range);
 	}
 }
@@ -9330,6 +9338,14 @@ static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
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
@@ -9343,6 +9359,9 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 	if (BPF_CLASS(insn->code) == BPF_JMP32)
 		return false;
 
+	if (is_bad_pkt_comparison(dst_reg, src_reg))
+		return false;
+
 	switch (BPF_OP(insn->code)) {
 	case BPF_JGT:
 		if ((dst_reg->type == PTR_TO_PACKET &&
@@ -9640,11 +9659,17 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
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
@@ -10891,6 +10916,8 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		/* id relations must be preserved */
 		if (rold->id && !check_ids(rold->id, rcur->id, idmap))
 			return false;
+		if (rold->pkt_uid && !check_ids(rold->pkt_uid, rcur->pkt_uid, idmap))
+			return false;
 		/* new val must satisfy old val knowledge */
 		return range_within(rold, rcur) &&
 		       tnum_in(rold->var_off, rcur->var_off);
-- 
2.35.1

