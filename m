Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3FB96467
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbfHTP3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:29:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37607 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730374AbfHTP3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:29:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id y26so6487731qto.4;
        Tue, 20 Aug 2019 08:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bFnaNlCJbS1STtybbkD8D5UctrEgyv/6R1gbjeYsEmo=;
        b=lKyaeD4zifwkuNBxNy7hIW9nSPtSHvRp8MUFQzkK9+wDVoa+fxQQQblsdikFfPkyNh
         aQSoHPnBLad4G4XcrQkYOvyUIENefvTGwBbXVUrCkrRvBs+LxeARqGdeaTYLxVJq/RNp
         9SjgLSql46RzPzDbEIYaMDPUvGxnXIjFbph4QT7kya4iiWHpyvPkJYNNBWx8fRsg/t3J
         +Yy7oddRYLAdzAU0i3/oSfrL/TH7awJaK41Y5lMPVPDZBABBGyGt4QEZQVMuZqBvQiMa
         uBaxD9j9rkr7yXRs05fhwLcAiP7HY/weBu+JcCgvHeIC6AXOQoWkIMyeHWR7kY5aDyVQ
         pLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bFnaNlCJbS1STtybbkD8D5UctrEgyv/6R1gbjeYsEmo=;
        b=FZs1fLybnEr2YMB4hkVEeS7qnsxhjpUsg+kHGvikh6tqbiTT3oSWYWA8aD04j+fxJ4
         7Mye3gfPN76MRsZ5k2RX/S/bk2DtBshEGAdSPzlkK+Jpo8RsCzFrMSlkQQRLSnABb3xr
         568wmubQB3318kaT3Gxs6EsmgGXO7AMkaNX9AU8+fCIUe9X4f8d5glHjC/CqEv4QfEae
         2+1AX2ezPAdBXs2P8CT/WVFXDXffiSuBUifu8YMZTSXsIhOBRhNSCKNAPe3GxP9lBy64
         YjroF8z+zKf6iU24wHGx2RQafJEbM+jgPQVaEzanjw7OrQG9ulnnwzgTcXjnVC0SNqKY
         iBSQ==
X-Gm-Message-State: APjAAAXuzTKg9d+y9Xt8vUiYaLGsvfWBRpN2aUnlWc72SGgdVR0ubcuQ
        yNDWPFojH3Z2wa7NJCttHdGeMxNbXg+xGZ/QyDE=
X-Google-Smtp-Source: APXvYqzOnQNQMEYzZx8mobOz5u77+c51BRzre3v1jzHr6yaOmJcZB16OxGuj0ZJQuBpPY3yM95McQUt8mI4fQodWzg4=
X-Received: by 2002:ac8:5247:: with SMTP id y7mr27553986qtn.107.1566314963078;
 Tue, 20 Aug 2019 08:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009167320590823a8c@google.com> <20190820100405.25564-1-bjorn.topel@gmail.com>
 <beef16bb-a09b-40f1-7dd0-c323b4b89b17@iogearbox.net>
In-Reply-To: <beef16bb-a09b-40f1-7dd0-c323b4b89b17@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 20 Aug 2019 17:29:11 +0200
Message-ID: <CAJ+HfNj8qNwCpiLBw1eO_ggSf11Qq9323NVOcTS6wtfTm=RWcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: proper socket state check in xsk_poll
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Xdp <xdp-newbies@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, hdanton@sina.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 at 16:30, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/20/19 12:04 PM, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The poll() implementation for AF_XDP sockets did not perform the
> > proper state checks, prior accessing the socket umem. This patch fixes
> > that by performing a xsk_is_bound() check.
> >
> > Suggested-by: Hillf Danton <hdanton@sina.com>
> > Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> > Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP r=
ings")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >   net/xdp/xsk.c | 14 ++++++++++++--
> >   1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index ee4428a892fa..08bed5e92af4 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -356,13 +356,20 @@ static int xsk_generic_xmit(struct sock *sk, stru=
ct msghdr *m,
> >       return err;
> >   }
> >
> > +static bool xsk_is_bound(struct xdp_sock *xs)
> > +{
> > +     struct net_device *dev =3D READ_ONCE(xs->dev);
> > +
> > +     return dev && xs->state =3D=3D XSK_BOUND;
> > +}
> > +
> >   static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t =
total_len)
> >   {
> >       bool need_wait =3D !(m->msg_flags & MSG_DONTWAIT);
> >       struct sock *sk =3D sock->sk;
> >       struct xdp_sock *xs =3D xdp_sk(sk);
> >
> > -     if (unlikely(!xs->dev))
> > +     if (unlikely(!xsk_is_bound(xs)))
> >               return -ENXIO;
> >       if (unlikely(!(xs->dev->flags & IFF_UP)))
> >               return -ENETDOWN;
> > @@ -383,6 +390,9 @@ static unsigned int xsk_poll(struct file *file, str=
uct socket *sock,
> >       struct net_device *dev =3D xs->dev;
> >       struct xdp_umem *umem =3D xs->umem;
> >
> > +     if (unlikely(!xsk_is_bound(xs)))
> > +             return mask;
> > +
> >       if (umem->need_wakeup)
> >               dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> >                                               umem->need_wakeup);
> > @@ -417,7 +427,7 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
> >   {
> >       struct net_device *dev =3D xs->dev;
> >
> > -     if (!dev || xs->state !=3D XSK_BOUND)
> > +     if (!xsk_is_bound(xs))
> >               return;
>
> I think I'm a bit confused by your READ_ONCE() usage. ;-/ I can see why y=
ou're
> using it in xsk_is_bound() above, but then at the same time all the other=
 callbacks
> like xsk_poll() or xsk_unbind_dev() above have a struct net_device *dev =
=3D xs->dev
> right before the test. Could you elaborate?
>

Yes, now I'm confused as well! Digging deeper... I believe there are a
couple of places in xsk.c that do not have
READ_ONCE/WRITE_ONCE-correctness. Various xdp_sock members are read
lock-less outside the control plane mutex (mutex member of struct
xdp_sock). This needs some re-work. I'll look into using the newly
introduced state member (with corresponding read/write barriers) for
this.

I'll cook some patch(es) that address this, but first it sounds like I
need to reread [1] two, or three times. At least. ;-)


Thanks,
Bj=C3=B6rn


[1] https://lwn.net/Articles/793253/


> Thanks,
> Daniel
