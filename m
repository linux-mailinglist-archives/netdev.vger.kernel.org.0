Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239D935202A
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhDATwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbhDATws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:52:48 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D85C0613E6;
        Thu,  1 Apr 2021 12:52:48 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i144so2993910ybg.1;
        Thu, 01 Apr 2021 12:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6rLJO2qOQCmv43yggqJui07r0xIuScXCZxDCUdyUn7M=;
        b=TOEDxWCkX681s5an22WhRMuwcTT2+/fKX90dTWYF6s4lkKoJBtVuoM0O3YO/gxwTYT
         aA7xOAUULR5yDTeNy/8EUyyC3aAOF8nSxlgc6bDFVDbM0WEApdF9NwMJgP1wbu9laeFq
         /OdCz1d9g1tMIXx1kZ9NLHp0dVTXMFOlF68UDiTE+sj86Jqv/1ajU3V9Qk8ziFgz2VkV
         C0R4aJcLNe3tJRPlWz4XI8YVwi+3ux7qHsRAYsHdlRRxSYth2QKMalA+bGSsQZLDcFEy
         mHr7RK75q4o/vKlTgoLmTdjxCYSkVOAk1lmauhgSgwOqf4n5TSyguiJ6v4tZ/VOwFSZ+
         QJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6rLJO2qOQCmv43yggqJui07r0xIuScXCZxDCUdyUn7M=;
        b=AsMzXgL2BB7XPlpG1nQ+ch1TpaGKdIoqwOU92oEm7DXRp3yOqsePOKL2mjUudDHMHt
         A9+pxk9+JQ5ifClEWzw1RJSfrAmgt6UUud/ollmqWNd9iEXSDk2OIzDmla3lc/AlO5Ao
         hMY8Evd1zKyI5svEHGmkgiYOIXnNpHMhBtCUB704JdGbtO/lGRg8deogB82HSoSt7xhK
         aCIfBrFL3dF7VglVmN8pyhgiS3KrlwXfqJzuBedwRCKCUIq65z3kS6toFj5AWIoekT6F
         Qdzg2DQC2WFcWbcDZKs0tNdcbaYx9F+DKb+A1My//Dra8smBBgSBONRxf6fEhRaZCzCT
         Vslw==
X-Gm-Message-State: AOAM5306fFld6GOPvZhzPr2qrAOJzW5OcpRV7P+8xe8qZCw1q1aAv+2f
        OwGZjtV76RaBM55dkCgIxKbQO4U/zCanMhbGxK4=
X-Google-Smtp-Source: ABdhPJzC8WBOpKivYaPjYAir0511bvJqxJPjbgtuOH4SC8e7wYQj414ANxs4gwFfHwsRJB+YccNPeuHSmHZVV0V6U18=
X-Received: by 2002:a25:6d83:: with SMTP id i125mr13758065ybc.27.1617306767826;
 Thu, 01 Apr 2021 12:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
 <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99gXvpnCwkz4vniABV5OQ29BE2K2iJY0tB898Fd9_8h6Q@mail.gmail.com>
 <20210329190851.2vy4yfrbfgiypxuz@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzY+6TspHiTH5Y7w5itCeHv9qe4Hg8sB-yBJK6kYXYoonA@mail.gmail.com> <20210401195126.uohtumhvd6fxig5c@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210401195126.uohtumhvd6fxig5c@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 1 Apr 2021 12:52:37 -0700
Message-ID: <CAEf4BzamO1YDfiq0sGy1E+6dYDsy71Lz88B8M-6Uxj_2v9Jgwg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 12:51 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Mar 30, 2021 at 11:44:39PM -0700, Andrii Nakryiko wrote:
> > On Mon, Mar 29, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Mon, Mar 29, 2021 at 05:06:26PM +0100, Lorenz Bauer wrote:
> > > > On Mon, 29 Mar 2021 at 02:25, Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > > > >
> > > > > > > > # pahole --version
> > > > > > > > v1.17
> > > > > > >
> > > > > > > That is the most likely reason.
> > > > > > > In lib/Kconfig.debug
> > > > > > > we have pahole >= 1.19 requirement for BTF in modules.
> > > > > > > Though your config has CUBIC=y I suspect something odd goes on.
> > > > > > > Could you please try the latest pahole 1.20 ?
> > > > > >
> > > > > > Sure, I will give it a try tomorrow, I am not in control of the CI I ran.
> > > > > Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
> > > > > is not set?
> > > >
> > > > I hit the same problem on newer pahole:
> > > >
> > > > $ pahole --version
> > > > v1.20
> > > >
> > > > CONFIG_DYNAMIC_FTRACE=y resolves the issue.
> > > Thanks for checking.
> > >
> > > pahole only generates the btf_id for external function
> > > and ftrace-able function.  Some functions in the bpf_tcp_ca_kfunc_ids list
> > > are static (e.g. cubictcp_init), so it fails during resolve_btfids.
> > >
> > > I will post a patch to limit the bpf_tcp_ca_kfunc_ids list
> > > to CONFIG_DYNAMIC_FTRACE.  I will address the pahole
> > > generation in a followup and then remove this
> > > CONFIG_DYNAMIC_FTRACE limitation.
> >
> > We should still probably add CONFIG_DYNAMIC_FTRACE=y to selftests/bpf/config?
> I thought the tracing tests have been requiring this already.  Together with

Yeah, I didn't mean that your feature suddenly requires that, it was
always a requirement before, but we always forget to add it to config
and then some users are periodically tripped up by this.

> the new kfunc call, it may be good to make it explicit in selftests/bpf/config.
> I can post a diff.
