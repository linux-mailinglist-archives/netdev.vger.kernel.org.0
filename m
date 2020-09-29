Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650DC27BE00
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI2H3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2H3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:29:44 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F24EC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:29:42 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id 7so2354758vsp.6
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RRExsVyVMwBvTMnZrDTLbfks0apPzLNJ5QKUNQU00UE=;
        b=Evpn9qO/frrfNUxv6L3B0DSPIIPy1ZctcHXUS0ssjSBetN9s1PZNFIY/O5IANEUOys
         RPNm8keLlt8p6mcKiL0GVrjdJ93kKWiKuymB8TzMAsnUOh5kJTsZ8oi9+Ymw3lJaXYXB
         R5rnGpDZHiiGQPoFKAtQKgrT6zG5LUVCXjU4YssTHdK4TympEIf57A1MDUlAFyWaHd9I
         TLLCDVaAeQefqd79ETKBH6RqrdDuaIZvaG8d3h/rgMXLCDtcQ9OKw5kVzgi51x6HK3vW
         WzOlhdSYvYiL1Mn8ARuJPoKNZ3cajn61IrupDxSuKJ1lC1h4bIToQEZgxP8MZGAEyVgs
         q72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RRExsVyVMwBvTMnZrDTLbfks0apPzLNJ5QKUNQU00UE=;
        b=I99pHFZ4EES/R1khNbjYNhMwxoIAhOEIMSyQ5kqC6hIKD7K055lfIbM3KmBaVHZUjG
         c0mQ4O8cwmiNz96cxy3mb556Q0OAKifgBYy1gQsawM7sl1l8TAVjj0nZrsQb2fqHdvQf
         hIvggzci+5EOab416CFeVcVuXFvTWyly96TIfhjUoifZPkj5ozQVuL3dLprI1OzYHX8R
         FYEY8qkrbWPKicssgg1wA/OcusxbZlZeZh4WifyxbG40P9iE5vSqtGqP6faGzPrbR2fo
         X4a2e++8XJQCZRVeOnCLJeUuL0Vq6uKSrq4F3SudBslhnAPkwQcpunpczbFTqRuFaCTA
         91Fg==
X-Gm-Message-State: AOAM531+bGmN7fh7qbg5dQakK6jlzoitQbKggC33GF+ANgOFTJmDfI7I
        b4LPH9v+2GW61Zi7GIGhmsU1mg9O8Hq/og==
X-Google-Smtp-Source: ABdhPJz9B+Ohx4gmsPL2wtp0Uf2WvYPFRXQn08tys670UYYICtt905ROfrAXQWOHWtMVwBo6wE9ahw==
X-Received: by 2002:a67:7710:: with SMTP id s16mr2120604vsc.3.1601364580250;
        Tue, 29 Sep 2020 00:29:40 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id 107sm358587uaf.15.2020.09.29.00.29.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 00:29:39 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id z193so2350663vsz.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:29:39 -0700 (PDT)
X-Received: by 2002:a67:e83:: with SMTP id 125mr2091259vso.22.1601364578963;
 Tue, 29 Sep 2020 00:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
 <20200929022246-mutt-send-email-mst@kernel.org> <CAMDZJNWM7eBkrYk9nkEvPyHW7=kt_hTHGQCDB1CPRz=EV6vJcQ@mail.gmail.com>
 <20200929031754-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200929031754-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 29 Sep 2020 09:29:02 +0200
X-Gmail-Original-Message-ID: <CA+FuTScinzrURHx_jQge9jN0mJU7oM2d9AJ9ckkXm3SxBHGNvQ@mail.gmail.com>
Message-ID: <CA+FuTScinzrURHx_jQge9jN0mJU7oM2d9AJ9ckkXm3SxBHGNvQ@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 9:23 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 02:59:03PM +0800, Tonghao Zhang wrote:
> > On Tue, Sep 29, 2020 at 2:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Sep 29, 2020 at 09:58:06AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Open vSwitch and Linux bridge will disable LRO of the interface
> > > > when this interface added to them. Now when disable the LRO, the
> > > > virtio-net csum is disable too. That drops the forwarding performance.
> > > >
> > > > Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > ---
> > > > v2:
> > > > * change the fix-tag
> > > > ---
> > > >  drivers/net/virtio_net.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 7145c83c6c8c..21b71148c532 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> > > >       VIRTIO_NET_F_GUEST_CSUM
> > > >  };
> > > >
> > > > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > > > +                             (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > > > +                             (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > +                             (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > +
> > >
> > > I think I'd rather we open-coded this, the macro is only
> > > used in one place ...
> > Yes, in this patch, it is used only in one place. But in next patch
> > [1], we use it twice and that make the code look a bit nicer.
> > Would we open-coded this in this patch ?
> >
> > [1] - http://patchwork.ozlabs.org/project/netdev/patch/20200928033915.82810-2-xiangxia.m.yue@gmail.com/
>
> OK then maybe keep this in a series like you did with v1.

If this is a fix it has to target net, unlike the other patch.
