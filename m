Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7D2470137
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbhLJNGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbhLJNG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:29 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1BEC061746;
        Fri, 10 Dec 2021 05:02:54 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id k64so8389406pfd.11;
        Fri, 10 Dec 2021 05:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4r5vRiQCUtnsrEXpXgVTZrt19aPResKG4UO9WSgK6HU=;
        b=hMXlZY5sgceftmd67FnFFIgucQ4BBCfctTTvuqC+NVlkDDtwyuFwOpMHV71Cp2/yqu
         e8rH00UAwaBGrxpFVqcqiUrCuizckoyR4uVm2/n0lSfNW4DgIA+MTzqsGz+46H+HNh4i
         jbEdOyCN85+ZJRfrtYqG8Y5dBODU9zyehp1mEsjyF6IXU9vKXeDyEVQHGrduSlvdNDSO
         SjtOom5e0sVAOl3t5Ima7skWSu9GygKgkLfngEOv2hbwgd4cOMdeOPwQNDooudEr7Lc2
         8XGAY00NH6qWU5ff5s14UIpBdlabitK2CVFXMjpHU+nT3j9K7xTKbp8iA0VZLiGuMHml
         /NRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4r5vRiQCUtnsrEXpXgVTZrt19aPResKG4UO9WSgK6HU=;
        b=yJBr2NbzhbqDvnk0zNBVlF1l75J0Mf7ulKbTJPW/UCqSIC3HwN1NXYT9LT9sYLvNy2
         IsDDCW6F1hpoB/v8rkzHFNT7D78NWyD9ui73cZehVfRb6CksFyEmYhveZKR79w3Uo2OX
         vkInClAmyTj+lQOhLuuC+3X2REdYXqsz3ktX6NA9pJkqTMLzplI3P8kN12sQ5mMzofIk
         CDSICEgzHeGkC8Pzbpn9sMy8vG3cfgP2FSc+bCZNbUR+ayzh3qra/3WDj63i/Mz4xPWh
         rTq0ke8koynenzcIbd5m7SuPM0Vrq6gNzZYo8Enu4Hglx9HDF3zY/4OJm9V9wcHz7aip
         9qsA==
X-Gm-Message-State: AOAM5300Jy5o2sAiPEND4Z/QKqqipZ07DiXoKxaGIzK1uZ3lyk5GRJBN
        u64d8TrtSSueo1PDanp0LwZ+TvdwmXQ=
X-Google-Smtp-Source: ABdhPJzX4TAF+6E//UtjkOytpFl9ruo7g37pBMiQ6Nh+7M06mJkQBvYMJ6xV/hmsIkRLfq1J6vIUjg==
X-Received: by 2002:a63:d955:: with SMTP id e21mr3629639pgj.39.1639141373640;
        Fri, 10 Dec 2021 05:02:53 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id z22sm3713662pfe.93.2021.12.10.05.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:53 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v3 6/9] bpf: Track provenance for pointers formed from referenced PTR_TO_BTF_ID
