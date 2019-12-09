Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802DA117977
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfLIWij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:38:39 -0500
Received: from mout.web.de ([212.227.15.3]:48313 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbfLIWih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:38:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575931113;
        bh=HVbvbJ3Yi08NdEgn7oHls6p1yIJqKL0tjNOsiEe0cnU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QYPPLktd7SuOBJ9KE2v0Nqu/z7+OS0VRjBEhJ/QfSL8Y8YeLz+5nN5TJKF/VPLqL/
         vUAJrRNKAWjauBrFhowU0YDULFGZ4o+3E0WxdqNMONTMingHVK8AWwYlBD4b3drvP8
         to4VgaikaDa7EgJqN8dw88/Z1LWfpBTqFES8xI8A=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.137.56]) by smtp.web.de
 (mrweb004 [213.165.67.108]) with ESMTPSA (Nemesis) id
 0Lnmpz-1i5wTH3xJn-00hyT2; Mon, 09 Dec 2019 23:38:33 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Soeren Moch <smoch@web.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] brcmfmac: add support for BCM4359 SDIO chipset
Date:   Mon,  9 Dec 2019 23:38:19 +0100
Message-Id: <20191209223822.27236-5-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GJs7KcSUGQtcSBqV23txnu685EcItFGhAPxjVA2qb51u72Wu277
 CJbK0lRLY2Yy00dvelvM7dIJEYRO0vEQrRX5AUQw4div8A8zOBUGqf8U5oYWMf1XZFXvnCl
 BhmUT3G7UtXTrXS8R+GjVALkyb1eBByBNudLFsmjwpQ7vZikVUSQ9pZb+YC2Dwf7GGtGZpw
 ifsIyIPNPAcXqvl1nVwuw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HbO2lG62y+4=:v/o0OCqxJfS2DDbgjuGFIF
 1S7B2KJ3QWU+t+sOWPL1ml4s/bJzXeo3JMBKdA1YXfYf9ew1KfWrqZoTOAEk3mW6r94fUDsps
 HF8kzVzvXs4kpVu4N08Q8KE/4d5+7kP5GvNEiRhYFvdXWHwZLx2yOFo9xsysA9KISCjdSz1fu
 GfiwHqe8cuVXPQ8G+xUdama5940oTTzb7cZNVfONH32Enk1dAu497X++zEvOf0NNctLL9BNVG
 08aVXYZSksO2fNHO8nrhUmP4dTbpPFDK2NLpriNyoo5zSR5ZGOwMmF+LW+gjs6PeKURYu1ir+
 dUsO2gfJkFzKZYYESRWSYEcET9HcHhZ6kSXoF2aSQ7WJDyW5dcbm5A7wxJZkQJbydkGJaH/ma
 D4o1P195WKavu9LnN3AANRy3f++53C+ANCDS5G/EYfsKVpKdRGNnDMkpcg1EoGoiyqenUVywe
 xBER6CDPhvYxpiJJFeou0GOTtKebwRXGNRYxGmFAveZ+hrAi0v+EJy6hMHFxrrV3yZAn3sd2T
 b8UBmC4Bd4zTPw1fhH6iM0gLwr6zTleAyDuJqRz8WCUES/CHCZkCIUVN//UKTPtz/2D1hnRMo
 yOZdF5Q5PYsqCT5SSHrFFwiSMXKBK+TV5NYTZmqMyEZzrXiOx4SNBWqCpUlN6tkgeCDiEksJv
 jlAFEru1xDls2eH7T11KuxPIsC4c0gJSV8iMmRngIlnYkVL4y4RsfspUU/ngnUtZtFkODmScA
 iJUsJdu2AO++U8PBIQOvKm2crLj8WGZZv2M/u2TijQHPNLNdO+VKxSiapxI11iuD/NdybmWMb
 uCZ9Qa2KIYZKKkIqnUNluVGWeXEerKGLCA+5aW5ifnD5INpRefCKvYbRCvlKJqzANIIcqsJ+x
 hjmMYrLQX4x6S9JlRryLvXwgyz3ayk0dIZmwKyR9nXwMd8VIu1ck1BaQ+S0VjqePiCbkw4iuV
 vizptIVu6veLA6qZK2KBcTPIAUZ0Si3YNI3M270s3pgfi18VvCH+303FAaVBc8w4h9glP9lNm
 k82msJKsCPUuKFKrdohcvs/T/lImNNCSzEsOKeSX4wrGG9kuYJ4R8U4O8uUBfC1V00/zE+G/W
 dNwq651kCkBKHqbpwHWUDZnEEEoN67cGkKAET+3FT5bp96wWNaU+25Ja/rHjn+wrVBg+cZFhA
 eHB/h+VFoNVrizxypYIqOJW896vKYfliY2X0k2dayC/XBbr5U9zd+xRWO84dGwsaEit0bFRtj
 TXXIbhL/KcbSvU/G63o73r+iiuBQePMaJDxvAPQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM4359 is a 2x2 802.11 abgn+ac Dual-Band HT80 combo chip and it
supports Real Simultaneous Dual Band feature.

Based on a similar patch by: Wright Feng <wright.feng@cypress.com>

Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
=2D--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 ++
 include/linux/mmc/sdio_ids.h                              | 1 +
 4 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/d=
rivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 68baf0189305..5b57d37caf17 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -973,6 +973,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] =
=3D {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_43012),
 	{ /* end: all zeroes */ }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index baf72e3984fc..282d0bc14e8e 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1408,6 +1408,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		addr =3D CORE_CC_REG(base, sr_control0);
 		reg =3D chip->ops->read32(chip->ctx, addr);
 		return (reg & CC_SR_CTL0_ENABLE_MASK) !=3D 0;
+	case BRCM_CC_4359_CHIP_ID:
 	case CY_CC_43012_CHIP_ID:
 		addr =3D CORE_CC_REG(pmu->base, retention_ctl);
 		reg =3D chip->ops->read32(chip->ctx, addr);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 21e535072f3f..c4012ed58b9c 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -616,6 +616,7 @@ BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
 BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
 BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
 BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
+BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
 BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
 BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");

@@ -638,6 +639,7 @@ static const struct brcmf_firmware_mapping brcmf_sdio_=
fwnames[] =3D {
 	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
 	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
 	BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
+	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
 	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
 	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
 };
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 08b25c02b5a1..930ef2d8264a 100644
=2D-- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -41,6 +41,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
+#define SDIO_DEVICE_ID_BROADCOM_4359		0x4359
 #define SDIO_DEVICE_ID_CYPRESS_4373		0x4373
 #define SDIO_DEVICE_ID_CYPRESS_43012		43012

=2D-
2.17.1

