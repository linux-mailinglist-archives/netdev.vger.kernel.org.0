Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BD5FE2A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfGDV1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45677 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbfGDV1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so7837140wre.12
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MgCwXPRFSdmtLovFM30zfgjSPm0tfzS0HM17EifhOcg=;
        b=gsAtbUIZKvtbhgxUN3mY4VQObKJdnsSIyYaiMz2ETASViXT/rtU3L3G6PhYA350us9
         rIUJXSeDDdkIF/iZv6ZhvXB8Q3cZVbCsIRE8059t/OT/ROkXOSqn+uKUBcIMSAk8pXtq
         fKjIlrTwkrbYFekU18gIMzeBgFzYJn3adm6PYpx3UQiacoruZhjjXG16d2NZXUJbnFKi
         5ip5+gKhb4ZNnz4ZBq//rcgri+hKwQLtbupD+fUdSHcnKsUzbSXfQxuOu5WXdkepcfiG
         Fz7FGFU1JQ1w8u5h94z2ZUus4QlcacjQpQh1qY5pyUbrc0EkQCs7OH+J8PCwKJXrm+Vu
         olvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MgCwXPRFSdmtLovFM30zfgjSPm0tfzS0HM17EifhOcg=;
        b=h5CIfDQNbSfhWXvPC4nXw2tk3v45n2DdBH8oQoEAdMsQ9JpvamI1zJ5VAhBdhexEx9
         8ZGJZaBkBxcOZbyheyOeOZEv7h/cOg4xJsFlJSqu/vdKCpFHbxfd2EC+pR+MQ6OoS0Qn
         N3RrdxHY4UONdg9MR8TuNfwh/DOqanTUY73JevHiSzV4xiFfPaZ2ZtKsBtW60jyl9y8h
         +PkjKIc5a/Ic+g1TEO5oQjZr7nOBQfgFGbtn/fBkyqU/AQcS8CDtQEx6k5a2drXxAzz9
         qGfdTi2AypGHf4J6qgdSwTSxiC2y5aaxIixqu5q9refNM4Z2SSIYo80L3JPZ9ylcJnq0
         ARLw==
X-Gm-Message-State: APjAAAXWHLH5S/tzsPZ4Ps2vNI0IctJzKPad6LAkBcx66X+N6uOIMWRh
        Q4se+0rDie68EP7dTzZkIhjV2g==
X-Google-Smtp-Source: APXvYqykWqThgx+O3MabQmVWXMVS0UmjqO62Y4tZeHIofN1fE1ZgLATQGKkHxW7rRe/ejATQt/n9ow==
X-Received: by 2002:adf:bc4d:: with SMTP id a13mr352532wrh.296.1562275631752;
        Thu, 04 Jul 2019 14:27:11 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:11 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 8/8] bpf: delete all those code around old insn patching infrastructure
Date:   Thu,  4 Jul 2019 22:26:51 +0100
Message-Id: <1562275611-31790-9-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch delete all code around old insn patching infrastructure.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/bpf_verifier.h |   1 -
 include/linux/filter.h       |   4 -
 kernel/bpf/core.c            | 169 ---------------------------------
 kernel/bpf/verifier.c        | 221 +------------------------------------------
 4 files changed, 1 insertion(+), 394 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5fe99f3..79c1733 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -305,7 +305,6 @@ struct bpf_insn_aux_data {
 	bool zext_dst; /* this insn zero extends dst reg */
 	u8 alu_state; /* used in combination with alu_limit */
 	bool prune_point;
-	unsigned int orig_idx; /* original instruction index */
 };
 
 #define MAX_USED_MAPS 64 /* max number of maps accessed by one eBPF program */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1fea68c..fcfe0b0 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -838,10 +838,6 @@ static inline bool bpf_dump_raw_ok(void)
 	return kallsyms_show_value() == 1;
 }
 
-struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
-				       const struct bpf_insn *patch, u32 len);
-int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt);
-
 int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
 			int idx_map[]);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c3a5f84..716220b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -333,175 +333,6 @@ int bpf_prog_calc_tag(struct bpf_prog *fp)
 	return 0;
 }
 
