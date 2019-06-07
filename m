Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B57398F1
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731460AbfFGWho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:37:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47093 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731456AbfFGWhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:37:42 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so1326756pls.13
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=npqZn7jrWknLiP6RpPMO0pPj6O8NQ9dRH7/VI2Vhthk=;
        b=hdMt7Tp8R3E0DReUmZ60ezy4X6bTQmVNpN9Xob9TjfIVuVL+nrVX7wdG3Y2lEjkEoe
         w7yjBbWqqH3/q7tBbdW4khMsRF5Fm+s4GofU3zrlvE3jW8r+me40NCIVGSVFt5KL9VVA
         g2YydiHRvFDQXquQIEaNZ1shPB2elvhqoQdmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=npqZn7jrWknLiP6RpPMO0pPj6O8NQ9dRH7/VI2Vhthk=;
        b=P4bgKlOVVPAzTB41qtJhfWkcCs6rxbuqRjgeD3FiBgsDQyNYoYe3B2ZRH0kw/bqE1U
         zPaTUW9+reoo1OukQvPXMsZAVax7q/tv9KRLUG4v5jyLeyYdlEsJTG/XC0C6agOC6cLp
         Kb1UJc856Vs06Lu0pGIClnozJz3T9jcaP9D73Kc73wKGWboAFZSPA/89rDJ6cjmQHh4Q
         ttQWqw9ZfVs94j9Wk+rlTPMOY4LJFwn8cGq7jsXIyxHZhPQJ8ko1SDN81IB9+eYBYq5C
         mI8Ye18s1pmx2pdgFfu/ys3tI5OLIisIYZQjaW2qQSQL0Eh6/YnFL1b7RizamwUB7B2j
         5olQ==
X-Gm-Message-State: APjAAAUYZN9KXdq3+qi/8Ua4bCTOnFn71pMHiJZV30ddoc/bBCTgKnoz
        Pc/DwIG8L5HScXMLkbIrAfCtfQ==
X-Google-Smtp-Source: APXvYqxe0jRoHVjH0j4kVqEfBP2PUF3gAe9VxHlJqI7LH0UKRSF8v7zzb19mCum1XWxKY7vDj7csbg==
X-Received: by 2002:a17:902:522:: with SMTP id 31mr55340726plf.296.1559947061581;
        Fri, 07 Jun 2019 15:37:41 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id j23sm4185193pgb.63.2019.06.07.15.37.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:37:41 -0700 (PDT)
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
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: [PATCH v3 1/5] Revert "brcmfmac: disable command decode in sdio_aos"
Date:   Fri,  7 Jun 2019 15:37:12 -0700
Message-Id: <20190607223716.119277-2-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190607223716.119277-1-dianders@chromium.org>
References: <20190607223716.119277-1-dianders@chromium.org>
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

