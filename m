Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C35C63679F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 00:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfFEWve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 18:51:34 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50750 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFEWve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 18:51:34 -0400
Received: by mail-it1-f195.google.com with SMTP id a186so198195itg.0
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 15:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5exRdrUtbUyeCW9OHOiVQExue5bAGFVKBlO3hebfXgU=;
        b=Dk9RMmCtQVXIS7madhd1BjIGxlHFetVfq7sbOV3EWXN3IwSUE/DPrHYpsPphGlpZdp
         BHeovziL9pxxS+tTeP0xK6McUug95q9Bg8Y37gyXYPKSOVcLIUnCYGxCzJPSw9Vl+yKo
         zIUCOhcg+0KFEG0qvEm7ONy/Tn4TbWmjqw05s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5exRdrUtbUyeCW9OHOiVQExue5bAGFVKBlO3hebfXgU=;
        b=hNpfBM1ntWnpnK9ACg2++R73+lWu9gc+m7E80pms7/C43f+20BmmyT6P3MPzKSq8SL
         xmH8moA5XviuqPcBul402fu+/zCgBL5tJavaUEIuFC/U0ZOJigAW73whngC8E7F4gdIr
         UH8RFIOFdh+uCmfS3uP6LpwToeArqGK4lgmWD+G4DcKPBbVv6E+UXXzYqmG9aeKyr++c
         kXIqXSm2UlY9EI+XrmU9Jjk80/sPr0OZNS7iTJ24+WXlh8TfcOIIPC9jd61nlGrfhChc
         L4wn5RCBexvUQzye502fJV54eCotnzl8mHYtlpqSsW9CC/d+Av5/7ooFrF6+KCvDK5Cp
         sVRw==
X-Gm-Message-State: APjAAAV3asWZD+BO4n0Py4dsLajPVR326AvqeYFDMRjJNk/dFA2Sm6xx
        jw0DFqcNDFd02bkOrXhI40WsiyMgwC4=
X-Google-Smtp-Source: APXvYqxq3Wlrdbkeg4upspIRXis0dXUzQenDWShbo2VFYOP1Ko6TL5wJQIqSmZjMJVcLisYU+GBbxQ==
X-Received: by 2002:a24:378b:: with SMTP id r133mr26292318itr.154.1559775092713;
        Wed, 05 Jun 2019 15:51:32 -0700 (PDT)
Received: from mail-it1-f179.google.com (mail-it1-f179.google.com. [209.85.166.179])
        by smtp.gmail.com with ESMTPSA id p130sm103177itd.19.2019.06.05.15.51.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 15:51:31 -0700 (PDT)
Received: by mail-it1-f179.google.com with SMTP id j204so175788ite.4
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 15:51:30 -0700 (PDT)
X-Received: by 2002:a24:5a06:: with SMTP id v6mr14776129ita.160.1559775090284;
 Wed, 05 Jun 2019 15:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190603183740.239031-1-dianders@chromium.org>
 <20190603183740.239031-3-dianders@chromium.org> <25fe1725-76fa-2739-1427-b0e8823ea4ae@broadcom.com>
In-Reply-To: <25fe1725-76fa-2739-1427-b0e8823ea4ae@broadcom.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 5 Jun 2019 15:51:19 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vu3p_Y=Q3PLj37nSOU2WH-SyaG5K=f0O_UKu1==Zj-eA@mail.gmail.com>
Message-ID: <CAD=FV=Vu3p_Y=Q3PLj37nSOU2WH-SyaG5K=f0O_UKu1==Zj-eA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mmc: core: API for temporarily disabling
 auto-retuning due to errors
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
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
        Linux MMC List <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jun 5, 2019 at 12:54 AM Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On 6/3/2019 8:37 PM, Douglas Anderson wrote:
> > Normally when the MMC core sees an "-EILSEQ" error returned by a host
> > controller then it will trigger a retuning of the card.  This is
> > generally a good idea.
> >
> > However, if a command is expected to sometimes cause transfer errors
> > then these transfer errors shouldn't cause a re-tuning.  This
> > re-tuning will be a needless waste of time.  One example case where a
> > transfer is expected to cause errors is when transitioning between
> > idle (sometimes referred to as "sleep" in Broadcom code) and active
> > state on certain Broadcom WiFi cards.  Specifically if the card was
> > already transitioning between states when the command was sent it
> > could cause an error on the SDIO bus.
> >
> > Let's add an API that the SDIO card drivers can call that will
> > temporarily disable the auto-tuning functionality.  Then we can add a
> > call to this in the Broadcom WiFi driver and any other driver that
> > might have similar needs.
> >
> > NOTE: this makes the assumption that the card is already tuned well
> > enough that it's OK to disable the auto-retuning during one of these
> > error-prone situations.  Presumably the driver code performing the
> > error-prone transfer knows how to recover / retry from errors.  ...and
> > after we can get back to a state where transfers are no longer
> > error-prone then we can enable the auto-retuning again.  If we truly
> > find ourselves in a case where the card needs to be retuned sometimes
> > to handle one of these error-prone transfers then we can always try a
> > few transfers first without auto-retuning and then re-try with
> > auto-retuning if the first few fail.
> >
> > Without this change on rk3288-veyron-minnie I periodically see this in
> > the logs of a machine just sitting there idle:
> >    dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ
> >
> > Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > ---
> > Note that are are a whole boatload of different ways that we could
> > provide an API for the Broadcom WiFi SDIO driver.  This patch
> > illustrates one way but if maintainers feel strongly that this is too
> > ugly and have a better idea then I can give it a shot too.  From a
> > purist point of view I kinda felt that the "expect errors" really
> > belonged as part of the mmc_request structure, but getting it into
> > there meant changing a whole pile of core SD/MMC APIs.  Simply adding
> > it to the host seemed to match the current style better and was a less
> > intrusive change.
>
> Hi Doug,
>
> Sorry for bringing this up, but there used to be an issue with retuning
> in general, ie. the device handled tuning command 19 only once after
> startup. I guess that is no longer an issue given your results.

Right.  It definitely used to just happen once at bootup and you were
out of luck if that value was bad for some reason or if conditions
changed.  In cases in my own personal experience it was actually fine
to just tune once at bootup once all the tuning bugs in the controller
were fixed.  ...but I can imagine that some controllers could use
delay elements that drift more.  ...and in any case if you're getting
CRC errors trying a re-tuning seems a sensible thing to do anyway
(unless the CRC error was expected).

Looking at commit bd11e8bd03ca ("mmc: core: Flag re-tuning is needed
on CRC errors") you can definitely see evidence that tuning can happen
again after bootup.


> I guess
> the problem goes away when you disable device sleep functionality. No
> what you want in terms of power consumption, but would be good to know.
> You can disable it with below patch.

I can try testing this if it's useful, but I'm not sure what it will
prove.  I definitely don't want to disable device sleep, so it's not a
long term solution.  Are you just looking for extra evidence that this
is indeed my problem?  I don't think I need any extra evidence, do I?
The fact that patch #3 in this series fixes my problems (plus
debugging I did to arrive at that patch) means we absolutely know that
brcmf_sdio_kso_control() is responsible for the CRC errors that caused
the unneeded tuning.  Setting BRCMF_IDLE_INTERVAL to 0 will
effectively prevent brcmf_sdio_kso_control() from doing anything
useful (except in full system suspend, but that's not the case I was
testing anyway).

-Doug
