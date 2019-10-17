Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DABDDA812
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408447AbfJQJK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:10:59 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:44046 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404200AbfJQJK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 05:10:58 -0400
Received: by mail-vk1-f195.google.com with SMTP id j21so336646vki.11
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 02:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=04hgzc9qmWLKJ4qr0kQdZsxTdQTI10306q/6E8gxvtc=;
        b=AqiK/AqAzagnlRkDP5D7TqpB+zWnEWzzdcE1+ogvr7ovwCaWkS1E6dkGJIs2VYkna0
         HA4p49iuZmap9bwrWQDRVBDRirGN4C+C2Zd7u80MbHPDi5LXzDcZodamYr8fGpxOJG9+
         cQZnATF4Ea0ykf2DI2LFkN6+oO+au47cMBmY/ah6FOd0Yu8NwLdx2gXP6PK0zgfk/FVl
         d5XrEkNmgDNqjUJTKWvbkMQHDg5i7+QZcSxqmZGGzma5dZtwr+ebc4iw4oBBUKILyGwe
         5vi75QlYGSAmHTq0wmbKn0zm/loaA1/zPSK2vMr5cX+3JCAUa64xiho02j7x4kDXzF9s
         eq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=04hgzc9qmWLKJ4qr0kQdZsxTdQTI10306q/6E8gxvtc=;
        b=ORHP4fP1DLMvIIlrYDL4BpRfYH/qmlMGy2qDbnPgqw8s9cMI1VxOADW7wgdNSX3jdU
         rCohHrK8WdofBw4vv6hVtSFptHPaMG2bY2g9F3SwRtxF/4/A0GZVIhGm4sOqAe05odN/
         ShGUoarj0O4w+T/smCB/nIQAi1BHh5fpCHEvBrhu0m3bviS/d1xGHbrdZ35u4RmaQhyL
         cwoXSeX3WymOGTtyUGYtKuFgb0mB5KvO3qh1mGfme3BFUVufy4+PqbHutPmGIO/64uVg
         aaYbCpioIw7TUK19zbGDL331f6nOKyyyTxtW9fMHWHxi/dzJFlQoFyEhTUSYwrXUSiT2
         RZ3g==
X-Gm-Message-State: APjAAAVHYMrjyp0LMLngTow4LCiF9QUvUhlJR04sof1bAlSKNNpS7MNH
        TcexADB7qnsIaFFaMETA74PR0dCLOlQCiPc/fVIx1Q==
X-Google-Smtp-Source: APXvYqy6RzDXcXpkWwa0bGaEo+8n7N3C2W0z0lEf79Xa7qw1LYxocO3L07nV4sCDvLvAw7yANGge1FFEGo3O1xtTF/4=
X-Received: by 2002:a1f:2f51:: with SMTP id v78mr1342917vkv.101.1571303457218;
 Thu, 17 Oct 2019 02:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org>
 <20190722193939.125578-2-dianders@chromium.org> <CAPDyKFpKWo4n+nmBXVcDc4TNzFV3vc+3aeKcu_nKaB=hj=RKUQ@mail.gmail.com>
 <CAD=FV=WTKy3PmMSCbjKA_Ro_MP+dFE89oCzi_Bs7YeCrcD+3Xg@mail.gmail.com>
