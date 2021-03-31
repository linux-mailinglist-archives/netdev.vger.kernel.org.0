Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A083134F8F7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhCaGpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhCaGov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 02:44:51 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6051FC061574;
        Tue, 30 Mar 2021 23:44:51 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id l15so20138887ybm.0;
        Tue, 30 Mar 2021 23:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w+2t2Nye8/SWHewNQ0PONbKMAheaX+6xvIxOoDicxJY=;
        b=EHXOecWLhM3zqNL8RZ2gQLCoKS4neY+nYRBnBU5aVMtLaCGrKBOmRkfNFzY6pDhgme
         D5GE20FGAPqodO7fhYq0if3lVVv53iDPKpeQHnNvIDDg/cqMVF1924dxfvD5ldNG3sfo
         wvCT2jaJpYeNsfouhTtwgjd+j5A7zT2cDDbydxcRRYESwa5azP+qH+URhJ2q5ftQ32Hs
         QE0MEQc5p7wo51sCNxaRXh01xPSr5GuyrScaL4ZJO7NGq+HGVQN4qv9rYxupXnUOBC+I
         A26VOI7+6gz8ebxHU2lR6P6iaBSyJMXdeHP03McYI0cKNXsB4nsBHrOis+DjhOxwRBnf
         XYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w+2t2Nye8/SWHewNQ0PONbKMAheaX+6xvIxOoDicxJY=;
        b=nOo1HpgiK8+oJZ29IOW/G+z2r5LIG0cP++GaH18kdOx4C8wDtPbnfVKgrwTTaQkZu3
         XzqDakPpPGMZY5DblTp2YS6Ame3tdY2NBQ/OO27tOwKmNim9KslVf3wGvJAELN8jgtqk
         Se21el3VO8+l9F+lYpBGDKSBYK/U7xOBPQX0lGNLQkkpDbsC1GByH5iIzILmLoS+b/O3
         KcM3KOWVEvFI7mc7PFQK+Rc2LMEJ7kZ1Jid3lErI9k3LwuwOyhnzYAao0BJiUToAJAjj
         DCAHvCiwh/kn6S18oyIekOQlfl3QN1m9E00oeNYuZGi+jwV07nHbvfA4DBx6/JPPHdiZ
         ZV5Q==
X-Gm-Message-State: AOAM532RpoBJPey2LA/oEB6oYknCiEXGABhrnQwJhj538X3HhOWi+yAm
        BhC+M54xAMiLYXUR09UcGTVMNzt/Od2PM+hqohXg5/Iy
X-Google-Smtp-Source: ABdhPJxyC4hA4TMwpBV8p1/kjAVmemLM/MkqRLq3JXI8X6+5r5LdMAlXHyTNQVre9evpuf/ZDMvr2TGRbyFQIao/4DQ=
X-Received: by 2002:a25:becd:: with SMTP id k13mr2548836ybm.459.1617173090668;
 Tue, 30 Mar 2021 23:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
 <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99gXvpnCwkz4vniABV5OQ29BE2K2iJY0tB898Fd9_8h6Q@mail.gmail.com> <20210329190851.2vy4yfrbfgiypxuz@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210329190851.2vy4yfrbfgiypxuz@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Mar 2021 23:44:39 -0700
Message-ID: <CAEf4BzY+6TspHiTH5Y7w5itCeHv9qe4Hg8sB-yBJK6kYXYoonA@mail.gmail.com>
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

On Mon, Mar 29, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Mar 29, 2021 at 05:06:26PM +0100, Lorenz Bauer wrote:
> > On Mon, 29 Mar 2021 at 02:25, Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > > > >
> > > > > > # pahole --version
> > > > > > v1.17
> > > > >
> > > > > That is the most likely reason.
> > > > > In lib/Kconfig.debug
> > > > > we have pahole >= 1.19 requirement for BTF in modules.
> > > > > Though your config has CUBIC=y I suspect something odd goes on.
> > > > > Could you please try the latest pahole 1.20 ?
> > > >
> > > > Sure, I will give it a try tomorrow, I am not in control of the CI I ran.
> > > Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
> > > is not set?
> >
> > I hit the same problem on newer pahole:
> >
> > $ pahole --version
> > v1.20
> >
> > CONFIG_DYNAMIC_FTRACE=y resolves the issue.
> Thanks for checking.
>
> pahole only generates the btf_id for external function
> and ftrace-able function.  Some functions in the bpf_tcp_ca_kfunc_ids list
> are static (e.g. cubictcp_init), so it fails during resolve_btfids.
>
> I will post a patch to limit the bpf_tcp_ca_kfunc_ids list
> to CONFIG_DYNAMIC_FTRACE.  I will address the pahole
> generation in a followup and then remove this
> CONFIG_DYNAMIC_FTRACE limitation.

We should still probably add CONFIG_DYNAMIC_FTRACE=y to selftests/bpf/config?
