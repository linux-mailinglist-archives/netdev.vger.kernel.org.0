Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED02EF4DB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 16:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbhAHPbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 10:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAHPbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 10:31:17 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8346C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 07:30:37 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q7so5943378pgm.5
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pcg+os/0yOWjldKVf73QhxWFDRz+4DGy+42r9RW0+WI=;
        b=uTH6OgcwMLNKvUsZyvbs+lgzQjAGx9EVs+pn5bwWRhBiyS8jUw0lUzvZKLepfNYors
         8IJYYukSc9u4Lpqm/OrM9KIh4elVXvV+r1+Oi8KaZKgUI2yo6+PXx02g5DRcyDK20S6X
         RzFQEDHef/czmlQUPkarNQicOZT9Zil1l9ChNsVFE7+fgaq5CAVsmwER1JsmTkwW2btn
         iHh5tCmr5KgzQPye2rbmG6eZU0DcbdFCRLbgcFUhkQoRgDgY6zBsBRAXh0VjnCp3zHTc
         PLBUQvLGdaI1iTGZi5lgM6T+EiY8YVJCR/6wObnqvcrXHucDf4jqo0jLzvhmkL33kVPf
         ae+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pcg+os/0yOWjldKVf73QhxWFDRz+4DGy+42r9RW0+WI=;
        b=A0ziNwYnCCeflENDQJHf6L8ygftSKGEpFI5zcFqdCKGQrQebcJp3zc/dzHLalvR7rm
         D75wRzYG6QMjBou7c7mDuYH8zCfGUK8EB9BDDvrKlOVPk0jaGQgtYRw11Q14c/W2ZPXO
         RB1/DrdMrkyQAyoOdUao+2ohP8uVtjWJRkqIRsJ6e7FblQqzt8JaeQmBQEpKE+N/n4ko
         tPVi05phEU46Tdnr+HP1P90BcOh191lRpmS4HjaucEQBlBAiKlVwuhO2+u5OftueDKWl
         dJovKqrvwLG2p/6wCXwsa8cbml99Ipdmm8ZlhYgzZV84hM7heHTEWZRJTYdjNdDhc45I
         AQrQ==
X-Gm-Message-State: AOAM531kgj6nSnUuOGv+RANcW4QleFxH924kRVZ11QuZiyE9+Rmz6vQ0
        kbXWAWaeX+aot+k1j+X7066X
X-Google-Smtp-Source: ABdhPJzR+qzldELt5Cc+Y9Y6HqLOJ7nCdnuwWtx5uzPnQDbxv2TXKpxOJ9BIUTSRUgCF/zN1Lpoh7A==
X-Received: by 2002:a63:dc53:: with SMTP id f19mr7450745pgj.443.1610119836817;
        Fri, 08 Jan 2021 07:30:36 -0800 (PST)
Received: from work ([103.77.37.188])
        by smtp.gmail.com with ESMTPSA id c14sm9603840pfp.167.2021.01.08.07.30.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 07:30:35 -0800 (PST)
Date:   Fri, 8 Jan 2021 21:00:32 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] bus: mhi: Add inbound buffers allocation flag
Message-ID: <20210108153032.GC32678@work>
References: <1609940623-8864-1-git-send-email-loic.poulain@linaro.org>
 <20210108134425.GA32678@work>
 <CAMZdPi9tUUzf0hLwLUBqB=+eGQS-eNP8NtnMF-iS1ZqUfautuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi9tUUzf0hLwLUBqB=+eGQS-eNP8NtnMF-iS1ZqUfautuw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 03:01:59PM +0100, Loic Poulain wrote:
