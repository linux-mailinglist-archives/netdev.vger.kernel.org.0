Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DBB6DB569
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 22:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjDGUiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjDGUiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 16:38:17 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC07CA2B;
        Fri,  7 Apr 2023 13:38:10 -0700 (PDT)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 84F7885956;
        Fri,  7 Apr 2023 22:38:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1680899888;
        bh=qHRzIcn1C3DUj1qfUwkJa2YX3XyiIBxJLMmhZnPbKh0=;
        h=From:To:Cc:Subject:Date:From;
        b=ILz90BvKX0+yhnVW/zZz1fytPEhCQmIKzSR6GT8Jenoiey7Ud/fXxyFhqPbWF2TcJ
         x3wUEgqFMDs4L7sKBD+QPEyXA4Bc1faYv8SD8zVEwgnSwMpCpRAmLnFhlFTdVHehB2
         BO2ABCYqFMv7KmneObwv21DlXLp6shvDFKl5SjR9mbwwnusZkKRRWcnQ1DwKPtTVXv
         xAH3rKxY/Su9TU4wSjREc9AvZGL7ng3T3uuGqMjjalJscUFuikBzFameWwNFYPHrId
         ArcRzjHFchP9aDDz5GEzyW4PUGNSmWAxBtY7qnSPNsVvUjb8+WYcQGYNb9Rp8PKCit
         x0B+c+duUHwjg==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
Date:   Fri,  7 Apr 2023 22:37:52 +0200
Message-Id: <20230407203752.128539-1-marex@denx.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
The odd thing about this is that the previous 1YN populated
on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
while the chip populated on real hardware has a Cypress one.
The device ID also differs between the two devices. But they
are both 43439 otherwise, so add the IDs for both.

On-device 1YN (43439), the new one, chip label reads "1YN":
```
/sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
0x04b4
0xbd3d
```

EA M.2 evaluation board 1YN (43439), the old one, chip label reads "1YN ES1.4":
```
/sys/.../mmc_host/mmc0/mmc0:0001/# cat vendor device
0x02d0
0xa9a6
```

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Fixes: be376df724aa3 ("wifi: brcmfmac: add 43439 SDIO ids and initialization")
Signed-off-by: Marek Vasut <marex@denx.de>
---
NOTE: Please drop the Fixes tag if this is considered unjustified
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Danny van Heumen <danny@dannyvanheumen.nl>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Marek Vasut <marex@denx.de>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-mmc@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
V2: Update commit message, add IDs for both old and new device
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c    | 9 ++++++++-
 include/linux/mmc/sdio_ids.h                             | 5 ++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 65d4799a56584..ff710b0b5071a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -965,6 +965,12 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		.driver_data = BRCMF_FWVENDOR_ ## fw_vend \
 	}
 
+#define CYW_SDIO_DEVICE(dev_id, fw_vend) \
+	{ \
+		SDIO_DEVICE(SDIO_VENDOR_ID_CYPRESS, dev_id), \
+		.driver_data = BRCMF_FWVENDOR_ ## fw_vend \
+	}
+
 /* devices we support, null terminated */
 static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43143, WCC),
@@ -979,6 +985,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339, WCC),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339, WCC),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430, WCC),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43439, WCC),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345, WCC),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455, WCC),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354, WCC),
@@ -986,9 +993,9 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359, WCC),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373, CYW),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43012, CYW),
-	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439, CYW),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752, CYW),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_89359, CYW),
+	CYW_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439, CYW),
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 0e4ef9c5127ad..bf3c95d8eb8af 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -74,10 +74,13 @@
 #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
 #define SDIO_DEVICE_ID_BROADCOM_43364		0xa9a4
 #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
-#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439	0xa9af
+#define SDIO_DEVICE_ID_BROADCOM_43439		0xa9af
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
 #define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752	0xaae8
 
+#define SDIO_VENDOR_ID_CYPRESS			0x04b4
+#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439	0xbd3d
+
 #define SDIO_VENDOR_ID_MARVELL			0x02df
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
 #define SDIO_DEVICE_ID_MARVELL_8688_WLAN	0x9104
-- 
2.39.2

