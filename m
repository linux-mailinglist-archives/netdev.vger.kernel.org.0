Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED01225172
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 13:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgGSLBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 07:01:30 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:39392 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGSLB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 07:01:29 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 3B60FBC063;
        Sun, 19 Jul 2020 11:01:21 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        saurav.girepunje@gmail.com, Larry.Finger@lwfinger.net,
        yanaijie@huawei.com, masahiroy@kernel.org,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] b43: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 13:01:15 +0200
Message-Id: <20200719110115.58085-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spam: Yes
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


 drivers/net/wireless/broadcom/b43/main.c      |  14 +-
 .../net/wireless/broadcom/b43/phy_common.c    |   2 +-
 drivers/net/wireless/broadcom/b43/phy_g.c     |  12 +-
 drivers/net/wireless/broadcom/b43/phy_ht.c    |   2 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c    |   2 +-
 drivers/net/wireless/broadcom/b43/phy_n.c     | 150 +++++++++---------
 .../net/wireless/broadcom/b43/radio_2056.c    |   2 +-
 .../net/wireless/broadcom/b43/tables_nphy.c   |   4 +-
 drivers/net/wireless/intersil/orinoco/Kconfig |   4 +-
 9 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 3ad94dad2d89..6efbc9ed7fe7 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -734,7 +734,7 @@ static void b43_short_slot_timing_disable(struct b43_wldev *dev)
 }
 
 /* DummyTransmission function, as documented on
- * http://bcm-v4.sipsolutions.net/802.11/DummyTransmission
+ * https://bcm-v4.sipsolutions.net/802.11/DummyTransmission
  */
 void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 {
@@ -1198,7 +1198,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacCorePllReset */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/BmacCorePllReset */
 void b43_wireless_core_phy_pll_reset(struct b43_wldev *dev)
 {
 	struct bcma_drv_cc *bcma_cc __maybe_unused;
@@ -2290,7 +2290,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 	return -EPROTO;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/Init/Firmware */
+/* https://bcm-v4.sipsolutions.net/802.11/Init/Firmware */
 static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 {
 	struct b43_wldev *dev = ctx->dev;
@@ -2843,7 +2843,7 @@ static int b43_upload_initvals_band(struct b43_wldev *dev)
 }
 
 /* Initialize the GPIOs
- * http://bcm-specs.sipsolutions.net/GPIO
+ * https://bcm-specs.sipsolutions.net/GPIO
  */
 
 #ifdef CONFIG_B43_SSB
@@ -2971,7 +2971,7 @@ void b43_mac_enable(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-specs.sipsolutions.net/SuspendMAC */
+/* https://bcm-specs.sipsolutions.net/SuspendMAC */
 void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
@@ -3004,7 +3004,7 @@ void b43_mac_suspend(struct b43_wldev *dev)
 	dev->mac_suspended++;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
 void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 {
 	u32 tmp;
@@ -3231,7 +3231,7 @@ static void b43_chip_exit(struct b43_wldev *dev)
 }
 
 /* Initialize the chip
- * http://bcm-specs.sipsolutions.net/ChipInit
+ * https://bcm-specs.sipsolutions.net/ChipInit
  */
 static int b43_chip_init(struct b43_wldev *dev)
 {
diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
index 923d4cb9fc30..1de4de094d61 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.c
+++ b/drivers/net/wireless/broadcom/b43/phy_common.c
@@ -559,7 +559,7 @@ bool b43_is_40mhz(struct b43_wldev *dev)
 	return dev->phy.chandef->width == NL80211_CHAN_WIDTH_40;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
 void b43_phy_force_clock(struct b43_wldev *dev, bool force)
 {
 	u32 tmp;
diff --git a/drivers/net/wireless/broadcom/b43/phy_g.c b/drivers/net/wireless/broadcom/b43/phy_g.c
index 1e022ec733a3..d5a1a5c58236 100644
--- a/drivers/net/wireless/broadcom/b43/phy_g.c
+++ b/drivers/net/wireless/broadcom/b43/phy_g.c
@@ -357,14 +357,14 @@ static void b43_set_original_gains(struct b43_wldev *dev)
 	b43_dummy_transmission(dev, false, true);
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 static void b43_nrssi_hw_write(struct b43_wldev *dev, u16 offset, s16 val)
 {
 	b43_phy_write(dev, B43_PHY_NRSSILT_CTRL, offset);
 	b43_phy_write(dev, B43_PHY_NRSSILT_DATA, (u16) val);
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 static s16 b43_nrssi_hw_read(struct b43_wldev *dev, u16 offset)
 {
 	u16 val;
@@ -375,7 +375,7 @@ static s16 b43_nrssi_hw_read(struct b43_wldev *dev, u16 offset)
 	return (s16) val;
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 static void b43_nrssi_hw_update(struct b43_wldev *dev, u16 val)
 {
 	u16 i;
@@ -389,7 +389,7 @@ static void b43_nrssi_hw_update(struct b43_wldev *dev, u16 val)
 	}
 }
 
-/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
+/* https://bcm-specs.sipsolutions.net/NRSSILookupTable */
 static void b43_nrssi_mem_update(struct b43_wldev *dev)
 {
 	struct b43_phy_g *gphy = dev->phy.g;
@@ -1575,7 +1575,7 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 	b43_write16(dev, 0x03E4, (b43_read16(dev, 0x03E4) & 0xFFC0) | 0x0004);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/Init/B6 */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/Init/B6 */
 static void b43_phy_initb6(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -2746,7 +2746,7 @@ static int b43_gphy_op_interf_mitigation(struct b43_wldev *dev,
 	return 0;
 }
 
-/* http://bcm-specs.sipsolutions.net/EstimatePowerOut
+/* https://bcm-specs.sipsolutions.net/EstimatePowerOut
  * This function converts a TSSI value to dBm in Q5.2
  */
 static s8 b43_gphy_estimate_power_out(struct b43_wldev *dev, s8 tssi)
diff --git a/drivers/net/wireless/broadcom/b43/phy_ht.c b/drivers/net/wireless/broadcom/b43/phy_ht.c
index 6033df1c3053..c685b4bb5ed6 100644
--- a/drivers/net/wireless/broadcom/b43/phy_ht.c
+++ b/drivers/net/wireless/broadcom/b43/phy_ht.c
@@ -1018,7 +1018,7 @@ static void b43_phy_ht_op_free(struct b43_wldev *dev)
 	phy->ht = NULL;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/Radio/Switch%20Radio */
+/* https://bcm-v4.sipsolutions.net/802.11/Radio/Switch%20Radio */
 static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
 {
diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
index cfb953d61dc5..0e5c076e7544 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lp.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
@@ -70,7 +70,7 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
 	dev->phy.lp = NULL;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/LP/ReadBandSrom */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/LP/ReadBandSrom */
 static void lpphy_read_band_sprom(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index c33b4235839d..8d8ae912ace4 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -98,7 +98,7 @@ static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 		(dev->phy.n->ipa5g_on && band == NL80211_BAND_5GHZ));
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreGetState */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreGetState */
 static u8 b43_nphy_get_rx_core_state(struct b43_wldev *dev)
 {
 	return (b43_phy_read(dev, B43_NPHY_RFSEQCA) & B43_NPHY_RFSEQCA_RXEN) >>
@@ -109,7 +109,7 @@ static u8 b43_nphy_get_rx_core_state(struct b43_wldev *dev)
  * RF (just without b43_nphy_rf_ctl_intc_override)
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ForceRFSeq */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/ForceRFSeq */
 static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
 				       enum b43_nphy_rf_sequence seq)
 {
@@ -146,7 +146,7 @@ static void b43_nphy_rf_ctl_override_rev19(struct b43_wldev *dev, u16 field,
 	/* TODO */
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverrideRev7 */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverrideRev7 */
 static void b43_nphy_rf_ctl_override_rev7(struct b43_wldev *dev, u16 field,
 					  u16 value, u8 core, bool off,
 					  u8 override)
@@ -193,7 +193,7 @@ static void b43_nphy_rf_ctl_override_rev7(struct b43_wldev *dev, u16 field,
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverideOneToMany */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverideOneToMany */
 static void b43_nphy_rf_ctl_override_one_to_many(struct b43_wldev *dev,
 						 enum n_rf_ctl_over_cmd cmd,
 						 u16 value, u8 core, bool off)
@@ -237,7 +237,7 @@ static void b43_nphy_rf_ctl_override_one_to_many(struct b43_wldev *dev,
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
 static void b43_nphy_rf_ctl_override(struct b43_wldev *dev, u16 field,
 				     u16 value, u8 core, bool off)
 {
@@ -382,7 +382,7 @@ static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlIntcOverride */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlIntcOverride */
 static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
 					  enum n_intc_override intc_override,
 					  u16 value, u8 core)
@@ -490,7 +490,7 @@ static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
  * Various PHY ops
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
 static void b43_nphy_write_clip_detection(struct b43_wldev *dev,
 					  const u16 *clip_st)
 {
@@ -498,14 +498,14 @@ static void b43_nphy_write_clip_detection(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, clip_st[1]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
 static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
 {
 	clip_st[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
 	clip_st[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/classifier */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/classifier */
 static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 {
 	u16 tmp;
@@ -526,7 +526,7 @@ static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 	return tmp;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
 static void b43_nphy_reset_cca(struct b43_wldev *dev)
 {
 	u16 bbcfg;
@@ -540,7 +540,7 @@ static void b43_nphy_reset_cca(struct b43_wldev *dev)
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/carriersearch */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/carriersearch */
 static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -564,7 +564,7 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/PHY/N/Read_Lpf_Bw_Ctl */
+/* https://bcm-v4.sipsolutions.net/PHY/N/Read_Lpf_Bw_Ctl */
 static u16 b43_nphy_read_lpf_ctl(struct b43_wldev *dev, u16 offset)
 {
 	if (!offset)
@@ -572,7 +572,7 @@ static u16 b43_nphy_read_lpf_ctl(struct b43_wldev *dev, u16 offset)
 	return b43_ntab_read(dev, B43_NTAB16(7, offset)) & 0x7;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/AdjustLnaGainTbl */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/AdjustLnaGainTbl */
 static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -628,7 +628,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRfSeq */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRfSeq */
 static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
 					u8 *events, u8 *delays, u8 length)
 {
@@ -805,7 +805,7 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 }
 
 /* Calibrate resistors in LPF of PLL?
- * http://bcm-v4.sipsolutions.net/PHY/radio205x_rcal
+ * https://bcm-v4.sipsolutions.net/PHY/radio205x_rcal
  */
 static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 {
@@ -919,7 +919,7 @@ static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 }
 
 /* Calibrate the internal RC oscillator?
- * http://bcm-v4.sipsolutions.net/PHY/radio2057_rccal
+ * https://bcm-v4.sipsolutions.net/PHY/radio2057_rccal
  */
 static u16 b43_radio_2057_rccal(struct b43_wldev *dev)
 {
@@ -1030,7 +1030,7 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
 	b43_radio_mask(dev, R2057_RFPLL_MASTER, ~0x8);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/Radio/2057/Init */
+/* https://bcm-v4.sipsolutions.net/802.11/Radio/2057/Init */
 static void b43_radio_2057_init(struct b43_wldev *dev)
 {
 	b43_radio_2057_init_pre(dev);
@@ -1117,7 +1117,7 @@ static void b43_chantab_radio_2056_upload(struct b43_wldev *dev,
 					e->radio_tx1_mixg_boost_tune);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2056Setup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2056Setup */
 static void b43_radio_2056_setup(struct b43_wldev *dev,
 				const struct b43_nphy_channeltab_entry_rev3 *e)
 {
@@ -1356,7 +1356,7 @@ static void b43_radio_init2056_post(struct b43_wldev *dev)
 
 /*
  * Initialize a Broadcom 2056 N-radio
- * http://bcm-v4.sipsolutions.net/802.11/Radio/2056/Init
+ * https://bcm-v4.sipsolutions.net/802.11/Radio/2056/Init
  */
 static void b43_radio_init2056(struct b43_wldev *dev)
 {
@@ -1406,7 +1406,7 @@ static void b43_chantab_radio_upload(struct b43_wldev *dev,
 	b43_radio_write(dev, B2055_C2_TX_MXBGTRIM, e->radio_c2_tx_mxbgtrim);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
 static void b43_radio_2055_setup(struct b43_wldev *dev,
 				const struct b43_nphy_channeltab_entry_rev2 *e)
 {
@@ -1480,7 +1480,7 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 
 /*
  * Initialize a Broadcom 2055 N-radio
- * http://bcm-v4.sipsolutions.net/802.11/Radio/2055/Init
+ * https://bcm-v4.sipsolutions.net/802.11/Radio/2055/Init
  */
 static void b43_radio_init2055(struct b43_wldev *dev)
 {
@@ -1499,7 +1499,7 @@ static void b43_radio_init2055(struct b43_wldev *dev)
  * Samples
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
 static int b43_nphy_load_samples(struct b43_wldev *dev,
 					struct cordic_iq *samples, u16 len) {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -1526,7 +1526,7 @@ static int b43_nphy_load_samples(struct b43_wldev *dev,
 	return 0;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
 static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 					bool test)
 {
@@ -1569,7 +1569,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 	return (i < 0) ? 0 : len;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
 static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 				 u16 wait, bool iqmode, bool dac_test,
 				 bool modify_bbmult)
@@ -1650,7 +1650,7 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
  * RSSI
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ScaleOffsetRssi */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/ScaleOffsetRssi */
 static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
 					s8 offset, u8 core,
 					enum n_rail_type rail,
@@ -1895,7 +1895,7 @@ static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code,
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
 static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code,
 				 enum n_rssi_type type)
 {
@@ -1907,7 +1907,7 @@ static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code,
 		b43_nphy_rev2_rssi_select(dev, code, type);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
 static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev,
 				       enum n_rssi_type rssi_type, u8 *buf)
 {
@@ -1936,7 +1936,7 @@ static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev,
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PollRssi */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/PollRssi */
 static int b43_nphy_poll_rssi(struct b43_wldev *dev, enum n_rssi_type rssi_type,
 			      s32 *buf, u8 nsamp)
 {
@@ -2025,7 +2025,7 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, enum n_rssi_type rssi_type,
 	return out;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
 static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -2287,7 +2287,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	b43_nphy_write_clip_detection(dev, clip_state);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
 static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, enum n_rssi_type type)
 {
 	int i, j, vcm;
@@ -2453,7 +2453,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, enum n_rssi_type type)
 
 /*
  * RSSI Calibration
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal
+ * https://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal
  */
 static void b43_nphy_rssi_cal(struct b43_wldev *dev)
 {
@@ -2680,7 +2680,7 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_PHY_N(0xC5D), 0xFF80, 4);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
 static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
 {
 	if (dev->phy.rev >= 19)
@@ -3433,7 +3433,7 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 				B43_NPHY_FINERX2_CGC_DECGC);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
 static void b43_nphy_workarounds(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3468,7 +3468,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 
 /*
  * Transmits a known value for LO calibration
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
+ * https://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
  */
 static int b43_nphy_tx_tone(struct b43_wldev *dev, u32 freq, u16 max_val,
 			    bool iqmode, bool dac_test, bool modify_bbmult)
@@ -3481,7 +3481,7 @@ static int b43_nphy_tx_tone(struct b43_wldev *dev, u32 freq, u16 max_val,
 	return 0;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Chains */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/Chains */
 static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -3509,7 +3509,7 @@ static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
 				~B43_NPHY_RFSEQMODE_CAOVER);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
 static void b43_nphy_stop_playback(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3546,7 +3546,7 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
 static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
 					struct nphy_txgains target,
 					struct nphy_iqcal_params *params)
@@ -3595,7 +3595,7 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
  * Tx and Rx
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlEnable */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlEnable */
 static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3732,7 +3732,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrFix */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrFix */
 static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3926,7 +3926,7 @@ static void b43_nphy_ipa_internal_tssi_setup(struct b43_wldev *dev)
 /*
  * Stop radio and transmit known signal. Then check received signal strength to
  * get TSSI (Transmit Signal Strength Indicator).
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlIdleTssi
+ * https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlIdleTssi
  */
 static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 {
@@ -3978,7 +3978,7 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	nphy->pwr_ctl_info[1].idle_tssi_2g = (tmp >> 8) & 0xFF;
 }
 
-/* http://bcm-v4.sipsolutions.net/PHY/N/TxPwrLimitToTbl */
+/* https://bcm-v4.sipsolutions.net/PHY/N/TxPwrLimitToTbl */
 static void b43_nphy_tx_prepare_adjusted_power_table(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -4039,7 +4039,7 @@ static void b43_nphy_tx_prepare_adjusted_power_table(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlSetup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlSetup */
 static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -4272,7 +4272,7 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PA%20override */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/PA%20override */
 static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -4310,7 +4310,7 @@ static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 
 /*
  * TX low-pass filter bandwidth setup
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw
+ * https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw
  */
 static void b43_nphy_tx_lpf_bw(struct b43_wldev *dev)
 {
@@ -4333,7 +4333,7 @@ static void b43_nphy_tx_lpf_bw(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqEst */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqEst */
 static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
 				u16 samps, u8 time, bool wait)
 {
@@ -4372,7 +4372,7 @@ static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
 	memset(est, 0, sizeof(*est));
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqCoeffs */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqCoeffs */
 static void b43_nphy_rx_iq_coeffs(struct b43_wldev *dev, bool write,
 					struct b43_phy_n_iq_comp *pcomp)
 {
@@ -4391,7 +4391,7 @@ static void b43_nphy_rx_iq_coeffs(struct b43_wldev *dev, bool write,
 
 #if 0
 /* Ready but not used anywhere */
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCalPhyCleanup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCalPhyCleanup */
 static void b43_nphy_rx_cal_phy_cleanup(struct b43_wldev *dev, u8 core)
 {
 	u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
@@ -4414,7 +4414,7 @@ static void b43_nphy_rx_cal_phy_cleanup(struct b43_wldev *dev, u8 core)
 	b43_phy_write(dev, B43_NPHY_PAPD_EN1, regs[10]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCalPhySetup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCalPhySetup */
 static void b43_nphy_rx_cal_phy_setup(struct b43_wldev *dev, u8 core)
 {
 	u8 rxval, txval;
@@ -4476,7 +4476,7 @@ static void b43_nphy_rx_cal_phy_setup(struct b43_wldev *dev, u8 core)
 }
 #endif
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalcRxIqComp */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/CalcRxIqComp */
 static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
 {
 	int i;
@@ -4574,7 +4574,7 @@ static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
 	b43_nphy_rx_iq_coeffs(dev, true, &new);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxIqWar */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxIqWar */
 static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
 {
 	u16 array[4];
@@ -4586,7 +4586,7 @@ static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SpurWar */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SpurWar */
 static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -4645,7 +4645,7 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
 static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -4713,7 +4713,7 @@ static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 
 /*
  * Restore RSSI Calibration
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreRssiCal
+ * https://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreRssiCal
  */
 static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 {
@@ -4822,7 +4822,7 @@ static void b43_nphy_tx_cal_radio_setup_rev7(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
 static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -4921,7 +4921,7 @@ static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/UpdateTxCalLadder */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/UpdateTxCalLadder */
 static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -4955,14 +4955,14 @@ static void b43_nphy_pa_set_tx_dig_filter(struct b43_wldev *dev, u16 offset,
 		b43_phy_write(dev, offset, filter[i]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ExtPaSetTxDigiFilts */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/ExtPaSetTxDigiFilts */
 static void b43_nphy_ext_pa_set_tx_dig_filters(struct b43_wldev *dev)
 {
 	b43_nphy_pa_set_tx_dig_filter(dev, 0x2C5,
 				      tbl_tx_filter_coef_rev4[2]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IpaSetTxDigiFilts */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/IpaSetTxDigiFilts */
 static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
 {
 	/* B43_NPHY_TXF_20CO_S0A1, B43_NPHY_TXF_40CO_S0A1, unknown */
@@ -5002,7 +5002,7 @@ static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
 static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -5077,7 +5077,7 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 	return target;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhyCleanup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhyCleanup */
 static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
 {
 	u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
@@ -5106,7 +5106,7 @@ static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhySetup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhySetup */
 static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -5207,7 +5207,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SaveCal */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SaveCal */
 static void b43_nphy_save_cal(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -5278,7 +5278,7 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal */
 static void b43_nphy_restore_cal(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -5366,7 +5366,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	b43_nphy_rx_iq_coeffs(dev, true, rxcal_coeffs);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalTxIqlo */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/CalTxIqlo */
 static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 				struct nphy_txgains target,
 				bool full, bool mphase)
@@ -5599,7 +5599,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 	return error;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ReapplyTxCalCoeffs */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/ReapplyTxCalCoeffs */
 static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -5634,7 +5634,7 @@ static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIqRev2 */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIqRev2 */
 static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 			struct nphy_txgains target, u8 type, bool debug)
 {
@@ -5821,7 +5821,7 @@ static int b43_nphy_rev3_cal_rx_iq(struct b43_wldev *dev,
 	return -1;
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIq */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIq */
 static int b43_nphy_cal_rx_iq(struct b43_wldev *dev,
 			struct nphy_txgains target, u8 type, bool debug)
 {
@@ -5834,7 +5834,7 @@ static int b43_nphy_cal_rx_iq(struct b43_wldev *dev,
 		return b43_nphy_rev2_cal_rx_iq(dev, target, type, debug);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreSetState */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreSetState */
 static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -5939,7 +5939,7 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
  * N-PHY init
  **************************************************/
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
 static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
 {
 	u16 mimocfg = b43_phy_read(dev, B43_NPHY_MIMOCFG);
@@ -5953,7 +5953,7 @@ static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
 	b43_phy_write(dev, B43_NPHY_MIMOCFG, mimocfg);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
 static void b43_nphy_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -5972,7 +5972,7 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SuperSwitchInit */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SuperSwitchInit */
 static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 {
 	if (dev->phy.rev >= 7)
@@ -6246,7 +6246,7 @@ static void b43_chantab_phy_upload(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
+/* https://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
 static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 {
 	switch (dev->dev->bus_type) {
@@ -6265,7 +6265,7 @@ static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
 static void b43_nphy_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_n_sfo_cfg *e,
 				struct ieee80211_channel *new_channel)
@@ -6372,7 +6372,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 		b43_nphy_spur_workaround(dev);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetChanspec */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/SetChanspec */
 static int b43_nphy_set_channel(struct b43_wldev *dev,
 				struct ieee80211_channel *channel,
 				enum nl80211_channel_type channel_type)
@@ -6589,7 +6589,7 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/Radio/Switch%20Radio */
+/* https://bcm-v4.sipsolutions.net/802.11/Radio/Switch%20Radio */
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
 {
@@ -6643,7 +6643,7 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/Anacore */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/Anacore */
 static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
 {
 	struct b43_phy *phy = &dev->phy;
diff --git a/drivers/net/wireless/broadcom/b43/radio_2056.c b/drivers/net/wireless/broadcom/b43/radio_2056.c
index 575c696b7cdf..94f5e626acba 100644
--- a/drivers/net/wireless/broadcom/b43/radio_2056.c
+++ b/drivers/net/wireless/broadcom/b43/radio_2056.c
@@ -3072,7 +3072,7 @@ INITTABSPTS(b2056_inittab_radio_rev11);
 	.phy_regs.phy_bw5	= r4,	\
 	.phy_regs.phy_bw6	= r5
 
-/* http://bcm-v4.sipsolutions.net/802.11/Radio/2056/ChannelTable */
+/* https://bcm-v4.sipsolutions.net/802.11/Radio/2056/ChannelTable */
 static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_phy_rev3[] = {
   {	.freq			= 4920,
 	RADIOREGS3(0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04,
diff --git a/drivers/net/wireless/broadcom/b43/tables_nphy.c b/drivers/net/wireless/broadcom/b43/tables_nphy.c
index dad405abf9b1..7957db94e84c 100644
--- a/drivers/net/wireless/broadcom/b43/tables_nphy.c
+++ b/drivers/net/wireless/broadcom/b43/tables_nphy.c
@@ -3620,7 +3620,7 @@ static void b43_nphy_tables_init_rev0(struct b43_wldev *dev)
 	ntab_upload(dev, B43_NTAB_C1_LOFEEDTH, b43_ntab_loftlt1);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables */
 void b43_nphy_tables_init(struct b43_wldev *dev)
 {
 	if (dev->phy.rev >= 16)
@@ -3633,7 +3633,7 @@ void b43_nphy_tables_init(struct b43_wldev *dev)
 		b43_nphy_tables_init_rev0(dev);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
+/* https://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
 static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
diff --git a/drivers/net/wireless/intersil/orinoco/Kconfig b/drivers/net/wireless/intersil/orinoco/Kconfig
index c470ee23673f..f62730aa7be3 100644
--- a/drivers/net/wireless/intersil/orinoco/Kconfig
+++ b/drivers/net/wireless/intersil/orinoco/Kconfig
@@ -27,7 +27,7 @@ config HERMES
 
 	  You will also very likely also need the Wireless Tools in order to
 	  configure your card and that /etc/pcmcia/wireless.opts works :
-	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>
+	  <https://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>
 
 config HERMES_PRISM
 	bool "Support Prism 2/2.5 chipset"
@@ -120,7 +120,7 @@ config PCMCIA_HERMES
 
 	  You will very likely need the Wireless Tools in order to
 	  configure your card and that /etc/pcmcia/wireless.opts works:
-	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <https://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
 config PCMCIA_SPECTRUM
 	tristate "Symbol Spectrum24 Trilogy PCMCIA card support"
-- 
2.27.0

