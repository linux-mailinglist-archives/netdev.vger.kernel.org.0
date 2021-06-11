Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DCC3A3C49
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhFKGyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:54:08 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:54270 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhFKGyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:54:07 -0400
Received: by mail-pj1-f48.google.com with SMTP id ei4so5152528pjb.3
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 23:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+sO2TB+8ApB3Zq0zPb7psqJ1i4EPBkuIPaEmOxjGjI=;
        b=dlNeKwDssqBPaJAwegfW+kmR2XlHzotK9yUPLpJkhyifvQ8yrwTVphQ/z96zy9Vf9H
         FdII0Bb0GeYh3Q2rOTqIXlUwQ3HopeJSxGYrSKh2vdS+p5CdesO8UIiiscX0Bt+WZKFU
         kHXlaUp7IsduWrYKsFiDPbgoI1hDrracfSCuRYrQZ2VT507+yGi1uaBn9rtoOWdeu/kd
         SecOwNAeOEPrSp0UCwTSYCpKSeJ9hkkL8GezSgHYYz+9mpb9FLEgtMv/RVT5YoZrWVWA
         HV+xGbsY6ZcnYjFv72n0GChE+30cnbJ6IP+PyP3fw6Ou+S/vVVf3z3v7VnETM79Mj0mw
         GUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+sO2TB+8ApB3Zq0zPb7psqJ1i4EPBkuIPaEmOxjGjI=;
        b=ZDMs0DkwhwV1IsTBzW42536kNqtKIsKlbcFO56oBLxsLWW41IPwEsmjUM2LhUstz5w
         uTpwcaQz9fyuZDLpo8r/rhBHaO4XGQxD+3TSs/kJq1JJoOrAtNwsy0YANQ3kYPq44VHH
         SzOIupwXP0I5Z3wjvINIob8wx+BMgql1NoWDvSa+L8oVbblUnxI2PvdGePkJ8Vb3tqM3
         BKTTMdTXTYEG71CbeYUbyrcmBwLWeQ11W1+39dZKZJHyN9oX7TJENUDbkMLlGaSQDpjh
         tJox+X/0DclRwres5Injb/I4OMT4ZM/2L1JWRbYQxB78azep+Nvb9TS4zOkMrkDfAGG4
         bsuQ==
X-Gm-Message-State: AOAM531CfkhqE/oIdS9MYQe/6CmqI1IqXD9DoBLI/dkRrUzH7tsDFDSe
        8Xi6i6D46chjvG/2By9Jhf4aaJulYIyRZnBCeY/Xdw==
X-Google-Smtp-Source: ABdhPJy5BioolQbVIKu/Do/YaIRrPujKR+V3jzJeOclywGXL/3Q/bZMdYh3WJHPQWEt2IRWvbiWjsJePoMtSvBPu0HM=
X-Received: by 2002:a17:90b:1bc4:: with SMTP id oa4mr3126091pjb.18.1623394269767;
 Thu, 10 Jun 2021 23:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <1621603519-16773-1-git-send-email-loic.poulain@linaro.org> <20210521163530.GO70095@thinkpad>
In-Reply-To: <20210521163530.GO70095@thinkpad>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 11 Jun 2021 09:00:16 +0200
Message-ID: <CAMZdPi8FVWRhU69z6JygsqoqMCOJTKGfo6vTWtv35kT-Ap8Drg@mail.gmail.com>
Subject: Re: [PATCH v2] bus: mhi: Add inbound buffers allocation flag
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

On Fri, 21 May 2021 at 18:35, Manivannan Sadhasivam <mani@kernel.org> wrote:
>
> + netdev, Dave, Jakub
>
> On Fri, May 21, 2021 at 03:25:19PM +0200, Loic Poulain wrote:
> > Currently, the MHI controller driver defines which channels should
> > have their inbound buffers allocated and queued. But ideally, this is
> > something that should be decided by the MHI device driver instead,
> > which actually deals with that buffers.
> >
> > Add a flag parameter to mhi_prepare_for_transfer allowing to specify
> > if buffers have to be allocated and queued by the MHI stack.
> >
> > Keep auto_queue flag for now, but should be removed at some point.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Tested-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  v2: Update API in mhi_wwan_ctrl driver
> >
> >  drivers/bus/mhi/core/internal.h  |  2 +-
> >  drivers/bus/mhi/core/main.c      | 11 ++++++++---
> >  drivers/net/mhi/net.c            |  2 +-
> >  drivers/net/wwan/mhi_wwan_ctrl.c |  2 +-
>
> Since this patch touches the drivers under net/, I need an Ack from Dave or
> Jakub to take it via MHI tree.

Could you please ack|nack this patch?

Thanks,
Loic


