Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A6535924
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfFEJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:00:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33808 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfFEJAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 05:00:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so11851235qtu.1;
        Wed, 05 Jun 2019 02:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7kYdah2nU4LVa6o5dKknStWAMq5Q0lEADTik/SQ5S8k=;
        b=F1q6lhRIpjwP3TVV0hvZZY0W/INTFjJ2pSy3a19s0d4oZ48sWaWDU40oKHpwjnWzfE
         npZGV9rhaZtm36o6GvZC6ND0OZYrOXDcNtnT3nKYFeC0gqY0K2QEORntgr7YKqPcyoQ4
         Lg2boZblBrD3Dadasg5MY2NLRZG+3cUd5qSHQN3smSfUUGesw/P3PlrWT1tIFW7hFuHV
         QSJmrVYpUZPRzdNSLQsdxZ/QbCZQTzuwc8ZSPQC/XlYWaUb+3mJgAWhj7Kal3Qb9POX+
         9zrSsIZT93MlRf46Sr5RIETGluJ9rdZhcVONOY7AVkaWMFqWmVpACOItAptWbZ4vXw2r
         BdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7kYdah2nU4LVa6o5dKknStWAMq5Q0lEADTik/SQ5S8k=;
        b=sAthB41Ue3IoQUCgmNSkawpDtoCbKz1AhPjQBQcSGhe2YAtsjDOlG5wsgeWK9DL+QY
         4qG4e0DEnrMShDuA8EGQIZY/P3IZHJngs4lm8jcJYiqUYFw18YQs18xM2KqiLx8xo6jF
         K/88USyfHg+PawEJYeMjM0B2emqqI9b/tltRkaeQIEEUSWY8L2axJ+lH3jHPujKF473L
         ZB1ojd/jYEdGLSweQtvtJnRuRCAEC7mV+1AB/oChS0mZGadciPGe5IyxvJZ7x4WjMbX+
         7hd4kNPDZYbbsOxC8kd9q33Q/LJYMAYbvM7M8sDifkmRbtJd5+zcjuINGajcpC2WxGe3
         7+CA==
X-Gm-Message-State: APjAAAXjYnfrDLNRbjcUCElfLo9mCD3UbbR1LqBWzQyLHsirV6Dw2Ocq
        Wd5usZ1G4wqmmn0aDY+zHX/ha8uuv/8ngmvMgCs=
X-Google-Smtp-Source: APXvYqwjrlUgAtlStGMcKSY7P4J7nW4AmxAuFuHx9QrT6bRBqdkS3i+5p+8a8t9Ig0uexXbc31tgWyadNkmgskgPzZw=
X-Received: by 2002:ac8:25b1:: with SMTP id e46mr13720177qte.36.1559725218205;
 Wed, 05 Jun 2019 02:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-2-maciej.fijalkowski@intel.com> <76bc124c-46ed-f0a6-315e-1600c837aea0@intel.com>
 <20190604170452.00001b29@gmail.com>
In-Reply-To: <20190604170452.00001b29@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 5 Jun 2019 11:00:07 +0200
Message-ID: <CAJ+HfNj6NvRQcT5iS_nQEYfpWoav7LxEqLFShjP8BHjqAaopqA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/4] libbpf: fill the AF_XDP fill queue
 before bind() call
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 17:06, Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Tue, 4 Jun 2019 10:06:36 +0200
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:
>
> > On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > > Let's get into the driver via ndo_bpf with command set to XDP_SETUP_U=
MEM
> > > with fill queue that already contains some available entries that can=
 be
