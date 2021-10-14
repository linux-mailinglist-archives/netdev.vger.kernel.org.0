Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A27742E2F0
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhJNU7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhJNU7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:59:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61028C061570;
        Thu, 14 Oct 2021 13:56:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so5736297pjb.0;
        Thu, 14 Oct 2021 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIBZDBaGUfAw9sHdArTGEX3LfFoazzbF0+zs0od5ymY=;
        b=N6FpXh8OiyulM6obs4FwvY32eagCT0nROF2BPT7jPm/RW1b3dg45kPVICJZIDrHKFl
         lBxJASYhxUzNXHTOnFnFVeTYF4pLhZvDWp4wdTINikGjIH8FVYp6qji/i15ZEBmsvN+v
         8MUDF+m8I6tjJGg0PJ1pUh+Pu6fyeoU4/H/8WBx64r6PZmCiKWCc5hDt+Uyj/57e/Z/T
         7B0yCEr3IgwBJjE7rPrR8V8t3lILl/+nh9J0vWDEfpBRL4nSDf4Vo/yjgLdXQF1GDaxx
         8vao8lJ1JRPgxw+l/rLNFxxbCc7+KIg8IVgao8leSDKfoL4BncoM/CqIWXzqRBId4TKU
         suOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIBZDBaGUfAw9sHdArTGEX3LfFoazzbF0+zs0od5ymY=;
        b=IQHb5W9ftDdjTR9mYDqSSMQ7oVL8DkJE2hORl+P1+zgGsPFmmgS5NmSgL/Ok0F9i6L
         v087dnCIRiNE14oRrRP0Ogne72c1ssjbQNF7RH/NYnOJM7zWEF+gs1g0hOBJ9B2VBYwe
         xu0mh3vj8uArYjrSTOZcgyX3Ec4vctox9qr+4gPmyj5FAjuhM3m/MMNmvD5HJrk/53F4
         gGyMkxP1odWdeSNYnK+87X5nqvw4aJeuojgjWaPqekmFm8On187ja3TjCMt3FKG0pi/q
         PnJL/oO9VYyrOfucI3/5HkV6aUbqJuaZvpdHOsH7WtovFCZS+aJO5OJRw7icg3GYa1op
         hV0Q==
X-Gm-Message-State: AOAM533Sxgy/i27nzMvg6CIqm9ahrsbuXBCnVwaq8rqzmUi3yXSn4qWe
        +WLTs3kt8iOykOoz48SkW8X0EB/OTIk=
X-Google-Smtp-Source: ABdhPJwlm8LAj15x6b0um7vSKzDo+CV+HdID9VUIz2Egib1fbnehe6SeSPCaVXehp9m6iPy2uXkxqg==
X-Received: by 2002:a17:902:6544:b0:13e:dd16:bd5b with SMTP id d4-20020a170902654400b0013edd16bd5bmr7249804pln.61.1634245017595;
        Thu, 14 Oct 2021 13:56:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id y203sm3388442pfc.0.2021.10.14.13.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:56:57 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 3/8] libbpf: Add weak ksym support to gen_loader
