Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44DA11FB5B
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfLOVGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:06:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:34508 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726146AbfLOVGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:06:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6703CACE3;
        Sun, 15 Dec 2019 21:06:05 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1A451E0404; Sun, 15 Dec 2019 22:06:05 +0100 (CET)
Message-Id: <deda05eab15d5a80b00fe05671e980b73ccef0b1.1576443050.git.mkubecek@suse.cz>
In-Reply-To: <cover.1576443050.git.mkubecek@suse.cz>
References: <cover.1576443050.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH iproute2-next 1/2] Update kernel headers
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Date:   Sun, 15 Dec 2019 22:06:05 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to commit:
    f5058a27dac7 ("net: phylink: propagate phy_attach_direct() return code")

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/if_bonding.h | 10 ++++++++++
 include/uapi/linux/if_bridge.h  | 10 ++++++++++
 include/uapi/linux/if_link.h    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index 790585f0e61b..6829213a54c5 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -95,6 +95,16 @@
 #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
 
+/* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
+#define AD_STATE_LACP_ACTIVITY   0x1
+#define AD_STATE_LACP_TIMEOUT    0x2
+#define AD_STATE_AGGREGATION     0x4
+#define AD_STATE_SYNCHRONIZATION 0x8
+#define AD_STATE_COLLECTING      0x10
+#define AD_STATE_DISTRIBUTING    0x20
+#define AD_STATE_DEFAULTED       0x40
+#define AD_STATE_EXPIRED         0x80
+
 typedef struct ifbond {
 	__s32 bond_mode;
 	__s32 num_slaves;
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 31fc51bdedb3..9fefc7f30d7b 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -156,6 +156,15 @@ struct bridge_vlan_xstats {
 	__u32 pad2;
 };
 
+struct bridge_stp_xstats {
+	__u64 transition_blk;
+	__u64 transition_fwd;
+	__u64 rx_bpdu;
+	__u64 tx_bpdu;
+	__u64 rx_tcn;
+	__u64 tx_tcn;
+};
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
@@ -262,6 +271,7 @@ enum {
 	BRIDGE_XSTATS_VLAN,
 	BRIDGE_XSTATS_MCAST,
 	BRIDGE_XSTATS_PAD,
+	BRIDGE_XSTATS_STP,
 	__BRIDGE_XSTATS_MAX
 };
 #define BRIDGE_XSTATS_MAX (__BRIDGE_XSTATS_MAX - 1)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1c49f436424d..29eac87e0e0f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,7 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_PERM_ADDRESS,
 	__IFLA_MAX
 };
 
-- 
2.24.1

