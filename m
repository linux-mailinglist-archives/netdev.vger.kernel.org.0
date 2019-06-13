Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F254502D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfFMXmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:42:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40318 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfFMXmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:42:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so179951pla.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 16:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qJQX+GLD4fwd+GCBrIWjKsA+IAvGAyQwTSeSX2BSMJY=;
        b=LxynRClHhe6x/JL/spDHqC1iBz5ugcvqw4xyZsmxiWuMKvrTOMnUdqDKFM09vDQEXk
         g8D28Mk39C+APeBjMzbC1os4SM6ZMn7qrCbrNb3T3fGmWaX7RMSCe+s43sy4YLrsZYAK
         USjKgfZYVdMtiNjE5ywU7CUZvHRcPUBbocn+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qJQX+GLD4fwd+GCBrIWjKsA+IAvGAyQwTSeSX2BSMJY=;
        b=FcLN+4o6Q9V1Y78yPZ3KRQFfTG2jRM2aXK7eDM2ZYmMn6gPhz3XZMZxnQmupJn9rf7
         WYYjRzUfcNITo7Fso8C2rpgZedIz8YA00Z7jisXi9IyD2jNsKWUcwMihOtcG9ovBf1mc
         g8X0sh6rrMQ1NySRn+xtUQdSg3ERsuQx5buOz72pQ4Yrtpt9FAZFmx08hjGPGwC1NN81
         6I9uazWxRhQsC2Sfpo/QfQnNfeqww68vfz3pKm++AKNjgRccS7NjlCfwj3WhcBFtgEZO
         Lq3HIBxwxWuXH0lZAGWSytn28Zh6ffvGQcHa+QMYTlzsYD5cIEfS2l2AtKDFqGy6Shte
         HV3g==
X-Gm-Message-State: APjAAAXv5L/PUPH3KJ7/KkL1iuHD7f9u6tS8J/qLAzO3wwNFAeh60ltD
        Ta7FZKRIA4mNRtNUIZoJbi3vTw==
X-Google-Smtp-Source: APXvYqyHvmG/55d6riqeb8uT5XjZFjeg3M6IzV8m9M1TGxU2K10/XPwKK4EKmj4io0cDJZmrlM1FDg==
X-Received: by 2002:a17:902:2a26:: with SMTP id i35mr51358780plb.315.1560469328377;
        Thu, 13 Jun 2019 16:42:08 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p7sm781088pfp.131.2019.06.13.16.42.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 16:42:07 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Douglas Anderson <dianders@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 0/5] brcmfmac: sdio: Deal better w/ transmission errors related to idle
Date:   Thu, 13 Jun 2019 16:41:48 -0700
Message-Id: <20190613234153.59309-1-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to deal better with the expected transmission
errors related to the idle states (handled by the Always-On-Subsystem
or AOS) on the SDIO-based WiFi on rk3288-veyron-minnie,
rk3288-veyron-speedy, and rk3288-veyron-mickey.

Some details about those errors can be found in
<https://crbug.com/960222>, but to summarize it here: if we try to
send the wakeup command to the WiFi card at the same time it has
decided to wake up itself then it will behave badly on the SDIO bus.
This can cause timeouts or CRC errors.

When I tested on 4.19 and 4.20 these CRC errors can be seen to cause
re-tuning.  Since I am currently developing on 4.19 this was the
original problem I attempted to solve.

On mainline it turns out that you don't see the retuning errors but
you see tons of spam about timeouts trying to wakeup from sleep.  I
tracked down the commit that was causing that and have partially
reverted it here.  I have no real knowledge about Broadcom WiFi, but
the commit that was causing problems sounds (from the descriptioin) to
be a hack commit penalizing all Broadcom WiFi users because of a bug
in a Cypress SD controller.  I will let others comment if this is
truly the case and, if so, what the right solution should be.

For v3 of this series I have added 2 patches to the end of the series
to address errors that would show up on systems with these same SDIO
WiFi cards when used on controllers that do periodic retuning.  These
systems need an extra fix to prevent the retuning from happening when
the card is asleep.

Changes in v4:
- Moved to SDIO API only (Adrian, Ulf).
- Renamed to make it less generic, now retune_crc_disable (Ulf).
- Function header makes it clear host must be claimed (Ulf).
- No more WARN_ON (Ulf).
- Adjust to API rename (Adrian, Ulf).
- Moved retune hold/release to SDIO API (Adrian).
- Adjust to API rename (Adrian).

Changes in v3:
- Took out the spinlock since I believe this is all in one context.
- Expect errors for all of brcmf_sdio_kso_control() (Adrian).
- ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.
- ("brcmfmac: sdio: Don't tune while the card is off") new for v3.

Changes in v2:
- A full revert, not just a partial one (Arend).  ...with explicit Cc.
- Updated commit message to clarify based on discussion of v1.

Douglas Anderson (5):
  Revert "brcmfmac: disable command decode in sdio_aos"
  mmc: core: API to temporarily disable retuning for SDIO CRC errors
  brcmfmac: sdio: Disable auto-tuning around commands expected to fail
  mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
  brcmfmac: sdio: Don't tune while the card is off

 drivers/mmc/core/core.c                       |  5 +-
 drivers/mmc/core/sdio_io.c                    | 76 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 +++--
 include/linux/mmc/core.h                      |  2 +
 include/linux/mmc/host.h                      |  1 +
 include/linux/mmc/sdio_func.h                 |  6 ++
 6 files changed, 100 insertions(+), 7 deletions(-)

-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

