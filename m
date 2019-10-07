Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5577CCEFAC
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 01:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfJGXju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 19:39:50 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44368 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbfJGXjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 19:39:49 -0400
Received: by mail-io1-f68.google.com with SMTP id w12so32512958iol.11
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 16:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PjC4IOE74uqk6BvdzjxTzi5lzmlkVlCf5u8wFkWOV1M=;
        b=FCzc0dVJaMula/54qVHjHdG5+S3RTJZtsnEQjayFHj/UgaXAkTNDkQvxpIyV2MbkVM
         VJCnCpcF/C5uksbCumurz92HwZiD2yiJo2mVj2UtgqibAfCSjpfxYpeLt67xQ3Go/Oj7
         qvR2ZwnciZv5TNaaBpr2KS/KnRvSVQfEqQO9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PjC4IOE74uqk6BvdzjxTzi5lzmlkVlCf5u8wFkWOV1M=;
        b=NMtk1xsAA6UA/91vwHyRb7LQoVaK5OfIN05EBdMRsck2VKOfzztN0Cm0pSA9+pxS9Z
         sQvzeNRFNM+HrbNPsmvtjdVsxOBmYY4iVDwdlX9TTjI2IwXqMNELfS2XMkCjuFvAvmAX
         pmow+Lc9NHcDIpW63hVXqm+EOX2dp3k09ksoTFD82+/nKzsnbe8Xj0QA0nJuvVaUnOtz
         GGb1kjTayo8vT/n44iQieT/bTBk1qwI5I7CZkjdaEiEiBn2O02bIhhIjVT505TDBwNVs
         HdTaCUf5W9oEDzXC0tEADFtWmEK2DJXIldB3rz/pTrubBV0TM9jspEhsW2lM01oIp13X
         UckA==
X-Gm-Message-State: APjAAAX01pSbQlJKnUxZpTli/xKnmWBur8XaVfrm4R3caNmp9eyMA+x9
        Ujyq43jUVGd6KSSGacrnHHS80tF5tjc=
X-Google-Smtp-Source: APXvYqwsQhM3X8KRVw66X6h7HxPpQocifackpxSJiFK678/hKfNbiMzo0vagjQ4l8oakth0dpBI4eQ==
X-Received: by 2002:a02:7b1e:: with SMTP id q30mr29272896jac.144.1570491588095;
        Mon, 07 Oct 2019 16:39:48 -0700 (PDT)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com. [209.85.166.42])
        by smtp.gmail.com with ESMTPSA id t16sm5618026iol.12.2019.10.07.16.39.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 16:39:47 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id c25so32538138iot.12
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 16:39:45 -0700 (PDT)
X-Received: by 2002:a92:4a11:: with SMTP id m17mr31969418ilf.142.1570491585206;
 Mon, 07 Oct 2019 16:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org>
 <CAPDyKFoND5Kaam72zxO4wChO0z_1XL2KWX6oNjVcMUGA7G8RFg@mail.gmail.com>
 <CAD=FV=VTLoqGbxFFMT8h72cfHCLupyvZpD75JB0N86+kFA+vzw@mail.gmail.com> <CAPDyKFrPHguMrMvXN0yHbD9GmEg4m=J1Un=LcpE0PB7WqMRYSg@mail.gmail.com>
In-Reply-To: <CAPDyKFrPHguMrMvXN0yHbD9GmEg4m=J1Un=LcpE0PB7WqMRYSg@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 7 Oct 2019 16:39:32 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W-qh2NnDc-C1_Tki3=D7vzNGG2PgnZjCjdLU9gL68AxA@mail.gmail.com>
Message-ID: <CAD=FV=W-qh2NnDc-C1_Tki3=D7vzNGG2PgnZjCjdLU9gL68AxA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: core: Fix Marvell WiFi reset by adding SDIO
 API to replug card
