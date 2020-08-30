Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87933257002
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 21:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgH3TPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgH3TPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 15:15:07 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B885C061575;
        Sun, 30 Aug 2020 12:15:06 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y2so951774lfy.10;
        Sun, 30 Aug 2020 12:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hzL71nqb/6BZxUitP92QceAo8sdBLgT31i3ar+cwVk4=;
        b=XOye4I75cIfJ4wkN4RaeluIx+/YAJsxlMpAnP498/xZTl1BTh8eSlfQif5JouocnSh
         14l3fBQ+A+yleGcThqMh1IaJriMgqMbIE00NyGf7Vle0M2E7WLVo9PlrLCn9vtgowgLt
         Lr4Mu7V/lWdptapsH5tCqMvP1g5ir1mEsMMokwajMTno6GR0SBVHl/7ypVl5YA3p4HoF
         fFymnbrHgHbTrzQ/PoyTHfJ+z2cr7zsyoWJ2DNueWkIQjuS/8ueDks4amJJKs+KgB+yp
         +XRynXf/t0fyF8u1wenwv3sbeaCt3sIPLNePGmjRYeaXo5pTqEUgNHd6MH2PGfsDTuU0
         5MTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hzL71nqb/6BZxUitP92QceAo8sdBLgT31i3ar+cwVk4=;
        b=j8AOqXUrl/hkYHnFrnNd2FRUeIHMr2dpaVrKcJBXuHajNJC8b3YN2G9F2K+lkC+ZxC
         w1B7sH1DNxY8u4wIuHketyNteuSdFH9vC+VZhu5DY5Bz0snrsLK43fS/8InrBWMd9/OZ
         3bt86DxIWv9szZELmV5sCnwAh5U9CKk95vI5k+mKJLfv8mmqgyJ2rbPBZO0xNWbyRMp3
         Bu+B+ze0mY9xjnOSwXK8dUvlTpRNr9zOeXmzjtWsb3xFgFN1PZ5wiD3bQ5m7XoYqQEXb
         Ah+zOiBL3P2mZUM54OyHP+HolPq8/V0zKDuw06na41SW1cJNuZUIG6W1m/x75S6hJO4D
         2lJg==
X-Gm-Message-State: AOAM533MF2BJ56mP1JcVq45SsbuqEwSox1UmefQdmOHheDJSUx5w2LUC
        ca86fl0ZnPg4zrXg3bFav48=
X-Google-Smtp-Source: ABdhPJx6cYCkNqBsgfZJn1WvrwBAiI7kWYd9Yi9pQ5L2953d0O0W457Bcur/fqHaFOJeiOQAPpwzwg==
X-Received: by 2002:a19:f510:: with SMTP id j16mr337056lfb.169.1598814904892;
        Sun, 30 Aug 2020 12:15:04 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id e23sm1409709lfj.80.2020.08.30.12.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 12:15:04 -0700 (PDT)
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
Subject: [PATCH v3 1/3] brcmfmac: increase F2 watermark for BCM4329
Date:   Sun, 30 Aug 2020 22:14:37 +0300
Message-Id: <20200830191439.10017-2-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200830191439.10017-1-digetx@gmail.com>
References: <20200830191439.10017-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes SDHCI CRC errors during of RX throughput testing on
BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
value is borrowed from downstream BCMDHD driver and it's matching to the
value that is already used for the BCM4339 chip, hence let's re-use it
for BCM4329.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index d1b96bad2718..b16944a898f9 100644
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

