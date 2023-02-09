Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EFC6911A2
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjBITw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjBITw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:52:27 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA7612F2C;
        Thu,  9 Feb 2023 11:52:24 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m2so9731630ejb.8;
        Thu, 09 Feb 2023 11:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EloPaQFnO4w90/UyCJV6KwoWQwdDOtOpIFoUpYCed/c=;
        b=NEOnhm9l2PA9ZgjTe1XTMV92Tq+1y+ibYKkehqvB86tAG/feySkHZAsLgpQmIjDx4Q
         xJ0E+ZOb74BFbGI3sEG8uojNbyLOS9AhwNAZcQQIOGdWekANjBtdH6pTxJ1j6y2iZVeD
         3tn85/I8Q8H7c3k0EUz67hHqBHbo7kAPPSjkQvZs+8Zrey3JxejY8bTIWYX/pwpSYJij
         +IadoEMe63a/TRcGOLlYYuUYe/ym4gPMoI9j/pQovZcODIGx0bvVErE4dRkUgpcVE3L/
         YosMitUlKVuWsu01U16A4aIe8IHbM/ZoqWaxtF7c8NF9YCIKnghSxKvDRDjEtGU5STFn
         QaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EloPaQFnO4w90/UyCJV6KwoWQwdDOtOpIFoUpYCed/c=;
        b=0dhxao7kZw4JrzodSUFAw50KZS4YjB7r8DOLRhMgaGqW/VKVjvSLRPQXycn8xN63l1
         NKANOuFMwWsT7aj1Cuem8NvxO+wcT0NCThbnwNJ7QCKIwyUg9u2JM2IdPLCYFlnIUEdM
         maoh7p2oV1uUOrzvmQcdEr/JRlHRW3pB3lb1jZg/8I164yZzWOqaAr1NtjiXQEU2WxYz
         s6Zllp8P0xE0FAE9ZgsG/0Eydk/gRKp0GYCPh/Tl9KVlRg4byvpHz/PCqS7t+iKxhsBP
         8RQSjpjSVviYMYBEkssIPrzLua5ITr/N3RI/O0JZc8+L602vOiz9aWHjJMWaeaeSaBqg
         7kgg==
X-Gm-Message-State: AO0yUKVKJEeR/3xYKzcCD4Jle/Enrpsq7IHvpLq6LAdIswHUvoaxBOmv
        n9w0NXq2o1tAEnXBebKzanlW2o7UZX544A4V/iw=
X-Google-Smtp-Source: AK7set93q4x6wCG804+tszb8kwkcrHCdhzsz4klOPlo5s3ZDF/jpWyHGjoysf7crWXJpeuayHJqhEBb1I3D8O2cW3LY=
X-Received: by 2002:a17:906:5a60:b0:8aa:bdec:d9ae with SMTP id
 my32-20020a1709065a6000b008aabdecd9aemr1869264ejc.12.1675972343370; Thu, 09
 Feb 2023 11:52:23 -0800 (PST)
