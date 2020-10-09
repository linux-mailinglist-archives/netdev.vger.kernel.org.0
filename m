Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D6289C00
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbgJIXBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731374AbgJIXBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 19:01:32 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593FEC0613D2;
        Fri,  9 Oct 2020 16:01:31 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 67so8425397ybt.6;
        Fri, 09 Oct 2020 16:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vtX2X4esleDi4H0686g5grmieupLoqDr/WDhrszoS9k=;
        b=skWGPRPs/NS4JT8PpbPfjP9fb1PrDNNKNh4CdhY3OIVZDE74LJvunrqdL99jvQoQhM
         e90OKYn2gmJMC/RLQwekiqk32rNyDC1S2VDBtNxsVGVseXtJrsVRv//wt2rusoU1j5Bd
         eT5uTNmDeSIv2mM4ZlBjmxAgkaVBFfh5zsm1xF5jBpX/X18tMqzfp+5ug+MaxLrsKOJt
         LVPlDeXyL5a/F92eqiqk9lL1g9SJ7LRrRWt2Gz5U2jEzujToRylyJEnzGCnRPgsblUGJ
         Y1vySz/QrLcJY51CncW7JHyTb3nlPg/Q3FXSFu8lFCar8XBKOAS3OSHhsrYMP/wxs7D7
         g0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vtX2X4esleDi4H0686g5grmieupLoqDr/WDhrszoS9k=;
        b=fphQ9ZEPyZr8nRQ1HCgImGCs+dlXQRVb9S6ZegY6nvpZdVYgNcRcOAqdpEUGVXhERn
         AIQ2Rk3/eTaw2rZ/XThvubE/cIdCmvV32b6nFfx8gttEof+GHa4mw/+qEv/eA3O7qi85
         iUMIDmY7VbN4t98aAuXjVAgE87Nbgb1ACN5KB+sapoidyaseLHA80f0NinD1ME9Wxx0r
         Dkh2hcOdzjrrI0axQ/aXjJdA6pGp2cAOr19YQWIPopi4Qr1ylhksuDB/FDmGoPJ2ORYQ
         UtOL3itKxtzOWPhBsHk0l+/ZzZQ9nb5O/Uy2LOshbG8Plxt1W/w6DXTRDPQ6sl2/T3tT
         YO0A==
X-Gm-Message-State: AOAM533VUT6q+rifIOOHyvU+RylaQiz83W3h+nS68byzbf5V5fcUjZxN
        Fn5l38jscrmcufOb4FueKJ5Y+/eC350e2a+50io=
X-Google-Smtp-Source: ABdhPJxDADFhA9/tVsQuHLcgF8ljXVxIanujq6E5cZNOOay1vm7HiTYruvtEkDjLOgYVGeXXN8GO09wmbaBF7VP2SjI=
X-Received: by 2002:a25:2687:: with SMTP id m129mr20126658ybm.425.1602284489107;
 Fri, 09 Oct 2020 16:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201009224007.30447-1-daniel@iogearbox.net> <20201009224007.30447-4-daniel@iogearbox.net>
