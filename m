Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A5F210F57
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgGAPbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731879AbgGAPbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:31:38 -0400
Received: from ziggy.cz (unknown [213.195.114.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC5220760;
        Wed,  1 Jul 2020 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593617497;
        bh=EB2CkEeCooqWPM+FKciypi3S6C1CFpF0DGtBgv2mghk=;
        h=From:To:Cc:Subject:Date:From;
        b=OWNMZ3rJ5ciZjAne86fG6PgL7snREQ8Oxp1PzRvjC7tXhtr/8lDoariL+hIXqRWlI
         Yda13FmLkR2Juu8D5+Ev+trCwp0K/BNMiMyOTxHtmcwnYPNk0VhVYuti0hKzOM3X+F
         k1UznWujuneMKF6uv+rNGLf7bXYmaauzozH/eBu0=
From:   matthias.bgg@kernel.org
To:     Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>, hdegoede@redhat.com
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Soeren Moch <smoch@web.de>
Subject: [PATCH] brcmfmac: expose firmware config files through modinfo
Date:   Wed,  1 Jul 2020 17:31:23 +0200
Message-Id: <20200701153123.25602-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

Apart from a firmware binary the chip needs a config file used by the
FW. Add the config files to modinfo so that they can be read by
userspace.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>

---

 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 310d8075f5d7..ba18df6d8d94 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -624,6 +624,22 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
 BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
 BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
 
+/* firmware config files */
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4330-sdio.Prowise-PT301.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.meegopad-t08.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.pov-tab-p1006w-data.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.ONDA-V80 PLUS.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.AP6212.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.MUR1DX.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.MINIX-NEO Z83-4.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4356-pcie.gpd-win-pocket.txt");
+
 static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
 	BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
-- 
2.27.0