MIME-Version: 1.0
References: <20230209192337.never.690-kees@kernel.org>
In-Reply-To: <20230209192337.never.690-kees@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Feb 2023 11:52:10 -0800
Message-ID: <CAEf4BzZXrf48wsTP=2H2gkX6T+MM0B45o0WNswi50DQ_B-WG4Q@mail.gmail.com>
Subject: Re: [PATCH] bpf: Deprecate "data" member of bpf_lpm_trie_key
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Haowen Bai <baihaowen@meizu.com>, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 11:23 AM Kees Cook <keescook@chromium.org> wrote:
>
> The kernel is globally removing the ambiguous 0-length and 1-element
> arrays in favor of flexible arrays, so that we can gain both compile-time
> and run-time array bounds checking[1]. Most cases of these changes are
> trivial, but this case in BPF is not. It faces some difficulties:
>
> 1) struct bpf_lpm_trie_key is part of UAPI so changes can be fragile in
>    the sense that projects external to Linux may be impacted.
>
> 2) The struct is intended to be used as a header, which means it may
>    be within another structure, resulting in the "data" array member
>    overlapping with the surrounding structure's following members. When
>    converting from [0]-style to []-style, this overlap elicits warnings
>    under Clang, and GCC considers it a deprecated extension (and similarly
>    warns under -pedantic): https://godbolt.org/z/vWzqs41h6
>
> 3) Both the kernel and userspace access the existing "data" member
>    for more than just static initializers and offsetof() calculations.
>    For example:
>
>       cilium:
>         struct egress_gw_policy_key in_key = {
>                 .lpm_key = { 32 + 24, {} },
>                 .saddr   = CLIENT_IP,
>                 .daddr   = EXTERNAL_SVC_IP & 0Xffffff,
>         };
>
>       systemd:
>         ipv6_map_fd = bpf_map_new(
>                         BPF_MAP_TYPE_LPM_TRIE,
>                         offsetof(struct bpf_lpm_trie_key, data) + sizeof(uint32_t)*4,
>                         sizeof(uint64_t), ...);
>         ...
>         struct bpf_lpm_trie_key *key_ipv4, *key_ipv6;
>         ...
>         memcpy(key_ipv4->data, &a->address, sizeof(uint32_t));
>
>    Searching for other uses in Debian Code Search seem to be just copies
>    of UAPI headers:
>    https://codesearch.debian.net/search?q=struct+bpf_lpm_trie_key&literal=1&perpkg=1
>
> Introduce struct bpf_lpm_trie_key_u8 for the kernel (and future userspace)
> to use for walking the individual bytes following the header, and leave
> the "data" member of struct bpf_lpm_trie_key as-is (i.e. a [0]-style
> array). This will allow existing userspace code to continue to use "data"
> as a fake flexible array. The kernel (and future userspace code) building
> with -fstrict-flex-arrays=3 will see struct bpf_lpm_trie_key::data has
> having 0 bytes so there will be no overlap warnings, and can instead
> use struct bpf_lpm_trie_key_u8::data for accessing the actual byte
> array contents. The definition of struct bpf_lpm_trie_key_u8 uses a
> union with struct bpf_lpm_trie_key so that things like container_of()
> can be used instead of doing explicit casting, all while leaving the
> member names un-namespaced (i.e. key->prefixlen == key_u8->prefixlen,
> key->data == key_u8->data), allowing for trivial drop-in replacement
> without collateral member renaming.
>
> This will avoid structure overlap warnings and array bounds warnings
> while enabling run-time array bounds checking under CONFIG_UBSAN_BOUNDS=y
> and -fstrict-flex-arrays=3.
>
> For reference, the current warning under GCC 13 with -fstrict-flex-arrays=3
> and -Warray-bounds is:
>
> ../kernel/bpf/lpm_trie.c:207:51: warning: array subscript i is outside array bounds of 'const __u8[0]' {aka 'const unsigned char[]'} [-Warray-bounds=]
>   207 |                                        *(__be16 *)&key->data[i]);
>       |                                                   ^~~~~~~~~~~~~
> ../include/uapi/linux/swab.h:102:54: note: in definition of macro '__swab16'
>   102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
>       |                                                      ^
> ../include/linux/byteorder/generic.h:97:21: note: in expansion of macro '__be16_to_cpu'
>    97 | #define be16_to_cpu __be16_to_cpu
>       |                     ^~~~~~~~~~~~~
> ../kernel/bpf/lpm_trie.c:206:28: note: in expansion of macro 'be16_to_cpu'
>   206 |                 u16 diff = be16_to_cpu(*(__be16 *)&node->data[i]
> ^
>       |                            ^~~~~~~~~~~
> In file included from ../include/linux/bpf.h:7:
> ../include/uapi/linux/bpf.h:82:17: note: while referencing 'data'
>    82 |         __u8    data[0];        /* Arbitrary size */
>       |                 ^~~~
>
> Additionally update the samples and selftests to use the new structure,
> for demonstrating best practices.
>
> [1] For lots of details, see both:
>     https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays
>     https://people.kernel.org/kees/bounded-flexible-arrays-in-c
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Mykola Lysenko <mykolal@fb.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: bpf@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/uapi/linux/bpf.h                   | 15 +++++++++++++--
>  kernel/bpf/lpm_trie.c                      | 16 +++++++++-------
>  samples/bpf/map_perf_test_user.c           |  2 +-
>  samples/bpf/xdp_router_ipv4_user.c         |  2 +-
>  tools/testing/selftests/bpf/test_lpm_map.c | 14 +++++++-------
>  5 files changed, 31 insertions(+), 18 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ba0f0cfb5e42..f843a7582456 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -76,10 +76,21 @@ struct bpf_insn {
>         __s32   imm;            /* signed immediate constant */
>  };
>
> -/* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
> +/* Header for a key of a BPF_MAP_TYPE_LPM_TRIE entry */
>  struct bpf_lpm_trie_key {
>         __u32   prefixlen;      /* up to 32 for AF_INET, 128 for AF_INET6 */
> -       __u8    data[0];        /* Arbitrary size */
> +       __u8    data[0];        /* Deprecated field: use struct bpf_lpm_trie_key_u8 */
> +};
> +
> +/* Raw (u8 byte array) key of a BPF_MAP_TYPE_LPM_TRIE entry */
> +struct bpf_lpm_trie_key_u8 {
> +       union {
> +               struct bpf_lpm_trie_key hdr;
> +               struct {
> +                       __u32   prefixlen;
> +                       __u8    data[];
> +               };
> +       };
>  };

Do we need to add a new type to UAPI at all here? We can make this new
struct internal to kernel code (e.g. struct bpf_lpm_trie_key_kern) and
point out that it should match the layout of struct bpf_lpm_trie_key.
User-space can decide whether to use bpf_lpm_trie_key as-is, or if
just to ensure their custom struct has the same layout (I see some
internal users at Meta do just this, just make sure that they have
__u32 prefixlen as first member).

This whole union work-around seems like just extra cruft that we don't
really need in UAPI.

Or did I miss anything?


[...]
