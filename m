Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93095427EF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbiFHHYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241602AbiFHGvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:51:04 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F53D16FEE1;
        Tue,  7 Jun 2022 23:40:23 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id f12so15922034ilj.1;
        Tue, 07 Jun 2022 23:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+TZw49Nhe+7KCyWBI9zirTshVFrJDlXh7Li47Plf5DE=;
        b=ZuGCQmPZvHWxI3dMPvLjZe63NAcX2ayiQmfiQCLHph+VmJzgG+DiAgWRh4CO6azaGP
         C56cDAEORo4OCaxi1+xbLbtnoTslKivQhVdt3A4Y5fkYhEZGLxhwgls6cVgDBv/m2aNi
         KG0DxxEX0LLIx152vuJyL1bU55vBDZT7icZZHGcBD63fLoRdog4t/i23zsruPntYB5Qf
         jaHhndrw15hW9E/D6SBH84cJL7w0qUEu0IqcwqmqdEEDMekXniWyLfw9saSn7z/UzDJ3
         rw7Eql/aSISL12tmb34nlOinmFpVOsGr1oTDvZO/jMF5Cu/Gb8G95KFbonUV9/+EuAxa
         CBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+TZw49Nhe+7KCyWBI9zirTshVFrJDlXh7Li47Plf5DE=;
        b=SMFxWBTqwGcpGzpU8zxPE3I3IJgRu915gHSRHB67aBqGqJxy+W3gER2HV+oy4vKO3a
         GWS2Mo5+pSaYWxmRiELlxW9vvK5xVxubdbUclmIKFVwE+TNXMndZdbTpN3JyNxdMpAL0
         c0n7BYChK4/pzEd45Qyd3MVLVJkBbzMQvF129qFgZq849Z2gkg9jNZeC6GPzvKxL8rqE
         Uvqv7XNt/l9R1eM/g9GkaYsl2r9SJZMjdQD/jfJtUxRm8gdpxr/jHWKbl3EzrX4Yvg00
         Zfzjy1ahBaCG+tR0QZW5sLLsmvn6TM9XiTfNM6qH1judrhejP2gJIIriIVQ1dXtiGD8D
         V1Og==
X-Gm-Message-State: AOAM5311UfsD1xuSl15n56oor9pU3JrW4J6lHk/PMAnMy+SkkPCFHlIv
        EN+Xds2dYdr4dlqxq8lf/bFkKaBWct+3Sg==
X-Google-Smtp-Source: ABdhPJwTYMwPcLFop1K/7b8HRmdDAnYMeWciLLju6fqcS6ER86+s0/D1sV0oRJzrBulPwmGlEb1eDA==
X-Received: by 2002:a05:6e02:1649:b0:2d5:199d:249c with SMTP id v9-20020a056e02164900b002d5199d249cmr10628998ilu.70.1654670422209;
        Tue, 07 Jun 2022 23:40:22 -0700 (PDT)
Received: from james-x399.localdomain (71-218-113-86.hlrn.qwest.net. [71.218.113.86])
        by smtp.gmail.com with ESMTPSA id f6-20020a056602038600b00665862d12bbsm7503501iov.46.2022.06.07.23.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 23:40:21 -0700 (PDT)
From:   James Hilliard <james.hilliard1@gmail.com>
To:     bpf@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/1] libbpf: replace typeof with __typeof__
Date:   Wed,  8 Jun 2022 00:40:03 -0600
Message-Id: <20220608064004.1493239-1-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems the gcc preprocessor breaks when typeof is used with
macros.

Fixes errors like:
error: expected identifier or '(' before '#pragma'
  106 | SEC("cgroup/bind6")
      | ^~~

error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
  114 | char _license[] SEC("license") = "GPL";
      | ^~~

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
Changes v1 -> v2:
  - replace typeof with __typeof__ instead of changing pragma macros
