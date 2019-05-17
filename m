Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8308022089
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfEQWyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:54:44 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46905 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfEQWyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 18:54:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id r18so3970005pls.13
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 15:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ul1gLClLY2RLZ2itEzzFB2yOFIqulLy55JPQTAySFDo=;
        b=IF+6pl0A6m1fIH81uzmdTDMrurVWOxHBgZdzg9ueW18kyGxlj6N5aPcTRqNNCU+vTS
         LKiCjnkbIC7ajqH/YtTymknHPW/NY4yPjYIJzDwwYqMMyIAHIYA46a6IB8NY149qfCHK
         CVTekqT/FiWMIwMhhNjynCJ139h41IPM+Swp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ul1gLClLY2RLZ2itEzzFB2yOFIqulLy55JPQTAySFDo=;
        b=GTbI5w038UyK6qYKV9dAf78xl+lHuNKo3cpymftqx0/TmJ41U8aX919r1rSZ4SUXg9
         1h8bLByl7bDtwB0ZN04lT0bYRoiU8alYLNoSeKi4RsmfDCtyOidsmG/VGZ5BSuM8K1vN
         f7l5o+xln/3auw16yAwcaQfJ0dtN5uAMHfOdmmBxA14VyJ3T7/TDrcGDWZ+VJIcJsqMJ
         z98g/DmOF/cFdYnfuBV38U/IuLWAs77BxfIxeP3ezGmWQHXYMLsikn5CyHPcklYOz7RC
         4ISo5vuah9Fri1NNgn+iPPUfGxu4fxYtI2qDlBZzER/UJBGCO7I0qfVeY1CfmJWy4rco
         vx2A==
X-Gm-Message-State: APjAAAXRDYSur+bFPrq//9BDlXR9ZrwJRrgwYKnNENKs3CpDwU58zHWg
        8ypB2Z8yhP5rmwFDmKfhON8WbA==
X-Google-Smtp-Source: APXvYqz/J4eNQzJXQjOFtQWVtg1bZz7U+KE/9+kUa8iLb3eFelZBp/fzq1UlgJul23Nw2JUqc2sKmA==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr58590219pll.147.1558133683494;
        Fri, 17 May 2019 15:54:43 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id u11sm11174450pfh.130.2019.05.17.15.54.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 15:54:42 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Douglas Anderson <dianders@chromium.org>,
        linux-mmc@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        brcm80211-dev-list@cypress.com, YueHaibing <yuehaibing@huawei.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Martin Hicks <mort@bork.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/3] brcmfmac: sdio: Deal better w/ transmission errors waking from sleep
Date:   Fri, 17 May 2019 15:54:17 -0700
Message-Id: <20190517225420.176893-1-dianders@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to deal better with the expected transmission
errors that we get when waking up the SDIO-based WiFi on
rk3288-veyron-minnie, rk3288-veyron-speedy, and rk3288-veyron-mickey.

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


Douglas Anderson (3):
  brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
  mmc: core: API for temporarily disabling auto-retuning due to errors
  brcmfmac: sdio: Disable auto-tuning around commands expected to fail

 drivers/mmc/core/core.c                       | 27 +++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  6 +++--
 include/linux/mmc/core.h                      |  2 ++
 include/linux/mmc/host.h                      |  1 +
 4 files changed, 32 insertions(+), 4 deletions(-)

-- 
2.21.0.1020.gf2820cf01a-goog

