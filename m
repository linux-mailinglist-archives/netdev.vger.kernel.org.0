Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA3A6DA6F9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjDGBbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjDGBbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:31:31 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC7493E4;
        Thu,  6 Apr 2023 18:31:28 -0700 (PDT)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 182CA85F45;
        Fri,  7 Apr 2023 03:31:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1680831086;
        bh=vXVWq86ptv5lCvSWV+LZTMItbNHfXVWbPisL3UAohQU=;
        h=From:To:Cc:Subject:Date:From;
        b=cZzZf31qnx5pD+xJyTcys65tFQvfyMaiHeTmQVke5y5bSm9Tq3wVV8XKoR/HgWjH7
         RaqWZE/ApPm7WgepkOVpo7vAKn19QfYiJ6yPfc2i3qW9TQltSG4sET9A0MOau5rc8v
         RQ1RtpLUxyR7XbysVdpkNlyH5r/Z3Z1+KkJNfraXZ0IRG22DOapWBokLLK+hVZG0sN
         FJ9DneSICApIOi+iwMKVDjTauKcCasuQuKFn1ssvqaBeuHFLtc/zsJZ8c7e3tkw15t
         1Cb5k8UAsyCKxeNaMN6KE6obbBXok+CE2/P8thGcTuLlINr6T2eKxMoK3AlAK8MZFy
         GdfZYdhWszHWg==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] wifi: brcmfmac: add Cypress 43439 SDIO ids
Date:   Fri,  7 Apr 2023 03:31:18 +0200
Message-Id: <20230407013118.466441-1-marex@denx.de>
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

```
/sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
0x04b4
0xbd3d
```

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
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-mmc@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
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

