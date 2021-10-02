Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7B541F90C
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhJBBTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbhJBBTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:19:52 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572D8C0613E4;
        Fri,  1 Oct 2021 18:18:07 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so322915pjc.3;
        Fri, 01 Oct 2021 18:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVwuyX9fAp2tKhkzcO8y6Eg2QuE05iMepjLtwR/q/qw=;
        b=S3EULQXsXPKohNVlkBxlGfgyESSvnnvZatFc72N1gt5fOGxNg6g6X/6RfatItPQx2P
         YVnms44paGecWe4AZcqCstYNScbSmV8cMzGF1v5YyOnDnCJD+bT27SzQfnXB7bwgJ7b3
         +o5Al2vwDU64Ahn8424oYwXrN/G1ylxa/4mDfmQYRTkOUHdl75sU2Gn3uySRyAJgxUTb
         9h1MVkX8ZOl1oA6Tt0BxYVaL76i6KN6hbZZXuNfBIKIHArXHvQAkXDXm7F2b9d7+iOnr
         OUaWSV+4qbKPrI/7dTFju4iayvlpY0NXaZGQnu+brB1bQ8228g+ri6YFddojO5p4TApB
         /7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVwuyX9fAp2tKhkzcO8y6Eg2QuE05iMepjLtwR/q/qw=;
        b=REJ1/GQMB433seVeDRyd+JtNrltwiscuc7w29X+6Y/hn/2BO/X4hIFwDu8+QucSFR4
         +5xsm0iaY8JI/cJcFK7dsbiUIZtuhCXYITjwkfWtUpFWndIHh96tS78z8KsVD5RTsy8V
         9jtxqj1mX1vA4zV3LyxtMX1Yus7zsPXhQP02xnRaSFf1eRrbNXkJoL9sxA7RoQHvv5mp
         amYnIiw2XM5RPa9fAl1mBLQqYX7aWeJIaihnX9Cf1RXHuZnFQCMat5qgw1LWG3TEwmbB
         6Uoko6q5eefg8H120rlh4dtGLnvhSACb5kN9QQd5S2rqIvpU3HzAhF47lfIye4YQ+t3t
         wM8g==
X-Gm-Message-State: AOAM5318JUSm+z+Zc0TtUp4q3q2GX7GOCQ8IOWZiF28HDOmohAxDA8Je
        IZsDJ2/lZeFrDLYIQEeaKGlEZ7FlBEs=
X-Google-Smtp-Source: ABdhPJxOZgtQ9Qg06OeIjGvmVZL/MvkNtG7axPojK2JXM/K2WwINGVlrXVYH4ZoEl1ul6B8CgFoMbw==
X-Received: by 2002:a17:90b:1c0f:: with SMTP id oc15mr16984798pjb.32.1633137486686;
        Fri, 01 Oct 2021 18:18:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id q21sm8172571pfj.90.2021.10.01.18.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:06 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 2/9] bpf: Be conservative while processing invalid kfunc calls
Date:   Sat,  2 Oct 2021 06:47:50 +0530
Message-Id: <20211002011757.311265-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2214; h=from:subject; bh=x3YVMt/L0MGY0B3nxUM4mcwj3vHm+wmx831D+QS1NxQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MQzI8YoaaH397Aj63CBNuXY/7jTT0W5O2i4Xp/ 8oeFOpSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEAAKCRBM4MiGSL8RygPjEA C/exZJjRDEGgtZM8sgfanDpci8hwVvM4wSSbRsrPFzgbwcPzJ6pfLRwAHmSZBfutJJE1ByPtJNFMAh R0y8y9UV7mIhSVkkMdKmjU5sdKXeDWlKNF4X3UWFAy9B9ZZ+iFl0Y2M5y0qVSALJhGaHqvyVg1W7Fx 2l1MJ2OX/keP1b+TzwIOTV0OBwe1EjS70PH4G1Z+NjLgNhcUxQt3fPwrBktYJYion9jH5VUOHtWC3z K1SdZtFnxlsDE1NBepHfc9/lLLpLsDp6D/Mwb/c5GaDA7oJiCnRm/z57jXtyzN0CCZaevkB7JPcN7C AtOebUVJXtjoqJm+0rHdforylGeFujG9eA5FXOMT8L66GNSfqAjlXHNnqFFSsb8Wbg/d7ED+x/HOG4 K9xB511glg18nvVwWkSS/UpBSaPdjcw4KSUrjAWBuRUp7xJdtFAr8pa7Q4g+SqiPXkavCbQ7Xf1C1k 8/XmOfFnHBS6H5uk/cpn3O7xKIdW590omQkHvkKHP83YkGVDhG3IMRO8EGvaDST6sr52PlqWgQH8z9 0WepkrT33+NB1J35tS0FwVRmTE6MTKjs2Wos15Bvb9LHfbZhRk5QFtEEadoXVxRYDKb0CpdV/xSvkR z21ctOaxh82LonIU4aXFkC8PwiOeAMWtZBLb3uPxW4GqcButz1BgshM1LlCw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch also modifies the BPF verifier to only return error for
invalid kfunc calls specially marked by userspace (with insn->imm == 0,
insn->off == 0) after the verifier has eliminated dead instructions.
This can be handled in the fixup stage, and skip processing during add
and check stages.

If such an invalid call is dropped, the fixup stage will not encounter
insn->imm as 0, otherwise it bails out and returns an error.

This will be exposed as weak ksym support in libbpf in later patches.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1d6d10265cab..68d6862de82e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1834,6 +1834,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	/* func_id == 0 is always invalid, but instead of returning an error, be
+	 * conservative and wait until the code elimination pass before returning
+	 * error, so that invalid calls that get pruned out can be in BPF programs
+	 * loaded from userspace.  It is also required that offset be untouched
+	 * for such calls.
+	 */
+	if (!func_id && !offset)
+		return 0;
+
 	if (!btf_tab && offset) {
 		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
 		if (!btf_tab)
@@ -6675,6 +6684,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12810,6 +12823,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
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