In-Reply-To: <20201009224007.30447-4-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 16:01:18 -0700
Message-ID: <CAEf4BzYHRi3zBWcVYo=1oB2mcWaW_7HmKsSw6X2PU1deyXXaDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 3:40 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Recent work in f4d05259213f ("bpf: Add map_meta_equal map ops") and 134fede4eecf
> ("bpf: Relax max_entries check for most of the inner map types") added support
> for dynamic inner max elements for most map-in-map types. Exceptions were maps
> like array or prog array where the map_gen_lookup() callback uses the maps'
> max_entries field as a constant when emitting instructions.
>
> We recently implemented Maglev consistent hashing into Cilium's load balancer
> which uses map-in-map with an outer map being hash and inner being array holding
> the Maglev backend table for each service. This has been designed this way in
> order to reduce overall memory consumption given the outer hash map allows to
> avoid preallocating a large, flat memory area for all services. Also, the
> number of service mappings is not always known a-priori.
>
> The use case for dynamic inner array map entries is to further reduce memory
> overhead, for example, some services might just have a small number of back
> ends while others could have a large number. Right now the Maglev backend table
> for small and large number of backends would need to have the same inner array
> map entries which adds a lot of unneeded overhead.
>
> Dynamic inner array map entries can be realized by avoiding the inlined code
> generation for their lookup. The lookup will still be efficient since it will
> be calling into array_map_lookup_elem() directly and thus avoiding retpoline.
> The patch adds a BPF_F_INNER_MAP flag to map creation which therefore skips
> inline code generation and relaxes array_map_meta_equal() check to ignore both
> maps' max_entries.
>
> Example code generation where inner map is dynamic sized array:
>
>   # bpftool p d x i 125
>   int handle__sys_enter(void * ctx):
>   ; int handle__sys_enter(void *ctx)
>      0: (b4) w1 = 0
>   ; int key = 0;
>      1: (63) *(u32 *)(r10 -4) = r1
>      2: (bf) r2 = r10
>   ;
>      3: (07) r2 += -4
>   ; inner_map = bpf_map_lookup_elem(&outer_arr_dyn, &key);
>      4: (18) r1 = map[id:468]
>      6: (07) r1 += 272
>      7: (61) r0 = *(u32 *)(r2 +0)
>      8: (35) if r0 >= 0x3 goto pc+5
>      9: (67) r0 <<= 3
>     10: (0f) r0 += r1
>     11: (79) r0 = *(u64 *)(r0 +0)
>     12: (15) if r0 == 0x0 goto pc+1
>     13: (05) goto pc+1
>     14: (b7) r0 = 0
>     15: (b4) w6 = -1
>   ; if (!inner_map)
>     16: (15) if r0 == 0x0 goto pc+6
>     17: (bf) r2 = r10
>   ;
>     18: (07) r2 += -4
>   ; val = bpf_map_lookup_elem(inner_map, &key);
>     19: (bf) r1 = r0                               | No inlining but instead
>     20: (85) call array_map_lookup_elem#149280     | call to array_map_lookup_elem()
>   ; return val ? *val : -1;                        | for inner array lookup.
>     21: (15) if r0 == 0x0 goto pc+1
>   ; return val ? *val : -1;
>     22: (61) r6 = *(u32 *)(r0 +0)
>   ; }
>     23: (bc) w0 = w6
>     24: (95) exit
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> ---
>  include/linux/bpf.h            |  2 +-
>  include/uapi/linux/bpf.h       |  3 +++
>  kernel/bpf/arraymap.c          | 17 +++++++++++------
>  kernel/bpf/hashtab.c           |  6 +++---
>  kernel/bpf/verifier.c          |  4 +++-
>  net/xdp/xskmap.c               |  2 +-
>  tools/include/uapi/linux/bpf.h |  3 +++
>  7 files changed, 25 insertions(+), 12 deletions(-)
>

[...]

>         *insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
>         *insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
>         if (!map->bypass_spec_v1) {
> @@ -496,8 +499,10 @@ static int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
>  static bool array_map_meta_equal(const struct bpf_map *meta0,
>                                  const struct bpf_map *meta1)
>  {
> -       return meta0->max_entries == meta1->max_entries &&
> -               bpf_map_meta_equal(meta0, meta1);
> +       if (!bpf_map_meta_equal(meta0, meta1))
> +               return false;
> +       return meta0->map_flags & BPF_F_INNER_MAP ? true :
> +              meta0->max_entries == meta1->max_entries;

even if meta1 doesn't have BPF_F_INNER_MAP, it's ok, because all the
accesses for map returned from outer map lookup will not inline, is
that right? So this flag only matters for the inner map's prototype.
You also mentioned that not inlining array access should still be
fast. So I wonder, what if we just force non-inlined access for inner
maps of ARRAY type? Would it be too bad of a hit for existing
applications?

The benefit would be that everything would just work without a special
flag. If perf hit isn't prohibitive, it might be worthwhile to
simplify user experience?

>  }
>
>  struct bpf_iter_seq_array_map_info {
> @@ -1251,7 +1256,7 @@ static void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
>         return READ_ONCE(*inner_map);
>  }
>

[...]

>         struct bpf_insn *insn = insn_buf;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f3e36eade3d4..76d43ef60e7b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11049,6 +11049,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>                         if (insn->imm == BPF_FUNC_map_lookup_elem &&
>                             ops->map_gen_lookup) {
>                                 cnt = ops->map_gen_lookup(map_ptr, insn_buf);
> +                               if (cnt == -EOPNOTSUPP)
> +                                       goto patch_map_ops_generic;
>                                 if (cnt == 0 || cnt >= ARRAY_SIZE(insn_buf)) {

should this now check cnt <= 0 instead?


>                                         verbose(env, "bpf verifier is misconfigured\n");
>                                         return -EINVAL;
> @@ -11079,7 +11081,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>                                      (int (*)(struct bpf_map *map, void *value))NULL));
>                         BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
>                                      (int (*)(struct bpf_map *map, void *value))NULL));
> -
> +patch_map_ops_generic:
>                         switch (insn->imm) {
>                         case BPF_FUNC_map_lookup_elem:
>                                 insn->imm = BPF_CAST_CALL(ops->map_lookup_elem) -

[...]
