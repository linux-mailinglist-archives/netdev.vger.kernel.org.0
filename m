Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3156E2A0129
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgJ3JV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3JV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:21:56 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE7CC0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:56 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dn5so5851722edb.10
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLh+BHHSUwKboUA6vpQcLpEkW+PQh5zESptmxIr/pVs=;
        b=wUI2LIhKAfEvhnay/UsRnRkXb0SdITwCO3T0/HHEJqwmwBmVFPKUU3wZ+TRCFBJMLC
         MUdPhcmohNJZX19YThKp56tPa4Srp2V1c3dRAdDpKizlLT8IcncIoH4rcFTnkg3phwXb
         NG/BJU14c0kJGsWnSoJONnq740VO4L2M17v4cleQxVWsZ91Cr+gkEaiViz55Pi/JYAVy
         V2y503ZCiGbd1jZUtmqprYFt43E/mNlJP2+pz9fqOTNh3ZgEbuY6Hg7WFAq2Bpwe4t5U
         j0xq++CRar7vn+DAcukO3mmzOUQRAI4A8w4DjIB5/VILjKebRw6hbBqo1DzFwVbFA469
         Xghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLh+BHHSUwKboUA6vpQcLpEkW+PQh5zESptmxIr/pVs=;
        b=TnkeK44gfBpJYlAYAA22beKTA60O0+Ejve5aD0BvKUrii7AOuv5ZGclNxwpWWqP9Go
         Asfru7jgiKAEDOM8FcyH+sdAKyajZYp7MUP6hF6LSohStu5mj6iK3DWqE2Fo69vg/Bva
         G9Z2jvLWE+C8H9wtDBF5K8RKjXScxiaFJS9AjPGSr1atgYOad1SBl0rKC/jsA7Sz0jWB
         2WQSqxyIe43AfDzl2YH8PZq8OJZvwAwuo6baNSWc1LKISOoCe9fHNXaPZTkYnrluF8a8
         wUhlBjrkBvgEVSB6czJSSd0g4XOD+0bVpNjlS82Lh2kBsZH3hNsHZYk/C99JnpMf9ohE
         dpEQ==
X-Gm-Message-State: AOAM533qgI4TGlEvjUjVQVlSWiYbVcJs7aYp3I0NQLmFip861qQTFCPY
        HgHt6r0PSFb7qsF47qNdFqOuBSeibJ3iHy/DhZqJYQ==
X-Google-Smtp-Source: ABdhPJxIRx9T86r/1wHaiq6Gqs8jF1qhUjW6tC0PrgTqVN12R1Ox7oeSumPDx7r8wFtTTFJ0i+VLWF2RfBET4m8LKwo=
X-Received: by 2002:a05:6402:8cc:: with SMTP id d12mr1265271edz.134.1604049714599;
 Fri, 30 Oct 2020 02:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <1603902898-25233-1-git-send-email-loic.poulain@linaro.org>
 <1603902898-25233-2-git-send-email-loic.poulain@linaro.org> <20201030081351.GA3818@Mani-XPS-13-9360>
In-Reply-To: <20201030081351.GA3818@Mani-XPS-13-9360>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 30 Oct 2020 10:27:45 +0100
Message-ID: <CAMZdPi99Ap8h0vE4+W+n2rbmUjhaG_VpkCxr6kg-f5nz94Lpxg@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] net: Add mhi-net driver
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 at 09:14, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> Hi Loic,
>
> On Wed, Oct 28, 2020 at 05:34:58PM +0100, Loic Poulain wrote:
> > This patch adds a new network driver implementing MHI transport for
> > network packets. Packets can be in any format, though QMAP (rmnet)
> > is the usual protocol (flow control + PDN mux).
> >
> > It support two MHI devices, IP_HW0 which is, the path to the IPA
> > (IP accelerator) on qcom modem, And IP_SW0 which is the software
> > driven IP path (to modem CPU).
> >
>
> This patch looks good to me. I just commented few nits inline. With those
> addressed, you can have my:
>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>


Thanks for your review Mani, going to address that points in v9.

