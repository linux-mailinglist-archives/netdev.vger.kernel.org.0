Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB1E265696
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgIKBYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:24:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:51454 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgIKBXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:47 -0400
IronPort-SDR: 4NtuoKxLGHwicpww3Pm6/aruL/XCqw8c64ivwDzUS9bywvxZ3oLWMDXF7R6vJU8dbty73HrusL
 eajs8ue1fYeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="243491824"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="243491824"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
IronPort-SDR: Po+rKLcqax5fFTyF3Kvy5/HgJBkDhd0Vcwi816w5rLraYDNMC0OGGLXdTyS37kN7Jsu3Yaqtfg
 oiDEVYeLrBVg==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808139"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:44 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 02/11] i40e: clean up W=1 warnings in i40e
Date:   Thu, 10 Sep 2020 18:23:28 -0700
Message-Id: <20200911012337.14015-3-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inspired by Lee Jones, this eliminates the remaining W=1 warnings in i40e.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c   |  2 --
 drivers/net/ethernet/intel/i40e/i40e_common.c   |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c     | 17 ++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_ptp.c      |  1 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c     |  7 ++++---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c  |  9 +++++----
 6 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index befd3018183f..a2dba32383f6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -278,8 +278,6 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
- * @client: pointer to a client struct in the client list.
- * @existing: if there was already an existing instance
  *
  **/
 static void i40e_client_add_instance(struct i40e_pf *pf)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 6ab52cbd697a..adc9e4fa4789 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -3766,9 +3766,7 @@ i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
 /**
  * i40e_aq_start_lldp
  * @hw: pointer to the hw struct
- * @buff: buffer for result
  * @persist: True if start of LLDP should be persistent across power cycles
- * @buff_size: buffer size
  * @cmd_details: pointer to command details structure or NULL
  *
  * Start the embedded LLDP Agent on all ports.
@@ -5395,6 +5393,7 @@ static void i40e_mdio_if_number_selection(struct i40e_hw *hw, bool set_mdio,
  * @hw: pointer to the hw struct
  * @phy_select: select which phy should be accessed
  * @dev_addr: PHY device address
+ * @page_change: flag to indicate if phy page should be updated
  * @set_mdio: use MDIO I/F number specified by mdio_num
  * @mdio_num: MDIO I/F number
  * @reg_addr: PHY register address
@@ -5439,6 +5438,7 @@ enum i40e_status_code i40e_aq_set_phy_register_ext(struct i40e_hw *hw,
  * @hw: pointer to the hw struct
  * @phy_select: select which phy should be accessed
  * @dev_addr: PHY device address
+ * @page_change: flag to indicate if phy page should be updated
  * @set_mdio: use MDIO I/F number specified by mdio_num
  * @mdio_num: MDIO I/F number
  * @reg_addr: PHY register address
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 05c6d3ea11e6..4553700ce686 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -287,6 +287,7 @@ void i40e_service_event_schedule(struct i40e_pf *pf)
 /**
  * i40e_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number timing out
  *
  * If any port has noticed a Tx timeout, it is likely that the whole
  * device is munged, not just the one netdev port, so go for the full
@@ -1609,6 +1610,8 @@ static int i40e_set_mac(struct net_device *netdev, void *p)
  * i40e_config_rss_aq - Prepare for RSS using AQ commands
  * @vsi: vsi structure
  * @seed: RSS hash seed
+ * @lut: pointer to lookup table of lut_size
+ * @lut_size: size of the lookup table
  **/
 static int i40e_config_rss_aq(struct i40e_vsi *vsi, const u8 *seed,
 			      u8 *lut, u16 lut_size)
@@ -5815,7 +5818,6 @@ static int i40e_vsi_reconfig_rss(struct i40e_vsi *vsi, u16 rss_size)
 /**
  * i40e_channel_setup_queue_map - Setup a channel queue map
  * @pf: ptr to PF device
- * @vsi: the VSI being setup
  * @ctxt: VSI context structure
  * @ch: ptr to channel structure
  *
@@ -6058,8 +6060,7 @@ static inline int i40e_setup_hw_channel(struct i40e_pf *pf,
 /**
  * i40e_setup_channel - setup new channel using uplink element
  * @pf: ptr to PF device
- * @type: type of channel to be created (VMDq2/VF)
- * @uplink_seid: underlying HW switching element (VEB) ID
+ * @vsi: pointer to the VSI to set up the channel within
  * @ch: ptr to channel structure
  *
  * Setup new channel (VSI) based on specified type (VMDq2/VF)
@@ -7780,7 +7781,7 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 /**
  * i40e_parse_cls_flower - Parse tc flower filters provided by kernel
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to struct flow_cls_offload
+ * @f: Pointer to struct flow_cls_offload
  * @filter: Pointer to cloud filter structure
  *
  **/
