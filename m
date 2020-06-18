Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC9D1FEBB7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFRGtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgFRGtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:49:13 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF188C06174E;
        Wed, 17 Jun 2020 23:49:11 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id s18so5825317ioe.2;
        Wed, 17 Jun 2020 23:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=N+5UiKZaYnXUu+aDVqWpTGiOtw5Odjzh+MCtWgl3usE=;
        b=rLNYAobG0JbLk+jKEc9RxGdLZabDzuenaNP37NLeW7cgefQTm49/3EVaUGaFfVXspw
         w5bSyvGcZzmLW0/3PrLFzeyikMvjHeQM3+Pwx9Vl+ci4Qaye8J4fs0HWA1s7H2iQEGDf
         i54Sz9hXrOTh3w0jyC81Y020l/QSRE3i7OWQEzzaTsQ5l5vz0SEYMgs8TEsV84kwM4DM
         ztDPZSvfwDpTmilnsTc3vZKNQR8vZkQhGYpfEiaUFYctKU3GhTWZHcsq0uQQaax5Ay/T
         789sIZWfw31IDSvZjnueXuu6Ihm827j8N2IAHh9bXRnhTRV0CSyZG2uR0HSxhRayKFNd
         dH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=N+5UiKZaYnXUu+aDVqWpTGiOtw5Odjzh+MCtWgl3usE=;
        b=EUgoRNP2thE1972tRZeYDqZ9O5rbc9XOaOLdzQ0IuodO18bHG3/q5ZW+qr63jFR4Cc
         XgIvXYFyJSIn2aU9mQSXmz3PlAyCz9DpB2YAjeP+RlYtUV3QwSvPQVeW2IiCAHdv8HUH
         +ja2gCmqepV/dQyqNKPFR5S0K0HHpknQSKXDYw1npnqcyr8Eqw6GjAEFgXR3129+7Dx/
         8kQwxxOUzzAvkiCTP5OlZy0TWFB3uzzcLZxURZsCVceKYv/O9XYwSYmFqqWvusF7NQ1L
         Je1nLoWVFYtGm994bLxczLksh/tfrQ8UiuxVe+WCQsFX0uENcmZPcqUfDDV0c5c2RK1R
         ztHg==
X-Gm-Message-State: AOAM531mHjHLUw4cDm4jsElZibs/4kNDc05lmt48iOQk78s+m2HAm5I0
        NrmQ5TGKfCD4g+6BYhQ2XKk=
X-Google-Smtp-Source: ABdhPJz5sKJKeYnvEzS9GT49wKtc5cGlH+11Lv5QFU/1odD35j9/ZbtJF3Uz8Z3vsu5eMzFn1e+SYA==
X-Received: by 2002:a02:ac0a:: with SMTP id a10mr2962445jao.97.1592462950878;
        Wed, 17 Jun 2020 23:49:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t5sm1270704iov.53.2020.06.17.23.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 23:49:10 -0700 (PDT)
Date:   Wed, 17 Jun 2020 23:49:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
In-Reply-To: <20200617202112.2438062-1-andriin@fb.com>
References: <20200617202112.2438062-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Switch most of BPF helper definitions from returning int to long. These
> definitions are coming from comments in BPF UAPI header and are used to
> generate bpf_helper_defs.h (under libbpf) to be later included and used from
> BPF programs.
> 
> In actual in-kernel implementation, all the helpers are defined as returning
> u64, but due to some historical reasons, most of them are actually defined as
> returning int in UAPI (usually, to return 0 on success, and negative value on
> error).

Could we change the helpers side to return correct types now? Meaning if the
UAPI claims its an int lets actually return the int.

> 
> This actually causes Clang to quite often generate sub-optimal code, because
> compiler believes that return value is 32-bit, and in a lot of cases has to be
> up-converted (usually with a pair of 32-bit bit shifts) to 64-bit values,
> before they can be used further in BPF code.
> 
> Besides just "polluting" the code, these 32-bit shifts quite often cause
> problems for cases in which return value matters. This is especially the case
> for the family of bpf_probe_read_str() functions. There are few other similar
> helpers (e.g., bpf_read_branch_records()), in which return value is used by
> BPF program logic to record variable-length data and process it. For such
> cases, BPF program logic carefully manages offsets within some array or map to
> read variable-length data. For such uses, it's crucial for BPF verifier to
> track possible range of register values to prove that all the accesses happen
> within given memory bounds. Those extraneous zero-extending bit shifts,
> inserted by Clang (and quite often interleaved with other code, which makes
> the issues even more challenging and sometimes requires employing extra
> per-variable compiler barriers), throws off verifier logic and makes it mark
> registers as having unknown variable offset. We'll study this pattern a bit
> later below.