> > > used by Rx driver rings. Things worked in such way on old version of
> > > xdpsock (that lacked libbpf support) and there's no particular reason
> > > for having this preparation done after bind().
> > >
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.c=
om>
> > > ---
> > >   samples/bpf/xdpsock_user.c | 15 ---------------
> > >   tools/lib/bpf/xsk.c        | 19 ++++++++++++++++++-
> > >   2 files changed, 18 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > > index d08ee1ab7bb4..e9dceb09b6d1 100644
> > > --- a/samples/bpf/xdpsock_user.c
> > > +++ b/samples/bpf/xdpsock_user.c
> > > @@ -296,8 +296,6 @@ static struct xsk_socket_info *xsk_configure_sock=
et(struct xsk_umem_info *umem)
> > >     struct xsk_socket_config cfg;
> > >     struct xsk_socket_info *xsk;
> > >     int ret;
> > > -   u32 idx;
> > > -   int i;
> > >
> > >     xsk =3D calloc(1, sizeof(*xsk));
> > >     if (!xsk)
> > > @@ -318,19 +316,6 @@ static struct xsk_socket_info *xsk_configure_soc=
ket(struct xsk_umem_info *umem)
> > >     if (ret)
> > >             exit_with_error(-ret);
> > >
> > > -   ret =3D xsk_ring_prod__reserve(&xsk->umem->fq,
> > > -                                XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > > -                                &idx);
> > > -   if (ret !=3D XSK_RING_PROD__DEFAULT_NUM_DESCS)
> > > -           exit_with_error(-ret);
> > > -   for (i =3D 0;
> > > -        i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> > > -                XSK_UMEM__DEFAULT_FRAME_SIZE;
> > > -        i +=3D XSK_UMEM__DEFAULT_FRAME_SIZE)
> > > -           *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) =3D i;
> > > -   xsk_ring_prod__submit(&xsk->umem->fq,
> > > -                         XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > > -
> > >     return xsk;
> > >   }
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index 38667b62f1fe..57dda1389870 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -529,7 +529,8 @@ int xsk_socket__create(struct xsk_socket **xsk_pt=
r, const char *ifname,
> > >     struct xdp_mmap_offsets off;
> > >     struct xsk_socket *xsk;
> > >     socklen_t optlen;
> > > -   int err;
> > > +   int err, i;
> > > +   u32 idx;
> > >
> > >     if (!umem || !xsk_ptr || !rx || !tx)
> > >             return -EFAULT;
> > > @@ -632,6 +633,22 @@ int xsk_socket__create(struct xsk_socket **xsk_p=
tr, const char *ifname,
> > >     }
> > >     xsk->tx =3D tx;
> > >
> > > +   err =3D xsk_ring_prod__reserve(umem->fill,
> > > +                                XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > > +                                &idx);
> > > +   if (err !=3D XSK_RING_PROD__DEFAULT_NUM_DESCS) {
> > > +           err =3D -errno;
> > > +           goto out_mmap_tx;
> > > +   }
> > > +
> > > +   for (i =3D 0;
> > > +        i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> > > +                XSK_UMEM__DEFAULT_FRAME_SIZE;
> > > +        i +=3D XSK_UMEM__DEFAULT_FRAME_SIZE)
> > > +           *xsk_ring_prod__fill_addr(umem->fill, idx++) =3D i;
> > > +   xsk_ring_prod__submit(umem->fill,
> > > +                         XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > > +
> >
> > Here, entries are added to the umem fill ring regardless if Rx is being
> > used or not. For a Tx only setup, this is not what we want, right?
>
> Right, but we have such behavior even without this patch. So I see two op=
tions
> here:
> - if you agree with this patch, then I guess we would need to pass the in=
fo to
>   libbpf what exactly we are setting up (txonly, rxdrop, l2fwd)?
> - otherwise, we should be passing the opt_bench onto xsk_configure_socket=
 and
>   based on that decide whether we fill the fq or not?
>
> >
> > Thinking out loud here; Now libbpf is making the decision which umem
> > entries that are added to the fill ring. The sample application has thi=
s
> > (naive) scheme. I'm not sure that all applications would like that
> > policy. What do you think?
> >
>
> I find it convenient to have the fill queue in "initialized" state if I a=
m
> making use of it, especially in case when I am doing the ZC so I must giv=
e the
> buffers to the driver via fill queue. So why would we bother other applic=
ations
> to provide it? I must admit that I haven't used AF_XDP with other apps th=
an the
> example one, so I might not be able to elaborate further. Maybe other peo=
ple
> have different feelings about it.
>

Personally, I think this scheme is not worth pursuing. I'd just leave
the fill ring work to the application. E.g. DPDK would definitely not
use a scheme like this.

Bj=C3=B6rn

> > >     sxdp.sxdp_family =3D PF_XDP;
> > >     sxdp.sxdp_ifindex =3D xsk->ifindex;
> > >     sxdp.sxdp_queue_id =3D xsk->queue_id;
> > >
>
