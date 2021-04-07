Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B9735604D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245671AbhDGA2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245246AbhDGA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:28:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9263A613C2;
        Wed,  7 Apr 2021 00:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617755319;
        bh=31q9KV16XuYJp2CxPWG0O/x4WP4ZiiGiqwFnZwSdaEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TK3gBn7E0dp5r8NXZRt9COM42H4KuyNtnZS4CCpxv7M49LEYq8lXd4esrtbEywsuZ
         OOdAxM08HmuwNjmVWmOaJTik0bZun8ntAzYM9D8TV3sEC7jrEuEGShhLrWx6vOmSK8
         ZQV5T+0QSm2Ldv+yJAkuBujlFErdyELXw0dRjK6H+MOrE9nWqBvDfvdXx0a8KQLGCS
         XJjdbOx0ES2sbYDwloDUUvLz1cHpN+XBp4IQdqfJk1UqhNweAvebWeHnXOgsjXF57P
         QMV27rtLPzR6cB85Ahi60PGuEraTKm5Krj/xfWemu/IxKdGNNTH4ujFE4KWuSYTWop
         q3tbMzVhOMkww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] ethtool: document reserved fields in the uAPI
Date:   Tue,  6 Apr 2021 17:28:26 -0700
Message-Id: <20210407002827.1861191-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407002827.1861191-1-kuba@kernel.org>
References: <20210407002827.1861191-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a note on expected handling of reserved fields,
and references to all kdocs. This fixes a bunch
of kdoc warnings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dc87ba092891..c9c18e88c215 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -26,6 +26,14 @@
  * have the same layout for 32-bit and 64-bit userland.
  */
 
+/* Note on reserved space.
+ * Reserved fields must not be accessed directly by user space because
+ * they may be replaced by a different field in the future. They must
+ * be initialized to zero before making the request, e.g. via memset
+ * of the entire structure or implicitly by not being set in a structure
+ * initializer.
+ */
+
 /**
  * struct ethtool_cmd - DEPRECATED, link control and status
  * This structure is DEPRECATED, please use struct ethtool_link_settings.
@@ -67,6 +75,7 @@
  *	and other link features that the link partner advertised
  *	through autonegotiation; 0 if unknown or not applicable.
  *	Read-only.
+ * @reserved: Reserved for future use; see the note on reserved space.
  *
  * The link speed in Mbps is split between @speed and @speed_hi.  Use
  * the ethtool_cmd_speed() and ethtool_cmd_speed_set() functions to
@@ -155,6 +164,7 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  * @bus_info: Device bus address.  This should match the dev_name()
  *	string for the underlying bus device, if there is one.  May be
  *	an empty string.
+ * @reserved2: Reserved for future use; see the note on reserved space.
  * @n_priv_flags: Number of flags valid for %ETHTOOL_GPFLAGS and
  *	%ETHTOOL_SPFLAGS commands; also the number of strings in the
  *	%ETH_SS_PRIV_FLAGS set
@@ -356,6 +366,7 @@ struct ethtool_eeprom {
  * @tx_lpi_timer: Time in microseconds the interface delays prior to asserting
  *	its tx lpi (after reaching 'idle' state). Effective only when eee
  *	was negotiated and tx_lpi_enabled was set.
+ * @reserved: Reserved for future use; see the note on reserved space.
  */
 struct ethtool_eee {
 	__u32	cmd;
@@ -374,6 +385,7 @@ struct ethtool_eee {
  * @cmd: %ETHTOOL_GMODULEINFO
  * @type: Standard the module information conforms to %ETH_MODULE_SFF_xxxx
  * @eeprom_len: Length of the eeprom
+ * @reserved: Reserved for future use; see the note on reserved space.
  *
  * This structure is used to return the information to
  * properly size memory for a subsequent call to %ETHTOOL_GMODULEEEPROM.
@@ -701,6 +713,7 @@ struct ethtool_gstrings {
 /**
  * struct ethtool_sset_info - string set information
  * @cmd: Command number = %ETHTOOL_GSSET_INFO
+ * @reserved: Reserved for future use; see the note on reserved space.
  * @sset_mask: On entry, a bitmask of string sets to query, with bits
  *	numbered according to &enum ethtool_stringset.  On return, a
  *	bitmask of those string sets queried that are supported.
@@ -745,6 +758,7 @@ enum ethtool_test_flags {
  * @flags: A bitmask of flags from &enum ethtool_test_flags.  Some
  *	flags may be set by the user on entry; others may be set by
  *	the driver on return.
+ * @reserved: Reserved for future use; see the note on reserved space.
  * @len: On return, the number of test results
  * @data: Array of test results
  *
@@ -945,6 +959,7 @@ union ethtool_flow_union {
  * @vlan_etype: VLAN EtherType
  * @vlan_tci: VLAN tag control information
  * @data: user defined data
+ * @padding: Reserved for future use; see the note on reserved space.
  *
  * Note, @vlan_etype, @vlan_tci, and @data are only valid if %FLOW_EXT
  * is set in &struct ethtool_rx_flow_spec @flow_type.
@@ -1120,7 +1135,8 @@ struct ethtool_rxfh_indir {
  *	hardware hash key.
  * @hfunc: Defines the current RSS hash function used by HW (or to be set to).
  *	Valid values are one of the %ETH_RSS_HASH_*.
- * @rsvd:	Reserved for future extensions.
+ * @rsvd8: Reserved for future use; see the note on reserved space.
+ * @rsvd32: Reserved for future use; see the note on reserved space.
  * @rss_config: RX ring/queue index for each hash value i.e., indirection table
  *	of @indir_size __u32 elements, followed by hash key of @key_size
  *	bytes.
@@ -1288,7 +1304,9 @@ struct ethtool_sfeatures {
  * @so_timestamping: bit mask of the sum of the supported SO_TIMESTAMPING flags
  * @phc_index: device index of the associated PHC, or -1 if there is none
  * @tx_types: bit mask of the supported hwtstamp_tx_types enumeration values
+ * @tx_reserved: Reserved for future use; see the note on reserved space.
  * @rx_filters: bit mask of the supported hwtstamp_rx_filters enumeration values
+ * @rx_reserved: Reserved for future use; see the note on reserved space.
  *
  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
@@ -1944,6 +1962,8 @@ enum ethtool_reset_flags {
  *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  * @transceiver: Used to distinguish different possible PHY types,
  *	reported consistently by PHYLIB.  Read-only.
+ * @reserved: Reserved for future use; see the note on reserved space.
+ * @reserved1: Reserved for future use; see the note on reserved space.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
  * fixed link mode and are writable if the driver supports multiple
-- 
2.30.2

