Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E4F413D80
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhIUWZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbhIUWZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:25:22 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45119C061574;
        Tue, 21 Sep 2021 15:23:52 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id v19so629500pjh.2;
        Tue, 21 Sep 2021 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KoiUWCT9pHLWW4LMH3hpcOQftLckFQSzudXt8mmYIQI=;
        b=Db4GCcqk7IuCl2FLQ4jmc5szG6CIfGgxIRrkCsvp6DJSKv+eApOcCZLbBVvGrqQcGz
         9I6HzrHuCjUUPNf9yCBGqx8LCXhddrrO0BeAPMFKfvi/MLgjbeZR5VtoTohVbKTANUtT
         qHEbCHZqDPW0jtj6wy/CHoB4gmbZAnWmvvw55bOHihn/Wcms9sM1qbYho/0HLhfLh0nk
         O9v0HSCZqyOq5ENHRXzqO7H1U9LpuYIDLNTqfEWj+lHNnfFpHk8iy3sjC1/yvphm2U2F
         xzoyKGYGS/hBasHR8tOiOLNIplqttkGD+LyA4gwcq8EbBgfammKuRGsf5UNcoMro8HKB
         HuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KoiUWCT9pHLWW4LMH3hpcOQftLckFQSzudXt8mmYIQI=;
        b=LWe4KGosOFbo8S4jYHMwada9+FsQz5ibwlfgsB4UZcTsYoughkBEzooHFuZUPGDfo4
         rg9uLdsmwxjTNXN8Cw31C/Db1UfFfX8Q4kzaSRAo6o8tfG886YNoAb7UTJapLvtt8k4B
         e4zzbXUgm5kxAGs/fjqXmd5Crv1Nllg9g39+GZKN/lUHKM2HmFbIcOmerWaU3QM7tzvI
         smaYIqgM171srhaUPoWh0PUuYudGeU7h6qkoLtC5E5xUhVn7twqtrapFVnIpiWlheedd
         ne+tnlF/FnQpo/b15aqTCfxUgY/5NXKGnZ9otfHtIc9X3OmNM8JIKH5nfoZ6euwjAAbC
         MTmQ==
X-Gm-Message-State: AOAM531QL8eRHFrYAms+Bco8h+uoPSUiBs1yNdbliJZ1MeG7ZoKtA/RQ
        SIE5ROarbnG49XRdDe+A+UY=
X-Google-Smtp-Source: ABdhPJwHo3mMIt9Msq/NTYNzc33GEZxth8bCQE597BO0U1QxAAwi8a68A5zeyH7CjsBZmMaIBtWTWw==
X-Received: by 2002:a17:90b:4a44:: with SMTP id lb4mr7766330pjb.140.1632263031601;
        Tue, 21 Sep 2021 15:23:51 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id p30sm148350pfh.116.2021.09.21.15.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:23:51 -0700 (PDT)
Date:   Wed, 22 Sep 2021 03:53:48 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 05/11] bpf: Enable TCP congestion control
 kfunc from modules
Message-ID: <20210921222348.4k6lg6jb73qcfpok@apollo.localdomain>
References: <20210920141526.3940002-1-memxor@gmail.com>
 <20210920141526.3940002-6-memxor@gmail.com>
 <CAEf4BzY7EVKv66CZ9KfefDopWDPL7xQCgLxq=oDS3eLKusAHWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY7EVKv66CZ9KfefDopWDPL7xQCgLxq=oDS3eLKusAHWA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 03:48:55AM IST, Andrii Nakryiko wrote:
> On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This commit moves BTF ID lookup into the newly added registration
> > helper, in a way that the bbr, cubic, and dctcp implementation set up
> > their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
> > dependent on modules are looked up from the wrapper function.
> >
> > This lifts the restriction for them to be compiled as built in objects,
> > and can be loaded as modules if required. Also modify Makefile.modfinal
> > to resolve_btfids in TCP congestion control modules if the config option
> > is set, using the base BTF support added in the previous commit.
> >
> > See following commits for background on use of:
> >
> >  CONFIG_X86 ifdef:
> >  569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)
> >
> >  CONFIG_DYNAMIC_FTRACE ifdef:
> >  7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)
> >
> > [ resolve_btfids uses --no-fail because some crypto kernel modules
> >   under arch/x86/crypto generated from ASM do not have the .BTF sections ]
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/btf.h       |  4 ++++
> >  kernel/bpf/btf.c          |  3 +++
> >  net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
> >  net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
> >  net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
> >  net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
> >  scripts/Makefile.modfinal |  1 +
> >  7 files changed, 88 insertions(+), 34 deletions(-)
> >
>
> [...]
>
> > diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> > index ff805777431c..b4f83533eda6 100644
> > --- a/scripts/Makefile.modfinal
> > +++ b/scripts/Makefile.modfinal
> > @@ -41,6 +41,7 @@ quiet_cmd_btf_ko = BTF [M] $@
> >        cmd_btf_ko =                                                     \
> >         if [ -f vmlinux ]; then                                         \
> >                 LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
> > +               $(RESOLVE_BTFIDS) --no-fail -s vmlinux $@;              \
>
> I think I've asked that before, but I don't remember this being
> answered. Why is this --no-fail?
>

Sorry, the first time, I missed that mail, and then it was too late so I decided
to put the reason in the commit message above.

> > [ resolve_btfids uses --no-fail because some crypto kernel modules
> >   under arch/x86/crypto generated from ASM do not have the .BTF sections ]

I could add a mode that fails only when processing a .BTF section present in
object fails, would that be better?

--
Kartikeya