To:     Ulf Hansson <ulf.hansson@linaro.org>
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 16, 2019 at 2:25 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Wed, 11 Sep 2019 at 23:26, Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
> >
> > On Thu, Jul 25, 2019 at 6:28 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> > >
> > > On Mon, 22 Jul 2019 at 21:41, Douglas Anderson <dianders@chromium.org> wrote:
> > > >
> > > > As talked about in the thread at:
> > > >
> > > > http://lkml.kernel.org/r/CAD=FV=X7P2F1k_zwHc0mbtfk55-rucTz_GoDH=PL6zWqKYcpuw@mail.gmail.com
> > > >
> > > > ...when the Marvell WiFi card tries to reset itself it kills
> > > > Bluetooth.  It was observed that we could re-init the card properly by
> > > > unbinding / rebinding the host controller.  It was also observed that
> > > > in the downstream Chrome OS codebase the solution used was
> > > > mmc_remove_host() / mmc_add_host(), which is similar to the solution
> > > > in this series.
> > > >
> > > > So far I've only done testing of this series using the reset test
> > > > source that can be simulated via sysfs.  Specifically I ran this test:
> > > >
> > > > for i in $(seq 1000); do
> > > >   echo "LOOP $i --------"
> > > >   echo 1 > /sys/kernel/debug/mwifiex/mlan0/reset
> > > >
> > > >   while true; do
> > > >     if ! ping -w15 -c1 "${GW}" >/dev/null 2>&1; then
> > > >       fail=$(( fail + 1 ))
> > > >       echo "Fail WiFi ${fail}"
> > > >       if [[ ${fail} == 3 ]]; then
> > > >         exit 1
> > > >       fi
> > > >     else
> > > >       fail=0
> > > >       break
> > > >     fi
> > > >   done
> > > >
> > > >   hciconfig hci0 down
> > > >   sleep 1
> > > >   if ! hciconfig hci0 up; then
> > > >     echo "Fail BT"
> > > >     exit 1
> > > >   fi
> > > > done
> > > >
> > > > I ran this several times and got several hundred iterations each
> > > > before a failure.  When I saw failures:
> > > >
> > > > * Once I saw a "Fail BT"; manually resetting the card again fixed it.
> > > >   I didn't give it time to see if it would have detected this
> > > >   automatically.
> > > > * Once I saw the ping fail because (for some reason) my device only
> > > >   got an IPv6 address from my router and the IPv4 ping failed.  I
> > > >   changed my script to use 'ping6' to see if that would help.
> > > > * Once I saw the ping fail because the higher level network stack
> > > >   ("shill" in my case) seemed to crash.  A few minutes later the
> > > >   system recovered itself automatically.  https://crbug.com/984593 if
> > > >   you want more details.
> > > > * Sometimes while I was testing I saw "Fail WiFi 1" indicating a
> > > >   transitory failure.  Usually this was an association failure, but in
> > > >   one case I saw the device do "Firmware wakeup failed" after I
> > > >   triggered the reset.  This caused the driver to trigger a re-reset
> > > >   of itself which eventually recovered things.  This was good because
> > > >   it was an actual test of the normal reset flow (not the one
> > > >   triggered via sysfs).
> > > >
> > > > Changes in v2:
> > > > - s/routnine/routine (Brian Norris, Matthias Kaehlcke).
> > > > - s/contining/containing (Matthias Kaehlcke).
> > > > - Add Matthias Reviewed-by tag.
> > > > - Removed clear_bit() calls and old comment (Brian Norris).
> > > > - Explicit CC of Andreas Fenkart.
> > > > - Explicit CC of Brian Norris.
> > > > - Add "Fixes" pointing at the commit Brian talked about.
> > > > - Add Brian's Reviewed-by tag.
> > > >
> > > > Douglas Anderson (2):
> > > >   mmc: core: Add sdio_trigger_replug() API
> > > >   mwifiex: Make use of the new sdio_trigger_replug() API to reset
> > > >
> > > >  drivers/mmc/core/core.c                     | 28 +++++++++++++++++++--
> > > >  drivers/mmc/core/sdio_io.c                  | 20 +++++++++++++++
> > > >  drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +-----------
> > > >  include/linux/mmc/host.h                    | 15 ++++++++++-
> > > >  include/linux/mmc/sdio_func.h               |  2 ++
> > > >  5 files changed, 63 insertions(+), 18 deletions(-)
> > > >
> > >
> > > Doug, thanks for sending this!
> > >
> > > As you know, I have been working on additional changes for SDIO
> > > suspend/resume (still WIP and not ready for sharing) and this series
> > > is related.
> > >
> > > The thing is, that even during system suspend/resume, synchronizations
> > > are needed between the different layers (mmc host, mmc core and
> > > sdio-funcs), which is common to the problem you want to solve.
> > >
> > > That said, I need to scratch my head a bit more before I can provide
> > > you some feedback on $subject series. Moreover, it's vacation period
> > > at my side so things are moving a bit slower. Please be patient.
> >
> > I had kinda forgotten about this series after we landed it locally in
> > Chrome OS, but I realized that it never got resolved upstream.  Any
> > chance your head has been sufficiently scratched and you're now happy
> > with $subject series?  ;-)
>
> It's still on my TODO list. Apologize for the delay, but I still need
> more time to look into it, possibly later this week.
>
> In any case, let's make sure we get this problem resolved for v5.5.

Hi Ulf.  It's your friendly pest, Doug, here to ask how things are going.  :-P


-Doug
