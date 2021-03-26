Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35C034A9A6
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 15:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhCZOZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 10:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhCZOYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 10:24:47 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416E4C0613AA;
        Fri, 26 Mar 2021 07:24:47 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b14so7934241lfv.8;
        Fri, 26 Mar 2021 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQ6cDueETr7R6JsMSrZJLtQswKIsE5Z44q0mYxtA07E=;
        b=c0KQ+/G7knKwgFFKEJGZkHPCPChjWm5irh8qKkb+fqsbU2Uy7ubwscqo6K8f02RMmO
         Tq00A+6w6l97RswUB5r1hOstDxzUnkl6Ru6CypQ1RmiRuIo/eNgWyJ7FXULiZ94x5Vab
         vjGSFPrerHA8yOi9ZwvTeivz3Q+UWvGw16cDoRLdZAb/6dOZ5+PiAII2AmsGoCsga6aK
         0pJyzxMrV9G/DEzAzknlrRhiC7kzHwg8tsEAzl2LCFdDhqm1TJxYEhi4ryURrknN+jRp
         cLxWYfzcWOA23TlI/cMPYxHYJV7E0zgs851HNuuhZO5UQjtkIess3sbVWbEVys8gdf1Z
         cNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQ6cDueETr7R6JsMSrZJLtQswKIsE5Z44q0mYxtA07E=;
        b=lRxFavbr2uBgmbn8uvPEnAj7ROhjnWb2RyQ8X/vehhe6x/P1mnHha3aqWdI8ebrCcj
         3eQiy3hjPQhoqknmZUohHwuCmx3r9Umt5Tam92U5s38SKGslyWCUj7XAih/nLO+ToYLL
         K7E6lE7Re8ocDjZQ7lBLaliDqsLXtVURbICOUSpLwo31XuGPFm68yDdJpqUcAFHTTRI4
         0PKG9a4f0Wi48Bmm8G8tRwMTJk1P7nw+2gupUrxbVjT0yoAwjRmhh6j99y5wZRvxLNxN
         U4TrAOFRdpZMakD3zR+Ej4ZEfNlrDHwXq0gccegbnTrAehp58ZC01yrJxJ2ZHCcHyIDR
         EZ7Q==
X-Gm-Message-State: AOAM5313px9e5YKRa3upoYs5HMAacwiGpSTQohSRswtIqZccQpOTvjw8
        otIdOHKwQ9NcxCrRv/5G9/kUqrFr4M6ZCRmfHNE=
X-Google-Smtp-Source: ABdhPJwcgpqv/t3Un/FbFhFtnv9tetg9zdfhUs6xUd/qg+/tj9XMUh5G134bNYItwQGzjO8dwP1O1b3UZ7+KNVnt+98=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr8621766lfq.214.1616768685772;
 Fri, 26 Mar 2021 07:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210326124030.1138964-1-Jianlin.Lv@arm.com>
In-Reply-To: <20210326124030.1138964-1-Jianlin.Lv@arm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Mar 2021 07:24:33 -0700
Message-ID: <CAADnVQ+W79=L=jb0hcOa4E067_PnWbnWHdxqyw-9+Nz9wKkOCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: trace jit code when enable BPF_JIT_ALWAYS_ON
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrey Ignatov <rdna@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        iecedge@gmail.com, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 5:40 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> When CONFIG_BPF_JIT_ALWAYS_ON is enabled, the value of bpf_jit_enable in
> /proc/sys is limited to SYSCTL_ONE. This is not convenient for debugging.
> This patch modifies the value of extra2 (max) to 2 that support developers
> to emit traces on kernel log.
>
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---
>  net/core/sysctl_net_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index d84c8a1b280e..aa16883ac445 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -386,7 +386,7 @@ static struct ctl_table net_core_table[] = {
>                 .proc_handler   = proc_dointvec_minmax_bpf_enable,
>  # ifdef CONFIG_BPF_JIT_ALWAYS_ON
>                 .extra1         = SYSCTL_ONE,
> -               .extra2         = SYSCTL_ONE,
> +               .extra2         = &two,

"bpftool prog dump jited" is much better way to examine JITed dumps.
I'd rather remove bpf_jit_enable=2 altogether.
