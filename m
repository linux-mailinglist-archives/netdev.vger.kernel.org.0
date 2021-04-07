Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433F535604F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245747AbhDGA2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245516AbhDGA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:28:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE9DD613C6;
        Wed,  7 Apr 2021 00:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617755320;
        bh=hlhCHzpkhxsG7Vys0zeoplTxSnI85eVAIE4mIRQpDOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nk/SXYWP1P4n90IxJYhYT1fgYqzdNf9TwCMLwlOU9yOipSIxH8LA6aO1OVu0uFPpA
         wUJbgkJsEia8YLdrfZb1CUVP13X8IFX1VTFEMXrQwtAxAOsj+jM3ArjF9Tds2PegjB
         Hu3M49WTS+6IkQDFGEMLNmbUnX63CdMAhCLSjjucwJrfh+XALZCCW+7yn6vPDvlqL8
         4iX3O20MMYwo32LKombc/wPk9KX8TqnyetRdfPrVHlGN5sBE2rRRussXogniKxBahl
         GtUNehdSit0ETKKZDCeeHnOTwL3Hw2QlS5VAzpn7t+33OKtxo4FJHbzOrrci1CQ0Td
         w/XdLargtCpIA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] ethtool: fix kdoc in headers
Date:   Tue,  6 Apr 2021 17:28:27 -0700
Message-Id: <20210407002827.1861191-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407002827.1861191-1-kuba@kernel.org>
References: <20210407002827.1861191-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix remaining issues with kdoc in the ethtool headers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h      | 9 +++++++--
 include/uapi/linux/ethtool.h | 6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a2b1a21ee7fd..7c88dfff7420 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -290,6 +290,9 @@ struct ethtool_pause_stats {
  *	do not attach ext_substate attribute to netlink message). If link_ext_state
  *	and link_ext_substate are unknown, return -ENODATA. If not implemented,
  *	link_ext_state and link_ext_substate will not be sent to userspace.
+ * @get_eeprom_len: Read range of EEPROM addresses for validation of
+ *	@get_eeprom and @set_eeprom requests.
+ *	Returns 0 if device does not support EEPROM access.
  * @get_eeprom: Read data from the device EEPROM.
  *	Should fill in the magic field.  Don't need to check len for zero
  *	or wraparound.  Fill in the data argument with the eeprom values
@@ -382,6 +385,8 @@ struct ethtool_pause_stats {
  * @get_module_eeprom: Get the eeprom information from the plug-in module
  * @get_eee: Get Energy-Efficient (EEE) supported and status.
  * @set_eee: Set EEE status (enable/disable) as well as LPI timers.
+ * @get_tunable: Read the value of a driver / device tunable.
+ * @set_tunable: Set the value of a driver / device tunable.
  * @get_per_queue_coalesce: Get interrupt coalescing parameters per queue.
  *	It must check that the given queue number is valid. If neither a RX nor
  *	a TX queue has this number, return -EINVAL. If only a RX queue or a TX
@@ -545,8 +550,8 @@ struct phy_tdr_config;
  * @get_sset_count: Get number of strings that @get_strings will write.
  * @get_strings: Return a set of strings that describe the requested objects
  * @get_stats: Return extended statistics about the PHY device.
- * @start_cable_test - Start a cable test
- * @start_cable_test_tdr - Start a Time Domain Reflectometry cable test
+ * @start_cable_test: Start a cable test
+ * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
  *
  * All operations are optional (i.e. the function pointer may be set to %NULL)
  * and callers must take this into account. Callers must hold the RTNL lock.
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index c9c18e88c215..5afea692a3f7 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -659,6 +659,7 @@ enum ethtool_link_ext_substate_cable_issue {
  *	now deprecated
  * @ETH_SS_FEATURES: Device feature names
  * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
+ * @ETH_SS_TUNABLES: tunable names
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
  * @ETH_SS_LINK_MODES: link mode names
@@ -668,6 +669,8 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
+ *
+ * @ETH_SS_COUNT: number of defined string sets
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -1962,8 +1965,11 @@ enum ethtool_reset_flags {
  *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  * @transceiver: Used to distinguish different possible PHY types,
  *	reported consistently by PHYLIB.  Read-only.
+ * @master_slave_cfg: Master/slave port mode.
+ * @master_slave_state: Master/slave port state.
  * @reserved: Reserved for future use; see the note on reserved space.
  * @reserved1: Reserved for future use; see the note on reserved space.
+ * @link_mode_masks: Variable length bitmaps.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
  * fixed link mode and are writable if the driver supports multiple
-- 
2.30.2