Date:   Fri, 15 Oct 2021 02:26:39 +0530
Message-Id: <20211014205644.1837280-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014205644.1837280-1-memxor@gmail.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4419; h=from:subject; bh=1VQ1/iFVJpoiRLxzbIW/D2J/8lkqpuGtePqGsqfoYqE=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/w/wojqi9fIJB/cO7EvGYcsw/5nG8Q2FEpdHu DdbYBEWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8RyuqiD/ 9MKc4vF6Fo6D5AqGntXpa640DkgV6wtF9yHino2Pa+2C03e7yjG15DRfpX0t8wDq5ZRyjSLLrwFVXV ZV2z5al0PsCAGqmaFP1B0DO2eMIqCTKx9Wc0MdC7K31zM3vbNOKDh7qUxxj1/UE4b8j68eQ5K+2JA4 YPnquD9AhrXeSVTYTQ7LbenPKjZSlx65T/Yck4b3wiOMKjxCC/iy+3ftpSsQkpo0lxDnpvCri3Icbx 3MLEXSnxTN25Zi17wHKhkL5WiTfnQ/Fw5HIrgFTSEO6PZht95kN+UxtMBgXm35PU7JgA+M5hDetvc8 oA/TwQ81U6zt536NY/vx7+ObXfsqREzi8BcrLsuCVuKrspwPdVaF15eu6fvCS1537oCxzq7H7SimAQ j1f6iOrtwTb6FCLYrzcv+LcfBM6cX7gRc3X89xRTSE8IbvArsFzaurOR3dajGO0I3Vj6JG4ENgUpDl zwZmKxeAeslWtgp0zuSraw+HZBuCb5Pm0mGGl4PcWBdI5p2fXfy2gCDj7If3J5pc2ZCLFs4wbe0sT+ 2drPYZl8R0C2lo0MSfsI0M3UCqWWzFETbYJUkfQxKNG37GpD2yTrW1B4E1Mj1IGeGYyZqfHv8gXmgz ZsLTRcAsUctF+ERqnqHmF5kbkoPp7SX66xOkS1+K43dPxMlWF6h8Lr1ROxwg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extends existing ksym relocation code to also support relocating
weak ksyms. Care needs to be taken to zero out the src_reg (currently
BPF_PSEUOD_BTF_ID, always set for gen_loader by bpf_object__relocate_data)
when the BTF ID lookup fails at runtime.  This is not a problem for
libbpf as it only sets ext->is_set when BTF ID lookup succeeds (and only
proceeds in case of failure if ext->is_weak, leading to src_reg
remaining as 0 for weak unresolved ksym).

A pattern similar to emit_relo_kfunc_btf is followed of first storing
the default values and then jumping over actual stores in case of an
error. For src_reg adjustment, we also need to perform it when copying
the populated instruction, so depending on if copied insn[0].imm is 0 or
not, we decide to jump over the adjustment.

We cannot reach that point unless the ksym was weak and resolved and
zeroed out, as the emit_check_err will cause us to jump to cleanup
label, so we do not need to recheck whether the ksym is weak before
doing the adjustment after copying BTF ID and BTF FD.

This is consistent with how libbpf relocates weak ksym. Logging
statements are added to show the relocation result and aid debugging.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/gen_loader.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 11172a868180..1c404752e565 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -13,6 +13,7 @@
 #include "hashmap.h"
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
+#include <asm/byteorder.h>
 
 #define MAX_USED_MAPS	64
 #define MAX_USED_PROGS	32
@@ -776,12 +777,24 @@ static void emit_relo_ksym_typeless(struct bpf_gen *gen,
 	emit_ksym_relo_log(gen, relo, kdesc->ref);
 }
 
+static __u32 src_reg_mask(void)
+{
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	return 0x0f; /* src_reg,dst_reg,... */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	return 0xf0; /* dst_reg,src_reg,... */
+#else
+#error "Unsupported bit endianness, cannot proceed"
+#endif
+}
+
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  */
 static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
 {
 	struct ksym_desc *kdesc;
+	__u32 reg_mask;
 
 	kdesc = get_ksym_desc(gen, relo);
 	if (!kdesc)
@@ -792,19 +805,35 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
 			       kdesc->insn + offsetof(struct bpf_insn, imm));
 		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
 			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
-		goto log;
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_9, BPF_REG_8, offsetof(struct bpf_insn, imm)));
+		/* jump over src_reg adjustment if imm is not 0 */
+		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_9, 0, 3));
+		goto clear_src_reg;
 	}
 	/* remember insn offset, so we can copy BTF ID and FD later */
 	kdesc->insn = insn;
 	emit_bpf_find_by_name_kind(gen, relo);
-	emit_check_err(gen);
+	if (!relo->is_weak)
+		emit_check_err(gen);
+	/* set default values as 0 */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, offsetof(struct bpf_insn, imm), 0));
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 0));
+	/* skip success case stores if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
 	/* store btf_id into insn[insn_idx].imm */
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
 	/* store btf_obj_fd into insn[insn_idx + 1].imm */
 	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
 			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
-log:
+	emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));
+clear_src_reg:
+	/* clear bpf_object__relocate_data's src_reg assignment, otherwise we get a verifier failure */
+	reg_mask = src_reg_mask();
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	emit(gen, BPF_ALU32_IMM(BPF_AND, BPF_REG_9, reg_mask));
+	emit(gen, BPF_STX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, offsetofend(struct bpf_insn, code)));
+
 	emit_ksym_relo_log(gen, relo, kdesc->ref);
 }
 
-- 
2.33.0

