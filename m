Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB05320A08
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 12:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhBULeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 06:34:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhBULeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 06:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613907189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZdeToMlanriOSyztn4NGDqzCE8kvs/AecJfz5xeD8Z0=;
        b=Mc9iLoQdP3g6rinB1V6O8v+R/Ymsr8l4NEMrnOO48+vUIQvUr3zJEx+4KK0feS2IO9Z4d3
        IuBqr3yT2RiqDiLo9zf9VrG3drbCmV4fSEqGHF/guopeT9y4pnqn2YoUnfVodGPPtmgGX1
        ouvchzVYjxDrajpgc4c1L1edloK3SJ0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-FGW12hsZMz2-27lBIwV5CQ-1; Sun, 21 Feb 2021 06:33:05 -0500
X-MC-Unique: FGW12hsZMz2-27lBIwV5CQ-1
Received: by mail-ed1-f72.google.com with SMTP id l23so5460208edt.23
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 03:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZdeToMlanriOSyztn4NGDqzCE8kvs/AecJfz5xeD8Z0=;
        b=NrAZU2PoEKRsWLdxi6/cW7+Chx+VqLE9sX/ypM3MVa3ii0f3P+HpKrfWRBGmQYG3Bf
         rCJAfMYgpxF4ZHDCJotAoytx8bENOJDOT1JFy9FBclPcyW7ySA1ZRPLcW5xARDzueIzi
         NhMLkmnZsPJ22QW4i3Yx3NHmLQbZTs7+qij1Q7kUtFUsNjR55pNqv7EyPzVBh6Y7HQxR
         Xv0Gs7CFtXpfPF8klepG3FH8kC8MZNuietv6rxOttbqZilH0vmuE0ZcpFmdIWfu5MQsR
         dfhq74DBIq/MaQMUmjhic5BNzHe9/UGxOYNSuCd4wFyW7bJ+kB3Vrb2uXZ2vihY7WqTm
         R9ew==
X-Gm-Message-State: AOAM531NZiDDzllitYc4x3NGMrrc6JSmh2Z3Ik4VnYmatKUkAsQph61D
        6bVh5TJyCSE1j6FM7v8IxzAMEzsRHVS6UruR3qtZzSnj8PWUIjpUbUp0GfJunq5cus+ETaHyFMb
        YHIRripqWNyIU6xU2
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr17682508edu.163.1613907184707;
        Sun, 21 Feb 2021 03:33:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwysqToGXs1mj8BQr9Sl+WDxGXmrKJUDqrnRhGVkCh4wUJ3SCYBAutr931huSXsnrIPk7pjoA==
X-Received: by 2002:a05:6402:46:: with SMTP id f6mr17682494edu.163.1613907184423;
        Sun, 21 Feb 2021 03:33:04 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id da12sm6921507edb.52.2021.02.21.03.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 03:33:03 -0800 (PST)
Date:   Sun, 21 Feb 2021 06:33:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210221062810-mutt-send-email-mst@kernel.org>
References: <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com>
 <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com>
 <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
 <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com>
 <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
 <CAEA6p_Bi1OMTas0W4VuxAMz8Frf+vBNc8c7xCDUxb_uwUy8Zgw@mail.gmail.com>
 <20210210040802-mutt-send-email-mst@kernel.org>
 <9b077d6c-aeca-8266-4579-fae02c8b31de@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b077d6c-aeca-8266-4579-fae02c8b31de@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 01:39:19PM +0800, Jason Wang wrote:
> 
> On 2021/2/10 下午5:14, Michael S. Tsirkin wrote:
> > On Tue, Feb 09, 2021 at 10:00:22AM -0800, Wei Wang wrote:
> > > On Tue, Feb 9, 2021 at 6:58 AM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > > > > > I have no preference. Just curious, especially if it complicates the patch.
> > > > > > > > 
> > > > > > > My understanding is that. It's probably ok for net. But we probably need
> > > > > > > to document the assumptions to make sure it was not abused in other drivers.
> > > > > > > 
> > > > > > > Introduce new parameters for find_vqs() can help to eliminate the subtle
> > > > > > > stuffs but I agree it looks like a overkill.
> > > > > > > 
> > > > > > > (Btw, I forget the numbers but wonder how much difference if we simple
> > > > > > > remove the free_old_xmits() from the rx NAPI path?)
> > > > > > The committed patchset did not record those numbers, but I found them
> > > > > > in an earlier iteration:
> > > > > > 
> > > > > >     [PATCH net-next 0/3] virtio-net tx napi
> > > > > >     https://lists.openwall.net/netdev/2017/04/02/55
> > > > > > 
> > > > > > It did seem to significantly reduce compute cycles ("Gcyc") at the
> > > > > > time. For instance:
> > > > > > 
> > > > > >       TCP_RR Latency (us):
> > > > > >       1x:
> > > > > >         p50              24       24       21
> > > > > >         p99              27       27       27
> > > > > >         Gcycles         299      432      308
> > > > > > 
> > > > > > I'm concerned that removing it now may cause a regression report in a
> > > > > > few months. That is higher risk than the spurious interrupt warning
> > > > > > that was only reported after years of use.
> > > > > 
> > > > > Right.
> > > > > 
> > > > > So if Michael is fine with this approach, I'm ok with it. But we
> > > > > probably need to a TODO to invent the interrupt handlers that can be
> > > > > used for more than one virtqueues. When MSI-X is enabled, the interrupt
> > > > > handler (vring_interrup()) assumes the interrupt is used by a single
> > > > > virtqueue.
> > > > Thanks.
> > > > 
> > > > The approach to schedule tx-napi from virtnet_poll_cleantx instead of
> > > > cleaning directly in this rx-napi function was not effective at
> > > > suppressing the warning, I understand.
> > > Correct. I tried the approach to schedule tx napi instead of directly
> > > do free_old_xmit_skbs() in virtnet_poll_cleantx(). But the warning
> > > still happens.
> > Two questions here: is the device using packed or split vqs?
> > And is event index enabled?
> > 
> > I think one issue is that at the moment with split and event index we
> > don't actually disable events at all.
> 
> 
> Do we really have a way to disable that? (We don't have a flag like packed
> virtqueue)
> 
> Or you mean the trick [1] when I post tx interrupt RFC?
> 
> Thanks
> 
> [1] https://lkml.org/lkml/2015/2/9/113

Something like this. Or basically any other value will do,
e.g. move the index back to a value just signalled ...

> 
> > 
> > static void virtqueue_disable_cb_split(struct virtqueue *_vq)
> > {
> >          struct vring_virtqueue *vq = to_vvq(_vq);
> > 
> >          if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
> >                  vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> >                  if (!vq->event)
> >                          vq->split.vring.avail->flags =
> >                                  cpu_to_virtio16(_vq->vdev,
> >                                                  vq->split.avail_flags_shadow);
> >          }
> > }
> > 
> > Can you try your napi patch + disable event index?
> > 
> > 

