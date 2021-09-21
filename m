Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689FF413D70
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhIUWUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbhIUWUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:20:36 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6100EC061574;
        Tue, 21 Sep 2021 15:19:07 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id c7so2886721qka.2;
        Tue, 21 Sep 2021 15:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJmCT0htDTlKya6prkkQKgoShwDE4EwGOXjvwMnMx08=;
        b=Bm+vMCe7oGujh6dPA6EVXbsh4absfPb+OGDlJrbod1Fu+vUQVxKLTW/jIoOwqI4Hga
         WXCgP9ae3DdSnVTFHEtKpmtIOaNASSL/qUU1nj1J/9XVIs+0UxMubFwFmi2q8oP3jHun
         aBzyGKkeAgTN9iz2zV1LZ38UD58kREzccakydJfgh2GAjfsfc26c+i2ZkJXIObtJi7Mi
         36M8ruLXvVqlXPOuy5vblQt1b/dswuVqP+1qo+4C17aq6ht3o4x1ED0IArp8yscvyoVT
         1Olos3mZsNILxazXe2xACRJ1uY8zsq6icAarZmJA4XsPzZrjxZxfs1+fkrtzCw2Aa9kv
         1tDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJmCT0htDTlKya6prkkQKgoShwDE4EwGOXjvwMnMx08=;
        b=eJVwnrb17i6a2l2lEelAKR1NR+EQ4/+mfDse5QPehl83uxAMqk0/EcJPjJhulsORgu
         GnVAnUM68NZuDoPEUBLqGqWbYUE+qZJiJLKX7GZv9unTUm4JT09peSttWbCrSBnGeuDV
         uc3hBk5WrAuupxrHwyZuEps5DXoBmCbG09XE1DuzsXZPn+tEjBegsW6yym1LxpwNCFmP
         Axu6fMu4JUUUsR6Ht+alX9uOsYrmCm08uSI9+Q8Cg9MYGULby1Le3414DqCzQC4z0+xh
         hsS9P+yQ8LFFF54P3dOuTcoPOM1R0G4a80Jk9jiWCl6e60OjwcIxx3AXOOQX/0pnyvLS
         nvWQ==
X-Gm-Message-State: AOAM531Z1Exu4HaGy8nu1X/AQ6aA2dR+0mD3oLqtbAMbLKEKVGDfR4VC
        RYdhFS7XGfLOB+ruSyToTUfZK57le6+LelD98i8=
X-Google-Smtp-Source: ABdhPJwmmUrnzsv6DPR9w/J6HOGUugglXwK3mzaVWoViNeInM3xpnGJWF6/Sx4BQ832CBZR9rltHgf3g4bCx/PdqStY=
X-Received: by 2002:a25:fc5:: with SMTP id 188mr39601373ybp.51.1632262746526;
 Tue, 21 Sep 2021 15:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-6-memxor@gmail.com>
In-Reply-To: <20210920141526.3940002-6-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 15:18:55 -0700
Message-ID: <CAEf4BzY7EVKv66CZ9KfefDopWDPL7xQCgLxq=oDS3eLKusAHWA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/11] bpf: Enable TCP congestion control
 kfunc from modules
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

On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This commit moves BTF ID lookup into the newly added registration
> helper, in a way that the bbr, cubic, and dctcp implementation set up
> their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
> dependent on modules are looked up from the wrapper function.
>
> This lifts the restriction for them to be compiled as built in objects,
> and can be loaded as modules if required. Also modify Makefile.modfinal
> to resolve_btfids in TCP congestion control modules if the config option
> is set, using the base BTF support added in the previous commit.
>
> See following commits for background on use of:
>
>  CONFIG_X86 ifdef:
>  569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)
>
>  CONFIG_DYNAMIC_FTRACE ifdef:
>  7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)
>
> [ resolve_btfids uses --no-fail because some crypto kernel modules
>   under arch/x86/crypto generated from ASM do not have the .BTF sections ]
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h       |  4 ++++
>  kernel/bpf/btf.c          |  3 +++
>  net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
>  net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
>  net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
>  net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
>  scripts/Makefile.modfinal |  1 +
>  7 files changed, 88 insertions(+), 34 deletions(-)
>

[...]

> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index ff805777431c..b4f83533eda6 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -41,6 +41,7 @@ quiet_cmd_btf_ko = BTF [M] $@
>        cmd_btf_ko =                                                     \
>         if [ -f vmlinux ]; then                                         \
>                 LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
> +               $(RESOLVE_BTFIDS) --no-fail -s vmlinux $@;              \

I think I've asked that before, but I don't remember this being
answered. Why is this --no-fail?

>         else                                                            \
>                 printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
>         fi;
> --
> 2.33.0
>
