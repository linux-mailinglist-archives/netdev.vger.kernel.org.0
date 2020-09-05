Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED2225E485
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 02:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgIEAIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 20:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIEAIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 20:08:45 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827AEC061244;
        Fri,  4 Sep 2020 17:08:44 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x2so5501472ybf.12;
        Fri, 04 Sep 2020 17:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KDX/6zy79NRu72r1RQNQKA3AIJxQMsol9K4um6Utn6A=;
        b=sQqJG3HY79lMKCfqXY+RAlVqI7KOZ301coe5V6Mr7RW3uEsE38vH/uspH5ci1mkQI1
         2qajEpHb9vUcajl54SWtxaBfiq3ngCBKnXunDlXxJtWRV+Xueaq+0QE05DrDPooo+JTk
         wCIfxBdBy+rVnDFJq/BFtFvWolc0dAqdFov8d6ob7EJNiYUyZnwoInXeBf7Z8RFEGrnn
         5CoARl6pX8fvsXAu4u/DmzbyOfCQlwkseVYpvp8NaBuO7w0Nu8DMmBHe09p6wx40Eeyo
         xps9b43xdB6cpyWE2bRJx0Muui1J+75XtLppeOphP02OKO6pMIbgSYtB2wDW1I5yS8We
         B/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KDX/6zy79NRu72r1RQNQKA3AIJxQMsol9K4um6Utn6A=;
        b=mr6lxjqk8yGsn579BNbKNa4oNXzbSPfo22NYSv48WBH3BIyxQCwF47tdqzvFyKj1DU
         8b18reXeqVfUhjnUTFp7Hm13nTBVYal7wy8oa+sF02mlrZi+XTNJu0nBwEnUioHHZH9W
         JLx+khz0pyD2H5NUN7sN0i8s/rHSoed8+LBizWeJ/z/thfzT1Wwywf8SP7SerfOuV6Rd
         tjnU6EuM0fswhEtcyUzeEeipWOhbQa56Uu6db+DawlJmW7pxvHzDUhZvu3ubtNWrSa23
         lI2LkSY9trOBaPMl53ULzGjW3INWeIHs9kaqPtfWQWp5MNymnmRHNgujHIt8XbEt2aI1
         fwLg==
X-Gm-Message-State: AOAM532rUWIRWZTMPViLJ0ArTVuY+vuEcpOPrxx5D4Vpq7ddg7a1MaYr
        BSfxJqHKnvlanEbGPjcQ1yf2CN2quw+0Y/WzNvI=
X-Google-Smtp-Source: ABdhPJz32ewHgnVTDiLUJ69WjBc/pos+Edn+jVIyHzUFpon1EhI40m64R33yBa6JgJ7GC531OForxTATcI+HwfePz9U=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr11668910ybm.230.1599264523663;
 Fri, 04 Sep 2020 17:08:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200904194900.3031319-1-yhs@fb.com> <20200904194900.3031377-1-yhs@fb.com>
 <CAEf4BzboqpYa7Zq=6xcpGez+jk--NTDA0=FQi5utwcFaHwC7bA@mail.gmail.com> <c016695c-3d22-ac74-5e2f-9210fb5b58af@fb.com>
