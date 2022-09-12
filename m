Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B965B57A0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 11:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiILJyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 05:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiILJxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 05:53:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9BC38694;
        Mon, 12 Sep 2022 02:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZKq5LVAgsyotdRPDg0MPEtw2EDcL8jnfDkhskfrhrMs=; b=q0tirkcVb+v/cDUvrQVPuLB7cX
        m66mnhAtqiaoNy9KTgM9cXGkddRjzi7DrqKPjV+59R1p3PzVYiN2Q4jc5mX0ZdkbBwFkU+WVVYckx
        oNUn+FHVJw4e560kVj9/GVUgdmOS30VCCUK7AFVfRZkfzdGOg9WTWSpZDjZB/mE2mRn6tEVvD1lDZ
        GAcTbl1g4QEgbJDSCQX3CSBaPXtZSFGrlhJIwCalpAwEAZlrfhCCaFM9VQia/r8c/6OWMaH/OSJUd
        iz6oHcbIhscwTQavWQZks3td8Gd6BT7gMIfNCJuo9t+f0g6NKgPNdSCEGrFMCdatZ66X3lAYGmsMC
        XZ9w6tfg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60542 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oXg88-0001UZ-Df; Mon, 12 Sep 2022 10:53:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oXg87-0064vZ-MX; Mon, 12 Sep 2022 10:53:27 +0100
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
Subject: [PATCH wireless-next v2 10/12] brcmfmac: pcie: Support PCIe core
 revisions >= 64
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oXg87-0064vZ-MX@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 12 Sep 2022 10:53:27 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

These newer PCIe core revisions include new sets of registers that must
be used instead of the legacy ones. Introduce a brcmf_pcie_reginfo to
hold the specific register offsets and values to use for a given
platform, and change all the register accesses to indirect through it.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 125 +++++++++++++++---
 1 file changed, 105 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3fb590a6e03b..269a516ae654 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -119,6 +119,12 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0	0x140
 #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1	0x144
 
+#define BRCMF_PCIE_64_PCIE2REG_INTMASK		0xC14
+#define BRCMF_PCIE_64_PCIE2REG_MAILBOXINT	0xC30
+#define BRCMF_PCIE_64_PCIE2REG_MAILBOXMASK	0xC34
+#define BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_0	0xA20
+#define BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_1	0xA24
+
 #define BRCMF_PCIE2_INTA			0x01
 #define BRCMF_PCIE2_INTB			0x02
 
@@ -138,6 +144,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define	BRCMF_PCIE_MB_INT_D2H3_DB0		0x400000
 #define	BRCMF_PCIE_MB_INT_D2H3_DB1		0x800000
 
+#define BRCMF_PCIE_MB_INT_FN0			(BRCMF_PCIE_MB_INT_FN0_0 | \
+						 BRCMF_PCIE_MB_INT_FN0_1)
 #define BRCMF_PCIE_MB_INT_D2H_DB		(BRCMF_PCIE_MB_INT_D2H0_DB0 | \
 						 BRCMF_PCIE_MB_INT_D2H0_DB1 | \
 						 BRCMF_PCIE_MB_INT_D2H1_DB0 | \
@@ -147,6 +155,40 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 						 BRCMF_PCIE_MB_INT_D2H3_DB0 | \
 						 BRCMF_PCIE_MB_INT_D2H3_DB1)
 