With latest verifier zext with alu32 support should be implemented as a
MOV insn.

> 
> Another common pattern is to check return of BPF helper for non-zero state to
> detect error conditions and attempt alternative actions in such case. Even in
> this simple and straightforward case, this 32-bit vs BPF's native 64-bit mode
> quite often leads to sub-optimal and unnecessary extra code. We'll look at
> this pattern as well.
> 
> Clang's BPF target supports two modes of code generation: ALU32, in which it
> is capable of using lower 32-bit parts of registers, and no-ALU32, in which
> only full 64-bit registers are being used. ALU32 mode somewhat mitigates the
> above described problems, but not in all cases.

A bit curious, do you see users running with no-ALU32 support? I have enabled
it by default now. It seems to generate better code and with latest 32-bit
bounds tracking I haven't hit any issues with verifier.

> 
> This patch switches all the cases in which BPF helpers return 0 or negative
> error from returning int to returning long. It is shown below that such change
> in definition leads to equivalent or better code. No-ALU32 mode benefits more,
> but ALU32 mode doesn't degrade or still gets improved code generation.
> 
> Another class of cases switched from int to long are bpf_probe_read_str()-like
> helpers, which encode successful case as non-negative values, while still
> returning negative value for errors.
> 
> In all of such cases, correctness is preserved due to two's complement
> encoding of negative values and the fact that all helpers return values with
> 32-bit absolute value. Two's complement ensures that for negative values
> higher 32 bits are all ones and when truncated, leave valid negative 32-bit
> value with the same value. Non-negative values have upper 32 bits set to zero
> and similarly preserve value when high 32 bits are truncated. This means that
> just casting to int/u32 is correct and efficient (and in ALU32 mode doesn't
> require any extra shifts).
> 
> To minimize the chances of regressions, two code patterns were investigated,
> as mentioned above. For both patterns, BPF assembly was analyzed in
> ALU32/NO-ALU32 compiler modes, both with current 32-bit int return type and
> new 64-bit long return type.
> 
> Case 1. Variable-length data reading and concatenation. This is quite
> ubiquitous pattern in tracing/monitoring applications, reading data like
> process's environment variables, file path, etc. In such case, many pieces of
> string-like variable-length data are read into a single big buffer, and at the
> end of the process, only a part of array containing actual data is sent to
> user-space for further processing. This case is tested in test_varlen.c
> selftest (in the next patch). Code flow is roughly as follows:
> 
>   void *payload = &sample->payload;
>   u64 len;
> 
>   len = bpf_probe_read_kernel_str(payload, MAX_SZ1, &source_data1);
>   if (len <= MAX_SZ1) {
>       payload += len;
>       sample->len1 = len;
>   }
>   len = bpf_probe_read_kernel_str(payload, MAX_SZ2, &source_data2);
>   if (len <= MAX_SZ2) {
>       payload += len;
>       sample->len2 = len;
>   }
>   /* and so on */
>   sample->total_len = payload - &sample->payload;
>   /* send over, e.g., perf buffer */
> 
> There could be two variations with slightly different code generated: when len
> is 64-bit integer and when it is 32-bit integer. Both variations were analysed.
> BPF assembly instructions between two successive invocations of
> bpf_probe_read_kernel_str() were used to check code regressions. Results are
> below, followed by short analysis. Left side is using helpers with int return
> type, the right one is after the switch to long.
> 
> ALU32 + INT                                ALU32 + LONG
> ===========                                ============
> 
> 64-BIT (13 insns):                         64-BIT (10 insns):
> ------------------------------------       ------------------------------------
>   17:   call 115                             17:   call 115
>   18:   if w0 > 256 goto +9 <LBB0_4>         18:   if r0 > 256 goto +6 <LBB0_4>
>   19:   w1 = w0                              19:   r1 = 0 ll
>   20:   r1 <<= 32                            21:   *(u64 *)(r1 + 0) = r0
>   21:   r1 s>>= 32                           22:   r6 = 0 ll

