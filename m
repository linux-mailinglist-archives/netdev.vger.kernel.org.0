Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F33FD082
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbhIAA4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241156AbhIAA4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:56:22 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D281C061575;
        Tue, 31 Aug 2021 17:55:26 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id f15so1958888ybg.3;
        Tue, 31 Aug 2021 17:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TCGFPpcc8GufCoAaIzbMQIF88I5DF0YXGiEmPHcl16w=;
        b=PMlv53spX1Zt0M00yXgl0NPlmxCZ9aJZytWJNEZBZrpZQZSVUvuuBnXQRLCtV7X8bg
         ZZ4KOZJXq+5DVabCb8RfaZAbyZ2rDql994hcjxS/y80Yx7hGqcI6ndH2fELvv1XBEjNB
         ilZlXjI4r7BIbakJSQH0r1qkjajFrNZj7i1I+0ljn4IFG0QlAQTfJKnJIyzj7X5ODWcQ
         A1OexPVorDnb3sQTjA0EIursIdpP9DOmb0cDL2JPo9mxqtxS6bIgmF5rdRre5y7uvy/5
         c8UJFy2F6fn9ZSpV5uhtL3Jb6ETlcW1g5glBDl+a7PzKxSZpcKFar8HmxAWY3OHKkVVb
         GI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TCGFPpcc8GufCoAaIzbMQIF88I5DF0YXGiEmPHcl16w=;
        b=GSVqaTEdzeb5SWPbGvez2TBJ2sDG265uKSv9YPAWzt/mQHfXUinbaJlBWo6DlkX++w
         SjW6YolFgj1H0RFOHbhQWnOxLrZZeHtvOTEGeZCxTtbNJMetm+Lvld8bS2tieJ7IUC9c
         wf2hti8Bi35jMJ8HD+f3FDRSdfC1XiBsYQnRa3kbEqophqLv89jEp9nwlVS9aFkJ0FWC
         BbJ1dmF10eAeqhsxdQ58tLurISbnN4C+L8kbop1axtWkK5xYgXVa8ikOTtov1b8h+L5P
         XalA1IkI+Xy0SV/VdDQzfVVBL+oxVjzI5+hL/7FtuH1EmhWOiQhXGzhbb7DiftqjUABM
         HAoQ==
X-Gm-Message-State: AOAM531rObwkKbtcbkhGo4PnWwuxlMtS44djX22U8sUJEovdDI9AgnYe
        RfcI2w/0htgvTldArWR3q/M1+00zLr9OKrJJNhQ=
X-Google-Smtp-Source: ABdhPJzLtX0Hhf20OaXbl/DXiqwtO3ZV5vigQPeSszLYUo6ifpW/WJ32PLZUbXE19ENilmGUJG1XV4Ox9zmrvUMeLMA=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr35847354ybg.347.1630457725551;
 Tue, 31 Aug 2021 17:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210830173424.1385796-1-memxor@gmail.com> <20210830173424.1385796-4-memxor@gmail.com>
In-Reply-To: <20210830173424.1385796-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 17:55:14 -0700
Message-ID: <CAEf4Bza11W+NPt1guXj87fy_xcsWLHeFLNK0OkzL9A+TfcYhog@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v1 3/8] libbpf: Support kernel module
 function calls
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:34 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>

-ENOCOMMITMESSAGE?

> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/bpf.c             |  3 ++
>  tools/lib/bpf/libbpf.c          | 71 +++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf_internal.h |  2 +
>  3 files changed, 73 insertions(+), 3 deletions(-)
>

[...]

> @@ -515,6 +521,13 @@ struct bpf_object {
>         void *priv;
>         bpf_object_clear_priv_t clear_priv;
>
> +       struct {
> +               struct hashmap *map;
> +               int *fds;
> +               size_t cap_cnt;
> +               __u32 n_fds;
> +       } kfunc_btf_fds;
> +
>         char path[];
>  };
>  #define obj_elf_valid(o)       ((o)->efile.elf)
> @@ -5327,6 +5340,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                         ext = &obj->externs[relo->sym_off];
>                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
>                         insn[0].imm = ext->ksym.kernel_btf_id;
> +                       insn[0].off = ext->ksym.offset;

Just a few lines above we use insn[1].imm =
ext->ksym.kernel_btf_obj_fd; for EXT_KSYM (for variables). Why are you
inventing a new form if we already have a pretty consistent pattern?

>                         break;
>                 case RELO_SUBPROG_ADDR:
>                         if (insn[0].src_reg != BPF_PSEUDO_FUNC) {

[...]
