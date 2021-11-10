Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9285D44CC58
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhKJWU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbhKJWUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:20:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BE0C061224;
        Wed, 10 Nov 2021 14:14:01 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id r5so4228299pls.1;
        Wed, 10 Nov 2021 14:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z+txdSr8V+WcbBPzi+kDYjDyg20CJ440QBded8RRNLQ=;
        b=HJFskguzBBvyRkt4v5DZ7VTCfblTfV5VZff9K8DdWvDU7apVbgI0Zx0q2EDwwpBwrN
         MELhQHvPgl+Q/ZbVLI0b7LxP18L3/L2MrMG7ZDgTYAyEfrNllReqgKzdHQ+WyfxEOKSA
         JJ1pt7PezcNZU01s52enWRjNjR1ODcLnBeESgGQ7kw6PzxpB8XxTstTwMppFcMdq0LjH
         q+B/in9BQmEjaMsZySAS5nluVWktNXL0jUIHIJMH55MNQPUQKoiwevDK1QrD8Z8TVCk9
         K2dxz7WeFh2BFm/AcrkRCn+4wdM5cZ02NVwRFoL72Z0loJz5DRwPfNh1sTHipFKlwavp
         S1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z+txdSr8V+WcbBPzi+kDYjDyg20CJ440QBded8RRNLQ=;
        b=UZwjFpeaOyinH4P4XXd2JeKwOHxjO8Po6cMURUT3gfU4jgSl0SwMv22cvAlNbNp+N7
         R1wQygikMvcKBo1Ct30l1Hr0w3j1j7ZiZrQRlP/2X6Q2cReagsGzfFdloJ4TD2FJfBYj
         dnuZYvSyStUG8rtTIe0Uf2zkHbn1+wTEb3BT4igHtnVhhH446CmrkIljEN+2GvBZZzpy
         lgv1o71aUyihCRgjJh3IQNHlsFzm0NHnHN3ckPU794f2c9ITCrddvDFElXdKQrOluIEr
         8KPvgQdNFo2v5gtT4sSrLii1um1YzsYRhGK9j9XaGSWGhy/LGNfvvTYY9feRROSLGKia
         JqMA==
X-Gm-Message-State: AOAM5323WtQuuDCoIAhjt3rwuDdyoaRuVgmW6Ct7H8GsFIZMTo8s3ra8
        rD/ZKIiEow9q0B5nE6DXclaqCtziLKcKo2nBuBU=
X-Google-Smtp-Source: ABdhPJzUgO0ZNWk9wrFgFvUhLUP/Nw6Xv0nMF3ZnME2euYoMecyfhANnRpOjYL93Zhcu8QmomeJkZgQwKsviuhUGiaM=
X-Received: by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr2761198plh.3.1636582441125; Wed, 10 Nov
 2021 14:14:01 -0800 (PST)
MIME-Version: 1.0
References: <20211110174442.619398-1-songliubraving@fb.com>
 <CAADnVQK5nHGnC_9+m0q__AdhSxuHtE5Uh98epw2JEdjOCP343Q@mail.gmail.com> <E3649A44-D11F-426A-A65D-ED40AA3B0214@fb.com>
In-Reply-To: <E3649A44-D11F-426A-A65D-ED40AA3B0214@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 10 Nov 2021 14:13:49 -0800
Message-ID: <CAADnVQJbqoAd85dHP03kY6geHU+GKg=S2afGT7dzQQyBLn-46A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com" 
        <syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 2:11 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 10, 2021, at 2:02 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Nov 10, 2021 at 9:47 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> -#ifdef CONFIG_DEBUG_INFO_BTF
> >> -BTF_ID_LIST_GLOBAL(btf_sock_ids)
> >> +BTF_ID_LIST_GLOBAL(btf_sock_ids, MAX_BTF_SOCK_TYPE)
> >> #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
> >> BTF_SOCK_TYPE_xxx
> >> #undef BTF_SOCK_TYPE
> >> -#else
> >> -u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
> >> -#endif
> >
> > If we're trying to future proof it I think it would be better
> > to combine it with MAX_BTF_SOCK_TYPE and BTF_SOCK_TYPE_xxx macro.
> > (or have another macro that is tracing specific).
> > That will help avoid cryptic btf_task_struct_ids[0|1|2]
> > references in the code.
>
> Yeah, this makes sense.
>
> I am taking time off for tomorrow and Friday, so I probably won't
> have time to implement this before 5.16-rc1. How about we ship
> this fix as-is, and improve it later?

It's not rc1 material. It's in bpf-next only. There is no rush, I think.