What version of clang is this? That is probably a zext in llvm-ir that in
latest should be sufficient with the 'w1=w0'. I'm guessing (hoping?) you
might not have latest?

>   22:   r2 = 0 ll                            24:   r6 += r0
>   24:   *(u64 *)(r2 + 0) = r1              00000000000000c8 <LBB0_4>:
>   25:   r6 = 0 ll                            25:   r1 = r6
>   27:   r6 += r1                             26:   w2 = 256
> 00000000000000e0 <LBB0_4>:                   27:   r3 = 0 ll
>   28:   r1 = r6                              29:   call 115
>   29:   w2 = 256
>   30:   r3 = 0 ll
>   32:   call 115
> 
> 32-BIT (11 insns):                         32-BIT (12 insns):
> ------------------------------------       ------------------------------------
>   17:   call 115                             17:   call 115
>   18:   if w0 > 256 goto +7 <LBB1_4>         18:   if w0 > 256 goto +8 <LBB1_4>
>   19:   r1 = 0 ll                            19:   r1 = 0 ll
>   21:   *(u32 *)(r1 + 0) = r0                21:   *(u32 *)(r1 + 0) = r0
>   22:   w1 = w0                              22:   r0 <<= 32
>   23:   r6 = 0 ll                            23:   r0 >>= 32
>   25:   r6 += r1                             24:   r6 = 0 ll
> 00000000000000d0 <LBB1_4>:                   26:   r6 += r0
>   26:   r1 = r6                            00000000000000d8 <LBB1_4>:
>   27:   w2 = 256                             27:   r1 = r6
>   28:   r3 = 0 ll                            28:   w2 = 256
>   30:   call 115                             29:   r3 = 0 ll
>                                              31:   call 115
> 
> In ALU32 mode, the variant using 64-bit length variable clearly wins and
> avoids unnecessary zero-extension bit shifts. In practice, this is even more
> important and good, because BPF code won't need to do extra checks to "prove"
> that payload/len are within good bounds.

I bet with latest clang the shifts are removed. But if not we probably
should fix clang regardless of if helpers return longs or ints.

> 
> 32-bit len is one instruction longer. Clang decided to do 64-to-32 casting
> with two bit shifts, instead of equivalent `w1 = w0` assignment. The former
> uses extra register. The latter might potentially lose some range information,
> but not for 32-bit value. So in this case, verifier infers that r0 is [0, 256]
> after check at 18:, and shifting 32 bits left/right keeps that range intact.
> We should probably look into Clang's logic and see why it chooses bitshifts
> over sub-register assignments for this.
> 
> NO-ALU32 + INT                             NO-ALU32 + LONG
> ==============                             ===============
> 
> 64-BIT (14 insns):                         64-BIT (10 insns):
> ------------------------------------       ------------------------------------
>   17:   call 115                             17:   call 115
>   18:   r0 <<= 32                            18:   if r0 > 256 goto +6 <LBB0_4>
>   19:   r1 = r0                              19:   r1 = 0 ll
>   20:   r1 >>= 32                            21:   *(u64 *)(r1 + 0) = r0
>   21:   if r1 > 256 goto +7 <LBB0_4>         22:   r6 = 0 ll
>   22:   r0 s>>= 32                           24:   r6 += r0
>   23:   r1 = 0 ll                          00000000000000c8 <LBB0_4>:
>   25:   *(u64 *)(r1 + 0) = r0                25:   r1 = r6
>   26:   r6 = 0 ll                            26:   r2 = 256
>   28:   r6 += r0                             27:   r3 = 0 ll
> 00000000000000e8 <LBB0_4>:                   29:   call 115
>   29:   r1 = r6
>   30:   r2 = 256
>   31:   r3 = 0 ll
>   33:   call 115
> 
> 32-BIT (13 insns):                         32-BIT (13 insns):
> ------------------------------------       ------------------------------------
>   17:   call 115                             17:   call 115
>   18:   r1 = r0                              18:   r1 = r0
>   19:   r1 <<= 32                            19:   r1 <<= 32
>   20:   r1 >>= 32                            20:   r1 >>= 32
>   21:   if r1 > 256 goto +6 <LBB1_4>         21:   if r1 > 256 goto +6 <LBB1_4>
>   22:   r2 = 0 ll                            22:   r2 = 0 ll
>   24:   *(u32 *)(r2 + 0) = r0                24:   *(u32 *)(r2 + 0) = r0
>   25:   r6 = 0 ll                            25:   r6 = 0 ll
>   27:   r6 += r1                             27:   r6 += r1
> 00000000000000e0 <LBB1_4>:                 00000000000000e0 <LBB1_4>:
>   28:   r1 = r6                              28:   r1 = r6
>   29:   r2 = 256                             29:   r2 = 256
>   30:   r3 = 0 ll                            30:   r3 = 0 ll
>   32:   call 115                             32:   call 115
> 
> In NO-ALU32 mode, for the case of 64-bit len variable, Clang generates much
> superior code, as expected, eliminating unnecessary bit shifts. For 32-bit
> len, code is identical.

