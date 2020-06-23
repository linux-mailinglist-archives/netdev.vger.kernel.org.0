Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8002062C0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393142AbgFWVH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:07:26 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:27160 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391612AbgFWUfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:35:12 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKZ9sL019557;
        Tue, 23 Jun 2020 13:35:10 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 12/12] cxgb4vf: update kernel-doc line comments
Date:   Wed, 24 Jun 2020 01:51:42 +0530
Message-Id: <c17c05694a242d1c670c19c371413f50446a5c19.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update several kernel-doc line comments to fix warnings reported by
make W=1.

Fixes following class of warnings reported by make W=1 in several
places:
cxgb4vf_main.c:275: warning: Function parameter or member 'persistent'
not described in 'cxgb4vf_change_mac'
cxgb4vf_main.c:275: warning: Excess function parameter 'persist'
description in 'cxgb4vf_change_mac'

Fixes: 16f8bd4be754 ("cxgb4vf: Add core T4 PCI-E SR-IOV Virtual Function hardware definitions and device communication code")
Fixes: c6e0d91464da ("cxgb4vf: Add T4 Virtual Function Scatter-Gather Engine DMA code")
Fixes: e0a8b34a9cc4 ("cxgb4vf: Add and initialize some sge params for VF driver")
Fixes: c3168cabe1af ("cxgb4/cxgbvf: Handle 32-bit fw port capabilities")
Fixes: 0e23daeb6407 ("drivers/net: chelsio/cxgb*: Convert timers to use timer_setup()")
Fixes: 3f8cfd0d95e6 ("cxgb4/cxgb4vf: Program hash region for {t4/t4vf}_change_mac()")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 3 +--
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c          | 7 ++++---
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c      | 9 +++------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index cec865a97464..a7641be9094f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -260,8 +260,7 @@ static int cxgb4vf_set_addr_hash(struct port_info *pi)
  *	@tcam_idx: TCAM index of existing filter for old value of MAC address,
  *		   or -1
  *	@addr: the new MAC address value
- *	@persist: whether a new MAC allocation should be persistent
- *	@add_smt: if true also add the address to the HW SMT
+ *	@persistent: whether a new MAC allocation should be persistent
  *
  *	Modifies an MPS filter and sets it to the new MAC address if
  *	@tcam_idx >= 0, or adds the MAC address to a new filter if
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index f71c973398ec..8c3d6e11a4bf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -1692,7 +1692,7 @@ static inline bool is_new_response(const struct rsp_ctrl *rc,
  *	restore_rx_bufs - put back a packet's RX buffers
  *	@gl: the packet gather list
  *	@fl: the SGE Free List
- *	@nfrags: how many fragments in @si
+ *	@frags: how many fragments in @si
  *
  *	Called when we find out that the current packet, @si, can't be
  *	processed right away for some reason.  This is a very rare event and
@@ -2054,7 +2054,7 @@ irq_handler_t t4vf_intr_handler(struct adapter *adapter)
 
 /**
  *	sge_rx_timer_cb - perform periodic maintenance of SGE RX queues
- *	@data: the adapter
+ *	@t: Rx timer
  *
  *	Runs periodically from a timer to perform maintenance of SGE RX queues.
  *
@@ -2113,7 +2113,7 @@ static void sge_rx_timer_cb(struct timer_list *t)
 
 /**
  *	sge_tx_timer_cb - perform periodic maintenance of SGE Tx queues
- *	@data: the adapter
+ *	@t: Tx timer
  *
  *	Runs periodically from a timer to perform maintenance of SGE TX queues.
  *
@@ -2405,6 +2405,7 @@ int t4vf_sge_alloc_rxq(struct adapter *adapter, struct sge_rspq *rspq,
  *	t4vf_sge_alloc_eth_txq - allocate an SGE Ethernet TX Queue
  *	@adapter: the adapter
  *	@txq: pointer to the new txq to be filled in
+ *	@dev: the network device
  *	@devq: the network TX queue associated with the new txq
  *	@iqid: the relative ingress queue ID to which events relating to
  *		the new txq should be directed
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
index 9d49ff211cc1..a31b87390b50 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -389,9 +389,7 @@ static inline enum cc_fec fwcap_to_cc_fec(fw_port_cap32_t fw_fec)
 	return cc_fec;
 }
 
-/**
- * Return the highest speed set in the port capabilities, in Mb/s.
- */
+/* Return the highest speed set in the port capabilities, in Mb/s. */
 static unsigned int fwcap_to_speed(fw_port_cap32_t caps)
 {
 	#define TEST_SPEED_RETURN(__caps_speed, __speed) \
@@ -1467,6 +1465,7 @@ int t4vf_identify_port(struct adapter *adapter, unsigned int viid,
  *	@bcast: 1 to enable broadcast Rx, 0 to disable it, -1 no change
  *	@vlanex: 1 to enable hardware VLAN Tag extraction, 0 to disable it,
  *		-1 no change
+ *	@sleep_ok: call is allowed to sleep
  *
  *	Sets Rx properties of a virtual interface.
  */
@@ -1906,7 +1905,7 @@ static const char *t4vf_link_down_rc_str(unsigned char link_down_rc)
 /**
  *	t4vf_handle_get_port_info - process a FW reply message
  *	@pi: the port info
- *	@rpl: start of the FW message
+ *	@cmd: start of the FW message
  *
  *	Processes a GET_PORT_INFO FW reply message.
  */
@@ -2137,8 +2136,6 @@ int t4vf_handle_fw_rpl(struct adapter *adapter, const __be64 *rpl)
 	return 0;
 }
 
-/**
- */
 int t4vf_prep_adapter(struct adapter *adapter)
 {
 	int err;
-- 
2.24.0

