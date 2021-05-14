Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C70380412
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhENHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:18:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232997AbhENHRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620976603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bs6XAiqm+++NgmbBMX048ZVKuxbmYHB+gyl0ZWTysSo=;
        b=DMnA5UIqQNrSNLAX5qn9ZpHc02ihGmUxJX8ZFZCe7OZ6rL4ofejVyKCDg6AUKdtJ/bIKMf
        QyXOohJh0Fs48FOZPhLN4SuXj4nmMvSjhVUUySwFSseh5W0y6B+3T3M4385otcoE+58Fm7
        cata/kL9c4PWvN0ul3XrN0hFL3xxnog=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-mZrX33JIPnCFBrx4tc02aw-1; Fri, 14 May 2021 03:16:36 -0400
X-MC-Unique: mZrX33JIPnCFBrx4tc02aw-1
Received: by mail-lj1-f199.google.com with SMTP id g6-20020a05651c0446b02900dee525f111so15595757ljg.19
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bs6XAiqm+++NgmbBMX048ZVKuxbmYHB+gyl0ZWTysSo=;
        b=ZawIqS1FHESlV3hGaXLuDAo5kavfptEJ+TCmU0TYrIJIqSR698kMkN9gk6hwScGFrL
         iGb0DAJIeXQWoXMrk1zdOXWT50gH2GcBlNlaHQRMETjLvi6yXGARnTtebuC2Cd0ptCh0
         ci+hocHA7mQj8lvhou9ogHcrEKerZAB5aHQo1YgovTlEYmzSwq2qOye4qs+NM43qUtKX
         KEwnmS1YOmHEgTBlsAF7YK/X2wCef5m1CMSRsUb2MUkLvZcnxnarAKChTAakEmR6OTQk
         ArAQKxWhbzEBTjgP/85epK2np+fovmxE6ae+cNsP01IkG7Hj/04IMJvIJc4/FP86fkUY
         b0yQ==
X-Gm-Message-State: AOAM53072ObdY3FGP3B1Ug4z8iU/P6kyye5QgxsBWPF0fvAqNXvBJ9Kb
        Ccmi5rSvpb+7M0bQ1yRAKIycxP/yFx5Umb9UzSUllgGIlBtEXnM8bx7f10YiLmsm5DwI/IEZgJY
        p0MhsK0W/oxTqfA8Kyp46s/0wp5a1Abm7
X-Received: by 2002:a05:6512:1027:: with SMTP id r7mr13858030lfr.153.1620976595398;
        Fri, 14 May 2021 00:16:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylEHgvD1At56XNI5YMYNsfY9iCPgmWpzVeYV6PPpvkCHSx7kuHth0tuPQkubc2oMXxR1C5ZImuUDudNmzwUls=
X-Received: by 2002:a05:6512:1027:: with SMTP id r7mr13858008lfr.153.1620976595150;
 Fri, 14 May 2021 00:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com> <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
 <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
 <89759261-3a72-df6c-7a81-b7a48abfad44@redhat.com> <CAOEp5Ocm9Q69Fv=oeyCs01F9J4nCTPiOPpw9_BRZ0WnF+LtEFQ@mail.gmail.com>
 <CACGkMEsZBCzV+d_eLj1aYT+pkS5m1QAy7q8rUkNsdV0C8aL8tQ@mail.gmail.com>
 <CAOEp5OeSankfA6urXLW_fquSMrZ+WYXDtKNacort1UwR=WgxqA@mail.gmail.com>
 <CACGkMEt3bZrdqbWtWjSkXvv5v8iCHiN8hkD3T602RZnb6nPd9A@mail.gmail.com>
 <CAOEp5Odw=eaQWZCXr+U8PipPtO1Avjw-t3gEdKyvNYxuNa5TfQ@mail.gmail.com>
 <CACGkMEuqXaJxGqC+CLoq7k4XDu+W3E3Kk3WvG-D6tnn2K4ZPNA@mail.gmail.com>
 <CAOEp5OfB62SQzxMj_GkVD4EM=Z+xf43TPoTZwMbPPa3BsX2ooA@mail.gmail.com>
 <CACGkMEu4NdyMoFKbyUGG1aGX+K=ShMZuVuMKYPauEBYz5pxYzA@mail.gmail.com> <CA+FuTScV+AJ+O3shOMLjUcy+PjBE8uWqCNt0FXWnq9L3gzrvaw@mail.gmail.com>
In-Reply-To: <CA+FuTScV+AJ+O3shOMLjUcy+PjBE8uWqCNt0FXWnq9L3gzrvaw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 14 May 2021 15:16:23 +0800
Message-ID: <CACGkMEuUF1vDNWbL9dRr1ZM4vFTLwc3j9uB-66451U1NvQ+2EA@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Yuri Benditovich <yuri.benditovich@daynix.com>,
        Yan Vugenfirer <yan@daynix.com>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 4:35 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > > But surprisingly when TUN receives TUN_F_UFO it does not propagate it
> > > anywhere, there is no corresponding NETIF flag.
> >
> > (It looks like I drop the community and other ccs accidentally, adding
> > them back and sorry)
> >
> > Actually, there is one, NETIF_F_GSO_UDP.
> >
> > Kernel used to have NETIF_F_UFO, but it was removed due to bugs and
> > the lack of real hardware support. Then we found it breaks uABI, so
> > Willem tries to make it appear for userspace again, and then it was
> > renamed to NETIF_F_GSO_UDP.
> >
> > But I think it's a bug that we don't proporate TUN_F_UFO to NETIF
> > flag, this is a must for the driver that doesn't support
> > VIRTIO_NET_F_GUEST_UFO. I just try to disable all offloads and
> > mrg_rxbuf, then netperf UDP_STREAM from host to guest gives me bad
> > length packet in the guest.
> >
> > Willem, I think we probably need to fix this.
>
> We had to add back support for the kernel to accept UFO packets from
> userspace over tuntap.
>
> The kernel does not generate such packets, so a guest should never be
> concerned of receiving UFO packets.

That's my feeling as well.

But when I:

1) turn off all guest gso feature and mrg rx buffers, in this case
virtio-net will only allocate 1500 bytes for each packet
2) doing netperf (UDP_STREAM) from local host to guest, I see packet
were truncated in the guest

>
> Perhaps i'm misunderstanding the problem here.
>

I will re-check and get back to you.
(probably need a while since I will not be online for the next week).

Thanks