>
> >  include/linux/mhi.h              | 12 +++++++++++-
> >  net/qrtr/mhi.c                   |  2 +-
> >  6 files changed, 23 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
> > index 5b9ea66..672052f 100644
> > --- a/drivers/bus/mhi/core/internal.h
> > +++ b/drivers/bus/mhi/core/internal.h
> > @@ -682,7 +682,7 @@ void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
> >                     struct image_info *img_info);
> >  void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl);
> >  int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> > -                     struct mhi_chan *mhi_chan);
> > +                     struct mhi_chan *mhi_chan, enum mhi_chan_flags flags);
> >  int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
> >                      struct mhi_chan *mhi_chan);
> >  void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
> > diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> > index 0f1febf..432b53b 100644
> > --- a/drivers/bus/mhi/core/main.c
> > +++ b/drivers/bus/mhi/core/main.c
> > @@ -1384,7 +1384,8 @@ static void mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
> >  }
> >
> >  int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> > -                     struct mhi_chan *mhi_chan)
> > +                     struct mhi_chan *mhi_chan,
> > +                     enum mhi_chan_flags flags)
> >  {
> >       int ret = 0;
> >       struct device *dev = &mhi_chan->mhi_dev->dev;
> > @@ -1409,6 +1410,9 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
> >       if (ret)
> >               goto error_pm_state;
> >
> > +     if (mhi_chan->dir == DMA_FROM_DEVICE)
> > +             mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
> > +
> >       /* Pre-allocate buffer for xfer ring */
> >       if (mhi_chan->pre_alloc) {
> >               int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
> > @@ -1555,7 +1559,8 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
> >  }
> >
> >  /* Move channel to start state */
> > -int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
> > +int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
> > +                          enum mhi_chan_flags flags)
> >  {
> >       int ret, dir;
> >       struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
> > @@ -1566,7 +1571,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
> >               if (!mhi_chan)
> >                       continue;
> >
> > -             ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
> > +             ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
> >               if (ret)
> >                       goto error_open_chan;
> >       }
> > diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
> > index 6b5bf23..3ddfb72 100644
> > --- a/drivers/net/mhi/net.c
> > +++ b/drivers/net/mhi/net.c
> > @@ -323,7 +323,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
> >       u64_stats_init(&mhi_netdev->stats.tx_syncp);
> >
> >       /* Start MHI channels */
> > -     err = mhi_prepare_for_transfer(mhi_dev);
> > +     err = mhi_prepare_for_transfer(mhi_dev, 0);
> >       if (err)
> >               goto out_err;
> >
> > diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> > index 3a44b22..84e75e4 100644
> > --- a/drivers/net/wwan/mhi_wwan_ctrl.c
> > +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> > @@ -110,7 +110,7 @@ static int mhi_wwan_ctrl_start(struct wwan_port *port)
> >       int ret;
> >
> >       /* Start mhi device's channel(s) */
> > -     ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev);
> > +     ret = mhi_prepare_for_transfer(mhiwwan->mhi_dev, 0);
> >       if (ret)
> >               return ret;
> >
> > diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> > index d095fba..9372acf 100644
> > --- a/include/linux/mhi.h
> > +++ b/include/linux/mhi.h
> > @@ -60,6 +60,14 @@ enum mhi_flags {
> >  };
> >
> >  /**
> > + * enum mhi_chan_flags - MHI channel flags
> > + * @MHI_CH_INBOUND_ALLOC_BUFS: Automatically allocate and queue inbound buffers
> > + */
> > +enum mhi_chan_flags {
> > +     MHI_CH_INBOUND_ALLOC_BUFS = BIT(0),
> > +};
> > +
> > +/**
> >   * enum mhi_device_type - Device types
> >   * @MHI_DEVICE_XFER: Handles data transfer
> >   * @MHI_DEVICE_CONTROLLER: Control device
> > @@ -719,8 +727,10 @@ void mhi_device_put(struct mhi_device *mhi_dev);
> >   *                            host and device execution environments match and
> >   *                            channels are in a DISABLED state.
> >   * @mhi_dev: Device associated with the channels
> > + * @flags: MHI channel flags
> >   */
> > -int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
> > +int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
> > +                          enum mhi_chan_flags flags);
> >
> >  /**
> >   * mhi_unprepare_from_transfer - Reset UL and DL channels for data transfer.
> > diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> > index 2bf2b19..47afded 100644
> > --- a/net/qrtr/mhi.c
> > +++ b/net/qrtr/mhi.c
> > @@ -77,7 +77,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
> >       int rc;
> >
> >       /* start channels */
> > -     rc = mhi_prepare_for_transfer(mhi_dev);
> > +     rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
> >       if (rc)
> >               return rc;
> >
> > --
> > 2.7.4
> >
