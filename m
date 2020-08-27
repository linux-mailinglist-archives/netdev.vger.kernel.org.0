Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4DA253D6C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgH0GF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgH0GF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:05:57 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA218C061247;
        Wed, 26 Aug 2020 23:05:56 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id g6so5041811ljn.11;
        Wed, 26 Aug 2020 23:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QrZ0fUUzpXVOWSAGCDeCT9RjODjg2DLDcxcKB9h7i2g=;
        b=K9ivd9KQnV9NUYRz8mj5X/cPijNctJe6sv2ndwZaKFwf0Tsk3F2GnSMlC6iGviaXSF
         v7Ri/8hM100UNGhr4TkCyuZ1PA7cSr+R78KEqYV6Khs1uIpPCKVr5c2bpbC8QZ9Xqa+M
         ZtMwzFnuSQ3M8i/XA2fzItK2MLoztr+m7y4/nbcdq7/OkDXrcBlnUUO3OsfGBSJK3Mii
         kICHQOxaksptI84o8wd/Cmfh+thlvCwhNmZRe6wEZIs/wqrO9cTTZA95hxQ/XKmSoUu7
         SAvHBTwbjFhMRzbE/1w5Hf2DS0XCf793zRCgMnxgPWvTZN0tEesSZiLVzN9k6sID3IJK
         OYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QrZ0fUUzpXVOWSAGCDeCT9RjODjg2DLDcxcKB9h7i2g=;
        b=R4q7nMMaohWMIuXT6WL1rYJTAp+npLR52M4YlG+rO8txjf5FzuUQXPbcBiWdnjZdEB
         WE4/fpjwUbl1haa7R7Iqpv6sCT/lqrLKxUZWlkUrddg77GwJtZ7p3qyFI/dEU7bXpNqR
         4sTujBH3W0H3MhNt2wcDxNmueLZvbdw8P8RRGIgY5TM9tj6zsBwio66PU4Lhb5M+uG9b
         s7J4NWrqEQN1OQOus9Kegmav+atxj+ToVKRVcK8kRvDq49oot0cZfsOHhdEdkT1tlG4Y
         YMJ0t6TFImZA/JmBZWt4GUTJX6HYFrSYOBueTjParJIsHqmbuVB2vvZYl9g4elD5oZ8N
         B81g==
X-Gm-Message-State: AOAM530ZAXbSImYSO9r0tZyW3bVIfQw5cj+Kjy3zwyoOonD5ahGH16l+
        +yF6rPBAF8wRo7/Hd1nYHG4=
X-Google-Smtp-Source: ABdhPJzJdF5HeE/tNfW3u5lrITEF7kT3nKactdsTfmEV5/+TXuNOvl7upSmRQf/KlcJqowbEX1TUMg==
X-Received: by 2002:a05:651c:88:: with SMTP id 8mr9355110ljq.277.1598508355389;
        Wed, 26 Aug 2020 23:05:55 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id z7sm255295lfc.59.2020.08.26.23.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:05:54 -0700 (PDT)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] Fixes and improvements for brcmfmac driver
Date:   Thu, 27 Aug 2020 09:04:37 +0300
Message-Id: <20200827060441.15487-1-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Recently I was debugging WiFi performance problems on Acer A500 tablet
device that got upstreamed recently. This is an older Android device from
2011-2012 that is powered by NVIDIA Tegra20 SoC and it has BCM4329 chip
that provides WiFi (SDIO) and Bluetooth (UART). I noticed that WiFi
throughput on a recent Linux kernel wasn't as great as it could be in
comparison to older 3.18 kernel that is uses downstream BCMDHD driver
and this series fixes a major part of the problems that I found.

Found problems:

1. The WiFi SDIO pinmux configuration had a bug in Acer A500 device-tree
   and MMC refused to work if it was clocked above 25MHz and legacy
   signaling mode was used. After fixing the bug, WiFi SDIO works perfectly
   well at 50MHz and this increases TX throughput by 5-10 Mbit/s. I already
   sent out patches that fix this bug to the Tegra ML.

2. There are occasional SDHCI CRC errors if SDIO is clocked above 25Mhz.
   The "increase F2 watermark" patch fixes this problem.

3. WiFi TX throughput is lower by 10 Mbit/s than it should be using 512B
   for maximum F2 SDIO block size. Reducing block size to 128B fixes this
   problem. The "set F2 SDIO block size to 128 bytes" patch addresses this
   issue. The exact reason why 128B is more efficient than 512B is unknown,
   this optimization is borrowed from the BCMDHD driver.

4. While I was bisecting upstream kernel, I found that WiFi RX/TX throughput
   dropped by 5-10 Mbit/s after 5.2 kernel and reverting the following commit
   from linux-next resolves the problem:

   commit c07a48c2651965e84d35cf193dfc0e5f7892d612
   Author: Adrian Hunter <adrian.hunter@intel.com>
   Date:   Fri Apr 5 15:40:20 2019 +0300

       mmc: sdhci: Remove finish_tasklet

   I'll send a separate email for discussing this problem.

After fixing all the above problems, I'm now getting a solid 40 Mbit/s
up/down on Acer A500 on a recent linux-next in comparison to 15 Mbit/s
that I was getting before the fixes.

Big thanks to Wright Feng who helped me to find and fix some of the problems!

Changelog:

v2: - Added "drop chip id from debug messages" as was requested by
      Arend Van Spriel in the review comment to v1 of the "increase F2
      watermark" patch.

    - Added patches that remove unnecessary "fallthrough" comments and
      change F2 SDIO block size to 128 bytes for BCM4329.

Dmitry Osipenko (4):
  brcmfmac: increase F2 watermark for BCM4329
  brcmfmac: drop unnecessary "fallthrough" comments
  brcmfmac: drop chip id from debug messages
  brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 6 ++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 7 +++----
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.27.0

