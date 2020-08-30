Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877E25701B
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 21:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgH3TRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 15:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgH3TPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 15:15:08 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E897C061236;
        Sun, 30 Aug 2020 12:15:07 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id j15so2315573lfg.7;
        Sun, 30 Aug 2020 12:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85fBH067dHvKQNq6ek+W6lpUInMb+ZStwZLTCqTuQ3g=;
        b=nVMf6eR/tzJR9bU6YV5ktJWXhIRVVdwtYx5dR5sOF9HNUZJR1lw0R2eZ5yKGcbs3Ij
         UCrio8mvGQhynAaPTXjMhm57mDu723ApUr0TiZXjmUoJrFQVIFl6VYZeCDu3dXXFGUw0
         XasSLQZ6ak9UxEk4Xen3Q2U/Zr/P+/jB0QY1vR+MRsiIFzZXwQRQpM9IJzj4yIYopB5X
         9XhWNhf2QWh9gH61eTumnKsNzptLg/c8atZt15ncup5uu1C2f/rwt/4dav6jO2dmbGAs
         p9NeFTAyGXpQxrzCtfDUCTXvmsS6UEY3o15iWQaZopVbo0ypnts/6Vg8upR1VNQVxnM7
         E7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85fBH067dHvKQNq6ek+W6lpUInMb+ZStwZLTCqTuQ3g=;
        b=WwmOJDBXyk7Su9lj9yFvo0X22q549x/nNNUuUYCmUf8OjvUL6LwAkcQ7l+F6X41BtP
         n1fYqGH6S7w68U3pIL2yyzR7YOl1NDYvZp3LRNGc6Y0dljwZbMMrbTXkdnimwrVneXLQ
         CLjOSIYQkJgtWX9ZG/Uaq+hnaY7BX9EMntr7mXYbD+O8Xmr8/Zb/jUJSKiKIxAVW48JM
         z2B7XRLEfmd8ELQoMhqtCw/23wbQ6tnT5tdtt+ngDJWh7aXnUaVgO8i/tQf0Th3JXBdj
         dB5/P8FDMKrLNwxVYaaHyo/vs86AeUzj+J7Vu+jSQYbWobKSsN0h9FsVwsoEzud1cPlw
         s9Tg==
X-Gm-Message-State: AOAM531EgBgv8kHi8OlvBWwXAThNCUT/1OO1iu8iU00rAeqI5Tb40pod
        ZyIrbVjNZJe6MgLKqLMeZrw=
X-Google-Smtp-Source: ABdhPJzI4lUuYNLpOO2XLO2AmkS9fShcfxSPyVOk6XVuyEYlvT5tmtBLoLVIApzOMF3Luuy0a5TW7Q==
X-Received: by 2002:ac2:5e2c:: with SMTP id o12mr3918764lfg.71.1598814905875;
        Sun, 30 Aug 2020 12:15:05 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id e23sm1409709lfj.80.2020.08.30.12.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 12:15:05 -0700 (PDT)
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
Subject: [PATCH v3 2/3] brcmfmac: drop chip id from debug messages
Date:   Sun, 30 Aug 2020 22:14:38 +0300
Message-Id: <20200830191439.10017-3-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200830191439.10017-1-digetx@gmail.com>
References: <20200830191439.10017-1-digetx@gmail.com>
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

