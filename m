Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F005E45042
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfFMXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:42:50 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40128 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfFMXmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:42:10 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so392873pgm.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 16:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vet+Dn10p+j7iocPSsG03g8vaMFWiMo90o3B9LDdj5Q=;
        b=eAWun/ksKNSaoQ10+uBkjZGfqtLoiG8yBGDTdZO258ZzYavaoOZuXXwFSkzwuBHRB7
         lAW5Qhzyq2gfCkWzO/C/0t28K4pk2shtn8t++uigTtM6pqGQTxJDZTEppJLVYFcPZiZ+
         ET5Mbl5aw+JT4vfiumCEtNewl5negiJ8/hElc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vet+Dn10p+j7iocPSsG03g8vaMFWiMo90o3B9LDdj5Q=;
        b=YYPrDUi/Ri53Zk7kkAPwJTS9rrMLtvMNQOmLKUF35H/NGCaVjVgltgDGx3aVNN+Jqu
         N73lacN/qkWqY8e4BIPXwVV/9pvCe9oz5NNBMJMAruq5HFIbNLyS4Y4wfonJAk0AGO/a
         SMXhij8Cmk69/v9ZUyulAcZWn91y/jN9fHQ/uVADvfrlh0AYS8Pk2tR67bfL2KaW0Ltu
         U7EIIYVbDGhWfibxg4nRHROWrFwdPUoK1rqelKC9Q4yD6OixlseCdI+wchFj8K+Urqos
         fcMGn3ViHGbGIJsHf2mtvUchmaBfiMH6cknekCLMM2tIyWzUtbFpRPVCLmzXqUvd94jU
         lbtQ==
X-Gm-Message-State: APjAAAUf1wKyLhyaZmvoqkbxx7n7jDfPlp62i1kP/Z27N4cb6ZM4w/Ii
        qxgUvZ82OU3xQs2oA7ojwHEvYQ==
X-Google-Smtp-Source: APXvYqzcYCogaB1dx3Z18YZOdlzBvYKRQdVrqLFdJgs65C5FTDSv0SULwuUx8O/K6Sy3YmVLTPDmpA==
X-Received: by 2002:a17:90a:8a8e:: with SMTP id x14mr7827548pjn.103.1560469329449;
        Thu, 13 Jun 2019 16:42:09 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p7sm781088pfp.131.2019.06.13.16.42.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 16:42:09 -0700 (PDT)
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
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v4 1/5] Revert "brcmfmac: disable command decode in sdio_aos"
Date:   Thu, 13 Jun 2019 16:41:49 -0700
Message-Id: <20190613234153.59309-2-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190613234153.59309-1-dianders@chromium.org>
References: <20190613234153.59309-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 29f6589140a10ece8c1d73f58043ea5b3473ab3e.

After that patch landed I find that my kernel log on
rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110

This seems to happen every time the Broadcom WiFi transitions out of
sleep mode.  Reverting the commit fixes the problem for me, so that's
what this patch does.

Note that, in general, the justification in the original commit seemed
a little weak.  It looked like someone was testing on a SD card
controller that would sometimes die if there were CRC errors on the
bus.  This used to happen back in early days of dw_mmc (the controller
on my boards), but we fixed it.  Disabling a feature on all boards
just because one SD card controller is broken seems bad.

Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Double Lo <double.lo@cypress.com>
Cc: Madhan Mohan R <madhanmohan.r@cypress.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
As far as I know this patch can land anytime.

Changes in v4: None
Changes in v3: None
Changes in v2:
- A full revert, not just a partial one (Arend).  ...with explicit Cc.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 4e15ea57d4f5..4a750838d8cd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3364,11 +3364,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 
 static bool brcmf_sdio_aos_no_decode(struct brcmf_sdio *bus)
 {
-	if (bus->ci->chip == CY_CC_43012_CHIP_ID ||
-	    bus->ci->chip == CY_CC_4373_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4339_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4345_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4354_CHIP_ID)
+	if (bus->ci->chip == CY_CC_43012_CHIP_ID)
 		return true;
 	else
 		return false;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