> Hi Mani,
> 
> On Fri, 8 Jan 2021 at 14:44, Manivannan Sadhasivam <
> manivannan.sadhasivam@linaro.org> wrote:
> 
> > On Wed, Jan 06, 2021 at 02:43:43PM +0100, Loic Poulain wrote:
> > > Currently, the MHI controller driver defines which channels should
> > > have their inbound buffers allocated and queued. But ideally, this is
> > > something that should be decided by the MHI device driver instead,
> >
> > We call them, "MHI client drivers"
> >
> 
> I'll fix that.
> 
> 
> > > which actually deals with that buffers.
> > >
> > > Add a flag parameter to mhi_prepare_for_transfer allowing to specify
> > > if buffers have to be allocated and queued by the MHI stack.
> > >
> > > Keep auto_queue flag for now, but should be removed at some point.
> > >
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > ---
> > >  drivers/bus/mhi/core/internal.h |  2 +-
> > >  drivers/bus/mhi/core/main.c     | 11 ++++++++---
> > >  drivers/net/mhi_net.c           |  2 +-
> > >  include/linux/mhi.h             | 12 +++++++++++-
> > >  net/qrtr/mhi.c                  |  2 +-
> > >  5 files changed, 22 insertions(+), 7 deletions(-)
> > >
> >
> > [...]
> >
> > > diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> > > index fa41d8c..b7f7f2e 100644
> > > --- a/drivers/net/mhi_net.c
> > > +++ b/drivers/net/mhi_net.c
> > > @@ -265,7 +265,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
> > >       u64_stats_init(&mhi_netdev->stats.tx_syncp);
> > >
> > >       /* Start MHI channels */
> > > -     err = mhi_prepare_for_transfer(mhi_dev);
> > > +     err = mhi_prepare_for_transfer(mhi_dev, 0);
> >
> > Eventhough I'd like Hemant to comment on this patch, AFAIU this looks to
> > me a controller dependent behaviour. The controller should have the
> > information whether a particular channel can auto queue or not then the
> > client driver can be agnostic.
> >
> 
> The client driver can not be agnostic if this information is defined on the
> controller side. In one case client driver needs to allocate (and queue)
> its own buffers and in the other case it uses the pre-allocated ones.
> Moreover, that will break compatibility if we have one controller (e.g. a
> Wifi MHI controller) that e.g. defines IPCR channels as pre-allocated and
> another one that defines IPCR channels as non-pre-allocated. Having
> pre-allocated channels is not something related to the MHI device but to
> how the host (client driver) wants to manage buffers. It would then make
> sense to let this choice to the client driver.
> 
> 
> >
> > >       if (err)
> > >               goto out_err;
> > >
> > > diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> > > index 209b335..6723339 100644
> > > --- a/include/linux/mhi.h
> > > +++ b/include/linux/mhi.h
> > > @@ -60,6 +60,14 @@ enum mhi_flags {
> > >  };
> > >
> > >  /**
> > > + * enum mhi_chan_flags - MHI channel flags
> > > + * @MHI_CH_INBOUND_ALLOC_BUFS: Automatically allocate and queue inbound
> > buffers
> > > + */
> > > +enum mhi_chan_flags {
> > > +     MHI_CH_INBOUND_ALLOC_BUFS = BIT(0),
> > > +};
> > > +
> > > +/**
> > >   * enum mhi_device_type - Device types
> > >   * @MHI_DEVICE_XFER: Handles data transfer
> > >   * @MHI_DEVICE_CONTROLLER: Control device
> > > @@ -705,8 +713,10 @@ void mhi_device_put(struct mhi_device *mhi_dev);
> > >  /**
> > >   * mhi_prepare_for_transfer - Setup channel for data transfer
> > >   * @mhi_dev: Device associated with the channels
> > > + * @flags: MHI channel flags
> > >   */
> > > -int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
> > > +int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
> > > +                          enum mhi_chan_flags flags);
> > >
> > >  /**
> > >   * mhi_unprepare_from_transfer - Unprepare the channels
> > > diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> > > index 2bf2b19..47afded 100644
> > > --- a/net/qrtr/mhi.c
> > > +++ b/net/qrtr/mhi.c
> > > @@ -77,7 +77,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device
> > *mhi_dev,
> > >       int rc;
> > >
> > >       /* start channels */
> > > -     rc = mhi_prepare_for_transfer(mhi_dev);
> > > +     rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
> >
> > Are you sure it requires auto queued channel?
> >
> 
> This is how mhi-qrtr has been implemented, yes.
> 

skb is allocated in qrtr_endpoint_post(). Then how the host can pre
allocate the buffer here? Am I missing something?

Thanks,
Mani

> Regards,
> Loic
