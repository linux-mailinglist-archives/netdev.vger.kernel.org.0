Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0075F6C462A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjCVJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCVJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:20:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0A29E14;
        Wed, 22 Mar 2023 02:20:18 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32M8XRtl027403;
        Wed, 22 Mar 2023 02:20:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=sczwnxoCvL2raUkFhq+sEe5qC2q7l60RfpvDnTIMfhQ=;
 b=R6V/260SCiPqtuEAGIfWm0urGC3j6bIXi/jD0VQ3fz8RzTvPnAtR4UIZgsJD0/mDBl1G
 /pqYutUdraXlpp7X+3Dbue7VXoL5hJxe16/cvUtl7GF1PQI3ARJzH4X0MrTNVy/m4bGi
 slnj7VbQPY/J6ZzdFhoSK6QXT1PgL1QU6r+BPFJfChU7FjiVTrX2PA5K/UtlSPUa/99i
 2LjE9ul9NEjYpNjv9KOc3kKVeXjiAwndH0AAd8NL8Rdhl3mfD4eMpcvq3L6Tdbr/JMrk
 fNIXze9uCSdiOAXYunWdMsLu/P9dIDf/rWFYGZyAo8YVboXbfgYXOLXH3XiuN3DBWtdY SQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pfx91g553-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 02:20:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 22 Mar
 2023 02:20:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 22 Mar 2023 02:20:08 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 2DFEB5B6934;
        Wed, 22 Mar 2023 02:20:08 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v4 5/8] octeon_ep: include function id in mailbox commands
Date:   Wed, 22 Mar 2023 02:19:54 -0700
Message-ID: <20230322091958.13103-6-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230322091958.13103-1-vburru@marvell.com>
References: <20230322091958.13103-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ln5DebkGEsZnJt3Jxc2tiRWIWR_LoAUp
X-Proofpoint-ORIG-GUID: ln5DebkGEsZnJt3Jxc2tiRWIWR_LoAUp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_06,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend control command structure to include vfid and
update APIs to accept VF ID.

Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
---
v3 -> v4:
 * address review comments
   https://lore.kernel.org/all/Y+0AW3b9No9pyWrr@boxer/
 * subset of 0004-xxx.patch moved to this new patch.

 .../marvell/octeon_ep/octep_ctrl_net.c        | 43 +++++++++++--------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 28 ++++++++----
 .../marvell/octeon_ep/octep_ethtool.c         |  7 +--
 .../ethernet/marvell/octeon_ep/octep_main.c   | 24 +++++++----
 4 files changed, 63 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 8d4d74e18a67..cef4bc3b1ec0 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -22,7 +22,8 @@ static const u32 link_info_sz = sizeof(struct octep_ctrl_net_link_info);
 static const u32 get_stats_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_get_stats);
 static atomic_t ctrl_net_msg_id;
 
-static void init_send_req(struct octep_ctrl_mbox_msg *msg, void *buf, u16 sz)
+static void init_send_req(struct octep_ctrl_mbox_msg *msg, void *buf,
+			  u16 sz, int vfid)
 {
 	msg->hdr.s.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
 	msg->hdr.s.msg_id = atomic_inc_return(&ctrl_net_msg_id) &
@@ -31,6 +32,10 @@ static void init_send_req(struct octep_ctrl_mbox_msg *msg, void *buf, u16 sz)
 	msg->sg_num = 1;
 	msg->sg_list[0].msg = buf;
 	msg->sg_list[0].sz = msg->hdr.s.sz;
+	if (vfid != OCTEP_CTRL_NET_INVALID_VFID) {
+		msg->hdr.s.is_vf = 1;
+		msg->hdr.s.vf_idx = vfid;
+	}
 }
 
 static int octep_send_mbox_req(struct octep_device *oct,
@@ -91,13 +96,13 @@ int octep_ctrl_net_init(struct octep_device *oct)
 	return 0;
 }
 
-int octep_ctrl_net_get_link_status(struct octep_device *oct)
+int octep_ctrl_net_get_link_status(struct octep_device *oct, int vfid)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 	int err;
 