In-Reply-To: <c016695c-3d22-ac74-5e2f-9210fb5b58af@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 17:08:32 -0700
Message-ID: <CAEf4BzaWZqLnR78B3F38bkDP62aDy81oQSAiZMXDULembVyhkA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: permit map_ptr arithmetic with opcode
 add and offset 0
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 4:20 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/4/20 1:30 PM, Andrii Nakryiko wrote:
> > On Fri, Sep 4, 2020 at 12:49 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Commit 41c48f3a98231 ("bpf: Support access
> >> to bpf map fields") added support to access map fields
> >> with CORE support. For example,
> >>
> >>              struct bpf_map {
> >>                      __u32 max_entries;
> >>              } __attribute__((preserve_access_index));
> >>
> >>              struct bpf_array {
> >>                      struct bpf_map map;
> >>                      __u32 elem_size;
> >>              } __attribute__((preserve_access_index));
> >>
> >>              struct {
> >>                      __uint(type, BPF_MAP_TYPE_ARRAY);
> >>                      __uint(max_entries, 4);
> >>                      __type(key, __u32);
> >>                      __type(value, __u32);
> >>              } m_array SEC(".maps");
> >>
> >>              SEC("cgroup_skb/egress")
> >>              int cg_skb(void *ctx)
> >>              {
> >>                      struct bpf_array *array = (struct bpf_array *)&m_array;
> >>
> >>                      /* .. array->map.max_entries .. */
> >>              }
> >>
> >> In kernel, bpf_htab has similar structure,
> >>
> >>              struct bpf_htab {
> >>                      struct bpf_map map;
> >>                      ...
> >>              }
> >>
> >> In the above cg_skb(), to access array->map.max_entries, with CORE, the clang will
> >> generate two builtin's.
> >>              base = &m_array;
> >>              /* access array.map */
> >>              map_addr = __builtin_preserve_struct_access_info(base, 0, 0);
> >>              /* access array.map.max_entries */
> >>              max_entries_addr = __builtin_preserve_struct_access_info(map_addr, 0, 0);
> >>              max_entries = *max_entries_addr;
> >>
> >> In the current llvm, if two builtin's are in the same function or
> >> in the same function after inlining, the compiler is smart enough to chain
> >> them together and generates like below:
> >>              base = &m_array;
> >>              max_entries = *(base + reloc_offset); /* reloc_offset = 0 in this case */
> >> and we are fine.
> >>
> >> But if we force no inlining for one of functions in test_map_ptr() selftest, e.g.,
> >> check_default(), the above two __builtin_preserve_* will be in two different
> >> functions. In this case, we will have code like:
> >>     func check_hash():
> >>              reloc_offset_map = 0;
> >>              base = &m_array;
> >>              map_base = base + reloc_offset_map;
> >>              check_default(map_base, ...)
> >>     func check_default(map_base, ...):
> >>              max_entries = *(map_base + reloc_offset_max_entries);
> >>
> >> In kernel, map_ptr (CONST_PTR_TO_MAP) does not allow any arithmetic.
> >> The above "map_base = base + reloc_offset_map" will trigger a verifier failure.
> >>    ; VERIFY(check_default(&hash->map, map));
> >>    0: (18) r7 = 0xffffb4fe8018a004
> >>    2: (b4) w1 = 110
> >>    3: (63) *(u32 *)(r7 +0) = r1
> >>     R1_w=invP110 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
> >>    ; VERIFY_TYPE(BPF_MAP_TYPE_HASH, check_hash);
> >>    4: (18) r1 = 0xffffb4fe8018a000
> >>    6: (b4) w2 = 1
> >>    7: (63) *(u32 *)(r1 +0) = r2
> >>     R1_w=map_value(id=0,off=0,ks=4,vs=8,imm=0) R2_w=invP1 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
> >>    8: (b7) r2 = 0
> >>    9: (18) r8 = 0xffff90bcb500c000
> >>    11: (18) r1 = 0xffff90bcb500c000
> >>    13: (0f) r1 += r2
> >>    R1 pointer arithmetic on map_ptr prohibited
> >>
> >> To fix the issue, let us permit map_ptr + 0 arithmetic which will
> >> result in exactly the same map_ptr.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   kernel/bpf/verifier.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index b4e9c56b8b32..92aa985e99df 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -5317,6 +5317,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
> >>                          dst, reg_type_str[ptr_reg->type]);
> >>                  return -EACCES;
> >>          case CONST_PTR_TO_MAP:
> >> +               if (known && smin_val == 0 && opcode == BPF_ADD)
> >
> > does smin_val imply that var_off is strictly zero? if that's the case,
> > can you please leave a comment stating this clearly, it's hard to tell
> > if that's enough of a check.
>
> It should be, if register state is maintained properly, the following
> function (or its functionality) should have been called.
>
> static void __update_reg64_bounds(struct bpf_reg_state *reg)
> {
>          /* min signed is max(sign bit) | min(other bits) */
>          reg->smin_value = max_t(s64, reg->smin_value,
>                                  reg->var_off.value | (reg->var_off.mask
> & S64_MIN));
>          /* max signed is min(sign bit) | max(other bits) */
>          reg->smax_value = min_t(s64, reg->smax_value,
>                                  reg->var_off.value | (reg->var_off.mask
> & S64_MAX));
>          reg->umin_value = max(reg->umin_value, reg->var_off.value);
>          reg->umax_value = min(reg->umax_value,
>                                reg->var_off.value | reg->var_off.mask);
> }
>
> for scalar constant, reg->var_off.mask should be 0. so we will have
> reg->smin_value = reg->smax_value = (s64)reg->var_off.value.
>
> The smin_val is also used below, e.g., BPF_ADD, for a known value.
> That is why I am using smin_val here.
>
> Will add a comment and submit v2.

it would be way-way more obvious (and reliable in the long run,
probably) if you just used (known && reg->var_off.value == 0). or just
tnum_equals_const(reg->var_off, 0)?

>
> >
> >> +                       break;
> >> +               /* fall-through */
> >>          case PTR_TO_PACKET_END:
> >>          case PTR_TO_SOCKET:
> >>          case PTR_TO_SOCKET_OR_NULL:
> >> --
> >> 2.24.1
> >>
