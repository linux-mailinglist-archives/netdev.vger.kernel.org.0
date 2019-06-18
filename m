Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF049F91
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 13:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbfFRLrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 07:47:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfFRLrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 07:47:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE02E6090E; Tue, 18 Jun 2019 11:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560858458;
        bh=zsiyismHkNaIwa20jYT3ygpjBUSpDFV20h1wHyoiRi4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H5tfAqm20VO08QFGVdOVOtMkcVVGFL246Sf3UyVYR2o3TEG6v5OeIXMB8aHE8WN33
         pDspwYOueoJUPxXUit0AQPkd4sK0qCot1aRU7IsQraLuq+vH5r7fO6vlyFCDXr8Nol
         z4SSAolCahXWQV4OslSkw2Crm+rq16NTPpqxpa7c=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99F376028D;
        Tue, 18 Jun 2019 11:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560858456;
        bh=zsiyismHkNaIwa20jYT3ygpjBUSpDFV20h1wHyoiRi4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lWS5vBN2n7mllaKBfP/xGUE/WXX3mG7tlT+2NMunARaEo6J1Emg3O4Bd61KfgDnIm
         tS+SssTn8qjpetiuUWVaLkZGKYxngG+qLqIj7cxilaIwLuiNDycKy6gHTRjyNTfOof
         5NF9IZc9lCRLoudqobxCMnGqIAVsAeTxfbXyP68Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99F376028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Douglas Anderson <dianders@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list\:ARM\/Rockchip SoC..." 
        <linux-rockchip@lists.infradead.org>,
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
        Niklas =?utf-8?Q?S=C3=B6derl?= =?utf-8?Q?und?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v5 0/5] brcmfmac: sdio: Deal better w/ transmission errors related to idle
References: <20190617175653.21756-1-dianders@chromium.org>
        <CAPDyKFpaX6DSM_BjtghAHUf7qYCyEG+wMagXPUdgz3Eutovqfw@mail.gmail.com>
        <87v9x39mxf.fsf@kamboji.qca.qualcomm.com>
        <CAPDyKFoE0+KNBT5j3_VpJKcztghVa-eFJhy8887bZcUk8bfN2Q@mail.gmail.com>
