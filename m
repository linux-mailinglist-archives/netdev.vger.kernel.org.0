Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18A549F64
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 13:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfFRLlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 07:41:20 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:39477 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729744AbfFRLlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 07:41:14 -0400
Received: by mail-vk1-f195.google.com with SMTP id o19so2737971vkb.6
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 04:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXKWHfiW2fK/oNHPaHV17m2/kXsIPSmEkP6INcYYU9o=;
        b=DbVcJjtjVOUaGpNKJ/DvdYK1FZNzvJnwIpOr3/kA2dreAHCj5DcjBfjZnEnYIrIL9Q
         gq7+EeNVE7nyL4th2fgWCodJu4sRMGXCIaIuRnP5IfcYW4NiepE4lr7gs5enJz5tCw7h
         TtYwfBPaT23F4mPYlUpktE1WjGcT41EhSwpTjDsKDZs9r5rQu8WyDZgBYo1DAdw2a3dR
         Nksam9I88iVRBmH9PNaflQd7Fj28V2t/rj80Z2I9WIYVyxbBH3N22NG6Cv7visa5uDhj
         UZ1yOk9v4J+/L/pEamjjXplcvuLmdPFTyfd9tkHBax7Y6B0OBcNQlPc+nFSUEoGFDVY1
         JKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXKWHfiW2fK/oNHPaHV17m2/kXsIPSmEkP6INcYYU9o=;
        b=ZDRV6xORikCraeU891M9EYwgwrwrSw9kgeGgwsthV4epHYfXwTWbHbgk0Pw0Y+eq36
         OEfo50xFAIYxFzRCuDdR1nAsqYbzYwu3YmlgG9Llqonvda0fhLjeBZfXZG9RcYG6mD9z
         pbUTBwP3HpGov56eIGhbZrmoNxM1qgGrgd9UoUtm7gWafXPJAyI/pFfTpM4CuwMfX4bg
         xXWGKQOfVGVuWVv3CRoStCK+s9ECSMwaxIru1RxkDIdSHSsbDvTl+KX1gniWo7E5ioou
         YCKADWyOUtACZOBOZI9UBxYSfaM8xRASRp2pniByOYrMjfZM7YQaOrMx1xPSTKB81gq7
         cZlw==
X-Gm-Message-State: APjAAAVggGwPiqmD/A5qxz+cjIHqUFYEwZBZomcW3nyyQeAijxqp99n+
        NMthAyVBRtpaIJcA366Cm1C/t5RT7OjwhE4LoLK95Q==
X-Google-Smtp-Source: APXvYqzAl7wJEEH+9xHNdBIPLlWcQNm3f6xV2K4I/CyVeso07z7k2+LL7fMznGVsUFSpo4IawQFtCpaHljxygG765/Q=
X-Received: by 2002:a1f:ab04:: with SMTP id u4mr26393129vke.40.1560858072830;
 Tue, 18 Jun 2019 04:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190617175653.21756-1-dianders@chromium.org> <CAPDyKFpaX6DSM_BjtghAHUf7qYCyEG+wMagXPUdgz3Eutovqfw@mail.gmail.com>
 <87v9x39mxf.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87v9x39mxf.fsf@kamboji.qca.qualcomm.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 18 Jun 2019 13:40:36 +0200
