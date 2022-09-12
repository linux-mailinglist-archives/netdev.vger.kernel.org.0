Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005B65B5789
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiILJxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 05:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiILJxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 05:53:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416BF2229E;
        Mon, 12 Sep 2022 02:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ei4pqthoLxLIR8gQN/qPHmZ1JCY6roVvg3hwl45LwrA=; b=gfLxwJhsarVmNxEMcQX4P1sOSe
        iQomeIKO7HeAp2HmryYcixwpsxr5HgdhzMRAQej+hadYYwhw/D3n/VCx/fBi05zCQTBBHBIC4YZjg
        hi/UnlBtyAbZ16QFm6WaX9cw+EDtJtWj+BqH2WGjLrZQmPpykqA2cmgzCv1wvnWb8qeRk+ScNNR+e
        i1XMOioKPn6OlhGLHAaO6KaGfeWguMdXPEDSnC/BsaxRJktsHJUSQjgG/c3ZZ5umLNxpdjc9kmm3C
        8/cIqpubT75tCa3ro+Bl689yZX8/D/tmA4W0iXa9JjLFZTUhL2WkeV+NIDkXI9l/aiKvOD91Y5pJ+
        4shOTaMQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40066 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oXg7d-0001SN-Ge; Mon, 12 Sep 2022 10:52:57 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oXg7c-0064uy-Q9; Mon, 12 Sep 2022 10:52:56 +0100
In-Reply-To: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: [PATCH wireless-next v2 04/12] brcmfmac: firmware: Support passing in
 multiple board_types
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oXg7c-0064uy-Q9@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 12 Sep 2022 10:52:56 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

Apple platforms have firmware and config files identified with multiple
dimensions. We want to be able to find the most specific firmware
available for any given platform, progressively trying more general
firmwares.

To do this, first add support for passing in multiple board_types,
which will be tried in sequence.

Since this will cause more log spam due to missing firmwares, also
switch the secondary firmware fecthes to use the _nowarn variant, which
will not log if the firmware is not found.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 53 +++++++++++++++----
 .../broadcom/brcm80211/brcmfmac/firmware.h    |  4 +-
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  4 +-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  2 +-
 4 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 6c7c0c8f94ce..371c086d1f48 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -430,6 +430,7 @@ struct brcmf_fw {
 	struct device *dev;
 	struct brcmf_fw_request *req;
 	u32 curpos;
+	unsigned int board_index;
 	void (*done)(struct device *dev, int err, struct brcmf_fw_request *req);
 };
 
@@ -616,17 +617,21 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 				     struct brcmf_fw *fwctx)
 {
 	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
+	unsigned int i;
 	int ret;
 
-	/* Files can be board-specific, first try a board-specific path */
-	if (fwctx->req->board_type) {
+	/* Files can be board-specific, first try board-specific paths */
+	for (i = 0; i < ARRAY_SIZE(fwctx->req->board_types); i++) {
 		char *alt_path;
 
-		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
+		if (!fwctx->req->board_types[i])
+			goto fallback;
+		alt_path = brcm_alt_fw_path(cur->path,
+					    fwctx->req->board_types[i]);
 		if (!alt_path)
 			goto fallback;
 
-		ret = request_firmware(fw, alt_path, fwctx->dev);
+		ret = firmware_request_nowarn(fw, alt_path, fwctx->dev);
 		kfree(alt_path);
 		if (ret == 0)
 			return ret;
@@ -660,15 +665,40 @@ static void brcmf_fw_request_done_alt_path(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
 	struct brcmf_fw_item *first = &fwctx->req->items[0];
+	const char *board_type, *alt_path;
 	int ret = 0;
 
-	/* Fall back to canonical path if board firmware not found */
-	if (!fw)
-		ret = request_firmware_nowait(THIS_MODULE, true, first->path,
+	if (fw) {
+		brcmf_fw_request_done(fw, ctx);
+		return;
+	}
+
+	/* Try next board firmware */
+	if (fwctx->board_index < ARRAY_SIZE(fwctx->req->board_types)) {
+		board_type = fwctx->req->board_types[fwctx->board_index++];
+		if (!board_type)
+			goto fallback;
+		alt_path = brcm_alt_fw_path(first->path, board_type);
+		if (!alt_path)
+			goto fallback;
+
+		ret = request_firmware_nowait(THIS_MODULE, true, alt_path,
 					      fwctx->dev, GFP_KERNEL, fwctx,
-					      brcmf_fw_request_done);
+					      brcmf_fw_request_done_alt_path);
+		kfree(alt_path);
 
-	if (fw || ret < 0)
+		if (ret < 0)
+			brcmf_fw_request_done(fw, ctx);
+		return;
+	}
+
+fallback:
+	/* Fall back to canonical path if board firmware not found */
+	ret = request_firmware_nowait(THIS_MODULE, true, first->path,
+				      fwctx->dev, GFP_KERNEL, fwctx,
+				      brcmf_fw_request_done);
+
+	if (ret < 0)
 		brcmf_fw_request_done(fw, ctx);
 }
 
@@ -712,10 +742,11 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	fwctx->done = fw_cb;
 
 	/* First try alternative board-specific path if any */
-	if (fwctx->req->board_type)
+	if (fwctx->req->board_types[0])
 		alt_path = brcm_alt_fw_path(first->path,
-					    fwctx->req->board_type);
+					    fwctx->req->board_types[0]);
 	if (alt_path) {
+		fwctx->board_index++;
 		ret = request_firmware_nowait(THIS_MODULE, true, alt_path,
 					      fwctx->dev, GFP_KERNEL, fwctx,
 					      brcmf_fw_request_done_alt_path);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index e290dec9c53d..1266cbaee072 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -11,6 +11,8 @@
 
 #define BRCMF_FW_DEFAULT_PATH		"brcm/"
 
+#define BRCMF_FW_MAX_BOARD_TYPES	8
+
 /**
  * struct brcmf_firmware_mapping - Used to map chipid/revmask to firmware
  *	filename and nvram filename. Each bus type implementation should create
@@ -66,7 +68,7 @@ struct brcmf_fw_request {
 	u16 domain_nr;
 	u16 bus_nr;
 	u32 n_items;
-	const char *board_type;
+	const char *board_types[BRCMF_FW_MAX_BOARD_TYPES];
 	struct brcmf_fw_item items[];
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index ec73d2620ec9..2a74c9d8d46a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1852,11 +1852,13 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->items[BRCMF_PCIE_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->board_type = devinfo->settings->board_type;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
 
+	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
+	fwreq->board_types[0] = devinfo->settings->board_type;
+
 	return fwreq;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5eb9b3138f09..465d95d83759 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4426,7 +4426,7 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 	fwreq->items[BRCMF_SDIO_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
 	fwreq->items[BRCMF_SDIO_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_SDIO_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
-	fwreq->board_type = bus->sdiodev->settings->board_type;
+	fwreq->board_types[0] = bus->sdiodev->settings->board_type;
 
 	return fwreq;
 }
-- 
2.30.2

