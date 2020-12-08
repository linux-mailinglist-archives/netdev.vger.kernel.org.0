Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC982D35AC
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgLHVz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 16:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgLHVz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 16:55:26 -0500
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDADC061794;
        Tue,  8 Dec 2020 13:54:46 -0800 (PST)
Received: by mail-vk1-xa42.google.com with SMTP id b190so63860vka.0;
        Tue, 08 Dec 2020 13:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HR742pSiozhDUPorvG6dtxyKOv7q/SNwr6kisht7zzA=;
        b=h4T0raMh3KbTUvZ3AtEZnAJ+RNv/5sWKxDoJ4Us2l1UBl7knAE13nyuHSFrDRzYxQ/
         +xtBjJn3so3TjyFcZGNNIEFWn76LcRzfksgNbqIpfQizCNbyNTCIeoBpnj46adOhaGpW
         fJQaJYHP8+2XsjkypZ7Y4riwLL0SQlcBv47pPPxgKl9j/eIbO+IXGLJ4p5OWGzH3DLJ7
         TDj5YyrimCHlWpA0ZFrdgna3yYERfdnuJkQoyuKEq7drEd69g4n/xJz8/L2lAFDRZ+TF
         rO/YJI8qbErhwUlCwyBkql+2eDYjrJ2icrHb3F+rkHwOfqtM956YKbbDrT+yoBgYvQel
         OG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HR742pSiozhDUPorvG6dtxyKOv7q/SNwr6kisht7zzA=;
        b=r35qZ5hh8AEmnujFwpUmpQ4pLPkTLE4VX3hb82Ow4tG6MOs6gTtD4FG4yrmAvuVQZX
         ECqiTEjFRr0wJMpN9h85LhesXYJYnga4N/KOORVfZmuZEvc+1HZuT93dzikjiimbbAaO
         EGWmwvjGqcJTtwjnuaSIQW6xserSfPQxhPXh07xRWp5RcguT6s3/pVcwP7HhjoBdgHBR
         dteViHIzwTxlWTKP8aQbfR1/oXN91CaPXl/aks++PKszNjb9QFBfSROZZyFxj83q61Mj
         /aA2RfgFG92Ks7CbanUpzKYovizGwS2slQHnflavzCU1ct+kYOukGPsEcIaEAxU5IoN6
         cPxQ==
X-Gm-Message-State: AOAM530msUslFx5SwHMKxkEdY+KVfTAP+PQNQoEf1g04xjmv+5dwGqUF
        ThlLuM1LLgSJX4xD8V1U9UZNNiAVUZech7Rmrlc=
X-Google-Smtp-Source: ABdhPJwClku4a+kRFN2kpMmxUeEoRZvBWlSISSn096dijLJ8C2hF/on6fRQtls+JjaMLhT4Dt65tcOirmrHQcIhQwR0=
X-Received: by 2002:a1f:5587:: with SMTP id j129mr19403233vkb.0.1607464484835;
 Tue, 08 Dec 2020 13:54:44 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 16:54:33 -0500
Message-ID: <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, thank you so much for reviewing this patchset !

On Tue, Dec 8, 2020 at 2:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > When the chip is working with the default 1500 byte MTU, a 9K
> > dma buffer goes from chip -> cpu per 1500 byte frame. This means
> > that to get 1G/s ethernet bandwidth, we need 6G/s PCIe bandwidth !
> >
> > Fix by limiting the rx ring dma buffer size to the current MTU
> > size.
>
> I'd guess this is a memory allocate issue, not a bandwidth thing.
> for 9K frames the driver needs to do order-2 allocations of 16K.
> For 1500 2K allocations are sufficient (which is < 1 page, hence
> a lot cheaper).

That's a good question. I used perf to create a flame graph of what
the cpu was doing when receiving data at high speed. It showed that
__dma_page_dev_to_cpu took up most of the cpu time. Which is triggered
by dma_unmap_single(9K, DMA_FROM_DEVICE).

So I assumed that it's a PCIe dma bandwidth issue, but I could be wrong -
I didn't do any PCIe bandwidth measurements.

>
> > Tested with iperf3 on a freescale imx6 + lan7430, both sides
> > set to mtu 1500 bytes.
> >
> > Before:
> > [ ID] Interval           Transfer     Bandwidth       Retr
> > [  4]   0.00-20.00  sec   483 MBytes   203 Mbits/sec    0
> > After:
> > [ ID] Interval           Transfer     Bandwidth       Retr
> > [  4]   0.00-20.00  sec  1.15 GBytes   496 Mbits/sec    0
> >
> > And with both sides set to MTU 9000 bytes:
> > Before:
> > [ ID] Interval           Transfer     Bandwidth       Retr
> > [  4]   0.00-20.00  sec  1.87 GBytes   803 Mbits/sec   27
> > After:
> > [ ID] Interval           Transfer     Bandwidth       Retr
> > [  4]   0.00-20.00  sec  1.98 GBytes   849 Mbits/sec    0
> >
> > Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> > Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
>
> This is a performance improvement, not a fix, it really needs to target
> net-next.

I thought it'd be cool if 'historic' kernels could benefit from this performance
improvement too, but yeah if it's against policy it should go into net-next.

What about the other patch in the patchset (ping-pong). Should it go into
net-next as well?

>
> > diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> > index ebb5e0bc516b..2bded1c46784 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> > @@ -1957,11 +1957,11 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
> >
> >  static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
> >  {
> > -     int length = 0;
> > +     struct net_device *netdev = rx->adapter->netdev;
> >
> > -     length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
> > -     return __netdev_alloc_skb(rx->adapter->netdev,
> > -                               length, GFP_ATOMIC | GFP_DMA);
> > +     return __netdev_alloc_skb(netdev,
> > +                               netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING,
> > +                               GFP_ATOMIC | GFP_DMA);
> >  }
> >
> >  static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
> > @@ -1969,9 +1969,10 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
> >  {
> >       struct lan743x_rx_buffer_info *buffer_info;
> >       struct lan743x_rx_descriptor *descriptor;
> > -     int length = 0;
> > +     struct net_device *netdev = rx->adapter->netdev;
> > +     int length;
> >
> > -     length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
> > +     length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
> >       descriptor = &rx->ring_cpu_ptr[index];
> >       buffer_info = &rx->buffer_info[index];
> >       buffer_info->skb = skb;
> > @@ -2157,8 +2158,8 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
> >                       int index = first_index;
> >
> >                       /* multi buffer packet not supported */
> > -                     /* this should not happen since
> > -                      * buffers are allocated to be at least jumbo size
> > +                     /* this should not happen since buffers are allocated
> > +                      * to be at least the mtu size configured in the mac.
> >                        */
> >
> >                       /* clean up buffers */
> > @@ -2632,9 +2633,13 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
> >       struct lan743x_adapter *adapter = netdev_priv(netdev);
> >       int ret = 0;
> >
> > +     if (netif_running(netdev))
> > +             return -EBUSY;
>
> That may cause a regression to users of the driver who expect to be
> able to set the MTU when the device is running. You need to disable
> the NAPI, pause the device, swap the buffers for smaller / bigger ones
> and restart the device.

That's what I tried first, but I quickly ran into a spot of trouble:
restarting the device may fail (unlikely but possible). So when the user tries
to change the mtu and that errors out, they might end up with a stopped device.
Is that acceptable behaviour? If so, I'll add it to the patch.

>
> >       ret = lan743x_mac_set_mtu(adapter, new_mtu);
> >       if (!ret)
> >               netdev->mtu = new_mtu;
> > +
> >       return ret;
> >  }
> >
>