Date:   Fri, 10 Dec 2021 18:32:27 +0530
Message-Id: <20211210130230.4128676-7-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7715; h=from:subject; bh=kDtn7PcefhwZyc4eaTzQBYsjRewCAc7PSsotdlO4r0k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/UvvOEPKmdf4ZXkRH+ZRv5QvWeaAHDi+xinDBY WCSa7C+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP1AAKCRBM4MiGSL8RylBCD/ 9vy0Xxp3JDKmkLIT61thAhkjYpn1we0ZGpvQo0TkS7k3C+DaGRw/w4uvK5WsERbU6qOJR28UcSaayZ 2gNPHjEm89RVHjAWr7s7u0aEsCisEW5+pfcKJ7cX9g25QcZ1RrXNnVuJHm6e+lwYNOMl6FVnB+CHYU UN16QqAhqbqouhzJPJ9Nu1H6LR3BsVeyRTrfCoLvvBer8XjnP1RUAlaLGwUTwdgl53jiTaljDy6dWU e+c03aFzBR+xV5vPF0WudsGAimYsl3SXSTWaSnRVx0DJc1P78kbBDZjvmhqiCySHhj0LvynHsgYIk8 8zV4EsJjYbs4iJFRRZlzkx/ZymXDRg5+g0dM8MbeH9MVtM6LCdLG23N4NVGXrRgn2ieiZLWC8GXqjU IZHbzvH0yw5oZPuf/5EKIN2l5I6oMKMXLhQ/4IHVbsBrwbnczL6I32Jrd6Rzosrn/eOXJme9ZWPbco WGZsmFXtkU56YRPfCdaGLtgekRQjiLhOE5C44wq4MjIX4CehH2c3ZlwOtw3zm1DAYl4jTnEmV2rijh p2O81qoHyfs97eItPL90ga7srBIJ8xnJzzi5TAbofnQXvmNsvcqNhRncr7aQuaMdc9bNN1+JxMX5Do WovUun2gouGtU3LCarHNAU5g+ErNA7QEudCAqg19eyOeBqQ6g9UsGIC6o91w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous commit, we implemented support in the verifier for
working with referenced PTR_TO_BTF_ID registers. These are invalidated
when their corresponding release function is called.

However, PTR_TO_BTF_ID is a bit special, in that distinct PTR_TO_BTF_ID
can be formed by walking pointers in the struct represented by the BTF
ID. mark_btf_ld_reg will copy the relevant register state to the
destination register.

However, we cannot simply copy ref_obj_id (such that
release_reg_references will match and invalidate all pointers formed by
pointer walking), as we obtain the same BTF ID in the destination
register, leading to confusion during release. An example is show below:

For a type like so:
struct foo { struct foo *next; };

r1 = acquire(...); // BTF ID of struct foo
if (r1) {
	r2 = r1->next; // BTF ID of struct foo, and we copied ref_obj_id in
		       // mark_btf_ld_reg.
	release(r2);
}

With this logic, the above snippet succeeds. Hence we need to
distinguish the canonical reference and pointers formed from it.

We introduce a 'parent_ref_obj_id' member in bpf_reg_state, for a
referenced register, only one of ref_obj_id or parent_ref_obj_id may be
set, i.e. either a register holds a canonical reference, or it is
related to a canonical reference for invalidation purposes (contains an
edge pointing to it by way of having the same ref_obj_id in
parent_ref_obj_id, in the graph of objects).

When releasing reference, we ensure that both are not set at once, and
then release if either of them match the requested ref_obj_id to be
released. This ensures that the example given above will not succeed.
A test to this end has been added in later patches.

Typically, kernel objects have a nested object lifetime (where the
parent object 'owns' the objects it holds references to). However, this
is not always true. For now, we don't need support to hold on to
references to objects obtained from a refcounted PTR_TO_BTF_ID after its
release, but this can be relaxed on a case by case basis (i.e. based on
the BTF ID and program type/attach type) in the future.

