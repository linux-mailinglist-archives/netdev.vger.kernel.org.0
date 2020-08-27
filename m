Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF847253D73
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgH0GG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0GF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:05:58 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3533FC061249;
        Wed, 26 Aug 2020 23:05:57 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id w25so5039052ljo.12;
        Wed, 26 Aug 2020 23:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=38x/FHPCvUI6C1PMr+cgZ0iy8HiLtsEpmjxfqsfrl/Y=;
        b=SSNJVMkEHNvDX/DmCTbWERwWBdLLQgom+e0hE6G1ghYZCG1jR5qDYJdmZLXR2Knxgm
         SlKtBoFxp4Yem1DCeI05lMEIl+rIF3QI4COLd1uI2hswj5jFD6DdYxeQIZEYntRPAgVA
         USAG3gn0c52GL9A5V+sRgW2T3be7I7xJ8U4Ci5+l2Pdcx5jwgR9Kz+7FglwEQ35ciBW2
         mijc2MBtPzzsxG47wryZ+3yvtQn68gCSoTj0Ge1JpKxsiltW1E+ysg6UqQwR0AwzZJGP
         q4PlyFIsPz35z8jFlzCjQNn8xg89biT17b7zGH9Y6hidUabt45xvLE2rC9nUroSWIW4a
         ZDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=38x/FHPCvUI6C1PMr+cgZ0iy8HiLtsEpmjxfqsfrl/Y=;
        b=X7pXJgOT8xpCsZjUeOamynTLjGMyy4SwUPCtSOB9xVrOTIcOH/mFbN33Kn/AbBw2TL
         YxS7UXTfq+ShNmqTfVlGLQD+rgCsISnFkxnnEKPuQizI5TRNyTYMbMzeL/w5fZtR19Zq
         xdRJkwtFGsD8bh8nnJ1OeZvF2yZjvt+rimDDyLQCrm8ge1uuHfL+9FjRHh7eqYafa1P0
         DJQ9qtS4EQycbYHMKJwxE3WxAKW8I6ThmiLPaFMYu9S+9EUvBQ6Y0zQlFHGuFWB7daFx
         wYMiyrosL1J9kWsUI3NzeACZKi3MlFdK7oDhBa3iLFKn40oNRGObYzZESRzo2zOtB7D6
         7A+w==
X-Gm-Message-State: AOAM530HJArM6YLIgPDKbd0Yd3u/GYb0JKefB0LrX69lPpbud60qDrln
        uTIbTUsQicp052npxX+gZEs=
X-Google-Smtp-Source: ABdhPJwFLyLpiDrInngiKjDlMQnbzdI8mZJVC9hfbrCATktdnCPtvDaaTTWZrQGRFBpJbEYV7pDmHg==
X-Received: by 2002:a05:651c:152:: with SMTP id c18mr8010629ljd.15.1598508356372;
        Wed, 26 Aug 2020 23:05:56 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id z7sm255295lfc.59.2020.08.26.23.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:05:55 -0700 (PDT)
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
Subject: [PATCH v2 1/4] brcmfmac: increase F2 watermark for BCM4329
Date:   Thu, 27 Aug 2020 09:04:38 +0300
Message-Id: <20200827060441.15487-2-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827060441.15487-1-digetx@gmail.com>
References: <20200827060441.15487-1-digetx@gmail.com>
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

