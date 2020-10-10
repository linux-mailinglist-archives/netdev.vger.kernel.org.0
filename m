Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7143228A498
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgJJXtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 19:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbgJJXtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 19:49:31 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491F7C0613D0;
        Sat, 10 Oct 2020 16:49:31 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x20so10332700ybs.8;
        Sat, 10 Oct 2020 16:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JRNVp8GdKibjrnv9VRzWXM3dOgQNe3Di0UKvmBxOiM0=;
        b=n1bo8Tn0Kvs5+E9AR/oaAT0g6c1LmoUYcTvj1Zh4wSlQU2nM1sK6OL3yjBLA1Oegxn
         SbRksHp/S6rOydZpn2sBUBZcOalcvnx93jbACLbIc1hztEF+vGUShwENYZHuJlP6RYfh
         IrG/KHduLThm30ftS4uewmZSi5kNsBTN19ue058IAhd2WJOTDbnKBFv+8jqCK3n4XI2P
         SxOeGIH0yQcbE8g88Z95u0XgwvzTQA80Dvdw+8v7DqLUSdaz5Vpd856LmInIS4mi6uoo
         BP+Jls2662NwPtK2ys2AkUnWJarCeoWHp/rmRLydYAM9i+RCYan6HlnFVRQyhPb5qSDf
         479g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JRNVp8GdKibjrnv9VRzWXM3dOgQNe3Di0UKvmBxOiM0=;
        b=JBcpsPEpo9GvOSyJJbPFEJQAFXG4f/uyd9eT2WCA8nmGnK0YirszQlQwagd7a08jJp
         7QQKRrDTAOQVWxSn4ecleVGrWnTE17Rkk+Lh5WgttKXapmFAJtBk+8fuXiEW8iZI6ZtF
         WhLKl0f4sv8TTvhkO/PdGyyOblY2btSm8IrTNoA7ojyQQ+DGgphE1ivD+OVKtK43Ldzl
         8p5R+LvdnhsTtZw0oWXfB6aXYOowSRzhidRwqk1o2t1UbsL7qEa1C1py4C+TAPbjLeBn
         Jog2UY4vCAewNFuCpasU0yjDKwHri9MeKERS20bjbsSi/7laCnwnM9UeNGCSo9Uf6GPa
         VlFg==
X-Gm-Message-State: AOAM530TJMhVmi57EHd6TSFXTAm35tm+hXW9BNsFA5q59cK8LTi8A9Sm
        S49eOZcNH4GDUXPmnXtVmZeWQeq6i8buOH+yb/g=
X-Google-Smtp-Source: ABdhPJzmhH/7CCA0gmLDnQGmgx/xMOl8nu0gy1qfvliClkytzdLBurbIhiF3iUOpgkM3N1N5BjNPKIuD9I1+Mb5tEPo=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr16144022ybe.403.1602373770149;
 Sat, 10 Oct 2020 16:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201010234006.7075-1-daniel@iogearbox.net> <20201010234006.7075-4-daniel@iogearbox.net>
In-Reply-To: <20201010234006.7075-4-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 10 Oct 2020 16:49:19 -0700
Message-ID: <CAEf4BzaNXT0y5teCbNzE-8oB6zV2HctTYhTmKGDeboDjh7ogUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 3/6] bpf: allow for map-in-map with dynamic
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

On Sat, Oct 10, 2020 at 4:40 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
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

Looks good, thanks!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

[...]
