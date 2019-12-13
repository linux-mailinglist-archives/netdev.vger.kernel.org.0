Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6BB11E7C8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfLMQJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:09:59 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46973 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMQJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:09:58 -0500
Received: by mail-qt1-f194.google.com with SMTP id 38so2629196qtb.13;
        Fri, 13 Dec 2019 08:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QH6xF7x8yKL4Ifn5+aJzOr7tfhb27sJNA8a0cd4iZC8=;
        b=WNpv776O95dCeLCLWYKAZbvOcvqBJ/0XWwY0gI7x18QH1OisbA2CV/VV35I2jzgiC9
         l5Xl8aNk/AsD0/pazp6s5gTgU6PA0HVpxi0Fh0K3enVVQNwfpwhTzgjOxvUkfttIpnRg
         bVGd3MgpGyNnuBEY/YTBar5phUAfti+/oqx9i50mIJXM5DbCnfBXaNlIUhHCzwexdsOl
         wBEHlLJOxW1x59E7ggE0jEpZGfdcL9yBkCYGScGZffbJM4VtrudZl2Zdmo12o0QOP+Wl
         zGfHbHv2j76WcwqW5x9EtrNAvxVEutkEVTyJukC+cQOKBHEvN98ttmtCvXHPgFiwGU+U
         WBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QH6xF7x8yKL4Ifn5+aJzOr7tfhb27sJNA8a0cd4iZC8=;
        b=DwAdRb1D1wTzXaNEmeaTiCcPtwrLiGdyqtFRQBCjg7PkgvrVVId/Pbry5HaskYp78/
         0v66/fZIKGebXef/zVZpKaBCs0iHGuYyMdJIoMQfR3ZHo8SDN6UUxlUjJmiMEHx57ooB
         nNc5EJ3DE37BgxNYCj/Dppn5Ms5k6GCkBzCkqvzFQOHSBgJEA67twanKyysQsSVDBD55
         C7qP8bU0UPgnIq9NqzvQxU9sWXBwk3IRuYOOEhpDSYR00EQifk7vcbqZEJS72d1un6LE
         7NaYx4geWCOl4xrYsW1/U8Q6nv1JUcxrEuvweY4gS2qYpYonbGYIL8HQFWFpaPPeyGui
         4xiw==
X-Gm-Message-State: APjAAAVmOKBmKxzon/Wpyanc+O/1ZqdjegD2cxM9+OKRx0jNvMy8z74W
        uUpRnNw/rmYXqXdf7Pn5fN33te/8ss+sjtb6a3TNoKP+K6uL0g==
X-Google-Smtp-Source: APXvYqw4cCB5f0T1YlHBRNme5Zav+KgmfN29mRzUHGXEqKjcamJuMBMfdwakdaIaz9vJpi9IG7rnX8nyrC+qXgE7YBY=
X-Received: by 2002:ac8:554b:: with SMTP id o11mr11158150qtr.36.1576253397764;
 Fri, 13 Dec 2019 08:09:57 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp> <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
 <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com>
 <CAADnVQLPJPDGY8aJwrTjOxVaDkZ3KM1_aBVc5jGwxxtNB+dBrg@mail.gmail.com>
 <CAJ+HfNg4uAA+++LvhPG8cvkz7X_wjJkB8vYGNeZROaDV6eDXmA@mail.gmail.com> <CAADnVQ+eD-=FZrg8L+YcdCyAS+E30W=Z-ShtEXAXVFjmxV4usg@mail.gmail.com>
In-Reply-To: <CAADnVQ+eD-=FZrg8L+YcdCyAS+E30W=Z-ShtEXAXVFjmxV4usg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Dec 2019 17:09:46 +0100
Message-ID: <CAJ+HfNgg6dp3om=nfA_vJ+SbtstC=e9dVSm=z0yRJjc372L+=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 at 17:03, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 7:59 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > On Fri, 13 Dec 2019 at 16:52, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Dec 13, 2019 at 7:49 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gm=
ail.com> wrote:
> > > >
> > > > On Fri, 13 Dec 2019 at 16:04, Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Dec 13, 2019 at 08:51:47AM +0100, Bj=C3=B6rn T=C3=B6pel w=
rote:
> > > > > >
> > > > > > > I hope my guess that compiler didn't inline it is correct. Th=
en extra noinline
> > > > > > > will not hurt and that's the only thing needed to avoid the i=
ssue.
> > > > > > >
> > > > > >
> > > > > > I'd say it's broken not marking it as noinline, and I was lucky=
. It
> > > > > > would break if other BPF entrypoints that are being called from
> > > > > > filter.o would appear. I'll wait for more comments, and respin =
a v5
> > > > > > after the weekend.
> > > > >
> > > > > Also noticed that EXPORT_SYMBOL for dispatch function is not nece=
ssary atm.
> > > > > Please drop it. It can be added later when need arises.
> > > > >
> > > >
> > > > It's needed for module builds, so I cannot drop it!
> > >
> > > Not following. Which module it's used out of?
> >
> > The trampoline is referenced from bpf_prog_run_xdp(), which is
> > inlined. Without EXPORT, the symbol is not visible for the module. So,
> > if, say i40e, is built as a module, you'll get a linker error.
>
> I'm still not following. i40e is not using this dispatch logic any more.

Hmm, *all* XDP users uses it, but indirectly via bpf_prog_run_xdp().
All drivers that execute an XDP program, does that via the
bpf_prog_run_xdp(), say, i40e_txrx.c and i40e_xsk.c.
bpf_prog_run_xdp() is inlined and expaned to __BPF_PROG_RUN(), which
calls into the dispatcher trampoline.

$ nm drivers/net/ethernet/intel/i40e/i40e_xsk.o|grep xdpfunc
                 U bpf_dispatcher_xdpfunc

Makes sense?
