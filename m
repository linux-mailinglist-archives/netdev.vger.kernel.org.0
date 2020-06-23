Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57770205ADF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733254AbgFWSdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733174AbgFWSdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:33:47 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08EDC061573;
        Tue, 23 Jun 2020 11:33:46 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id cv17so10115670qvb.13;
        Tue, 23 Jun 2020 11:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCcgoWpqsPBIRGWIpIPXz560VFo4wTsrkocxos1a58M=;
        b=l9OA6O1coHeRAOluEwFNfdZqF+YQs441fSxNEpkuWFaZa2peWeekfb+Ex2QDO4hPCH
         B05HGXwQaaFq3eYG6xbEHXOLpESM6t0Fc3U/o50LatiC9kh0xBfYoZZeTcJwmZgQiv3v
         4VYgWmg5e5FiM+8CiS6u9svdaMj/LwsEtoF27joWHP0a0N56uCHNJ78ZudXBXtcAqXKt
         CW63XrUUmvb8SOffxRHZs6ukeOxvKVVD1zqeUfoviQeuNgdDDVRqYFj0BbwKSvB9Ox1J
         F+vCt87GT4boOFlx5YFe+3Jb0wgqsqC3/Rl+KEKRTu7NRIfaeciNEVzZdR7pfQmpGbMv
         DVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCcgoWpqsPBIRGWIpIPXz560VFo4wTsrkocxos1a58M=;
        b=X04M2tpvfwLc5v3QgOjVRGovJt3joLcvTixhYV8vQEhjUoUmCSexGMtNpuR355EZDf
         oImL953aKqkxZNQHvxUoFNYtqKD4U8AYru/PfouUrSoiTFWR5e4fAcfLVFB2wd6BNp9U
         vybX/fgQHBuGlZg7CukpfVBCibvOZgSLah7w6D06rK4+hWDpcAvzfnpihCzo/EhgHz6K
         2qVuxuBNFrq0cswF1qIPZfcoIPwT81jyUo2lt95C5u7eOBQARpHeuBcHRcmdVJc/jfCw
         eUo/vsKkXf5pggkJ+z48r7XxnDKsiNfXX8v/isgk3djRGDK96BAdOreHtHUD7g2UO5Iz
         FvRQ==
X-Gm-Message-State: AOAM53254p39f3n4U66pPWfiXbFLTu4ndjonz6lwNLGxUMaaRnRQapHC
        zb/ex+SDJnkUDPkPrNC/lsHxAOxZMv7Ii+FCB3c=
X-Google-Smtp-Source: ABdhPJwHJSkVMEZZfrs1A9V4SFyNTNjbEcAYxoCqkKfZJubvMzx11W9wdAo6fwC3JYxHSCY0aqt965G+XIQSW8wYuEM=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr26930339qvf.247.1592937226066;
 Tue, 23 Jun 2020 11:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <159293239241.32225.12338844121877017327.stgit@john-Precision-5820-Tower>
In-Reply-To: <159293239241.32225.12338844121877017327.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:33:35 -0700
Message-ID: <CAEf4BzYZBoffuYUfssw+wBgz2SQx9E=AAP0VvOQDMc3Y3y1zLA@mail.gmail.com>
Subject: Re: [bpf PATCH] bpf: do not allow btf_ctx_access with __int128 types
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 10:14 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> To ensure btf_ctx_access() is safe the verifier checks that the BTF
> arg type is an int, enum, or pointer. When the function does the
> BTF arg lookup it uses the calculation 'arg = off / 8'  using the
> fact that registers are 8B. This requires that the first arg is
> in the first reg, the second in the second, and so on. However,
> for __int128 the arg will consume two registers by default LLVM
> implementation. So this will cause the arg layout assumed by the
> 'arg = off / 8' calculation to be incorrect.
>
> Because __int128 is uncommon this patch applies the easiest fix and
> will force int types to be sizeof(u64) or smaller so that they will
> fit in a single register.
>
> Fixes: 9e15db66136a1 ("bpf: Implement accurate raw_tp context access via BTF")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

"small int" for u64 looks funny, but naming is hard :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/btf.h |    5 +++++
>  kernel/bpf/btf.c    |    4 ++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 5c1ea99..35642f6 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -82,6 +82,11 @@ static inline bool btf_type_is_int(const struct btf_type *t)
>         return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
>  }
>
> +static inline bool btf_type_is_small_int(const struct btf_type *t)
> +{
> +       return btf_type_is_int(t) && (t->size <= sizeof(u64));

nit: unnecessary (), () are usually used to disambiguate | and &  vs
|| and &&; this is not the case, though.

> +}
> +
>  static inline bool btf_type_is_enum(const struct btf_type *t)
>  {
>         return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 58c9af1..9a1a98d 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3746,7 +3746,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>                                 return false;
>
>                         t = btf_type_skip_modifiers(btf, t->type, NULL);
> -                       if (!btf_type_is_int(t)) {
> +                       if (!btf_type_is_small_int(t)) {
>                                 bpf_log(log,
>                                         "ret type %s not allowed for fmod_ret\n",
>                                         btf_kind_str[BTF_INFO_KIND(t->info)]);
> @@ -3768,7 +3768,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>         /* skip modifiers */
>         while (btf_type_is_modifier(t))
>                 t = btf_type_by_id(btf, t->type);
> -       if (btf_type_is_int(t) || btf_type_is_enum(t))
> +       if (btf_type_is_small_int(t) || btf_type_is_enum(t))
>                 /* accessing a scalar */
>                 return true;
>         if (!btf_type_is_ptr(t)) {
>
