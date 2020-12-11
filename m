Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11B2D73C4
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgLKKQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731920AbgLKKP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:15:59 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8B3C0613D6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:15:18 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id lj6so556997pjb.0
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LhKal6ZA0guljLSSaDv111ejGEexaf+FFXINZMKjQhQ=;
        b=LKgBsCuKh5XSXw64B/dx4wGOnlmMk0Xy+WBz6gTWZlPlYMaJWdI2DYBaeY7niYgQg5
         EQw2QzY/FnQD2HBhisvrnhSPKy3TLpgwS4jr7U29LNxsYrGZeHoQVGD2mQ1dzWsje3KE
         ffhx87QoVPHquZCpVUf425cAv+7yjhUD9Qn3MC2ZWgfEVh04Cv7he9/3c6gGzImDfDoA
         c3uRHa2q7UKF/Nk9zc2xhTb3LkEk7QK/mDoozDQzzKIXzkb8CEk7vMfiqCegLJWddcjL
         3RA2CD6ulcj1hGpFIBvtwcadSTxiyhKXmNAAb0L9C9RyqfSnSl2o7pC8Z3BIx2tyGe57
         Gk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LhKal6ZA0guljLSSaDv111ejGEexaf+FFXINZMKjQhQ=;
        b=lVwkOv4Z1uNXEy6Y4orJBxbqseUY+m80wz5W2MNJYK1yzUetzr3vAS5IiGOQeeCRj0
         3c6MVh/D/VGBbIiMpA6SPGXdtZSYOJqA7IyG4bnmA3nc51kq0HsMxuryCtswksSLKxcZ
         XghY+7iEP8kQ4k6YXzDrRkur+eyXFdK0nzbW5ISf6osByUks1vQ8PcIWa6TNXPoK3mox
         eA412WfvwUkLHYuWHvv/Ala/PJM1yGZna9Q1TZd9v/0nO7be1U+xKiwfcSP/uTxX9blD
         wqf06JU5hGJwVOI/kYC+QLRJmElRruDonx6w63VMCbi5HxwAbMQVAght+fbNlxn5e2li
         7BYQ==
X-Gm-Message-State: AOAM5300CDBqj0XbBCK8860Couln85TC55E74Tcv1hAU85CjAkowxNHT
        pQUTmb1voahTk6WBx1A7s8DI
X-Google-Smtp-Source: ABdhPJyJN10cugMZ1efJ+RlbCGGPmiRnkTHFVwUxfEnI5TjSd0Dusovu8b++v+Pf2wvPZj7sA8462g==
X-Received: by 2002:a17:90a:6809:: with SMTP id p9mr12108451pjj.112.1607681718181;
        Fri, 11 Dec 2020 02:15:18 -0800 (PST)
Received: from work ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id nm6sm9527395pjb.25.2020.12.11.02.15.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Dec 2020 02:15:17 -0800 (PST)
Date:   Fri, 11 Dec 2020 15:45:10 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v2 2/3] net: mhi: Get RX queue size from MHI core
Message-ID: <20201211101510.GE4222@work>
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
 <1607598951-2340-2-git-send-email-loic.poulain@linaro.org>
 <20201211053800.GC4222@work>
 <CAMZdPi_9=CPXTNCDV=eLEg-2A0o-S1LkHr=hmED=z=CNe8u2iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi_9=CPXTNCDV=eLEg-2A0o-S1LkHr=hmED=z=CNe8u2iw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 10:40:13AM +0100, Loic Poulain wrote:
> Hi Mani,
> 
> On Fri, 11 Dec 2020 at 06:38, Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> >
> > On Thu, Dec 10, 2020 at 12:15:50PM +0100, Loic Poulain wrote:
> > > The RX queue size can be determined at runtime by retrieving the
> > > number of available transfer descriptors.
> > >
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > ---
> > >  v2: Fixed commit message typo
> > >
> > >  drivers/net/mhi_net.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> [...]
> > > -
> > >       INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> > >       u64_stats_init(&mhi_netdev->stats.rx_syncp);
> > >       u64_stats_init(&mhi_netdev->stats.tx_syncp);
> > > @@ -268,6 +265,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
> > >       if (err)
> > >               goto out_err;
> > >
> > > +     /* Number of transfer descriptors determines size of the queue */
> > > +     mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> > > +
> >
> > This value is not static right? You might need to fetch the count in
> > mhi_net_rx_refill_work().
> 
> It is, actually here driver is just looking for the total queue size,
> which is the number of descriptors at init time. This total queue size
> is used later to determine the level of MHI queue occupancy rate.
> 

Right but what if the size got increased in runtime (recycled etc...), we won't
be fully utilizing the ring.

Thanks,
Mani

> Regards,
> Loic