The safest assumption for the verifier to make in absence of any other
hints, is that all such pointers formed from refcounted PTR_TO_BTF_ID
shall be invalidated.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf_verifier.h | 10 +++++++
 kernel/bpf/verifier.c        | 54 ++++++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index b80fe5bf2a02..a6ef11db6823 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -128,6 +128,16 @@ struct bpf_reg_state {
 	 * allowed and has the same effect as bpf_sk_release(sk).
 	 */
 	u32 ref_obj_id;
+	/* This is set for pointers which are derived from referenced
+	 * pointer (e.g. PTR_TO_BTF_ID pointer walking), so that the
+	 * pointers obtained by walking referenced PTR_TO_BTF_ID
+	 * are appropriately invalidated when the lifetime of their
+	 * parent object ends.
+	 *
+	 * Only one of ref_obj_id and parent_ref_obj_id can be set,
+	 * never both at once.
+	 */
+	u32 parent_ref_obj_id;
 	/* For scalar types (SCALAR_VALUE), this represents our knowledge of
 	 * the actual value.
 	 * For pointer types, this represents the variable part of the offset
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b8685fb7ff15..16e30d7f631b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -654,7 +654,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose(env, "%s", kernel_type_name(reg->btf, reg->btf_id));
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
-				verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
+				verbose(env, ",%sref_obj_id=%d", reg->ref_obj_id ? "" : "parent_",
+					reg->ref_obj_id ?: reg->parent_ref_obj_id);
 			if (t != SCALAR_VALUE)
 				verbose(env, ",off=%d", reg->off);
 			if (type_is_pkt_pointer(t))
@@ -1500,7 +1501,8 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *regs, u32 regno,
 			    enum bpf_reg_type reg_type,
-			    struct btf *btf, u32 btf_id)
+			    struct btf *btf, u32 btf_id,
+			    u32 parent_ref_obj_id)
 {
 	if (reg_type == SCALAR_VALUE) {
 		mark_reg_unknown(env, regs, regno);
@@ -1509,6 +1511,7 @@ static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 	mark_reg_known_zero(env, regs, regno);
 	regs[regno].type = PTR_TO_BTF_ID;
 	regs[regno].btf = btf;
+	regs[regno].parent_ref_obj_id = parent_ref_obj_id;
 	regs[regno].btf_id = btf_id;
 }
 
@@ -4136,8 +4139,14 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (ret < 0)
 		return ret;
 
-	if (atype == BPF_READ && value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id);
+	if (atype == BPF_READ && value_regno >= 0) {
+		if (WARN_ON_ONCE(reg->ref_obj_id && reg->parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id,
+				reg->ref_obj_id ?: reg->parent_ref_obj_id);
+	}
 
 	return 0;
 }
@@ -4191,8 +4200,14 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
 	if (ret < 0)
 		return ret;
 
-	if (value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, btf_vmlinux, btf_id);
+	if (value_regno >= 0) {
+		if (WARN_ON_ONCE(reg->ref_obj_id && reg->parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		mark_btf_ld_reg(env, regs, value_regno, ret, btf_vmlinux, btf_id,
+				reg->ref_obj_id ?: reg->parent_ref_obj_id);
+	}
 
 	return 0;
 }
@@ -5865,23 +5880,35 @@ static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range
 		reg->range = AT_PKT_END;
 }
 
-static void release_reg_references(struct bpf_verifier_env *env,
+static int release_reg_references(struct bpf_verifier_env *env,
 				   struct bpf_func_state *state,
 				   int ref_obj_id)
 {
 	struct bpf_reg_state *regs = state->regs, *reg;
 	int i;
 
-	for (i = 0; i < MAX_BPF_REG; i++)
-		if (regs[i].ref_obj_id == ref_obj_id)
+	for (i = 0; i < MAX_BPF_REG; i++) {
+		if (WARN_ON_ONCE(regs[i].ref_obj_id && regs[i].parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		if (regs[i].ref_obj_id == ref_obj_id ||
+		    regs[i].parent_ref_obj_id == ref_obj_id)
 			mark_reg_unknown(env, regs, i);
+	}
 
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg->ref_obj_id == ref_obj_id)
+		if (WARN_ON_ONCE(reg->ref_obj_id && reg->parent_ref_obj_id)) {
+			verbose(env, "verifier internal error: both ref and parent ref set\n");
+			return -EACCES;
+		}
+		if (reg->ref_obj_id == ref_obj_id ||
+		    reg->parent_ref_obj_id == ref_obj_id)
 			__mark_reg_unknown(env, reg);
 	}
+	return 0;
 }
 
 /* The pointer with the specified id has released its reference to kernel
@@ -5898,8 +5925,11 @@ static int release_reference(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
-	for (i = 0; i <= vstate->curframe; i++)
-		release_reg_references(env, vstate->frame[i], ref_obj_id);
+	for (i = 0; i <= vstate->curframe; i++) {
+		err = release_reg_references(env, vstate->frame[i], ref_obj_id);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
-- 
2.34.1

