Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDBA16AC59
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBXQ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:57:09 -0500
Received: from gateway22.websitewelcome.com ([192.185.46.225]:49025 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727421AbgBXQ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:57:08 -0500
X-Greylist: delayed 1380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2020 11:57:06 EST
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 417F568D0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 10:57:06 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6H2Yj50dFEfyq6H2YjBOnL; Mon, 24 Feb 2020 10:57:06 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WuWievwWNGzLn0JtdB0vIH/WOobPdyBMBhaEBO/ED9Q=; b=r9fLSNl8nHbV46E4kSeeNEm/GW
        gOLV+NjEEIqRXr6Nw5gfLJ4svJzi150riF9Qzx+sk98c1BjtLiWxy9e8P9drM02NY4MoH+4I4I0s2
        jhI9NKmmsKVar7k3DfwxV1ObalhZ/f600yZcTv+2mFgawX2+O5t6IwZyut8XYiQnyo6c/stOutxSX
        sb9EU4OULOaPx7yukKp5xpF46GXbo79I5ScM1UZEyTH29uObk3+zlvAQaTYy1M+lMihL3iWzerN4f
        3r1BwAmdJZ77JZiMOvi+D3QOsGReyHF1ohgYZeuiyQcj6RYvKbcJTk7eR/PgFUqgOkIirnxAQygL6
        5JYaHztQ==;
Received: from [200.68.140.135] (port=18194 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6H2W-0032qs-8v; Mon, 24 Feb 2020 10:57:04 -0600
Date:   Mon, 24 Feb 2020 10:59:52 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maya Erez <merez@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, wcn36xx@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, wil6210@qti.qualcomm.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] ath: Replace zero-length array with flexible-array
 member
Message-ID: <20200224165952.GA9377@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.135
X-Source-L: No
X-Exim-ID: 1j6H2W-0032qs-8v
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.135]:18194
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 99
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was detected with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath10k/ce.h          |  2 +-
 drivers/net/wireless/ath/ath10k/core.h        |  2 +-
 drivers/net/wireless/ath/ath10k/coredump.h    |  4 +-
 drivers/net/wireless/ath/ath10k/debug.h       |  2 +-
 drivers/net/wireless/ath/ath10k/hw.h          |  2 +-
 drivers/net/wireless/ath/ath10k/pci.h         |  2 +-
 drivers/net/wireless/ath/ath10k/swap.h        |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h     |  6 +-
 drivers/net/wireless/ath/ath10k/wmi.h         | 42 +++++++-------
 drivers/net/wireless/ath/ath11k/ce.h          |  2 +-
 drivers/net/wireless/ath/ath11k/debug.h       |  2 +-
 .../net/wireless/ath/ath11k/debug_htt_stats.h |  8 +--
 drivers/net/wireless/ath/ath11k/dp.h          | 10 ++--
 drivers/net/wireless/ath/ath11k/hal_desc.h    |  4 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h      |  2 +-
 drivers/net/wireless/ath/ath11k/hw.h          |  2 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h     |  2 +-
 drivers/net/wireless/ath/ath11k/wmi.h         |  2 +-
 drivers/net/wireless/ath/ath6kl/core.h        |  4 +-
 drivers/net/wireless/ath/ath6kl/debug.c       |  2 +-
 drivers/net/wireless/ath/ath6kl/hif.h         |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h         | 26 ++++-----
 drivers/net/wireless/ath/carl9170/fwcmd.h     |  2 +-
 drivers/net/wireless/ath/carl9170/fwdesc.h    |  2 +-
 drivers/net/wireless/ath/carl9170/hw.h        |  2 +-
 drivers/net/wireless/ath/carl9170/wlan.h      |  2 +-
 drivers/net/wireless/ath/spectral_common.h    |  2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h        |  4 +-
 drivers/net/wireless/ath/wcn36xx/testmode.h   |  2 +-
 drivers/net/wireless/ath/wil6210/fw.h         | 16 ++---
 drivers/net/wireless/ath/wil6210/wmi.c        |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.h        | 58 +++++++++----------
 32 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index a7478c240f78..41b5ea25ca57 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -110,7 +110,7 @@ struct ath10k_ce_ring {
 	struct ce_desc_64 *shadow_base;
 
 	/* keep last */
-	void *per_transfer_context[0];
+	void *per_transfer_context[];
 };
 
 struct ath10k_ce_pipe {
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5101bf2b5b15..7155eafdf8c6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1223,7 +1223,7 @@ struct ath10k {
 	struct completion peer_delete_done;
 
 	/* must be last */
-	u8 drv_priv[0] __aligned(sizeof(void *));
+	u8 drv_priv[] __aligned(sizeof(void *));
 };
 
 static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
index 8bf03e8c1d3a..e760ce1a5f1e 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.h
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -88,7 +88,7 @@ struct ath10k_dump_file_data {
 	u8 unused[128];
 
 	/* struct ath10k_tlv_dump_data + more */
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct ath10k_dump_ram_data_hdr {
@@ -100,7 +100,7 @@ struct ath10k_dump_ram_data_hdr {
 	/* length of payload data, not including this header */
 	__le32 length;
 
-	u8 data[0];
+	u8 data[];
 };
 
 /* magic number to fill the holes not copied due to sections in regions */
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 82f7eb8583d9..099cc438e231 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -65,7 +65,7 @@ struct ath10k_pktlog_hdr {
 	__le16 log_type; /* Type of log information foll this header */
 	__le16 size; /* Size of variable length log information in bytes */
 	__le32 timestamp;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* FIXME: How to calculate the buffer size sanely? */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 775fd62fb92d..87c18266f88f 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -165,7 +165,7 @@ enum qca9377_chip_id_rev {
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum ath10k_fw_ie_type {
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 4455ed6c5275..1254412f06dd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -182,7 +182,7 @@ struct ath10k_pci {
 	 * allocated (ahb support enabled case) in the continuation of
 	 * this struct.
 	 */
-	struct ath10k_ahb ahb[0];
+	struct ath10k_ahb ahb[];
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/swap.h b/drivers/net/wireless/ath/ath10k/swap.h
index 25e0ad36ddb1..b4733b5ded34 100644
--- a/drivers/net/wireless/ath/ath10k/swap.h
+++ b/drivers/net/wireless/ath/ath10k/swap.h
@@ -17,7 +17,7 @@ struct ath10k_fw_file;
 struct ath10k_swap_code_seg_tlv {
 	__le32 address;
 	__le32 length;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct ath10k_swap_code_seg_tail {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 4972dc12991c..4d49eb4b7f3d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1623,7 +1623,7 @@ wmi_tlv_svc_map_ext(const __le32 *in, unsigned long *out, size_t len)
 struct wmi_tlv {
 	__le16 len;
 	__le16 tag;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 struct ath10k_mgmt_tx_pkt_addr {
@@ -2023,7 +2023,7 @@ struct wmi_tlv_bcn_tx_status_ev {
 struct wmi_tlv_bcn_prb_info {
 	__le32 caps;
 	__le32 erp;
-	u8 ies[0];
+	u8 ies[];
 } __packed;
 
 struct wmi_tlv_bcn_tmpl_cmd {
@@ -2054,7 +2054,7 @@ struct wmi_tlv_diag_item {
 	__le16 len;
 	__le32 timestamp;
 	__le32 code;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct wmi_tlv_diag_data_ev {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 972d53d77654..a2fdb9550627 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2283,7 +2283,7 @@ struct wmi_service_ready_event {
 	 * where FW can access this memory directly (or) by DMA.
 	 */
 	__le32 num_mem_reqs;
-	struct wlan_host_mem_req mem_reqs[0];
+	struct wlan_host_mem_req mem_reqs[];
 } __packed;
 
 /* This is the definition from 10.X firmware branch */
@@ -2322,7 +2322,7 @@ struct wmi_10x_service_ready_event {
 	 */
 	__le32 num_mem_reqs;
 
-	struct wlan_host_mem_req mem_reqs[0];
+	struct wlan_host_mem_req mem_reqs[];
 } __packed;
 
 #define WMI_SERVICE_READY_TIMEOUT_HZ (5 * HZ)
@@ -3077,19 +3077,19 @@ struct wmi_chan_list_entry {
 struct wmi_chan_list {
 	__le32 tag; /* WMI_CHAN_LIST_TAG */
 	__le32 num_chan;
-	struct wmi_chan_list_entry channel_list[0];
+	struct wmi_chan_list_entry channel_list[];
 } __packed;
 
 struct wmi_bssid_list {
 	__le32 tag; /* WMI_BSSID_LIST_TAG */
 	__le32 num_bssid;
-	struct wmi_mac_addr bssid_list[0];
+	struct wmi_mac_addr bssid_list[];
 } __packed;
 
 struct wmi_ie_data {
 	__le32 tag; /* WMI_IE_TAG */
 	__le32 ie_len;
-	u8 ie_data[0];
+	u8 ie_data[];
 } __packed;
 
 struct wmi_ssid {
@@ -3100,7 +3100,7 @@ struct wmi_ssid {
 struct wmi_ssid_list {
 	__le32 tag; /* WMI_SSID_LIST_TAG */
 	__le32 num_ssids;
-	struct wmi_ssid ssids[0];
+	struct wmi_ssid ssids[];
 } __packed;
 
 /* prefix used by scan requestor ids on the host */
@@ -3302,7 +3302,7 @@ struct wmi_stop_scan_arg {
 
 struct wmi_scan_chan_list_cmd {
 	__le32 num_scan_chans;
-	struct wmi_channel chan_info[0];
+	struct wmi_channel chan_info[];
 } __packed;
 
 struct wmi_scan_chan_list_arg {
@@ -3386,12 +3386,12 @@ struct wmi_mgmt_rx_hdr_v2 {
 
 struct wmi_mgmt_rx_event_v1 {
 	struct wmi_mgmt_rx_hdr_v1 hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_mgmt_rx_event_v2 {
 	struct wmi_mgmt_rx_hdr_v2 hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_10_4_mgmt_rx_hdr {
@@ -3406,7 +3406,7 @@ struct wmi_10_4_mgmt_rx_hdr {
 
 struct wmi_10_4_mgmt_rx_event {
 	struct wmi_10_4_mgmt_rx_hdr hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_mgmt_rx_ext_info {
@@ -3446,14 +3446,14 @@ struct wmi_phyerr {
 	__le32 rssi_chains[4];
 	__le16 nf_chains[4];
 	__le32 buf_len;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_phyerr_event {
 	__le32 num_phyerrs;
 	__le32 tsf_l32;
 	__le32 tsf_u32;
-	struct wmi_phyerr phyerrs[0];
+	struct wmi_phyerr phyerrs[];
 } __packed;
 
 struct wmi_10_4_phyerr_event {
@@ -3470,7 +3470,7 @@ struct wmi_10_4_phyerr_event {
 	__le32 phy_err_mask[2];
 	__le32 tsf_timestamp;
 	__le32 buf_len;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_radar_found_info {
@@ -3583,7 +3583,7 @@ struct wmi_mgmt_tx_hdr {
 
 struct wmi_mgmt_tx_cmd {
 	struct wmi_mgmt_tx_hdr hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_echo_event {
@@ -4611,7 +4611,7 @@ struct wmi_stats_event {
 	 *  By having a zero sized array, the pointer to data area
 	 *  becomes available without increasing the struct size
 	 */
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_10_2_stats_event {
@@ -4621,7 +4621,7 @@ struct wmi_10_2_stats_event {
 	__le32 num_vdev_stats;
 	__le32 num_peer_stats;
 	__le32 num_bcnflt_stats;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /*
@@ -5016,7 +5016,7 @@ struct wmi_vdev_install_key_cmd {
 	__le32 key_rxmic_len;
 
 	/* contains key followed by tx mic followed by rx mic */
-	u8 key_data[0];
+	u8 key_data[];
 } __packed;
 
 struct wmi_vdev_install_key_arg {
@@ -5686,7 +5686,7 @@ struct wmi_bcn_tx_hdr {
 
 struct wmi_bcn_tx_cmd {
 	struct wmi_bcn_tx_hdr hdr;
-	u8 *bcn[0];
+	u8 *bcn[];
 } __packed;
 
 struct wmi_bcn_tx_arg {
@@ -6103,7 +6103,7 @@ struct wmi_bcn_info {
 
 struct wmi_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_bcn_info bcn_info[0];
+	struct wmi_bcn_info bcn_info[];
 } __packed;
 
 struct wmi_10_2_4_bcn_info {
@@ -6113,7 +6113,7 @@ struct wmi_10_2_4_bcn_info {
 
 struct wmi_10_2_4_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_10_2_4_bcn_info bcn_info[0];
+	struct wmi_10_2_4_bcn_info bcn_info[];
 } __packed;
 
 /* 16 words = 512 client + 1 word = for guard */
@@ -6154,7 +6154,7 @@ struct wmi_10_4_bcn_info {
 
 struct wmi_10_4_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_10_4_bcn_info bcn_info[0];
+	struct wmi_10_4_bcn_info bcn_info[];
 } __packed;
 
 #define WMI_MAX_AP_VDEV 16
diff --git a/drivers/net/wireless/ath/ath11k/ce.h b/drivers/net/wireless/ath/ath11k/ce.h
index e355dfda48bf..5fbf1fc39606 100644
--- a/drivers/net/wireless/ath/ath11k/ce.h
+++ b/drivers/net/wireless/ath/ath11k/ce.h
@@ -144,7 +144,7 @@ struct ath11k_ce_ring {
 	u32 hal_ring_id;
 
 	/* keep last */
-	struct sk_buff *skb[0];
+	struct sk_buff *skb[];
 };
 
 struct ath11k_ce_pipe {
diff --git a/drivers/net/wireless/ath/ath11k/debug.h b/drivers/net/wireless/ath/ath11k/debug.h
index 8e8d5588b541..ead5ca5160b6 100644
--- a/drivers/net/wireless/ath/ath11k/debug.h
+++ b/drivers/net/wireless/ath/ath11k/debug.h
@@ -65,7 +65,7 @@ struct debug_htt_stats_req {
 	u8 peer_addr[ETH_ALEN];
 	struct completion cmpln;
 	u32 buf_len;
-	u8 buf[0];
+	u8 buf[];
 };
 
 #define ATH11K_HTT_STATS_BUF_SIZE (1024 * 512)
diff --git a/drivers/net/wireless/ath/ath11k/debug_htt_stats.h b/drivers/net/wireless/ath/ath11k/debug_htt_stats.h
index 4bdb62dd7b8d..f85982dcc2ad 100644
--- a/drivers/net/wireless/ath/ath11k/debug_htt_stats.h
+++ b/drivers/net/wireless/ath/ath11k/debug_htt_stats.h
@@ -237,7 +237,7 @@ struct htt_tx_pdev_stats_tx_ppdu_stats_tlv_v {
  */
 struct htt_tx_pdev_stats_tried_mpdu_cnt_hist_tlv_v {
 	u32 hist_bin_size;
-	u32 tried_mpdu_cnt_hist[0]; /* HTT_TX_PDEV_TRIED_MPDU_CNT_HIST */
+	u32 tried_mpdu_cnt_hist[]; /* HTT_TX_PDEV_TRIED_MPDU_CNT_HIST */
 };
 
 /* == SOC ERROR STATS == */
@@ -548,7 +548,7 @@ struct htt_tx_hwq_stats_cmn_tlv {
 struct htt_tx_hwq_difs_latency_stats_tlv_v {
 	u32 hist_intvl;
 	/* histogram of ppdu post to hwsch - > cmd status received */
-	u32 difs_latency_hist[0]; /* HTT_TX_HWQ_MAX_DIFS_LATENCY_BINS */
+	u32 difs_latency_hist[]; /* HTT_TX_HWQ_MAX_DIFS_LATENCY_BINS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
@@ -584,7 +584,7 @@ struct htt_tx_hwq_fes_result_stats_tlv_v {
 struct htt_tx_hwq_tried_mpdu_cnt_hist_tlv_v {
 	u32 hist_bin_size;
 	/* Histogram of number of mpdus on tried mpdu */
-	u32 tried_mpdu_cnt_hist[0]; /* HTT_TX_HWQ_TRIED_MPDU_CNT_HIST */
+	u32 tried_mpdu_cnt_hist[]; /* HTT_TX_HWQ_TRIED_MPDU_CNT_HIST */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size
@@ -1582,7 +1582,7 @@ struct htt_pdev_stats_twt_session_tlv {
 struct htt_pdev_stats_twt_sessions_tlv {
 	u32 pdev_id;
 	u32 num_sessions;
-	struct htt_pdev_stats_twt_session_tlv twt_session[0];
+	struct htt_pdev_stats_twt_session_tlv twt_session[];
 };
 
 enum htt_rx_reo_resource_sample_id_enum {
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 6ef5be4201b2..71d387c6c925 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -1022,12 +1022,12 @@ struct ath11k_htt_ppdu_stats_msg {
 	u32 ppdu_id;
 	u32 timestamp;
 	u32 rsvd;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct htt_tlv {
 	u32 header;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 #define HTT_TLV_TAG			GENMASK(11, 0)
@@ -1205,7 +1205,7 @@ struct htt_ppdu_stats_usr_cmn_array {
 	 * tx_ppdu_stats_info is variable length, with length =
 	 *     number_of_ppdu_stats * sizeof (struct htt_tx_ppdu_stats_info)
 	 */
-	struct htt_tx_ppdu_stats_info tx_ppdu_info[0];
+	struct htt_tx_ppdu_stats_info tx_ppdu_info[];
 } __packed;
 
 struct htt_ppdu_user_stats {
@@ -1267,7 +1267,7 @@ struct htt_ppdu_stats_info {
  */
 struct htt_pktlog_msg {
 	u32 hdr;
-	u8 payload[0];
+	u8 payload[];
 };
 
 /**
@@ -1487,7 +1487,7 @@ struct ath11k_htt_extd_stats_msg {
 	u32 info0;
 	u64 cookie;
 	u32 info1;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct htt_mac_addr {
diff --git a/drivers/net/wireless/ath/ath11k/hal_desc.h b/drivers/net/wireless/ath/ath11k/hal_desc.h
index 5e200380cca4..a1f747c1c44d 100644
--- a/drivers/net/wireless/ath/ath11k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath11k/hal_desc.h
@@ -477,7 +477,7 @@ enum hal_tlv_tag {
 
 struct hal_tlv_hdr {
 	u32 tl;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 #define RX_MPDU_DESC_INFO0_MSDU_COUNT		GENMASK(7, 0)
@@ -1972,7 +1972,7 @@ struct hal_rx_reo_queue {
 	u32 processed_total_bytes;
 	u32 info5;
 	u32 rsvd[3];
-	struct hal_rx_reo_queue_ext ext_desc[0];
+	struct hal_rx_reo_queue_ext ext_desc[];
 } __packed;
 
 /* hal_rx_reo_queue
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.h b/drivers/net/wireless/ath/ath11k/hal_rx.h
index bb022c781c48..07b97fcb7c08 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.h
@@ -23,7 +23,7 @@ struct hal_rx_wbm_rel_info {
 
 struct hal_rx_mon_status_tlv_hdr {
 	u32 hdr;
-	u8 value[0];
+	u8 value[];
 };
 
 enum hal_rx_su_mu_coding {
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index dd39333ec0ea..7610c46c75fa 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -110,7 +110,7 @@ struct ath11k_hw_params {
 struct ath11k_fw_ie {
 	__le32 id;
 	__le32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum ath11k_bd_ie_board_type {
diff --git a/drivers/net/wireless/ath/ath11k/rx_desc.h b/drivers/net/wireless/ath/ath11k/rx_desc.h
index a5aff801f17f..ec2bca652923 100644
--- a/drivers/net/wireless/ath/ath11k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath11k/rx_desc.h
@@ -1206,7 +1206,7 @@ struct hal_rx_desc {
 	__le32 hdr_status_tag;
 	__le32 phy_ppdu_id;
 	u8 hdr_status[HAL_RX_DESC_HDR_STATUS_LEN];
-	u8 msdu_payload[0];
+	u8 msdu_payload[];
 } __packed;
 
 #endif /* ATH11K_RX_DESC_H */
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 1fde15c762ad..3dc3a6716881 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -39,7 +39,7 @@ struct wmi_cmd_hdr {
 
 struct wmi_tlv {
 	u32 header;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 #define WMI_TLV_LEN	GENMASK(15, 0)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 0d30e762c090..77e052336eb5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -160,7 +160,7 @@ enum ath6kl_fw_capability {
 struct ath6kl_fw_ie {
 	__le32 id;
 	__le32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum ath6kl_hw_flags {
@@ -406,7 +406,7 @@ struct ath6kl_mgmt_buff {
 	u32 id;
 	bool no_cck;
 	size_t len;
-	u8 buf[0];
+	u8 buf[];
 };
 
 struct ath6kl_sta {
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 54337d60f288..7506cea46f58 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -30,7 +30,7 @@ struct ath6kl_fwlog_slot {
 	__le32 length;
 
 	/* max ATH6KL_FWLOG_PAYLOAD_SIZE bytes */
-	u8 payload[0];
+	u8 payload[];
 };
 
 #define ATH6KL_FWLOG_MAX_ENTRIES 20
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index dc6bd8cd9b83..aea7fea2a81e 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -199,7 +199,7 @@ struct hif_scatter_req {
 
 	u32 scat_q_depth;
 
-	struct hif_scatter_item scat_list[0];
+	struct hif_scatter_item scat_list[];
 };
 
 struct ath6kl_irq_proc_registers {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 784940ba4c90..8535784af513 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1637,7 +1637,7 @@ struct bss_bias {
 
 struct bss_bias_info {
 	u8 num_bss;
-	struct bss_bias bss_bias[0];
+	struct bss_bias bss_bias[];
 } __packed;
 
 struct low_rssi_scan_params {
@@ -1720,7 +1720,7 @@ struct wmi_neighbor_info {
 
 struct wmi_neighbor_report_event {
 	u8 num_neighbors;
-	struct wmi_neighbor_info neighbor[0];
+	struct wmi_neighbor_info neighbor[];
 } __packed;
 
 /* TKIP MIC Error Event */
@@ -2051,7 +2051,7 @@ struct wmi_get_keepalive_cmd {
 struct wmi_set_appie_cmd {
 	u8 mgmt_frm_type; /* enum wmi_mgmt_frame_type */
 	u8 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 struct wmi_set_ie_cmd {
@@ -2059,7 +2059,7 @@ struct wmi_set_ie_cmd {
 	u8 ie_field;	/* enum wmi_ie_field_type */
 	u8 ie_len;
 	u8 reserved;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* Notify the WSC registration status to the target */
@@ -2127,7 +2127,7 @@ struct wmi_add_wow_pattern_cmd {
 	u8 filter_list_id;
 	u8 filter_size;
 	u8 filter_offset;
-	u8 filter[0];
+	u8 filter[];
 } __packed;
 
 struct wmi_del_wow_pattern_cmd {
@@ -2360,7 +2360,7 @@ struct wmi_send_action_cmd {
 	__le32 freq;
 	__le32 wait;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_send_mgmt_cmd {
@@ -2369,7 +2369,7 @@ struct wmi_send_mgmt_cmd {
 	__le32 wait;
 	__le32 no_cck;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_tx_status_event {
@@ -2389,7 +2389,7 @@ struct wmi_set_appie_extended_cmd {
 	u8 role_id;
 	u8 mgmt_frm_type;
 	u8 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 struct wmi_remain_on_chnl_event {
@@ -2406,18 +2406,18 @@ struct wmi_cancel_remain_on_chnl_event {
 struct wmi_rx_action_event {
 	__le32 freq;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_p2p_capabilities_event {
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_p2p_rx_probe_req_event {
 	__le32 freq;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define P2P_FLAG_CAPABILITIES_REQ   (0x00000001)
@@ -2431,7 +2431,7 @@ struct wmi_get_p2p_info {
 struct wmi_p2p_info_event {
 	__le32 info_req_flags;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_p2p_capabilities {
@@ -2450,7 +2450,7 @@ struct wmi_p2p_probe_response_cmd {
 	__le32 freq;
 	u8 destination_addr[ETH_ALEN];
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /* Extended WMI (WMIX)
diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index ea1d80f9a50e..56999a3b9d3b 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -127,7 +127,7 @@ struct carl9170_write_reg {
 struct carl9170_write_reg_byte {
 	__le32	addr;
 	__le32  count;
-	u8	val[0];
+	u8	val[];
 } __packed;
 
 #define	CARL9170FW_PHY_HT_ENABLE		0x4
diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 503b21abbba5..10acb6ad30d0 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -149,7 +149,7 @@ struct carl9170fw_fix_entry {
 
 struct carl9170fw_fix_desc {
 	struct carl9170fw_desc_head head;
-	struct carl9170fw_fix_entry data[0];
+	struct carl9170fw_fix_entry data[];
 } __packed;
 #define CARL9170FW_FIX_DESC_SIZE			\
 	(sizeof(struct carl9170fw_fix_desc))
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 08e0ae9c5836..555ad4975970 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -851,7 +851,7 @@ struct ar9170_stream {
 	__le16 length;
 	__le16 tag;
 
-	u8 payload[0];
+	u8 payload[];
 } __packed __aligned(4);
 #define AR9170_STREAM_LEN				4
 
diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index ea17995b32f4..54a6fbfc77cf 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -327,7 +327,7 @@ struct _carl9170_tx_superdesc {
 struct _carl9170_tx_superframe {
 	struct _carl9170_tx_superdesc s;
 	struct _ar9170_tx_hwdesc f;
-	u8 frame_data[0];
+	u8 frame_data[];
 } __packed __aligned(4);
 
 #define	CARL9170_TX_SUPERDESC_LEN		24
diff --git a/drivers/net/wireless/ath/spectral_common.h b/drivers/net/wireless/ath/spectral_common.h
index 0d742acb1599..90f08ffc911e 100644
--- a/drivers/net/wireless/ath/spectral_common.h
+++ b/drivers/net/wireless/ath/spectral_common.h
@@ -107,7 +107,7 @@ struct fft_sample_ath10k {
 	u8 avgpwr_db;
 	u8 max_exp;
 
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #endif /* SPECTRAL_COMMON_H */
diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 6ba0fd57c951..aab5a58616fc 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2240,7 +2240,7 @@ struct wcn36xx_hal_process_ptt_msg_req_msg {
 	struct wcn36xx_hal_msg_header header;
 
 	/* Actual FTM Command body */
-	u8 ptt_msg[0];
+	u8 ptt_msg[];
 } __packed;
 
 struct wcn36xx_hal_process_ptt_msg_rsp_msg {
@@ -2249,7 +2249,7 @@ struct wcn36xx_hal_process_ptt_msg_rsp_msg {
 	/* FTM Command response status */
 	u32 ptt_msg_resp_status;
 	/* Actual FTM Command body */
-	u8 ptt_msg[0];
+	u8 ptt_msg[];
 } __packed;
 
 struct update_edca_params_req_msg {
diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.h b/drivers/net/wireless/ath/wcn36xx/testmode.h
index 4c6cfdb46580..09d68fab9add 100644
--- a/drivers/net/wireless/ath/wcn36xx/testmode.h
+++ b/drivers/net/wireless/ath/wcn36xx/testmode.h
@@ -20,7 +20,7 @@ struct ftm_rsp_msg {
 	u16 msg_id;
 	u16 msg_body_length;
 	u32 resp_status;
-	u8 msg_response[0];
+	u8 msg_response[];
 } __packed;
 
 /* The request buffer of FTM which contains a byte of command and the request */
diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index 540fa1607794..440614d61156 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -33,7 +33,7 @@ struct wil_fw_record_head {
  */
 struct wil_fw_record_data { /* type == wil_fw_type_data */
 	__le32 addr;
-	__le32 data[0]; /* [data_size], see above */
+	__le32 data[]; /* [data_size], see above */
 } __packed;
 
 /* fill with constant @value, @size bytes starting from @addr */
@@ -61,7 +61,7 @@ struct wil_fw_record_capabilities { /* type == wil_fw_type_comment */
 	/* identifies capabilities record */
 	struct wil_fw_record_comment_hdr hdr;
 	/* capabilities (variable size), see enum wmi_fw_capability */
-	u8 capabilities[0];
+	u8 capabilities[];
 } __packed;
 
 /* FW VIF concurrency encoded inside a comment record
@@ -80,7 +80,7 @@ struct wil_fw_concurrency_combo {
 	u8 n_diff_channels; /* total number of different channels allowed */
 	u8 same_bi; /* for APs, 1 if all APs must have same BI */
 	/* keep last - concurrency limits, variable size by n_limits */
-	struct wil_fw_concurrency_limit limits[0];
+	struct wil_fw_concurrency_limit limits[];
 } __packed;
 
 struct wil_fw_record_concurrency { /* type == wil_fw_type_comment */
@@ -93,7 +93,7 @@ struct wil_fw_record_concurrency { /* type == wil_fw_type_comment */
 	/* number of concurrency combinations that follow */
 	__le16 n_combos;
 	/* keep last - combinations, variable size by n_combos */
-	struct wil_fw_concurrency_combo combos[0];
+	struct wil_fw_concurrency_combo combos[];
 } __packed;
 
 /* brd file info encoded inside a comment record */
@@ -108,7 +108,7 @@ struct wil_fw_record_brd_file { /* type == wil_fw_type_comment */
 	/* identifies brd file record */
 	struct wil_fw_record_comment_hdr hdr;
 	__le32 version;
-	struct brd_info brd_info[0];
+	struct brd_info brd_info[];
 } __packed;
 
 /* perform action
@@ -116,7 +116,7 @@ struct wil_fw_record_brd_file { /* type == wil_fw_type_comment */
  */
 struct wil_fw_record_action { /* type == wil_fw_type_action */
 	__le32 action; /* action to perform: reset, wait for fw ready etc. */
-	__le32 data[0]; /* action specific, [data_size], see above */
+	__le32 data[]; /* action specific, [data_size], see above */
 } __packed;
 
 /* data block for struct wil_fw_record_direct_write */
@@ -179,7 +179,7 @@ struct wil_fw_record_gateway_data { /* type == wil_fw_type_gateway_data */
 #define WIL_FW_GW_CTL_BUSY	BIT(29) /* gateway busy performing operation */
 #define WIL_FW_GW_CTL_RUN	BIT(30) /* start gateway operation */
 	__le32 command;
-	struct wil_fw_data_gw data[0]; /* total size [data_size], see above */
+	struct wil_fw_data_gw data[]; /* total size [data_size], see above */
 } __packed;
 
 /* 4-dword gateway */
@@ -201,7 +201,7 @@ struct wil_fw_record_gateway_data4 { /* type == wil_fw_type_gateway_data4 */
 	__le32 gateway_cmd_addr;
 	__le32 gateway_ctrl_address; /* same logic as for 1-dword gw */
 	__le32 command;
-	struct wil_fw_data_gw4 data[0]; /* total size [data_size], see above */
+	struct wil_fw_data_gw4 data[]; /* total size [data_size], see above */
 } __packed;
 
 #endif /* __WIL_FW_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 23e1ed6a9d6d..c7136ce567ee 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -222,7 +222,7 @@ struct auth_no_hdr {
 	__le16 auth_transaction;
 	__le16 status_code;
 	/* possibly followed by Challenge text */
-	u8 variable[0];
+	u8 variable[];
 } __packed;
 
 u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index e3558136e0c4..9affa4525609 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -474,7 +474,7 @@ struct wmi_start_scan_cmd {
 	struct {
 		u8 channel;
 		u8 reserved;
-	} channel_list[0];
+	} channel_list[];
 } __packed;
 
 #define WMI_MAX_PNO_SSID_NUM	(16)
@@ -530,7 +530,7 @@ struct wmi_update_ft_ies_cmd {
 	/* Length of the FT IEs */
 	__le16 ie_len;
 	u8 reserved[2];
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* WMI_SET_PROBED_SSID_CMDID */
@@ -575,7 +575,7 @@ struct wmi_set_appie_cmd {
 	u8 reserved;
 	/* Length of the IE to be added to MGMT frame */
 	__le16 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* WMI_PXMT_RANGE_CFG_CMDID */
@@ -850,7 +850,7 @@ struct wmi_pcp_start_cmd {
 struct wmi_sw_tx_req_cmd {
 	u8 dst_mac[WMI_MAC_LEN];
 	__le16 len;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_SW_TX_REQ_EXT_CMDID */
@@ -861,7 +861,7 @@ struct wmi_sw_tx_req_ext_cmd {
 	/* Channel to use, 0xFF for currently active channel */
 	u8 channel;
 	u8 reserved[5];
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_VRING_SWITCH_TIMING_CONFIG_CMDID */
@@ -1423,7 +1423,7 @@ struct wmi_rf_xpm_write_cmd {
 	u8 verify;
 	u8 reserved1[3];
 	/* actual size=num_bytes */
-	u8 data_bytes[0];
+	u8 data_bytes[];
 } __packed;
 
 /* Possible modes for temperature measurement */
@@ -1572,7 +1572,7 @@ struct wmi_tof_session_start_cmd {
 	u8 aoa_type;
 	__le16 num_of_dest;
 	u8 reserved[4];
-	struct wmi_ftm_dest_info ftm_dest_info[0];
+	struct wmi_ftm_dest_info ftm_dest_info[];
 } __packed;
 
 /* WMI_TOF_CFG_RESPONDER_CMDID */
@@ -1766,7 +1766,7 @@ struct wmi_internal_fw_ioctl_cmd {
 	/* payload max size is WMI_MAX_IOCTL_PAYLOAD_SIZE
 	 * Must be the last member of the struct
 	 */
-	__le32 payload[0];
+	__le32 payload[];
 } __packed;
 
 /* WMI_INTERNAL_FW_IOCTL_EVENTID */
@@ -1778,7 +1778,7 @@ struct wmi_internal_fw_ioctl_event {
 	/* payload max size is WMI_MAX_IOCTL_REPLY_PAYLOAD_SIZE
 	 * Must be the last member of the struct
 	 */
-	__le32 payload[0];
+	__le32 payload[];
 } __packed;
 
 /* WMI_INTERNAL_FW_EVENT_EVENTID */
@@ -1788,7 +1788,7 @@ struct wmi_internal_fw_event_event {
 	/* payload max size is WMI_MAX_INTERNAL_EVENT_PAYLOAD_SIZE
 	 * Must be the last member of the struct
 	 */
-	__le32 payload[0];
+	__le32 payload[];
 } __packed;
 
 /* WMI_SET_VRING_PRIORITY_WEIGHT_CMDID */
@@ -1818,7 +1818,7 @@ struct wmi_set_vring_priority_cmd {
 	 */
 	u8 num_of_vrings;
 	u8 reserved[3];
-	struct wmi_vring_priority vring_priority[0];
+	struct wmi_vring_priority vring_priority[];
 } __packed;
 
 /* WMI_BF_CONTROL_CMDID - deprecated */
@@ -1910,7 +1910,7 @@ struct wmi_bf_control_ex_cmd {
 	u8 each_mcs_cfg_size;
 	u8 reserved1;
 	/* Configuration for each MCS */
-	struct wmi_bf_control_ex_mcs each_mcs_cfg[0];
+	struct wmi_bf_control_ex_mcs each_mcs_cfg[];
 } __packed;
 
 /* WMI_LINK_STATS_CMD */
@@ -2192,7 +2192,7 @@ struct wmi_fw_ver_event {
 	/* FW capabilities info
 	 * Must be the last member of the struct
 	 */
-	__le32 fw_capabilities[0];
+	__le32 fw_capabilities[];
 } __packed;
 
 /* WMI_GET_RF_STATUS_EVENTID */
@@ -2270,7 +2270,7 @@ struct wmi_mac_addr_resp_event {
 struct wmi_eapol_rx_event {
 	u8 src_mac[WMI_MAC_LEN];
 	__le16 eapol_len;
-	u8 eapol[0];
+	u8 eapol[];
 } __packed;
 
 /* WMI_READY_EVENTID */
@@ -2343,7 +2343,7 @@ struct wmi_connect_event {
 	u8 aid;
 	u8 reserved2[2];
 	/* not in use */
-	u8 assoc_info[0];
+	u8 assoc_info[];
 } __packed;
 
 /* disconnect_reason */
@@ -2376,7 +2376,7 @@ struct wmi_disconnect_event {
 	/* last assoc req may passed to host - not in used */
 	u8 assoc_resp_len;
 	/* last assoc req may passed to host - not in used */
-	u8 assoc_info[0];
+	u8 assoc_info[];
 } __packed;
 
 /* WMI_SCAN_COMPLETE_EVENTID */
@@ -2400,7 +2400,7 @@ struct wmi_ft_auth_status_event {
 	u8 reserved[3];
 	u8 mac_addr[WMI_MAC_LEN];
 	__le16 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* WMI_FT_REASSOC_STATUS_EVENTID */
@@ -2418,7 +2418,7 @@ struct wmi_ft_reassoc_status_event {
 	__le16 reassoc_req_ie_len;
 	__le16 reassoc_resp_ie_len;
 	u8 reserved[4];
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* wmi_rx_mgmt_info */
@@ -2461,7 +2461,7 @@ struct wmi_stop_sched_scan_event {
 
 struct wmi_sched_scan_result_event {
 	struct wmi_rx_mgmt_info info;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_ACS_PASSIVE_SCAN_COMPLETE_EVENT */
@@ -2492,7 +2492,7 @@ struct wmi_acs_passive_scan_complete_event {
 	__le16 filled;
 	u8 num_scanned_channels;
 	u8 reserved;
-	struct scan_acs_info scan_info_list[0];
+	struct scan_acs_info scan_info_list[];
 } __packed;
 
 /* WMI_BA_STATUS_EVENTID */
@@ -2751,7 +2751,7 @@ struct wmi_rf_xpm_read_result_event {
 	u8 status;
 	u8 reserved[3];
 	/* requested num_bytes of data */
-	u8 data_bytes[0];
+	u8 data_bytes[];
 } __packed;
 
 /* EVENT: WMI_RF_XPM_WRITE_RESULT_EVENTID */
@@ -2769,7 +2769,7 @@ struct wmi_tx_mgmt_packet_event {
 /* WMI_RX_MGMT_PACKET_EVENTID */
 struct wmi_rx_mgmt_packet_event {
 	struct wmi_rx_mgmt_info info;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_ECHO_RSP_EVENTID */
@@ -2969,7 +2969,7 @@ struct wmi_rs_cfg_ex_cmd {
 	u8 each_mcs_cfg_size;
 	u8 reserved[3];
 	/* Configuration for each MCS */
-	struct wmi_rs_cfg_ex_mcs each_mcs_cfg[0];
+	struct wmi_rs_cfg_ex_mcs each_mcs_cfg[];
 } __packed;
 
 /* WMI_RS_CFG_EX_EVENTID */
@@ -3178,7 +3178,7 @@ struct wmi_get_detailed_rs_res_ex_event {
 	u8 each_mcs_results_size;
 	u8 reserved1[3];
 	/* Results for each MCS */
-	struct wmi_rs_results_ex_mcs each_mcs_results[0];
+	struct wmi_rs_results_ex_mcs each_mcs_results[];
 } __packed;
 
 /* BRP antenna limit mode */
@@ -3320,7 +3320,7 @@ struct wmi_set_link_monitor_cmd {
 	u8 rssi_hyst;
 	u8 reserved[12];
 	u8 rssi_thresholds_list_size;
-	s8 rssi_thresholds_list[0];
+	s8 rssi_thresholds_list[];
 } __packed;
 
 /* wmi_link_monitor_event_type */
@@ -3637,7 +3637,7 @@ struct wmi_tof_ftm_per_dest_res_event {
 	/* Measurments are from RFs, defined by the mask */
 	__le32 meas_rf_mask;
 	u8 reserved0[3];
-	struct wmi_responder_ftm_res responder_ftm_res[0];
+	struct wmi_responder_ftm_res responder_ftm_res[];
 } __packed;
 
 /* WMI_TOF_CFG_RESPONDER_EVENTID */
@@ -3669,7 +3669,7 @@ struct wmi_tof_channel_info_event {
 	/* data report length */
 	u8 len;
 	/* data report payload */
-	u8 report[0];
+	u8 report[];
 } __packed;
 
 /* WMI_TOF_SET_TX_RX_OFFSET_EVENTID */
@@ -4085,7 +4085,7 @@ struct wmi_link_stats_event {
 	u8 has_next;
 	u8 reserved[5];
 	/* a stream of wmi_link_stats_record_s */
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_LINK_STATS_EVENT */
@@ -4094,7 +4094,7 @@ struct wmi_link_stats_record {
 	u8 record_type_id;
 	u8 reserved;
 	__le16 record_size;
-	u8 record[0];
+	u8 record[];
 } __packed;
 
 /* WMI_LINK_STATS_TYPE_BASIC */
-- 
2.25.0

