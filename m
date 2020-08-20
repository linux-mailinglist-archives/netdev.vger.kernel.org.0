Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3880424ADEE
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 06:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHTEmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 00:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgHTEmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 00:42:35 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF9C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 21:42:35 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id c4so451737otf.12
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 21:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=FiEubfhVKQC+gxzipOmlwKyOSEtNoGgQ3+pUJvMJppU=;
        b=EP10b80FRDQbTLZg1uUW0jXpO8+gzwQho5mOSLFnCLHPyG87leXl2JFGqtZiSODkud
         FM1m82VjrGic/juoLmG+0MHkAWLwFizebWhUUJapFhp218CYSCnbuiSrQ+nLxQclmPXR
         tDCGaWhICQVckEk/wMGVabPrYHpolMgYPU3zuVbA2pTjkDs3XYMxpOkVbofn/vdT2it/
         xdTzbIXAjevWXmpldePMiYv/wUbdsexhIsK1nIevuVVK4X3dKV+IDCc8bk96DnvcufQs
         r8MdI1wjGKvGKEHbbVERi4Ejy+YdXVbQe5dYFOoZ+inK0DyFMJhQ1VPcpWF2tBtOCdOf
         N13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=FiEubfhVKQC+gxzipOmlwKyOSEtNoGgQ3+pUJvMJppU=;
        b=crag85ej3gWt9Eu+DoJ0Ssc29/GJIJthNMBg6zUFFTrYrfLD8bgcJ8noNtUAXa+Msl
         5bs7/PIMbTeSR6avmoBj38NnzJE6Aow5HpDT3guDstTEa3Gcb0YJw9tAqi0JmHIt1aUc
         PHVJIN6J4CCYsuDCwcI23xpb0q9CkZoHiqMzLXD2U8OwlZMCAwgUtvEd9c7A+wFUZ8g9
         j5Bsy+/W2twycQx71RwsJYZqiZvRCXEJkIDrWM7xaeqKyC6KTdHWqGIwVMAm+xLmPeSZ
         uoc8NYEsvc5LTJmx2g40fAMyFUYlVHTXwmE+djhFIOLzSqWtyHe+0Fne9NK0CuE1O6sc
         pemg==
X-Gm-Message-State: AOAM531u3fPlBR2FmID3Oxlx8Nov+AlojJlXj+OFQE03rpsH6W3Z/GYW
        hhOCkeB4BL0ix6Io8b0AmmWwBHhT/LTBFve8E/c=
X-Google-Smtp-Source: ABdhPJzQEGLvdvjjx3CnG78rele5Fo+qT1PVhsELOS3mX6khHe112gQZ7HkwjysSDorRT4xR2o7WrteShCuzvUOA4R0=
X-Received: by 2002:a9d:7656:: with SMTP id o22mr841861otl.109.1597898555099;
 Wed, 19 Aug 2020 21:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu> <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu> <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
 <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com> <20200820043323.GA21461@1wt.eu>
In-Reply-To: <20200820043323.GA21461@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 20 Aug 2020 06:42:23 +0200
Message-ID: <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <edumazet@google.com>, George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 6:33 AM Willy Tarreau <w@1wt.eu> wrote:
>
> On Thu, Aug 20, 2020 at 05:05:49AM +0200, Sedat Dilek wrote:
> > We have the same defines for K0 and K1 in include/linux/prandom.h and
> > lib/random32.c?
> > More room for simplifications?
>
> Definitely, I'm not surprized at all. As I said, the purpose was to
> discuss around the proposal, not much more. If we think it's the way
> to go, some major lifting is required. I just don't want to invest
> significant time on this if nobody cares.
>

OK.

Right now, I will try with the attached diff.

Unclear to me where this modpost "net_rand_noise" undefined! comes from.
Any hints?

- Sedat -

[ prandom-siphash-noise-wtarreau-20200816-dileks.diff ]

diff --git a/drivers/staging/rtl8188eu/include/rtw_security.h
b/drivers/staging/rtl8188eu/include/rtw_security.h
index 8ba02a7cea60..5cbb6fec71cd 100644
--- a/drivers/staging/rtl8188eu/include/rtw_security.h
+++ b/drivers/staging/rtl8188eu/include/rtw_security.h
@@ -221,6 +221,9 @@ do {
                         \
 #define ROL32(A, n)    (((A) << (n)) | (((A) >> (32 - (n)))  & ((1UL
<< (n)) - 1)))
 #define ROR32(A, n)    ROL32((A), 32 - (n))

