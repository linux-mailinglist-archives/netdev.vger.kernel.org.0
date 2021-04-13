Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D345735E0B9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhDMN6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:58:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhDMN6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618322310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N6aEgVCEoy+49hpLG7PzhDVD4jebtkLcDUAJoYDQrlA=;
        b=XhKDI5q1uJ7cSu1qVAjRbmmb/1HwSICspkod+PhbZLQUxRNXe7tdmU3yiQ8RzQpeZCgfo2
        V7ZRteVe4oyC6CWCcRe4Mm8vH2E74Nw0v46YFt+HZfJtlJUd2ByESPrltnC9wdC7jVjiu0
        XujeCSYJRXqMtsS2WphHc1ZH9Rkb5b4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-kWt6NLGcMy6ggWZ0e_uhzQ-1; Tue, 13 Apr 2021 09:58:29 -0400
X-MC-Unique: kWt6NLGcMy6ggWZ0e_uhzQ-1
Received: by mail-wr1-f72.google.com with SMTP id t17so805410wrn.12
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N6aEgVCEoy+49hpLG7PzhDVD4jebtkLcDUAJoYDQrlA=;
        b=hxf9zoUGSt0W2deJE2BgAJxa2t7xLrU+r40WZxcXpKYPMJq9PggTHqkAgH1b8BRyj7
         3NjOysxaWxz2/yVrb45kAw4Q/9/wvBcgO6xaXCIbN6AeJveBSvavkUdr0L9Jr5OmxdY0
         mMVmWdNdvQAMjUlCt+0WZaEQA/++SbRNTzIgxYAwD0CVglvVlkSU1RV8/eUT2Q9ZjmQf
         5z7AuAuRRHwxVpRLf/sFCOW3eNIrYGx/HdV3owwTJCcLHtbZhByLiUNAtDEQ4JTnCMPr
         dJgIBvXSqj6OoVy0mJGGEgFlCLL1RXKhbV76KY1iGImGpkZmrsxQkVhO1l6W4CBwGAn0
         WbnQ==
X-Gm-Message-State: AOAM533olxPIuLNLgCE6SsNYUfCrvhsQ4kMWPXptA9Vn07xYrMZRrsvO
        n71G11aMF4Mtj9QO2sr73uaOShjp03R3AIvFSUOL1dpPMYObokTeNWnCn8q5g3kVv46FWC5A1zc
        fDxmVAA6UJASXEscY
X-Received: by 2002:a05:6000:249:: with SMTP id m9mr12430457wrz.13.1618322307811;
        Tue, 13 Apr 2021 06:58:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqlUzPfeUpVOZejUytVOPbXufBpfqSXRYMWREcueUUvC0kJ1n+ZnQJKVrsq2z5fqCYItcPng==
X-Received: by 2002:a05:6000:249:: with SMTP id m9mr12430436wrz.13.1618322307635;
        Tue, 13 Apr 2021 06:58:27 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id x23sm2551469wmj.43.2021.04.13.06.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:58:27 -0700 (PDT)
Date:   Tue, 13 Apr 2021 09:58:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: Linux 5.12-rc7
Message-ID: <20210413095539-mutt-send-email-mst@kernel.org>
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net>
 <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
 <CANn89i+sYS_x8D5hASKNgmc-k3P7B9JGY9mU1aBwhqHuAkwnBQ@mail.gmail.com>
 <20210413085538-mutt-send-email-mst@kernel.org>
 <CANn89iJODpHFAAZt0X-EewnbwKgeLPYpb=0GPRqqZmU9=12R6g@mail.gmail.com>
 <CANn89iKrSDL9usw18uvVfarWRUBv=V4xTHOMEgS48jhNmzR5_A@mail.gmail.com>
 <20210413093606-mutt-send-email-mst@kernel.org>
 <CANn89iKB3x2T=8j5qBVVtStdQBASD-P6B1+yLKwLh+Y+PggB0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKB3x2T=8j5qBVVtStdQBASD-P6B1+yLKwLh+Y+PggB0A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:42:24PM +0200, Eric Dumazet wrote:
