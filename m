Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2A13FBB0C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhH3Rft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238226AbhH3Rfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:31 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B192C061760;
        Mon, 30 Aug 2021 10:34:37 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c4so8943126plh.7;
        Mon, 30 Aug 2021 10:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=76/2LNOo9Nw4fWX3xeUm9dQL50csWuRKgfcc/WZhFt0=;
        b=nZoDVIELkZ0gh5XYcV4haBBAwEUpuLM9UbssEBs+aiiCLlVxtHAqquEuM42ZgH/L6t
         t4axK7jvbsr0OiSJRanw6ohmuPVgrnLMDV8k/qDz9g5CBs/MZTOGFZAKk9dif4QIusO/
         6B/VZJZv9BneMeXVpFWdpAm04E1Aw/KsmvnXSgzyrZxcGT69mUD4APtQFuP0M3uEAM3U
         udp8gExdvlkPz4GoWrVpRxsjy5JE+cRifDwIxl50w/RN1bPwYE0/8vIVb6spF5irIRMC
         xRBAh4xKYx23tkL2cQwT8NeUmd2jIf3E87/lr2POr/7aHZeH/79dAyRnW1NY4bzSIt3L
         Ji1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=76/2LNOo9Nw4fWX3xeUm9dQL50csWuRKgfcc/WZhFt0=;
        b=o2nRYxQpRrm83L0L5gFdxs24TOJoZaAd1xPWF6U9jI+5mEpdL3RAhR9sMFTN1r6o7t
         SA7anYCWme5jBDYHRWaH36xOawCGJ2v7Zp4vwNr2TQaUMw6ayXiQ0hTOyHhrMpdrI2Je
         wTUAX/ZhWZQ+mORKYyPzkOMylKLESNGG3QvOTzlKXYPCKo3yXa/16ZP4jg3Hpe9c9iyL
         mwNwnoKCrFJ6JoXHmy+KoxpqtQMoSvH3Z6+du2s0lUcy8pQEL0qihhMMnwOcvWq5aEd0
         8KrpFq5gtTGRECmR/dOp/IYedoq6+LSwsoKlXo2BWA9SUO1/jTDfHpvocTtAq446WQnM
         9t3g==
X-Gm-Message-State: AOAM531BJY3DkIvVa47IEIhycjENhdFR49kwBU7Jqqj9vUyzGMbn28VZ
        O87NlqAltzkI7zKF7yeN7YWpgaH1xpSYCQ==
X-Google-Smtp-Source: ABdhPJzrtpw923WlxYaIJmdE2TUfcA0kXlhAy3t7QLe9EZkiQnM0EQx17h9uEWBNBNm0Plnv5r6Dxw==
X-Received: by 2002:a17:90a:f8e:: with SMTP id 14mr192579pjz.85.1630344876683;
        Mon, 30 Aug 2021 10:34:36 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id z131sm15241447pfc.159.2021.08.30.10.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:36 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next RFC v1 2/8] bpf: Be conservative during verification for invalid kfunc calls
Date:   Mon, 30 Aug 2021 23:04:18 +0530
Message-Id: <20210830173424.1385796-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2420; h=from:subject; bh=a0x10+MQqnbcBIP/XYujwKGlPoaxIuTaPPpnR7WZSR8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX98IFDd4p5nyA70OsewQCoPHep4fOy00UsyDKE pqwszzCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8RyldVD/ 9y01qvrtk7N0a93nPcX52Q5Nee0jqHQpJ7Nn++VKZgK1T3Elg6TbrF6IcLYC8n0YAWPxc291qCoPG1 dy/a60LIW4mk8OQCzA1Shak10nOU8SNqi/5ps/UQ1mvIR4XME9PIap85pLCEK+DrKHwOLcKpWzkzpV ala8bh+CpMuE9C4p8fCGvYPP78iwnSny2fZAlciWnDkTRnb3lQ/jJVfkY1KUNN2SQUhkhJRQGZ/n+s k8Ksq6sVe+KV1JURdxSaVbUOUYBkyWfVor6YHhaeuQYZ2IZ+m3oMjEp+ugM0ROCn/4ELRPdOjtLErf gIsz6ywOH5Q9w6ZN5EeqRfxlkKZsUsYWaEGFv9rKZWDArLKVkT9bxX4RqbE1ME521PMxYkS3BbWIhK /MJ65eVWQOanPAPR7lFEmLRBjiEnGOlp6jwYa/+rLL/NkxvsUhjndbA7CJtrKpHm3tHx4HWK7FJIyO pnmCx2sCDIHFTqd82AdkI455d25VsTw4vuya6prTglAxiJpYmDfbqKSlFoWELw+yg/rLcHNtiVcTBj kAU9xZYUvf9Mn9AtYdSg2pfNE5jOvslEZmADSGUue+jw+mHBdOfjCYfzihrL5AuPjxVj+1fqj5e0FP aA8LEAS1Kgyr23oh2iSFNUNoZKlM4F1BvqBYPNFSwwxNuty9vh2NP0Qn7rpQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change modifies the BPF verifier to only return error for invalid
kfunc calls specially marked by userspace (with insn->imm == 0) after
the verifier has eliminated dead instructions. This can be handled in
the fixup stage, and skip processing during add and check stages.

If such an invalid call is dropped, the fixup stage will not encounter
insn->imm as 0, otherwise it bails out and returns an error.

This can be used by userspace to use branches to call old and new kfunc
helpers across kernel versions by setting the rodata map value before
loading the BPF program, enhancing runtime portability. The next patch
introduces libbpf support for this.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index de0670a8b1df..9904b9a96b04 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1730,6 +1730,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	/* btf_idr allocates IDs from 1, so func_id == 0 is always invalid, but
+	 * instead of returning an error, be conservative and wait until the
+	 * code elimination pass before returning error, so that invalid calls
+	 * that get pruned out can be in BPF programs loaded from userspace.
+	 * It is also required that offset be 0.
+	 */
+	if (!func_id && !offset)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, func_id, offset);
 	if (IS_ERR(desc_btf)) {
 		verbose(env, "failed to find BTF for kernel function\n");
@@ -6527,6 +6536,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12658,6 +12671,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 {
 	const struct bpf_kfunc_desc *desc;
 
+	if (!insn->imm) {
+		verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
+		return -EINVAL;
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
-- 
2.33.0

