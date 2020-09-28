Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433D327A525
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 03:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgI1BNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 21:13:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29752 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgI1BNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 21:13:36 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S11UBE149188
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BZMfeNElNlvjkCfY9DLyQJLDYvWjNtx+PbBmFDshQtM=;
 b=esc/hiqY/4z2xkuBE5jxfygM0BfGpeuUEHSp725Q657yXaD5yOCCKCK/ZxQKnYjUUNAf
 jChnYBlFwf3mv3W427j25bPzWj5T6C2/aO4PDZJ2KkI0a7XHZuKSLKbV1IQeFL+sMBJE
 NQF5dVQgARQ/sHnIhwoSEOm0Z/iUrC1xqOMZ9FKjjc6E/uV9M0IJvg6p0xSoOG8MfI8V
 AWNOs8TT8yUM0jnSO70zcHoRHg+Bb3h5GPkuolL9V8vv9xp/rZJLwfFhGbGD5NyyJDF/
 sPQ0Qu5mOe77vehvj/xTnoPAbNbX22NbTm4sEpH6FJIjV7j8/3FEm/7Z0rkkklfl3tb1 bA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u46usyst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:34 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S170XE002207
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:34 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 33sw98t6kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:34 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S1DXCu52494596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:13:33 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64F8FAC05F;
        Mon, 28 Sep 2020 01:13:33 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05221AC05E;
        Mon, 28 Sep 2020 01:13:33 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 5/5] ibmvnic: create send_control_ip_offload
Date:   Sun, 27 Sep 2020 20:13:30 -0500
Message-Id: <20200928011330.79774-6-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200928011330.79774-1-ljp@linux.ibm.com>
References: <20200928011330.79774-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=837 lowpriorityscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor send_control_ip_offload out of handle_query_ip_offload_rsp.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 150 +++++++++++++++--------------
 1 file changed, 80 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c31b81cf43b6..22ba3dc83d2f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3981,6 +3981,85 @@ static void send_query_ip_offload(struct ibmvnic_adapter *adapter)
 	ibmvnic_send_crq(adapter, &crq);
 }
 
