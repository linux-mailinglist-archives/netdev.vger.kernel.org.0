Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9593525E2C3
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgIDUbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgIDUbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 16:31:08 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01530C061244;
        Fri,  4 Sep 2020 13:31:07 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c17so5282185ybe.0;
        Fri, 04 Sep 2020 13:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zTe3Mx2s33ZrVvXymlinvaXGi3RaFuG6B/IAiGNQ5rs=;
        b=bXq1pMwaRwQVggUO4Ptcv/YIYF+DOLFLGHEurYYZP8qlgil53eWi/z0vogf2RcYCZC
         Ro6ThynCuvncXKHb1mTaL8eSscapbHD+mjhwFZ+rJBXaxPDZll/KYQeId9BqKWwM6nkJ
         RZBa4G9ZcgezwEq9fX5whvvESKtaQP7t3woLBYXIB6zw+ROCjMLqKpL/Bf4Kr0c3e+IJ
         1z2Ki/Hcmm8j0n670X+kKR+06K/N5NF50tTMgVy+9zzQatGb8WKwBfpOJ0MLh/FaHe4E
         MCd/zIX4wYUodoCxGf8F9ldDUbp3F0IzA1CfGac/0gRQLnTNqWTOKKjOoXTW8VgLcMVQ
         KM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zTe3Mx2s33ZrVvXymlinvaXGi3RaFuG6B/IAiGNQ5rs=;
        b=PHkwwjwyUaZ9/ujFNT8A4cAZhtPPNVAmArw3jF5TNFpqsZQW9PxauMqaykL0NO3t7t
         wXPXuzHXXI6MozuLMe/I5uZo4DzyV+P0WWdnl4EAn6oqzfgckQguf0OafoMdfrJCVxO/
         qDsbzeorQyHxmVUAuRjHaNFDrtbnGG8legFnIKLRd/R0vCVmBbUOYBBQz6/24auTmBV6
         X07ujARu0MRmIAHVqm2ej1JBmqLNcuwwP2iTKdHsrnbdw13NvOvLhuZvMHzOegCHPwvH
         6x3nyx4YwmJwy7ksi0NEMv8JqSvH0qSbGXm7VZQW8e/eGUPrBpvbn+xGuqlqVukWsYZg
         0KSA==
X-Gm-Message-State: AOAM531cxBmWHgWsDbPdFxcx3jlcRcSHslmVoceLuIcJGmsK9b1H5Zrl
        wInVyXcn1BtV3X9aLASaprtir8kxvrOEyxNGueI=
X-Google-Smtp-Source: ABdhPJwNV/A0GEf144SXS3gF1pclDXRgHiyZ0LP/quE5bcqB/zFmX5pQ9eJfnmWYUWx+1P6jj9M+jRzIkiGakYBAqOQ=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr11862621ybe.510.1599251466796;
 Fri, 04 Sep 2020 13:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200904194900.3031319-1-yhs@fb.com> <20200904194900.3031377-1-yhs@fb.com>
In-Reply-To: <20200904194900.3031377-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 13:30:55 -0700
Message-ID: <CAEf4BzboqpYa7Zq=6xcpGez+jk--NTDA0=FQi5utwcFaHwC7bA@mail.gmail.com>
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

On Fri, Sep 4, 2020 at 12:49 PM Yonghong Song <yhs@fb.com> wrote:
>
> Commit 41c48f3a98231 ("bpf: Support access
> to bpf map fields") added support to access map fields
> with CORE support. For example,
>
>             struct bpf_map {
>                     __u32 max_entries;
>             } __attribute__((preserve_access_index));
>
>             struct bpf_array {
>                     struct bpf_map map;
>                     __u32 elem_size;
>             } __attribute__((preserve_access_index));
>
>             struct {
>                     __uint(type, BPF_MAP_TYPE_ARRAY);
>                     __uint(max_entries, 4);
>                     __type(key, __u32);
>                     __type(value, __u32);
>             } m_array SEC(".maps");
>
>             SEC("cgroup_skb/egress")
>             int cg_skb(void *ctx)
>             {
>                     struct bpf_array *array = (struct bpf_array *)&m_array;
>
>                     /* .. array->map.max_entries .. */
>             }
>
> In kernel, bpf_htab has similar structure,
>
>             struct bpf_htab {
>                     struct bpf_map map;
>                     ...
>             }
>
> In the above cg_skb(), to access array->map.max_entries, with CORE, the clang will
> generate two builtin's.
>             base = &m_array;
>             /* access array.map */
>             map_addr = __builtin_preserve_struct_access_info(base, 0, 0);
>             /* access array.map.max_entries */
>             max_entries_addr = __builtin_preserve_struct_access_info(map_addr, 0, 0);
>             max_entries = *max_entries_addr;
>
> In the current llvm, if two builtin's are in the same function or
> in the same function after inlining, the compiler is smart enough to chain
> them together and generates like below:
>             base = &m_array;
>             max_entries = *(base + reloc_offset); /* reloc_offset = 0 in this case */
> and we are fine.
>
> But if we force no inlining for one of functions in test_map_ptr() selftest, e.g.,
> check_default(), the above two __builtin_preserve_* will be in two different
> functions. In this case, we will have code like:
>    func check_hash():
>             reloc_offset_map = 0;
>             base = &m_array;
>             map_base = base + reloc_offset_map;
>             check_default(map_base, ...)
>    func check_default(map_base, ...):
>             max_entries = *(map_base + reloc_offset_max_entries);
>
> In kernel, map_ptr (CONST_PTR_TO_MAP) does not allow any arithmetic.
> The above "map_base = base + reloc_offset_map" will trigger a verifier failure.
>   ; VERIFY(check_default(&hash->map, map));
>   0: (18) r7 = 0xffffb4fe8018a004
>   2: (b4) w1 = 110
>   3: (63) *(u32 *)(r7 +0) = r1
>    R1_w=invP110 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
>   ; VERIFY_TYPE(BPF_MAP_TYPE_HASH, check_hash);
>   4: (18) r1 = 0xffffb4fe8018a000
>   6: (b4) w2 = 1
>   7: (63) *(u32 *)(r1 +0) = r2
>    R1_w=map_value(id=0,off=0,ks=4,vs=8,imm=0) R2_w=invP1 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
>   8: (b7) r2 = 0
>   9: (18) r8 = 0xffff90bcb500c000
>   11: (18) r1 = 0xffff90bcb500c000
>   13: (0f) r1 += r2
>   R1 pointer arithmetic on map_ptr prohibited
>
> To fix the issue, let us permit map_ptr + 0 arithmetic which will
> result in exactly the same map_ptr.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/verifier.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b4e9c56b8b32..92aa985e99df 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5317,6 +5317,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>                         dst, reg_type_str[ptr_reg->type]);
>                 return -EACCES;
>         case CONST_PTR_TO_MAP:
> +               if (known && smin_val == 0 && opcode == BPF_ADD)

does smin_val imply that var_off is strictly zero? if that's the case,
can you please leave a comment stating this clearly, it's hard to tell
if that's enough of a check.

> +                       break;
> +               /* fall-through */
>         case PTR_TO_PACKET_END:
>         case PTR_TO_SOCKET:
>         case PTR_TO_SOCKET_OR_NULL:
> --
> 2.24.1
>