-	init_send_req(&d.msg, (void *)req, state_sz);
+	init_send_req(&d.msg, (void *)req, state_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
 	req->link.cmd = OCTEP_CTRL_NET_CMD_GET;
 	err = octep_send_mbox_req(oct, &d, true);
@@ -107,13 +112,13 @@ int octep_ctrl_net_get_link_status(struct octep_device *oct)
 	return d.data.resp.link.state;
 }
 
-int octep_ctrl_net_set_link_status(struct octep_device *oct, bool up,
+int octep_ctrl_net_set_link_status(struct octep_device *oct, int vfid, bool up,
 				   bool wait_for_response)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	init_send_req(&d.msg, req, state_sz);
+	init_send_req(&d.msg, req, state_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
 	req->link.cmd = OCTEP_CTRL_NET_CMD_SET;
 	req->link.state = (up) ? OCTEP_CTRL_NET_STATE_UP :
@@ -122,13 +127,13 @@ int octep_ctrl_net_set_link_status(struct octep_device *oct, bool up,
 	return octep_send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_ctrl_net_set_rx_state(struct octep_device *oct, bool up,
+int octep_ctrl_net_set_rx_state(struct octep_device *oct, int vfid, bool up,
 				bool wait_for_response)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	init_send_req(&d.msg, req, state_sz);
+	init_send_req(&d.msg, req, state_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
 	req->link.cmd = OCTEP_CTRL_NET_CMD_SET;
 	req->link.state = (up) ? OCTEP_CTRL_NET_STATE_UP :
@@ -137,13 +142,13 @@ int octep_ctrl_net_set_rx_state(struct octep_device *oct, bool up,
 	return octep_send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_ctrl_net_get_mac_addr(struct octep_device *oct, u8 *addr)
+int octep_ctrl_net_get_mac_addr(struct octep_device *oct, int vfid, u8 *addr)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 	int err;
 
-	init_send_req(&d.msg, req, mac_sz);
+	init_send_req(&d.msg, req, mac_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
 	req->link.cmd = OCTEP_CTRL_NET_CMD_GET;
 	err = octep_send_mbox_req(oct, &d, true);
@@ -155,13 +160,13 @@ int octep_ctrl_net_get_mac_addr(struct octep_device *oct, u8 *addr)
 	return 0;
 }
 
-int octep_ctrl_net_set_mac_addr(struct octep_device *oct, u8 *addr,
+int octep_ctrl_net_set_mac_addr(struct octep_device *oct, int vfid, u8 *addr,
 				bool wait_for_response)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	init_send_req(&d.msg, req, mac_sz);
+	init_send_req(&d.msg, req, mac_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
 	req->mac.cmd = OCTEP_CTRL_NET_CMD_SET;
 	memcpy(&req->mac.addr, addr, ETH_ALEN);
@@ -169,13 +174,13 @@ int octep_ctrl_net_set_mac_addr(struct octep_device *oct, u8 *addr,
 	return octep_send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_ctrl_net_set_mtu(struct octep_device *oct, int mtu,
+int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
 			   bool wait_for_response)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	init_send_req(&d.msg, req, mtu_sz);
+	init_send_req(&d.msg, req, mtu_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
 	req->mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
 	req->mtu.val = mtu;
@@ -183,7 +188,7 @@ int octep_ctrl_net_set_mtu(struct octep_device *oct, int mtu,
 	return octep_send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_ctrl_net_get_if_stats(struct octep_device *oct)
+int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
@@ -191,7 +196,7 @@ int octep_ctrl_net_get_if_stats(struct octep_device *oct)
 	void __iomem *iface_tx_stats;
 	int err;
 
-	init_send_req(&d.msg, req, get_stats_sz);
+	init_send_req(&d.msg, req, get_stats_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
 	req->get_stats.offset = oct->ctrl_mbox_ifstats_offset;
 	err = octep_send_mbox_req(oct, &d, true);
@@ -207,14 +212,14 @@ int octep_ctrl_net_get_if_stats(struct octep_device *oct)
 	return 0;
 }
 
-int octep_ctrl_net_get_link_info(struct octep_device *oct)
+int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 	struct octep_ctrl_net_h2f_resp *resp;
 	int err;
 
-	init_send_req(&d.msg, req, link_info_sz);
+	init_send_req(&d.msg, req, link_info_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
 	req->link_info.cmd = OCTEP_CTRL_NET_CMD_GET;
 	err = octep_send_mbox_req(oct, &d, true);
@@ -231,14 +236,14 @@ int octep_ctrl_net_get_link_info(struct octep_device *oct)
 	return 0;
 }
 
-int octep_ctrl_net_set_link_info(struct octep_device *oct,
+int octep_ctrl_net_set_link_info(struct octep_device *oct, int vfid,
 				 struct octep_iface_link_info *link_info,
 				 bool wait_for_response)
 {
 	struct octep_ctrl_net_wait_data d = {0};
 	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	init_send_req(&d.msg, req, link_info_sz);
+	init_send_req(&d.msg, req, link_info_sz, vfid);
 	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
 	req->link_info.cmd = OCTEP_CTRL_NET_CMD_SET;
 	req->link_info.info.advertised_modes = link_info->advertised_modes;
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
index aba373ec28a4..de0759365f13 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
@@ -7,6 +7,8 @@
 #ifndef __OCTEP_CTRL_NET_H__
 #define __OCTEP_CTRL_NET_H__
 
+#define OCTEP_CTRL_NET_INVALID_VFID	(-1)
+
 /* Supported commands */
 enum octep_ctrl_net_cmd {
 	OCTEP_CTRL_NET_CMD_GET = 0,
@@ -216,89 +218,99 @@ int octep_ctrl_net_init(struct octep_device *oct);
 /** Get link status from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  *
  * return value: link status 0=down, 1=up.
  */
-int octep_ctrl_net_get_link_status(struct octep_device *oct);
+int octep_ctrl_net_get_link_status(struct octep_device *oct, int vfid);
 
 /** Set link status in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param up: boolean status.
  * @param wait_for_response: poll for response.
  *
  * return value: 0 on success, -errno on failure
  */
-int octep_ctrl_net_set_link_status(struct octep_device *oct, bool up,
+int octep_ctrl_net_set_link_status(struct octep_device *oct, int vfid, bool up,
 				   bool wait_for_response);
 
 /** Set rx state in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param up: boolean status.
  * @param wait_for_response: poll for response.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_set_rx_state(struct octep_device *oct, bool up,
+int octep_ctrl_net_set_rx_state(struct octep_device *oct, int vfid, bool up,
 				bool wait_for_response);
 
 /** Get mac address from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param addr: non-null pointer to mac address.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_get_mac_addr(struct octep_device *oct, u8 *addr);
+int octep_ctrl_net_get_mac_addr(struct octep_device *oct, int vfid, u8 *addr);
 
 /** Set mac address in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param addr: non-null pointer to mac address.
  * @param wait_for_response: poll for response.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_set_mac_addr(struct octep_device *oct, u8 *addr,
+int octep_ctrl_net_set_mac_addr(struct octep_device *oct, int vfid, u8 *addr,
 				bool wait_for_response);
 
 /** Set mtu in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param mtu: mtu.
  * @param wait_for_response: poll for response.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_set_mtu(struct octep_device *oct, int mtu,
+int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
 			   bool wait_for_response);
 
 /** Get interface statistics from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_get_if_stats(struct octep_device *oct);
+int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid);
 
 /** Get link info from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_ctrl_net_get_link_info(struct octep_device *oct);
+int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid);
 
 /** Set link info in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param link_info: non-null pointer to struct octep_iface_link_info.
  * @param wait_for_response: poll for response.
  *
  * return value: 0 on success, -errno on failure.
  */
 int octep_ctrl_net_set_link_info(struct octep_device *oct,
+				 int vfid,
 				 struct octep_iface_link_info *link_info,
 				 bool wait_for_response);
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
index a1ddb64791f2..389042b57787 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
@@ -150,7 +150,7 @@ octep_get_ethtool_stats(struct net_device *netdev,
 	rx_packets = 0;
 	rx_bytes = 0;
 
-	octep_ctrl_net_get_if_stats(oct);
+	octep_ctrl_net_get_if_stats(oct, OCTEP_CTRL_NET_INVALID_VFID);
 	iface_tx_stats = &oct->iface_tx_stats;
 	iface_rx_stats = &oct->iface_rx_stats;
 
@@ -283,7 +283,7 @@ static int octep_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 
-	octep_ctrl_net_get_link_info(oct);
+	octep_ctrl_net_get_link_info(oct, OCTEP_CTRL_NET_INVALID_VFID);
 
 	advertised_modes = oct->link_info.advertised_modes;
 	supported_modes = oct->link_info.supported_modes;
@@ -439,7 +439,8 @@ static int octep_set_link_ksettings(struct net_device *netdev,
 	link_info_new.speed = cmd->base.speed;
 	link_info_new.autoneg = autoneg;
 
-	err = octep_ctrl_net_set_link_info(oct, &link_info_new, true);
+	err = octep_ctrl_net_set_link_info(oct, OCTEP_CTRL_NET_INVALID_VFID,
+					   &link_info_new, true);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 43fff8979854..112d3825e544 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -507,8 +507,10 @@ static int octep_open(struct net_device *netdev)
 	octep_napi_enable(oct);
 
 	oct->link_info.admin_up = 1;
-	octep_ctrl_net_set_rx_state(oct, true, false);
-	octep_ctrl_net_set_link_status(oct, true, false);
+	octep_ctrl_net_set_rx_state(oct, OCTEP_CTRL_NET_INVALID_VFID, true,
+				    false);
+	octep_ctrl_net_set_link_status(oct, OCTEP_CTRL_NET_INVALID_VFID, true,
+				       false);
 	oct->poll_non_ioq_intr = false;
 
 	/* Enable the input and output queues for this Octeon device */
@@ -519,7 +521,7 @@ static int octep_open(struct net_device *netdev)
 
 	octep_oq_dbell_init(oct);
 
-	ret = octep_ctrl_net_get_link_status(oct);
+	ret = octep_ctrl_net_get_link_status(oct, OCTEP_CTRL_NET_INVALID_VFID);
 	if (ret > 0)
 		octep_link_up(netdev);
 
@@ -549,8 +551,10 @@ static int octep_stop(struct net_device *netdev)
 
 	netdev_info(netdev, "Stopping the device ...\n");
 
-	octep_ctrl_net_set_link_status(oct, false, false);
-	octep_ctrl_net_set_rx_state(oct, false, false);
+	octep_ctrl_net_set_link_status(oct, OCTEP_CTRL_NET_INVALID_VFID, false,
+				       false);
+	octep_ctrl_net_set_rx_state(oct, OCTEP_CTRL_NET_INVALID_VFID, false,
+				    false);
 
 	/* Stop Tx from stack */
 	netif_tx_stop_all_queues(netdev);
@@ -759,7 +763,7 @@ static void octep_get_stats64(struct net_device *netdev,
 	int q;
 
 	if (netif_running(netdev))
-		octep_ctrl_net_get_if_stats(oct);
+		octep_ctrl_net_get_if_stats(oct, OCTEP_CTRL_NET_INVALID_VFID);
 
 	tx_packets = 0;
 	tx_bytes = 0;
@@ -831,7 +835,8 @@ static int octep_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	err = octep_ctrl_net_set_mac_addr(oct, addr->sa_data, true);
+	err = octep_ctrl_net_set_mac_addr(oct, OCTEP_CTRL_NET_INVALID_VFID,
+					  addr->sa_data, true);
 	if (err)
 		return err;
 
@@ -851,7 +856,8 @@ static int octep_change_mtu(struct net_device *netdev, int new_mtu)
 	if (link_info->mtu == new_mtu)
 		return 0;
 
-	err = octep_ctrl_net_set_mtu(oct, new_mtu, true);
+	err = octep_ctrl_net_set_mtu(oct, OCTEP_CTRL_NET_INVALID_VFID, new_mtu,
+				     true);
 	if (!err) {
 		oct->link_info.mtu = new_mtu;
 		netdev->mtu = new_mtu;
@@ -1102,7 +1108,7 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->max_mtu = OCTEP_MAX_MTU;
 	netdev->mtu = OCTEP_DEFAULT_MTU;
 
-	err = octep_ctrl_net_get_mac_addr(octep_dev,
+	err = octep_ctrl_net_get_mac_addr(octep_dev, OCTEP_CTRL_NET_INVALID_VFID,
 					  octep_dev->mac_addr);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to get mac address\n");
-- 
2.36.0

