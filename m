Return-Path: <netdev+bounces-7320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B8771FA86
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 823F22816CF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9855D46B3;
	Fri,  2 Jun 2023 07:02:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8154F10E5;
	Fri,  2 Jun 2023 07:02:27 +0000 (UTC)
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C610518C;
	Fri,  2 Jun 2023 00:02:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 98e67ed59e1d1-25632c99eecso812975a91.2;
        Fri, 02 Jun 2023 00:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689344; x=1688281344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMePapRvx579minlQSYMxdALrJ1DqOKehZl4zrZxhok=;
        b=BxLYbhTWK8mJwbyPR/LlyVGVuQAcXwfCxqSsMg2YPA03+bbXxEdgOFXnqXRBM69X2q
         zmyFvjlMhIJ8vCnJt2rNASjwWqysYKceTpfaLCPhhSn9n38Z0xsqaU3ChoLXS7CXmOt+
         N8Yub2RgyYxgM5iRVj7tcFwCKCjgha77xlAgdyUWN7b0y5rwy8geyPSo3ViN8tb9XS2G
         8dorEvu+d7B9p0/tz0cp1BnFeOYYoSrJkpN46AaBm+D46ErKloGm9Zfw6LhIG/ns094b
         kvBM0UePowXsDo6wpLojXTbdMXcflBblDyIAdQYSYlKVGsVb1E2x7qYM4ABpwq58XIpY
         i59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689344; x=1688281344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMePapRvx579minlQSYMxdALrJ1DqOKehZl4zrZxhok=;
        b=aYgiIhQrhAFaqoy+5Ja2n2I4Og2tYKMpbOnbiNzpgMTUR9+0MibP590GJn0mNgeqzx
         vJF+jwfG1K9Cjmw0zU6BS4Sqbv6svQLB2t4q2apeh7BJJButC5PJ3Zs5DpBgfUgFQ7aw
         sxvS7IqvX9r4IzZHcsl4Mic3YbUA9FJI7A74R5kB1O5BxUntm8Ry1JJLWyARoaBSG6HA
         HxB/mgzLQ5hvlHbJj/zdjVH4+QKO4cwCSFLC/dugB8VdtC+ke+rvLAM4w7y+p+YeDsSq
         BX7qXTm104zq1P9TfCcmRpr7pKj3qPyrx73z1Y8kCDAv6oHJQcs84Med1c8epHmJmRNE
         +kDA==
X-Gm-Message-State: AC+VfDzSzN1nVN7MOon7ohw/yHjVetktKiqmuFd5tu0yzjz6p8xi7hZb
	mNu+arsn6SQwT1odLjSd4+M=
X-Google-Smtp-Source: ACHHUZ5IYjqhQm+F1PrAShDiEjyMvthdktQ1ZccrIx7qbruCP1ksSKYkta6wA7EWSDdOOkm+qyUejg==
X-Received: by 2002:a17:902:ef85:b0:1b1:9272:55f3 with SMTP id iz5-20020a170902ef8500b001b1927255f3mr776489plb.66.1685689344095;
        Fri, 02 Jun 2023 00:02:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b001ac7c725c1asm572716plb.6.2023.06.02.00.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:02:23 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: olsajiri@gmail.com
Cc: davem@davemloft.net,
	dsahern@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org,
	benbjiang@tencent.com,
	iii@linux.ibm.com,
	imagedong@tencent.com,
	xukuohai@huawei.com,
	chantr4@gmail.com,
	zwisler@google.com,
	eddyz87@gmail.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 3/5] libbpf: make BPF_PROG support 15 function arguments
Date: Fri,  2 Jun 2023 14:59:56 +0800
Message-Id: <20230602065958.2869555-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602065958.2869555-1-imagedong@tencent.com>
References: <20230602065958.2869555-1-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Menglong Dong <imagedong@tencent.com>

Now that we changed MAX_BPF_FUNC_ARGS from 12 to 14, we should update
BPF_PROG() too.

Extend BPF_PROG() to make it support 15 arguments, 14 for kernel
function arguments and 1 for return value of FEXIT.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 tools/lib/bpf/bpf_helpers.h |  9 ++++++---
 tools/lib/bpf/bpf_tracing.h | 10 ++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index bbab9ad9dc5a..d1574491cf16 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -194,11 +194,13 @@ enum libbpf_tristate {
 #define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
 #endif
 #ifndef ___bpf_nth
-#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
+#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c,	\
+		   _d, _e, _f, N, ...) N
 #endif
 #ifndef ___bpf_narg
 #define ___bpf_narg(...) \
-	___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+	___bpf_nth(_, ##__VA_ARGS__, 15, 14, 13, 12, 11, 10, 9, 8, 7,	\
+		   6, 5, 4, 3, 2, 1, 0)
 #endif
 
 #define ___bpf_fill0(arr, p, x) do {} while (0)
@@ -290,7 +292,8 @@ enum libbpf_tristate {
 #define ___bpf_pick_printk(...) \
 	___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,	\
 		   __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,		\
-		   __bpf_vprintk, __bpf_vprintk, __bpf_printk /*3*/, __bpf_printk /*2*/,\
+		   __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,		\
+		   __bpf_vprintk, __bpf_printk /*3*/, __bpf_printk /*2*/,		\
 		   __bpf_printk /*1*/, __bpf_printk /*0*/)
 
 /* Helper macro to print out debug messages */
diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index be076a4041ab..4e940239f1c1 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -628,10 +628,13 @@ struct pt_regs;
 #define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
 #endif
 #ifndef ___bpf_nth
-#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
+#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c,	\
+		   _d, _e, _f, N, ...) N
 #endif
 #ifndef ___bpf_narg
-#define ___bpf_narg(...) ___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+#define ___bpf_narg(...) \
+	___bpf_nth(_, ##__VA_ARGS__, 15, 14, 13, 12, 11, 10, 9, 8, 7,	\
+		   6, 5, 4, 3, 2, 1, 0)
 #endif
 
 #define ___bpf_ctx_cast0()            ctx
@@ -647,6 +650,9 @@ struct pt_regs;
 #define ___bpf_ctx_cast10(x, args...) ___bpf_ctx_cast9(args), (void *)ctx[9]
 #define ___bpf_ctx_cast11(x, args...) ___bpf_ctx_cast10(args), (void *)ctx[10]
 #define ___bpf_ctx_cast12(x, args...) ___bpf_ctx_cast11(args), (void *)ctx[11]
+#define ___bpf_ctx_cast13(x, args...) ___bpf_ctx_cast12(args), (void *)ctx[12]
+#define ___bpf_ctx_cast14(x, args...) ___bpf_ctx_cast13(args), (void *)ctx[13]
+#define ___bpf_ctx_cast15(x, args...) ___bpf_ctx_cast14(args), (void *)ctx[14]
 #define ___bpf_ctx_cast(args...)      ___bpf_apply(___bpf_ctx_cast, ___bpf_narg(args))(args)
 
 /*
-- 
2.40.1


