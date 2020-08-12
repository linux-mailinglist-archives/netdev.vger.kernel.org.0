Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5EC242463
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgHLDt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHLDt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 23:49:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316DCC061788
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:49:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 74so319273pfx.13
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGZ7oH5irgb8vHttyuKAPTbuHfvCyPqoeu6cHuTeExc=;
        b=2Dft5flWpUB03NQgpw9xj7T9+NTrzhj/vMHyRIAznuP6lw+xeaq/srnjOBPrJu02GR
         tcpTC3WsTR1TeSnT+ZEtKuImF2TVg56FFgf+JjlLk3MK0BBMdTmAZJ5nT3yLGHM6QfCs
         NA4d4y6lqJTeELkH7DQi1RvDAlNE4MDey642d34tekFwnI5179igxFoIDC3qjemebGW3
         aGxi6Mp7Z7mJPGLRBC18y128pXEvu9d7RFCM05HMxBQWQ2RNc24xWw/uCNm7gVUxEmgX
         VhdesRuuFJZy4qwDFzjaJwdYAKC3MQspHqv+L6Y+iQzyplkVN6QLsDB5XpuXBRACewJk
         YjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGZ7oH5irgb8vHttyuKAPTbuHfvCyPqoeu6cHuTeExc=;
        b=muZDipMWZIVBSEAP1GkmvUSUvD3Yvd/QSJR0JhHRrTQfmjMCLRF7X9MnJU5M74zdPl
         tT6rC5ys1QQrgwAc8IRdZmrY308pW9I7UOUEwyN/ee5T8NtnmVzbcQsHe7/IKok97+mx
         kedNQdKBsbUCLip/9FylhIwQ0oAQegfLw1KM8AaGGwO8OlKt/iKIs91tb+s1rF0mpRjg
         yO7gSX7/YOtdKW/341BOnvBCUjgPTyyZK+t62Tpj3DBbnXyif7mp5aYwBHNEyESdpR8x
         e0wG3pcXhfuGvbgdFGpWQN/UhupA6i3aPwhjX2XMw0H7DKr05ouB0vU741gTSKC/nZsv
         CMqw==
X-Gm-Message-State: AOAM532+unKb8Mxv4B0ThsojI9zIdGwddmvxJQOQVETITeap2GMru/Ow
        tY3wWCiOPAWIX8fAcQe2R1J4zA==
X-Google-Smtp-Source: ABdhPJzrvSzwT2N1BMUiellgv6g/V2xXKQpYD6iLiVgzojCmV6OSSVfry8e6Y++DlMNQvpq9Zj4P5g==
X-Received: by 2002:aa7:8c42:: with SMTP id e2mr8861014pfd.181.1597204166326;
        Tue, 11 Aug 2020 20:49:26 -0700 (PDT)
Received: from starnight.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.googlemail.com with ESMTPSA id cc23sm413610pjb.48.2020.08.11.20.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 20:49:25 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Nick Xie <nick@khadas.com>
Subject: [PATCH] brcm: Add 4356 based AP6356S NVRAM for the khadas VIM2
Date:   Wed, 12 Aug 2020 11:46:12 +0800
Message-Id: <20200812034611.2944-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a NVRAM file for the wireless module used in khadas VIM2.  This
source comes from khadas fenix project's commit 022fdc3a1333 ("hwpacks:
wlan-firmware: add AP6356S firmware for mainline linux"). [1]

[1]: https://github.com/khadas/fenix/commit/022fdc3a1333d2d16f84c2e59e4507c92a668a3d

Suggested-by: Nick Xie <nick@khadas.com>
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 brcm/brcmfmac4356-sdio.khadas,vim2.txt | 128 +++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 brcm/brcmfmac4356-sdio.khadas,vim2.txt