+#define	BRCMF_PCIE_64_MB_INT_D2H0_DB0		0x1
+#define	BRCMF_PCIE_64_MB_INT_D2H0_DB1		0x2
+#define	BRCMF_PCIE_64_MB_INT_D2H1_DB0		0x4
+#define	BRCMF_PCIE_64_MB_INT_D2H1_DB1		0x8
+#define	BRCMF_PCIE_64_MB_INT_D2H2_DB0		0x10
+#define	BRCMF_PCIE_64_MB_INT_D2H2_DB1		0x20
+#define	BRCMF_PCIE_64_MB_INT_D2H3_DB0		0x40
+#define	BRCMF_PCIE_64_MB_INT_D2H3_DB1		0x80
+#define	BRCMF_PCIE_64_MB_INT_D2H4_DB0		0x100
+#define	BRCMF_PCIE_64_MB_INT_D2H4_DB1		0x200
+#define	BRCMF_PCIE_64_MB_INT_D2H5_DB0		0x400
+#define	BRCMF_PCIE_64_MB_INT_D2H5_DB1		0x800
+#define	BRCMF_PCIE_64_MB_INT_D2H6_DB0		0x1000
+#define	BRCMF_PCIE_64_MB_INT_D2H6_DB1		0x2000
+#define	BRCMF_PCIE_64_MB_INT_D2H7_DB0		0x4000
+#define	BRCMF_PCIE_64_MB_INT_D2H7_DB1		0x8000
+
+#define BRCMF_PCIE_64_MB_INT_D2H_DB		(BRCMF_PCIE_64_MB_INT_D2H0_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H0_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H1_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H1_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H2_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H2_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H3_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H3_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H4_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H4_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H5_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H5_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H6_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H6_DB1 | \
+						 BRCMF_PCIE_64_MB_INT_D2H7_DB0 | \
+						 BRCMF_PCIE_64_MB_INT_D2H7_DB1)
+
 #define BRCMF_PCIE_SHARED_VERSION_7		7
 #define BRCMF_PCIE_MIN_SHARED_VERSION		5
 #define BRCMF_PCIE_MAX_SHARED_VERSION		BRCMF_PCIE_SHARED_VERSION_7
@@ -273,6 +315,7 @@ struct brcmf_pciedev_info {
 	char nvram_name[BRCMF_FW_NAME_LEN];
 	char clm_name[BRCMF_FW_NAME_LEN];
 	const struct firmware *clm_fw;
+	const struct brcmf_pcie_reginfo *reginfo;
 	void __iomem *regs;
 	void __iomem *tcm;
 	u32 ram_base;
@@ -359,6 +402,36 @@ static const u32 brcmf_ring_itemsize[BRCMF_NROF_COMMON_MSGRINGS] = {
 	BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE
 };
 
+struct brcmf_pcie_reginfo {
+	u32 intmask;
+	u32 mailboxint;
+	u32 mailboxmask;
+	u32 h2d_mailbox_0;
+	u32 h2d_mailbox_1;
+	u32 int_d2h_db;
+	u32 int_fn0;
+};
+
+static const struct brcmf_pcie_reginfo brcmf_reginfo_default = {
+	.intmask = BRCMF_PCIE_PCIE2REG_INTMASK,
+	.mailboxint = BRCMF_PCIE_PCIE2REG_MAILBOXINT,
+	.mailboxmask = BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
+	.h2d_mailbox_0 = BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0,
+	.h2d_mailbox_1 = BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1,
+	.int_d2h_db = BRCMF_PCIE_MB_INT_D2H_DB,
+	.int_fn0 = BRCMF_PCIE_MB_INT_FN0,
+};
+
+static const struct brcmf_pcie_reginfo brcmf_reginfo_64 = {
+	.intmask = BRCMF_PCIE_64_PCIE2REG_INTMASK,
+	.mailboxint = BRCMF_PCIE_64_PCIE2REG_MAILBOXINT,
+	.mailboxmask = BRCMF_PCIE_64_PCIE2REG_MAILBOXMASK,
+	.h2d_mailbox_0 = BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_0,
+	.h2d_mailbox_1 = BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_1,
+	.int_d2h_db = BRCMF_PCIE_64_MB_INT_D2H_DB,
+	.int_fn0 = 0,
+};
+
 static void brcmf_pcie_setup(struct device *dev, int ret,
 			     struct brcmf_fw_request *fwreq);
 static struct brcmf_fw_request *
@@ -802,30 +875,29 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
 
 static void brcmf_pcie_intr_disable(struct brcmf_pciedev_info *devinfo)
 {
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK, 0);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxmask, 0);
 }
 
 
 static void brcmf_pcie_intr_enable(struct brcmf_pciedev_info *devinfo)
 {
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
-			       BRCMF_PCIE_MB_INT_D2H_DB |
-			       BRCMF_PCIE_MB_INT_FN0_0 |
-			       BRCMF_PCIE_MB_INT_FN0_1);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxmask,
+			       devinfo->reginfo->int_d2h_db |
+			       devinfo->reginfo->int_fn0);
 }
 
 static void brcmf_pcie_hostready(struct brcmf_pciedev_info *devinfo)
 {
 	if (devinfo->shared.flags & BRCMF_PCIE_SHARED_HOSTRDY_DB1)
 		brcmf_pcie_write_reg32(devinfo,
-				       BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1, 1);
+				       devinfo->reginfo->h2d_mailbox_1, 1);
 }
 
 static irqreturn_t brcmf_pcie_quick_check_isr(int irq, void *arg)
 {
 	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)arg;
 
