Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC21FFF91
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 03:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgFSBKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 21:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbgFSBKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 21:10:42 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDF6C06174E;
        Thu, 18 Jun 2020 18:10:41 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so3901775qkc.6;
        Thu, 18 Jun 2020 18:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v/V9+pW70OEf97NCGu5ygJfNfIbyxmiDx56EuL5HTi8=;
        b=ig4KXAIOPBdtFBYP4qB/47OGmAyi2cnxDJyqz3srpfG3d+e2A9aLqFazxccg18Nx+f
         C4MBFnJoMwj+R3X9UcBLJASCNuZcGaVqv68+wagzOWGyzTOmdaoi8Yfzzg6USQ9nMmYy
         bwoCFTfpo/17uHRDoRfR+cgs02zXTsJM25TaMr/RvDiiwvhUtEAcO33fCUtUsXurvp8Z
         a+GC+i6K2kj62jRkn1w65cMVWz3g0ZRyKiwn9o/h8OFFj+aS/gjw3l3q7kTd5xTfdwgE
         ULBwoz3bz3BDgMvPYqwM9yTZc2Mxuj9voUkKX4yp8oaG77GFa9bisFFYyybrgRgmpu5w
         kvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/V9+pW70OEf97NCGu5ygJfNfIbyxmiDx56EuL5HTi8=;
        b=sDvVyvYio4/JaeGWxzBT53beT+MaNkTHpoy20OMlcnei7aji4GHoX3oPimyf+8NeDi
         QG1tqBg1qG6vwMGyFrFhI1DGaDdUUo143Y4Lvv/dqyI0iTM4C2OlNV7KD+cH8lugR8do
         lwYrurdDkMRBREswVtEOpE+aSH9/Sr42RGdX5Ge6+nu33AvxI66Ke5Cdu+DBdiIU2H7p
         OPlMKgdr/TvrwI/upKhfNESkfBO5ifzR0fYZfhww4iorCIwPfqn2OTbMI0n4HyNKHs5S
         hZSILu2tbgBJ4BHeI38dFDQ44/AYdlWTEP+PCXjjCTyizUe/zmQJHDWuoLcb3fM4dLKz
         5mHA==
X-Gm-Message-State: AOAM531GCZb9YMUani6Mc87PdCKVfRcpAxz5k+OdfoDyCUp/7U2D3jtz
        ca5iYLQtbJ/ubso4DFK7aKLN/Vk8VZzwhbeTpsU96VOyn8w=
X-Google-Smtp-Source: ABdhPJzS+IpPOdFEIO+JY6Trg0uhsZU7vAqhv0vC/OXSVCiunBNrx1WLJb5r135cB94v7N+Nqidn8cpRG9CmlgxPExw=
X-Received: by 2002:a37:6712:: with SMTP id b18mr1298205qkc.36.1592529040547;
 Thu, 18 Jun 2020 18:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-6-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 18:10:29 -0700
Message-ID: <CAEf4BzYw0VciF-7CS164Nk8LLnZ4odtdYQyX1MS4eWDN5WbcSg@mail.gmail.com>
Subject: Re: [PATCH 05/11] bpf: Remove btf_id helpers resolving
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Now when we moved the helpers btf_id into .BTF_ids section,
> we can remove the code that resolve those IDs in runtime.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Nice! :)

BTW, have you looked at bpf_ctx_convert stuff? Would we be able to
replace it with your btfids thing as well?


>  kernel/bpf/btf.c | 88 +++---------------------------------------------
>  1 file changed, 4 insertions(+), 84 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 58c9af1d4808..aea7b2cc8d26 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4049,96 +4049,16 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         return -EINVAL;
>  }
>

[...]

>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
>  {
> -       int *btf_id = &fn->btf_id[arg];
> -       int ret;
> -
>         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
>                 return -EINVAL;
>
> -       ret = READ_ONCE(*btf_id);
> -       if (ret)
> -               return ret;
> -       /* ok to race the search. The result is the same */
> -       ret = __btf_resolve_helper_id(log, fn->func, arg);
> -       if (!ret) {
> -               /* Function argument cannot be type 'void' */
> -               bpf_log(log, "BTF resolution bug\n");
> -               return -EFAULT;
> -       }
> -       WRITE_ONCE(*btf_id, ret);
> -       return ret;
> +       if (WARN_ON_ONCE(!fn->btf_id))
> +               return -EINVAL;
> +
> +       return fn->btf_id[arg];

It probably would be a good idea to add some sanity checking here,
making sure that btf_id is >0 (void is never a right type) and <=
nr_types in vmlinux_btf?

>  }
>
>  static int __get_type_size(struct btf *btf, u32 btf_id,
> --
> 2.25.4
>