diff --git a/brcm/brcmfmac4356-sdio.khadas,vim2.txt b/brcm/brcmfmac4356-sdio.khadas,vim2.txt
new file mode 100644
index 0000000..4c286cc
--- /dev/null
+++ b/brcm/brcmfmac4356-sdio.khadas,vim2.txt
@@ -0,0 +1,128 @@
+#AP6356SL_V1.1_NVRAM_20150805
+#Modified from AP6356SDP_V1.0_NVRAM_20150216
+NVRAMRev=$Rev: 373428 $
+sromrev=11
+boardrev=0x1121
+boardtype=0x073e
+boardflags=0x02400201
+boardflags2=0x00802000
+boardflags3=0x0000010a
+macaddr=00:90:4c:1a:10:01
+ccode=0x5855
+regrev=1
+antswitch=0
+pdgain5g=4
+pdgain2g=4
+tworangetssi2g=0
+tworangetssi5g=0
+paprdis=0
+femctrl=10
+vendid=0x14e4
+devid=0x43a3
+manfid=0x2d0
+nocrc=1
+otpimagesize=502
+xtalfreq=37400
+rxgains2gelnagaina0=0
+rxgains2gtrisoa0=7
+rxgains2gtrelnabypa0=0
+rxgains5gelnagaina0=0
+rxgains5gtrisoa0=11
+rxgains5gtrelnabypa0=0
+rxgains5gmelnagaina0=0
+rxgains5gmtrisoa0=13
+rxgains5gmtrelnabypa0=0
+rxgains5ghelnagaina0=0
+rxgains5ghtrisoa0=12
+rxgains5ghtrelnabypa0=0
+rxgains2gelnagaina1=0
+rxgains2gtrisoa1=7
+rxgains2gtrelnabypa1=0
+rxgains5gelnagaina1=0
+rxgains5gtrisoa1=10
+rxgains5gtrelnabypa1=0
+rxgains5gmelnagaina1=0
+rxgains5gmtrisoa1=11
+rxgains5gmtrelnabypa1=0
+rxgains5ghelnagaina1=0
+rxgains5ghtrisoa1=11
+rxgains5ghtrelnabypa1=0
+rxchain=3
+txchain=3
+aa2g=3
+aa5g=3
+agbg0=2
+agbg1=2
+aga0=2
+aga1=2
+tssipos2g=1
+extpagain2g=2
+tssipos5g=1
+extpagain5g=2
+tempthresh=255
+tempoffset=255
+rawtempsense=0x1ff
+pa2ga0=-135,5769,-647
+pa2ga1=-143,6023,-677
+pa5ga0=-183,5746,-697,-172,5801,-685,-176,5707,-680,-180,5445,-659
+pa5ga1=-186,5543,-669,-193,5506,-675,-210,5282,-661,-199,5367,-665
+subband5gver=0x4
+pdoffsetcckma0=0x4
+pdoffsetcckma1=0x4
+pdoffset40ma0=0x0000
+pdoffset80ma0=0x0000
+pdoffset40ma1=0x0000
+pdoffset80ma1=0x0000
+maxp2ga0=72
+maxp5ga0=69,70,69,68
+maxp2ga1=71
+maxp5ga1=67,67,67,67
+cckbw202gpo=0x1222
+cckbw20ul2gpo=0x0000
+mcsbw202gpo=0x99E644422
+mcsbw402gpo=0xE9744424
+dot11agofdmhrbw202gpo=0x4444
+ofdmlrbw202gpo=0x0022
+mcsbw205glpo=0xEEA86661
+mcsbw405glpo=0xEEB86663
+mcsbw805glpo=0xEEB86663
+mcsbw205gmpo=0xAAA86663
+mcsbw405gmpo=0xECB86663
+mcsbw805gmpo=0xEEA86663
+mcsbw205ghpo=0xCC986663
+mcsbw405ghpo=0xEEA86663
+mcsbw805ghpo=0xEEA86663
+mcslr5glpo=0x0000
+mcslr5gmpo=0x0000
+mcslr5ghpo=0x0000
+sb20in40hrpo=0x0
+sb20in80and160hr5glpo=0x0
+sb40and80hr5glpo=0x0
+sb20in80and160hr5gmpo=0x0
+sb40and80hr5gmpo=0x0
+sb20in80and160hr5ghpo=0x0
+sb40and80hr5ghpo=0x0
+sb20in40lrpo=0x0
+sb20in80and160lr5glpo=0x0
+sb40and80lr5glpo=0x0
+sb20in80and160lr5gmpo=0x0
+sb40and80lr5gmpo=0x0
+sb20in80and160lr5ghpo=0x0
+sb40and80lr5ghpo=0x0
+dot11agduphrpo=0x0
+dot11agduplrpo=0x0
+phycal_tempdelta=255
+temps_period=15
+temps_hysteresis=15
+rssicorrnorm_c0=4,4
+rssicorrnorm_c1=4,4
+rssicorrnorm5g_c0=1,2,3,1,2,3,6,6,8,6,6,8
+rssicorrnorm5g_c1=1,2,3,2,2,2,7,7,8,7,7,8
+
+swctrlmap_2g=0x00001040,0x00004010,0x00004010,0x200010,0xff
+swctrlmap_5g=0x00000202,0x00000101,0x00000101,0x000000,0x47
+swctrlmapext_5g=0x00000000,0x00000000,0x00000000,0x000000,0x000
+swctrlmapext_2g=0x00000000,0x00000000,0x00000000,0x000000,0x000
+
+muxenab=0x10
+
-- 
2.28.0

