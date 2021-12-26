Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D025C47F77D
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhLZPg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:36:59 -0500
Received: from marcansoft.com ([212.63.210.85]:55522 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhLZPg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:36:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 21DCE4264E;
        Sun, 26 Dec 2021 15:36:44 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 02/34] brcmfmac: pcie: Declare missing firmware files in pcie.c
Date:   Mon, 27 Dec 2021 00:35:52 +0900
Message-Id: <20211226153624.162281-3-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move one of the declarations from sdio.c to pcie.c, since it makes no
sense in the former (SDIO support is optional), and add missing ones.

Signed-off-by: Hector Martin <marcan@marcan.st>
Fixes: 75729e110e68 ("brcmfmac: expose firmware config files through modinfo")
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 -
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 8b149996fc00..aed49416c434 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -59,6 +59,13 @@ BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
 BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 
+/* firmware config files */
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
+
+/* per-board firmware binaries */
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.bin");
+
 static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
 	BRCMF_FW_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8effeb7a7269..5d156e591b35 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -629,7 +629,6 @@ BRCMF_FW_CLM_DEF(43752, "brcmfmac43752-sdio");
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 
 /* per-board firmware binaries */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.bin");
-- 
2.33.0

