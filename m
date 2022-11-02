Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FBE616635
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiKBPcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKBPbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:31:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B8F2C659
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:30:56 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2EKDuF022035
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 15:30:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/hlXFz5MDIr+JwnIxnH9PchkSdTzHw+vA3T9FDp7Bv0=;
 b=f1LU4aidLZQqKDM+1H6yZWtYgJM7n0Zlo2D84nxXQQm+IpBUn88cD9eY2hDtHHwEv3oc
 BvEJh2IXzfzucCIUZBGFKJoA+EJho1ujTCHZ9+ucwc3ImjUQ7ws1MRKjP0EK0lee5tYU
 VFoej2OFX5+G1hlSWX5/KUQed5ITfap8R6bOtVrPkDcs9TtdlYGtRtgcvZpFJyGr+zxq
 OnLGtMaI4AoSSm8E351ghu/NTDq1FaORMSRK0lRdKy3tlSTa/H9RQpoEP8AT4VeOVAd8
 zBj3X24Zdnl2pGGkf96COrLzv11Z67Fh62WSWSHye1Zz/eVPj2O5Mi4ZbgGZ6V1ayfv+ dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkt7cjuyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:30:55 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A2F6JhZ019143
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 15:30:55 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kkt7cjuxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:30:55 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A2FKFFM022800;
        Wed, 2 Nov 2022 15:30:54 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3kgut9uj7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 15:30:54 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A2FUpBv22217280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Nov 2022 15:30:52 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 985495805C;
        Wed,  2 Nov 2022 15:30:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA4905805A;
        Wed,  2 Nov 2022 15:30:50 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.21.137])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  2 Nov 2022 15:30:50 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     nick.child@ibm.com, bjking1@linux.ibm.com, ricklind@us.ibm.com,
        dave.taht@gmail.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net] ibmveth: Reduce maximum tx queues to 8
Date:   Wed,  2 Nov 2022 10:30:40 -0500
Message-Id: <20221102153040.149244-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OcQbXVhdREuGfD0-vNKRMkijpLE00rlh
X-Proofpoint-ORIG-GUID: sQYsVU-eZP9JvqnskKvvte8AnHU_MSX4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_11,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=416 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211020093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the maximum number of transmit queues
allowed was 16. Due to resource concerns, limit
to 8 queues instead.

Since the driver is virtualized away from the
physical NIC, the purpose of multiple queues is
purely to allow for parallel calls to the
hypervisor. Therefore, there is no noticeable
effect on performance by reducing queue count to 8.

Reported-by: Reported-by: Dave Taht <dave.taht@gmail.com>
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
Relevant links:
 - Introduce multiple tx queues (accepted in v6.1):
   https://lore.kernel.org/netdev/20220928214350.29795-2-nnac123@linux.ibm.com/
 - Resource concerns with 16 queues:
   https://lore.kernel.org/netdev/CAA93jw5reJmaOvt9vw15C1fo1AN7q5jVKzUocbAoNDC-cpi=KQ@mail.gmail.com/

 drivers/net/ethernet/ibm/ibmveth.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 4f8357187292..6b5faf1feb0b 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -99,7 +99,7 @@ static inline long h_illan_attributes(unsigned long unit_address,
 #define IBMVETH_FILT_LIST_SIZE 4096
 #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
 #define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
-#define IBMVETH_MAX_QUEUES 16U
+#define IBMVETH_MAX_QUEUES 8U
 
 static int pool_size[] = { 512, 1024 * 2, 1024 * 16, 1024 * 32, 1024 * 64 };
 static int pool_count[] = { 256, 512, 256, 256, 256 };
-- 
2.31.1

