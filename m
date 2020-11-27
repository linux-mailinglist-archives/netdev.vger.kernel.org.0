Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BDE2C66F8
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 14:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgK0Ngp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 08:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgK0Ngp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 08:36:45 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8447DC0613D1;
        Fri, 27 Nov 2020 05:36:45 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so4639832pfu.1;
        Fri, 27 Nov 2020 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:to:cc:subject:date;
        bh=+5xvuHx9xFZP0w6JZXyPvv5kaP3Y+SZFb5tatXkOPiE=;
        b=SubS628TLmKjZLZrVGX550O5mHeqxbAusVZ0WZGTGtdFXKCEoTsFiv2ak90Zw3Mj5D
         0LJTyeQWC3AthsnQSaHJ3TywvWlGeozGa7tOibcWmD2dXcQ77TeE0OtwD17Y3YUulLfw
         kOcRXmcxvbLAkD6Oqhnqp2xwMCtz1C6eEfiSau9hORTqAY0qUQz+mXslOzEGQdXrWuMO
         qx+uRBsWNXaRGTCt2L4tOmMXXN1Sq7G2aSGonwuMI9h34ywzxaDiYOpBmbyLlYheMcld
         7J5as+M1WXcLeITG8tbDk9dg76kFKbVllx4m5zlXfScEWIXI2qdldP576JLrj67h2/3U
         wATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:date;
        bh=+5xvuHx9xFZP0w6JZXyPvv5kaP3Y+SZFb5tatXkOPiE=;
        b=OJSw1/fth0T3fmKRZ2G/QGJWwTs95VeN9y42HQjrnSzGsjKboVHG0CF5eCEzNSGPAF
         yZm/IXmSOEsG+o6XDQU3uaLi5yRSJz4fwrlSYDS0T1S+eP6BOBaSQ8q0mJdpwKmOU9UD
         V5rjjIo+vVQoiA1J8jSclIiYzl++mPlM548T7oqES4CDqwG7OW9iP+aWZFmISZPVJyuV
         RriOyZy9QK5QokWUEFWpREAtgwVuqlJffE/CpJJlmiNDD86k8PMbSjDCPlfiW2cxkPNZ
         cppv68ZuwjRywK/ftjzZGGfdq8bXrz5Bgca3GlAAY5RydD1OnYoOZ7+3PAVkmazeb609
         B23g==
X-Gm-Message-State: AOAM531u6QVm6l6NrwdqSaGo/gjEyzCcpjhFmMdey8PJuZjPzBrptttN
        sLGR6ZV3aYIMagt20P7uZ/Q=
X-Google-Smtp-Source: ABdhPJzR+bw8M+Wf/aokO2yVHP8li/tSZy8bwH9lW7wrGbR1ErRkNulR6//yde8OrpfO/foxpCJNoA==
X-Received: by 2002:a62:1c96:0:b029:198:1cb6:26bd with SMTP id c144-20020a621c960000b02901981cb626bdmr7102563pfc.33.1606484205004;
        Fri, 27 Nov 2020 05:36:45 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id p127sm7846980pfp.93.2020.11.27.05.36.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Nov 2020 05:36:44 -0800 (PST)
