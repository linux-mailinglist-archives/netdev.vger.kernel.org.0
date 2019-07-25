Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B122874F6D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfGYN2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:28:49 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33110 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfGYN2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:28:49 -0400
Received: by mail-vs1-f68.google.com with SMTP id m8so33770151vsj.0
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 06:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vXKNB/T35UEJpgjy5bQMa/g2p0OKD2QzsqlMlAa6XPw=;
        b=f/uQQYPHA8g4EJYLPYLuJ1y5iqC+JXr+y3ZExBNQFRTKMBE0ptdYkfXtsOwg8bWulp
         zZ8vUXVHZTtT4veYqE6FY3J9yFjAWOKah4KLs0giuYjbw9oX80NdYOLQLeEpMoPXSM6F
         LNu9DnmAgcDf2vlgWEuiZiTg9pVoHA9Kkn6k5l9MtGEZO/630B/DkxncJQpZvT08FtmE
         ifzxx8MnhDevDnFLTEhcuytmqcQSWHjXXKaWyxOrUa4+IMAdtbxkxnY+4AzTBJuCCibf
         ZN5FXJyrsuZFnYPkovS2Im/Jo42DNXFxP9f+RaIyJMosOPS+ykDNufilHeZ0jIjlcLVL
         uwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vXKNB/T35UEJpgjy5bQMa/g2p0OKD2QzsqlMlAa6XPw=;
        b=QmBdHM8hzPxXNQU9vp21SSzn4Jx2bXge1rVaFLnL54n5FMGMYV8PEHoM9vZ+2pOJCQ
         3Z058pTM7GNEwRoo822PgPXwsRRv4DbVVZ/KTxvixn8ngdlDyZJN4IaQbfWBsD3lNZLF
         Fz80k2p19KBUNOC1iew1+F+7wxI+mj/jzC/eZIbiyVniq6RX4/Ef6OYP0t6ECuvR/lpA
         xuBSf3QMvZ8jMN4k/bjCOcxhFNxbEvTZVUTY0Z7TY/uxhdNeTTjWC6r4TxbdBEVCsHKQ
         qUjDJxZjvHelNBxTTPe+WRU7azyWOdHS9ht4txIZstS7o4INX9y2EbjS62xyFFhj/5Jx
         Bc3w==
X-Gm-Message-State: APjAAAU6AaZitoTHnuSAkhCSlrs03+yGetZkFw3vazRhjzC4yIYrbG61
        YRVA5ppecgT69mb9UDOg+icphfgTMk48QK/RQGNzEg==
X-Google-Smtp-Source: APXvYqxQVUGQaO08z8JvqC/8hjWZk0eU15RGOsp4tEzLJQFfOVWtNAiPhhBmEDA9IIpQqprtF6qepXrstTHdGFfN0SU=
X-Received: by 2002:a67:61c7:: with SMTP id v190mr4507235vsb.165.1564061327635;
 Thu, 25 Jul 2019 06:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org>
In-Reply-To: <20190722193939.125578-1-dianders@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 25 Jul 2019 15:28:11 +0200
Message-ID: <CAPDyKFoND5Kaam72zxO4wChO0z_1XL2KWX6oNjVcMUGA7G8RFg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: core: Fix Marvell WiFi reset by adding SDIO
 API to replug card
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
> As talked about in the thread at:
>
> http://lkml.kernel.org/r/CAD=FV=X7P2F1k_zwHc0mbtfk55-rucTz_GoDH=PL6zWqKYcpuw@mail.gmail.com
>
> ...when the Marvell WiFi card tries to reset itself it kills
> Bluetooth.  It was observed that we could re-init the card properly by
> unbinding / rebinding the host controller.  It was also observed that
> in the downstream Chrome OS codebase the solution used was
> mmc_remove_host() / mmc_add_host(), which is similar to the solution
> in this series.
>
> So far I've only done testing of this series using the reset test
> source that can be simulated via sysfs.  Specifically I ran this test:
>
> for i in $(seq 1000); do
>   echo "LOOP $i --------"
>   echo 1 > /sys/kernel/debug/mwifiex/mlan0/reset
>
>   while true; do
>     if ! ping -w15 -c1 "${GW}" >/dev/null 2>&1; then
>       fail=$(( fail + 1 ))
>       echo "Fail WiFi ${fail}"
>       if [[ ${fail} == 3 ]]; then
>         exit 1
>       fi
>     else
>       fail=0
>       break
>     fi
>   done
>
>   hciconfig hci0 down
>   sleep 1
>   if ! hciconfig hci0 up; then
>     echo "Fail BT"
>     exit 1
>   fi
> done
>
> I ran this several times and got several hundred iterations each
> before a failure.  When I saw failures:
>
> * Once I saw a "Fail BT"; manually resetting the card again fixed it.
>   I didn't give it time to see if it would have detected this
>   automatically.
> * Once I saw the ping fail because (for some reason) my device only
>   got an IPv6 address from my router and the IPv4 ping failed.  I
>   changed my script to use 'ping6' to see if that would help.
> * Once I saw the ping fail because the higher level network stack
>   ("shill" in my case) seemed to crash.  A few minutes later the
>   system recovered itself automatically.  https://crbug.com/984593 if
>   you want more details.
> * Sometimes while I was testing I saw "Fail WiFi 1" indicating a
>   transitory failure.  Usually this was an association failure, but in
>   one case I saw the device do "Firmware wakeup failed" after I
>   triggered the reset.  This caused the driver to trigger a re-reset
>   of itself which eventually recovered things.  This was good because
>   it was an actual test of the normal reset flow (not the one
>   triggered via sysfs).
>
> Changes in v2:
> - s/routnine/routine (Brian Norris, Matthias Kaehlcke).
> - s/contining/containing (Matthias Kaehlcke).
> - Add Matthias Reviewed-by tag.
> - Removed clear_bit() calls and old comment (Brian Norris).
> - Explicit CC of Andreas Fenkart.
> - Explicit CC of Brian Norris.
> - Add "Fixes" pointing at the commit Brian talked about.
> - Add Brian's Reviewed-by tag.
>
> Douglas Anderson (2):
>   mmc: core: Add sdio_trigger_replug() API
>   mwifiex: Make use of the new sdio_trigger_replug() API to reset
>
>  drivers/mmc/core/core.c                     | 28 +++++++++++++++++++--
>  drivers/mmc/core/sdio_io.c                  | 20 +++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +-----------
>  include/linux/mmc/host.h                    | 15 ++++++++++-
>  include/linux/mmc/sdio_func.h               |  2 ++
>  5 files changed, 63 insertions(+), 18 deletions(-)
>

Doug, thanks for sending this!

As you know, I have been working on additional changes for SDIO
suspend/resume (still WIP and not ready for sharing) and this series
is related.

The thing is, that even during system suspend/resume, synchronizations
are needed between the different layers (mmc host, mmc core and
sdio-funcs), which is common to the problem you want to solve.

That said, I need to scratch my head a bit more before I can provide
you some feedback on $subject series. Moreover, it's vacation period
at my side so things are moving a bit slower. Please be patient.

Kind regards
Uffe
