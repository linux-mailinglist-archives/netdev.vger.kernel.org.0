Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA24645CA
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhLAEUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLAEUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:20:54 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49376C061574;
        Tue, 30 Nov 2021 20:17:34 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v64so59397622ybi.5;
        Tue, 30 Nov 2021 20:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BffJ4sWQgdBaiuYpbIS7hR41JOI6EP0ZzM2HFXgplcQ=;
        b=fLbVwBEnBndOyzpou0qLz9v/pSu31J8kq+XFRrd32O/u/h48CNV5WjXtV02iwumesA
         zyNOVTdlvInWdpegfFwBq61ad0WEscWG8GrPVB91j54caGZrfWvi/F49I0Zv/sFEiLAN
         aCwNeVoacB0lyjF3j8/W0iBzKRnnNtwiqK56R7nqLTdoO9HhnMA0oZzFbUHKOIlIReLz
         oFZ6+kuemKcGHrxipfkrPYSf89scjyNEV0lNZMxXL660xyPKbpGpwPtTtrv9CJ6fPQ/u
         lbK/JdcXYkVKKFxOfxYdWzeowPbUA/YGEjSXAiQL+j6Zrc4EWKlAVM8xEeHMnivJC/tp
         DjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BffJ4sWQgdBaiuYpbIS7hR41JOI6EP0ZzM2HFXgplcQ=;
        b=brpPPxN9iFHSwKlX7ReHCj0fpNvKwOhCstCQU7BV6fsZfNwQG6Uxt9V/nGuWxfszZw
         dH1e0CCxnGavwZmXhzn14hBbHs4Z2LdphX5IRbFl7AEIdlEU7gDbzVbwKsS5cU1G/07u
         vI0ejdsm++ela5EUdOv+BedHeU46puTaONcOI39+rm2IyKOzzI1Y7+D7cnGyzEE1XdEa
         3Xfwwd0a3Og0PmQuIYIJk5jnJTb0Yy8zuyVQdqRwRkyBHC5cCEamLV5i3X82dlQzc1Mj
         IjRrKLrXVQClGNA7weD81lZZ05t4z+44Yj9f4BOjo2ScL7GaJgPSBXCPILyJys/A15C/
         pNpA==
X-Gm-Message-State: AOAM531DYUpNCxZIctOl1x+e/wa/hjqe6NWYc892zOCxGvREAO44VlpQ
        hUw0ksOeACuoFBaz3ZNO4EedK6o8DzHvNjt+n5dss+IGiKRTrw==
X-Google-Smtp-Source: ABdhPJyc6lmjzO8grzlbNLzgClqcVWxkdSl+vfkqdlC812ycU+qm0WdweURPP4TGSCNi/NmkZFzaTj2mskjm//fzNGY=
X-Received: by 2002:a25:e617:: with SMTP id d23mr4160796ybh.555.1638332253447;
 Tue, 30 Nov 2021 20:17:33 -0800 (PST)
MIME-Version: 1.0
References: <20211201035450.31083-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20211201035450.31083-1-zhoufeng.zf@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 20:17:22 -0800
Message-ID: <CAEf4BzZ5Q9QkRGsT2kW+3AW4s7=qixJYO84heeu64TLG9DP3+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Let any two INT/UNION compatible if
 their names and sizes match
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 7:55 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> commit:67c0496e87d193b8356d2af49ab95e8a1b954b3c(kernfs: convert
> kernfs_node->id from union kernfs_node_id to u64).
>
> The bpf program compiles on the kernel version after this commit and
> then tries to run on the kernel before this commit, libbpf will report
> an error. The reverse is also same.
>
> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: kind <byte_off> (0),
> spec is [342] struct kernfs_node.id (0:9 @ offset 104)
> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: non-matching candidate
> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: non-matching candidate
> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: no matching targets
> found
>
> The type before this commit:
>         union kernfs_node_id    id;
>         union kernfs_node_id {
>                 struct {
>                         u32             ino;
>                         u32             generation;
>                 };
>                 u64                     id;
>         };
>
> The type after this commit:
>         u64 id;
>
> We can find that the variable name and size have not changed except for
> the type change.
> So I added some judgment to let any two INT/UNION are compatible, if
> their names and sizes match.
>
> Reported-by: Chengming Zhou <zhouchengming@bytedance.com>
> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---

This should be handled by application, not by hacking libbpf's CO-RE
relocation logic. See [0] for how this should be done with existing
BPF CO-RE mechanisms.

  [0] https://nakryiko.com/posts/bpf-core-reference-guide/#handling-incompatible-field-and-type-changes

>  tools/lib/bpf/relo_core.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
> index b5b8956a1be8..ff7f4e97bafb 100644
> --- a/tools/lib/bpf/relo_core.c
> +++ b/tools/lib/bpf/relo_core.c
> @@ -294,6 +294,7 @@ static int bpf_core_parse_spec(const struct btf *btf,
>   *   - any two FLOATs are always compatible;
>   *   - for ARRAY, dimensionality is ignored, element types are checked for
>   *     compatibility recursively;
> + *   - any two INT/UNION are compatible, if their names and sizes match;
>   *   - everything else shouldn't be ever a target of relocation.
>   * These rules are not set in stone and probably will be adjusted as we get
>   * more experience with using BPF CO-RE relocations.
> @@ -313,8 +314,14 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
>
>         if (btf_is_composite(local_type) && btf_is_composite(targ_type))
>                 return 1;
> -       if (btf_kind(local_type) != btf_kind(targ_type))
> -               return 0;
> +       if (btf_kind(local_type) != btf_kind(targ_type)) {
> +               if (local_type->size == targ_type->size &&
> +                   (btf_is_union(local_type) || btf_is_union(targ_type)) &&
> +                   (btf_is_int(local_type) || btf_is_int(targ_type)))
> +                       return 1;
> +               else
> +                       return 0;
> +       }
>
>         switch (btf_kind(local_type)) {
>         case BTF_KIND_PTR:
> @@ -384,11 +391,17 @@ static int bpf_core_match_member(const struct btf *local_btf,
>         targ_type = skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
>         if (!targ_type)
>                 return -EINVAL;
> -       if (!btf_is_composite(targ_type))
> -               return 0;
>
>         local_id = local_acc->type_id;
>         local_type = btf__type_by_id(local_btf, local_id);
> +       if (!btf_is_composite(targ_type)) {
> +               if (local_type->size == targ_type->size &&
> +                   btf_is_union(local_type) && btf_is_int(targ_type))
> +                       return 1;
> +               else
> +                       return 0;
> +       }
> +
>         local_member = btf_members(local_type) + local_acc->idx;
>         local_name = btf__name_by_offset(local_btf, local_member->name_off);
>
> --
> 2.11.0
>
