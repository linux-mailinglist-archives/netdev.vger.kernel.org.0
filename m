Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E0F41D36A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348379AbhI3GcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348372AbhI3Gbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEDFC06176D;
        Wed, 29 Sep 2021 23:30:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w19so4035091pfn.12;
        Wed, 29 Sep 2021 23:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uTzy4HE+3fIpUtgSkBARBojnE/c5iFGMRARxejh0OL8=;
        b=c/4JbyeGRBK7NdK7LXOrtkJdR4pjOgW8pjZbsxm5nimc267a1txoFeB4Ce8HJ1/C8V
         mK3OrhamA+10Xk6iwzFOh6cAktduQyAoL8kNDz75WTOLCYzCAsZJPjB+1erhERp4L1X+
         8OsLqVnEEzLVRDDX7rQtgz59WlRIkN8ZMA4fcR333F0AIluY3xirVCq9PgimFCxsbOOw
         wYMeZlLcEz9hZ+KS8HiKyPvt8kafj1DfcM4gawb3kVPFhaoLXw+rgeHCZQ6h+Dzkeqmp
         XUlTmKpXjKx2Ehw596/kGtPIRtJftoJD/YN0NZWCHo3BL1BollETziKZYH0TsjVSMipM
         6gEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uTzy4HE+3fIpUtgSkBARBojnE/c5iFGMRARxejh0OL8=;
        b=ZdSjQ5gvOxXIkTdG1XWCuU6iKSIklYlSdDOnyVtCM+3sRh5mcUyT1AQV3vZvDu+OmW
         4tAc/hs9OW9Dk2widQoX81sDgLMG4lj9iwBj/nLo5ydJKWHUFaIORXX8n+KVcLao/mpd
         WyFCvqOBrs1CmeXnYn23NMni7qOAQIDtL82eB9c58A/7s6z1L7aqhOfT/IYuKLn4ZYM+
         vKTmUdMM325+LTsikPqLdYRqD81Mlpi7VlT+z6NKsO9upCvqsfeTuDBHLztlGeJBc+IQ
         y4zDeDS2ieB0uPJjPk/L8uQD/6ykz94ATIaWaYHhuhcKPFog0xQWU3X7r2G3eSxTqAlh
         j67Q==
X-Gm-Message-State: AOAM5312LfBPPJk7jYFCCFv0EUIpT2NxX6N0nzQDuKZc/CYiQkfNY6Gv
        HSLlwN5liwzVucPsjHpgoIjzNvk9MCc=
X-Google-Smtp-Source: ABdhPJzWAvjJ6SMMJM4k0lxAUyuyaLlKftt8M6VTZRixn90aM+32UNnmMgZbqCOCZBxBRD6LYJ+h8Q==
X-Received: by 2002:a05:6a00:22c3:b0:447:b30c:ed36 with SMTP id f3-20020a056a0022c300b00447b30ced36mr3893029pfj.82.1632983410739;
        Wed, 29 Sep 2021 23:30:10 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id k9sm1730648pff.22.2021.09.29.23.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:30:10 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 7/9] libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
Date:   Thu, 30 Sep 2021 11:59:46 +0530
Message-Id: <20210930062948.1843919-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2562; h=from:subject; bh=M9koFlOVJkp/6jAmJJz+OUivbhxvE6O8If2Ut6u4ugM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlCVM3zd/WdLieVOADL7sw4rjtCSeFpxEXaM4iH YXAkcueJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQgAKCRBM4MiGSL8RykK4D/ 4/Q2FkuAgbN/SAxe4KyuLAA0CgZtVLiItG6SO31cXrwDi5pjw0RWy38JE2mw7cxJPzixPfxu1f+8fm u0a/xPV4JW5xX49w970UsF4GUwpQA1hmfeNwKNKlsbxS9dW3WgjptyzK9hIsZtnqGQ/TJEL9Sfc4gb aGA/yEXMCh4stPvfbrbIVeNXLRQs6gLW/NBqz/pCGtFf4AZINM1DKzxBjRVBNRE0UdIYVxgJFngtkI vy3rQfm7piSDY2FCjyEorCIK728Ay3jprHXhKmCjZGV5c4OdX6Q5ML+GfSZtcBYb/ppdbpAEATXvXd XmNoPQETyXWkIMb58oguItYuswa1e0NeGX0z3dWl3e/KeDtOzO3PJ4RSZ+Qjz/fsIJaJS7NtTsuY84 E9oAZzCsIgWvNCannfZPA10Qv2W9Yyt2CYbXHcmF9B24zZXiED7vAfyKcivs3uo0tueBLjbuJSDFLC 72Ofk3qLxRUJhVeiWfAuGTSoWAzW6CRPUxMXopMhMG8PjJaQSN1adbQNwu60PYwZhCyt71uSsRQS0X 2RDwWuuP3IIgz5oSahzWn8dTxA3RC5tJqT634evMaC+QbEyxiPFw9H9E5YzVeXf8fzGQ9NYt9Mff9Z XpCnRxgmMNwEzMgSIKaMCdyqWFmDvMdY81Y1OrhUsTCrZxaFDKyUdrgpSOzA==
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
index 8943a56f4fcb..a750ee5d8035 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3442,11 +3442,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
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
@@ -5395,8 +5390,13 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
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
@@ -6786,9 +6786,9 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
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
@@ -6841,7 +6841,9 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
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

