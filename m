Return-Path: <netdev+bounces-8631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF134724EF4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 484551C20BC7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74602DBC2;
	Tue,  6 Jun 2023 21:43:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62B2DBBD;
	Tue,  6 Jun 2023 21:43:09 +0000 (UTC)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1501E1702;
	Tue,  6 Jun 2023 14:43:08 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-5428f63c73aso3376559a12.1;
        Tue, 06 Jun 2023 14:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686087787; x=1688679787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bVp3sxGYYmvDAXqCieOLHVX04weYGZl76ejiM9qiOig=;
        b=fqET+JlDRntgb32iyH8TFVlq9tCg5tef16N87Ywknv/Aq2IVb8THmvh0ZaEPrvpmvb
         ItLXX3s1P+GOE833peHemYfag3nF1dNySynWachycA+Vlr0sYxjV9mtu8EiDuijtOTh8
         hNE5KaNjDjH8Oo8F+6EFagol7T1stiiEk21nGLK6tvPSvUP6+gjSmUFESAFEORXN1GUM
         xmhRql0x8ksYfnZSvBfI8xBDbd8lPVUPOQbB5cvt0JVdvrKaYaM5Lh078wGd7PIZkJo8
         xwcRtKCfiQxp8l4B3bgUCJXBw6iINzDwsEWHvUtMXVRR8DUkiC6MY4CtUYyJYHeOeI4t
         2krQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686087787; x=1688679787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVp3sxGYYmvDAXqCieOLHVX04weYGZl76ejiM9qiOig=;
        b=SsVLoVzQr04RXTQqLeaQsvxXy+n0tmPYwSWpLsOv00yYgpp2ihCR2iPevdWfhfUpcz
         renqdSLGd9NG4zziGqm5616EOfkRNeEOgHeLIl2uMTBWrZl9KyDoXIH+N6hU+wlAqpeD
         DzuE034H8Rp7YI6vUaQSzlN96qGabGAkVGBPLVCNEwBi31Jwrc//WtPZZKjwmapCRwH3
         3nIJqtLGmxy9Wo+oLE+maNn7HTNPsz1rXUyhhJLWYHo0BwghNY8NNnvEIPJBS9M2rBNA
         59l29fyUijOGtX63ri9UkcEHyI/TvNUxriSBwgdfrDZUE+9kT/uyaeLBwZ3RB8NEgLPY
         J/9g==
X-Gm-Message-State: AC+VfDxMk6K7sUcLmVZkRa3Yg4AIF/4oU+HNmXzDQGC2BSduhSa13l2W
	/nG3OCFb5UusFVOSLgDeeTPnphtO+FK6i9yh
X-Google-Smtp-Source: ACHHUZ6HTjhIseQC+YX/8i7KuQIZNvRMZxqXKIURAQEx6g1gRz8rkAFe31oux7Yb1V6BKUW61mc4yw==
X-Received: by 2002:a05:6a21:9101:b0:103:73a6:5cc1 with SMTP id tn1-20020a056a21910100b0010373a65cc1mr763646pzb.4.1686087787031;
        Tue, 06 Jun 2023 14:43:07 -0700 (PDT)
Received: from localhost ([87.118.116.103])
        by smtp.gmail.com with ESMTPSA id z9-20020a170902834900b001b0142908f7sm8880294pln.291.2023.06.06.14.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 14:43:06 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH bpf v3 1/2] bpf: Fix verifier tracking scalars on spill
Date: Wed,  7 Jun 2023 00:42:45 +0300
Message-Id: <20230606214246.403579-2-maxtram95@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606214246.403579-1-maxtram95@gmail.com>
References: <20230606214246.403579-1-maxtram95@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maxim Mikityanskiy <maxim@isovalent.com>

The following scenario describes a verifier bypass in privileged mode
(CAP_BPF or CAP_SYS_ADMIN):

1. Prepare a 32-bit rogue number.
2. Put the rogue number into the upper half of a 64-bit register, and
   roll a random (unknown to the verifier) bit in the lower half. The
   rest of the bits should be zero (although variations are possible).
3. Assign an ID to the register by MOVing it to another arbitrary
   register.
4. Perform a 32-bit spill of the register, then perform a 32-bit fill to
   another register. Due to a bug in the verifier, the ID will be
   preserved, although the new register will contain only the lower 32
   bits, i.e. all zeros except one random bit.

At this point there are two registers with different values but the same
ID, which means the integrity of the verifier state has been corrupted.
Next steps show the actual bypass:

5. Compare the new 32-bit register with 0. In the branch where it's
   equal to 0, the verifier will believe that the original 64-bit
   register is also 0, because it has the same ID, but its actual value
   still contains the rogue number in the upper half.
   Some optimizations of the verifier prevent the actual bypass, so
   extra care is needed: the comparison must be between two registers,
   and both branches must be reachable (this is why one random bit is
   needed). Both branches are still suitable for the bypass.
6. Right shift the original register by 32 bits to pop the rogue number.
7. Use the rogue number as an offset with any pointer. The verifier will
   believe that the offset is 0, while in reality it's the given number.

The fix is similar to the 32-bit BPF_MOV handling in check_alu_op for
SCALAR_VALUE. If the spill is narrowing the actual register value, don't
keep the ID, make sure it's reset to 0.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5871aa78d01a..7be23eced561 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3856,6 +3856,8 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	mark_stack_slot_scratched(env, spi);
 	if (reg && !(off % BPF_REG_SIZE) && register_is_bounded(reg) &&
 	    !register_is_null(reg) && env->bpf_capable) {
+		bool reg_value_fits;
+
 		if (dst_reg != BPF_REG_FP) {
 			/* The backtracking logic can only recognize explicit
 			 * stack slot address like [fp - 8]. Other spill of
@@ -3867,7 +3869,12 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 			if (err)
 				return err;
 		}
+
+		reg_value_fits = fls64(reg->umax_value) <= BITS_PER_BYTE * size;
 		save_register_state(state, spi, reg, size);
+		/* Break the relation on a narrowing spill. */
+		if (!reg_value_fits)
+			state->stack[spi].spilled_ptr.id = 0;
 	} else if (!reg && !(off % BPF_REG_SIZE) && is_bpf_st_mem(insn) &&
 		   insn->imm != 0 && env->bpf_capable) {
 		struct bpf_reg_state fake_reg = {};
-- 
2.40.1


