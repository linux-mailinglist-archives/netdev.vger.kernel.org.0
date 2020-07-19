Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6088E22518A
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 13:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgGSLLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 07:11:35 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:41678 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgGSLLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 07:11:35 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id EC2B5BC053;
        Sun, 19 Jul 2020 11:11:30 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     Larry.Finger@lwfinger.net, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] b43legacy: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 13:11:24 +0200
Message-Id: <20200719111124.58167-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 drivers/net/wireless/broadcom/b43legacy/main.c  | 8 ++++----
 drivers/net/wireless/broadcom/b43legacy/phy.c   | 8 ++++----
 drivers/net/wireless/broadcom/b43legacy/radio.c | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 5208a39fd6f7..177a5d85915f 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -591,7 +591,7 @@ static void b43legacy_synchronize_irq(struct b43legacy_wldev *dev)
 }
 
 /* DummyTransmission function, as documented on
- * http://bcm-specs.sipsolutions.net/DummyTransmission
+ * https://bcm-specs.sipsolutions.net/DummyTransmission
  */
 void b43legacy_dummy_transmission(struct b43legacy_wldev *dev)
 {
@@ -1870,7 +1870,7 @@ static int b43legacy_upload_initvals(struct b43legacy_wldev *dev)
 }
 
 /* Initialize the GPIOs
- * http://bcm-specs.sipsolutions.net/GPIO
+ * https://bcm-specs.sipsolutions.net/GPIO
  */
 static int b43legacy_gpio_init(struct b43legacy_wldev *dev)
 {
@@ -1960,7 +1960,7 @@ void b43legacy_mac_enable(struct b43legacy_wldev *dev)
 	}
 }
 
-/* http://bcm-specs.sipsolutions.net/SuspendMAC */
+/* https://bcm-specs.sipsolutions.net/SuspendMAC */
 void b43legacy_mac_suspend(struct b43legacy_wldev *dev)
 {
 	int i;
@@ -2141,7 +2141,7 @@ static void b43legacy_chip_exit(struct b43legacy_wldev *dev)
 }
 
 /* Initialize the chip
- * http://bcm-specs.sipsolutions.net/ChipInit
+ * https://bcm-specs.sipsolutions.net/ChipInit
  */
 static int b43legacy_chip_init(struct b43legacy_wldev *dev)
 {
diff --git a/drivers/net/wireless/broadcom/b43legacy/phy.c b/drivers/net/wireless/broadcom/b43legacy/phy.c
index a659259bc51a..05404fbd1e70 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.c
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.c
@@ -129,7 +129,7 @@ void b43legacy_phy_calibrate(struct b43legacy_wldev *dev)
 }
 
 /* initialize B PHY power control
- * as described in http://bcm-specs.sipsolutions.net/InitPowerControl
+ * as described in https://bcm-specs.sipsolutions.net/InitPowerControl
  */
 static void b43legacy_phy_init_pctl(struct b43legacy_wldev *dev)
 {
@@ -1461,7 +1461,7 @@ void b43legacy_phy_set_baseband_attenuation(struct b43legacy_wldev *dev,
 	b43legacy_phy_write(dev, 0x0060, value);
 }
 
-/* http://bcm-specs.sipsolutions.net/LocalOscillator/Measure */
+/* https://bcm-specs.sipsolutions.net/LocalOscillator/Measure */
 void b43legacy_phy_lo_g_measure(struct b43legacy_wldev *dev)
 {
 	static const u8 pairorder[10] = { 3, 1, 5, 7, 9, 2, 0, 4, 6, 8 };
@@ -1721,7 +1721,7 @@ void b43legacy_phy_lo_mark_all_unused(struct b43legacy_wldev *dev)
 	}
 }
 
-/* http://bcm-specs.sipsolutions.net/EstimatePowerOut
+/* https://bcm-specs.sipsolutions.net/EstimatePowerOut
  * This function converts a TSSI value to dBm in Q5.2
  */
 static s8 b43legacy_phy_estimate_power_out(struct b43legacy_wldev *dev, s8 tssi)
@@ -1747,7 +1747,7 @@ static s8 b43legacy_phy_estimate_power_out(struct b43legacy_wldev *dev, s8 tssi)
 	return dbm;
 }
 
-/* http://bcm-specs.sipsolutions.net/RecalculateTransmissionPower */
+/* https://bcm-specs.sipsolutions.net/RecalculateTransmissionPower */
 void b43legacy_phy_xmitpower(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_phy *phy = &dev->phy;
diff --git a/drivers/net/wireless/broadcom/b43legacy/radio.c b/drivers/net/wireless/broadcom/b43legacy/radio.c
index da40d1ca8723..06891b4f837b 100644
--- a/drivers/net/wireless/broadcom/b43legacy/radio.c
+++ b/drivers/net/wireless/broadcom/b43legacy/radio.c
@@ -313,14 +313,14 @@ u8 b43legacy_radio_aci_scan(struct b43legacy_wldev *dev)
 	return ret[channel - 1];
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 void b43legacy_nrssi_hw_write(struct b43legacy_wldev *dev, u16 offset, s16 val)
 {
 	b43legacy_phy_write(dev, B43legacy_PHY_NRSSILT_CTRL, offset);
 	b43legacy_phy_write(dev, B43legacy_PHY_NRSSILT_DATA, (u16)val);
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 s16 b43legacy_nrssi_hw_read(struct b43legacy_wldev *dev, u16 offset)
 {
 	u16 val;
@@ -331,7 +331,7 @@ s16 b43legacy_nrssi_hw_read(struct b43legacy_wldev *dev, u16 offset)
 	return (s16)val;
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 void b43legacy_nrssi_hw_update(struct b43legacy_wldev *dev, u16 val)
 {
 	u16 i;
@@ -345,7 +345,7 @@ void b43legacy_nrssi_hw_update(struct b43legacy_wldev *dev, u16 val)
 	}
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 void b43legacy_nrssi_mem_update(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_phy *phy = &dev->phy;
-- 
2.27.0

