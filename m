Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9F22084
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfEQWyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:54:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47021 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfEQWyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 18:54:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so3932725pgb.13
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 15:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kE32OCklpIZXO7svMqG/W8w7+/cFFktuMCsLmJ9iAxQ=;
        b=j738cSt9G+eC+Ssi6Mhsw32N5TiBKHXPoJHB8D/AEDypV+5B0elAKCdF6PlzOM6OcS
         rbZQn5r0unqEm9W5BfrmtQTF+g0qfmROnRX2xCe1NjJ64kzHNg820UnDDryZLzrD8T2m
         etwXw4YU1QMMjXANx95rOa5DruCs5yslqOl6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kE32OCklpIZXO7svMqG/W8w7+/cFFktuMCsLmJ9iAxQ=;
        b=SYdJiiqgl8zzhbTR5t3nat3fETx0DIlNN+8NNAFIccPJ4pc1szjcDfCPXaP5sCPlfU
         0oslMJZZjptaXZO1MxwqI5Zk3wclCuCWd/ShDRf/AmzY5KRJc+IFaWIt2cDdSugb61tn
         Tcb9SdAxQ8wRP0qZ4u/KFo/k51cXWxHr3q8NcpOhM/cJuzzITfb6xd8HAbN25zTRA+SF
         MtQzrP1rw3duFh0VDMpGWX0bMYVwD1XWBQf7U5xFsiJZNvsbIR5p71uEwt+G5xG3ilCN
         +3ZBfl26+XDh99MR1dT6Xy9etpouujqFLjZSS4RV7o4RvjwhrWaQ6rsgvI2rS7TDIWuT
         GgwA==
X-Gm-Message-State: APjAAAURS6vjNxB4Q+HGBBJiIdJLekEQ2JUoI10+xX2lPcBMUKKdKILt
        PIARXSc8r5XHnkORm/00KPvvaQ==
X-Google-Smtp-Source: APXvYqw3Pllw0o/YaHOCk+UhRzInd8A3zNoabhFlV045lJlGWBCfwcMIFoinD8muUSpjk/9MTo4nVw==
X-Received: by 2002:a63:ee0b:: with SMTP id e11mr6703708pgi.453.1558133684631;
        Fri, 17 May 2019 15:54:44 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id u11sm11174450pfh.130.2019.05.17.15.54.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 15:54:44 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Douglas Anderson <dianders@chromium.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        brcm80211-dev-list@cypress.com, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for BRCM 4354
Date:   Fri, 17 May 2019 15:54:18 -0700
Message-Id: <20190517225420.176893-2-dianders@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190517225420.176893-1-dianders@chromium.org>
References: <20190517225420.176893-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 29f6589140a1 ("brcmfmac: disable command decode in
sdio_aos") we disabled something called "command decode in sdio_aos"
for a whole bunch of Broadcom SDIO WiFi parts.

After that patch landed I find that my kernel log on
rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
  brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110

This seems to happen every time the Broadcom WiFi transitions out of
sleep mode.  Reverting the part of the commit that affects the WiFi on
my boards fixes the problem for me, so that's what this patch does.

Note that, in general, the justification in the original commit seemed
a little weak.  It looked like someone was testing on a SD card
controller that would sometimes die if there were CRC errors on the
bus.  This used to happen back in early days of dw_mmc (the controller
on my boards), but we fixed it.  Disabling a feature on all boards
just because one SD card controller is broken seems bad.  ...so
instead of just this patch possibly the right thing to do is to fully
revert the original commit.

Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 22b73da42822..3fd2d58a3c88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3378,8 +3378,7 @@ static bool brcmf_sdio_aos_no_decode(struct brcmf_sdio *bus)
 	if (bus->ci->chip == CY_CC_43012_CHIP_ID ||
 	    bus->ci->chip == CY_CC_4373_CHIP_ID ||
 	    bus->ci->chip == BRCM_CC_4339_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4345_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4354_CHIP_ID)
+	    bus->ci->chip == BRCM_CC_4345_CHIP_ID)
 		return true;
 	else
 		return false;
-- 
2.21.0.1020.gf2820cf01a-goog