In-Reply-To: <CAD=FV=WTKy3PmMSCbjKA_Ro_MP+dFE89oCzi_Bs7YeCrcD+3Xg@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 17 Oct 2019 11:10:21 +0200
Message-ID: <CAPDyKFrwUgi6MzyZm0VgGWOahCGW6KgGRrWC7v=KvM=vbFY4RA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: core: Add sdio_trigger_replug() API
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xinming Hu <huxinming820@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 at 02:22, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Oct 10, 2019 at 7:11 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > On Mon, 22 Jul 2019 at 21:41, Douglas Anderson <dianders@chromium.org> wrote:
> > >
> > > When using Marvell WiFi SDIO cards, it is not uncommon for Linux WiFi
> > > driver to fully lose the communication channel to the firmware running
> > > on the card.  Presumably the firmware on the card has a bug or two in
> > > it and occasionally crashes.
> > >
> > > The Marvell WiFi driver attempts to recover from this problem.
> > > Specifically the driver has the function mwifiex_sdio_card_reset()
> > > which is called when communcation problems are found.  That function
> > > attempts to reset the state of things by utilizing the mmc_hw_reset()
> > > function.
> > >
> > > The current solution is a bit complex because the Marvell WiFi driver
> > > needs to manually deinit and reinit the WiFi driver around the reset
> > > call.  This means it's going through a bunch of code paths that aren't
> > > normally tested.  However, complexity isn't our only problem.  The
> > > other (bigger) problem is that Marvell WiFi cards are often combo
> > > WiFi/Bluetooth cards and Bluetooth runs on a second SDIO func.  While
> > > the WiFi driver knows that it should re-init its own state around the
> > > mmc_hw_reset() call there is no good way to inform the Bluetooth
> > > driver.  That means that in Linux today when you reset the Marvell
> > > WiFi driver you lose all Bluetooth communication.  Doh!
> >
> > Thanks for a nice description to the problem!
> >
> > In principle it makes mmc_hw_reset() quite questionable to use for
> > SDIO func drivers, at all. However, let's consider that for later.
>
> Yeah, unless you somehow knew that your card would only have one function.
>
>
> > > One way to fix the above problems is to leverage a more standard way
> > > to reset the Marvell WiFi card where we go through the same code paths
> > > as card unplug and the card plug.  In this patch we introduce a new
> > > API call for doing just that: sdio_trigger_replug().  This API call
> > > will trigger an unplug of the SDIO card followed by a plug of the
> > > card.  As part of this the card will be nicely reset.
> >
> > I have been thinking back and forth on this, exploring various
> > options, perhaps adding some callbacks that the core could invoke to
> > inform the SDIO func drivers of what is going on.
> >
> > Although, in the end this boils done to complexity and I think your
> > approach is simply the most superior in regards to this. However, I
> > think there is a few things that we can do to even further simply your
> > approach, let me comment on the code below.
>
> Right.  Unplugging / re-plugging is sorta gross / inelegant, but it is
> definitely simpler and nice that it doesn't add so many new code
> paths.  For cases where you're just trying to re-init things with a
> hammer it works pretty well.
>
>
> > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > >
> > > Changes in v2:
> > > - s/routnine/routine (Brian Norris, Matthias Kaehlcke).
> > > - s/contining/containing (Matthias Kaehlcke).
> > > - Add Matthias Reviewed-by tag.
> > >
> > >  drivers/mmc/core/core.c       | 28 ++++++++++++++++++++++++++--
> > >  drivers/mmc/core/sdio_io.c    | 20 ++++++++++++++++++++
> > >  include/linux/mmc/host.h      | 15 ++++++++++++++-
> > >  include/linux/mmc/sdio_func.h |  2 ++
> > >  4 files changed, 62 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > > index 221127324709..5da365b1fdb4 100644
> > > --- a/drivers/mmc/core/core.c
> > > +++ b/drivers/mmc/core/core.c
> > > @@ -2161,6 +2161,12 @@ int mmc_sw_reset(struct mmc_host *host)
> > >  }
> > >  EXPORT_SYMBOL(mmc_sw_reset);
> > >
> > > +void mmc_trigger_replug(struct mmc_host *host)
> > > +{
> > > +       host->trigger_replug_state = MMC_REPLUG_STATE_UNPLUG;
> > > +       _mmc_detect_change(host, 0, false);
> > > +}
> > > +
> > >  static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
> > >  {
> > >         host->f_init = freq;
> > > @@ -2214,6 +2220,11 @@ int _mmc_detect_card_removed(struct mmc_host *host)
> > >         if (!host->card || mmc_card_removed(host->card))
> > >                 return 1;
> > >
> > > +       if (host->trigger_replug_state == MMC_REPLUG_STATE_UNPLUG) {
> > > +               mmc_card_set_removed(host->card);
> > > +               return 1;
> >
> > Do you really need to set state of the card to "removed"?
> >
> > If I understand correctly, what you need is to allow mmc_rescan() to
> > run a second time, in particular for non removable cards.
> >
> > In that path, mmc_rescan should find the card being non-functional,
> > thus it should remove it and then try to re-initialize it again. Etc.
> >
> > Do you want me to send a patch to show you what I mean!?
>
> If you don't mind, that would probably be easiest.  I've totally
> swapped out all of the implementation details of this from my brain
> now, but if I saw a patch from you it would be easy for me to analyze
> it and test it.

Alright, I think I owe you that because of my slow review pase. :-)

Patches are coming soon!

Kind regards
Uffe