+static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
+{
+	struct ibmvnic_control_ip_offload_buffer *ctrl_buf = &adapter->ip_offload_ctrl;
+	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
+	struct device *dev = &adapter->vdev->dev;
+	netdev_features_t old_hw_features = 0;
+	union ibmvnic_crq crq;
+
+	adapter->ip_offload_ctrl_tok =
+		dma_map_single(dev,
+			       ctrl_buf,
+			       sizeof(adapter->ip_offload_ctrl),
+			       DMA_TO_DEVICE);
+
+	if (dma_mapping_error(dev, adapter->ip_offload_ctrl_tok)) {
+		dev_err(dev, "Couldn't map ip offload control buffer\n");
+		return;
+	}
+
+	ctrl_buf->len = cpu_to_be32(sizeof(adapter->ip_offload_ctrl));
+	ctrl_buf->version = cpu_to_be32(INITIAL_VERSION_IOB);
+	ctrl_buf->ipv4_chksum = buf->ipv4_chksum;
+	ctrl_buf->ipv6_chksum = buf->ipv6_chksum;
+	ctrl_buf->tcp_ipv4_chksum = buf->tcp_ipv4_chksum;
+	ctrl_buf->udp_ipv4_chksum = buf->udp_ipv4_chksum;
+	ctrl_buf->tcp_ipv6_chksum = buf->tcp_ipv6_chksum;
+	ctrl_buf->udp_ipv6_chksum = buf->udp_ipv6_chksum;
+	ctrl_buf->large_tx_ipv4 = buf->large_tx_ipv4;
+	ctrl_buf->large_tx_ipv6 = buf->large_tx_ipv6;
+
+	/* large_rx disabled for now, additional features needed */
+	ctrl_buf->large_rx_ipv4 = 0;
+	ctrl_buf->large_rx_ipv6 = 0;
+
+	if (adapter->state != VNIC_PROBING) {
+		old_hw_features = adapter->netdev->hw_features;
+		adapter->netdev->hw_features = 0;
+	}
+
+	adapter->netdev->hw_features = NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+
+	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
+		adapter->netdev->hw_features |= NETIF_F_IP_CSUM;
+
+	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
+		adapter->netdev->hw_features |= NETIF_F_IPV6_CSUM;
+
+	if ((adapter->netdev->features &
+	    (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)))
+		adapter->netdev->hw_features |= NETIF_F_RXCSUM;
+
+	if (buf->large_tx_ipv4)
+		adapter->netdev->hw_features |= NETIF_F_TSO;
+	if (buf->large_tx_ipv6)
+		adapter->netdev->hw_features |= NETIF_F_TSO6;
+
+	if (adapter->state == VNIC_PROBING) {
+		adapter->netdev->features |= adapter->netdev->hw_features;
+	} else if (old_hw_features != adapter->netdev->hw_features) {
+		netdev_features_t tmp = 0;
+
+		/* disable features no longer supported */
+		adapter->netdev->features &= adapter->netdev->hw_features;
+		/* turn on features now supported if previously enabled */
+		tmp = (old_hw_features ^ adapter->netdev->hw_features) &
+			adapter->netdev->hw_features;
+		adapter->netdev->features |=
+				tmp & adapter->netdev->wanted_features;
+	}
+
+	memset(&crq, 0, sizeof(crq));
+	crq.control_ip_offload.first = IBMVNIC_CRQ_CMD;
+	crq.control_ip_offload.cmd = CONTROL_IP_OFFLOAD;
+	crq.control_ip_offload.len =
+	    cpu_to_be32(sizeof(adapter->ip_offload_ctrl));
+	crq.control_ip_offload.ioba = cpu_to_be32(adapter->ip_offload_ctrl_tok);
+	ibmvnic_send_crq(adapter, &crq);
+}
+
 static void handle_vpd_size_rsp(union ibmvnic_crq *crq,
 				struct ibmvnic_adapter *adapter)
 {
@@ -4050,8 +4129,6 @@ static void handle_query_ip_offload_rsp(struct ibmvnic_adapter *adapter)
 {
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
-	netdev_features_t old_hw_features = 0;
-	union ibmvnic_crq crq;
 	int i;
 
 	dma_unmap_single(dev, adapter->ip_offload_tok,
@@ -4101,74 +4178,7 @@ static void handle_query_ip_offload_rsp(struct ibmvnic_adapter *adapter)
 	netdev_dbg(adapter->netdev, "off_ipv6_ext_hd = %d\n",
 		   buf->off_ipv6_ext_headers);
 
-	adapter->ip_offload_ctrl_tok =
-	    dma_map_single(dev, &adapter->ip_offload_ctrl,
-			   sizeof(adapter->ip_offload_ctrl), DMA_TO_DEVICE);
-
-	if (dma_mapping_error(dev, adapter->ip_offload_ctrl_tok)) {
-		dev_err(dev, "Couldn't map ip offload control buffer\n");
-		return;
-	}
-
-	adapter->ip_offload_ctrl.len =
-	    cpu_to_be32(sizeof(adapter->ip_offload_ctrl));
-	adapter->ip_offload_ctrl.version = cpu_to_be32(INITIAL_VERSION_IOB);
-	adapter->ip_offload_ctrl.ipv4_chksum = buf->ipv4_chksum;
-	adapter->ip_offload_ctrl.ipv6_chksum = buf->ipv6_chksum;
-	adapter->ip_offload_ctrl.tcp_ipv4_chksum = buf->tcp_ipv4_chksum;
-	adapter->ip_offload_ctrl.udp_ipv4_chksum = buf->udp_ipv4_chksum;
-	adapter->ip_offload_ctrl.tcp_ipv6_chksum = buf->tcp_ipv6_chksum;
-	adapter->ip_offload_ctrl.udp_ipv6_chksum = buf->udp_ipv6_chksum;
-	adapter->ip_offload_ctrl.large_tx_ipv4 = buf->large_tx_ipv4;
-	adapter->ip_offload_ctrl.large_tx_ipv6 = buf->large_tx_ipv6;
-
-	/* large_rx disabled for now, additional features needed */
-	adapter->ip_offload_ctrl.large_rx_ipv4 = 0;
-	adapter->ip_offload_ctrl.large_rx_ipv6 = 0;
-
-	if (adapter->state != VNIC_PROBING) {
-		old_hw_features = adapter->netdev->hw_features;
-		adapter->netdev->hw_features = 0;
-	}
-
-	adapter->netdev->hw_features = NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
-
-	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
-		adapter->netdev->hw_features |= NETIF_F_IP_CSUM;
-
-	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
-		adapter->netdev->hw_features |= NETIF_F_IPV6_CSUM;
-
-	if ((adapter->netdev->features &
-	    (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)))
-		adapter->netdev->hw_features |= NETIF_F_RXCSUM;
-
-	if (buf->large_tx_ipv4)
-		adapter->netdev->hw_features |= NETIF_F_TSO;
-	if (buf->large_tx_ipv6)
-		adapter->netdev->hw_features |= NETIF_F_TSO6;
-
-	if (adapter->state == VNIC_PROBING) {
-		adapter->netdev->features |= adapter->netdev->hw_features;
-	} else if (old_hw_features != adapter->netdev->hw_features) {
-		netdev_features_t tmp = 0;
-
-		/* disable features no longer supported */
-		adapter->netdev->features &= adapter->netdev->hw_features;
-		/* turn on features now supported if previously enabled */
-		tmp = (old_hw_features ^ adapter->netdev->hw_features) &
-			adapter->netdev->hw_features;
-		adapter->netdev->features |=
-				tmp & adapter->netdev->wanted_features;
-	}
-
-	memset(&crq, 0, sizeof(crq));
-	crq.control_ip_offload.first = IBMVNIC_CRQ_CMD;
-	crq.control_ip_offload.cmd = CONTROL_IP_OFFLOAD;
-	crq.control_ip_offload.len =
-	    cpu_to_be32(sizeof(adapter->ip_offload_ctrl));
-	crq.control_ip_offload.ioba = cpu_to_be32(adapter->ip_offload_ctrl_tok);
-	ibmvnic_send_crq(adapter, &crq);
+	send_control_ip_offload(adapter);
 }
 
 static const char *ibmvnic_fw_err_cause(u16 cause)
-- 
2.23.0

