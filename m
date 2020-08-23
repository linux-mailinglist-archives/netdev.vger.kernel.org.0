Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486224ED9F
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 16:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHWOWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 10:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgHWOWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 10:22:38 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC3BC061573;
        Sun, 23 Aug 2020 07:22:37 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 185so6756695ljj.7;
        Sun, 23 Aug 2020 07:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cpCT819jIZRApX9D520kYS6bFmlnpJPpxZjN4lrXVfs=;
        b=AKOdxg9x4WPMYdcVBFb6mbCTAht38QZGhsXUdTJkxxM1nl1W0PkY/anI72vrMwXbaI
         ou7kHmCFWXkygBGapGdKCmTdbNTMEyiWMBtOxxsWbaKw2yACIoX1z17ez2bBC/HqQ2EG
         5addTlyUg5G9vohHbfBMtLeJriLNqoMMlprdqUtXvZ0vEXMBqQq5FELMWGOYPn6KX487
         R83z83bnvJGWte06RSYwY4vX5cFb6FCVYrlwjWKgCjzLlI6VzTDvFJjqZIdaUn9gJBEB
         56t+5W7vJK6+ShRCQzNCQ2FN2j2qfcgKS9krwdX70YrDsIDbiHAC5gGmxhE/QgvzNzCo
         eYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cpCT819jIZRApX9D520kYS6bFmlnpJPpxZjN4lrXVfs=;
        b=ZoXJihx59V0HAFqtJEDimaNSwEoOrlCO6cn4TwLSYNZHD1NlXDrKvJYaBV/Ip1E74S
         OVWn+eLYtL5PvVjtbfgVy+QzZwYEZZ931sfAjJ2kVZTFgWiKHWcrI5KdXZB9ywsDJk22
         eZZ8JWw+1SNSnxD0LcxgvVhh43ZG1JKWKDA14/Vu50UAuOyjeFHNZshfCzotcf3k+wcc
         WU31WfWq8P+7QRUfYMKBDo5ONamdaPpVWY/DXDwoEy4otBc6c1AVpoZ9t0I7XtF6qEYe
         UDX8uMn+V8dvDtO8VJT82ydMjGxnLbsuQlR8TwQJh1hL3+aZodrCGSBARvt5i356RGIr
         nJxQ==
X-Gm-Message-State: AOAM5303QXBQxllRafkMrNJ+gXyMsiaLsiqbgvYJI52HeggorEIo2qKN
        HJTBdMyLWuYeJOgFswhDNmIz7Dx+zxA=
X-Google-Smtp-Source: ABdhPJxGj++OCovG9IFWIJGZ6F5MA3xQetTwTZaV29FbQT5OaF+P2/Fkq2Y8x3gtSk0LOz9fiFZHWw==
X-Received: by 2002:a2e:8e94:: with SMTP id z20mr762846ljk.367.1598192556375;
        Sun, 23 Aug 2020 07:22:36 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id 1sm1627876ljr.6.2020.08.23.07.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 07:22:35 -0700 (PDT)
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
Subject: [PATCH v1] brcmfmac: increase F2 watermark for BCM4329
Date:   Sun, 23 Aug 2020 17:20:04 +0300
Message-Id: <20200823142004.21990-1-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes SDHCI CRC errors during of RX throughput testing on
BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
value is borrowed from downstream BCMDHD driver and it's the same as the
value used for the BCM4339 chip, hence let's re-use it for BCM4329.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3c07d1bbe1c6..ac3ee93a2378 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4278,6 +4278,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
 					   CY_43012_MESBUSYCTRL, &err);
 			break;
+		case SDIO_DEVICE_ID_BROADCOM_4329:
 		case SDIO_DEVICE_ID_BROADCOM_4339:
 			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes for 4339\n",
 				  CY_4339_F2_WATERMARK);
-- 
2.27.0

