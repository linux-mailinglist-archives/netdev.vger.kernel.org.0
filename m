Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EC42B595D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 06:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgKQFiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 00:38:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62993 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgKQFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 00:38:09 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201117053804epoutp043fa00032812b7de4c5fcb83857018a4a~INPLQlLjl0457104571epoutp04i
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 05:38:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201117053804epoutp043fa00032812b7de4c5fcb83857018a4a~INPLQlLjl0457104571epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605591484;
        bh=ZGu+C1Pv/M4NO1wCJwQlyriHGg8iK7U2CD5tZVIy8GI=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=gcXhpE3zH425gjrQAeu95744Ui4X3vgKG2050KQch/2AR/o77vj7zGrGjE0No2OVK
         lrknWmGypMm32LA+xtviMnJ84M7DAedz4okYJRWhvcWFd4F3Cc7O+OnK2xABtCiDdX
         i3zNGnzNDyIGGsBd7qSf9EG3H3BEqq10/Xxrq2rU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201117053804epcas2p1c3f4fef30c31d033e362bac54e5086c2~INPK9kEU60510005100epcas2p1X;
        Tue, 17 Nov 2020 05:38:04 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CZvqG5WLkzMqYkh; Tue, 17 Nov
        2020 05:38:02 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-0c-5fb361b7efd8
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.F1.56312.7B163BF5; Tue, 17 Nov 2020 14:37:59 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next] net/nfc/nci: Support NCI 2.x initial sequence
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8>
Date:   Tue, 17 Nov 2020 14:37:59 +0900
X-CMS-MailID: 20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmme72xM3xBu3ntCy2NE9it5hzvoXF
        4sK2PlaLy7vmsFkcWyDmwOqxZeVNJo9NqzrZPPq2rGL0+LxJLoAlKscmIzUxJbVIITUvOT8l
        My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd/Opii/
        tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ6P5UC97weWQipcbZjI2
        MD5w7WLk5JAQMJHY/baZvYuRi0NIYAejxN5PO1m7GDk4eAUEJf7uEAapERZwl/jUO5UZxBYS
        UJT433GODSKuK/Hi71Ewm01AW2Lt0UYmEFtEIExi7ssusDizQJnE8UcbmCB28UrMaH/KAmFL
        S2xfvpURwtaQ+LGslxnCFpW4ufotO4z9/th8qBoRidZ7Z6FqBCUe/NwNFZeUeLtvHtj9EgLt
        jBLnf/5gg3BmMEqc2vwXqkNfYvG5FWBX8Ar4Snz7dZYVxGYRUJW49XAZK0SNi8T8Hy1QV8tL
        bH87hxkUEMwCmhLrd+mDmBICyhJHbrFAVPBJdBz+yw7z1455T6B+VJXobf7CBPPj5NktUHd6
        SJz72QwNw0CJw7s3ME9gVJiFCOlZSPbOQti7gJF5FaNYakFxbnpqsVGBEXLkbmIEJ0Ettx2M
        U95+0DvEyMTBeIhRgoNZSYTXxWRjvBBvSmJlVWpRfnxRaU5q8SFGU6CPJzJLiSbnA9NwXkm8
        oamRmZmBpamFqZmRhZI4b+jKvnghgfTEktTs1NSC1CKYPiYOTqkGpv0fkvjTyhME3+6cK5d5
        7l9GpqRkztoJme6906zc5n3Nca9oT3nrvXPx0lP735W8Nr2wjLdtdbjBwrRZVT5TL/400PRa
        63BfnZvvb+qvFcrfT82Yut5m8v71K04wZfGetDDgKW/IesEi++1/2ZGOwxqRSiyt/8qj9l2W
        ev1e/aTp9WULzvnuf7Pu74lz2no7p0xfUSF6xrJsply87852xaDTIk3Bc7j3TBc8xCHHlFTK
        8vKA1pyKeQ8ZuNny12lVHjzB88Cqzy+KfZLx0/uzJvreSir/ufTnnr5tmxt7S59w5MjN+pK+
        qsRHj/dZ5iOJ1PfZj047N3xnd0pRttUK0fzdU5NoefNS4deCCYUvLZVYijMSDbWYi4oTAe7+
        ZesLBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7
