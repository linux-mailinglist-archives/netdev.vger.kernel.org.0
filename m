Return-Path: <netdev+bounces-8841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E46ED725FC8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A8191C20E97
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266F51F952;
	Wed,  7 Jun 2023 12:41:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A14E1426E;
	Wed,  7 Jun 2023 12:41:08 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB901988;
	Wed,  7 Jun 2023 05:40:43 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51491b87565so1475729a12.1;
        Wed, 07 Jun 2023 05:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686141600; x=1688733600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBz2MV4ztkt691mrrB3N7hlq0WVgCYoQcpwdekr5XV0=;
        b=r2axeMD7pa5eUbn2PSOaNvou4awVkiAgtBMdK05OnUTiPTCNRzbsd93yB5KWdJAJBx
         aiuEEXNMcyJ57TyABJqi5ZxU734RrU2egayQDci3VyFmGNurNFS1JQ7HLvZQCpU48UqE
         Ap9kQUa1/6B6ePXRseYcrMLJ1b0vTVlLh2u7cYQFlSuTrpqW2zRceIkVkhxtt/609MxD
         YrUZfExyl4o8aph+EGVGOEQ5BewO7xJXi6lPvKzfMxt5kZ+P3AvVHuzQ8UCCBYcVDPBC
         /I+XnERJ3HJbel9+ZQj8JlFFpSO9vaV+pUiWtKsKg4rer9L7QV42hJ9rneqmeSOu2YaJ
         wwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686141600; x=1688733600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBz2MV4ztkt691mrrB3N7hlq0WVgCYoQcpwdekr5XV0=;
        b=cv/gEE7hIzttfpJK+ZSzGESztde3c2/lmm1XcqO9c8BdddnbITBg9y1U7ELFlLc7tZ
         nTNCAoDKzjM9VL+QE+WgvZaOo5ZEO5dkK2D8ltTP1kKitL7F2z9BlOIrpdjMLO/w4wnP
         kR/pv+aEJlXY4Vaq8BOpsayFm1zEolqruTj9MBtieI6QK8aIvS9/p1g2XGHUyAmPOCDP
         6VZO4f7a+osdZfQrAZOsVeuvBBrPuUBbJ05kBJp0J+rnePuIemcRScTdSeUYaqAqSvUi
         cGvqI6kEPY6oLjwziogyaZiuGJgvAVEnMlGRKt/kXtGTGDK5pj0O1KmtjsOvYEVKs0Jl
         +afA==
X-Gm-Message-State: AC+VfDw+v9RgtmZp42lfULGoFPl3pzEAFn91rod7+mmaDQrbTCIGqleL
	/d5t9BIFnqNGymej2JaToRxXNlgp3WXWROW/Rh8=
X-Google-Smtp-Source: ACHHUZ6FxDnAxua6geAAvzRbOYl0As0JGMHFLUcojlHJZyN1WrWlLUBxp3/J6donrAgh3Njt7XtM1Q==
X-Received: by 2002:aa7:c507:0:b0:50c:3dc:2262 with SMTP id o7-20020aa7c507000000b0050c03dc2262mr3653027edq.39.1686141599613;
        Wed, 07 Jun 2023 05:39:59 -0700 (PDT)
Received: from localhost (tor-exit-48.for-privacy.net. [185.220.101.48])
        by smtp.gmail.com with ESMTPSA id c26-20020aa7df1a000000b0051560edc8d4sm6151436edy.45.2023.06.07.05.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:39:59 -0700 (PDT)
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
Subject: [PATCH bpf v4 2/2] selftests/bpf: Add test cases to assert proper ID tracking on spill
Date: Wed,  7 Jun 2023 15:39:51 +0300
Message-Id: <20230607123951.558971-3-maxtram95@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607123951.558971-1-maxtram95@gmail.com>
References: <20230607123951.558971-1-maxtram95@gmail.com>
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

The previous commit fixed a verifier bypass by ensuring that ID is not
preserved on narrowing spills. Add the test cases to check the
problematic patterns.

Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
---
 .../selftests/bpf/progs/verifier_spill_fill.c | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index 136e5530b72c..6115520154e3 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -371,4 +371,83 @@ __naked void and_then_at_fp_8(void)
 "	::: __clobber_all);
 }
 
+SEC("xdp")
+__description("32-bit spill of 64-bit reg should clear ID")
+__failure __msg("math between ctx pointer and 4294967295 is not allowed")
+__naked void spill_32bit_of_64bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	r1 = 0xffffffff;				\
+	r1 <<= 32;					\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 32-bit spill r1 to stack - should clear the ID! */\
+	*(u32*)(r10 - 8) = r1;				\
+	/* 32-bit fill r2 from stack. */		\
+	r2 = *(u32*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 32;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffffffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("xdp")
+__description("16-bit spill of 32-bit reg should clear ID")
+__failure __msg("dereference of modified ctx ptr R6 off=65535 disallowed")
+__naked void spill_16bit_of_32bit_fail(void)
+{
+	asm volatile ("					\
+	r6 = r1;					\
+	/* Roll one bit to force the verifier to track both branches. */\
+	call %[bpf_get_prandom_u32];			\
+	r0 &= 0x8;					\
+	/* Put a large number into r1. */		\
+	w1 = 0xffff0000;				\
+	r1 += r0;					\
+	/* Assign an ID to r1. */			\
+	r2 = r1;					\
+	/* 16-bit spill r1 to stack - should clear the ID! */\
+	*(u16*)(r10 - 8) = r1;				\
+	/* 16-bit fill r2 from stack. */		\
+	r2 = *(u16*)(r10 - 8);				\
+	/* Compare r2 with another register to trigger find_equal_scalars.\
+	 * Having one random bit is important here, otherwise the verifier cuts\
+	 * the corners. If the ID was mistakenly preserved on spill, this would\
+	 * cause the verifier to think that r1 is also equal to zero in one of\
+	 * the branches, and equal to eight on the other branch.\
+	 */						\
+	r3 = 0;						\
+	if r2 != r3 goto l0_%=;				\
+l0_%=:	r1 >>= 16;					\
+	/* At this point, if the verifier thinks that r1 is 0, an out-of-bounds\
+	 * read will happen, because it actually contains 0xffff.\
+	 */						\
+	r6 += r1;					\
+	r0 = *(u32*)(r6 + 0);				\
+	exit;						\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.40.1


