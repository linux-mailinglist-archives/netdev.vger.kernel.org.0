Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950EB253D6A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgH0GGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgH0GGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:06:00 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7655C06124F;
        Wed, 26 Aug 2020 23:05:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f26so5043834ljc.8;
        Wed, 26 Aug 2020 23:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85fBH067dHvKQNq6ek+W6lpUInMb+ZStwZLTCqTuQ3g=;
        b=LAQCKf7V+H8Hfnb7BZybXxxgLvGGrihgB+KAUY1Tj+kA0EoV35K6aUEb5WXr23Q30Y
         hQtw6kqLqLfS0UMyLBIXjMRb6LFAC0B6K5YCTROdl24fwAg/MCo3YYfLvyxVRB7IB+7J
         wANPAygVIyQKATVHjVt3N8pk8TGRgRy3zhmjqvP8lDFVJwf4t4TyKxFoOKZnLzynj/z7
         B7bKlnDJShUYmmO2QUG4+xGhYSflF8aCg1UvernFWssBdoZoZ2fye3j7rtr7VbvVaqgB
         eYdTf/1z1wRP0v4UEiR6WOOEwvg/m1OyL9nDEeG+00C+SePaDOODBSGrCt0FHpuPTzFR
         NZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85fBH067dHvKQNq6ek+W6lpUInMb+ZStwZLTCqTuQ3g=;
        b=nhZu2+0V97IFijj4d8vdptMZnX3sp2WIrV8OCXYFECW7ykgsLE1WI0OiER9kilKgpm
         0+C5vrVnztpsU4v7loTyVKJf9QMvKoE8PMtHFihK9s+7ohbMjNVFEsboinntQunMpFd6
         yP7m9gGEiwTKjn1jWgbEPNP0c/DzGkFhuntaC4yKAMx1caoL7+0NrTVJ0bSAotZeA3UE
         2yEqDf+T+OKZ33wbthjTNHaXlM7II2896CFZc98OEcoFyv5PYWPjXLJtEjQDjs3U1Wi0
         pmx7BYGi/eI7TolE/MbRrZ5cDEsXURnaHA9RdIW2/dl9gU3ZeBUTYaVSuJc0hXV5O+yg
         /gxQ==
X-Gm-Message-State: AOAM531Iafru935YWn7mcmkgFi8+KfSnura/L0G61XkSvgHKSyn4nbw8
        hHLT6UMN1gialDSQdhs2PXE=
X-Google-Smtp-Source: ABdhPJwoOgvB7reSaDGYFu+hqpx2fpi2Z8iky2pgXDkwAHSZ7nlUuSO623t8xrL9U8X11t6Q7cSmdg==
X-Received: by 2002:a2e:9990:: with SMTP id w16mr8244686lji.156.1598508358235;
        Wed, 26 Aug 2020 23:05:58 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id z7sm255295lfc.59.2020.08.26.23.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:05:57 -0700 (PDT)
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
Subject: [PATCH v2 3/4] brcmfmac: drop chip id from debug messages
Date:   Thu, 27 Aug 2020 09:04:40 +0300
Message-Id: <20200827060441.15487-4-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827060441.15487-1-digetx@gmail.com>
References: <20200827060441.15487-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The chip ID was already printed out at the time when debug message about
the changed F2 watermark is printed, hence let's drop the unnecessary part
of the debug messages. This cleans code a tad and also allows to re-use
the F2 watermark debug messages by multiple chips.

Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b16944a898f9..d4989e0cd7be 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4280,7 +4280,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 			break;
 		case SDIO_DEVICE_ID_BROADCOM_4329:
 		case SDIO_DEVICE_ID_BROADCOM_4339:
-			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes for 4339\n",
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
 				  CY_4339_F2_WATERMARK);
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
 					   CY_4339_F2_WATERMARK, &err);
@@ -4293,7 +4293,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 					   CY_4339_MESBUSYCTRL, &err);
 			break;
 		case SDIO_DEVICE_ID_BROADCOM_43455:
-			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes for 43455\n",
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
 				  CY_43455_F2_WATERMARK);
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
 					   CY_43455_F2_WATERMARK, &err);
-- 
2.27.0

