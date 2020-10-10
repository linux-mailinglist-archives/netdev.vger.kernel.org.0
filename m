Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFFA28A399
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390256AbgJJW4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730730AbgJJWCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 18:02:47 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0510FC0613D0;
        Sat, 10 Oct 2020 15:02:46 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h9so10226070ybm.4;
        Sat, 10 Oct 2020 15:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BPBONxxyc/ex5OHILvYzv0JlzTpLWw2xP7v4ZASALFI=;
        b=shDLVtvTK/uzL9IyUrcof7dNKQDBT6+FnW+xaBA4W6SykTAgqiYi+B1L2c/Ed2DFWd
         oE+MJvl2OHWEPAwGIw83yFJD0BEc76TkdZPxjkE35QLDqh2/YAUqRT/CKFG/vmUcMi9m
         4Anmj7zJ36m+jD0kha5wxLexJzG3wuz0Q3jDRTFKbRZP/BBhKTsT6nYOramAvvN7pD1g
         W+a64oK3pEwVbBx4T1O/frK3WFutv/roj0sW/gTUDpryqNZZ2eI7aiGI4HPbWEUJY4Tb
         ALUlO6AKymjLSiobcUDuEhoW0bstjw7U4LzMlAJgCPoX8GvlHBonqx+Ymc3nVVDAmESd
         E1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BPBONxxyc/ex5OHILvYzv0JlzTpLWw2xP7v4ZASALFI=;
        b=iikqMDLJ+NhD9mvRoLjcJpDx67+j67rWw6jTFrZEZSwl6U/D4cLl3vo2UiLOdQeS0c
         Icgzn0krwb7KfPsgTC4xIWZ/QON/pXYEfDLYb6IBUqX3wvCIrox7hcvblHh0ksYFZAsC
         yqpvZdGtwZMhKx+YQwwVWH9JH9zof1BE4W8PM91p7+FnYEWKpn/Ophks1jPq9nag23O6
         c9+EJeBDwRjNu9UB6lBXU8zOTYpRBpUc8W3cJ7FzpnUAjRPljijLV4xhirpscNcaaihD
         uP3VITynkHCnKAk+phIcyhm9t1gzY/+C6TFm53wFINr0wPCbKvEb6UPyzFdNudZr8o5h
         pQ5g==
X-Gm-Message-State: AOAM530/8tDM7K8RniHpApiN7sCSLf4cUM4oAXTKhLDU4ZX8wYMZegfE
        StwdqFBjyQpoVEi66GVPjCxQ6Lo+p5X4zlt268E=
X-Google-Smtp-Source: ABdhPJwwQ9QUbTlJgjeiZSkxW8PdW93J3Wb9f/3iZbRIxvAzSn9EWnlckNJl3xPOIrpfYvrZWfEoWLEWtIJJvksiFyE=
X-Received: by 2002:a25:2a4b:: with SMTP id q72mr18181406ybq.27.1602367366106;
 Sat, 10 Oct 2020 15:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201010205447.5610-1-daniel@iogearbox.net> <20201010205447.5610-4-daniel@iogearbox.net>
In-Reply-To: <20201010205447.5610-4-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 10 Oct 2020 15:02:35 -0700
Message-ID: <CAEf4BzZjDVqH3feow2Jzp--+akegVp5yrDdMyzB6EiD6U2ddDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/6] bpf: allow for map-in-map with dynamic
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

On Sat, Oct 10, 2020 at 1:54 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
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
> maps' max_entries. This also still allows to have faster lookups for map-in-map
> when BPF_F_INNER_MAP is not specified and hence dynamic max_entries not needed.
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

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f3e36eade3d4..d578875df1ad 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11049,6 +11049,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>                         if (insn->imm == BPF_FUNC_map_lookup_elem &&
>                             ops->map_gen_lookup) {
>                                 cnt = ops->map_gen_lookup(map_ptr, insn_buf);
> +                               if (cnt < 0)
> +                                       goto patch_map_ops_generic;

but now any reported error will be silently skipped. The logic should be:

if (cnt == -EOPNOTSUPP)
    goto patch_map_ops_generic;
if (cnt <= 0 || cnt >= ARRAY_SIZE(insn_buf))
    verbose(env, "bpf verifier is misconfigured\n");

This way only -EOPNOTSUPP is silently skipped, all other cases where
error is returned, cnt == 0, or cnt is too big would be reported as
error.

>                                 if (cnt == 0 || cnt >= ARRAY_SIZE(insn_buf)) {
>                                         verbose(env, "bpf verifier is misconfigured\n");
>                                         return -EINVAL;
> @@ -11079,7 +11081,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>                                      (int (*)(struct bpf_map *map, void *value))NULL));
>                         BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
>                                      (int (*)(struct bpf_map *map, void *value))NULL));

[...]
