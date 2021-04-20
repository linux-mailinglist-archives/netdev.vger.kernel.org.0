Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB39365ED5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhDTRxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDTRxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 13:53:34 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B42C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 10:53:02 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id g38so43987205ybi.12
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 10:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Yy5aIK7mUu0wzwYHioto+tDrclA8MaRFgoC8XStUKk=;
        b=KfO5gUVL+5TVuwraobxt/POtKLdn/4BBZZJiiC2XahOK0V1hDpeBb/bEQQXrFBCdYX
         Y7OOs9cCzYxXYtU/X4rBauI5P0sSXhoRsrcpYNs+yJYI2r55TJbAPmQqf5A8rT41Smtg
         IWgjB6rgX8/yc7I7uk1C/4YbbEHPHU4ND9r7xsPbT0ZqTP0+N7IIpSaVaVTlU9ZF9YZz
         W6tgB8RgDd47p0PyVt+T/HeN8FezE9qr9WLdgJKZKA327zxzUGV/vmEtyaC24MG615wr
         Az6GkNz7advUpyUoVyVwbDLUWL4Q6d4QAwkcb8+G446R42N89bwWLo4SQJggMLOvBo8g
         Kk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Yy5aIK7mUu0wzwYHioto+tDrclA8MaRFgoC8XStUKk=;
        b=ljn11jdgYSAAART3NaWHeteaNCbgHCyv2fTRxgkReCY6O5VUedAPfuIGdEPBA0xGHK
         TqRq6xt+1+rI2eBIeEZGy96dMhD+udgWNZsOP/hIjbKsLpvwc6KAjtCeVwvsXhh3K+2B
         hBqt3QgtEEkCJPGbtV1PIbtiQDNG9GI2T2sCHwuYKxiPoLTXrDXf1eHSYzr44bsnlfVY
         7PCscp/0N8IaPS0NAhtY9t6Kcwa5W2+gXUWplVLZzpxdBRLSzyM4S5RIZ8oCiO4nM6rA
         AB9fhAtvYHPk0bjndXtl/k8brgnMsQLe7ld2uIqMLX5eoZLXCTXP461MhLoZEJjveSP+
         NXdw==
X-Gm-Message-State: AOAM532CxLEY3oIhQXxyYA0gvrE5bn7HMrrMT+dkKMacZhXZUs0N76n2
        e+qtUBgYwtDLgTcERZAnk+pHBe33PDXgbeBpwzEdJw==
X-Google-Smtp-Source: ABdhPJzeN/HyIqn4TWYBH7fQTlP+PJkdzbjTDqqCHP/RYwvhimVzVLGjqubfNrflrpIOT6E+AbK2UJXeMvaOFTitjZI=
X-Received: by 2002:a25:8284:: with SMTP id r4mr11343829ybk.234.1618941181628;
 Tue, 20 Apr 2021 10:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210420094341.3259328-1-eric.dumazet@gmail.com>
 <c5a8aeaf-0f41-9274-b9c5-ec385b34180a@roeck-us.net> <CANn89iKMbUtDhU+B5dFJDABUSJJ3rnN0PWO0TDY=mRYEbNpHZw@mail.gmail.com>
 <20210420154240.GA115350@roeck-us.net> <CANn89iKqx69Xe9x3BzDrybqwgAfiASXZ8nOC7KN8dmADonOBxw@mail.gmail.com>
 <335cc59c-47c4-2781-7146-6c671c2ee62c@roeck-us.net>
