Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0362A9EC4
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgKFU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbgKFU6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:58:09 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE89CC0613CF;
        Fri,  6 Nov 2020 12:58:08 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id c129so2296519yba.8;
        Fri, 06 Nov 2020 12:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfgNiqc7FPmeRo9u5EBrE/Hi/TlplGpHLKs32RAKO9A=;
        b=bepPv6HgX29aP/hxS6S+e5bYm5n7fZwl6jNHkmbVO0WKZ9h73tYy0/5p7JPW4wVy6c
         JYND6sCJ4bh2Nj/f2aS0wD3MLdEDP+lsS03iCru6gZPzcLlGJcXPPgNvNsb/celt3idk
         5CRhfi2Nn8uTaBCd0beMCqv0+TFLQ8Z2C6N8sf5hJupJc0Itv96hoDkajgYlZtAmtp3v
         FR/u3RQiw0R1Gcny6k+E0hek9ttpTiHFJht7fRef5C3b8Kld70E2Egp6cWzE7MRRV7WL
         QRawtynLvbFADOficETyZMsOsx+3J2aYmZ0TpBCEF3n3Lh3lJP+rGyBSCvwSXVoh5Ebj
         8kCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DfgNiqc7FPmeRo9u5EBrE/Hi/TlplGpHLKs32RAKO9A=;
        b=kkxDbzMcJOux4Y3qlV2pOSbAdnCc8rfRHiUsmZkUdvdXnYBKaiAJQTarLUb+6iHLSi
         XBA7WVdfDCzNj7N0r3MbTejexgUfNsEbTDwtZUBJAe78rLtetJfdZ1fyn2mpbJOHBDwS
         JB0vmJWlZqolL7V7mf1St85m3sPBeuA0Lh4pdfpae6EI4qi20ShNQuSFB0/MMFtmb30v
         h4FRESPoPI022bLND4SHMzuyLhN9+8s2GRV0XuWJgsK87Ev9md9t+hIVFU2KpDshTtFm
         mR7xfutT0M0i7fbOV1tifg6YEbZ1HOHMAx8qpobuLxhjq9hqbBL1GswHRq7SHh9TzU/z
         RvzA==
X-Gm-Message-State: AOAM531vmM/zc4PDtrGy8MnwFZL5C7+D79idXHOTk8jxuRSPNaRpM9hO
        TJv/iZN9j+MbGr8Qm5rCOITECWiZf2spbFVHWKk=
X-Google-Smtp-Source: ABdhPJzspGMaJW4V4XJJYR980bkplhP3rJhpEkhpWaiVMlZ8syf2P6GJj5KRClEz7Df2+C7nNCvVgDTeAgQG6UZFfLA=
X-Received: by 2002:a25:da4e:: with SMTP id n75mr5424442ybf.425.1604696288129;
 Fri, 06 Nov 2020 12:58:08 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com> <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com> <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
In-Reply-To: <20201106094425.5cc49609@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 12:57:56 -0800
Message-ID: <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 12:44 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:
> > I'll just quote myself here for your convenience.
>
> Sorry, I missed your original email for some reason.
>
> >   Submodule is a way that I know of to make this better for end users.
> >   If there are other ways to pull this off with shared library use, I'm
> >   all for it, it will save the security angle that distros are arguing
> >   for. E.g., if distributions will always have the latest libbpf
> >   available almost as soon as it's cut upstream *and* new iproute2
> >   versions enforce the latest libbpf when they are packaged/released,
> >   then this might work equivalently for end users. If Linux distros
> >   would be willing to do this faithfully and promptly, I have no
> >   objections whatsoever. Because all that matters is BPF end user
> >   experience, as Daniel explained above.
>
> That's basically what we already do, for both Fedora and RHEL.
>
> Of course, it follows the distro release cycle, i.e. no version
> upgrades - or very limited ones - during lifetime of a particular
> release. But that would not be different if libbpf was bundled in
> individual projects.

Alright. Hopefully this would be sufficient in practice.

>
>  Jiri
>
