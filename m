Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1237A350
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfG3IrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:47:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41339 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbfG3IrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:47:09 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so122176665ioj.8;
        Tue, 30 Jul 2019 01:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tweUbVZ3TlHSrmKd5A3NkGv9TQYFvzxkm9AoWsk/q30=;
        b=Lnm5pWMO9gDB+xSAlEIw37rit9GWukpli0ciwz3KX3p4EfASEW3ma4NWF3a/1SQXcU
         3arAYwANOaLQH2rJGpccnOvhSUOd6E87lZbFx7BMyf1JRCphLtU1sS52m3ydPtp6jcj3
         7nRj9tovKZ179EkLYguciarwpTad2g/pOd/FrbAm6ldq6ZhS9rkU/7oXpA0kC9utTGWw
         f07hrfSKHY7iyaUEFy0bzUcUYeAcEwU2ckzmi6YX4x3OWm6iXJ6VGlJC+6+fyJbS8uQT
         Ji9nQO6BrVSNMXHXWAV0iwKWe80HuhEmsoSrAo8DSrKUhhHIPD2lSe6tgX3Taivh+AAO
         60TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tweUbVZ3TlHSrmKd5A3NkGv9TQYFvzxkm9AoWsk/q30=;
        b=btCIApKprYjyceVNR9jiiledXj6ajKqlbMi7wNxgcGZ24+sXAJu8B/Stw4k+CeHGUv
         fVQI85frjm3qzFVTDf2pc3jA4SM5XZu3hf97nlDkm6neM6b3QN2gS07Q84db/H9wTLaD
         Ee8sDvthK7LaDQfhjtDQCDdjWSfyGUcrEKJrhhLHhcuQebIvMHrn3SOevK9dSSLKuDcu
         RxUmf80m/N1hlNojv4jN2XDqNNu66C9WkMoqaymr3blyBEIH4EdTIjw1L/WVXNY50q+w
         h+6mH7Rb+XxLlduHclQ8YGWKFbk71P7zQNNsBdOVnrjQUuTzazyRHBB3X6iBsqHpCBAe
         ImVA==
X-Gm-Message-State: APjAAAW/tgkepv36R2O0+Nx06Yqv+kF/w3ZVTjJoghaRXA0Nm4lvDRMz
        QNnYKHD4hlGchAkNXWJCqTNuep8ncXI9JC73I/g=
X-Google-Smtp-Source: APXvYqz0CFC15wZ2XiWoOhayfdcusTMEkipxhXpT31Qa/75EYarCxrEJN+xvSNxVibKyB1L6/NT5tPx8w8nEPvXN8xY=
X-Received: by 2002:a6b:e60b:: with SMTP id g11mr110036034ioh.9.1564476427973;
 Tue, 30 Jul 2019 01:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org>
In-Reply-To: <20190722193939.125578-1-dianders@chromium.org>
From:   Andreas Fenkart <afenkart@gmail.com>
Date:   Tue, 30 Jul 2019 10:46:56 +0200
Message-ID: <CALtMJEB871Redpzx1u6G5GVEXz-kAP=vT6Wt98=X=xm4SEMeAQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: core: Fix Marvell WiFi reset by adding SDIO
 API to replug card
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Douglas,

Am Mo., 22. Juli 2019 um 21:41 Uhr schrieb Douglas Anderson
<dianders@chromium.org>:
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

This error triggers something. I remember that when I was working on
suspend-to-ram feature, we had problems to wake up the firmware
reliable. I found this patch in one of my old 3.13 tree

    the missing bit -- ugly hack to force cmd52 before cmd53.
---
 drivers/mmc/host/omap_hsmmc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index fb24a006080f..710d0bdf39e5 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2372,6 +2372,12 @@ static int omap_hsmmc_suspend(struct device *dev)
        if (host->flags & HSMMC_SWAKEUP_QUIRK)
                disable_irq(host->gpio_sdio_irq);

+       /*
+        * force a polling cycle after resume.
+        * will issue cmd52, not cmd53 straight away
+        */
+       omap_hsmmc_enable_sdio_irq(host->mmc, false);
+
        if (host->dbclk)
                clk_disable_unprepare(host->dbclk);

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
> --
> 2.22.0.657.g960e92d24f-goog
>
