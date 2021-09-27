Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018DF4196FA
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhI0PCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbhI0PBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE45C061776;
        Mon, 27 Sep 2021 08:00:08 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k23-20020a17090a591700b001976d2db364so233098pji.2;
        Mon, 27 Sep 2021 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75YvYvEsvh397a9t/GUbdRglLQeQDw2VgrXGcjLzh6g=;
        b=cQi+YaMiAiHQahXir/RNLlE1zThQCWwHoWHtM2/KwmHQ/yXwKZC6A0iRcOikLz4kgh
         7rB7kBAucuBz5WKAPVGFEv9ZkzdHKkOb4rj05JedtPO+zThVePWT5fE04BxLgsqJkgWm
         CiMfi7UTdzxHlXd1i6ZC47QkD2ogHBrKT+PgH6TfVQEv6M4wKxGdyWJD60mTbS+i5J86
         Ov3MxaImoVUWio9Y6CdBvxssvbGMdOZv8qpen5xDUkx1b745PcO9eZ8L62n7XqMIOCa7
         0qq0q9DvIzCxoqrudOODXKc30aWf0em3/7CVy5qoB8OIrmRjTBJl6U41Dwy/n16VV9BB
         Se4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75YvYvEsvh397a9t/GUbdRglLQeQDw2VgrXGcjLzh6g=;
        b=OxskayLL3iuhk/d6pJHOMlOaafx5cgSvdkMTMcscwXgIVm0BtluEdM2Hnlgv250xMf
         MYyEJVwDOoTt5pFSQNolsweMSwqQO5ITfARkyrjEJ/aYAmkoO5EC0EaA7d9dTIkYb+U1
         nrPv6DGpOIIHcz7zrwLtmtGEO4eYuQR6tvQXXSFsd5jnD06aCac4ENAPs5wfxSgg2fks
         NmRXYpxaaiw2mn0qKvP1Hvl5LEPmmNeKDfTAN3PtRwt6d1E9oStNbc8q8afvz13PTAxN
         HHcA2Z/hA1wgvTNHoaphx9OQ5v9j+gOPto4Se08JndEQpdZDEaGMoUp6P5XHvX5dE9qy
         XkRw==
X-Gm-Message-State: AOAM5325LJJu4DC1/VHEqHscYErx+te9fSuEiT6Jfq/lqThxV+B/6frR
        keVJVzl/rRGTB45xxiFO8z15zExNPKY=
X-Google-Smtp-Source: ABdhPJz3rN3SBIkvGvp7418FwRbIR4sELkcB8T99Mpwm13ScVZlATAx5zCIAUpNA64xRMK5WJPoMbg==
X-Received: by 2002:a17:90a:7d05:: with SMTP id g5mr20544865pjl.14.1632754807474;
        Mon, 27 Sep 2021 08:00:07 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z19sm17732012pfk.109.2021.09.27.08.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:07 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 07/12] libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
Date:   Mon, 27 Sep 2021 20:29:36 +0530
Message-Id: <20210927145941.1383001-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2562; h=from:subject; bh=wtMr11ltrcGBXIzDIKBO9mdVxLsLz4SfHdSlEf2aLB0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxOQjYnkUVAWCr8yujN3XJ9YSo64qV7Mo30r5tv chPJrlOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8RykQ1D/ 9dOO5YiM6ggRBpU+pApOFFtKbnOXSEzeAxJzstHQ8UIDnQ8OsjCV7JNvjJrguBXQXIEM5kQ8xBNlxK zjef5Je/p01u8XMBFfxjj2UmETvsk+fVLc5IFJquFs7iQpXvHJCnHPhEexYA4BHZ/PRSN0WbwtcFyz 0ieByNFs62zDcJnLVFzxjSrmF+F9XR0Kgpk6ClsrP0ZUQTKKnzfjb1B3/lqJFq/tA7cJiLQMpzYCvx vCfhAWC92ObwnwFbxP8K9o/bnz8rfS+Ou0YdnHcjrkp+KTpd0yOjrfGHmeGRO4PX54zEwGkC2QhSWD 3NS8SjzMA0dgtpy4xNnlXWFFV6Yl8AR4sHIi+GvBWwRE6298cw+pPxRnaE6rm+We2He47hdu2oRP3X GlrUPXMzeqbRvHEZ9un1/iQKrvvzuv5z1rgCjmB9cGJzQYoKGApumWcpKON/ESJ8pmMkOY85qnKY3S cIrx3U2mau4zJzA1Xgtsxaz2scTSlhJNrw1/aEyT8mfNYN5EcddG8+OQey0EeCswldeGRRUnqs37tq fKSMYIbKFlr3GKk9JwwflbEoo0pppW09engOeiwCnNcSuGUHynFmzJO9f3vQqNAVBMGbeSH9Y4R5Vy 0hEl6mGhuygKduzUUqCEDlANTMvgzrp92RQF4lmMO7O/RUyKmv1gwyx8udPQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preserve these calls as it allows verifier to succeed in loading the
program if they are determined to be unreachable after dead code
elimination during program load. If not, the verifier will fail at
runtime. This is done for ext->is_weak symbols similar to the case for
variable ksyms.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0f4d203f926e..4b2d0511c1e7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3416,11 +3416,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 				return -ENOTSUP;
 			}
 		} else if (strcmp(sec_name, KSYMS_SEC) == 0) {
-			if (btf_is_func(t) && ext->is_weak) {
-				pr_warn("extern weak function %s is unsupported\n",
-					ext->name);
-				return -ENOTSUP;
-			}
 			ksym_sec = sec;
 			ext->type = EXT_KSYM;
 			skip_mods_and_typedefs(obj->btf, t->type,
@@ -5369,8 +5364,13 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 		case RELO_EXTERN_FUNC:
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
-			insn[0].imm = ext->ksym.kernel_btf_id;
-			insn[0].off = ext->ksym.offset;
+			if (ext->is_set) {
+				insn[0].imm = ext->ksym.kernel_btf_id;
+				insn[0].off = ext->ksym.offset;
+			} else { /* unresolved weak kfunc */
+				insn[0].imm = 0;
+				insn[0].off = 0;
+			}
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6719,9 +6719,9 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	int id, err;
 
 	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &mod_btf);
-	if (id == -ESRCH && ext->is_weak) {
-		return 0;
-	} else if (id < 0) {
+	if (id < 0) {
+		if (id == -ESRCH && ext->is_weak)
+			return 0;
 		pr_warn("extern (var ksym) '%s': not found in kernel BTF\n",
 			ext->name);
 		return id;
@@ -6774,7 +6774,9 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
 	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, &btf, &mod_btf);
 	if (kfunc_id < 0) {
-		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+		if (kfunc_id == -ESRCH && ext->is_weak)
+			return 0;
+		pr_warn("extern (func ksym) '%s': not found in kernel or module BTFs\n",
 			ext->name);
 		return kfunc_id;
 	}
-- 
2.33.0