Right I can't think of any way clang can avoid it here. OTOH I fix this
by enabling alu32 ;)

> 
> So overall, only ALU-32 32-bit len case is more-or-less equivalent and the
> difference stems from internal Clang decision, rather than compiler lacking
> enough information about types.
> 
> Case 2. Let's look at the simpler case of checking return result of BPF helper
> for errors. The code is very simple:
> 
>   long bla;
>   if (bpf_probe_read_kenerl(&bla, sizeof(bla), 0))
>       return 1;
>   else
>       return 0;
> 
> ALU32 + CHECK (9 insns)                    ALU32 + CHECK (9 insns)
> ====================================       ====================================
>   0:    r1 = r10                             0:    r1 = r10
>   1:    r1 += -8                             1:    r1 += -8
>   2:    w2 = 8                               2:    w2 = 8
>   3:    r3 = 0                               3:    r3 = 0
>   4:    call 113                             4:    call 113
>   5:    w1 = w0                              5:    r1 = r0
>   6:    w0 = 1                               6:    w0 = 1
>   7:    if w1 != 0 goto +1 <LBB2_2>          7:    if r1 != 0 goto +1 <LBB2_2>
>   8:    w0 = 0                               8:    w0 = 0
> 0000000000000048 <LBB2_2>:                 0000000000000048 <LBB2_2>:
>   9:    exit                                 9:    exit
> 
> Almost identical code, the only difference is the use of full register
> assignment (r1 = r0) vs half-registers (w1 = w0) in instruction #5. On 32-bit
> architectures, new BPF assembly might be slightly less optimal, in theory. But
> one can argue that's not a big issue, given that use of full registers is
> still prevalent (e.g., for parameter passing).
> 
> NO-ALU32 + CHECK (11 insns)                NO-ALU32 + CHECK (9 insns)
> ====================================       ====================================
>   0:    r1 = r10                             0:    r1 = r10
>   1:    r1 += -8                             1:    r1 += -8
>   2:    r2 = 8                               2:    r2 = 8
>   3:    r3 = 0                               3:    r3 = 0
>   4:    call 113                             4:    call 113
>   5:    r1 = r0                              5:    r1 = r0
>   6:    r1 <<= 32                            6:    r0 = 1
>   7:    r1 >>= 32                            7:    if r1 != 0 goto +1 <LBB2_2>
>   8:    r0 = 1                               8:    r0 = 0
>   9:    if r1 != 0 goto +1 <LBB2_2>        0000000000000048 <LBB2_2>:
>  10:    r0 = 0                               9:    exit
> 0000000000000058 <LBB2_2>:
>  11:    exit
> 
> NO-ALU32 is a clear improvement, getting rid of unnecessary zero-extension bit
> shifts.

It seems a win for the NO-ALU32 case but for the +ALU32 case I think its
the same with latest clang although I haven't tried yet. I was actually
considering going the other way and avoiding always returning u64 on
the other side. From a purely aesethetics point of view I prefer the
int type because it seems more clear/standard C. I'm also not so interested
in optimizing the no-alu32 case but curious if there is a use case for
that?