> On Tue, Apr 13, 2021 at 3:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Apr 13, 2021 at 03:33:40PM +0200, Eric Dumazet wrote:
> > > On Tue, Apr 13, 2021 at 3:27 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Apr 13, 2021 at 2:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Apr 12, 2021 at 06:47:07PM +0200, Eric Dumazet wrote:
> > > > > > On Mon, Apr 12, 2021 at 6:31 PM Eric Dumazet <edumazet@google.com> wrote:
> > > > > > >
> > > > > > > On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> > > > > > > <torvalds@linux-foundation.org> wrote:
> > > > > > > >
> > > > > > > > On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > > > > >
> > > > > > > > > Qemu test results:
> > > > > > > > >         total: 460 pass: 459 fail: 1
> > > > > > > > > Failed tests:
> > > > > > > > >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> > > > > > > > >
> > > > > > > > > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > > > > > > > > skb->head"). It is a spurious problem - the test passes roughly every other
> > > > > > > > > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > > > > > > > > with SIGTERM. So far I have only seen this with the "sh" architecture.
> > > > > > > >
> > > > > > > > Hmm. Let's add in some more of the people involved in that commit, and
> > > > > > > > also netdev.
> > > > > > > >
> > > > > > > > Nothing in there looks like it should have any interaction with
> > > > > > > > architecture, so that "it happens on sh" sounds odd, but maybe it's
> > > > > > > > some particular interaction with the qemu environment.
> > > > > > >
> > > > > > > Yes, maybe.
> > > > > > >
> > > > > > > I spent few hours on this, and suspect a buggy memcpy() implementation
> > > > > > > on SH, but this was not conclusive.
> > > > > > >
> > > > > > > By pulling one extra byte, the problem goes away.
> > > > > > >
> > > > > > > Strange thing is that the udhcpc process does not go past sendto().
> > > > > >
> > > > > > This is the patch working around the issue. Unfortunately I was not
> > > > > > able to root-cause it (I really suspect something on SH)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 0824e6999e49957f7aaf7c990f6259792d42f32b..fd890a951beea03bdf24406809042666eb972655
> > > > > > 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -408,11 +408,17 @@ static struct sk_buff *page_to_skb(struct
> > > > > > virtnet_info *vi,
> > > > > >
> > > > > >         /* Copy all frame if it fits skb->head, otherwise
> > > > > >          * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> > > > > > +        *
> > > > > > +        * Apparently, pulling only the Ethernet Header triggers a bug
> > > > > > on qemu-system-sh4.
> > > > > > +        * Since GRO aggregation really cares of IPv4/IPv6, pull 20 bytes
> > > > > > +        * more to work around this bug : These 20 bytes can not belong
> > > > > > +        * to UDP/TCP payload.
> > > > > > +        * As a bonus, this makes GRO slightly faster for IPv4 (one less copy).
> > > > > >          */
> > > > >
> > > > > Question: do we still want to do this for performance reasons?
> > > > > We also have the hdr_len coming from the device which is
> > > > > just skb_headlen on the host.
> > > >
> > > > Well, putting 20 bytes in skb->head will disable frag0 optimization.
> > > >
> > > > The change would only benefit to sh architecture :)
> > > >
> > > > About hdr_len, I suppose we could try it, with appropriate safety checks.
> > >
> > > I have added traces, hdr_len seems to be 0 with the qemu-system-sh4 I am using.
> > >
> > > Have I understood you correctly ?
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 0824e6999e49957f7aaf7c990f6259792d42f32b..f024860f7dc260d4efbc35a3b8ffd358bd0da894
> > > 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -399,9 +399,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > >                 hdr_padded_len = sizeof(struct padded_vnet_hdr);
> > >
> > >         /* hdr_valid means no XDP, so we can copy the vnet header */
> > > -       if (hdr_valid)
> > > +       if (hdr_valid) {
> > >                 memcpy(hdr, p, hdr_len);
> > > -
> > > +               pr_err("hdr->hdr_len=%u\n", hdr->hdr.hdr_len);
> > > +       }
> > >         len -= hdr_len;
> > >         offset += hdr_padded_len;
> > >         p += hdr_padded_len;
> >
> >
> > Depends on how you connect qemu on the host. It's filled by host tap,
> > see virtio_net_hdr_from_skb. If you are using slirp that just zero-fills
> > it.
> 
> Guenter provided :
> 
> qemu-system-sh4 -M r2d -kernel ./arch/sh/boot/zImage -no-reboot \
>         -snapshot \
>         -drive file=rootfs.ext2,format=raw,if=ide \
>         -device virtio-net,netdev=net0 -netdev user,id=net0 \
>         -append "root=/dev/sda console=ttySC1,115200
> earlycon=scif,mmio16,0xffe80000 noiotrap" \
>         -serial null -serial stdio -nographic -monitor null


I do something like this (macvtap):

sudo ip link del macvtap0
sudo ip link add link enp0s25 name macvtap0 type macvtap mode bridge
#sudo ip link add link wlp3s0 name macvtap0 type macvtap mode bridge
sudo ip link set macvtap0 address 52:54:00:12:34:56 up
index=`cat /sys/class/net/macvtap0/ifindex`
sudo chgrp mst /dev/tap$index
sudo chmod g+rw /dev/tap$index

and then

-netdev tap,fds=6,id=net0,vhost=on -device virtio-net,netdev=net0 \
    6<>/dev/tap$index


