Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576E911E917
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfLMRSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:18:46 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44463 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfLMRSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:18:46 -0500
Received: by mail-pl1-f195.google.com with SMTP id az3so1478521plb.11;
        Fri, 13 Dec 2019 09:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=qXc/vfihXBGlK8g1+J3ovo1b6aC2XrOPwi2cHjZrPeY=;
        b=bRpZJTbJJJvjOUzsqLuJLrcsberjD0lW3JdFeGG2nxr/GjrFdPXUl4ZNZZkhiwaq9h
         Nvs2np7vzcdP8W4bDj8YsD/vKiL72q19eVc2Q3EUWL0bTucxNBJtIl63pNoGHjqBT9IG
         U1NRJWjZDvA71bjjT3h/iXoLDnAEyBC1gVfPS8fNqQ7tfDTIHbUzO3HrOJ1hxPOBCf4E
         3/hRsdCbfrj7CRIehmOP88V9Mlc8UmTqlM3lSgFw30S5Cu9uHIqmCM+CsB9dnrG5/jtX
         AEnX1tYQ/XIcUy/VsG9qcrakTWZl5jezbUsCxMV48BSBnv7GLKFiw4BmZS6p/TW6XRiv
         mIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=qXc/vfihXBGlK8g1+J3ovo1b6aC2XrOPwi2cHjZrPeY=;
        b=hT+iiNMx7009a4yWEilg/qQifyw1GBjEdIsD8AgHQkgR8SLb5qSAJNHB6mLxYFPOUv
         L2tWkxraVGba3M/kS3l2B+965Uut7j0ulQOjQ6CRzYlKakWgnc5sNLXXkNw6df3GEO9d
         T/JP0pL7s6pwbmI6/xmxhUv7V4HgbsEVpaeG8ekG18GlctYYwHoKiWq9gVkz2cFt6O4k
         qdVx/fNOS1QOBOA6hI56nveTXcsDIENz6okzdWgYw3i2a8KabyDD7s3tuxdcFrNUdVoK
         FjGLPa95B4Cq71HYiqpMRddk7DiJXL0LhWK0v5BHi8CKtTQmt8i1glLIV+ZN/eb4CZMI
         qcAw==
X-Gm-Message-State: APjAAAVIVcvbHAoQshCAe1WEsaQPLvqTUvVWagGK1C39U9IjIq2KcNjo
        RUoFey0EDv8W94FzQ4TDbyI=
X-Google-Smtp-Source: APXvYqzZeB66fAKwh3lu7h7lOfFEQHvYUXX5Hh+d7z0qZ9gIkPLfoaRTy+bht3EvlWlQ/zcpLAagRA==
X-Received: by 2002:a17:902:758c:: with SMTP id j12mr451549pll.14.1576257525647;
        Fri, 13 Dec 2019 09:18:45 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::de66])
        by smtp.gmail.com with ESMTPSA id z64sm12355062pfz.23.2019.12.13.09.18.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 09:18:44 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:18:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= 
        <thoiland@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <20191213171841.kjrs3uhf6bgskgzq@ast-mbp.dhcp.thefacebook.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
 <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp>
 <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
 <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com>
 <CAADnVQLPJPDGY8aJwrTjOxVaDkZ3KM1_aBVc5jGwxxtNB+dBrg@mail.gmail.com>
 <CAJ+HfNg4uAA+++LvhPG8cvkz7X_wjJkB8vYGNeZROaDV6eDXmA@mail.gmail.com>
 <CAADnVQ+eD-=FZrg8L+YcdCyAS+E30W=Z-ShtEXAXVFjmxV4usg@mail.gmail.com>
 <CAJ+HfNgg6dp3om=nfA_vJ+SbtstC=e9dVSm=z0yRJjc372L+=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNgg6dp3om=nfA_vJ+SbtstC=e9dVSm=z0yRJjc372L+=w@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:09:46PM +0100, Björn Töpel wrote:
> On Fri, 13 Dec 2019 at 17:03, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 7:59 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
> > >
> > > On Fri, 13 Dec 2019 at 16:52, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Dec 13, 2019 at 7:49 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
> > > > >
> > > > > On Fri, 13 Dec 2019 at 16:04, Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Dec 13, 2019 at 08:51:47AM +0100, Björn Töpel wrote:
> > > > > > >
> > > > > > > > I hope my guess that compiler didn't inline it is correct. Then extra noinline
> > > > > > > > will not hurt and that's the only thing needed to avoid the issue.
> > > > > > > >
> > > > > > >
> > > > > > > I'd say it's broken not marking it as noinline, and I was lucky. It
> > > > > > > would break if other BPF entrypoints that are being called from
> > > > > > > filter.o would appear. I'll wait for more comments, and respin a v5
> > > > > > > after the weekend.
> > > > > >
> > > > > > Also noticed that EXPORT_SYMBOL for dispatch function is not necessary atm.
> > > > > > Please drop it. It can be added later when need arises.
> > > > > >
> > > > >
> > > > > It's needed for module builds, so I cannot drop it!
> > > >
> > > > Not following. Which module it's used out of?
> > >
> > > The trampoline is referenced from bpf_prog_run_xdp(), which is
> > > inlined. Without EXPORT, the symbol is not visible for the module. So,
> > > if, say i40e, is built as a module, you'll get a linker error.
> >
> > I'm still not following. i40e is not using this dispatch logic any more.
> 
> Hmm, *all* XDP users uses it, but indirectly via bpf_prog_run_xdp().
> All drivers that execute an XDP program, does that via the
> bpf_prog_run_xdp(), say, i40e_txrx.c and i40e_xsk.c.
> bpf_prog_run_xdp() is inlined and expaned to __BPF_PROG_RUN(), which
> calls into the dispatcher trampoline.
> 
> $ nm drivers/net/ethernet/intel/i40e/i40e_xsk.o|grep xdpfunc
>                  U bpf_dispatcher_xdpfunc
> 
> Makes sense?

ahh. got it. bpf_prog_run_xdp() is static inline in .h

Thank you for explaining!

