Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A731535E00D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345959AbhDMN2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbhDMN2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:28:05 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB6CC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:27:46 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id l9so18180913ybm.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFpLB8DIBaYGwxlQWaPSNY6O41QeyPIXs1swuZ8gAsc=;
        b=ki3+aqqGlvi7IPzprReKeRHALl45saSRifTnATBrV8quvF9zINoIHLeV8qPd+A6uDt
         +dh/PXmEr2LL2ALb2eX0A5XDS6j3n6PhJAAnRs+WPuxQwr15QpLModi4QqC4bSIq0IA4
         wkiiobqLlTEpvJvj2B0axX36KG85ZlqqgMxN2MlLQ49HPynhQSePOMUz+hvR7EzUe6AZ
         zOx8RCh6eCncG8UNy6mZyryMVwQctO4XOOo6Dje5gwcjEDGb+X+e9qBSQvdMSHvtz4Od
         S4/i/qBd5OXoRiEAc3+j+ClVkBvZTbu5JbUCogC/lknhQZj6EOiCGzfIoxHizVS0dROJ
         CCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFpLB8DIBaYGwxlQWaPSNY6O41QeyPIXs1swuZ8gAsc=;
        b=gue+6AReHish06VaOYxPogwIUnaKQ7WFsAqBgyqxK54/TEuS7lSbSPzfd444HVgO/7
         KGZDyXYfbP4DmtWO80qE50q5ldNxROnB7d7T36VCVVI3lNjHfAAbDc3CIEySzxL3HYi0
         TXXkPZVDsoG7eA2Udv1ILcQVu0xT5eSVwJoscGwNblkRvvwABuYKmxiDD+baCh7Gm+Ec
         ke1JMgE607hHkm40/woOY7lBeizS+/vESRRYj3DEmI3Mdp22LE2PQ+OaJmG3/HwGGjVP
         JLWqQleaSmzNuwatrEIcJU+QVtYVfTi56xsRHI4wCtI1F51sSzhy4rK4kMdaicwmOV2q
         D9RA==
X-Gm-Message-State: AOAM532Zlj/RQqk0E70iig++tU4tTIOuX3IwlvgczCAEfMWePaK458uR
        ce6jCZiZTLxuof31BnhERWuh2dk+AAYsUJ+1blqoZA==
X-Google-Smtp-Source: ABdhPJxQZPXL+J7Pw71LOKFZotyLZciqj3G9dLrB8M03xC7UnUbEcgv2LeMk4ByFuKLKewvaUHpH1Zqar6AC3+PSBxU=
X-Received: by 2002:a5b:e90:: with SMTP id z16mr2404490ybr.303.1618320465203;
 Tue, 13 Apr 2021 06:27:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
 <CANn89i+sYS_x8D5hASKNgmc-k3P7B9JGY9mU1aBwhqHuAkwnBQ@mail.gmail.com> <20210413085538-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210413085538-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 13 Apr 2021 15:27:33 +0200
Message-ID: <CANn89iJODpHFAAZt0X-EewnbwKgeLPYpb=0GPRqqZmU9=12R6g@mail.gmail.com>
Subject: Re: Linux 5.12-rc7
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 2:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Apr 12, 2021 at 06:47:07PM +0200, Eric Dumazet wrote:
> > On Mon, Apr 12, 2021 at 6:31 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > >
> > > > > Qemu test results:
> > > > >         total: 460 pass: 459 fail: 1
> > > > > Failed tests:
> > > > >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> > > > >
> > > > > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > > > > skb->head"). It is a spurious problem - the test passes roughly every other
> > > > > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > > > > with SIGTERM. So far I have only seen this with the "sh" architecture.
> > > >
> > > > Hmm. Let's add in some more of the people involved in that commit, and
> > > > also netdev.
> > > >
> > > > Nothing in there looks like it should have any interaction with
> > > > architecture, so that "it happens on sh" sounds odd, but maybe it's
> > > > some particular interaction with the qemu environment.
> > >
> > > Yes, maybe.
> > >
> > > I spent few hours on this, and suspect a buggy memcpy() implementation
> > > on SH, but this was not conclusive.
> > >
> > > By pulling one extra byte, the problem goes away.
> > >
> > > Strange thing is that the udhcpc process does not go past sendto().
> >
> > This is the patch working around the issue. Unfortunately I was not
> > able to root-cause it (I really suspect something on SH)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 0824e6999e49957f7aaf7c990f6259792d42f32b..fd890a951beea03bdf24406809042666eb972655
> > 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -408,11 +408,17 @@ static struct sk_buff *page_to_skb(struct
> > virtnet_info *vi,
> >
> >         /* Copy all frame if it fits skb->head, otherwise
> >          * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> > +        *
> > +        * Apparently, pulling only the Ethernet Header triggers a bug
> > on qemu-system-sh4.
> > +        * Since GRO aggregation really cares of IPv4/IPv6, pull 20 bytes
> > +        * more to work around this bug : These 20 bytes can not belong
> > +        * to UDP/TCP payload.
> > +        * As a bonus, this makes GRO slightly faster for IPv4 (one less copy).
> >          */
>
> Question: do we still want to do this for performance reasons?
> We also have the hdr_len coming from the device which is
> just skb_headlen on the host.

Well, putting 20 bytes in skb->head will disable frag0 optimization.

The change would only benefit to sh architecture :)

About hdr_len, I suppose we could try it, with appropriate safety checks.

>
> >         if (len <= skb_tailroom(skb))
> >                 copy = len;
> >         else
> > -               copy = ETH_HLEN + metasize;
> > +               copy = ETH_HLEN + sizeof(struct iphdr) + metasize;
> >         skb_put_data(skb, p, copy);
> >
> >         if (metasize) {
>
