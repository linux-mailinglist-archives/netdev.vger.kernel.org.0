Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D452D73FD
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389463AbgLKKeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731901AbgLKKeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:34:11 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20206C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:33:31 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b73so8785738edf.13
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yw3efIQANBQ8XwRRejxkA4LweO/AkPMImHnUupXkGnU=;
        b=WUQfEFtdMKmUzpLO55go+pjz4hv5r/4Hp3ljJLcKSSeGl0k7W9OBEsq6qKVk79vFb0
         FPvFaA7kwloQ7Ps1xVqkg8taTAXe0Iwu/igoXMr96Oqd9qy8x+fTrYWAOr/sUNR/UPHu
         oGPD0nj9xI98+gjlQlQsPQkXM77UkkcD6XJRjvpVtgHKW39xO55kZjfh/wkny9/9K57j
         RbvluFJAWAq50a2ubLDtyOxD0KsK0N5oOBX6xTGHHTDYvWVMZ5ca3TXoHZCzVkiBL+x4
         EXICfbHMeqro8QbviCufa6w3Em5BV48QLvhI0CRUBpQnQyOvmWjahVx096e6jrulezR3
         5d3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yw3efIQANBQ8XwRRejxkA4LweO/AkPMImHnUupXkGnU=;
        b=ek2vRRiqndMegdUiP5S2UCNGA54KKxosH2qqSaFUqs2iuXlw3dVcXJyTX5ypt50lLW
         KvgPnPw1VtPsl+F1hPD4fIbREr7T1DfFn6j9lGGI5ar5Dmx3E7YLkkUXG6qD0NlGQq3s
         f9Xtx16x9+zEGcgNYp7PZ9vxrZJwuGx8gdwGJjCkgHJAETkNPcDGi5rIXxVxxUEUxpXM
         e7gJm4XzSBzJdQ4OaOml/LQD3gz+rKnIBra2hRH4iyOubQqe6Db3DYrX4dsQfImp5Utw
         VzTCwNlw4d6V9s1RCRnyYBgiPsAfJsc1FexUHFRSFRz5yMYi9MRQPqJmd8ut7kmq8+16
         cozg==
X-Gm-Message-State: AOAM532xUJBN38875X4welCRyOO0El0w813YVmwUElzon8iqN9Z0lPgH
        I7lcOXQyWMK2IVDsvK6K/s2qs4kg2yBCjLB92ur8fg==
X-Google-Smtp-Source: ABdhPJy4IYCeF0hjRfYR1m6VTIzkTzOUSXDzvOlBTshw/jj1Q1JUcvMVBCca72sGHZGA+CaezVFWzGrpaYErvmqqbJc=
X-Received: by 2002:aa7:c64e:: with SMTP id z14mr11267248edr.69.1607682809683;
 Fri, 11 Dec 2020 02:33:29 -0800 (PST)
MIME-Version: 1.0
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
 <1607598951-2340-2-git-send-email-loic.poulain@linaro.org>
 <20201211053800.GC4222@work> <CAMZdPi_9=CPXTNCDV=eLEg-2A0o-S1LkHr=hmED=z=CNe8u2iw@mail.gmail.com>
 <20201211101510.GE4222@work>
In-Reply-To: <20201211101510.GE4222@work>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 11 Dec 2020 11:40:02 +0100
Message-ID: <CAMZdPi8=SMGgXtD9Ne9HWd8JAb=c_PpKOrp-0dHOY-LHQNRc3g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] net: mhi: Get RX queue size from MHI core
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 at 11:15, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> On Fri, Dec 11, 2020 at 10:40:13AM +0100, Loic Poulain wrote:
> > Hi Mani,
> >
> > On Fri, 11 Dec 2020 at 06:38, Manivannan Sadhasivam
> > <manivannan.sadhasivam@linaro.org> wrote:
> > >
> > > On Thu, Dec 10, 2020 at 12:15:50PM +0100, Loic Poulain wrote:
> > > > The RX queue size can be determined at runtime by retrieving the
> > > > number of available transfer descriptors.
> > > >
> > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > > ---
> > > >  v2: Fixed commit message typo
> > > >
> > > >  drivers/net/mhi_net.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > [...]
> > > > -
> > > >       INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> > > >       u64_stats_init(&mhi_netdev->stats.rx_syncp);
> > > >       u64_stats_init(&mhi_netdev->stats.tx_syncp);
> > > > @@ -268,6 +265,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
> > > >       if (err)
> > > >               goto out_err;
> > > >
> > > > +     /* Number of transfer descriptors determines size of the queue */
> > > > +     mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> > > > +
> > >
> > > This value is not static right? You might need to fetch the count in
> > > mhi_net_rx_refill_work().
> >
> > It is, actually here driver is just looking for the total queue size,
> > which is the number of descriptors at init time. This total queue size
> > is used later to determine the level of MHI queue occupancy rate.
> >
>
> Right but what if the size got increased in runtime (recycled etc...), we won't
> be fully utilizing the ring.

The queue size can not be more than the initial size, which is the
number of elements in the rings (e.g. 128). At runtime, the driver
calls again mhi_get_free_desc_count() in DL callback to determine the
current number available slots (e.g. 32). If this value is higher than
a certain limit (e.g 128 /2), then we start refilling the MHI RX queue
with fresh buffers to prevent buffer starvation.

Regards,
Loic
