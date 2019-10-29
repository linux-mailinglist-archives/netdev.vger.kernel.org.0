Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF0E8B1E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389566AbfJ2OqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:46:15 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:52806 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbfJ2OqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 10:46:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 4183823FA55;
        Tue, 29 Oct 2019 15:46:11 +0100 (CET)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.078
X-Spam-Level: 
X-Spam-Status: No, score=-3.078 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.178, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j4643k9o8BOZ; Tue, 29 Oct 2019 15:46:10 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 631F023F62E;
        Tue, 29 Oct 2019 15:46:09 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lars Poeschel <poeschel@lemonage.de>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>, Simon Horman <horms@verge.net.au>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v11 2/7] nfc: pn532: Add uart phy docs and rename it
Date:   Tue, 29 Oct 2019 15:45:58 +0100
Message-Id: <20191029144602.17974-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191029144320.17718-1-poeschel@lemonage.de>
References: <20191029144320.17718-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds documentation about the uart phy to the pn532 binding doc. As
the filename "pn533-i2c.txt" is not appropriate any more, rename it to
the more general "pn532.txt".
This also documents the deprecation of the compatible strings ending
with "...-i2c".

Cc: Johan Hovold <johan@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v10:
- Rebased the patch series on net-next 'Commit 503a64635d5e ("Merge
  branch 'DPAA-Ethernet-changes'")'

Changes in v9:
- Rebased the patch series on v5.4-rc2
- Produce patch with -M4 to git format-patch to detect the rename
- Change DT node name from pn532@24 to nfc@24 in example

Changes in v8:
- Update existing binding doc instead of adding a new one:
  - Add uart phy example
  - Add general "pn532" compatible string
  - Deprecate "...-i2c" compatible strings
  - Rename file to a more general filename
- Intentionally drop Rob's Reviewed-By as I guess this rather big change
  requires a new review

Changes in v7:
- Accidentally lost Rob's Reviewed-By

Changes in v6:
- Rebased the patch series on v5.3-rc5
- Picked up Rob's Reviewed-By

Changes in v4:
- Add documentation about reg property in case of i2c

Changes in v3:
- seperate binding doc instead of entry in trivial-devices.txt

 .../net/nfc/{pn533-i2c.txt => pn532.txt}      | 25 ++++++++++++++++---
 1 file changed, 21 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/net/nfc/{pn533-i2c.txt => pn532.txt} (42%)

diff --git a/Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt b/Documentation/devicetree/bindings/net/nfc/pn532.txt
similarity index 42%
rename from Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt
rename to Documentation/devicetree/bindings/net/nfc/pn532.txt
index 2efe3886b95b..a5507dc499bc 100644
--- a/Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt
+++ b/Documentation/devicetree/bindings/net/nfc/pn532.txt
@@ -1,9 +1,16 @@
 * NXP Semiconductors PN532 NFC Controller
 
 Required properties:
-- compatible: Should be "nxp,pn532-i2c" or "nxp,pn533-i2c".
+- compatible: Should be
+    - "nxp,pn532" Place a node with this inside the devicetree node of the bus
+                  where the NFC chip is connected to.
+                  Currently the kernel has phy bindings for uart and i2c.
+    - "nxp,pn532-i2c" (DEPRECATED) only works for the i2c binding.
+    - "nxp,pn533-i2c" (DEPRECATED) only works for the i2c binding.
+
+Required properties if connected on i2c:
 - clock-frequency: I²C work frequency.
-- reg: address on the bus
+- reg: for the I²C bus address. This is fixed at 0x24 for the PN532.
 - interrupts: GPIO interrupt to which the chip is connected
 
 Optional SoC Specific Properties:
@@ -15,9 +22,9 @@ Example (for ARM-based BeagleBone with PN532 on I2C2):
 &i2c2 {
 
 
-	pn532: pn532@24 {
+	pn532: nfc@24 {
 
-		compatible = "nxp,pn532-i2c";
+		compatible = "nxp,pn532";
 
 		reg = <0x24>;
 		clock-frequency = <400000>;
@@ -27,3 +34,13 @@ Example (for ARM-based BeagleBone with PN532 on I2C2):
 
 	};
 };
+
+Example (for PN532 connected via uart):
+
+uart4: serial@49042000 {
+        compatible = "ti,omap3-uart";
+
+        pn532: nfc {
+                compatible = "nxp,pn532";
+        };
+};
-- 
2.23.0

