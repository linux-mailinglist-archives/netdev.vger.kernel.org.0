Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7E227A523
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 03:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgI1BNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 21:13:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726630AbgI1BNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 21:13:35 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S10PiF068215
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TzoJaRmNGD18O1ynHwgQkVE8tX7/J7b6EYdSJ5Hj+JM=;
 b=ePlwihdFzbDLaQxilTUUsH4zQiglyGltBLOJuPas458dvjT2PLfIRkspMNIE/4GdlXQ0
 gqIwH8mMJFUCEhyA+RdTWbhbNxMXl7T34GrmMX0HopKFOdHwFryp9Cc26nmIehykyNDN
 JLs2aPLJKiGQSOCkvLv7YDg1y8SIVCcODbmIHlicPaEXLZawmKm8JdVj/tFAUpZQdAkQ
 pox4u2JOS4CSzft05bN3yvZf9PKzgILYcwoLNuRJN8ZFK+q7fs9r9ICj9fEwFWkVnwN3
 0oyabQWQ0kXJxt5odiycoRArokCiTud6sXeUrlE1fP05nPk/5d2zBK5X0S5GTtFFcdQ1 dA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33u5ahrt7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 21:13:33 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S16uI8028605
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:33 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 33sw98pk9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:13:33 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S1DWGm48693614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 01:13:33 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0CA4AC060;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8491CAC05E;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 01:13:32 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 4/5] ibmvnic: create send_query_ip_offload
Date:   Sun, 27 Sep 2020 20:13:29 -0500
Message-Id: <20200928011330.79774-5-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200928011330.79774-1-ljp@linux.ibm.com>
References: <20200928011330.79774-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=1 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor send_query_ip_offload out of handle_request_cap_rsp to
pair with handle_query_ip_offload_rsp.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 52 +++++++++++++++++-------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1ab321e69075..c31b81cf43b6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3953,6 +3953,34 @@ static void send_query_cap(struct ibmvnic_adapter *adapter)
 	ibmvnic_send_crq(adapter, &crq);
 }
 
+static void send_query_ip_offload(struct ibmvnic_adapter *adapter)
+{
+	int buf_sz = sizeof(struct ibmvnic_query_ip_offload_buffer);
+	struct device *dev = &adapter->vdev->dev;
+	union ibmvnic_crq crq;
+
+	adapter->ip_offload_tok =
+		dma_map_single(dev,
+			       &adapter->ip_offload_buf,
+			       buf_sz,
+			       DMA_FROM_DEVICE);
+
+	if (dma_mapping_error(dev, adapter->ip_offload_tok)) {
+		if (!firmware_has_feature(FW_FEATURE_CMO))
+			dev_err(dev, "Couldn't map offload buffer\n");
+		return;
+	}
+
+	memset(&crq, 0, sizeof(crq));
+	crq.query_ip_offload.first = IBMVNIC_CRQ_CMD;
+	crq.query_ip_offload.cmd = QUERY_IP_OFFLOAD;
+	crq.query_ip_offload.len = cpu_to_be32(buf_sz);
+	crq.query_ip_offload.ioba =
+	    cpu_to_be32(adapter->ip_offload_tok);
+
+	ibmvnic_send_crq(adapter, &crq);
+}
+
 static void handle_vpd_size_rsp(union ibmvnic_crq *crq,
 				struct ibmvnic_adapter *adapter)
 {
@@ -4276,30 +4304,8 @@ static void handle_request_cap_rsp(union ibmvnic_crq *crq,
 
 	/* Done receiving requested capabilities, query IP offload support */
 	if (atomic_read(&adapter->running_cap_crqs) == 0) {
-		union ibmvnic_crq newcrq;
-		int buf_sz = sizeof(struct ibmvnic_query_ip_offload_buffer);
-		struct ibmvnic_query_ip_offload_buffer *ip_offload_buf =
-		    &adapter->ip_offload_buf;
-
 		adapter->wait_capability = false;
-		adapter->ip_offload_tok = dma_map_single(dev, ip_offload_buf,
-							 buf_sz,
-							 DMA_FROM_DEVICE);
-
-		if (dma_mapping_error(dev, adapter->ip_offload_tok)) {
-			if (!firmware_has_feature(FW_FEATURE_CMO))
-				dev_err(dev, "Couldn't map offload buffer\n");
-			return;
-		}
-
-		memset(&newcrq, 0, sizeof(newcrq));
-		newcrq.query_ip_offload.first = IBMVNIC_CRQ_CMD;
-		newcrq.query_ip_offload.cmd = QUERY_IP_OFFLOAD;
-		newcrq.query_ip_offload.len = cpu_to_be32(buf_sz);
-		newcrq.query_ip_offload.ioba =
-		    cpu_to_be32(adapter->ip_offload_tok);
-
-		ibmvnic_send_crq(adapter, &newcrq);
+		send_query_ip_offload(adapter);
 	}
 }
 
-- 
2.23.0

