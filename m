Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A837C40BF32
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhIOFLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbhIOFLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53B2C0613D8;
        Tue, 14 Sep 2021 22:10:12 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k24so1536807pgh.8;
        Tue, 14 Sep 2021 22:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=32BI41DAg22Ier2vT7ndI8G/NSyHXIlhQoTx3oswHc8=;
        b=fLw3ok9jwhHdOvDjfyXnxkam+ErK606yyYPJ1SfOhZtuFbT0NImqxxOwygrooTD3Eb
         Fm8km2Us/XPVLIXwXTF+DbIz0eqABvzFpE4izYil63kkF4ffQQ6b5iEQ+VS6r9m2nZ3I
         JU+7i1Tgi6sd2tEjjmv1ItXN1EjA6pgN8g3terCh/4WCIZodx+MmZhYnbiQ+m0h0nMdk
         WS9HTqUhT/7Ky84Bgmrlx279X6cysxnEyQ9AfXN8+i3I2/r7JfGeskGtwILEe1YDUX0O
         GeG25mTbfmUURfKV8ukZrax/YhX5kg9HRxfLfdy1thDTDQwQ+CAfn9q+7dEGHLwEWwnX
         A20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=32BI41DAg22Ier2vT7ndI8G/NSyHXIlhQoTx3oswHc8=;
        b=NOAsWMJL+mE2WCDZ2rE99+J+XXHaRf9Ul6i1diggvHMwSg9o/Kvzw+ZjCP6nQVOyeL
         so9lLt9f2YQbFx7b27fG4uHfHCmvEiYnwsMjcCtGbqdVQfIZaLNeqWEY6YRJS/hTZxTT
         tUOIzuXBqX/VlATxQqjx50+J8PcypTObu7qLRqSMIIUQlyk7apatUPRlnPz845kkAfMR
         VY+TOkRGBUDribofZP3MeETSA2LKdp0312Rjrsmvl6/4ImZ6Do9BXQMElPr1rpg7aV3Q
         eoP/d8J+Q108S2OFwAID+nzbpb54YZsV63u6nCnuFdrgDCcnZu8qsbQsWcrn79MoTXsM
         4SoQ==
X-Gm-Message-State: AOAM5314rDKYPP2N1Y1PC/NbRtuvNa/+ROHTQT2Ie8nk749Ct6LTqI/R
        odBaQ44CNu4xKfZZ22cfaAuW2zEil+q6Jw==
X-Google-Smtp-Source: ABdhPJzsk4DtMzTZ3BXfTKxOhbYo0EZhTec1ZDSdVt065GEg1qDTb26i4qgBXPKJXo9zsBUv+uN2+A==
X-Received: by 2002:aa7:9ec7:0:b0:43d:c46d:2540 with SMTP id r7-20020aa79ec7000000b0043dc46d2540mr8484642pfq.24.1631682612331;
        Tue, 14 Sep 2021 22:10:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id a11sm660913pfo.31.2021.09.14.22.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:12 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 08/10] libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
Date:   Wed, 15 Sep 2021 10:39:41 +0530
Message-Id: <20210915050943.679062-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; h=from:subject; bh=rxxSOTg/nYpcMpKfo1S2l+qYHiC3uCZSg3+Tco5RqP4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4ceLBvB1x690/KaUTOqBvLZOlJsioqVaTbDN7k EdXkS+6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+HAAKCRBM4MiGSL8Rygp3EA CCyOt/GPw5/hLocm93Vk+33/vpjO4yuR4h+hArdxlYIVcxAmTSYHEV69//Xx7ugT4UO2HkdHUpKNdJ ucvxxC4Rlkpsla+ELWq6LMM2xF1tu8G8muy3CIinZ2uJMcodRBOAoV9ep7Nsy2gH91iY2zwKyBkzzE HlhFX4MLSgVq5hbC0HWU74Fjxr0sfCgcx/iC7lFeuT3voHyKMd3GM0pbARDMFB7P+UFGLt4JkBT+8h TdTOn6ABj/89DowGuf/J0NkAe75jMzRr1AghiQ+kVjk7nVED9EKYttBz4HuYypo+QSzfzaq9pXCzuB yn9+5pzGhPAKoEepWF53MfYUTUOlmRQ4P+TQJAMOiV9Y7lAG1K3Tf+P6FIIU3F82bEGQAnjGF+pR7T g9UZMT6/psbkacuIoSFThiuqqqY72Je0fNkoADRj2erGIGP/sPYklou4XMKyv9dc1Uw16bncXt2R9B 98qCpfdZTdSvjHDF3aNC8DN74XHsibL2CnyPEoFlk0QLSdbY+gkhaHYmsO17pmeOjf0+GuliGhRDS/ H0KxdDZt2WfsQBKQXTFhSU7Fa/dajnD18xWf51zvsRKEDGiT2b2EixG528BaN9Rws0lfmXqTwnSVku VMEv3HQgSFhQEPfsIr71N0XTcOLKtpPVwG+ou+KpWNgdAFn+z47TZqWlLv+w==
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

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index accf2586fa76..50a7c995979a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3413,11 +3413,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
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
@@ -5366,8 +5361,12 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 		case RELO_EXTERN_FUNC:
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
-			insn[0].imm = ext->ksym.kernel_btf_id;
-			insn[0].off = ext->ksym.offset;
+			if (ext->is_set) {
+				insn[0].imm = ext->ksym.kernel_btf_id;
+				insn[0].off = ext->ksym.offset;
+			} else { /* unresolved weak kfunc */
+				insn[0].imm = insn[0].off = 0;
+			}
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6765,8 +6764,10 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
 	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
 				    &kern_btf, &kern_btf_fd);
-	if (kfunc_id < 0) {
-		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+	if (kfunc_id == -ESRCH && ext->is_weak) {
+		return 0;
+	} else if (kfunc_id < 0) {
+		pr_warn("extern (func ksym) '%s': not found in kernel or module BTFs\n",
 			ext->name);
 		return kfunc_id;
 	}
-- 
2.33.0

