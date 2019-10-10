Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3A6D2C28
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfJJOLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:11:10 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45202 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfJJOLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 10:11:10 -0400
Received: by mail-vs1-f65.google.com with SMTP id d204so3968588vsc.12
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 07:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gA5F+RboE/pq+skSstsxaptbKJRogDAxspae1hZdrlw=;
        b=r/LIxHSW9Hdinc+D0Q6ii6IgfODtEPA7DG+J3nI5G4dmTYbg0AE8kFbjz4uCjpx4tF
         QrLKKae+TVAOXVIm8ul1al4xJKrRBf4PHxbHxvzkzylS2dlImR5Ta9ZS8C8LOnIvCi8Z
         YT/DpA5D0z2tTsdrfvUKjoUGjElPqlkPMxF7J3/BaBDUsUQ+JXlh/jdLQqKjZ2y0T/SN
         LWPgem2QK0RVDs3oPjUFSY0OULoh/0Qonhqby6SdaZMcuFtH7hOoyOSaj2qJWVhkmJEq
         J6EH4NlsThcmjNlAM7KIo+XcHU1nBOjHN8nNi0cFMsvnIW5b1HABIkXZX3x+z3765HHV
         S6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gA5F+RboE/pq+skSstsxaptbKJRogDAxspae1hZdrlw=;
        b=Szlrk192BUhrH+lNNd+mCQQmNDyxN30kFhwQf8zzrSZ448hXMyyBNTxLL4CVaQzmhg
         UZJfzc3CEVMpIVrNiee/4jNjpjj7s2unLMvKeA98cmPzkoYXmEUzK1ibrdOMb63JZcmR
         tMm1V2VTktwqZ084Ng6A2RYa1g755lnSRWmgh+3UMdKp3SJZlhwCAMK7CFeDTfksq87H
         t2fqWaROUJjstkKSziVFBRr9Uj3POzJIOvyiyQSFMABPE/icUpFF9zdfN57tvt71XFOn
         NFCnXdZbkUgnQAqUWjdrPiki4b9MS8GtLge2i0XHWnGyGTe8v4fu3qEoDLnoRy2ULCcT
         Rc+A==
X-Gm-Message-State: APjAAAWF1NRd0GKn71ustNK4hNRfUMb973q3rjVw2TCODJ/Qw8mf9C2E
        CupeYFJyDfUxS5pkEGNMoYuSy1aOzf1OvI3Pgw99Rw==
X-Google-Smtp-Source: APXvYqx8YwXRB2hrYG/fdZo1ha3XH6HrALf+bCVpuuJw5+7mmU3wP8OnkTRknPuULXGYFLMFs7UbggxceKVIPmCeIC8=
X-Received: by 2002:a67:ef89:: with SMTP id r9mr5830898vsp.200.1570716668861;
 Thu, 10 Oct 2019 07:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org> <20190722193939.125578-2-dianders@chromium.org>
In-Reply-To: <20190722193939.125578-2-dianders@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 10 Oct 2019 16:10:32 +0200
Message-ID: <CAPDyKFpKWo4n+nmBXVcDc4TNzFV3vc+3aeKcu_nKaB=hj=RKUQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mmc: core: Add sdio_trigger_replug() API
To:     Douglas Anderson <dianders@chromium.org>
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

On Mon, 22 Jul 2019 at 21:41, Douglas Anderson <dianders@chromium.org> wrote:
>
> When using Marvell WiFi SDIO cards, it is not uncommon for Linux WiFi
> driver to fully lose the communication channel to the firmware running
> on the card.  Presumably the firmware on the card has a bug or two in
> it and occasionally crashes.
>
> The Marvell WiFi driver attempts to recover from this problem.
> Specifically the driver has the function mwifiex_sdio_card_reset()
> which is called when communcation problems are found.  That function
> attempts to reset the state of things by utilizing the mmc_hw_reset()
> function.
>
> The current solution is a bit complex because the Marvell WiFi driver
> needs to manually deinit and reinit the WiFi driver around the reset
> call.  This means it's going through a bunch of code paths that aren't
> normally tested.  However, complexity isn't our only problem.  The
> other (bigger) problem is that Marvell WiFi cards are often combo
> WiFi/Bluetooth cards and Bluetooth runs on a second SDIO func.  While
> the WiFi driver knows that it should re-init its own state around the
> mmc_hw_reset() call there is no good way to inform the Bluetooth
> driver.  That means that in Linux today when you reset the Marvell
> WiFi driver you lose all Bluetooth communication.  Doh!

Thanks for a nice description to the problem!

In principle it makes mmc_hw_reset() quite questionable to use for
SDIO func drivers, at all. However, let's consider that for later.

>
> One way to fix the above problems is to leverage a more standard way
> to reset the Marvell WiFi card where we go through the same code paths
> as card unplug and the card plug.  In this patch we introduce a new
> API call for doing just that: sdio_trigger_replug().  This API call
> will trigger an unplug of the SDIO card followed by a plug of the
> card.  As part of this the card will be nicely reset.

I have been thinking back and forth on this, exploring various
options, perhaps adding some callbacks that the core could invoke to
inform the SDIO func drivers of what is going on.

Although, in the end this boils done to complexity and I think your
approach is simply the most superior in regards to this. However, I
think there is a few things that we can do to even further simply your
approach, let me comment on the code below.

>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>
> Changes in v2:
> - s/routnine/routine (Brian Norris, Matthias Kaehlcke).
> - s/contining/containing (Matthias Kaehlcke).
> - Add Matthias Reviewed-by tag.
>
>  drivers/mmc/core/core.c       | 28 ++++++++++++++++++++++++++--
>  drivers/mmc/core/sdio_io.c    | 20 ++++++++++++++++++++
>  include/linux/mmc/host.h      | 15 ++++++++++++++-
>  include/linux/mmc/sdio_func.h |  2 ++
>  4 files changed, 62 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 221127324709..5da365b1fdb4 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2161,6 +2161,12 @@ int mmc_sw_reset(struct mmc_host *host)
>  }
>  EXPORT_SYMBOL(mmc_sw_reset);
>
> +void mmc_trigger_replug(struct mmc_host *host)
> +{
> +       host->trigger_replug_state = MMC_REPLUG_STATE_UNPLUG;
> +       _mmc_detect_change(host, 0, false);
> +}
> +
>  static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
>  {
>         host->f_init = freq;
> @@ -2214,6 +2220,11 @@ int _mmc_detect_card_removed(struct mmc_host *host)
>         if (!host->card || mmc_card_removed(host->card))
>                 return 1;
>
> +       if (host->trigger_replug_state == MMC_REPLUG_STATE_UNPLUG) {
> +               mmc_card_set_removed(host->card);
> +               return 1;

Do you really need to set state of the card to "removed"?

If I understand correctly, what you need is to allow mmc_rescan() to
run a second time, in particular for non removable cards.

In that path, mmc_rescan should find the card being non-functional,
thus it should remove it and then try to re-initialize it again. Etc.

Do you want me to send a patch to show you what I mean!?

[...]

Kind regards
Uffe