In-Reply-To: <335cc59c-47c4-2781-7146-6c671c2ee62c@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Apr 2021 19:52:50 +0200
Message-ID: <CANn89i+827gp1=9naMbd3Mf+Jo+z7OX_forZEa7rGj4_VpLJBA@mail.gmail.com>
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 7:51 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/20/21 9:31 AM, Eric Dumazet wrote:
> > On Tue, Apr 20, 2021 at 5:42 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> On Tue, Apr 20, 2021 at 04:00:07PM +0200, Eric Dumazet wrote:
> >>> On Tue, Apr 20, 2021 at 3:48 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >>>>
> >>>> On 4/20/21 2:43 AM, Eric Dumazet wrote:
> >>>
> >>>>>
> >>>>
> >>>> Unfortunately that doesn't fix the problem for me. With this patch applied
> >>>> on top of next-20210419, I still get the same crash as before:
> >>>>
> >>>> udhcpc: sending discover^M
> >>>> Unable to handle kernel paging request at virtual address 0000000000000004^M
> >>>> udhcpc(169): Oops -1^M
> >>>> pc = [<0000000000000004>]  ra = [<fffffc0000b8c5b8>]  ps = 0000    Not tainted^M
> >>>> pc is at 0x4^M
> >>>> ra is at napi_gro_receive+0x68/0x150^M
> >>>> v0 = 0000000000000000  t0 = 0000000000000008  t1 = 0000000000000000^M
> >>>> t2 = 0000000000000000  t3 = 000000000000000e  t4 = 0000000000000038^M
> >>>> t5 = 000000000000ffff  t6 = fffffc00002f298a  t7 = fffffc0002c78000^M
> >>>> s0 = fffffc00010b3ca0  s1 = 0000000000000000  s2 = fffffc00011267e0^M
> >>>> s3 = 0000000000000000  s4 = fffffc00025f2008  s5 = fffffc00002f2940^M
> >>>> s6 = fffffc00025f2040^M
> >>>> a0 = fffffc00025f2008  a1 = fffffc00002f2940  a2 = fffffc0002ca000c^M
> >>>> a3 = fffffc00000250d0  a4 = 0000000effff0008  a5 = 0000000000000000^M
> >>>> t8 = fffffc00010b3c80  t9 = fffffc0002ca04cc  t10= 0000000000000000^M
> >>>> t11= 00000000000004c0  pv = fffffc0000b8bc40  at = 0000000000000000^M
> >>>> gp = fffffc00010f9fb8  sp = 00000000df74db09^M
> >>>> Disabling lock debugging due to kernel taint^M
> >>>> Trace:^M
> >>>> [<fffffc0000b8c5b8>] napi_gro_receive+0x68/0x150^M
> >>>> [<fffffc00009b409c>] receive_buf+0x50c/0x1b80^M
> >>>> [<fffffc00009b58b8>] virtnet_poll+0x1a8/0x5b0^M
> >>>> [<fffffc00009b58ec>] virtnet_poll+0x1dc/0x5b0^M
> >>>> [<fffffc0000b8d17c>] __napi_poll+0x4c/0x270^M
> >>>> [<fffffc0000b8d670>] net_rx_action+0x130/0x2c0^M
> >>>> [<fffffc0000bd6cb0>] sch_direct_xmit+0x170/0x360^M
> >>>> [<fffffc0000bd7000>] __qdisc_run+0x160/0x6c0^M
> >>>> [<fffffc0000337b64>] do_softirq+0xa4/0xd0^M
> >>>> [<fffffc0000337ca4>] __local_bh_enable_ip+0x114/0x120^M
> >>>> [<fffffc0000b89554>] __dev_queue_xmit+0x484/0xa60^M
> >>>> [<fffffc0000cd072c>] packet_sendmsg+0xe7c/0x1ba0^M
> >>>> [<fffffc0000b53338>] __sys_sendto+0xf8/0x170^M
> >>>> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
> >>>> [<fffffc0000a9bf7c>] ehci_irq+0x2cc/0x5c0^M
> >>>> [<fffffc0000a71334>] usb_hcd_irq+0x34/0x50^M
> >>>> [<fffffc0000b521bc>] move_addr_to_kernel+0x3c/0x60^M
> >>>> [<fffffc0000b532e4>] __sys_sendto+0xa4/0x170^M
> >>>> [<fffffc0000b533d4>] sys_sendto+0x24/0x40^M
> >>>> [<fffffc0000cfea38>] _raw_spin_lock+0x18/0x30^M
> >>>> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
> >>>> [<fffffc0000325298>] clipper_enable_irq+0x98/0x100^M
> >>>> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
> >>>> [<fffffc0000311514>] entSys+0xa4/0xc0^M
> >>>
> >>> OK, it would be nice if you could get line number from this stack trace.
> >>>
> >>
> >> Here you are:
> >>
> >> napi_gro_receive (net/core/dev.c:6196)
> >> receive_buf (drivers/net/virtio_net.c:1150)
> >> virtnet_poll (drivers/net/virtio_net.c:1414 drivers/net/virtio_net.c:1519)
> >> clipper_srm_device_interrupt (arch/alpha/kernel/sys_dp264.c:256)
> >> virtnet_poll (drivers/net/virtio_net.c:1413 drivers/net/virtio_net.c:1519)
> >> __napi_poll (net/core/dev.c:6962)
> >> net_rx_action (net/core/dev.c:7029 net/core/dev.c:7116)
> >> __qdisc_run (net/sched/sch_generic.c:376 net/sched/sch_generic.c:384)
> >> do_softirq (./include/asm-generic/softirq_stack.h:10 kernel/softirq.c:460 kernel/softirq.c:447)
> >> __local_bh_enable_ip (kernel/softirq.c:384)
> >> __dev_queue_xmit (./include/linux/bottom_half.h:32 ./include/linux/rcupdate.h:746 net/core/dev.c:4272)
> >> packet_sendmsg (net/packet/af_packet.c:3009 net/packet/af_packet.c:3034)
> >> __sys_sendto (net/socket.c:654 net/socket.c:674 net/socket.c:1977)
> >> __d_alloc (fs/dcache.c:1744)
> >> packet_create (net/packet/af_packet.c:1192 net/packet/af_packet.c:3296)
> >> move_addr_to_kernel (./include/linux/uaccess.h:192 net/socket.c:198 net/socket.c:192)
> >> __sys_sendto (net/socket.c:1968)
> >> sys_sendto (net/socket.c:1989 net/socket.c:1985)
> >> sys_bind (net/socket.c:1648 net/socket.c:1646)
> >> entSys (arch/alpha/kernel/entry.S:477)
> >>
> >> Guenter
> >
> > OK, I guess we are back to unaligned access, right ?
> > I guess sh arch should have failed as well ?
> >
>
> sh does indeed fail, with the same symptoms as before, but so far I was not
> able to track it down to a specific commit. The alpha failure is different,
> though. It is a NULL pointer access.

Not sure alpha linux kernel deals nicely with unaligned trap ?

>
> Anyway, testing ...
>
> The patch below does indeed fix the problem I am seeing on sh.
>
> ... and it does fix the alpha problem as well. Neat, though I don't really understand
> what a NULL pointer access and an unaligned access have to do with each other.
>
> Great catch, thanks!
>
> Guenter
>
>
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 8cd76037c72481200ea3e8429e9fdfec005dad85..0579914d3dd84c24982c1ff85314cc7b8d0f8d2d
> > 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -415,7 +415,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >
> >         shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >
> > -       if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> > +       if (len > GOOD_COPY_LEN && tailroom >= shinfo_size &&
> > +           (!NET_IP_ALIGN || ((unsigned long)p & 3) == 2)) {
> >                 skb = build_skb(p, truesize);
> >                 if (unlikely(!skb))
> >                         return NULL;
> >
>