>
> Thanks,
> Mani
>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >   v2: - rebase on net-next
> >       - remove useless skb_linearize
> >       - check error type on mhi_queue return
> >       - rate limited errors
> >       - Schedule RX refill only on 'low' buf level
> >       - SET_NETDEV_DEV in probe
> >       - reorder device remove sequence
> >   v3: - Stop channels on net_register error
> >       - Remove useles parentheses
> >       - Add driver .owner
> >   v4: - prevent potential cpu hog in rx-refill loop
> >       - Access mtu via READ_ONCE
> >   v5: - Fix access to u64 stats
> >   v6: - Stop TX queue earlier if queue is full
> >       - Preventing 'abnormal' NETDEV_TX_BUSY path
> >   v7: - Stop dl/ul cb operations on channel resetting
> >   v8: - remove premature comment about TX threading gain
> >       - check rx_queued to determine queuing limits
> >       - fix probe error path (unified goto usage)
> >
> >  drivers/net/Kconfig   |   7 ++
> >  drivers/net/Makefile  |   1 +
> >  drivers/net/mhi_net.c | 313 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 321 insertions(+)
> >  create mode 100644 drivers/net/mhi_net.c
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index 1368d1d..11a6357 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -426,6 +426,13 @@ config VSOCKMON
> >         mostly intended for developers or support to debug vsock issues. If
> >         unsure, say N.
> >
> > +config MHI_NET
> > +     tristate "MHI network driver"
> > +     depends on MHI_BUS
> > +     help
> > +       This is the network driver for MHI.  It can be used with
>
> network driver for MHI bus.
>
> > +       QCOM based WWAN modems (like SDX55).  Say Y or M.
> > +
> >  endif # NET_CORE
> >
> >  config SUNGEM_PHY
> > diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> > index 94b6080..8312037 100644
> > --- a/drivers/net/Makefile
> > +++ b/drivers/net/Makefile
> > @@ -34,6 +34,7 @@ obj-$(CONFIG_GTP) += gtp.o
> >  obj-$(CONFIG_NLMON) += nlmon.o
> >  obj-$(CONFIG_NET_VRF) += vrf.o
> >  obj-$(CONFIG_VSOCKMON) += vsockmon.o
> > +obj-$(CONFIG_MHI_NET) += mhi_net.o
> >
> >  #
> >  # Networking Drivers
> > diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> > new file mode 100644
> > index 0000000..4ba146d
> > --- /dev/null
> > +++ b/drivers/net/mhi_net.c
> > @@ -0,0 +1,313 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* MHI Network driver - Network over MHI
>
> Network over MHI bus.
>
> > + *
> > + * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
> > + */
> > +
> > +#include <linux/if_arp.h>
> > +#include <linux/mhi.h>
> > +#include <linux/mod_devicetable.h>
> > +#include <linux/module.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/u64_stats_sync.h>
> > +
> > +#define MIN_MTU              ETH_MIN_MTU
> > +#define MAX_MTU              0xffff
> > +#define DEFAULT_MTU  16384
>
> Please add a prefix to avoid namespace issues in future...
>
> > +
> > +struct mhi_net_stats {
> > +     u64_stats_t rx_packets;
> > +     u64_stats_t rx_bytes;
> > +     u64_stats_t rx_errors;
> > +     u64_stats_t rx_dropped;
> > +     u64_stats_t tx_packets;
> > +     u64_stats_t tx_bytes;
> > +     u64_stats_t tx_errors;
> > +     u64_stats_t tx_dropped;
> > +     atomic_t rx_queued;
> > +     struct u64_stats_sync tx_syncp;
> > +     struct u64_stats_sync rx_syncp;
> > +};
> > +
> > +struct mhi_net_dev {
> > +     struct mhi_device *mdev;
> > +     struct net_device *ndev;
> > +     struct delayed_work rx_refill;
> > +     struct mhi_net_stats stats;
> > +     u32 rx_queue_sz;
> > +};
> > +
>
> [...]
>
> > +static void mhi_net_rx_refill_work(struct work_struct *work)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> > +                                                   rx_refill.work);
> > +     struct net_device *ndev = mhi_netdev->ndev;
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     int size = READ_ONCE(ndev->mtu);
> > +     struct sk_buff *skb;
> > +     int err;
> > +
> > +     do {
> > +             skb = netdev_alloc_skb(ndev, size);
> > +             if (unlikely(!skb))
> > +                     break;
> > +
> > +             err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> > +             if (unlikely(err)) {
> > +                     net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> > +                                         ndev->name, err);
> > +                     kfree_skb(skb);
> > +                     break;
> > +             }
> > +
> > +             /* Do not hog the CPU if rx buffers are completed faster than
> > +              * queued (unlikely).
>
> s/completed/consumed
>
> > +              */
> > +             cond_resched();
> > +     } while (atomic_inc_return(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz);
> > +
> > +     /* If we're still starved of rx buffers, reschedule later */
> > +     if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> > +             schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> > +}
> > +
> > +static int mhi_net_probe(struct mhi_device *mhi_dev,
> > +                      const struct mhi_device_id *id)
> > +{
> > +     const char *netname = (char *)id->driver_data;
> > +     struct mhi_net_dev *mhi_netdev;
> > +     struct net_device *ndev;
> > +     struct device *dev = &mhi_dev->dev;
> > +     int err;
>
> Since this is a networking driver, please stick to reverse xmas tree order for
> local variables.
