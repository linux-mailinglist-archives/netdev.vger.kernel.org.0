Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C15E3FD071
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbhIAAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhIAAtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:49:24 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D904C061575;
        Tue, 31 Aug 2021 17:48:28 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id v19so1877574ybv.9;
        Tue, 31 Aug 2021 17:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZJFgYd9GZvRFDg2nFgMQcm+f3UC5H2KabqPnVvzcu4g=;
        b=DILlh5qmo+qZeyrX1d1ci6wmTucg+7bZyK+8QGewFU21+2lKHzYOl3tzmHCe8PWgtA
         epNiurRHkaO0npHbaAyU8ZK6wKpr10NV/n7cxLO1Tsb71nd/g0z82VyvXE8wznty4Vji
         RwacjUzl32OnMiNZN+bwKsz+Nrvww9yhDrA2MXSyUizKPfVEe5DN/Hm736TbMBZhmeNo
         Y16skz/Ej9aerodXhBAR5eU/+hG72bNpjGNzNWMiw5n3MzvLyeBemD1KvJ9aKt1tnATm
         HI7V9uWiyJ730TieMW7kOq2e3WMlcVUjOZrrCYZv8J8+06OJv2evaq1dyP0/+VF4yiYI
         4mRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJFgYd9GZvRFDg2nFgMQcm+f3UC5H2KabqPnVvzcu4g=;
        b=SaFh/d08IeEjQskO2MdCHet9eX1iX5uyzePyPLXZ+LVLrGlvkdpkGk+KD08XIVANsz
         Xksyz4K0r5jrnVt2cTAZV3sVETeIpR52y712gngJUiZVVJw2HpH6kQeGCin5gKzjfFKe
         DWu8P5g8cO9pxe2G+RognsrYrAkuTU1c1cLcGqlVCDck1Erny5FjA1rOCPhFhVkVYKYG
         owBOTFvQuylFpAzw1xhgF28EKcJddOsqwe+ra0RGPsQs8sCvje7yiiZfi1BRud59VdQT
         A5brSTG+sXbLd16W+/JwuUzv8B55/ZEhSCNuWp6bKpeqzzra+CB4g/R7qqDvc+j2u5O2
         S+qw==
X-Gm-Message-State: AOAM531QDaesCgmUw00aVSdiDt9AAI3AWJrGW9MNf6T5Ep2iLFpgGtqT
        /F058S69syIfF1mBd4J8GZxBX90NPMEW0b9SEWstlqhr
X-Google-Smtp-Source: ABdhPJwnKIEBKvr5KJBTTNQvQ+SEmw4DG6n5hZgoH2V+LJOS3orKB4gHbCiLMrLqoQ4Qlc4nOJp7VIsRT2ZPwtL+IHs=
X-Received: by 2002:a25:1e03:: with SMTP id e3mr32616135ybe.459.1630457307499;
 Tue, 31 Aug 2021 17:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210830173424.1385796-1-memxor@gmail.com> <20210830173424.1385796-8-memxor@gmail.com>
In-Reply-To: <20210830173424.1385796-8-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 17:48:16 -0700
Message-ID: <CAEf4BzY+B12m7OGVpxMNp6tPOTcAGnjuf51Bxqn5HCdz635WVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v1 7/8] bpf: enable TCP congestion control
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

On Mon, Aug 30, 2021 at 10:34 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This commit moves BTF ID lookup into the newly added registration
> helper, in a way that the bbr, cubic, and dctcp implementation set up
> their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
> dependent on modules are looked up from the wrapper function.
>
> This lifts the restriction for them to be compiled as built in objects,
> and can be loaded as modules if required. Also modify link-vmlinux.sh to
> resolve_btfids in TCP congestion control modules if the config option is
> set, using the base BTF support added in the previous commit.
>
> See following commits for background on use of:
>
>  CONFIG_X86 ifdef:
>  569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)
>
>  CONFIG_DYNAMIC_FTRACE ifdef:
>  7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h       |  2 ++
>  kernel/bpf/btf.c          |  2 ++
>  net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
>  net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
>  net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
>  net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
>  scripts/Makefile.modfinal |  1 +
>  7 files changed, 85 insertions(+), 34 deletions(-)
>

[...]

> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index 5e9b8057fb24..0755d4b8b74a 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -58,6 +58,7 @@ quiet_cmd_btf_ko = BTF [M] $@
>        cmd_btf_ko =                                                     \
>         if [ -f vmlinux ]; then                                         \
>                 LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
> +               $(RESOLVE_BTFIDS) --no-fail -s vmlinux $@;              \

why is this --no-fail?


>         else                                                            \
>                 printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
>         fi;
> --
> 2.33.0
>