Message-ID: <5fc100ec.1c69fb81.58b7b.2dee@mx.google.com>
X-Google-Original-Message-ID: <1606484191-6069-1-git-send-email-Bongsu.Jeon>
From:   bongsu.jeon2@gmail.com
X-Google-Original-From: Bongsu.Jeon
To:     kuba@kernel.org
Cc:     linux-nfc@lists.01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v3] net/nfc/nci: Support NCI 2.x initial sequence
Date:   Fri, 27 Nov 2020 22:36:31 +0900
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

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
 Changes in v3:
  - remove the unused struct nci_core_reset_rsp_nci_ver2.
  - remove the __packed because of no need.
  - remove the unnecessary brackets.
  - change the asignment code for ndev->num_supported_rf_interfaces.

 Changes in v2:
  - fix the warning of type casting.
  - changed the __u8 type to unsigned char.

 include/net/nfc/nci.h | 34 +++++++++++++++++++++
 net/nfc/nci/core.c    | 24 +++++++++++++--
 net/nfc/nci/ntf.c     | 21 +++++++++++++
 net/nfc/nci/rsp.c     | 81 ++++++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 143 insertions(+), 17 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 0550e0380..825c6d2 100644
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
+	unsigned char	feature1;
+	unsigned char	feature2;
+};
 
 #define NCI_OP_CORE_SET_CONFIG_CMD	nci_opcode_pack(NCI_GID_CORE, 0x02)
 struct set_config_param {
@@ -334,6 +344,20 @@ struct nci_core_init_rsp_2 {
 	__le32	manufact_specific_info;
 } __packed;
 
+/* To support NCI ver 2.x */
+struct nci_core_init_rsp_nci_ver2 {
+	unsigned char	status;
+	__le32	nfcc_features;
+	unsigned char	max_logical_connections;
+	__le16	max_routing_table_size;
+	unsigned char	max_ctrl_pkt_payload_len;
+	unsigned char	max_data_pkt_hci_payload_len;
+	unsigned char	number_of_hci_credit;
+	__le16	max_nfc_v_frame_size;
+	unsigned char	num_supported_rf_interfaces;
+	unsigned char	supported_rf_interfaces[];
+} __packed;
+
 #define NCI_OP_CORE_SET_CONFIG_RSP	nci_opcode_pack(NCI_GID_CORE, 0x02)
 struct nci_core_set_config_rsp {
 	__u8	status;
@@ -372,6 +396,16 @@ struct nci_nfcee_discover_rsp {
 /* --------------------------- */
 /* ---- NCI Notifications ---- */
 /* --------------------------- */
+#define NCI_OP_CORE_RESET_NTF		nci_opcode_pack(NCI_GID_CORE, 0x00)
+struct nci_core_reset_ntf {
+	unsigned char	reset_trigger;
+	unsigned char	config_status;
+	unsigned char	nci_ver;
+	unsigned char	manufact_id;
+	unsigned char	manufacturer_specific_len;
+	__le32	manufact_specific_info;
+} __packed;
+
 #define NCI_OP_CORE_CONN_CREDITS_NTF	nci_opcode_pack(NCI_GID_CORE, 0x06)
 struct conn_credit_entry {
 	__u8	conn_id;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 4953ee5..b1ad276 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -165,7 +165,15 @@ static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
 
 static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
 {
-	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
+	struct nci_core_init_v2_cmd *cmd = (struct nci_core_init_v2_cmd *)opt;
+
+	if (!cmd)
+		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
+	else
+		/* if nci version is 2.0, then use the feature parameters */
+		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD,
+			     sizeof(struct nci_core_init_v2_cmd), cmd);
+
 }
 
 static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
@@ -497,8 +505,18 @@ static int nci_open_device(struct nci_dev *ndev)
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
index 33e1170..98af04c 100644
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
index a48297b..ea9e603 100644
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
+static unsigned char nci_core_init_rsp_packet_v1(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct nci_core_init_rsp_1 *rsp_1 = (void *) skb->data;
 	struct nci_core_init_rsp_2 *rsp_2;
@@ -48,16 +51,14 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	pr_debug("status 0x%x\n", rsp_1->status);
 
 	if (rsp_1->status != NCI_STATUS_OK)
-		goto exit;
+		return rsp_1->status;
 
 	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
 	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
 
-	if (ndev->num_supported_rf_interfaces >
-	    NCI_MAX_SUPPORTED_RF_INTERFACES) {
-		ndev->num_supported_rf_interfaces =
-			NCI_MAX_SUPPORTED_RF_INTERFACES;
-	}
+	ndev->num_supported_rf_interfaces =
+		min((int)ndev->num_supported_rf_interfaces,
+		    NCI_MAX_SUPPORTED_RF_INTERFACES);
 
 	memcpy(ndev->supported_rf_interfaces,
 	       rsp_1->supported_rf_interfaces,
@@ -77,6 +78,58 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	ndev->manufact_specific_info =
 		__le32_to_cpu(rsp_2->manufact_specific_info);
 
+	return NCI_STATUS_OK;
+}
+
+static unsigned char nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
+	unsigned char rf_interface_idx = 0;
+	unsigned char rf_extension_cnt = 0;
+	unsigned char *supported_rf_interface = rsp->supported_rf_interfaces;
+
+	pr_debug("status %x\n", rsp->status);
+
+	if (rsp->status != NCI_STATUS_OK)
+		return rsp->status;
+
+	ndev->nfcc_features = __le32_to_cpu(rsp->nfcc_features);
+	ndev->num_supported_rf_interfaces = rsp->num_supported_rf_interfaces;
+
+	ndev->num_supported_rf_interfaces =
+		min((int)ndev->num_supported_rf_interfaces,
+		    NCI_MAX_SUPPORTED_RF_INTERFACES);
+
+	while (rf_interface_idx < ndev->num_supported_rf_interfaces) {
+		ndev->supported_rf_interfaces[rf_interface_idx++] = *supported_rf_interface++;
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
+	unsigned char status = 0;
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
@@ -103,7 +156,7 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 ndev->manufact_specific_info);
 
 exit:
-	nci_req_complete(ndev, rsp_1->status);
+	nci_req_complete(ndev, status);
 }
 
 static void nci_core_set_config_rsp_packet(struct nci_dev *ndev,
-- 
1.9.1

