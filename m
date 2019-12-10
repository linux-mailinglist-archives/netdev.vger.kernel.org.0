Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F202E118005
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 06:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLJFyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 00:54:46 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40385 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfLJFyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 00:54:46 -0500
Received: by mail-qt1-f195.google.com with SMTP id t17so1725659qtr.7;
        Mon, 09 Dec 2019 21:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aEdbSb4fDofi843wGegclbDxWODU3NrINX67WoXCGbE=;
        b=laiHemXoMlKAziVJp1hmYJMC31hksAvOs52IVY0hYhyenWMEgQz+nd7FAIkRC2M+Un
         phQtApChTnFDFMBMEbFRAL5h3Ip5APo19P7B6x2A61rkMOVKLQjOqxePAd1vvi1sYnfo
         738oXSNfX8rNdjh+Kio5BCyHTpvNYD/fFh5liJIzqyy8m/t2B3iIw3iyKpl14jB5/XUX
         +nS1CFZ42S+EH1bl0H0V4jMAAkZGqCAaOuXvMWYRmGuAyRXF53BohLmGdLrbtmyqPz7G
         u60/m7IDsTL0LX74oOpPFe7mGHyIJROmrLL/WUnqwz6pOgcAgFFwZj+zEBFq7fDURMKI
         eoSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aEdbSb4fDofi843wGegclbDxWODU3NrINX67WoXCGbE=;
        b=gThp0NvyoOPAqHpYpXGINE/kb4h9CO+Uf0LX5h4tRYkGVmFkiHOE3Xpjqt667BwgTw
         z7V9RnDpwrExD8I6s+MRMxFOgLny5VxOAcDGt4EppguTWlGIvm+t+s4YLcpX6YDGozie
         qzuwfUL4WGT2VdPyFTINR1Jjt3dMTLX8hDHabSHFMU5uVylAGywhVO+CMDM9Vn+qHext
         KSokIMBQUoVcpWTcI/v2nZSSxM26XWqbbNGevP3ydFBVYKDMxLaoA6WPTYcN0km1XY8m
         Y56+YPFxWBQ8cCY/UUHUgQFESMlQqbHVloYxYA5pYNqJXIODIPIR2q26dOFXHTSUJH7X
         xaxQ==
X-Gm-Message-State: APjAAAV1w1A6wPeHdVpAGt1BudeGTrwinguR/+tmFd4DHo0NQsK4YAHr
        FtfVGTsKTyRXZ4Kt5fgSCRQZikwICLKRrPtSEag=
X-Google-Smtp-Source: APXvYqzqCwX50vpUAHemUw3tbBPzvGWhpOVQKrMajAAXp/qN0zDOdtKxDMp7JO+oq3gw7KCBt5/GqZ8Va3FdE0Pdmts=
X-Received: by 2002:ac8:104:: with SMTP id e4mr28232284qtg.37.1575957285115;
 Mon, 09 Dec 2019 21:54:45 -0800 (PST)
MIME-Version: 1.0
References: <20191209135522.16576-1-bjorn.topel@gmail.com> <20191209135522.16576-3-bjorn.topel@gmail.com>
 <20191210055042.bhvm2gw633ts2gmg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191210055042.bhvm2gw633ts2gmg@ast-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 10 Dec 2019 06:54:33 +0100
Message-ID: <CAJ+HfNjtawO7f6kFimRiXoyQ_-9r2Y7FMV_2CU60TwaqHGhExw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/6] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 at 06:50, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Dec 09, 2019 at 02:55:18PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > +
> > +struct bpf_disp_prog {
> > +     struct bpf_prog *prog;
> > +     refcount_t users;
> > +};
> > +
> > +struct bpf_dispatcher {
> > +     void *func;
> > +     struct bpf_disp_prog progs[BPF_DISPATCHER_MAX];
> > +     int num_progs;
> > +     void *image;
> > +     u32 image_off;
> > +};
> > +
> > +static struct bpf_dispatcher *bpf_disp;
> > +
> > +static DEFINE_MUTEX(dispatcher_mutex);
> > +
> > +static struct bpf_dispatcher *bpf_dispatcher_lookup(void *func)
> > +{
> > +     struct bpf_dispatcher *d;
> > +     void *image;
> > +
> > +     if (bpf_disp) {
> > +             if (bpf_disp->func !=3D func)
> > +                     return NULL;
> > +             return bpf_disp;
> > +     }
> > +
> > +     d =3D kzalloc(sizeof(*d), GFP_KERNEL);
> > +     if (!d)
> > +             return NULL;
>
> The bpf_dispatcher_lookup() above makes this dispatch logic a bit difficu=
lt to
> extend, since it works for only one bpf_disp and additional dispatchers w=
ould
> need hash table. Yet your numbers show that even with retpoline=3Doff the=
re is a
> performance benefit. So dispatcher probably can be reused almost as-is to
> accelerate sched_cls programs.
> What I was trying to say in my previous feedback on this subject is that
> lookup() doesn't need to exist. That 'void *func' doesn't need to be a fu=
nction
> that dispatcher uses. It can be 'struct bpf_dispatcher *' instead.
> And lookup() becomes init().
> Then bpf_dispatcher_change_prog() will be passing &bpf_dispatcher_xdp
> and bpf_dispatcher_xdp is defined via macro that supplies
> 'struct bpf_dispatcher' above and instantiated in particular .c file
> that used that macro. Then dispatcher can be used in more than one place.
> No need for hash table. Multiple dispatchers are instantiated in places
> that need them via macro.
> The code will look like:
> bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
> {
>    bpf_dispatcher_change_prog(&bpf_dispatcher_xdp, prev_prog, prog);
> }
> Similarly sched_cls dispatcher for skb progs will do:
>    bpf_dispatcher_change_prog(&bpf_dispatcher_tc, prev_prog, prog);
> wdyt?
>

Yes, much cleaner. I'll respin!
