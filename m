Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20342BA699
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgKTJwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgKTJwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 04:52:47 -0500
Received: from ziggy.com (unknown [213.195.126.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748B5204EF;
        Fri, 20 Nov 2020 09:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605865966;
        bh=udTHvxcuCpSES0f2tVzcWrSR6BzuIbl1+3bPc1axuBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NAyTdDXfdkzDgGz51roi/laoFCqxWVIiamZD9ajJRQcgl+HNHWwB9RLtk97KcB8ZZ
         IV54pbFljRsAsX619EJXoOPbqK8OOdZ0u1EMEBfj5Ke7TH80GhZapI/bxXQZ23nEGV
         3K0k9yg7mnz98iMcsjaNmRTClHnps69KTwImjO1Y=
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
        Amar Shankar <amsr@cypress.com>,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH v2] brcmfmac: expose firmware config files through modinfo
Date:   Fri, 20 Nov 2020 10:52:33 +0100
Message-Id: <20201120095233.19953-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

Apart from a firmware binary the chip needs a config file used by the
FW. Add the config files to modinfo so that they can be read by
userspace.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>

---

Changes in v2:
In comparison to first version [0] we use wildcards to enumerate the
firmware configuration files. Wildcard support was added to dracut
recently [1].
[0] https://lore.kernel.org/linux-wireless/20200701153123.25602-1-matthias.bgg@kernel.org/
[1] https://github.com/dracutdevs/dracut/pull/860

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 99987a789e7e..dd6d287b1b00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -625,6 +625,15 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
 BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
 BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
 
+/* firmware config files */
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4330-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43362-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4356-pcie.*.txt");
+
 static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
 	BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
-- 
2.29.2

