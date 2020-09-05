Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201E925E48D
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 02:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgIEAKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 20:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIEAKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 20:10:31 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D37EC061244;
        Fri,  4 Sep 2020 17:10:31 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c2so9854706ljj.12;
        Fri, 04 Sep 2020 17:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tbo/fP80u13iaVfzepEzqs/nlhrTTDUJVYz/xjFhpiY=;
        b=tvOw2VmHnmvPRCBzH7VgtWc8Wsc+Gk/uP/o5QXY02NXUlmLol1njnXZLMRS/3KBGge
         juy9sY//p5FIQmnxDSEMLJFkOsRsOdL1NAcNaWDD8D3FI4DytcId2NHlQTqU9PcwP7G7
         yVxYtuK75PZuvcNHQ0Tz4xD4+jFAmLecwd9r1juteFEDTR13id8vhYr1uMoD3kArDklF
         WpOk8p35TI7HVXHR3lOCkEUBhcB5HLTzp5e35b+ew9oEtulhgRCQnWLZj/a+OaJoHdrW
         Ns6l9KOFQeeFPif1Hlk7yf5wW/RcfMrX3u4VUMjUwCIuWufEiMworZhXFfRVdIiTCOPm
         VfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tbo/fP80u13iaVfzepEzqs/nlhrTTDUJVYz/xjFhpiY=;
        b=Rpzxgl00int2yJgp8l8fBV8dbcfOATAmipBCAqMERgESPF29k/JhuFmSVNAEp4CR5f
         MwBb477LH6rz2gtqi5RtW8lVvXiRLO7b5cl9j9XTiQRr0thb2YNR1wzg4MaUpOcXuzcW
         DUTxNhGSL8hGSohSgxSlyZ4Awxa0qo3amf/8xex7fErsT4ts0veNTb6zhj3Lx97QTxSX
         /8WQBNff8c4tTXQy3FR8nBxwN8WUlmkgjHqi+AY29J6Zc9tCFpN1Ef6mpcvJmuWL8avR
         7bVsBPUbfMP+eB0Uq9BtwoaNBhGDwQ1ZuVW06OAGvUPdd5NKPeFFRRUMDe7aBNb4ntm+
         DHsQ==
X-Gm-Message-State: AOAM532F3e8M0y16jdaDMs7gkd4Jq5RdHwv58wMJLKJxCinjIgFuzqJa
        l0KsuNYOAukApzTmNgC6QwQNOnj9QZ78+rTTAZA=
X-Google-Smtp-Source: ABdhPJwwubiU5GVA+BR62Zh8dV3eHyJL/xzfYHfblB/N9GQ/A2CAC7943eTw3V7Pre/jP/RCFUrDoDObHxzlzjzo7WU=
X-Received: by 2002:a2e:8593:: with SMTP id b19mr4779116lji.290.1599264629814;
 Fri, 04 Sep 2020 17:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200904194900.3031319-1-yhs@fb.com> <20200904194900.3031377-1-yhs@fb.com>
 <CAEf4BzboqpYa7Zq=6xcpGez+jk--NTDA0=FQi5utwcFaHwC7bA@mail.gmail.com>
 <c016695c-3d22-ac74-5e2f-9210fb5b58af@fb.com> <CAEf4BzaWZqLnR78B3F38bkDP62aDy81oQSAiZMXDULembVyhkA@mail.gmail.com>
