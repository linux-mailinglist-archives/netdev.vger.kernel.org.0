Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042D439909
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbfFGWhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:37:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34006 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbfFGWhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:37:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id h2so1877805pgg.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UkQI8hX0vIUpVc3tfTJ4CpjSb/8p01+g0dvWePLdY08=;
        b=e+vKvdKnQ/cr5CGuTa5EK01cZ+MfRnMYC41CccgXzHQwKg/POij2RhNAaHeGK5TdVM
         NYenBPuQyROBou1KlsUskYhDUQCGPp4n4PkvdKpwxUNIuxqAaQD3sMzt3joDkZBHy1C5
         6uAsWmd444nBt/Xf4T4r+T1ujKXJx+/0JVRuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UkQI8hX0vIUpVc3tfTJ4CpjSb/8p01+g0dvWePLdY08=;
        b=fLu7aF8JW0Z5FN7CVX+fK51VepzA4gMCpn1eG6RYquD7HX9VJ6/rQ8z/tOTSE7mWIa
         iCO/YjIAlUlUIRVhhTByIC/Cu/2TSd1WpFe3sU/xLFmVb5ZSKsNmhkD4Jdg4A3qtlmUX
         Rk/tKGQq8D+YqeFMnozSZbfut5jYhYRGlzi3J6uI4x3dzEzyetymHjO0Q3v52TV/PP9H
         jruindg5UAL5hUb2eD1GY2HnYwl5vSMFFAHPL4iY7lrO4k6vw2QtiAheZRRt3MSuSiIq
         M2AYziS2wPxWNu1wnraZjsomcqrF1GNRj9NZeHedNnyI6Y4tXiMMihQ5mn2N7BF40Vqj
         63GA==
X-Gm-Message-State: APjAAAW7Fcdg76VYjYmkoBSuA+TwJcKf4T+bYA2aR0oJ1rOL54SJ+M5I
        jtGmTrsJNL5e5M8d/xJa/hFiyA==
X-Google-Smtp-Source: APXvYqwiSuAGcVzbwTvmm2ZIw/J7BlC5c609f8Ulw7reX7J6HoWIpxjWRSnpfKnbC7g5fUiN6hOMHQ==
X-Received: by 2002:a63:2206:: with SMTP id i6mr2387516pgi.349.1559947060322;
        Fri, 07 Jun 2019 15:37:40 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id j23sm4185193pgb.63.2019.06.07.15.37.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:37:39 -0700 (PDT)
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
        linux-mmc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Mathieu Malaterre <malat@debian.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pan Bian <bianpan2016@163.com>, linux-kernel@vger.kernel.org,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Tony Lindgren <tony@atomide.com>,
        Avri Altman <avri.altman@wdc.com>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v3 0/5] brcmfmac: sdio: Deal better w/ transmission errors related to idle
Date:   Fri,  7 Jun 2019 15:37:11 -0700
Message-Id: <20190607223716.119277-1-dianders@chromium.org>
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
  mmc: core: API for temporarily disabling auto-retuning due to errors
  brcmfmac: sdio: Disable auto-tuning around commands expected to fail
  mmc: core: Export mmc_retune_hold_now() mmc_retune_release()
  brcmfmac: sdio: Don't tune while the card is off

 drivers/mmc/core/core.c                       | 19 +++++++++++++++++--
 drivers/mmc/core/host.c                       |  7 +++++++
 drivers/mmc/core/host.h                       |  7 -------
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 18 +++++++++++++-----
 include/linux/mmc/core.h                      |  4 ++++
 include/linux/mmc/host.h                      |  1 +
 6 files changed, 42 insertions(+), 14 deletions(-)

-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

