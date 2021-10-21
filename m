Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91316436AE9
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhJUSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhJUSww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 14:52:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552F9C061764;
        Thu, 21 Oct 2021 11:50:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e10so1044397plh.8;
        Thu, 21 Oct 2021 11:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKYdNAdb6PyaWMwkCssp4dF025r/v851J5DQkxIhrbA=;
        b=nhHAyQRvJh79B+VtyGgQGead16iFB8n01zbePhbzb3MorftmOF7OHiE0Dm7rdOcAVN
         TjItVO8v37/8aZxP5hC0CyInogrOwohKkrjxyGnxJoEsgvgmC0E2ZIzAeGQnS3ptDWXX
         t+fdxLpv9bP7tCw55uYege/FgDmBh00JNwfD99n3EebYCQiTyX3l1dOqGR6M1OSXA7Wt
         1md8yIc5paPVfdtVzFLHKb4DKBmToSEZz3c5CUDb6rqHeTBl/TBh1/9yBkd4TC7f0aO9
         4GxstdDut97L7wb2qDgH/YHi/Sq5arXnv7cdH145BZOR/dPiy8YY2/ggsvu8kREY1Np2
         lu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKYdNAdb6PyaWMwkCssp4dF025r/v851J5DQkxIhrbA=;
        b=xPPgsnGAIVc2xF53OPoe23QNBVN+rQze6uzXujHXo/FcrefKwFiiGlhdNnK3fR3Tj3
         QSNbGn6iuNxFssuLz+we+5Qhpd/jejOC481QHBlgNh00XFariQIYHRaIhJAvz6Z5BXjA
         svmwp6NwuJn+ogbsPWptxLtkfZx0Ft7bI40IzEkAEWJ4BY/pXLE6HxOqTS0BKShr2Bff
         z/JH6egonGXXf5uf4CBUJM33E1zHvAJCyCccBUWAV6mce1F/IXqT6Gca5HzVGAE4vybb
         PEvkAQvHmbLRmu0Hlnje5dqiyocS0c4Zj5Nsl5ZcaIZ+byW/3EAxDvsxhPvdLCWWG+kC
         PyHw==
X-Gm-Message-State: AOAM532OtoGBkXWrbUbVDH8t4V/qZ8uA//iOPEQMsAYEjI3aMpIGlgRT
        YPU1n/RlYgyfpHm11lt0G75vsh3HJSymYC5OWe8=
X-Google-Smtp-Source: ABdhPJytOCl5Z672wrEXwbja9bEGDv6Iv/X+TvYoHoeYsOR2tXlcUPsfaA84k+duuaApUa3wxszGFhyQC1/WQqbS2lk=
X-Received: by 2002:a17:902:ea09:b0:13f:ac2:c5ae with SMTP id
 s9-20020a170902ea0900b0013f0ac2c5aemr6802426plg.3.1634842235777; Thu, 21 Oct
 2021 11:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211019144655.3483197-1-maximmi@nvidia.com> <20211019144655.3483197-11-maximmi@nvidia.com>
 <20211021010605.osyvspqie63asgn4@ast-mbp.dhcp.thefacebook.com> <055556e9-8028-a399-a099-f141a63cfbb5@nvidia.com>
In-Reply-To: <055556e9-8028-a399-a099-f141a63cfbb5@nvidia.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Oct 2021 11:50:24 -0700
Message-ID: <CAADnVQLD00wz8jivthiZMz5=ZhvpfMKqQJF7WwswL5JaVBVf-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] bpf: Add sample for raw syncookie helpers
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 10:31 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2021-10-21 04:06, Alexei Starovoitov wrote:
> > On Tue, Oct 19, 2021 at 05:46:55PM +0300, Maxim Mikityanskiy wrote:
> >> This commit adds a sample for the new BPF helpers: bpf_ct_lookup_tcp,
> >> bpf_tcp_raw_gen_syncookie and bpf_tcp_raw_check_syncookie.
> >>
> >> samples/bpf/syncookie_kern.c is a BPF program that generates SYN cookies
> >> on allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
> >> iptables module.
> >>
> >> samples/bpf/syncookie_user.c is a userspace control application that
> >> allows to configure the following options in runtime: list of allowed
> >> ports, MSS, window scale, TTL.
> >>
> >> samples/bpf/syncookie_test.sh is a script that demonstrates the setup of
> >> synproxy with XDP acceleration.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> >> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> >> ---
> >>   samples/bpf/.gitignore        |   1 +
> >>   samples/bpf/Makefile          |   3 +
> >>   samples/bpf/syncookie_kern.c  | 591 ++++++++++++++++++++++++++++++++++
> >>   samples/bpf/syncookie_test.sh |  55 ++++
> >>   samples/bpf/syncookie_user.c  | 388 ++++++++++++++++++++++
> >>   5 files changed, 1038 insertions(+)
> >>   create mode 100644 samples/bpf/syncookie_kern.c
> >>   create mode 100755 samples/bpf/syncookie_test.sh
> >>   create mode 100644 samples/bpf/syncookie_user.c
> >
> > Tests should be in selftests/bpf.
> > Samples are for samples only.
>
> It's not a test, please don't be confused by the name of
> syncookie_test.sh - it's more like a demo script.
>
> syncookie_user.c and syncookie_kern.c are 100% a sample, they show how
> to use the new helpers and are themselves a more or less
> feature-complete solution to protect from SYN flood. syncookie_test.sh
> should probably be named syncookie_demo.sh, it demonstrates how to bring
> pieces together.
>
> These files aren't aimed to be a unit test for the new helpers, their
> purpose is to show the usage.

Please convert it to a selftest.
Sooner or later we will convert all samples/bpf into tests and delete that dir.
