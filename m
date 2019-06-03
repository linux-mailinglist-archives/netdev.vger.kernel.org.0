Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234053384A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 20:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfFCSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 14:38:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35922 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbfFCSh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 14:37:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so11107911pfm.3
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sdJuH7k++BGfpS8zEifYD9KLgjj0LNkMfJlMApOTv3A=;
        b=VI7KxZOr4/miSRAbIaeuYOJWoiCEXYABO8BpdtXK45HVy3s3YAOXH2NJeOgkyrBE/Y
         M99xiWkHi2jRBQUPUeYqrK2eK3FG6YAzAK2+y6UTn4rp+zImAeXBrz5q/Kjrd7fCFoYp
         NqT8KOH/N14j84ZVOE54ukekZw45tWyTAZ44U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sdJuH7k++BGfpS8zEifYD9KLgjj0LNkMfJlMApOTv3A=;
        b=Imdp1VdeBnscac38e4hI61p/3hT1Poq4pUy+d5yKdakCA+Sb8apwqPY69a6QfirfqJ
         3AZc9e1IKjnjVfZBc6nU+rPlJNOmBTKb5zaqb0c+dCwmh27rlqRjBJQgMavV0ZkUspbC
         oVx0Po14xFGxaGy3VqmxbPrWUMCw8A1noLf0TgifRIO9t1Vkj+Z62oYIzc0Ob8VjSowQ
         izEa6jGLFfs+PYr6bqvnlXY/F0y6l4k17EeR9jRTqQF88ob+QEeeTrFx3v3yaDPR7kqM
         MAuXhgSQaYfq6cmD8E5pt3MgL2VpQ7fH8qx6/dG8lRi0fer/66oZ8WoedpoQpfCbROxv
         JO9w==
X-Gm-Message-State: APjAAAVPSjn0WBpV+6EXy88UuAFUrJV5wi4Z0mefnAyh24k8VafzIJBx
        jikMgQnuBHGXhsO4YMGTN9MUPw==
X-Google-Smtp-Source: APXvYqxCAKpMJCDgPT0zPf8L4uQ/LWU+VMtO7VfMvXmyv9L+9e+E97URHi0HoDSQYuK+nyvUaZeP3A==
X-Received: by 2002:a17:90a:26a9:: with SMTP id m38mr31800995pje.93.1559587077838;
        Mon, 03 Jun 2019 11:37:57 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id t2sm14808969pfh.166.2019.06.03.11.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 11:37:57 -0700 (PDT)
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
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 1/3] Revert "brcmfmac: disable command decode in sdio_aos"
Date:   Mon,  3 Jun 2019 11:37:38 -0700
Message-Id: <20190603183740.239031-2-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190603183740.239031-1-dianders@chromium.org>
References: <20190603183740.239031-1-dianders@chromium.org>
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
2.22.0.rc1.311.g5d7573a151-goog

