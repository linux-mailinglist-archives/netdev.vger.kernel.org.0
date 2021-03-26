Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D1834B011
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhCZUTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhCZUSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF87761A18;
        Fri, 26 Mar 2021 20:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616789929;
        bh=YeUAbMrfYLccfT1TYuQJEoCSYO9J3nb1QDCeP7Kj8fg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=h40wmvBjIvEqaCo9M3nMUHArljlVK1B7BFhAqSLB61Ic5AaSTodUqEre/DQjjx5kQ
         1CwcxQIaHfFvcg3T2hhuzvcz4pLziHEI4mWXekIUPd2LTUQviEi2U5eM/eo6FPSq+g
         r1sXvvlW5XrnNSaDAyxZD9rxIZ4/3+nyZGlXTPRXPuCIhMTHKHtzWoj543PdrwRy9m
         u0nemSp1DaQyA0txvKXV+an3sXagO4IYy95sqV2cxaTPJuP/9kmU3fY6mX2coH9AYN
         PP5Z8O5tsIeFni/3cBTP8l3lTTBbTrpE3CCs0M7j+zJ8ns/5Y38xnb9EQn+LKa8rtI
         HDv+hREv6xXsQ==
Received: by mail-lj1-f171.google.com with SMTP id a1so8832425ljp.2;
        Fri, 26 Mar 2021 13:18:48 -0700 (PDT)
X-Gm-Message-State: AOAM532IlfCZUrEkINZXQGnJ0T+KVWY6+arCV5S9pwuC1UZ4MSJGCtAn
        6q+So3StPyGThaNyxhBXYqfoWLDlrSjVZzFeFI4=
X-Google-Smtp-Source: ABdhPJyHW/TMpw7vCpfb3a3D5bXtj9kaHjI/akwGLbFYxpG0Yl9+BNlkH5wT/flKOFG/f2ilBdENgyncIjgpR6vdKPQ=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr10035208lji.270.1616789927107;
 Fri, 26 Mar 2021 13:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210326194348.623782-1-colin.king@canonical.com>
In-Reply-To: <20210326194348.623782-1-colin.king@canonical.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Mar 2021 13:18:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4K1RB-kz-Wu32eOFYE=ZwQr7Wr20zuEhhtzK_hr9YGUw@mail.gmail.com>
Message-ID: <CAPhsuW4K1RB-kz-Wu32eOFYE=ZwQr7Wr20zuEhhtzK_hr9YGUw@mail.gmail.com>
Subject: Re: [PATCH] bpf: remove redundant assignment of variable id
To:     Colin King <colin.king@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 12:45 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The variable id is being assigned a value that is never
> read, the assignment is redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Song Liu <songliubraving@fb.com>

For future patches, please prefix it as [PATCH bpf-next] for
[PATCH bpf], based on which tree the patch should apply to.

> ---
>  kernel/bpf/btf.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 369faeddf1df..b22fb29347c0 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -789,7 +789,6 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
>
>         while (btf_type_is_modifier(t) &&
>                BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
> -               id = t->type;
>                 t = btf_type_by_id(btf, t->type);
>         }
>
> --
> 2.30.2
>