@@ -8161,8 +8162,8 @@ static int i40e_delete_clsflower(struct i40e_vsi *vsi,
 
 /**
  * i40e_setup_tc_cls_flower - flower classifier offloads
- * @netdev: net device to configure
- * @type_data: offload data
+ * @np: net device to configure
+ * @cls_flower: offload data
  **/
 static int i40e_setup_tc_cls_flower(struct i40e_netdev_priv *np,
 				    struct flow_cls_offload *cls_flower)
@@ -9586,6 +9587,7 @@ static int i40e_reconstitute_veb(struct i40e_veb *veb)
 /**
  * i40e_get_capabilities - get info about the HW
  * @pf: the PF struct
+ * @list_type: AQ capability to be queried
  **/
 static int i40e_get_capabilities(struct i40e_pf *pf,
 				 enum i40e_admin_queue_opc list_type)
@@ -10547,7 +10549,7 @@ static void i40e_service_task(struct work_struct *work)
 
 /**
  * i40e_service_timer - timer callback
- * @data: pointer to PF struct
+ * @t: timer list pointer
  **/
 static void i40e_service_timer(struct timer_list *t)
 {
@@ -12380,6 +12382,7 @@ static int i40e_get_phys_port_id(struct net_device *netdev,
  * @addr: the MAC address entry being added
  * @vid: VLAN ID
  * @flags: instructions from stack about fdb operation
+ * @extack: netlink extended ack, unused currently
  */
 static int i40e_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index ff7b19c6bc73..7a879614ca55 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -259,7 +259,6 @@ static u32 i40e_ptp_get_rx_events(struct i40e_pf *pf)
 /**
  * i40e_ptp_rx_hang - Detect error case when Rx timestamp registers are hung
  * @pf: The PF private data structure
- * @vsi: The VSI with the rings relevant to 1588
  *
  * This watchdog task is scheduled to detect error case where hardware has
  * dropped an Rx packet that was timestamped when the ring is full. The
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 91ab824926b9..828dff2e7ed2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1755,7 +1755,6 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
  * @rx_ring: rx descriptor ring packet is being transacted on
  * @rx_desc: pointer to the EOP Rx descriptor
  * @skb: pointer to current skb being populated
- * @rx_ptype: the packet type decoded by hardware
  *
  * This function checks the ring, descriptor, and packet information in
  * order to populate the hash, checksum, VLAN, protocol, and
@@ -3499,7 +3498,7 @@ static inline int i40e_tx_map(struct i40e_ring *tx_ring, struct sk_buff *skb,
 
 /**
  * i40e_xmit_xdp_ring - transmits an XDP buffer to an XDP Tx ring
- * @xdp: data to transmit
+ * @xdpf: data to transmit
  * @xdp_ring: XDP Tx ring
  **/
 static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
@@ -3694,7 +3693,9 @@ netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 /**
  * i40e_xdp_xmit - Implements ndo_xdp_xmit
  * @dev: netdev
- * @xdp: XDP buffer
+ * @n: number of frames
+ * @frames: array of XDP buffer pointers
+ * @flags: XDP extra info
  *
  * Returns number of frames successfully sent. Frames that fail are
  * free'ed via XDP return API.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8e133d6545bd..f32a907b4419 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2234,7 +2234,8 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 }
 
 /**
- * i40e_validate_queue_map
+ * i40e_validate_queue_map - check queue map is valid
+ * @vf: the VF structure pointer
  * @vsi_id: vsi id
  * @queuemap: Tx or Rx queue map
  *
@@ -3150,8 +3151,8 @@ static int i40e_vc_disable_vlan_stripping(struct i40e_vf *vf, u8 *msg)
 
 /**
  * i40e_validate_cloud_filter
- * @mask: mask for TC filter
- * @data: data for TC filter
+ * @vf: pointer to VF structure
+ * @tc_filter: pointer to filter requested
  *
  * This function validates cloud filter programmed as TC filter for ADq
  **/
@@ -3284,7 +3285,7 @@ static int i40e_validate_cloud_filter(struct i40e_vf *vf,
 /**
  * i40e_find_vsi_from_seid - searches for the vsi with the given seid
  * @vf: pointer to the VF info
- * @seid - seid of the vsi it is searching for
+ * @seid: seid of the vsi it is searching for
  **/
 static struct i40e_vsi *i40e_find_vsi_from_seid(struct i40e_vf *vf, u16 seid)
 {
-- 
2.27.0

