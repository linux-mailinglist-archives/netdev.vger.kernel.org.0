Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55493161F3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBJJS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:18:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230388AbhBJJP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:15:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612948470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DTTShUwVJ0CrEkc+tYcazKGDX2AZYCkEtJJC3BlqDjo=;
        b=VM9NpJLSNyhSccz7er5P0aa5Bjk13+UsVXSFuOiC1rStb5OBipEfGSt1NCNciS2dij1OUw
        qx5p1Jcha2uo3TvijTitUD8+p6OXRS6mQIBWNB45OCg49PjtYmUvgHKUKi0hWHgtHr+Ker
        JkDQw9HvooVT7xdHuTLKTiXzeUmAhyI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-8sHDyxzrM8eMqT2gb3HZOQ-1; Wed, 10 Feb 2021 04:14:27 -0500
X-MC-Unique: 8sHDyxzrM8eMqT2gb3HZOQ-1
Received: by mail-wr1-f72.google.com with SMTP id s18so1340146wrf.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DTTShUwVJ0CrEkc+tYcazKGDX2AZYCkEtJJC3BlqDjo=;
        b=mYVZKRULnTVLwyheGjajWg80q0qsjBpJhwJPiMvEygll6hrvCFpZXD55ADdClwapMX
         YLLW2mLfW8/ce4yyz+unm+uVw9/Hl3u5AKHudVVQKcXmbulKj41QCCX8TcnExS+2WIEg
         OZuqtvHTlwMyZ87iMckgm5WSPoZ1UvQAe2NxdmPAUSWdZucT6pU9oB5yoAOWz38yQ3AU
         Vru08BrCxgJOFU+ifgjI/JZ9VoJKkCzIj1rTufKhZHmfNPZWyIxGAirAC01VkG3mTzf7
         kek66a02qRyjWFf074yKJCmOiaSauQWf4elFFVGzrUwI83ryRcgtXuPYUafUkhdcJgru
         WHUA==
X-Gm-Message-State: AOAM533roowcex7gqnnUrO6NkZJDnE9IuikIW7pNX1NakSJwpqv5THbQ
        j4RENfAerFaIaJLnHcp/h8pyAYfViItnbBmDMGb8MSF5tfJ1HgzjrdJDowcqbFgZqTRNfABaqav
        Xj2ZI2sDjrcPn1JFT
X-Received: by 2002:adf:f905:: with SMTP id b5mr2415512wrr.129.1612948465660;
        Wed, 10 Feb 2021 01:14:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVKNmX7F7uxfESFV+eOczVcXshzHHqofRNkNcRtOMdL/1msWkrIn0DfFr8uZOjZfXmBf8p7g==
X-Received: by 2002:adf:f905:: with SMTP id b5mr2415495wrr.129.1612948465499;
        Wed, 10 Feb 2021 01:14:25 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id l83sm1814553wmf.4.2021.02.10.01.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:14:24 -0800 (PST)
Date:   Wed, 10 Feb 2021 04:14:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <weiwan@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210210040802-mutt-send-email-mst@kernel.org>
References: <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com>
 <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com>
 <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com>
 <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
 <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com>
 <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
 <CAEA6p_Bi1OMTas0W4VuxAMz8Frf+vBNc8c7xCDUxb_uwUy8Zgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEA6p_Bi1OMTas0W4VuxAMz8Frf+vBNc8c7xCDUxb_uwUy8Zgw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 10:00:22AM -0800, Wei Wang wrote:
> On Tue, Feb 9, 2021 at 6:58 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > >>> I have no preference. Just curious, especially if it complicates the patch.
> > > >>>
> > > >> My understanding is that. It's probably ok for net. But we probably need
> > > >> to document the assumptions to make sure it was not abused in other drivers.
> > > >>
> > > >> Introduce new parameters for find_vqs() can help to eliminate the subtle
> > > >> stuffs but I agree it looks like a overkill.
> > > >>
> > > >> (Btw, I forget the numbers but wonder how much difference if we simple
> > > >> remove the free_old_xmits() from the rx NAPI path?)
> > > > The committed patchset did not record those numbers, but I found them
> > > > in an earlier iteration:
> > > >
> > > >    [PATCH net-next 0/3] virtio-net tx napi
> > > >    https://lists.openwall.net/netdev/2017/04/02/55
> > > >
> > > > It did seem to significantly reduce compute cycles ("Gcyc") at the
> > > > time. For instance:
> > > >
> > > >      TCP_RR Latency (us):
> > > >      1x:
> > > >        p50              24       24       21
> > > >        p99              27       27       27
> > > >        Gcycles         299      432      308
> > > >
> > > > I'm concerned that removing it now may cause a regression report in a
> > > > few months. That is higher risk than the spurious interrupt warning
> > > > that was only reported after years of use.
> > >
> > >
> > > Right.
> > >
> > > So if Michael is fine with this approach, I'm ok with it. But we
> > > probably need to a TODO to invent the interrupt handlers that can be
> > > used for more than one virtqueues. When MSI-X is enabled, the interrupt
> > > handler (vring_interrup()) assumes the interrupt is used by a single
> > > virtqueue.
> >
> > Thanks.
> >
> > The approach to schedule tx-napi from virtnet_poll_cleantx instead of
> > cleaning directly in this rx-napi function was not effective at
> > suppressing the warning, I understand.
> 
> Correct. I tried the approach to schedule tx napi instead of directly
> do free_old_xmit_skbs() in virtnet_poll_cleantx(). But the warning
> still happens.

Two questions here: is the device using packed or split vqs?
And is event index enabled?

I think one issue is that at the moment with split and event index we
don't actually disable events at all.

static void virtqueue_disable_cb_split(struct virtqueue *_vq)
{
        struct vring_virtqueue *vq = to_vvq(_vq);

        if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
                vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
                if (!vq->event)
                        vq->split.vring.avail->flags =
                                cpu_to_virtio16(_vq->vdev,
                                                vq->split.avail_flags_shadow);
        }
}

Can you try your napi patch + disable event index?


-- 
MST

