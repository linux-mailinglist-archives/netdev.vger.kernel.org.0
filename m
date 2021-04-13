Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5D35E041
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346042AbhDMNjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:39:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346022AbhDMNit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618321109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HYGa/3UIOk9T3rLD/aoY1nbvR6OlkCYFIF7xKrNQws8=;
        b=J8su+qPj+0d8hwOhH5NiyndnO14cifR6CkQklZQ89WdQUCxDoSQ3/Dq5IE0jFCumfao753
        ZfAKuJile/1jZQPYiEpDa9e0oPrUDyHdSagk/3HU1zrpgygVRNgvZ4WvE4ijxaRxWu/RbO
        fvBjsOURzzuBhXxgmCoSJQEZ9zj429w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-v3cVOj5BMXuEOUmGwvOyGg-1; Tue, 13 Apr 2021 09:38:02 -0400
X-MC-Unique: v3cVOj5BMXuEOUmGwvOyGg-1
Received: by mail-wm1-f70.google.com with SMTP id o21-20020a05600c4fd5b02901132a38a0c7so2774710wmq.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HYGa/3UIOk9T3rLD/aoY1nbvR6OlkCYFIF7xKrNQws8=;
        b=V7wc1L5c/byJ89lMpo4scfqktKkW4PFippGLWmpl57KZZF5rAt9nXsKYoEQ+UfoM5g
         BScN2RZ2IgF95f8BhaQTx0jvKfCoSakxrqMTMf6tMc0W7G5pFkASljlr3o7/dg/BtaF6
         lUzAP7Y4gG7jYgzR5ELnYo1Lxr8acACJ4nt2z9KxFK3i/tAdK5k2Ha4HU7hrVvbdCMfQ
         jIoZrHdv2ZfhbVamku0IvMjIzvXImz8r9srautvk6h0+CZNn9PvUU7uA9hsPS/9DuogR
         TPAcWcFiO3+nXfEw9QrwVHtX7IQOHDcH368hEQ2eFtCu6zip9CHMpU6jn2A9GX8jj5Ce
         wslQ==
X-Gm-Message-State: AOAM533Ix8NckX+Wgz+T2MXNGYaKwi9lRK6BKqm7klh0Cw7dw5QjaYhA
        LCn1kY0iPb4d5QJlkHTHOpJTugWDBF5fqw+Fv6N5VJsuZKb4KdveaUkoPutVL3U0oNs0Urj7aEs
        xba2LXJJ0luGjLJFh
X-Received: by 2002:a05:6000:120b:: with SMTP id e11mr8418212wrx.299.1618321080719;
        Tue, 13 Apr 2021 06:38:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9UDf0d05H+onvOc9AxMyE1Cxi1QOcwdFwbsDkDWYofB3k9/JZ/ZyfcQ7vmaDWvRdbwEWuDQ==
X-Received: by 2002:a05:6000:120b:: with SMTP id e11mr8418201wrx.299.1618321080570;
        Tue, 13 Apr 2021 06:38:00 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id q18sm17427501wrs.25.2021.04.13.06.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:37:59 -0700 (PDT)
Date:   Tue, 13 Apr 2021 09:37:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 5.12-rc7
Message-ID: <20210413093606-mutt-send-email-mst@kernel.org>
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net>
 <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
 <CANn89i+sYS_x8D5hASKNgmc-k3P7B9JGY9mU1aBwhqHuAkwnBQ@mail.gmail.com>
 <20210413085538-mutt-send-email-mst@kernel.org>
 <CANn89iJODpHFAAZt0X-EewnbwKgeLPYpb=0GPRqqZmU9=12R6g@mail.gmail.com>
 <CANn89iKrSDL9usw18uvVfarWRUBv=V4xTHOMEgS48jhNmzR5_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKrSDL9usw18uvVfarWRUBv=V4xTHOMEgS48jhNmzR5_A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:33:40PM +0200, Eric Dumazet wrote:
> On Tue, Apr 13, 2021 at 3:27 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Apr 13, 2021 at 2:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Apr 12, 2021 at 06:47:07PM +0200, Eric Dumazet wrote:
> > > > On Mon, Apr 12, 2021 at 6:31 PM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> > > > > <torvalds@linux-foundation.org> wrote:
> > > > > >
> > > > > > On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > > >
> > > > > > > Qemu test results:
> > > > > > >         total: 460 pass: 459 fail: 1
> > > > > > > Failed tests:
> > > > > > >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> > > > > > >
> > > > > > > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > > > > > > skb->head"). It is a spurious problem - the test passes roughly every other
> > > > > > > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > > > > > > with SIGTERM. So far I have only seen this with the "sh" architecture.
> > > > > >
> > > > > > Hmm. Let's add in some more of the people involved in that commit, and
> > > > > > also netdev.
> > > > > >
> > > > > > Nothing in there looks like it should have any interaction with
> > > > > > architecture, so that "it happens on sh" sounds odd, but maybe it's
> > > > > > some particular interaction with the qemu environment.
> > > > >
> > > > > Yes, maybe.
> > > > >
> > > > > I spent few hours on this, and suspect a buggy memcpy() implementation
> > > > > on SH, but this was not conclusive.
> > > > >
> > > > > By pulling one extra byte, the problem goes away.
> > > > >
> > > > > Strange thing is that the udhcpc process does not go past sendto().
> > > >
> > > > This is the patch working around the issue. Unfortunately I was not
> > > > able to root-cause it (I really suspect something on SH)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 0824e6999e49957f7aaf7c990f6259792d42f32b..fd890a951beea03bdf24406809042666eb972655
> > > > 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -408,11 +408,17 @@ static struct sk_buff *page_to_skb(struct
> > > > virtnet_info *vi,
> > > >
> > > >         /* Copy all frame if it fits skb->head, otherwise
> > > >          * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> > > > +        *
> > > > +        * Apparently, pulling only the Ethernet Header triggers a bug
> > > > on qemu-system-sh4.
> > > > +        * Since GRO aggregation really cares of IPv4/IPv6, pull 20 bytes
> > > > +        * more to work around this bug : These 20 bytes can not belong
> > > > +        * to UDP/TCP payload.
> > > > +        * As a bonus, this makes GRO slightly faster for IPv4 (one less copy).
> > > >          */
> > >
> > > Question: do we still want to do this for performance reasons?
> > > We also have the hdr_len coming from the device which is
> > > just skb_headlen on the host.
> >
> > Well, putting 20 bytes in skb->head will disable frag0 optimization.
> >
> > The change would only benefit to sh architecture :)
> >
> > About hdr_len, I suppose we could try it, with appropriate safety checks.
> 
> I have added traces, hdr_len seems to be 0 with the qemu-system-sh4 I am using.
> 
> Have I understood you correctly ?
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0824e6999e49957f7aaf7c990f6259792d42f32b..f024860f7dc260d4efbc35a3b8ffd358bd0da894
> 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -399,9 +399,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>                 hdr_padded_len = sizeof(struct padded_vnet_hdr);
> 
>         /* hdr_valid means no XDP, so we can copy the vnet header */
> -       if (hdr_valid)
> +       if (hdr_valid) {
>                 memcpy(hdr, p, hdr_len);
> -
> +               pr_err("hdr->hdr_len=%u\n", hdr->hdr.hdr_len);
> +       }
>         len -= hdr_len;
>         offset += hdr_padded_len;
>         p += hdr_padded_len;


Depends on how you connect qemu on the host. It's filled by host tap,
see virtio_net_hdr_from_skb. If you are using slirp that just zero-fills
it.


-- 
MST

