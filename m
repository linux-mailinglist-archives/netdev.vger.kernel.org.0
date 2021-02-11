Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CAF318284
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 01:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhBKAOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 19:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbhBKAN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 19:13:58 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B292C06174A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 16:13:18 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id b187so3867582ybg.9
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 16:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=chlkKVNTVPk0zWoGvuSGI8o+POtpyt8MtzzSG0MNV6Y=;
        b=K/FCFAYh0Qv4g9qx0haGFM/glLWO3k1AoqYnivlhCLV9WIQ7xvA/a95+c3e3rMAgQQ
         q6lDeyq/Y+3r8opcet1IP1jXZCX+JSkiWwXUYPMiTBeZdjWtG+r3oI2x5Eb3lzIswGMB
         P3Ds678KT+rAr33EJZPiqJw1rOOGIA/tnfVN0A4nAlsHaiDTnHtqY2GNjbgfBYkQFVZE
         2TebyjJdMLPkvQWLf4dOErfc1bL3lprkkDMrIhkLAR9qr2rx5H+BH64CJaGwXvd2GAtf
         NGZc/VYG4Sw2eLkAb+heT5+QOSir0AT4ZwIrTdCOrSji+upRHiPCsu5yO6A7QFYCIkhh
         UDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=chlkKVNTVPk0zWoGvuSGI8o+POtpyt8MtzzSG0MNV6Y=;
        b=U2BDtNwhrokOp/OZ9htA3ibqanO+2uBwaP+PVQP5uDC5mORoBg7gD4bY7fvu31PUhA
         h02Wc5VG6Dqc2C6L5n2P5/vVuflt2wm1jIwgFjz17Zs6tcnVMuaBewCF8HRt5f4yhMqN
         n9LvQec84NtevOwp6PomM9rOrr0fxvvbfKzVNa4ynQJLM5KdmrBNn494COzyscLtYskH
         g+/0B3F2GXTfQBa0gawopEHFbGfbDbcZ85TJfLC15/9zSlEqcC4KCQkWGX7QCN6gBcjD
         R1ag67Ad+JQDf3YSWQum7OAOklBjWDQc8w6ATF9L9xpdMs3gO/iZHHJw7fJbYt3zACJ5
         pzCQ==
X-Gm-Message-State: AOAM531MqaVmang/IJBWmIHIH6bLBX8Oh1FCRt7maU2ZU/4sYXFjxdwU
        nie98g4vMlaos5iNBflv3+2IqNoQgZRh8p5040WWUw==
X-Google-Smtp-Source: ABdhPJzdZNmEzEhSUZL1ZHMO7BvbclVRlL2jffCOQHICa7aGcxKRSnj1W3HmOslPWgZw0DOgy7bISju6p+ibJ0/2PbM=
X-Received: by 2002:a25:d016:: with SMTP id h22mr7312725ybg.278.1613002397125;
 Wed, 10 Feb 2021 16:13:17 -0800 (PST)
MIME-Version: 1.0
References: <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com> <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com> <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com> <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
 <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com> <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
 <CAEA6p_Bi1OMTas0W4VuxAMz8Frf+vBNc8c7xCDUxb_uwUy8Zgw@mail.gmail.com> <20210210040802-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210210040802-mutt-send-email-mst@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 10 Feb 2021 16:13:06 -0800
Message-ID: <CAEA6p_A+wYSdz+NwVEcJk-9pGs7X0tyZyAL_QvEB4E1+vYeiyw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 1:14 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Feb 09, 2021 at 10:00:22AM -0800, Wei Wang wrote:
> > On Tue, Feb 9, 2021 at 6:58 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > > >>> I have no preference. Just curious, especially if it complicates the patch.
> > > > >>>
> > > > >> My understanding is that. It's probably ok for net. But we probably need
> > > > >> to document the assumptions to make sure it was not abused in other drivers.
> > > > >>
> > > > >> Introduce new parameters for find_vqs() can help to eliminate the subtle
> > > > >> stuffs but I agree it looks like a overkill.
> > > > >>
> > > > >> (Btw, I forget the numbers but wonder how much difference if we simple
> > > > >> remove the free_old_xmits() from the rx NAPI path?)
> > > > > The committed patchset did not record those numbers, but I found them
> > > > > in an earlier iteration:
> > > > >
> > > > >    [PATCH net-next 0/3] virtio-net tx napi
> > > > >    https://lists.openwall.net/netdev/2017/04/02/55
> > > > >
> > > > > It did seem to significantly reduce compute cycles ("Gcyc") at the
> > > > > time. For instance:
> > > > >
> > > > >      TCP_RR Latency (us):
> > > > >      1x:
> > > > >        p50              24       24       21
> > > > >        p99              27       27       27
> > > > >        Gcycles         299      432      308
> > > > >
> > > > > I'm concerned that removing it now may cause a regression report in a
> > > > > few months. That is higher risk than the spurious interrupt warning
> > > > > that was only reported after years of use.
> > > >
> > > >
> > > > Right.
> > > >
> > > > So if Michael is fine with this approach, I'm ok with it. But we
> > > > probably need to a TODO to invent the interrupt handlers that can be
> > > > used for more than one virtqueues. When MSI-X is enabled, the interrupt
> > > > handler (vring_interrup()) assumes the interrupt is used by a single
> > > > virtqueue.
> > >
> > > Thanks.
> > >
> > > The approach to schedule tx-napi from virtnet_poll_cleantx instead of
> > > cleaning directly in this rx-napi function was not effective at
> > > suppressing the warning, I understand.
> >
> > Correct. I tried the approach to schedule tx napi instead of directly
> > do free_old_xmit_skbs() in virtnet_poll_cleantx(). But the warning
> > still happens.
>
> Two questions here: is the device using packed or split vqs?
> And is event index enabled?
>

The device is indeed using split vqs with event index enabled.

> I think one issue is that at the moment with split and event index we
> don't actually disable events at all.
>
You mean we don't disable 'interrupts' right?
What is the reason for that?

> static void virtqueue_disable_cb_split(struct virtqueue *_vq)
> {
>         struct vring_virtqueue *vq = to_vvq(_vq);
>
>         if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
>                 vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
>                 if (!vq->event)
>                         vq->split.vring.avail->flags =
>                                 cpu_to_virtio16(_vq->vdev,
>                                                 vq->split.avail_flags_shadow);
>         }
> }
>
> Can you try your napi patch + disable event index?
>

Thanks for the suggestion.
I've run the reproducer with  napi patch + disable event index, and so
far, I did not see the warning getting triggered. Will keep it running
for a bit longer.

>
> --
> MST
>
