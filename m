Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBAB3955EB
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhEaHVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhEaHVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:21:18 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A220FC061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:19:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g8so6761473ejx.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cTcp9v8u4pMFG1SgPeYUwPp2woOjmcDKnMwfn2ea1TE=;
        b=E+CogGtmUBrMse+vR+hdRJEYcLZNYtX7rOHpETf7lwi/3ikt6SetSqfwE2EWA+JS57
         0ZPxGhM2gyVKOsIey9oR2rJOAOalp7+g+VNfhRdd98CVuPVAplaqNYp6vpaWhpRsMBdq
         61yUwOxR9lVTBRAIsxhmjCx3xnJwg3ckWPna7yRxDiO9wqtyp1jR4D6qs4f/ZqeOmXEN
         DyMlvfMxT1kqm3ATKvjnwInJRRzTXeKMCaKW8bt1i3FEz+U18XWweLM1FVv+2Dg9sBZI
         fCiGKaDDQMq9r2bHbT6he+tzhOJgjI+Q9SMISdX5d8FwZejnjCqnU+x9mXoYOKEcGLTE
         RzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cTcp9v8u4pMFG1SgPeYUwPp2woOjmcDKnMwfn2ea1TE=;
        b=hBEMm11OofmkVAgYNaIZ/2zQpITVlMkfBlCDp6hJZG1nzW9Fg87/V0pwGNen8XiAM4
         BirfSYw2kLYUWEBFoxhD0HbdEY83rE46kNbfTl3Mvmvo7WdjJ5sTfGt8rBYJPWve/CZs
         un01Z1DOXa5y6+DyhT3VLwfhYn8Yn4tGBy7tsoG+l5OfXpxdRMnG2JQqlpJuqZxz9hrd
         TG660mdQ8TaQDwO75CcNpOPBxWHn/trZkQ8Lw52wD8Ncz2N3Rmjicn4GUyhZ28HDrblF
         IfH65hjV6Lebo5MwKVe/A/ep7Dd96LWJXELITRnr/j0aQZkcN+TwgYvcvqoGpmTmNj6g
         +AUg==
X-Gm-Message-State: AOAM5324KWo+wjYZ6FkLiG14Va9XsRo6iG4Eedt3Ia2WRpKQl3YIeKLB
        WrEZVq8oGk48gQRKDPdJ5M0D2bvhukHGhvP28qFk
X-Google-Smtp-Source: ABdhPJzxuVxYLZR8fmb00QX/IhpvMYe2uUVN01hloe1NQZYW+Z/O/3OA7EgTBkXyH5yIBWSRCxim1/RpUW5kLLC1GEY=
X-Received: by 2002:a17:906:3818:: with SMTP id v24mr13266181ejc.197.1622445577298;
 Mon, 31 May 2021 00:19:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210528121157.105-1-xieyongji@bytedance.com> <49ab3d41-c5d8-a49d-3ff4-28ebfdba0181@redhat.com>
In-Reply-To: <49ab3d41-c5d8-a49d-3ff4-28ebfdba0181@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 31 May 2021 15:19:26 +0800
Message-ID: <CACycT3uo-J3MYdEo0TscENewp3Xnjce8yFLtt6JkK8uZrvsMjg@mail.gmail.com>
Subject: Re: Re: [PATCH v3] virtio-net: Add validation for used length
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 2:49 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/28 =E4=B8=8B=E5=8D=888:11, Xie Yongji =E5=86=99=E9=81=93=
:
> > This adds validation for used length (might come
> > from an untrusted device) to avoid data corruption
> > or loss.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/net/virtio_net.c | 28 +++++++++++++++++++++-------
> >   1 file changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 073fec4c0df1..01f15b65824c 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -732,6 +732,17 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
> >
> >       rcu_read_lock();
> >       xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > +     if (unlikely(len > GOOD_PACKET_LEN)) {
> > +             pr_debug("%s: rx error: len %u exceeds max size %d\n",
> > +                      dev->name, len, GOOD_PACKET_LEN);
> > +             dev->stats.rx_length_errors++;
> > +             if (xdp_prog)
> > +                     goto err_xdp;
> > +
> > +             rcu_read_unlock();
> > +             put_page(page);
> > +             return NULL;
> > +     }
> >       if (xdp_prog) {
> >               struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_off=
set;
> >               struct xdp_frame *xdpf;
> > @@ -888,6 +899,16 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
> >
> >       rcu_read_lock();
> >       xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > +     if (unlikely(len > truesize)) {
> > +             pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> > +                      dev->name, len, (unsigned long)ctx);
> > +             dev->stats.rx_length_errors++;
> > +             if (xdp_prog)
> > +                     goto err_xdp;
> > +
> > +             rcu_read_unlock();
> > +             goto err_skb;
> > +     }
>
>
> Patch looks correct but I'd rather not bother XDP here. It would be
> better if we just do the check before rcu_read_lock() and use err_skb
> directly() to avoid RCU/XDP stuffs.
>

If so, we will miss the statistics of xdp_drops. Is it OK?

Thanks,
Yongji