---
 tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
 tools/lib/bpf/bpf_helpers.h     |  4 ++--
 tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
 tools/lib/bpf/btf.h             |  4 ++--
 tools/lib/bpf/libbpf_internal.h |  6 +++---
 tools/lib/bpf/usdt.bpf.h        |  6 +++---
 tools/lib/bpf/xsk.h             | 12 ++++++------
 7 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index fd48b1ff59ca..d3a88721c9e7 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -111,7 +111,7 @@ enum bpf_enum_value_kind {
 })
 
 #define ___bpf_field_ref1(field)	(field)
-#define ___bpf_field_ref2(type, field)	(((typeof(type) *)0)->field)
+#define ___bpf_field_ref2(type, field)	(((__typeof__(type) *)0)->field)
 #define ___bpf_field_ref(args...)					    \
 	___bpf_apply(___bpf_field_ref, ___bpf_narg(args))(args)
 
@@ -161,7 +161,7 @@ enum bpf_enum_value_kind {
  * BTF. Always succeeds.
  */
 #define bpf_core_type_id_local(type)					    \
-	__builtin_btf_type_id(*(typeof(type) *)0, BPF_TYPE_ID_LOCAL)
+	__builtin_btf_type_id(*(__typeof__(type) *)0, BPF_TYPE_ID_LOCAL)
 
 /*
  * Convenience macro to get BTF type ID of a target kernel's type that matches
@@ -171,7 +171,7 @@ enum bpf_enum_value_kind {
  *    - 0, if no matching type was found in a target kernel BTF.
  */
 #define bpf_core_type_id_kernel(type)					    \
-	__builtin_btf_type_id(*(typeof(type) *)0, BPF_TYPE_ID_TARGET)
+	__builtin_btf_type_id(*(__typeof__(type) *)0, BPF_TYPE_ID_TARGET)
 
 /*
  * Convenience macro to check that provided named type
@@ -181,7 +181,7 @@ enum bpf_enum_value_kind {
  *    0, if no matching type is found.
  */
 #define bpf_core_type_exists(type)					    \
-	__builtin_preserve_type_info(*(typeof(type) *)0, BPF_TYPE_EXISTS)
+	__builtin_preserve_type_info(*(__typeof__(type) *)0, BPF_TYPE_EXISTS)
 
 /*
  * Convenience macro to get the byte size of a provided named type
@@ -191,7 +191,7 @@ enum bpf_enum_value_kind {
  *    0, if no matching type is found.
  */
 #define bpf_core_type_size(type)					    \
-	__builtin_preserve_type_info(*(typeof(type) *)0, BPF_TYPE_SIZE)
+	__builtin_preserve_type_info(*(__typeof__(type) *)0, BPF_TYPE_SIZE)
 
 /*
  * Convenience macro to check that provided enumerator value is defined in
@@ -202,7 +202,7 @@ enum bpf_enum_value_kind {
  *    0, if no matching enum and/or enum value within that enum is found.
  */
 #define bpf_core_enum_value_exists(enum_type, enum_value)		    \
-	__builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENUMVAL_EXISTS)
+	__builtin_preserve_enum_value(*(__typeof__(enum_type) *)enum_value, BPF_ENUMVAL_EXISTS)
 
 /*
  * Convenience macro to get the integer value of an enumerator value in
@@ -213,7 +213,7 @@ enum bpf_enum_value_kind {
  *    0, if no matching enum and/or enum value within that enum is found.
  */
 #define bpf_core_enum_value(enum_type, enum_value)			    \
