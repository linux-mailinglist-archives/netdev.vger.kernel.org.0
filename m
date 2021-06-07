Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E9839D9C0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFGKgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhFGKge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 06:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD0C611ED;
        Mon,  7 Jun 2021 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623062083;
        bh=cU05gedathS+r+GYw7Hqqj6yfka3rVJddSsAknXH9fg=;
        h=From:To:Cc:Subject:Date:From;
        b=ijCbd5gBpCOvzqed80tpJI8FK0XSO+0BphUm6x5X9PAFJqaHBOu1FhHx1MJG/77mv
         ZADdop/J4YzzeywciixV2k2Qx/8RQu5vspDgOCuKhGkPKZiY/nMfLt6nh+NsdCAm99
         a/fIYeUWXnf2F2I7B7v7tEfXYAISsp7QKxvHepFlslUyr8anfLv7Y4y45lHNxj8OZ9
         N5VkZ2PArQWaFVnpnq9f8PG8dipnKJl9cAuoiDtaaFmMK6waGOfUSQvfVJdzcsaMnQ
         2Ii+wiZB4RfGMSNEwKSJ04hFN7ICN2rXl9HZqgwAD09Oz8oL/YBbWdgrrjau95t4rz
         vKbXZ+3VMfl/w==
From:   matthias.bgg@kernel.org
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        Remi Depommier <rde@setrix.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        linux-wireless@vger.kernel.org, Amar Shankar <amsr@cypress.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        SHA-cyfmac-dev-list@infineon.com, rafal@milecki.pl,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Wright Feng <wright.feng@infineon.com>
Subject: [PATCH] brcmfmac: Add clm_blob firmware files to modinfo
Date:   Mon,  7 Jun 2021 12:34:33 +0200
Message-Id: <20210607103433.21022-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

Cypress Wi-Fi chipsets include information regarding regulatory
constraints. These are provided to the driver through "Country Local
Matrix" (CLM) blobs. Files present in Linux firmware repository are
on a generic world-wide safe version with conservative power
settings which is designed to comply with regulatory but may not
provide best performance on all boards. Never the less, a better
functionality can be expected with the file present, so add it to the
modinfo of the driver.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>

---

 .../wireless/broadcom/brcm80211/brcmfmac/firmware.h  |  7 +++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c  |  4 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 ++++++------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 46c66415b4a6..e290dec9c53d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -32,6 +32,13 @@ static const char BRCM_ ## fw_name ## _FIRMWARE_BASENAME[] = \
 	BRCMF_FW_DEFAULT_PATH fw_base; \
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw_base ".bin")
 
+/* Firmware and Country Local Matrix files */
+#define BRCMF_FW_CLM_DEF(fw_name, fw_base) \
+static const char BRCM_ ## fw_name ## _FIRMWARE_BASENAME[] = \
+	BRCMF_FW_DEFAULT_PATH fw_base; \
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw_base ".bin"); \
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw_base ".clm_blob")
+
 #define BRCMF_FW_ENTRY(chipid, mask, name) \
 	{ chipid, mask, BRCM_ ## name ## _FIRMWARE_BASENAME }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 143a705b5cb3..c49dd0c36ae4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -48,8 +48,8 @@ enum brcmf_pcie_state {
 BRCMF_FW_DEF(43602, "brcmfmac43602-pcie");
 BRCMF_FW_DEF(4350, "brcmfmac4350-pcie");
 BRCMF_FW_DEF(4350C, "brcmfmac4350c2-pcie");
-BRCMF_FW_DEF(4356, "brcmfmac4356-pcie");
-BRCMF_FW_DEF(43570, "brcmfmac43570-pcie");
+BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
+BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
 BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
 BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
 BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b8788d7090a4..69cbe38f05ce 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -616,14 +616,14 @@ BRCMF_FW_DEF(43362, "brcmfmac43362-sdio");
 BRCMF_FW_DEF(4339, "brcmfmac4339-sdio");
 BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
 /* Note the names are not postfixed with a1 for backward compatibility */
-BRCMF_FW_DEF(43430A1, "brcmfmac43430-sdio");
-BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
+BRCMF_FW_CLM_DEF(43430A1, "brcmfmac43430-sdio");
+BRCMF_FW_CLM_DEF(43455, "brcmfmac43455-sdio");
 BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
-BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
-BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
+BRCMF_FW_CLM_DEF(4354, "brcmfmac4354-sdio");
+BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-sdio");
 BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
-BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
-BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
+BRCMF_FW_CLM_DEF(4373, "brcmfmac4373-sdio");
+BRCMF_FW_CLM_DEF(43012, "brcmfmac43012-sdio");
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
-- 
2.31.1

