Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E046D775
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhLHP5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbhLHP5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:57:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DE9C061A72;
        Wed,  8 Dec 2021 07:54:01 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so9774277eda.11;
        Wed, 08 Dec 2021 07:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iuVlLOimjUDYe52DFCRXFDhm8yvjQ5B0hyH2staIQaA=;
        b=VCRuCkYplEh5TlfUaN+OY8wsufmwjzgQHxxMEXuWiZhe7N0DSuq/A9Bs63gxyonBO9
         eKjYMO1q2NGlA4LXPqQQlEsxPd9XB9DXHWqF6spbmtqJbGp9YXRlHp6sQ97tf0iFmodG
         9uokRvhrDosHJlZek64TJ8XDZ3tjDp8SCPEl+YPRTymevgxfaKSDPoYSI4G4HfANmSSf
         INxEpfKIAbOF9piVbaJQ/XLnaQmQ9v112YmrfumCEuG44Uy0213F/1hXyxxb0tfZONQ9
         jqv6DuGSDnUMgazFSa4WRMJljFqcQ1SaVysGM6Slx87I4iUAjloPOhm3OUVQWuEIo9yA
         /aag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iuVlLOimjUDYe52DFCRXFDhm8yvjQ5B0hyH2staIQaA=;
        b=X7e2uYOXLoOSS4HuXaESNnAwQ2OKE8ShqSavLV5Uv+0vkxQlAtKOg0siW1oJThkHKo
         izOu9Vv2wXclo6x8mSxuYLMMK1EF9BQbMUKNDCaRm0PZVqBleQwZSJyRB2gelsn7INTG
         4zMoHvGJZhozQLirqTSLvsxIwmVuS8Sx/J8D/9U0+7H1C2F1C0Cj1Z/ljKytcbyHT5Qc
         whUaRqWDOdLt8nF/8Xv3mL266+YtAdmRV96bv8E3wFfNISiWeM1V+zxOf3zVvNdSAM12
         eRs7WWOZgDzZsjLCoXm8Kh7hhPcOBMjaRhqYdizHqsS15PJedyrZZhpEGAjAMQiFCDir
         ZhbQ==
X-Gm-Message-State: AOAM533H7ZofCTiHmQ5HxsAz+8obfGHEnubus2zeoEUvvloGznhfFLq7
        NWmzni7mqzludDQro6IPAZ4KUCq5QrZO/mUsrxE=
X-Google-Smtp-Source: ABdhPJzeMpa8KjL88qDlFeKIlxkmly/y0k5kIgIkI4OBoza4mev2afueIns08liQLw3kilIWm+6m8lp8u1E1ZENixJQ=
X-Received: by 2002:a17:906:c155:: with SMTP id dp21mr8377352ejc.450.1638978839532;
 Wed, 08 Dec 2021 07:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com> <20211208154145.647078-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211208154145.647078-1-alexandr.lobakin@intel.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 8 Dec 2021 23:53:23 +0800
Message-ID: <CAMDZJNV2s1jjPB6uw262H9_TRCbNK732Q=RfA3aP7k3onMLjmg@mail.gmail.com>
Subject: Re: [net v5 0/3] fix bpf_redirect to ifb netdev
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 11:42 PM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Date: Wed,  8 Dec 2021 22:54:56 +0800
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patchset try to fix bpf_redirect to ifb netdev.
> > Prevent packets loopback and perfromance drop, add check
> > in sch egress.
>
> Please provide a changelog in the cover letter. With the links to
> your previous versions ideally.
> Otherwise it becomes difficult to understand what are the changes
> between them.
Hi Alexander
This version of patchset, 2/3 only updates the commit message. because the
example in the commit message is not a usual case.
There are no  comments, so I sent them again.
I will provide a changelog in the next version or resend this version
again.  Thanks.

> >
> > Tonghao Zhang (3):
> >   net: core: set skb useful vars in __bpf_tx_skb
> >   net: sched: add check tc_skip_classify in sch egress
> >   selftests: bpf: add bpf_redirect to ifb
> >
> >  net/core/dev.c                                |  3 +
> >  net/core/filter.c                             | 12 ++-
> >  tools/testing/selftests/bpf/Makefile          |  1 +
> >  .../bpf/progs/test_bpf_redirect_ifb.c         | 13 ++++
> >  .../selftests/bpf/test_bpf_redirect_ifb.sh    | 73 +++++++++++++++++++
> >  5 files changed, 101 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
> >  create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh
> >
> > --
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Andrii Nakryiko <andrii@kernel.org>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: KP Singh <kpsingh@kernel.org>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Antoine Tenart <atenart@kernel.org>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Wei Wang <weiwan@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > --
> > 2.27.0
>
> Al



-- 
Best regards, Tonghao
