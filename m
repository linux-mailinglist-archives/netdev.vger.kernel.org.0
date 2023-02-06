Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD51568BDBB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjBFNRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjBFNRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A06823C4E
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N2-0007VD-Dr
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:20 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3E39017142B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 24CF61712BE;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 00ae310b;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 16/47] can: ems_pci: Add Asix AX99100 definitions
Date:   Mon,  6 Feb 2023 14:15:49 +0100
Message-Id: <20230206131620.2758724-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>

Add Asix AX99100 PCI IDs and add the v3 to the ems_pci_tbl.
Add define for maximum CAN channel count

Signed-off-by: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Link: https://lore.kernel.org/all/20230120112616.6071-3-uttenthaler@ems-wuensche.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/ems_pci.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/can/sja1000/ems_pci.c b/drivers/net/can/sja1000/ems_pci.c
index c34788b9a6d5..80fa5e4c5eac 100644
--- a/drivers/net/can/sja1000/ems_pci.c
+++ b/drivers/net/can/sja1000/ems_pci.c
@@ -26,6 +26,7 @@ MODULE_LICENSE("GPL v2");
 
 #define EMS_PCI_V1_MAX_CHAN 2
 #define EMS_PCI_V2_MAX_CHAN 4
+#define EMS_PCI_V3_MAX_CHAN 4
 #define EMS_PCI_MAX_CHAN    EMS_PCI_V2_MAX_CHAN
 
 struct ems_pci_card {
@@ -61,6 +62,15 @@ struct ems_pci_card {
 #define PLX_ICSR_ENA_CLR    (PLX_ICSR_LINTI1_ENA | PLX_ICSR_PCIINT_ENA | \
 			     PLX_ICSR_LINTI1_CLR)
 
+/* Register definitions for the ASIX99100
+ */
+#define ASIX_LINTSR 0x28 /* Interrupt Control/Status register */
+#define ASIX_LINTSR_INT0AC BIT(0) /* Writing 1 enables or clears interrupt */
+
+#define ASIX_LIEMR 0x24 /* Local Interrupt Enable / Miscellaneous Register */
+#define ASIX_LIEMR_L0EINTEN BIT(16) /* Local INT0 input assertion enable */
+#define ASIX_LIEMR_LRST BIT(14) /* Local Reset assert */
+
 /* The board configuration is probably following:
  * RX1 is connected to ground.
  * TX1 is not connected.
@@ -86,6 +96,13 @@ struct ems_pci_card {
 
 #define EMS_PCI_BASE_SIZE  4096 /* size of controller area */
 
+#ifndef PCI_VENDOR_ID_ASIX
+#define PCI_VENDOR_ID_ASIX 0x125b
+#define PCI_DEVICE_ID_ASIX_9110 0x9110
+#define PCI_SUBVENDOR_ID_ASIX 0xa000
+#endif
+#define PCI_SUBDEVICE_ID_EMS 0x4010
+
 static const struct pci_device_id ems_pci_tbl[] = {
 	/* CPC-PCI v1 */
 	{PCI_VENDOR_ID_SIEMENS, 0x2104, PCI_ANY_ID, PCI_ANY_ID,},
@@ -93,6 +110,8 @@ static const struct pci_device_id ems_pci_tbl[] = {
 	{PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_PLX, 0x4000},
 	/* CPC-104P v2 */
 	{PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_PLX, 0x4002},
+	/* CPC-PCIe v3 */
+	{PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_9110, PCI_SUBVENDOR_ID_ASIX, PCI_SUBDEVICE_ID_EMS},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, ems_pci_tbl);
-- 
2.39.1