References: <CGME20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.

In NCI 1.0, Initial sequence and payloads are as below:
(DH)                     (NFCC)
 |  -- CORE_RESET_CMD --> |
 |  <-- CORE_RESET_RSP -- |
 |  -- CORE_INIT_CMD -->  |
 |  <-- CORE_INIT_RSP --  |
 CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
 CORE_INIT_CMD payloads are empty.
 CORE_INIT_RSP payloads are Status, NFCC Features,
    Number of Supported RF Interfaces, Supported RF Interface,
    Max Logical Connections, Max Routing table Size,
    Max Control Packet Payload Size, Max Size for Large Parameters,
    Manufacturer ID, Manufacturer Specific Information.

In NCI 2.0, Initial Sequence and Parameters are as below:
(DH)                     (NFCC)
 |  -- CORE_RESET_CMD --> |
 |  <-- CORE_RESET_RSP -- |
 |  <-- CORE_RESET_NTF -- |
 |  -- CORE_INIT_CMD -->  |
 |  <-- CORE_INIT_RSP --  |
 CORE_RESET_RSP payloads are Status.
 CORE_RESET_NTF payloads are Reset Trigger,
    Configuration Status, NCI Version, Manufacturer ID,
    Manufacturer Specific Information Length,
    Manufacturer Specific Information.
 CORE_INIT_CMD payloads are Feature1, Feature2.
 CORE_INIT_RSP payloads are Status, NFCC Features,
    Max Logical Connections, Max Routing Table Size,
    Max Control Packet Payload Size,
    Max Data Packet Payload Size of the Static HCI Connection,
    Number of Credits of the Static HCI Connection,
    Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
    Supported RF Interfaces.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 include/net/nfc/nci.h | 39 ++++++++++++++++++++++
 net/nfc/nci/core.c    | 23 +++++++++++--
 net/nfc/nci/ntf.c     | 21 ++++++++++++
 net/nfc/nci/rsp.c     | 75 +++++++++++++++++++++++++++++++++++++------
 4 files changed, 146 insertions(+), 12 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 0550e0380b8d..b434f984bc8c 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -25,6 +25,8 @@
 #define NCI_MAX_PARAM_LEN					251
 #define NCI_MAX_PAYLOAD_SIZE					255
 #define NCI_MAX_PACKET_SIZE					258
+#define NCI_MAX_LARGE_PARAMS_NCI_v2				15
+#define NCI_VER_2_MASK						0x20
 
 /* NCI Status Codes */
 #define NCI_STATUS_OK						0x00
@@ -131,6 +133,9 @@
 #define NCI_LF_CON_BITR_F_212					0x02
 #define NCI_LF_CON_BITR_F_424					0x04
 
+/* NCI 2.x Feature Enable Bit */
+#define NCI_FEATURE_DISABLE					0x00
+
 /* NCI Reset types */
 #define NCI_RESET_TYPE_KEEP_CONFIG				0x00
 #define NCI_RESET_TYPE_RESET_CONFIG				0x01
@@ -220,6 +225,11 @@ struct nci_core_reset_cmd {
 } __packed;
 
 #define NCI_OP_CORE_INIT_CMD		nci_opcode_pack(NCI_GID_CORE, 0x01)
