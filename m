Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5319039409
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbfFGSNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:13:16 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36233 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730310AbfFGSNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:13:15 -0400
Received: by mail-it1-f194.google.com with SMTP id r135so4158484ith.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xLehMSYkK3XfUc0NYuOTQwZFYDyQEwqS9DQD1R1eHAk=;
        b=Htkn/o8Z18DC5jDpDQXQDKkSRSOkZr8DK1ynqG68Nsu83En9ojGIOff8TmkqZBRGpK
         CQjm63dpKUi/As2mwytCiEIv2F3dYXc/C26x5ekX0J67olxPg0C/uU6Azrdhx5oMfivO
         ANn2R3YckbO8MIPG6fFFFz7JF7EApgtYNH71E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xLehMSYkK3XfUc0NYuOTQwZFYDyQEwqS9DQD1R1eHAk=;
        b=aWVwacnLkNVVLaBelgwBnRKN1PEjpZ0InODMuoA7qqAj/6xfFKWtzJKoElQX1HLwlH
         hPijbVVF32l5pFDsigNnMRKI3NT08csYP27rIfMvBMqcNscqoA+J0gICdEmEX4sbVyLS
         6/2+pxw6mgYrYqNlLdUi0tkk/ldk9UBDfKw44nrjh0KI5tRqxdf+UGEnr8DDd49vYCb3
         tye8q86xUCPHYsLUdreNXUVOrKM0ce0hmtrMSyxPkYvzX3QOTYjG12IbW8N0+IeJ1z33
         2veGOZxvTAwmG3YMkSa/rWIuo9Qn7L7qd1Et8xbrPANoKGWoVDOmPs+zZOg7kc6DKCVt
         6Edg==
X-Gm-Message-State: APjAAAVsBjo5FsUeaqcclZthk0IbO2SnLUlQRGNH1DoGTe1fYebT6kps
        nhrIZAhdP1bt1Q/9SRi5biLBO3L+n10=
X-Google-Smtp-Source: APXvYqwBlZ/kc8FmdoNXfQinkwgrFqLYZVrPLYY/3tH1tOfJxI8GwEasa/uhdp+TisEFM9Lfpa13dA==
X-Received: by 2002:a05:660c:752:: with SMTP id a18mr4972756itl.63.1559931194442;
        Fri, 07 Jun 2019 11:13:14 -0700 (PDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com. [209.85.166.47])
        by smtp.gmail.com with ESMTPSA id p2sm1145306itb.29.2019.06.07.11.13.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 11:13:14 -0700 (PDT)
Received: by mail-io1-f47.google.com with SMTP id k13so2116041iop.5
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:13:14 -0700 (PDT)
X-Received: by 2002:a5e:db0a:: with SMTP id q10mr872549iop.168.1559930787784;
 Fri, 07 Jun 2019 11:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190603183740.239031-1-dianders@chromium.org>
 <20190603183740.239031-4-dianders@chromium.org> <42fc30b1-adab-7fa8-104c-cbb7855f2032@intel.com>
 <CAD=FV=UPfCOr-syAbVZ-FjHQy7bgQf5BS5pdV-Bwd3hquRqEGg@mail.gmail.com>
 <16b305a7110.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <ff0e7b7a-6a58-8bec-b182-944a8b64236d@intel.com> <16b3223dea0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <16b3223dea0.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 7 Jun 2019 11:06:16 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XVmCYWe9rtTFakq8yu67R-97EPyAHWck+o3dRXzHCchQ@mail.gmail.com>
Message-ID: <CAD=FV=XVmCYWe9rtTFakq8yu67R-97EPyAHWck+o3dRXzHCchQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
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
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 7, 2019 at 6:32 AM Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On June 7, 2019 2:40:04 PM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> > On 7/06/19 8:12 AM, Arend Van Spriel wrote:
> >> On June 6, 2019 11:37:22 PM Doug Anderson <dianders@chromium.org> wrote:
> >>>
> >>> In the case of dw_mmc, which I'm most familiar with, we don't have any
> >>> sort of automated or timed-based retuning.  ...so we'll only re-tune
> >>> when we see the CRC error.  If I'm understanding things correctly then
> >>> that for dw_mmc my solution and yours behave the same.  That means the
> >>> difference is how we deal with other retuning requests, either ones
> >>> that come about because of an interrupt that the host controller
> >>> provided or because of a timer.  Did I get that right?
> >>
> >> Right.
> >>
> >>> ...and I guess the reason we have to deal specially with these cases
> >>> is because any time that SDIO card is "sleeping" we don't want to
> >>> retune because it won't work.  Right?  NOTE: the solution that would
> >>> come to my mind first to solve this would be to hold the retuning for
> >>> the whole time that the card was sleeping and then release it once the
> >>> card was awake again.  ...but I guess we don't truly need to do that
> >>> because tuning only happens as a side effect of sending a command to
> >>> the card and the only command we send to the card is the "wake up"
> >>> command.  That's why your solution to hold tuning while sending the
> >>> "wake up" command works, right?
> >>
> >> Yup.
> >>
> >>> ---
> >>>
> >>> OK, so assuming all the above is correct, I feel like we're actually
> >>> solving two problems and in fact I believe we actually need both our
> >>> approaches to solve everything correctly.  With just your patch in
> >>> place there's a problem because we will clobber any external retuning
> >>> requests that happened while we were waking up the card.  AKA, imagine
> >>> this:
> >>>
> >>> A) brcmf_sdio_kso_control(on=True) gets called; need_retune starts as 0
> >>>
> >>> B) We call sdio_retune_hold_now()
> >>>
> >>> C) A retuning timer goes off or the SD Host controller tells us to retune
> >>>
> >>> D) We get to the end of brcmf_sdio_kso_control() and clear the "retune
> >>> needed" since need_retune was 0 at the start.
> >>>
> >>> ...so we dropped the retuning request from C), right?
> >>>
> >>>
> >>> What we truly need is:
> >>>
> >>> 1. CRC errors shouldn't trigger a retuning request when we're in
> >>> brcmf_sdio_kso_control()
> >>>
> >>> 2. A separate patch that holds any retuning requests while the SDIO
> >>> card is off.  This patch _shouldn't_ do any clearing of retuning
> >>> requests, just defer them.
> >>>
> >>>
> >>> Does that make sense to you?  If so, I can try to code it up...
> >>
> >> FWIW it does make sense to me. However, I am still not sure if our sdio
> >> hardware supports retuning. Have to track down an asic designer who can tell
> >> or dive into vhdl myself.
> >
> > The card supports re-tuning if is handles CMD19, which it does.  It is not
> > the card that does any tuning, only the host.  The card just helps by
> > providing a known data pattern in response to CMD19.  It can be that a card
> > provides good enough signals that the host should not need to re-tune.  I
> > don't know if that can be affected by the board design though.
>
> Right. I know it supports initial tuning, but I'm not sure about subsequent
> retuning initiated by the host controller.

My evidence says that it supports subsequent tuning.  In fact, without
this series my logs would be filled with:

  dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ

...where the phase varied by a few degrees each time.  AKA: it was
retuning over and over again and getting sane results which implies
that the tuning was working just fine.

The whole point of this series is not that the retuning was actually
broken or anything it was just pointless and blocking the bus while it
happened.  On rk3288 dw_mmc ports we also currently do pretty
extensive tuning, trying _lots_ of phases.  Thus the re-tuning was
blocking the bus for a significant amount of time.

-Doug
