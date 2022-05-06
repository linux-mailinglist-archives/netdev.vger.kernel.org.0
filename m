Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC2B51E0DD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444353AbiEFVQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiEFVP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:15:59 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F976EC7B;
        Fri,  6 May 2022 14:12:15 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id i22so5580791ila.1;
        Fri, 06 May 2022 14:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S4OxoVMwYpNwbrGj4NKGMSUgtBwSQCWc2E0fSlFQJtE=;
        b=jsVP1iDrUumwbjhE98Y+o+fYPdQTFQ+kEQkVPfu3XOOqxoDWmHKY6SEVExZlYJs7SX
         1XImN/INIRNhMstxtMw1njpkH4XqWtz/deAgpyNNqm1u+P15hFG3jUWOuo9f/9jDPm2h
         uNtX574SnvjuBUCk9R+l/DD2O+ya+zeOzeSpySo5d1bNSqTTGDURTxvbIrBduCTWaFST
         nV14SBWpHoYNU8VHTyV9epVKskZr13LXCcFJvJXQ5yDjaDGDeux8cMHr9+cMR9M8/9Yv
         dpCcgK4J9W3o6vkYMePoZuQFZpGMZZpk65HmNN1e8sXObePkTY03fFuqsNajNBD6P0lG
         vf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S4OxoVMwYpNwbrGj4NKGMSUgtBwSQCWc2E0fSlFQJtE=;
        b=za0R/84pAIf4VvN1rhDqIaTfzCJ57C3DDTuy+OWSK/JOFlLlUzDX35bpcECwg5NPr9
         HZm4Hyg03pH6NbyE1rUQt1zKZ5u01j9dQDFbJKQRL1FTPFMLKPKbszHnjqO6q+Pe2wGH
         JC7kn5IAnTX0+C6JxSUayIH52qP+M4v4IuuOyHMG/mqLvAWNvGhOxN18dsxImDd5psEv
         sJtYNZv7iGc/tGGBfms+pXt4xcuQTsXlE8v77iODVN9UttVrBRxDlK9pUDCAoiOZ1FGp
         F+bnZmOazi3WVuepzeyrTCIzEb7zW2W1u3wSdhEf/a5G9LwQhYklM6WPnfN+rE1io5cg
         7Lnw==
X-Gm-Message-State: AOAM5339ZZLPZuJJ65ByLNyGEJ02lDHJgjEzn0/zruCvMkNU7gYH47dM
        z9NUvc4r2lE4Z+KztTzCGCev/+KUEXQXf+9qGcs=
X-Google-Smtp-Source: ABdhPJxLB+Z+rDhsxemCPyaFDhQEmIC5l9UvjlCfN1f+VU1VibPtYe7vL6/SSellQFTIiGdYCtViSjhxHesHve1yhas=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr2038491ilb.305.1651871534347; Fri, 06
 May 2022 14:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <20220503171437.666326-3-maximmi@nvidia.com>
In-Reply-To: <20220503171437.666326-3-maximmi@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 14:12:03 -0700
Message-ID: <CAEf4Bzb-y7-5PG2vjdy__Jqwb2n2hPPQ_8Xs9R_cnenwT-AyTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 2/5] bpf: Allow helpers to accept pointers
 with a fixed size
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> Before this commit, the BPF verifier required ARG_PTR_TO_MEM arguments
> to be followed by ARG_CONST_SIZE holding the size of the memory region.
> The helpers had to check that size in runtime.
>
> There are cases where the size expected by a helper is a compile-time
> constant. Checking it in runtime is an unnecessary overhead and waste of
> BPF registers.
>
> This commit allows helpers to accept ARG_PTR_TO_MEM arguments without
> the corresponding ARG_CONST_SIZE, given that they define the memory
> region size in struct bpf_func_proto.

I think it's much less confusing and cleaner to have
ARG_PTR_TO_FIXED_SIZE_MEM (or whatever similar name), instead of
adding special casing to ARG_PTR_TO_MEM.

>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/linux/bpf.h   | 10 ++++++++++
>  kernel/bpf/verifier.c | 26 +++++++++++++++-----------
>  2 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index be94833d390a..255ae3652225 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -514,6 +514,16 @@ struct bpf_func_proto {
>                 };
>                 u32 *arg_btf_id[5];
>         };
> +       union {
> +               struct {
> +                       size_t arg1_size;
> +                       size_t arg2_size;
> +                       size_t arg3_size;
> +                       size_t arg4_size;
> +                       size_t arg5_size;
> +               };
> +               size_t arg_size[5];
> +       };

We have almost 250 instances of struct bpf_func_proto variables:

$ rg 'const struct bpf_func_proto.* = \{' | wc -l
244

You are adding 40 bytes to it just to use it for 1-2 special
prototypes. It is quite expensive, IMHO, to increase vmlinux image
size by 10KB just for this.

Should we reuse arg_btf_id union (same argument won't be PTR_TO_BTF_ID
and PTR_TO_FIXED_SIZE_MEM, right)? Or alternatively special-case those
few prototypes in verifier code directly when trying to fetch memory
size?


>         int *ret_btf_id; /* return value btf_id */
>         bool (*allowed)(const struct bpf_prog *prog);
>  };

[...]