-static int bpf_adj_delta_to_imm(struct bpf_insn *insn, u32 pos, s32 end_old,
-				s32 end_new, s32 curr, const bool probe_pass)
-{
-	const s64 imm_min = S32_MIN, imm_max = S32_MAX;
-	s32 delta = end_new - end_old;
-	s64 imm = insn->imm;
-
-	if (curr < pos && curr + imm + 1 >= end_old)
-		imm += delta;
-	else if (curr >= end_new && curr + imm + 1 < end_new)
-		imm -= delta;
-	if (imm < imm_min || imm > imm_max)
-		return -ERANGE;
-	if (!probe_pass)
-		insn->imm = imm;
-	return 0;
-}
-
-static int bpf_adj_delta_to_off(struct bpf_insn *insn, u32 pos, s32 end_old,
-				s32 end_new, s32 curr, const bool probe_pass)
-{
-	const s32 off_min = S16_MIN, off_max = S16_MAX;
-	s32 delta = end_new - end_old;
-	s32 off = insn->off;
-
-	if (curr < pos && curr + off + 1 >= end_old)
-		off += delta;
-	else if (curr >= end_new && curr + off + 1 < end_new)
-		off -= delta;
-	if (off < off_min || off > off_max)
-		return -ERANGE;
-	if (!probe_pass)
-		insn->off = off;
-	return 0;
-}
-
-static int bpf_adj_branches(struct bpf_prog *prog, u32 pos, s32 end_old,
-			    s32 end_new, const bool probe_pass)
-{
-	u32 i, insn_cnt = prog->len + (probe_pass ? end_new - end_old : 0);
-	struct bpf_insn *insn = prog->insnsi;
-	int ret = 0;
-
-	for (i = 0; i < insn_cnt; i++, insn++) {
-		u8 code;
-
-		/* In the probing pass we still operate on the original,
-		 * unpatched image in order to check overflows before we
-		 * do any other adjustments. Therefore skip the patchlet.
-		 */
-		if (probe_pass && i == pos) {
-			i = end_new;
-			insn = prog->insnsi + end_old;
-		}
-		code = insn->code;
-		if ((BPF_CLASS(code) != BPF_JMP &&
-		     BPF_CLASS(code) != BPF_JMP32) ||
-		    BPF_OP(code) == BPF_EXIT)
-			continue;
-		/* Adjust offset of jmps if we cross patch boundaries. */
-		if (BPF_OP(code) == BPF_CALL) {
-			if (insn->src_reg != BPF_PSEUDO_CALL)
-				continue;
-			ret = bpf_adj_delta_to_imm(insn, pos, end_old,
-						   end_new, i, probe_pass);
-		} else {
-			ret = bpf_adj_delta_to_off(insn, pos, end_old,
-						   end_new, i, probe_pass);
-		}
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-static void bpf_adj_linfo(struct bpf_prog *prog, u32 off, u32 delta)
-{
-	struct bpf_line_info *linfo;
-	u32 i, nr_linfo;
-
-	nr_linfo = prog->aux->nr_linfo;
-	if (!nr_linfo || !delta)
-		return;
-
-	linfo = prog->aux->linfo;
-
-	for (i = 0; i < nr_linfo; i++)
-		if (off < linfo[i].insn_off)
-			break;
-
-	/* Push all off < linfo[i].insn_off by delta */
-	for (; i < nr_linfo; i++)
-		linfo[i].insn_off += delta;
-}
-
-struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
-				       const struct bpf_insn *patch, u32 len)
-{
-	u32 insn_adj_cnt, insn_rest, insn_delta = len - 1;
-	const u32 cnt_max = S16_MAX;
-	struct bpf_prog *prog_adj;
-	int err;
-
-	/* Since our patchlet doesn't expand the image, we're done. */
-	if (insn_delta == 0) {
-		memcpy(prog->insnsi + off, patch, sizeof(*patch));
-		return prog;
-	}
-
-	insn_adj_cnt = prog->len + insn_delta;
-
-	/* Reject anything that would potentially let the insn->off
-	 * target overflow when we have excessive program expansions.
-	 * We need to probe here before we do any reallocation where
-	 * we afterwards may not fail anymore.
-	 */
-	if (insn_adj_cnt > cnt_max &&
-	    (err = bpf_adj_branches(prog, off, off + 1, off + len, true)))
-		return ERR_PTR(err);
-
-	/* Several new instructions need to be inserted. Make room
-	 * for them. Likely, there's no need for a new allocation as
-	 * last page could have large enough tailroom.
-	 */
-	prog_adj = bpf_prog_realloc(prog, bpf_prog_size(insn_adj_cnt),
-				    GFP_USER);
-	if (!prog_adj)
-		return ERR_PTR(-ENOMEM);
-
-	prog_adj->len = insn_adj_cnt;
-
-	/* Patching happens in 3 steps:
-	 *
-	 * 1) Move over tail of insnsi from next instruction onwards,
-	 *    so we can patch the single target insn with one or more
-	 *    new ones (patching is always from 1 to n insns, n > 0).
-	 * 2) Inject new instructions at the target location.
-	 * 3) Adjust branch offsets if necessary.
-	 */
-	insn_rest = insn_adj_cnt - off - len;
-
-	memmove(prog_adj->insnsi + off + len, prog_adj->insnsi + off + 1,
-		sizeof(*patch) * insn_rest);
-	memcpy(prog_adj->insnsi + off, patch, sizeof(*patch) * len);
-
-	/* We are guaranteed to not fail at this point, otherwise
-	 * the ship has sailed to reverse to the original state. An
-	 * overflow cannot happen at this point.
-	 */
-	BUG_ON(bpf_adj_branches(prog_adj, off, off + 1, off + len, false));
-
-	bpf_adj_linfo(prog_adj, off, insn_delta);
-
-	return prog_adj;
-}
-
-int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
-{
-	/* Branch offsets can't overflow when program is shrinking, no need
-	 * to call bpf_adj_branches(..., true) here
-	 */
-	memmove(prog->insnsi + off, prog->insnsi + off + cnt,
-		sizeof(struct bpf_insn) * (prog->len - off - cnt));
-	prog->len -= cnt;
-
-	return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
-}
-
 int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
 			s32 idx_map[])
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index abe11fd..9e5618f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8067,223 +8067,6 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
 			insn->src_reg = 0;
 }
 