+/* To support NCI 2.x */
+struct nci_core_init_v2_cmd {
+	__u8	feature1;
+	__u8	feature2;
+} __packed;
 
 #define NCI_OP_CORE_SET_CONFIG_CMD	nci_opcode_pack(NCI_GID_CORE, 0x02)
 struct set_config_param {
@@ -316,6 +326,11 @@ struct nci_core_reset_rsp {
 	__u8	config_status;
 } __packed;
 
+/* To support NCI ver 2.x */
+struct nci_core_reset_rsp_nci_ver2 {
+	__u8	status;
+} __packed;
+
 #define NCI_OP_CORE_INIT_RSP		nci_opcode_pack(NCI_GID_CORE, 0x01)
 struct nci_core_init_rsp_1 {
 	__u8	status;
@@ -334,6 +349,20 @@ struct nci_core_init_rsp_2 {
 	__le32	manufact_specific_info;
 } __packed;
 
+/* To support NCI ver 2.x */
+struct nci_core_init_rsp_nci_ver2 {
+	__u8	status;
+	__le32	nfcc_features;
+	__u8	max_logical_connections;
+	__le16	max_routing_table_size;
+	__u8	max_ctrl_pkt_payload_len;
+	__u8	max_data_pkt_hci_payload_len;
+	__u8	number_of_hci_credit;
+	__le16	max_nfc_v_frame_size;
+	__u8	num_supported_rf_interfaces;
+	__u8	supported_rf_interfaces[];
+} __packed;
+
 #define NCI_OP_CORE_SET_CONFIG_RSP	nci_opcode_pack(NCI_GID_CORE, 0x02)
 struct nci_core_set_config_rsp {
 	__u8	status;
@@ -372,6 +401,16 @@ struct nci_nfcee_discover_rsp {
 /* --------------------------- */
 /* ---- NCI Notifications ---- */
 /* --------------------------- */
+#define NCI_OP_CORE_RESET_NTF		nci_opcode_pack(NCI_GID_CORE, 0x00)
+struct nci_core_reset_ntf {
+	__u8	reset_trigger;
+	__u8	config_status;
+	__u8	nci_ver;
+	__u8	manufact_id;
+	__u8	manufacturer_specific_len;
+	__u32	manufact_specific_info;
+} __packed;
+
 #define NCI_OP_CORE_CONN_CREDITS_NTF	nci_opcode_pack(NCI_GID_CORE, 0x06)
 struct conn_credit_entry {
 	__u8	conn_id;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 4953ee5146e1..68889faadda2 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -165,7 +165,14 @@ static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
 
 static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
 {
-	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
+	struct nci_core_init_v2_cmd *cmd = (struct nci_core_init_v2_cmd *)opt;
+
+	if (!cmd) {
+		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
+	} else {
+		/* if nci version is 2.0, then use the feature parameters */
+		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, sizeof(struct nci_core_init_v2_cmd), cmd);
+	}
 }
 
 static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
@@ -497,8 +504,18 @@ static int nci_open_device(struct nci_dev *ndev)
 	}
 
 	if (!rc) {
-		rc = __nci_request(ndev, nci_init_req, 0,
-				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
+		if (!(ndev->nci_ver & NCI_VER_2_MASK)) {
+			rc = __nci_request(ndev, nci_init_req, 0,
+					   msecs_to_jiffies(NCI_INIT_TIMEOUT));
+		} else {
+			struct nci_core_init_v2_cmd nci_init_v2_cmd;
+
+			nci_init_v2_cmd.feature1 = NCI_FEATURE_DISABLE;
+			nci_init_v2_cmd.feature2 = NCI_FEATURE_DISABLE;
+
+			rc = __nci_request(ndev, nci_init_req, (unsigned long)&nci_init_v2_cmd,
+					   msecs_to_jiffies(NCI_INIT_TIMEOUT));
+		}
 	}
 
 	if (!rc && ndev->ops->post_setup)
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 33e1170817f0..98af04c86b2c 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -27,6 +27,23 @@
 
 /* Handle NCI Notification packets */
 
+static void nci_core_reset_ntf_packet(struct nci_dev *ndev,
+				      struct sk_buff *skb)
+{
+	/* Handle NCI 2.x core reset notification */
+	struct nci_core_reset_ntf *ntf = (void *)skb->data;
+
+	ndev->nci_ver = ntf->nci_ver;
+	pr_debug("nci_ver 0x%x, config_status 0x%x\n",
+		 ntf->nci_ver, ntf->config_status);
+
+	ndev->manufact_id = ntf->manufact_id;
+	ndev->manufact_specific_info =
+		__le32_to_cpu(ntf->manufact_specific_info);
+
+	nci_req_complete(ndev, NCI_STATUS_OK);
+}
+
 static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 					     struct sk_buff *skb)
 {
@@ -756,6 +773,10 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	}
 
 	switch (ntf_opcode) {
+	case NCI_OP_CORE_RESET_NTF:
+		nci_core_reset_ntf_packet(ndev, skb);
+		break;
+
 	case NCI_OP_CORE_CONN_CREDITS_NTF:
 		nci_core_conn_credits_ntf_packet(ndev, skb);
 		break;
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index a48297b79f34..dcb371d7923b 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -31,16 +31,19 @@ static void nci_core_reset_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 
 	pr_debug("status 0x%x\n", rsp->status);
 
-	if (rsp->status == NCI_STATUS_OK) {
-		ndev->nci_ver = rsp->nci_ver;
-		pr_debug("nci_ver 0x%x, config_status 0x%x\n",
-			 rsp->nci_ver, rsp->config_status);
-	}
+	/* Handle NCI 1.x ver */
+	if (skb->len != 1) {
+		if (rsp->status == NCI_STATUS_OK) {
+			ndev->nci_ver = rsp->nci_ver;
+			pr_debug("nci_ver 0x%x, config_status 0x%x\n",
+				 rsp->nci_ver, rsp->config_status);
+		}
 
-	nci_req_complete(ndev, rsp->status);
+		nci_req_complete(ndev, rsp->status);
+	}
 }
 
-static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+static __u8 nci_core_init_rsp_packet_v1(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct nci_core_init_rsp_1 *rsp_1 = (void *) skb->data;
 	struct nci_core_init_rsp_2 *rsp_2;
@@ -48,7 +51,7 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	pr_debug("status 0x%x\n", rsp_1->status);
 
 	if (rsp_1->status != NCI_STATUS_OK)
-		goto exit;
+		return rsp_1->status;
 
 	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
 	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
@@ -77,6 +80,60 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	ndev->manufact_specific_info =
 		__le32_to_cpu(rsp_2->manufact_specific_info);
 
+	return NCI_STATUS_OK;
+}
+
+static __u8 nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
+	__u8 rf_interface_idx = 0;
+	__u8 rf_extension_cnt = 0;
+	__u8 *supported_rf_interface = rsp->supported_rf_interfaces;
+
+	pr_debug("status %x\n", rsp->status);
+
+	if (rsp->status != NCI_STATUS_OK)
+		return rsp->status;
+
+	ndev->nfcc_features = __le32_to_cpu(rsp->nfcc_features);
+	ndev->num_supported_rf_interfaces = rsp->num_supported_rf_interfaces;
+
+	if (ndev->num_supported_rf_interfaces >
+	    NCI_MAX_SUPPORTED_RF_INTERFACES) {
+		ndev->num_supported_rf_interfaces =
+			NCI_MAX_SUPPORTED_RF_INTERFACES;
+	}
+
+	while (rf_interface_idx < ndev->num_supported_rf_interfaces) {
+		ndev->supported_rf_interfaces[rf_interface_idx] = *supported_rf_interface++;
+
+		/* skip rf extension parameters */
+		rf_extension_cnt = *supported_rf_interface++;
+		supported_rf_interface += rf_extension_cnt;
+	}
+
+	ndev->max_logical_connections = rsp->max_logical_connections;
+	ndev->max_routing_table_size =
+			__le16_to_cpu(rsp->max_routing_table_size);
+	ndev->max_ctrl_pkt_payload_len =
+			rsp->max_ctrl_pkt_payload_len;
+	ndev->max_size_for_large_params = NCI_MAX_LARGE_PARAMS_NCI_v2;
+
+	return NCI_STATUS_OK;
+}
+
+static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	__u8 status = 0;
+
+	if (!(ndev->nci_ver & NCI_VER_2_MASK))
+		status = nci_core_init_rsp_packet_v1(ndev, skb);
+	else
+		status = nci_core_init_rsp_packet_v2(ndev, skb);
+
+	if (status != NCI_STATUS_OK)
+		goto exit;
+
 	pr_debug("nfcc_features 0x%x\n",
 		 ndev->nfcc_features);
 	pr_debug("num_supported_rf_interfaces %d\n",
@@ -103,7 +160,7 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 ndev->manufact_specific_info);
 
 exit:
-	nci_req_complete(ndev, rsp_1->status);
+	nci_req_complete(ndev, status);
 }
 
 static void nci_core_set_config_rsp_packet(struct nci_dev *ndev,
-- 
2.17.1

