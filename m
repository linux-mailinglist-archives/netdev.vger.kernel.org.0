Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5A83CBECF
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbhGPWBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhGPWBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:01:49 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BEFC06175F;
        Fri, 16 Jul 2021 14:58:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id g19so17146024ybe.11;
        Fri, 16 Jul 2021 14:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xvZiHYh8sEvszytNrjZADXCU0w7qYvrE5/t4RLDqOsI=;
        b=CjsG1uPIi+UXIKJBh2ziGoaGVXWW6PmmzjLzSILLt6vo8EbpD6K3uyR2cUJBtJqu3c
         qnvo5XGauII6J+XKA6nuUZ9/k380+h02aLiqbwRdJcg+tm5WXNyVjLhncNGliDuUJcku
         lpQXxoJsRmw1FqlxuK+moWIGquN6g0ksUO5DIzxFOOzVc4QUwwuiv/3P6CIMFezDhT6G
         ibliOUsu9ihdC/P73mgJslCM6p+ZGeyITKyKoubgyxcDOZB5XqGDjTRmzxb5g4nk8fWf
         2Q5pwBb+xLqwYtkSk8+v0zNcp2JyVt4CM9LvEOJRbMjHBhptdwy8HkctbcjyX296Ofd+
         bR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xvZiHYh8sEvszytNrjZADXCU0w7qYvrE5/t4RLDqOsI=;
        b=lVnxEihwkmPiF0mn29BnCWp3jLcqzerwERA0z3UEOQ/iv4jzeNUiULzIVO031++hR4
         YwGSylISyH9GwEKp3OAN/SvgEOKMwRZAJG2Vvx1UJG3zWXtOitg3oSd++a3Z6h9wSwbS
         vGJ+SSZbMepJsfj+kKb1dcnvcTpOQRs0pDW/Ijnbt4o4IkagolB/2MWBrnAVnrFGOeVF
         8LfH7IX80xrgPIsFSgRlkOOzgvKDEW6dugQoH7FTcjrRsy00SrYFNr5vmTHC9f9oTpGh
         T2+PqBlXjtPrnpZgSJUxEm0UxcJr5iC40I48wJ6XMvolTNTzEmtaCXcNYLiPlHuxjHGq
         XB4Q==
X-Gm-Message-State: AOAM530GjCPDkbXdzM0xLDHfix4nO4mCJvodRXOOr8l6myU75mSR8kLT
        riOsTzWuuzA7Mpn1jFp4bmqCUIJII5QmuE9PU7k=
X-Google-Smtp-Source: ABdhPJxD5MFWm9MUnE/OVW0WS0gpZ6N5HwesFJ1ViVBOxXJrkMD4vNIvo2mzg3lPB1eVdHjkWiW93dYcyJvRSURCzfU=
X-Received: by 2002:a25:3787:: with SMTP id e129mr15036161yba.459.1626472732969;
 Fri, 16 Jul 2021 14:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com> <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 14:58:42 -0700
Message-ID: <CAEf4BzaewudVvonuisxPb9rTO6_cj=SCZMUmRf-iGnbeNcGukg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 1/3] libbpf: BTF dumper support for typed data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 8:15 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Add a BTF dumper for typed data, so that the user can dump a typed
> version of the data provided.
>
> The API is
>
> int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>                              void *data, size_t data_sz,
>                              const struct btf_dump_type_data_opts *opts);
>
> ...where the id is the BTF id of the data pointed to by the "void *"
> argument; for example the BTF id of "struct sk_buff" for a
> "struct skb *" data pointer.  Options supported are
>
>  - a starting indent level (indent_lvl)
>  - a user-specified indent string which will be printed once per
>    indent level; if NULL, tab is chosen but any string <= 32 chars
>    can be provided.
>  - a set of boolean options to control dump display, similar to those
>    used for BPF helper bpf_snprintf_btf().  Options are
>         - compact : omit newlines and other indentation
>         - skip_names: omit member names
>         - emit_zeroes: show zero-value members
>
> Default output format is identical to that dumped by bpf_snprintf_btf(),
> for example a "struct sk_buff" representation would look like this:
>
> struct sk_buff){
>         (union){
>                 (struct){
>                         .next = (struct sk_buff *)0xffffffffffffffff,
>                         .prev = (struct sk_buff *)0xffffffffffffffff,
>                 (union){
>                         .dev = (struct net_device *)0xffffffffffffffff,
>                         .dev_scratch = (long unsigned int)18446744073709551615,
>                 },
>         },
> ...
>
> If the data structure is larger than the *data_sz*
> number of bytes that are available in *data*, as much
> of the data as possible will be dumped and -E2BIG will
> be returned.  This is useful as tracers will sometimes
> not be able to capture all of the data associated with
> a type; for example a "struct task_struct" is ~16k.
> Being able to specify that only a subset is available is
> important for such cases.  On success, the amount of data
> dumped is returned.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf.h      |  19 ++
>  tools/lib/bpf/btf_dump.c | 819 ++++++++++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.map |   1 +
>  3 files changed, 834 insertions(+), 5 deletions(-)
>

[...]

> +/* return size of type, or if base type overflows, return -E2BIG. */
> +static int btf_dump_type_data_check_overflow(struct btf_dump *d,
> +                                            const struct btf_type *t,
> +                                            __u32 id,
> +                                            const void *data,
> +                                            __u8 bits_offset)
> +{
> +       __s64 size = btf__resolve_size(d->btf, id);
> +
> +       if (size < 0 || size >= INT_MAX) {
> +               pr_warn("unexpected size [%lld] for id [%u]\n",
> +                       size, id);

ppc64le arch doesn't like the %lld:

 In file included from btf_dump.c:22:
btf_dump.c: In function 'btf_dump_type_data_check_overflow':
libbpf_internal.h:111:22: error: format '%lld' expects argument of
type 'long long int', but argument 3 has type '__s64' {aka 'long int'}
[-Werror=format=]
  111 |  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
      |                      ^~~~~~~~~~
libbpf_internal.h:114:27: note: in expansion of macro '__pr'
  114 | #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                           ^~~~
btf_dump.c:1992:3: note: in expansion of macro 'pr_warn'
 1992 |   pr_warn("unexpected size [%lld] for id [%u]\n",
      |   ^~~~~~~
btf_dump.c:1992:32: note: format string is defined here
 1992 |   pr_warn("unexpected size [%lld] for id [%u]\n",
      |                             ~~~^
      |                                |
      |                                long long int
      |                             %ld


Cast to size_t and use %zu.

> +               return -EINVAL;
> +       }
> +

[...]
