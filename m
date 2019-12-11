Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A424F11C0D8
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfLKXxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:53:32 -0500
Received: from mout.web.de ([212.227.17.12]:58215 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbfLKXxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 18:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576108394;
        bh=UIfQ1uEbBM7aRcsCELoWupsxNBU1uTnrfPC1GXuP4k0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=k+FurcGv4TqMLZ609jRprB6gFKo66ccff7+ww9DBPhQA3+MY2E9cemTMAeF/mQc/D
         W6mrMnD79QAA2/sbWWE2G2YVn6SF27stpEQioQHz7idLthLgPOqFKLURomtcw4zBW6
         A0dwfZFmfTDMlWbvEf+eQ+ZgKgNxW2vyvlTXLj8o=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([89.204.139.166]) by smtp.web.de
 (mrweb101 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0LopiJ-1i3xMg2sFn-00gnU9; Thu, 12 Dec 2019 00:53:13 +0100
From:   Soeren Moch <smoch@web.de>
To:     Kalle Valo <kvalo@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>
Cc:     Soeren Moch <smoch@web.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/9] brcmfmac: add support for BCM4359 SDIO chipset
Date:   Thu, 12 Dec 2019 00:52:49 +0100
Message-Id: <20191211235253.2539-6-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
References: <20191211235253.2539-1-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fbFLsfS9zJn7W1W+geLYLgL2xgrwq0iSOy4xXpjyJpvWZaUoD4E
 Y0N/HgtLWYoCW//RMA1C56H/2QGtRXUt7FI3e+QfgKv7AbY7WZfIYaL0vqoEDdrNw1A7fou
 Bda7+OfEDfs76gdEzVQB+VO+mAGdy7KGqTxlpNipT/MSTqPXjhnbcFMvToySJY3i9bvbqSG
 zaec0MLD5YciT9kes7SPg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QcQIpKAkuMw=:9dXi2isuR2bE8ZA7lkpXK3
 JHnpknUmYgsJHS5jpFZlGrfzeS79/ygdKCK4CMI6KkJ+cVRcXPzAUWkAB9l3jho2xXKh28c1x
 2la10ALczojxXFDuCCWb6G02C5ESFJzE02HTX6oTcZnhVabr7HU96rtlUN6spKEZ9Bd7My17/
 RRZ7KSsMH9JlQ80JiNuKsD/tLHHTwi5PzmmrcUfmv9yTWf2/ZBE8J20R2S7YOBu6xecdLVR2Y
 IA17+ZWAzHh/GkSAmMHPiBInLGgT2yx1UvbY0MOFTC7RserBpyOBRle8UPkdaqNy88G3M/7aZ
 oGtNIxEQ4t9lRgFZNZHI0S2yPi+CJHroCCxriCTfwj1QIlLaNhXDVWjLqARRywmd8y1r2B+Lv
 cmWYt+sGIETyVYvpMZdyHY/fw8R5KB4QhcaCe3iQCDO7rxU+XEuDQMZiqkMD4z+pPygugXB8Y
 ulCRhlEO0rqXz7FmPUll2EB2WOLRSc6UM/D8Hlv7enz7jA/Pdaf7C+rK4dbygEYmeJ/ccjvbc
 RfsTH4pxCBAdm7K4MPdyMbiDXQwJLFt9fQokHZC/54Ie8ksTJBkFRpAUp4lXmnOYgtVQ1DJk2
 HXmMuxF14xwckRovEh1YrUooaKUKZxP9euxJndIiOj6mIiO7A1kay3hTsw3iHIJXbokxFamWm
 MPLyy0lWyGeaRaceNUnEhJRx6MKPHg0dagULvbAW5U2i+I6I5weUdMgrl7khiQoGUtuh+FQQf
 nPJ+YDQXQqJsCY/uJxA57bCiWSMdcpJP+SzhHnMEA31M1pHw3R+wY0RQ+N4a+4JRxS+JX5Gkj
 i77aPu5fIUgq44nCPD0yAdlz0ynMseQ2+TXC/YcxvBuFuVXIxG1PYaLmgsf3UHapxiFtJxQ0t
 xDOdJsSgozVtIoGS+hbAFeDBEHIXbbwMfoQ5lxaSdhw1pl1aCtHMO/4tywzCB96nrpcsz/y+S
 o44ZdGQOPgQvu5D8ynByIHNb6wsTTFUoHLPm5oLV54KoWXgD7R3ZVZynCwJsPMd8E3oHfMgI7
 0ziSq7RMTogMHgJSJfUOEJPJJscLHXoNWBAb79IyhFi6gxNAf072nSSDJJC/pd1NPCabwiL3g
 E9gtYKllSBhDz6qQdMn1S7pTrXincYqaWcTS8efzUSMV6aG/Djcza10dAmR7ulFD9cqj4qtF4
 1Ud9C6FJxZYLebDfwFMc+hCGGyZJel9btqgRw27Pej+UBZ5LR5DOPU8kHhD3U01yDQmOMUdV1
 RSQtIOcuYrpDFvTyIO46ZygLtElFl8ANvmhoupA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM4359 is a 2x2 802.11 abgn+ac Dual-Band HT80 combo chip and it
supports Real Simultaneous Dual Band feature.

Based on a similar patch by: Wright Feng <wright.feng@cypress.com>

Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
changes in v2:
- add SDIO_DEVICE_ID_CYPRESS_89359 as requested
  by Chi-Hsien Lin <chi-hsien.lin@cypress.com>

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
=2D--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 ++
 include/linux/mmc/sdio_ids.h                              | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/d=
rivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 68baf0189305..f4c53ab46058 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -973,8 +973,10 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] =
=3D {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_43012),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_89359),
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
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
index 08b25c02b5a1..2e9a6e4634eb 100644
=2D-- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -41,8 +41,10 @@
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
+#define SDIO_DEVICE_ID_BROADCOM_4359		0x4359
 #define SDIO_DEVICE_ID_CYPRESS_4373		0x4373
 #define SDIO_DEVICE_ID_CYPRESS_43012		43012
+#define SDIO_DEVICE_ID_CYPRESS_89359		0x4355

 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
=2D-
2.17.1