Message-ID: <CAPDyKFqGtui4+shA0TENF=h6Zk0_tgQaJTNSP1xakw7Nb12irg@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] brcmfmac: sdio: Deal better w/ transmission errors
 related to idle
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Douglas Anderson <dianders@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 at 13:02, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Ulf Hansson <ulf.hansson@linaro.org> writes:
>
> > On Mon, 17 Jun 2019 at 19:57, Douglas Anderson <dianders@chromium.org> wrote:
> >>
> >> This series attempts to deal better with the expected transmission
> >> errors related to the idle states (handled by the Always-On-Subsystem
> >> or AOS) on the SDIO-based WiFi on rk3288-veyron-minnie,
> >> rk3288-veyron-speedy, and rk3288-veyron-mickey.
> >>
> >> Some details about those errors can be found in
> >> <https://crbug.com/960222>, but to summarize it here: if we try to
> >> send the wakeup command to the WiFi card at the same time it has
> >> decided to wake up itself then it will behave badly on the SDIO bus.
> >> This can cause timeouts or CRC errors.
> >>
> >> When I tested on 4.19 and 4.20 these CRC errors can be seen to cause
> >> re-tuning.  Since I am currently developing on 4.19 this was the
> >> original problem I attempted to solve.
> >>
> >> On mainline it turns out that you don't see the retuning errors but
> >> you see tons of spam about timeouts trying to wakeup from sleep.  I
> >> tracked down the commit that was causing that and have partially
> >> reverted it here.  I have no real knowledge about Broadcom WiFi, but
> >> the commit that was causing problems sounds (from the descriptioin) to
> >> be a hack commit penalizing all Broadcom WiFi users because of a bug
> >> in a Cypress SD controller.  I will let others comment if this is
> >> truly the case and, if so, what the right solution should be.
> >>
> >> For v3 of this series I have added 2 patches to the end of the series
> >> to address errors that would show up on systems with these same SDIO
> >> WiFi cards when used on controllers that do periodic retuning.  These
> >> systems need an extra fix to prevent the retuning from happening when
> >> the card is asleep.
> >>
> >> I believe v5 of this series is all ready to go assuming Kalle Valo is
> >> good with it.  I've added after-the-cut notes to patches awaiting his
> >> Ack and have added other tags collected so far.
> >>
> >> Changes in v5:
> >> - Add missing sdio_retune_crc_enable() in comments (Ulf).
> >> - /s/reneable/re-enable (Ulf).
> >> - Remove leftover prototypes: mmc_expect_errors_begin() / end() (Ulf).
> >> - Rewording of "sleep command" in commit message (Arend).
> >>
> >> Changes in v4:
> >> - Moved to SDIO API only (Adrian, Ulf).
> >> - Renamed to make it less generic, now retune_crc_disable (Ulf).
> >> - Function header makes it clear host must be claimed (Ulf).
> >> - No more WARN_ON (Ulf).
> >> - Adjust to API rename (Adrian, Ulf).
> >> - Moved retune hold/release to SDIO API (Adrian).
> >> - Adjust to API rename (Adrian).
> >>
> >> Changes in v3:
> >> - Took out the spinlock since I believe this is all in one context.
> >> - Expect errors for all of brcmf_sdio_kso_control() (Adrian).
> >> - ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.
> >> - ("brcmfmac: sdio: Don't tune while the card is off") new for v3.
> >>
> >> Changes in v2:
> >> - A full revert, not just a partial one (Arend).  ...with explicit Cc.
> >> - Updated commit message to clarify based on discussion of v1.
> >>
> >> Douglas Anderson (5):
> >>   Revert "brcmfmac: disable command decode in sdio_aos"
> >>   mmc: core: API to temporarily disable retuning for SDIO CRC errors
> >>   brcmfmac: sdio: Disable auto-tuning around commands expected to fail
> >>   mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
> >>   brcmfmac: sdio: Don't tune while the card is off
> >>
> >>  drivers/mmc/core/core.c                       |  5 +-
> >>  drivers/mmc/core/sdio_io.c                    | 77 +++++++++++++++++++
> >>  .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 ++--
> >>  include/linux/mmc/host.h                      |  1 +
> >>  include/linux/mmc/sdio_func.h                 |  6 ++
> >>  5 files changed, 99 insertions(+), 7 deletions(-)
> >>
> >> --
> >> 2.22.0.410.gd8fdbe21b5-goog
> >>
> >
> > Applied for fixes, thanks!
> >
> > Some minor changes:
> > 1) Dropped the a few "commit notes", that was more related to version
> > and practical information about the series.
> > 2) Dropped fixes tags for patch 2->5, but instead put a stable tag
> > targeted for v4.18+.
> >
> > Awaiting an ack from Kalle before sending the PR to Linus.
> >
> > Kalle, perhaps you prefer to pick patch 1, as it could go separate.
> > Then please tell - and/or if there is anything else you want me to
> > change.
>
> TBH I haven't followed the thread (or patches) that closely :) So feel
> free to take them and push them to Linus.
>

I take that as an ack and will add your tag for it, thanks!

Kind regards
Uffe
