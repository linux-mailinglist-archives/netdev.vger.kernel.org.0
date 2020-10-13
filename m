Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B17E28D6FB
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbgJMXVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:21:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388809AbgJMXVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 19:21:03 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09DN2u0k168720;
        Tue, 13 Oct 2020 19:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V9Wu368UELjgKQ7FBUQ0Gc5qiGKEPhNQDsUqm7YOJ3o=;
 b=gCAFMtuhbsqmGzaOjoXYan7H31eAQcHFFnDtzUOVP06nwqFHZ/yBLe8fHdJkXRHe6a5K
 HsZSpIPLU4E0d7B2bNic5MpIx8ytCH5aR96WixvHkTotZzTsb8hs/6PGcr1x3S1kKqCk
 7HmkluGmO9kDEytdVNGRdqCTdT7OU5fXRLMSIGH1BS7zZByOq3pxE0MY2/VOgtBrYDOD
 yHvPjTRVdCDa5XL+75zOggjEEjcxA8pMcNuhxW3iuzJ3/2UoiTMvJDN+lEwoCxVIp7Wt
 adP2KOsHFEF8te7q/W9OliCkn66hxcCeDjXWSD2FElSbU/7auqP1kapcv/HoX2AnWhWX wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 345m0b2p45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 19:21:01 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09DN3omC171552;
        Tue, 13 Oct 2020 19:21:00 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 345m0b2p3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 19:21:00 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09DNH6mE032654;
        Tue, 13 Oct 2020 23:21:00 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 3434k8ugx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Oct 2020 23:21:00 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09DNKwZJ16384608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 23:20:58 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0AF9AE05F;
        Tue, 13 Oct 2020 23:20:58 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 567CDAE05C;
        Tue, 13 Oct 2020 23:20:57 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.65.207.144])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 13 Oct 2020 23:20:57 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org
Subject: [ PATCH v2 2/2] ibmveth: Identify ingress large send packets.
Date:   Tue, 13 Oct 2020 16:20:14 -0700
Message-Id: <20201013232014.26044-3-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20201013232014.26044-1-dwilder@us.ibm.com>
References: <20201013232014.26044-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-13_16:2020-10-13,2020-10-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=865
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=1
 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130160
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ingress large send packets are identified by either:
The IBMVETH_RXQ_LRG_PKT flag in the receive buffer
or with a -1 placed in the ip header checksum.
The method used depends on firmware version. Frame
geometry and sufficient header validation is performed by the
hypervisor eliminating the need for further header checks here.

Fixes: 7b5967389f5a ("ibmveth: set correct gso_size and gso_type")
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3935a7e22ce5..7ef3369953b6 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1349,6 +1349,7 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 			int offset = ibmveth_rxq_frame_offset(adapter);
 			int csum_good = ibmveth_rxq_csum_good(adapter);
 			int lrg_pkt = ibmveth_rxq_large_packet(adapter);
+			__sum16 iph_check = 0;
 
 			skb = ibmveth_rxq_get_buffer(adapter);
 
@@ -1385,7 +1386,17 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
 
-			if (length > netdev->mtu + ETH_HLEN) {
+			/* PHYP without PLSO support places a -1 in the ip
+			 * checksum for large send frames.
+			 */
+			if (skb->protocol == cpu_to_be16(ETH_P_IP)) {
+				struct iphdr *iph = (struct iphdr *)skb->data;
+
+				iph_check = iph->check;
+			}
+
+			if ((length > netdev->mtu + ETH_HLEN) ||
+			    lrg_pkt || iph_check == 0xffff) {
 				ibmveth_rx_mss_helper(skb, mss, lrg_pkt);
 				adapter->rx_large_packets++;
 			}
-- 
1.8.3.1

