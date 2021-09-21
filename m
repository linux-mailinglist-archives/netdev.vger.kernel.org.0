Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA08413DCE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 01:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhIUXEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 19:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhIUXEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 19:04:24 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A4CC061574;
        Tue, 21 Sep 2021 16:02:55 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 73so3123035qki.4;
        Tue, 21 Sep 2021 16:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hKQQwmeziLQV3Zl8Z6GcoEmhM45LZd29KWKMsYh23DE=;
        b=ahCBou0Zc5Zw0Ae4Zgdi+EF+F4azkDGzbS9dBhFYXf+aRUXuXznNpCHOnDr0bf4rCA
         fCpAMCTC/3WwAo3sBtLHLUBdtKsHw2pmWh6WksKV2eZDtziH/5INZQxuPBvA6/Lye++Y
         K0ZPSINcjVdf5C7zLAf++qrHvUP14jM9lKee8lr2Et7z9w3g3j2h7nOZTm849oBmN8cM
         YyrYMP/AtgTAQGQnF0ZUC3y2gVf1kjT0IYtDEch1+J7kFDiQCf3cLiNFdpKz6fgl5K5/
         8hz7E3G1X7d8nHRKNXJIPSHmAx89XaCQTLTgfolsiAsPGTbpiihNEDITRRJRcK2/HhFQ
         gDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hKQQwmeziLQV3Zl8Z6GcoEmhM45LZd29KWKMsYh23DE=;
        b=ov+8TzkLdlp78uDreYd9n/agDzwglM16cK+f5qxc2mUKNjjo2HZ5ZvZV+FQ3jD+8SP
         uub9c1PGR2hF7JMaKEtAIeRYonkEUnazgNo22Y5FX8UcVyg8RSh+7nYgo2MlltAvWqiC
         GMY6JWx3KyFthOh42vBghrlx1nfumuKgKW25VB8cuwNiNj/MMjH8aGa/vQPFkzH0xc90
         zgYQES2Jasmi3Sd47GBg+5qCg53/rGGpn+QILu2GzaHjOTnWY+uejDIPQkmZjsuGjZUX
         1l63bdGVbPCO/Du897RTuAn+ISqXTpA3TOIfMLnPwFF555+Jj5wUKmSSFq7t4TIWznRO
         vIPw==
X-Gm-Message-State: AOAM533MX2Zm3zqGpGfm9kTsjXQUBL+ecLOkreLE3ml31xMNftMndRxW
        ov8j8t4Nlox5X49dVReGYkZ76XrDv+a+iP92VIw=
X-Google-Smtp-Source: ABdhPJzZUkzfuWUQgF9JMzt8Ys1MIQz7T6Bzuq1WGLycqAXY3BsfCDksBmnUdTuJHyvV+4JspIBIfNIANPei3Le+gUY=
X-Received: by 2002:a25:47c4:: with SMTP id u187mr44409544yba.225.1632265374225;
 Tue, 21 Sep 2021 16:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-6-memxor@gmail.com>
 <CAEf4BzY7EVKv66CZ9KfefDopWDPL7xQCgLxq=oDS3eLKusAHWA@mail.gmail.com> <20210921222348.4k6lg6jb73qcfpok@apollo.localdomain>
In-Reply-To: <20210921222348.4k6lg6jb73qcfpok@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 16:02:42 -0700
Message-ID: <CAEf4BzZKXWPV-nE+AiNsujnEuGXOjG+cHzmSaSpthBPA4aEcPg@mail.gmail.com>
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
        Networking <netdev@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 3:23 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Sep 22, 2021 at 03:48:55AM IST, Andrii Nakryiko wrote:
> > On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This commit moves BTF ID lookup into the newly added registration
> > > helper, in a way that the bbr, cubic, and dctcp implementation set up
> > > their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
> > > dependent on modules are looked up from the wrapper function.
> > >
> > > This lifts the restriction for them to be compiled as built in objects,
> > > and can be loaded as modules if required. Also modify Makefile.modfinal
> > > to resolve_btfids in TCP congestion control modules if the config option
> > > is set, using the base BTF support added in the previous commit.
> > >
> > > See following commits for background on use of:
> > >
> > >  CONFIG_X86 ifdef:
> > >  569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)
> > >
> > >  CONFIG_DYNAMIC_FTRACE ifdef:
> > >  7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)
> > >
> > > [ resolve_btfids uses --no-fail because some crypto kernel modules
> > >   under arch/x86/crypto generated from ASM do not have the .BTF sections ]
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  include/linux/btf.h       |  4 ++++
> > >  kernel/bpf/btf.c          |  3 +++
> > >  net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
> > >  net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
> > >  net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
> > >  net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
> > >  scripts/Makefile.modfinal |  1 +
> > >  7 files changed, 88 insertions(+), 34 deletions(-)
> > >
> >
> > [...]
> >
> > > diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> > > index ff805777431c..b4f83533eda6 100644
> > > --- a/scripts/Makefile.modfinal
> > > +++ b/scripts/Makefile.modfinal
> > > @@ -41,6 +41,7 @@ quiet_cmd_btf_ko = BTF [M] $@
> > >        cmd_btf_ko =                                                     \
> > >         if [ -f vmlinux ]; then                                         \
> > >                 LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
> > > +               $(RESOLVE_BTFIDS) --no-fail -s vmlinux $@;              \
> >
> > I think I've asked that before, but I don't remember this being
> > answered. Why is this --no-fail?
> >
>
> Sorry, the first time, I missed that mail, and then it was too late so I decided
> to put the reason in the commit message above.
>
> > > [ resolve_btfids uses --no-fail because some crypto kernel modules
> > >   under arch/x86/crypto generated from ASM do not have the .BTF sections ]
>
> I could add a mode that fails only when processing a .BTF section present in
> object fails, would that be better?

Oh, missed [ ] part in the commit message. But yeah, it feels like it
shouldn't be an error if the module legitimately doesn't have a .BTF
section. Is it an error right now? cc Jiri, maybe that was intentional

>
> --
> Kartikeya