-/* single env->prog->insni[off] instruction was replaced with the range
- * insni[off, off + cnt).  Adjust corresponding insn_aux_data by copying
- * [0, off) and [off, end) to new locations, so the patched range stays zero
- */
-static int adjust_insn_aux_data(struct bpf_verifier_env *env,
-				struct bpf_prog *new_prog, u32 off, u32 cnt)
-{
-	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
-	struct bpf_insn *insn = new_prog->insnsi;
-	u32 prog_len;
-	int i;
-
-	/* aux info at OFF always needs adjustment, no matter fast path
-	 * (cnt == 1) is taken or not. There is no guarantee INSN at OFF is the
-	 * original insn at old prog.
-	 */
-	old_data[off].zext_dst = insn_has_def32(env, insn + off + cnt - 1);
-
-	if (cnt == 1)
-		return 0;
-	prog_len = new_prog->len;
-	new_data = vzalloc(array_size(prog_len,
-				      sizeof(struct bpf_insn_aux_data)));
-	if (!new_data)
-		return -ENOMEM;
-	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
-	memcpy(new_data + off + cnt - 1, old_data + off,
-	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
-	for (i = off; i < off + cnt - 1; i++) {
-		new_data[i].seen = true;
-		new_data[i].zext_dst = insn_has_def32(env, insn + i);
-	}
-	env->insn_aux_data = new_data;
-	vfree(old_data);
-	return 0;
-}
-
-static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len)
-{
-	int i;
-
-	if (len == 1)
-		return;
-	/* NOTE: fake 'exit' subprog should be updated as well. */
-	for (i = 0; i <= env->subprog_cnt; i++) {
-		if (env->subprog_info[i].start <= off)
-			continue;
-		env->subprog_info[i].start += len - 1;
-	}
-}
-
-static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 off,
-					    const struct bpf_insn *patch, u32 len)
-{
-	struct bpf_prog *new_prog;
-
-	new_prog = bpf_patch_insn_single(env->prog, off, patch, len);
-	if (IS_ERR(new_prog)) {
-		if (PTR_ERR(new_prog) == -ERANGE)
-			verbose(env,
-				"insn %d cannot be patched due to 16-bit range\n",
-				env->insn_aux_data[off].orig_idx);
-		return NULL;
-	}
-	if (adjust_insn_aux_data(env, new_prog, off, len))
-		return NULL;
-	adjust_subprog_starts(env, off, len);
-	return new_prog;
-}
-
-static int adjust_subprog_starts_after_remove(struct bpf_verifier_env *env,
-					      u32 off, u32 cnt)
-{
-	int i, j;
-
-	/* find first prog starting at or after off (first to remove) */
-	for (i = 0; i < env->subprog_cnt; i++)
-		if (env->subprog_info[i].start >= off)
-			break;
-	/* find first prog starting at or after off + cnt (first to stay) */
-	for (j = i; j < env->subprog_cnt; j++)
-		if (env->subprog_info[j].start >= off + cnt)
-			break;
-	/* if j doesn't start exactly at off + cnt, we are just removing
-	 * the front of previous prog
-	 */
-	if (env->subprog_info[j].start != off + cnt)
-		j--;
-
-	if (j > i) {
-		struct bpf_prog_aux *aux = env->prog->aux;
-		int move;
-
-		/* move fake 'exit' subprog as well */
-		move = env->subprog_cnt + 1 - j;
-
-		memmove(env->subprog_info + i,
-			env->subprog_info + j,
-			sizeof(*env->subprog_info) * move);
-		env->subprog_cnt -= j - i;
-
-		/* remove func_info */
-		if (aux->func_info) {
-			move = aux->func_info_cnt - j;
-
-			memmove(aux->func_info + i,
-				aux->func_info + j,
-				sizeof(*aux->func_info) * move);
-			aux->func_info_cnt -= j - i;
-			/* func_info->insn_off is set after all code rewrites,
-			 * in adjust_btf_func() - no need to adjust
-			 */
-		}
-	} else {
-		/* convert i from "first prog to remove" to "first to adjust" */
-		if (env->subprog_info[i].start == off)
-			i++;
-	}
-
-	/* update fake 'exit' subprog as well */
-	for (; i <= env->subprog_cnt; i++)
-		env->subprog_info[i].start -= cnt;
-
-	return 0;
-}
-
-static int bpf_adj_linfo_after_remove(struct bpf_verifier_env *env, u32 off,
-				      u32 cnt)
-{
-	struct bpf_prog *prog = env->prog;
-	u32 i, l_off, l_cnt, nr_linfo;
-	struct bpf_line_info *linfo;
-
-	nr_linfo = prog->aux->nr_linfo;
-	if (!nr_linfo)
-		return 0;
-
-	linfo = prog->aux->linfo;
-
-	/* find first line info to remove, count lines to be removed */
-	for (i = 0; i < nr_linfo; i++)
-		if (linfo[i].insn_off >= off)
-			break;
-
-	l_off = i;
-	l_cnt = 0;
-	for (; i < nr_linfo; i++)
-		if (linfo[i].insn_off < off + cnt)
-			l_cnt++;
-		else
-			break;
-
-	/* First live insn doesn't match first live linfo, it needs to "inherit"
-	 * last removed linfo.  prog is already modified, so prog->len == off
-	 * means no live instructions after (tail of the program was removed).
-	 */
-	if (prog->len != off && l_cnt &&
-	    (i == nr_linfo || linfo[i].insn_off != off + cnt)) {
-		l_cnt--;
-		linfo[--i].insn_off = off + cnt;
-	}
-
-	/* remove the line info which refer to the removed instructions */
-	if (l_cnt) {
-		memmove(linfo + l_off, linfo + i,
-			sizeof(*linfo) * (nr_linfo - i));
-
-		prog->aux->nr_linfo -= l_cnt;
-		nr_linfo = prog->aux->nr_linfo;
-	}
-
-	/* pull all linfo[i].insn_off >= off + cnt in by cnt */
-	for (i = l_off; i < nr_linfo; i++)
-		linfo[i].insn_off -= cnt;
-
-	/* fix up all subprogs (incl. 'exit') which start >= off */
-	for (i = 0; i <= env->subprog_cnt; i++)
-		if (env->subprog_info[i].linfo_idx > l_off) {
-			/* program may have started in the removed region but
-			 * may not be fully removed
-			 */
-			if (env->subprog_info[i].linfo_idx >= l_off + l_cnt)
-				env->subprog_info[i].linfo_idx -= l_cnt;
-			else
-				env->subprog_info[i].linfo_idx = l_off;
-		}
-
-	return 0;
-}
-
-static int verifier_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
-{
-	struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
-	unsigned int orig_prog_len = env->prog->len;
-	int err;
-
-	if (bpf_prog_is_dev_bound(env->prog->aux))
-		bpf_prog_offload_remove_insns(env, off, cnt);
-
-	err = bpf_remove_insns(env->prog, off, cnt);
-	if (err)
-		return err;
-
-	err = adjust_subprog_starts_after_remove(env, off, cnt);
-	if (err)
-		return err;
-
-	err = bpf_adj_linfo_after_remove(env, off, cnt);
-	if (err)
-		return err;
-
-	memmove(aux_data + off,	aux_data + off + cnt,
-		sizeof(*aux_data) * (orig_prog_len - off - cnt));
-
-	return 0;
-}
-
 /* The verifier does more data flow analysis than llvm and will not
  * explore branches that are dead at run time. Malicious programs can
  * have dead code too. Therefore replace all dead at-run-time code
@@ -9365,7 +9148,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	u64 start_time = ktime_get_ns();
 	struct bpf_verifier_env *env;
 	struct bpf_verifier_log *log;
-	int i, len, ret = -EINVAL;
+	int len, ret = -EINVAL;
 	bool is_priv;
 
 	/* no program is valid */
@@ -9386,8 +9169,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	ret = -ENOMEM;
 	if (!env->insn_aux_data)
 		goto err_free_env;
-	for (i = 0; i < len; i++)
-		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
 	is_priv = capable(CAP_SYS_ADMIN);
-- 
2.7.4