-	if (brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT)) {
+	if (brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->mailboxint)) {
 		brcmf_pcie_intr_disable(devinfo);
 		brcmf_dbg(PCIE, "Enter\n");
 		return IRQ_WAKE_THREAD;
@@ -840,15 +912,14 @@ static irqreturn_t brcmf_pcie_isr_thread(int irq, void *arg)
 	u32 status;
 
 	devinfo->in_irq = true;
-	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
+	status = brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->mailboxint);
 	brcmf_dbg(PCIE, "Enter %x\n", status);
 	if (status) {
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
+		brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxint,
 				       status);
-		if (status & (BRCMF_PCIE_MB_INT_FN0_0 |
-			      BRCMF_PCIE_MB_INT_FN0_1))
+		if (status & devinfo->reginfo->int_fn0)
 			brcmf_pcie_handle_mb_data(devinfo);
-		if (status & BRCMF_PCIE_MB_INT_D2H_DB) {
+		if (status & devinfo->reginfo->int_d2h_db) {
 			if (devinfo->state == BRCMFMAC_PCIE_STATE_UP)
 				brcmf_proto_msgbuf_rx_trigger(
 							&devinfo->pdev->dev);
@@ -907,8 +978,8 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 	if (devinfo->in_irq)
 		brcmf_err(bus, "Still in IRQ (processing) !!!\n");
 
-	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT, status);
+	status = brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->mailboxint);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->mailboxint, status);
 
 	devinfo->irq_allocated = false;
 }
@@ -960,7 +1031,7 @@ static int brcmf_pcie_ring_mb_ring_bell(void *ctx)
 
 	brcmf_dbg(PCIE, "RING !\n");
 	/* Any arbitrary value will do, lets use 1 */
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0, 1);
+	brcmf_pcie_write_reg32(devinfo, devinfo->reginfo->h2d_mailbox_0, 1);
 
 	return 0;
 }
@@ -1723,15 +1794,22 @@ static int brcmf_pcie_buscoreprep(void *ctx)
 static int brcmf_pcie_buscore_reset(void *ctx, struct brcmf_chip *chip)
 {
 	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)ctx;
-	u32 val;
+	struct brcmf_core *core;
+	u32 val, reg;
 
 	devinfo->ci = chip;
 	brcmf_pcie_reset_device(devinfo);
 
-	val = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
+	/* reginfo is not ready yet */
+	core = brcmf_chip_get_core(chip, BCMA_CORE_PCIE2);
+	if (core->rev >= 64)
+		reg = BRCMF_PCIE_64_PCIE2REG_MAILBOXINT;
+	else
+		reg = BRCMF_PCIE_PCIE2REG_MAILBOXINT;
+
+	val = brcmf_pcie_read_reg32(devinfo, reg);
 	if (val != 0xffffffff)
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
-				       val);
+		brcmf_pcie_write_reg32(devinfo, reg, val);
 
 	return 0;
 }
@@ -2118,6 +2196,7 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct brcmf_fw_request *fwreq;
 	struct brcmf_pciedev_info *devinfo;
 	struct brcmf_pciedev *pcie_bus_dev;
+	struct brcmf_core *core;
 	struct brcmf_bus *bus;
 
 	brcmf_dbg(PCIE, "Enter %x:%x\n", pdev->vendor, pdev->device);
@@ -2137,6 +2216,12 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto fail;
 	}
 
+	core = brcmf_chip_get_core(devinfo->ci, BCMA_CORE_PCIE2);
+	if (core->rev >= 64)
+		devinfo->reginfo = &brcmf_reginfo_64;
+	else
+		devinfo->reginfo = &brcmf_reginfo_default;
+
 	pcie_bus_dev = kzalloc(sizeof(*pcie_bus_dev), GFP_KERNEL);
 	if (pcie_bus_dev == NULL) {
 		ret = -ENOMEM;
@@ -2306,7 +2391,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 	brcmf_dbg(PCIE, "Enter, dev=%p, bus=%p\n", dev, bus);
 
 	/* Check if device is still up and running, if so we are ready */
-	if (brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_INTMASK) != 0) {
+	if (brcmf_pcie_read_reg32(devinfo, devinfo->reginfo->intmask) != 0) {
 		brcmf_dbg(PCIE, "Try to wakeup device....\n");
 		if (brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D0_INFORM))
 			goto cleanup;
-- 
2.30.2

