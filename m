Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE0377946
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 01:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhEIXbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 19:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhEIXbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 19:31:21 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA850C061573;
        Sun,  9 May 2021 16:30:17 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id p12so18591304ljg.1;
        Sun, 09 May 2021 16:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RedzcwQXnK2JFK7yvp/MkYUU1m35sxE8mjp3sZ0+O08=;
        b=bf2wa3vSWP5/spJ155BDp7+NNLyEm3nLBuGGZ8UXInKbvzavBx6VswOFlTQ+igmYiH
         S2npdP3+4cf3fbhpZBBwopAu6R1rZ+dDXvEL2837vqDSSSTCtbPBPiKbTreqh7B7Drdl
         ma0n2qjrat8zDonEXBMOHDJORfVg7HdlTYj93Aq0wdYleZGQSokIH5NoLtCOT9kZhDp2
         mhMQMY7wgtK1IRhtGCfNzE0+USfBjY40M2syIpUl/yeO/GIqLivPceFbhBqp84DKDj6B
         1a0f199+NyIR06RQCXgTreHTHYoaAW8EmUmCys/rt3MpFGeVIxMQOV/DuZlQG+6oJtFH
         T+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RedzcwQXnK2JFK7yvp/MkYUU1m35sxE8mjp3sZ0+O08=;
        b=gGC5+oEyudYTsi0O+1PebYek4JTGOhsjjlKaf1sR1+K3dY15Wb2JbbN4ds6RVCIurG
         3HiaHEViQxWMBSIsefx6T6GLzExCoMGEEWkpG8B8FZTyC9XONV0y7SGSWAj29/A3SFKz
         jq5V2KjInMgh9iZUbZUYCrtjx6BmQpwr0cd195St/DLQEWCi2PAvuPZLUBP38JNZMjH8
         IsKiUoHwMKrf1v9W8elp+BqumsePrb/pfWg/CgKrcNvhdRWLJh8p+D/9JewaoI6qxr7g
         l3lk5yChVb37sQrxwGaPyVvBRQ3JqYZRaBWID9n4/Kq33IJN2MiQGVay28WMp9WJ32fY
         cR/A==
X-Gm-Message-State: AOAM5310Ji9/VkjBKHlsThF+7hFgggPP973k25QWo4rzLVYSq7SZd6e5
        pLwPpt2lrw3ENF7ob4DnjFs=
X-Google-Smtp-Source: ABdhPJxeBOTcgVB8iviTLkqcQ6LzrND82y+6Q7o6gwzKv1TOGNGqjhBu0nzNbflGPrx9KowMoXxTVg==
X-Received: by 2002:a2e:a593:: with SMTP id m19mr869291ljp.103.1620603016249;
        Sun, 09 May 2021 16:30:16 -0700 (PDT)
Received: from localhost ([85.249.34.38])
        by smtp.gmail.com with ESMTPSA id q127sm3015291ljq.88.2021.05.09.16.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 16:30:16 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     Mikhail Rudenko <mike.rudenko@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        Remi Depommier <rde@setrix.com>,
        Amar Shankar <amsr@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
Date:   Mon, 10 May 2021 02:30:08 +0300
Message-Id: <20210509233010.2477973-1-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A separate firmware is needed for Broadcom 43430 revision 2.  This
chip can be found in e.g. certain revisions of Ampak AP6212 wireless
IC. Original firmware file from IC vendor is named
'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
id 43430, so requested firmware file name is
'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 16ed325795a8..f0c22b5bb57c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -617,6 +617,7 @@ BRCMF_FW_DEF(4339, "brcmfmac4339-sdio");
 BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
 /* Note the names are not postfixed with a1 for backward compatibility */
 BRCMF_FW_DEF(43430A1, "brcmfmac43430-sdio");
+BRCMF_FW_DEF(43430B0, "brcmfmac43430b0-sdio");
 BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
 BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
 BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
@@ -643,7 +644,8 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, 43362),
 	BRCMF_FW_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
 	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000001, 43430A0),
-	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFE, 43430A1),
+	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000002, 43430A1),
+	BRCMF_FW_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000004, 43430B0),
 	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0x00000200, 43456),
 	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
 	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
-- 
2.31.1

