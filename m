Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2881CB808
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEHTR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHTR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:17:26 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE44C061A0C;
        Fri,  8 May 2020 12:17:26 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so1726912qkh.11;
        Fri, 08 May 2020 12:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8qkd1Vxkbdock9qtJb1K8tFWR6V/0xtrk6Iu1YkChhk=;
        b=eHNFfeUwolwUVcCoIod6HU1+w7hIOl+k1q3vHap3/nTidpOktOndoQE1lOoQMKs6Ot
         F+JdA8Uhs6gox9Cf7SHLi49cf15ZpJJCcyM6O/MTXN7kkCsgwT2ODvKGS2OBdpJVGFgf
         Woo1liK+S3h9S16y/MBCVFBCS5tdccYK66Jm/J6unPR5F9+pFyvLfhvjJyZD4UNQpFIf
         N8NrqpVwGnW3DHoxeR6Nh9C0i+nu8+Flf8Ge9YpQEQr7pC9CLnutaY+irJpzweGJlUav
         kbogUZC1n9lelzWH2ufUzK+oG6e0nZeRoewOi1J5Nf3+q3r/ozfiFk5vW/reJyntarOp
         bBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8qkd1Vxkbdock9qtJb1K8tFWR6V/0xtrk6Iu1YkChhk=;
        b=C0MyqvOlTTjhnYzrs2PZe0pCH3tY0d5Xw/OjhjXHaXn/BXIQsM0OAB8ye5VgVKdgFW
         71EH1MAwwduUvRIwGSyOW8F2kODDfufqsCFCTTiEkxgF91aEKtTBOuOH0Inl3hrMC5ne
         rUY+2SCw8D80loQM0X4BcQyQXu6D9aKP1V6iOkPlRPnQEm0gSbXtJM+wnBgI7Ohw3Ipv
         IPlubfsAZAoYIImvv7kJUFUZaT3JEb1puf6XrpR3yqvr+6UijXmpUSEtBgoWsjxq4KIW
         LJnCarUubZ3m1ATsk4sZfmOa1/DW16Xq7lKpRTp8VNlZ1uEZRRB7mKZYb8e0vj/siIhV
         c6bg==
X-Gm-Message-State: AGi0PuaX8puMwkxzUwarvUEMa0yh0oTKmmMc54qfO7AeR505NKG3m0w/
        mRhXJyyxHvRDwkY/1Dbd96dDthdaqGQ4+DKR2qWvxbX/
X-Google-Smtp-Source: APiQypInEDI2ZEkQtiPnf0RkqYHZYktNakLE873Mauna+yIMgftIRTGpEF+U+czKJfrtx3rwcFFPjI5V8n/uZvs7+fk=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr4280505qkj.92.1588965445914;
 Fri, 08 May 2020 12:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053926.1543403-1-yhs@fb.com>
In-Reply-To: <20200507053926.1543403-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:17:15 -0700
Message-ID: <CAEf4BzYvwCaG9sTFM-mJXRF-BosuRRe+URZpVUvrke-nXABivA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 10/21] net: bpf: add netlink and ipv6_route
 bpf_iter targets
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
> This patch added netlink and ipv6_route targets, using
> the same seq_ops (except show() and minor changes for stop())
> for /proc/net/{netlink,ipv6_route}.
>
> The net namespace for these targets are the current net
> namespace at file open stage, similar to
> /proc/net/{netlink,ipv6_route} reference counting
> the net namespace at seq_file open stage.
>
> Since module is not supported for now, ipv6_route is
> supported only if the IPV6 is built-in, i.e., not compiled
> as a module. The restriction can be lifted once module
> is properly supported for bpf_iter.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks correct.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  fs/proc/proc_net.c       | 19 +++++++++
>  include/linux/proc_fs.h  |  3 ++
>  net/ipv6/ip6_fib.c       | 65 +++++++++++++++++++++++++++++-
>  net/ipv6/route.c         | 37 +++++++++++++++++
>  net/netlink/af_netlink.c | 87 +++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 207 insertions(+), 4 deletions(-)
>

[...]

> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 3912aac7854d..25f6d3e619d0 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -6393,6 +6393,30 @@ void __init ip6_route_init_special_entries(void)
>    #endif
>  }
>
> +#if IS_BUILTIN(CONFIG_IPV6)
> +#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
> +DEFINE_BPF_ITER_FUNC(ipv6_route, struct bpf_iter_meta *meta, struct fib6_info *rt)
> +
> +static int __init bpf_iter_register(void)
> +{
> +       struct bpf_iter_reg reg_info = {
> +               .target                 = "ipv6_route",
> +               .seq_ops                = &ipv6_route_seq_ops,
> +               .init_seq_private       = bpf_iter_init_seq_net,
> +               .fini_seq_private       = bpf_iter_fini_seq_net,
> +               .seq_priv_size          = sizeof(struct ipv6_route_iter),
> +       };
> +
> +       return bpf_iter_reg_target(&reg_info);
> +}
> +
> +static void bpf_iter_unregister(void)
> +{
> +       bpf_iter_unreg_target("ipv6_route");

Nit. This string duplication is unfortunate. If bpf_iter_unreg_target
took same `struct bpf_iter_ret *` as bpf_iter_reg_target(), it would
be symmetrical and not dependent on magic strings anymore. That
reg_info struct would just be static const struct global variable
passed to both register/unregister.

> +}
> +#endif
> +#endif
> +

[...]
