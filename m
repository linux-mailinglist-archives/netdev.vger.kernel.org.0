Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F4835CEE4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245610AbhDLQvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345722AbhDLQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:47:48 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C9EC061343
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:47:21 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c123so10009543qke.1
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8w9EURUSJ/JlzH1y4R+2PQ2Woxija1EBoUQCQMeXIhk=;
        b=Y8VPlPzKH66v2WroMYwSo+VqXKTtIovqXmBxaR88iNXTknh/KKaMSLvqwXsRat50wb
         yD9jTZtrbKJCdBP6P4CZ03nPpfD0SAF81QcX/UECPZQZ0bWmlKODyyVSivXdoZKmRxuP
         6APSXxsq6EtWmhYE1Ns92R+l8j/Solvv09wg64P+eMXzwOiIRDP8tXOiLbQgaRaRSdfQ
         r80xWyx/5PtBJCQJT/njtfZNZ9kUGbZqkJqZOzVnIcnkw1qTlhElP2Xa3X7h4oU6LHWy
         0HwFUg2oluEWJC6CNw2uA4lJu5SFVGMQsVaQZgzO2+wpzS5IeAah0LZ2wN/8Ugn0aG8B
         xK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8w9EURUSJ/JlzH1y4R+2PQ2Woxija1EBoUQCQMeXIhk=;
        b=WdQr4Nz5/6lnw7QcI6Z2eskyhZPCb3dch6Cs/TTmRYxd+E5hVUHFiaOTI/R9oFhWTI
         TE3ADh0NsU+WopypHW9qXl3cT/Ru1vGML54cbbJBAO0pRTbIZfWTKBAwPzb9/UqV++42
         o+C2ITLit9W7JtwXgKxnPe7Cfn0SJ+LfPEIwnyB4+61tag/LBwPPYNTJ0XFOdqY3K8m0
         ZkN5mSYnG1qJM7dXbVOlxEkz8zup7Dkfb5OWmbGUjNdi4uN8vzUCY10c2luBbE7wlf7F
         sReu1FwtcIssaULmVTKQePFv7lQef3B0WNMkDiM9URGabXGOCPmJjbhwovH45WB9iRnQ
         +CTw==
X-Gm-Message-State: AOAM5338JwgWB/dVswDRnYeNse+7MB8EBawgn9LEOe/V+MYkwlUtVYUt
        ZzwrLt6arr9Bo20bcaW6TXkDY+ai7EImWuMoXZVNgw==
X-Google-Smtp-Source: ABdhPJz9fBvbM4XHx1uojO8mBo3giiBwXBSUd5XBxlO6lGGJeZqumr+MM9otn8fqTpoUMRG3aT5MrZr6iB1Be3zOJrc=
X-Received: by 2002:a05:6902:4d2:: with SMTP id v18mr38476903ybs.303.1618246039093;
 Mon, 12 Apr 2021 09:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
In-Reply-To: <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Apr 2021 18:47:07 +0200
Message-ID: <CANn89i+sYS_x8D5hASKNgmc-k3P7B9JGY9mU1aBwhqHuAkwnBQ@mail.gmail.com>
Subject: Re: Linux 5.12-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 6:31 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > Qemu test results:
> > >         total: 460 pass: 459 fail: 1
> > > Failed tests:
> > >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> > >
> > > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > > skb->head"). It is a spurious problem - the test passes roughly every other
> > > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > > with SIGTERM. So far I have only seen this with the "sh" architecture.
> >
> > Hmm. Let's add in some more of the people involved in that commit, and
> > also netdev.
> >
> > Nothing in there looks like it should have any interaction with
> > architecture, so that "it happens on sh" sounds odd, but maybe it's
> > some particular interaction with the qemu environment.
>
> Yes, maybe.
>
> I spent few hours on this, and suspect a buggy memcpy() implementation
> on SH, but this was not conclusive.
>
> By pulling one extra byte, the problem goes away.
>
> Strange thing is that the udhcpc process does not go past sendto().

This is the patch working around the issue. Unfortunately I was not
able to root-cause it (I really suspect something on SH)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0824e6999e49957f7aaf7c990f6259792d42f32b..fd890a951beea03bdf24406809042666eb972655
100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -408,11 +408,17 @@ static struct sk_buff *page_to_skb(struct
virtnet_info *vi,

        /* Copy all frame if it fits skb->head, otherwise
         * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
+        *
+        * Apparently, pulling only the Ethernet Header triggers a bug
on qemu-system-sh4.
+        * Since GRO aggregation really cares of IPv4/IPv6, pull 20 bytes
+        * more to work around this bug : These 20 bytes can not belong
+        * to UDP/TCP payload.
+        * As a bonus, this makes GRO slightly faster for IPv4 (one less copy).
         */
        if (len <= skb_tailroom(skb))
                copy = len;
        else
-               copy = ETH_HLEN + metasize;
+               copy = ETH_HLEN + sizeof(struct iphdr) + metasize;
        skb_put_data(skb, p, copy);

        if (metasize) {
