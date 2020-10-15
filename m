Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF53128F9CC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392006AbgJOT5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbgJOT5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:57:46 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA359C061755;
        Thu, 15 Oct 2020 12:57:45 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a5so63320ljj.11;
        Thu, 15 Oct 2020 12:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKudZxWK9EEotNrmtlMDNbg20bqbty8lC8eoQ/FpCCo=;
        b=qWK07KOB7pQo3ovYpeX7oyC2H5e8qflRYEJYQ/wxaiCGbDmv/3ZWZ/wGvaMo/Pkf5j
         vBxPjfZbDczcZy/qmQBJTTHpZMSReDkWfcgSNZovdia+UsZFZXGsGnCsbSc5fhs7ZvRe
         qnch+YfJc9JhzwxZAXRvShLExOp/V933weVWpRPNLIvgPfl7BUJPGZXOH4BLewGHuvzu
         nsr4KtC6WG66agKCCx2rcR+R+opoOJSdvf1W98bgizJQ6SiYvBmIdooJf9nh45RsKK5u
         qF635hh+WPUDD4SZ94wp8/El1nDEcXy4YQ4B4cKh3+Fu0YXIrqV0yNHdL+1sWn/zVNSp
         r0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKudZxWK9EEotNrmtlMDNbg20bqbty8lC8eoQ/FpCCo=;
        b=daG7m9lR1RLXnA2RvPl0xzlvQnco0bsm4qgDSNfXZxtbsnkW9f3F7qVBr5ccSVG/AF
         WFm/WGTJvPdYNHOprHhQ72IfwHFRk9gLBSXOSM8GU0e+B3xC5pl5DeB3Wwb+3HV6A4lu
         FzY4segEOh+x9VhctlPuUCt04xGGSrWyQqsD7piOVDsIEdIgQgvBF3yXghW86IrEH86N
         EIH1zFdbo39j0UBSY5xWB8+YuOW6g5Tyu8KsxHdmWxqwrti4IoEilKLAHXcDKgAUTAXP
         gS6JeJqnEd3z5XUdC4snntePl/m+ve6gpwcNN/GfEPj4PCFPYdguhTwbsUYi1wie1qZH
         jt3Q==
X-Gm-Message-State: AOAM530Ih+GQwP/ln288sg5apXelSqvjsdZvrCV6LIsZQPyqi1H8mZVJ
        q6/X0mub/Dw2jrw7CSiIioMRUIJIvRTEYtPrAJE=
X-Google-Smtp-Source: ABdhPJwvg4HGucuypRt7n+8tHJ22sh4O+qz/n8yyT2zmUYCciy9BT3zMWMDlM7sMO5oXfZOCTb0VpCYiCWKnn1uFs2E=
X-Received: by 2002:a2e:7014:: with SMTP id l20mr143714ljc.91.1602791864323;
 Thu, 15 Oct 2020 12:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201014091749.25488-1-yuehaibing@huawei.com> <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKJ=iDMiJpELmuATsdf2vxGJ=Y9r+vjJG6m4BDRNPmP3g@mail.gmail.com>
 <20201015115643.3a4d4820@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQLVvd_2zJTQJ7m=322H7M7NdTFfFE7f800XA=9HXVY28Q@mail.gmail.com> <20201015122624.0ca7b58c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015122624.0ca7b58c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Oct 2020 12:57:32 -0700
Message-ID: <CAADnVQLiYfi3DvT=S_jgb+X=qD4GC1WJynWmh8988scUQJozWA@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 12:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 15 Oct 2020 12:03:14 -0700 Alexei Starovoitov wrote:
> > On Thu, Oct 15, 2020 at 11:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > How so? It's using in-tree headers instead of system ones.
> > > Many samples seem to be doing the same thing.
> >
> > There is no such thing as "usr/include" in the kernel build and source trees.
>
> Hm. I thought bpfilter somehow depends on make headers. But it doesn't
> seem to. Reverting now.

Thanks!
Right. To explain it a bit further for the author of the patch:
Some samples makefiles use this -I usr/include pattern.
That's different. This local "usr/include" is a result of 'make
headers_install'.
For samples and such it's ok to depend on that, but bpfilter is
the part of the kernel build.
It cannot depend on the 'make headers_install' step,
so the fix has to be different.

> > > > Also please don't take bpf patches.
> > >
> > > You had it marked it as netdev in your patchwork :/
> >
> > It was delegated automatically by the patchwork system.
> > I didn't have time to reassign, but you should have known better
> > when you saw 'bpfilter' in the subject.
>
> The previous committers for bpfilter are almost all Dave, so I checked
> your patchwork to make sure and it was netdev...

It was my fault. I was sloppy in the past and didn't pay enough attention
to bpfilter and it started to bitrot because Dave was applying patches
with his normal SLAs while I was silent.
