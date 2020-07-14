Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8039F21E4DB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGNAxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgGNAxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:53:41 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2E4C061755;
        Mon, 13 Jul 2020 17:53:41 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so14146817qkc.6;
        Mon, 13 Jul 2020 17:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpaDsBvlz9opHaHnQGrx2N2C4SwE84lnQr92+oDq3LY=;
        b=rMiR71v/yR8fu0eB1iPdEzuhUbc3Mny0j9rhKZSyWfs+1MHiJRYvhF82OKFiwcI3X9
         XeiFgk1K/dR0TL1vVCF/lQSSqa/gD4mrnxOYM7tt+DvJ2oPoGd95uW8w15LKE8GzZOTn
         uJnZET35qb/G0NspQbaiwdvxGR7/QENEyDYKFWc5nkbymOswflogUc1UIV7n0pZFuspi
         A5ouCCNm08KU7a96OiZ/WsFZN9Szb1Teoup51io8Dt4X1WWmakOZN4IA2+3gFZ32JTVN
         /35A7tqKPg6tE0rU+Q8HBN4pXEmq040XQusOlSB/q1e9mKPGYVxJBMQwlkjhSrz+QdxU
         NvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpaDsBvlz9opHaHnQGrx2N2C4SwE84lnQr92+oDq3LY=;
        b=HOA2O+D8Uwl7X1bZaUOdlNFJVx6yGypyejlT4YX7JZJqCoppK3iZ8AjXxikmZzy5fN
         8kH+KPwibIQoXBB47C4pHS4M+FoXKAPj7ZUQijhgoe/VW2F+9pEIs1bffAbzYwpNqWSc
         PWgtJ/6ihTsrM5eYDQUlRDdlfbwXE96HUNm1Vp2+oNfLxAhb7XZhCh2+hnrI4RFSUc28
         gT6knMpNy0d/m4yg/nIOvvIJ/DL8fhoiL3KDyDOHsdoetNAd30oGm/9f5fun4KG59ett
         zBzLswDESEXl1+Jl6eZkLgNoyLXkpobtvVoYvni4JfE5dqLXyyqkegsGvIhKk5VEVXhA
         fLGw==
X-Gm-Message-State: AOAM530qsF1RfiZ9e+WjhoIgbSW+vv1JcQEhwYjBbzbcJKE7Q7jfg1UX
        yB3f890bY3YYO6oBsVXkRG1XSC4fEnXSJxc2Nwo=
X-Google-Smtp-Source: ABdhPJznFhGSinelKiS7+HI+X4/sqgLA5sTa9+gPEz/8nzGxBgAA+YLhuelXQUf40NcKOvz88GZRILG2qCFPv1ILg6w=
X-Received: by 2002:a37:7683:: with SMTP id r125mr2256135qkc.39.1594688020649;
 Mon, 13 Jul 2020 17:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200714003856.194768-1-yepeilin.cs@gmail.com>
In-Reply-To: <20200714003856.194768-1-yepeilin.cs@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jul 2020 17:53:28 -0700
Message-ID: <CAEf4BzZRGOsTiW3uFWd1aY6K5Yi+QBrTeC5FNOo6uVXviXuX4g@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH] bpf: Fix NULL pointer dereference
 in __btf_resolve_helper_id()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 5:43 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
> as NULL. This patch fixes the following syzbot bug:
>
>     https://syzkaller.appspot.com/bug?id=5edd146856fd513747c1992442732e5a0e9ba355
>
> Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 30721f2c2d10..3e981b183fa4 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4088,7 +4088,7 @@ static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
>         const char *tname, *sym;
>         u32 btf_id, i;
>
> -       if (IS_ERR(btf_vmlinux)) {
> +       if (IS_ERR_OR_NULL(btf_vmlinux)) {
>                 bpf_log(log, "btf_vmlinux is malformed\n");

Can you please split IS_ERR and NULL cases and emit different messages
to log? If the kernel is not built with btf_vmlinux, saying that it's
"malformed" will confuse people. Thanks.

>                 return -EINVAL;
>         }
> --
> 2.25.1
>
