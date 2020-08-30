Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6714257015
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 21:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgH3TPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 15:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3TPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 15:15:06 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C44FC061573;
        Sun, 30 Aug 2020 12:15:05 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id r69so1361115lff.4;
        Sun, 30 Aug 2020 12:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88QVZJWyYPWGresnObCSdSSijug6Py1JroTlbOaMMms=;
        b=tetWJdh505+kqkUGmejhoBwUt+0rV8XHFksG14n8GIClO2b75pDS+47oxMFqVMKENG
         n/+3j6w4fRlEh7rN+5Kbgz9K1ZgSXC2J0/94JfW8neb1uxvPvTtI73Ft4nSFCEGWKlCb
         1blXk7GgIV4euv3nF8Dtt2TDlFODPPLYqTk+x4keT9hKqXxwJvOHP1VLE2z/zSiZpKjs
         +O2Z5IAm0Nqj5mIsZaiwtW7PrRGUEnIUJ66qhAMxe8AyJAByJd8WYspGlq79ZQLDjGG6
         JbyjOGCNKo28WLsHPzbuxx+LBhT++j9Y/0yiQfjoVgxVB9aOJqVZZaq4/f3MpNSwdsFK
         H/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88QVZJWyYPWGresnObCSdSSijug6Py1JroTlbOaMMms=;
        b=hWvUejdOJ45vaZh0PLp6ZDxEXnSxcTjZzVC2sFGenTi2TX5YxJ+2F9+aLBrUM3SCPB
         YdwiIZ7I+ALJ86FmTcy1OxUV7/sTob8slZXZJyh1l1A+/EhfQp4oQXYwD3qZr7j3DKtO
         3uavdYYLeJNNLA5mxTeEDiLehsZTzpz66qHnn8YgT4M05fv5GKzRKN+rwcCC+N7KrHWP
         /k7GT/l+Pf6nPzyoSBEuso1uxczl9xQS1FqSQVcQdaEMqOtcBiAvJ4skRBTNOKo6eRuR
         RBPmZbaq8mL9GJ1SCyV5EjnlujqOSKnasqugGjmMua+HZvZcS9unLbkcjdrS8di1Qjax
         ZWXQ==
X-Gm-Message-State: AOAM532KSRr2fT1FjDDsfFaRmAsHzjAnt+NXP7u19N7+w+T0jy9mnVim
        nBl9xnqZWfkPZ1OSl4u7ECQ=
X-Google-Smtp-Source: ABdhPJx8zDLp5C8fN41g217hWlTE42K7LR2yysraJhgBJ8wBmczZYehRhxbs3wBAf054TqSqKBXgig==
X-Received: by 2002:a19:30e:: with SMTP id 14mr3994288lfd.48.1598814903934;
        Sun, 30 Aug 2020 12:15:03 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id e23sm1409709lfj.80.2020.08.30.12.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 12:15:03 -0700 (PDT)
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
Subject: [PATCH v3 0/3] Fixes and improvements for brcmfmac driver
Date:   Sun, 30 Aug 2020 22:14:36 +0300
Message-Id: <20200830191439.10017-1-digetx@gmail.com>
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

   I'll sent a separate email for discussing this problem [1].

   [1] https://lkml.org/lkml/2020/8/27/54

After fixing all the above problems, I'm now getting a solid 40 Mbit/s
up/down on Acer A500 on a recent linux-next in comparison to 15 Mbit/s
that I was getting before the fixes.

Big thanks to Wright Feng who helped me to find and fix some of the problems!

Changelog:

v3: - The v2 "drop unnecessary "fallthrough" comments" patch isn't needed
      anymore because that change is already applied.

    - Added r-b from Arend van Spriel that he gave to the v1 of "increase F2
      watermark for BCM4329" patch.

v2: - Added "drop chip id from debug messages" as was requested by
      Arend Van Spriel in the review comment to v1 of the "increase F2
      watermark" patch.

    - Added patches that remove unnecessary "fallthrough" comments and
      change F2 SDIO block size to 128 bytes for BCM4329.

Dmitry Osipenko (3):
  brcmfmac: increase F2 watermark for BCM4329
  brcmfmac: drop chip id from debug messages
  brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.27.0