In-Reply-To: <CAEf4BzaWZqLnR78B3F38bkDP62aDy81oQSAiZMXDULembVyhkA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Sep 2020 17:10:18 -0700
Message-ID: <CAADnVQJrjPynzVZTDvDh7qosBVFO8+iKEKDbC4=yK+4HVZ6Tng@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: permit map_ptr arithmetic with opcode
 add and offset 0
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 5:08 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Sep 4, 2020 at 4:20 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 9/4/20 1:30 PM, Andrii Nakryiko wrote:
> > > On Fri, Sep 4, 2020 at 12:49 PM Yonghong Song <yhs@fb.com> wrote:
> > >>
> > >> Commit 41c48f3a98231 ("bpf: Support access
> > >> to bpf map fields") added support to access map fields
> > >> with CORE support. For example,
> > >>
> > >>              struct bpf_map {
> > >>                      __u32 max_entries;
> > >>              } __attribute__((preserve_access_index));
> > >>
> > >>              struct bpf_array {
> > >>                      struct bpf_map map;
> > >>                      __u32 elem_size;
> > >>              } __attribute__((preserve_access_index));
> > >>
> > >>              struct {
> > >>                      __uint(type, BPF_MAP_TYPE_ARRAY);
> > >>                      __uint(max_entries, 4);
> > >>                      __type(key, __u32);
> > >>                      __type(value, __u32);
> > >>              } m_array SEC(".maps");
> > >>
> > >>              SEC("cgroup_skb/egress")
> > >>              int cg_skb(void *ctx)
> > >>              {
> > >>                      struct bpf_array *array = (struct bpf_array *)&m_array;
> > >>
> > >>                      /* .. array->map.max_entries .. */
> > >>              }
> > >>
> > >> In kernel, bpf_htab has similar structure,
> > >>
> > >>              struct bpf_htab {
> > >>                      struct bpf_map map;
> > >>                      ...
> > >>              }
> > >>
> > >> In the above cg_skb(), to access array->map.max_entries, with CORE, the clang will
> > >> generate two builtin's.
> > >>              base = &m_array;
> > >>              /* access array.map */
> > >>              map_addr = __builtin_preserve_struct_access_info(base, 0, 0);
> > >>              /* access array.map.max_entries */
> > >>              max_entries_addr = __builtin_preserve_struct_access_info(map_addr, 0, 0);
> > >>              max_entries = *max_entries_addr;
> > >>
> > >> In the current llvm, if two builtin's are in the same function or
> > >> in the same function after inlining, the compiler is smart enough to chain
> > >> them together and generates like below:
> > >>              base = &m_array;
> > >>              max_entries = *(base + reloc_offset); /* reloc_offset = 0 in this case */
> > >> and we are fine.
> > >>
> > >> But if we force no inlining for one of functions in test_map_ptr() selftest, e.g.,
> > >> check_default(), the above two __builtin_preserve_* will be in two different
> > >> functions. In this case, we will have code like:
> > >>     func check_hash():
> > >>              reloc_offset_map = 0;
> > >>              base = &m_array;
> > >>              map_base = base + reloc_offset_map;
> > >>              check_default(map_base, ...)
> > >>     func check_default(map_base, ...):
> > >>              max_entries = *(map_base + reloc_offset_max_entries);
> > >>
> > >> In kernel, map_ptr (CONST_PTR_TO_MAP) does not allow any arithmetic.
> > >> The above "map_base = base + reloc_offset_map" will trigger a verifier failure.
> > >>    ; VERIFY(check_default(&hash->map, map));
> > >>    0: (18) r7 = 0xffffb4fe8018a004
> > >>    2: (b4) w1 = 110
> > >>    3: (63) *(u32 *)(r7 +0) = r1
> > >>     R1_w=invP110 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
> > >>    ; VERIFY_TYPE(BPF_MAP_TYPE_HASH, check_hash);
> > >>    4: (18) r1 = 0xffffb4fe8018a000
> > >>    6: (b4) w2 = 1
> > >>    7: (63) *(u32 *)(r1 +0) = r2
> > >>     R1_w=map_value(id=0,off=0,ks=4,vs=8,imm=0) R2_w=invP1 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
> > >>    8: (b7) r2 = 0
> > >>    9: (18) r8 = 0xffff90bcb500c000
> > >>    11: (18) r1 = 0xffff90bcb500c000
> > >>    13: (0f) r1 += r2
> > >>    R1 pointer arithmetic on map_ptr prohibited
> > >>
> > >> To fix the issue, let us permit map_ptr + 0 arithmetic which will
> > >> result in exactly the same map_ptr.
> > >>
> > >> Signed-off-by: Yonghong Song <yhs@fb.com>
> > >> ---
> > >>   kernel/bpf/verifier.c | 3 +++
> > >>   1 file changed, 3 insertions(+)
> > >>
> > >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > >> index b4e9c56b8b32..92aa985e99df 100644
> > >> --- a/kernel/bpf/verifier.c
> > >> +++ b/kernel/bpf/verifier.c
> > >> @@ -5317,6 +5317,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
> > >>                          dst, reg_type_str[ptr_reg->type]);
> > >>                  return -EACCES;
> > >>          case CONST_PTR_TO_MAP:
> > >> +               if (known && smin_val == 0 && opcode == BPF_ADD)
> > >
> > > does smin_val imply that var_off is strictly zero? if that's the case,
> > > can you please leave a comment stating this clearly, it's hard to tell
> > > if that's enough of a check.
> >
> > It should be, if register state is maintained properly, the following
> > function (or its functionality) should have been called.
> >
> > static void __update_reg64_bounds(struct bpf_reg_state *reg)
> > {
> >          /* min signed is max(sign bit) | min(other bits) */
> >          reg->smin_value = max_t(s64, reg->smin_value,
> >                                  reg->var_off.value | (reg->var_off.mask
> > & S64_MIN));
> >          /* max signed is min(sign bit) | max(other bits) */
> >          reg->smax_value = min_t(s64, reg->smax_value,
> >                                  reg->var_off.value | (reg->var_off.mask
> > & S64_MAX));
> >          reg->umin_value = max(reg->umin_value, reg->var_off.value);
> >          reg->umax_value = min(reg->umax_value,
> >                                reg->var_off.value | reg->var_off.mask);
> > }
> >
> > for scalar constant, reg->var_off.mask should be 0. so we will have
> > reg->smin_value = reg->smax_value = (s64)reg->var_off.value.
> >
> > The smin_val is also used below, e.g., BPF_ADD, for a known value.
> > That is why I am using smin_val here.
> >
> > Will add a comment and submit v2.
>
> it would be way-way more obvious (and reliable in the long run,
> probably) if you just used (known && reg->var_off.value == 0). or just
> tnum_equals_const(reg->var_off, 0)?

Pls dont. smin_val == 0 is a standard way to do this.
Just check all other places in this function and everywhere else.