-	__builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENUMVAL_VALUE)
+	__builtin_preserve_enum_value(*(__typeof__(enum_type) *)enum_value, BPF_ENUMVAL_VALUE)
 
 /*
  * bpf_core_read() abstracts away bpf_probe_read_kernel() call and captures
@@ -300,7 +300,7 @@ enum bpf_enum_value_kind {
 #define ___arrow10(a, b, c, d, e, f, g, h, i, j) a->b->c->d->e->f->g->h->i->j
 #define ___arrow(...) ___apply(___arrow, ___narg(__VA_ARGS__))(__VA_ARGS__)
 
-#define ___type(...) typeof(___arrow(__VA_ARGS__))
+#define ___type(...) __typeof__(___arrow(__VA_ARGS__))
 
 #define ___read(read_fn, dst, src_type, src, accessor)			    \
 	read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index fb04eaf367f1..859604345e03 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -11,8 +11,8 @@
 #include "bpf_helper_defs.h"
 
 #define __uint(name, val) int (*name)[val]
-#define __type(name, val) typeof(val) *name
-#define __array(name, val) typeof(val) *name[]
+#define __type(name, val) __typeof__(val) *name
+#define __array(name, val) __typeof__(val) *name[]
 
 /*
  * Helper macro to place programs, maps, license in
diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 01ce121c302d..d64fcf01ea20 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -424,16 +424,16 @@ struct pt_regs;
  */
 #define BPF_PROG(name, args...)						    \
 name(unsigned long long *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(unsigned long long *ctx, ##args);				    \
-typeof(name(0)) name(unsigned long long *ctx)				    \
+__typeof__(name(0)) name(unsigned long long *ctx)			    \
 {									    \
 	_Pragma("GCC diagnostic push")					    \
 	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
 	return ____##name(___bpf_ctx_cast(args));			    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(unsigned long long *ctx, ##args)
 
 struct pt_regs;
@@ -458,16 +458,16 @@ struct pt_regs;
  */
 #define BPF_KPROBE(name, args...)					    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args);				    \
-typeof(name(0)) name(struct pt_regs *ctx)				    \
+__typeof__(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
 	_Pragma("GCC diagnostic push")					    \
 	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
 	return ____##name(___bpf_kprobe_args(args));			    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args)
 
 #define ___bpf_kretprobe_args0()       ctx
@@ -482,16 +482,16 @@ ____##name(struct pt_regs *ctx, ##args)
  */
 #define BPF_KRETPROBE(name, args...)					    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args);				    \
-typeof(name(0)) name(struct pt_regs *ctx)				    \
+__typeof__(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
 	_Pragma("GCC diagnostic push")					    \
 	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
 	return ____##name(___bpf_kretprobe_args(args));			    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
+static __always_inline __typeof__(name(0)) ____##name(struct pt_regs *ctx, ##args)
 
 #define ___bpf_syscall_args0()           ctx
 #define ___bpf_syscall_args1(x)          ___bpf_syscall_args0(), (void *)PT_REGS_PARM1_CORE_SYSCALL(regs)
@@ -515,9 +515,9 @@ static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
  */
 #define BPF_KPROBE_SYSCALL(name, args...)				    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args);				    \
-typeof(name(0)) name(struct pt_regs *ctx)				    \
+__typeof__(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
 	struct pt_regs *regs = PT_REGS_SYSCALL_REGS(ctx);		    \
 	_Pragma("GCC diagnostic push")					    \
@@ -525,7 +525,7 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
 	return ____##name(___bpf_syscall_args(args));			    \
 	_Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args)
 
 #endif
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 9fb416eb5644..c39ef51c361b 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -322,8 +322,8 @@ LIBBPF_API struct btf_dump *btf_dump__new_deprecated(const struct btf *btf,
  */
 #ifndef __cplusplus
 #define btf_dump__new(a1, a2, a3, a4) __builtin_choose_expr(				\
-	__builtin_types_compatible_p(typeof(a4), btf_dump_printf_fn_t) ||		\
-	__builtin_types_compatible_p(typeof(a4), void(void *, const char *, va_list)),	\
+	__builtin_types_compatible_p(__typeof__(a4), btf_dump_printf_fn_t) ||		\
+	__builtin_types_compatible_p(__typeof__(a4), void(void *, const char *, va_list)),	\
 	btf_dump__new_deprecated((void *)a1, (void *)a2, (void *)a3, (void *)a4),	\
 	btf_dump__new((void *)a1, (void *)a2, (void *)a3, (void *)a4))
 #endif
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index a1ad145ffa74..259664c1dedb 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -138,7 +138,7 @@ static inline bool str_has_sfx(const char *str, const char *sfx)
 
 #define COMPAT_VERSION(internal_name, api_name, version)
 #define DEFAULT_VERSION(internal_name, api_name, version) \
-	extern typeof(internal_name) api_name \
+	extern __typeof__(internal_name) api_name \
 	__attribute__((alias(#internal_name)));
 
 #endif
@@ -300,7 +300,7 @@ static inline bool libbpf_validate_opts(const char *opts,
 						     type##__last_field),     \
 					 (opts)->sz, #type))
 #define OPTS_HAS(opts, field) \
-	((opts) && opts->sz >= offsetofend(typeof(*(opts)), field))
+	((opts) && opts->sz >= offsetofend(__typeof__(*(opts)), field))
 #define OPTS_GET(opts, field, fallback_value) \
 	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
 #define OPTS_SET(opts, field, value)		\
@@ -311,7 +311,7 @@ static inline bool libbpf_validate_opts(const char *opts,
 
 #define OPTS_ZEROED(opts, last_nonzero_field)				      \
 ({									      \
-	ssize_t __off = offsetofend(typeof(*(opts)), last_nonzero_field);     \
+	ssize_t __off = offsetofend(__typeof__(*(opts)), last_nonzero_field); \
 	!(opts) || libbpf_is_mem_zeroed((const void *)opts + __off,	      \
 					(opts)->sz - __off);		      \
 })
diff --git a/tools/lib/bpf/usdt.bpf.h b/tools/lib/bpf/usdt.bpf.h
index 4181fddb3687..a822e181371c 100644
--- a/tools/lib/bpf/usdt.bpf.h
+++ b/tools/lib/bpf/usdt.bpf.h
@@ -244,16 +244,16 @@ long bpf_usdt_cookie(struct pt_regs *ctx)
  */
 #define BPF_USDT(name, args...)						    \
 name(struct pt_regs *ctx);						    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args);				    \
-typeof(name(0)) name(struct pt_regs *ctx)				    \
+__typeof__(name(0)) name(struct pt_regs *ctx)				    \
 {									    \
         _Pragma("GCC diagnostic push")					    \
         _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
         return ____##name(___bpf_usdt_args(args));			    \
         _Pragma("GCC diagnostic pop")					    \
 }									    \
-static __attribute__((always_inline)) typeof(name(0))			    \
+static __attribute__((always_inline)) __typeof__(name(0))		    \
 ____##name(struct pt_regs *ctx, ##args)
 
 #endif /* __USDT_BPF_H__ */
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 64e9c57fd792..631549817976 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -36,8 +36,8 @@ extern "C" {
  * LIBRARY INTERNAL
  */
 
-#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
-#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
+#define __XSK_READ_ONCE(x) (*(volatile __typeof__(x) *)&x)
+#define __XSK_WRITE_ONCE(x, v) (*(volatile __typeof__(x) *)&x) = (v)
 
 #if defined(__i386__) || defined(__x86_64__)
 # define libbpf_smp_store_release(p, v)					\
@@ -47,7 +47,7 @@ extern "C" {
 	} while (0)
 # define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
+		__typeof__(*p) ___p1 = __XSK_READ_ONCE(*p);		\
 		asm volatile("" : : : "memory");			\
 		___p1;							\
 	})
@@ -56,7 +56,7 @@ extern "C" {
 		asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
 # define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1;					\
+		__typeof__(*p) ___p1;					\
 		asm volatile ("ldar %w0, %1"				\
 			      : "=r" (___p1) : "Q" (*p) : "memory");	\
 		___p1;							\
@@ -69,7 +69,7 @@ extern "C" {
 	} while (0)
 # define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
+		__typeof__(*p) ___p1 = __XSK_READ_ONCE(*p);		\
 		asm volatile ("fence r,rw" : : : "memory");		\
 		___p1;							\
 	})
@@ -86,7 +86,7 @@ extern "C" {
 #ifndef libbpf_smp_load_acquire
 #define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
+		__typeof__(*p) ___p1 = __XSK_READ_ONCE(*p);		\
 		__sync_synchronize();					\
 		___p1;							\
 	})
-- 
2.25.1

