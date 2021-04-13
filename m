Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8C35E021
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhDMNeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbhDMNeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:34:12 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DF9C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:33:52 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id c195so18127867ybf.9
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/mG+7TE16wzw/LGXUKa6TF83xtW+W10dYBi8pyRFa14=;
        b=OLTBZP0bcHIYA1nkyTqCRAIuZVEnm4coraIOfgxBfh4T1U1N2PkRjWVQp+2VHcR2q8
         o2cTUSinxfLr9SiIURiqhAvFLW4S6cp1sLyAz3k+WteVb9i6e9I0NY9W2nj+IGx4YvEf
         XhJ6fQg6AQn49w4tB61crL797RMM6oV0/eVjzEHUG5yZPeBhFX4tt2J8EL+UfZFc53VR
         JtqR3i0/EqEwUZkXVMQTR4ra1qzmEcjn+/B+WVgtJonHPuaz34K8zwnrDzyntC3zrbDT
         j7CmUNa1bQOzwjfN1APM5kcqBvHMltadOJN0GJy9BGDUhU9j2gYwJ00uPaQe9QzJ5VkR
         OrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/mG+7TE16wzw/LGXUKa6TF83xtW+W10dYBi8pyRFa14=;
        b=d4uKamiR2ln2CJPkpf/hmKOwQg7ojppQsEhEoKVVrC1a4yEu/yk3y+aLWLOja+9wLz
         QxxMRFgZf4/hxzVCZClORubRjRilRGQqUBki3H7BpXSeJNnzFhX9WiLXMYcPUgoa/2Ja
         L9iO52tJ+/uf1Y8RdEjdJR2dVJGWVgHPFqICTKPfiU/bSCTKLL58DO12XJ+Ft+HBck6O
         Lz9uNSwxC2QcoA7CT27wO/F4V7j+IJBJlUp8B0TwiADkzqinOKEuAbObFE7TkGe3DhuN
         +6GFlaRqQAkRVd8yaOOwq/d1k4QJt5HapaSvq1dC2kkaGkEr3VyM3PYHjNyFLYtneLUu
         kO4A==
X-Gm-Message-State: AOAM530Jupc0wKqkWVPMC2P9k5h2Ooqeybrm6NgwgPQ+bYp+w2Dz+fbA
        4u2aRHqe9s8/8lidsgggQRpJ/vYIkDmSOURC6fSEWQ==
X-Google-Smtp-Source: ABdhPJx+a/0Kjw/SH+spYnpjGIWsUIuP/HVEQCrjziPZiNBlpIDz5PkXdNyxAVg4Mtpd9ItQ4u+6gRdjjbbfwrlMa0Y=
X-Received: by 2002:a25:850b:: with SMTP id w11mr45509205ybk.518.1618320831671;
 Tue, 13 Apr 2021 06:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
 <CANn89i+sYS_x8D5hASKNgmc-k3P7B9JGY9mU1aBwhqHuAkwnBQ@mail.gmail.com>
 <20210413085538-mutt-send-email-mst@kernel.org> <CANn89iJODpHFAAZt0X-EewnbwKgeLPYpb=0GPRqqZmU9=12R6g@mail.gmail.com>
In-Reply-To: <CANn89iJODpHFAAZt0X-EewnbwKgeLPYpb=0GPRqqZmU9=12R6g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 13 Apr 2021 15:33:40 +0200
Message-ID: <CANn89iKrSDL9usw18uvVfarWRUBv=V4xTHOMEgS48jhNmzR5_A@mail.gmail.com>
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

On Tue, Apr 13, 2021 at 3:27 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Apr 13, 2021 at 2:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Apr 12, 2021 at 06:47:07PM +0200, Eric Dumazet wrote:
> > > On Mon, Apr 12, 2021 at 6:31 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > >
> > > > > On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > >
> > > > > > Qemu test results:
> > > > > >         total: 460 pass: 459 fail: 1
> > > > > > Failed tests:
> > > > > >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> > > > > >
> > > > > > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > > > > > skb->head"). It is a spurious problem - the test passes roughly every other
> > > > > > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > > > > > with SIGTERM. So far I have only seen this with the "sh" architecture.
> > > > >
> > > > > Hmm. Let's add in some more of the people involved in that commit, and
> > > > > also netdev.
> > > > >
> > > > > Nothing in there looks like it should have any interaction with
> > > > > architecture, so that "it happens on sh" sounds odd, but maybe it's
> > > > > some particular interaction with the qemu environment.
> > > >
> > > > Yes, maybe.
> > > >
> > > > I spent few hours on this, and suspect a buggy memcpy() implementation
> > > > on SH, but this was not conclusive.
> > > >
> > > > By pulling one extra byte, the problem goes away.
> > > >
> > > > Strange thing is that the udhcpc process does not go past sendto().
> > >
> > > This is the patch working around the issue. Unfortunately I was not
> > > able to root-cause it (I really suspect something on SH)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 0824e6999e49957f7aaf7c990f6259792d42f32b..fd890a951beea03bdf24406809042666eb972655
> > > 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -408,11 +408,17 @@ static struct sk_buff *page_to_skb(struct
> > > virtnet_info *vi,
> > >
> > >         /* Copy all frame if it fits skb->head, otherwise
> > >          * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> > > +        *
> > > +        * Apparently, pulling only the Ethernet Header triggers a bug
> > > on qemu-system-sh4.
> > > +        * Since GRO aggregation really cares of IPv4/IPv6, pull 20 bytes
> > > +        * more to work around this bug : These 20 bytes can not belong
> > > +        * to UDP/TCP payload.
> > > +        * As a bonus, this makes GRO slightly faster for IPv4 (one less copy).
> > >          */
> >
> > Question: do we still want to do this for performance reasons?
> > We also have the hdr_len coming from the device which is
> > just skb_headlen on the host.
>
> Well, putting 20 bytes in skb->head will disable frag0 optimization.
>
> The change would only benefit to sh architecture :)
>
> About hdr_len, I suppose we could try it, with appropriate safety checks.

I have added traces, hdr_len seems to be 0 with the qemu-system-sh4 I am using.

Have I understood you correctly ?

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0824e6999e49957f7aaf7c990f6259792d42f32b..f024860f7dc260d4efbc35a3b8ffd358bd0da894
100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -399,9 +399,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
                hdr_padded_len = sizeof(struct padded_vnet_hdr);

        /* hdr_valid means no XDP, so we can copy the vnet header */
-       if (hdr_valid)
+       if (hdr_valid) {
                memcpy(hdr, p, hdr_len);
-
+               pr_err("hdr->hdr_len=%u\n", hdr->hdr.hdr_len);
+       }
        len -= hdr_len;
        offset += hdr_padded_len;
        p += hdr_padded_len;