Date:   Tue, 18 Jun 2019 14:47:27 +0300
In-Reply-To: <CAPDyKFoE0+KNBT5j3_VpJKcztghVa-eFJhy8887bZcUk8bfN2Q@mail.gmail.com>
        (Ulf Hansson's message of "Tue, 18 Jun 2019 13:28:10 +0200")
Message-ID: <87ef3r9kts.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On Tue, 18 Jun 2019 at 13:02, Kalle Valo <kvalo@codeaurora.org> wrote:
>
>     Ulf Hansson <ulf.hansson@linaro.org> writes:
>     
>     > On Mon, 17 Jun 2019 at 19:57, Douglas Anderson
>     <dianders@chromium.org> wrote:
>     >>
>     >> This series attempts to deal better with the expected
>     transmission
>     >> errors related to the idle states (handled by the
>     Always-On-Subsystem
>     >> or AOS) on the SDIO-based WiFi on rk3288-veyron-minnie,
>     >> rk3288-veyron-speedy, and rk3288-veyron-mickey.
>     >>
>     >> Some details about those errors can be found in
>     >> <https://crbug.com/960222>, but to summarize it here: if we try
>     to
>     >> send the wakeup command to the WiFi card at the same time it
>     has
>     >> decided to wake up itself then it will behave badly on the SDIO
>     bus.
>     >> This can cause timeouts or CRC errors.
>     >>
>     >> When I tested on 4.19 and 4.20 these CRC errors can be seen to
>     cause
>     >> re-tuning. Since I am currently developing on 4.19 this was the
>     >> original problem I attempted to solve.
>     >>
>     >> On mainline it turns out that you don't see the retuning errors
>     but
>     >> you see tons of spam about timeouts trying to wakeup from
>     sleep. I
>     >> tracked down the commit that was causing that and have
>     partially
>     >> reverted it here. I have no real knowledge about Broadcom WiFi,
>     but
>     >> the commit that was causing problems sounds (from the
>     descriptioin) to
>     >> be a hack commit penalizing all Broadcom WiFi users because of
>     a bug
>     >> in a Cypress SD controller. I will let others comment if this
>     is
>     >> truly the case and, if so, what the right solution should be.
>     >>
>     >> For v3 of this series I have added 2 patches to the end of the
>     series
>     >> to address errors that would show up on systems with these same
>     SDIO
>     >> WiFi cards when used on controllers that do periodic retuning.
>     These
>     >> systems need an extra fix to prevent the retuning from
>     happening when
>     >> the card is asleep.
>     >>
>     >> I believe v5 of this series is all ready to go assuming Kalle
>     Valo is
>     >> good with it. I've added after-the-cut notes to patches
>     awaiting his
>     >> Ack and have added other tags collected so far.
>     >>
>     >> Changes in v5:
>     >> - Add missing sdio_retune_crc_enable() in comments (Ulf).
>     >> - /s/reneable/re-enable (Ulf).
>     >> - Remove leftover prototypes: mmc_expect_errors_begin() / end()
>     (Ulf).
>     >> - Rewording of "sleep command" in commit message (Arend).
>     >>
>     >> Changes in v4:
>     >> - Moved to SDIO API only (Adrian, Ulf).
>     >> - Renamed to make it less generic, now retune_crc_disable
>     (Ulf).
>     >> - Function header makes it clear host must be claimed (Ulf).
>     >> - No more WARN_ON (Ulf).
>     >> - Adjust to API rename (Adrian, Ulf).
>     >> - Moved retune hold/release to SDIO API (Adrian).
>     >> - Adjust to API rename (Adrian).
>     >>
>     >> Changes in v3:
>     >> - Took out the spinlock since I believe this is all in one
>     context.
>     >> - Expect errors for all of brcmf_sdio_kso_control() (Adrian).
>     >> - ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release
>     ()") new for v3.
>     >> - ("brcmfmac: sdio: Don't tune while the card is off") new for
>     v3.
>     >>
>     >> Changes in v2:
>     >> - A full revert, not just a partial one (Arend). ...with
>     explicit Cc.
>     >> - Updated commit message to clarify based on discussion of v1.
>     >>
>     >> Douglas Anderson (5):
>     >> Revert "brcmfmac: disable command decode in sdio_aos"
>     >> mmc: core: API to temporarily disable retuning for SDIO CRC
>     errors
>     >> brcmfmac: sdio: Disable auto-tuning around commands expected to
>     fail
>     >> mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
>     >> brcmfmac: sdio: Don't tune while the card is off
>     >>
>     >> drivers/mmc/core/core.c | 5 +-
>     >> drivers/mmc/core/sdio_io.c | 77 +++++++++++++++++++
>     >> .../broadcom/brcm80211/brcmfmac/sdio.c | 17 ++--
>     >> include/linux/mmc/host.h | 1 +
>     >> include/linux/mmc/sdio_func.h | 6 ++
>     >> 5 files changed, 99 insertions(+), 7 deletions(-)
>     >>
>     >> --
>     >> 2.22.0.410.gd8fdbe21b5-goog
>     >>
>     >
>     > Applied for fixes, thanks!
>     >
>     > Some minor changes:
>     > 1) Dropped the a few "commit notes", that was more related to
>     version
>     > and practical information about the series.
>     > 2) Dropped fixes tags for patch 2->5, but instead put a stable
>     tag
>     > targeted for v4.18+.
>     >
>     > Awaiting an ack from Kalle before sending the PR to Linus.
>     >
>     > Kalle, perhaps you prefer to pick patch 1, as it could go
>     separate.
>     > Then please tell - and/or if there is anything else you want me
>     to
>     > change.
>     
>     TBH I haven't followed the thread (or patches) that closely :) So
>     feel
>     free to take them and push them to Linus.
>     
>
> I take that as an ack and will add your tag for it, thanks!

Yes, it was an ack :) I forgot to add:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

BTW, your previous mail was in HTML so most likely it didn't reach the
list.

-- 
Kalle Valo