+// XXX: Workaround: Undef defines from <include/linux/prandom.h>
+#undef K0
+#undef K1
 struct mic_data {
        u32  K0, K1;         /*  Key */
        u32  L, R;           /*  Current state */
diff --git a/drivers/staging/rtl8712/rtl871x_security.h
b/drivers/staging/rtl8712/rtl871x_security.h
index b2dda16cbd0a..d4ffb31d9d14 100644
--- a/drivers/staging/rtl8712/rtl871x_security.h
+++ b/drivers/staging/rtl8712/rtl871x_security.h
@@ -188,6 +188,9 @@ do {\
 #define ROL32(A, n) (((A) << (n)) | (((A)>>(32-(n)))  & ((1UL << (n)) - 1)))
 #define ROR32(A, n) ROL32((A), 32 - (n))

+// XXX: Workaround: Undef defines from <include/linux/prandom.h>
+#undef K0
+#undef K1
 struct mic_data {
        u32  K0, K1;         /* Key */
        u32  L, R;           /* Current state */
diff --git a/drivers/staging/rtl8723bs/include/rtw_security.h
b/drivers/staging/rtl8723bs/include/rtw_security.h
index 514c0799c34b..260ca9f29a35 100644
--- a/drivers/staging/rtl8723bs/include/rtw_security.h
+++ b/drivers/staging/rtl8723bs/include/rtw_security.h
@@ -271,6 +271,9 @@ do {\
 #define ROL32(A, n)    (((A) << (n)) | (((A)>>(32-(n)))  & ((1UL << (n)) - 1)))
 #define ROR32(A, n)    ROL32((A), 32-(n))

+// XXX: Workaround: Undef defines from <include/linux/prandom.h>
+#undef K0
+#undef K1
 struct mic_data {
        u32  K0, K1;         /*  Key */
        u32  L, R;           /*  Current state */
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index 95d73b01d8c5..efebcff3c93d 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -32,6 +32,11 @@ DECLARE_PER_CPU(unsigned long, net_rand_noise);
        v1 ^= v0, v0 = rol64(v0, 32),  v3 ^= v2,                     \
        v0 += v3, v3 = rol64(v3, 21),  v2 += v1, v1 = rol64(v1, 17), \
        v3 ^= v0,                      v1 ^= v2, v2 = rol64(v2, 32)  )
+#define SIPROUND(v0,v1,v2,v3) ( \
+       v0 += v1, v1 = rol64(v1, 13),  v2 += v3, v3 = rol64(v3, 16), \
+       v1 ^= v0, v0 = rol64(v0, 32),  v3 ^= v2,                     \
+       v0 += v3, v3 = rol64(v3, 21),  v2 += v1, v1 = rol64(v1, 17), \
+       v3 ^= v0,                      v1 ^= v2, v2 = rol64(v2, 32)  )
 #define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
 #define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )

@@ -46,6 +51,11 @@ DECLARE_PER_CPU(unsigned long, net_rand_noise);
        v1 ^= v0, v0 = rol32(v0, 16),  v3 ^= v2,                     \
        v0 += v3, v3 = rol32(v3,  7),  v2 += v1, v1 = rol32(v1, 13), \
        v3 ^= v0,                      v1 ^= v2, v2 = rol32(v2, 16)  )
+#define SIPROUND(v0,v1,v2,v3) ( \
+       v0 += v1, v1 = rol32(v1,  5),  v2 += v3, v3 = rol32(v3,  8), \
+       v1 ^= v0, v0 = rol32(v0, 16),  v3 ^= v2,                     \
+       v0 += v3, v3 = rol32(v3,  7),  v2 += v1, v1 = rol32(v1, 13), \
+       v3 ^= v0,                      v1 ^= v2, v2 = rol32(v2, 16)  )
 #define K0 0x6c796765
 #define K1 0x74656462

diff --git a/lib/random32.c b/lib/random32.c
index 93f0cd3a67ee..f24c7a0febf0 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -323,37 +323,6 @@ struct siprand_state {
 static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
 DEFINE_PER_CPU(unsigned long, net_rand_noise);

-#if BITS_PER_LONG == 64
-/*
- * The core SipHash round function.  Each line can be executed in
- * parallel given enough CPU resources.
- */
-#define SIPROUND(v0,v1,v2,v3) ( \
-       v0 += v1, v1 = rol64(v1, 13),  v2 += v3, v3 = rol64(v3, 16), \
-       v1 ^= v0, v0 = rol64(v0, 32),  v3 ^= v2,                     \
-       v0 += v3, v3 = rol64(v3, 21),  v2 += v1, v1 = rol64(v1, 17), \
-       v3 ^= v0,                      v1 ^= v2, v2 = rol64(v2, 32)  )
-#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
-#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
-
-#elif BITS_PER_LONG == 32
-/*
- * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
- * This is weaker, but 32-bit machines are not used for high-traffic
- * applications, so there is less output for an attacker to analyze.
- */
-#define SIPROUND(v0,v1,v2,v3) ( \
-       v0 += v1, v1 = rol32(v1,  5),  v2 += v3, v3 = rol32(v3,  8), \
-       v1 ^= v0, v0 = rol32(v0, 16),  v3 ^= v2,                     \
-       v0 += v3, v3 = rol32(v3,  7),  v2 += v1, v1 = rol32(v1, 13), \
-       v3 ^= v0,                      v1 ^= v2, v2 = rol32(v2, 16)  )
-#define K0 0x6c796765
-#define K1 0x74656462
-
-#else
-#error Unsupported BITS_PER_LONG
-#endif
-
 /*
  * This is the core CPRNG function.  As "pseudorandom", this is not used
  * for truly valuable things, just intended to be a PITA to guess.

- EOF -
