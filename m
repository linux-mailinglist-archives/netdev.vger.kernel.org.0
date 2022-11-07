Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690A761FF92
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiKGUc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiKGUcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:32:25 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B316629345
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 12:32:23 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7K6ase022665
        for <netdev@vger.kernel.org>; Mon, 7 Nov 2022 20:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=EKekxwHyi6pEjTuiXgwsWu/AGGsBxIkSMTsrEKWalSU=;
 b=La/pCAJD8LPACTAsRMfzYYLLSBWP4orviQgfu/SpR49X+ZYNcmmCuFD7Pc6sMSYsaIJk
 mXA331VIPlfeSmI9DosbBKf+EEZyKUUpEfLFxuZNK+64awALhZObEZ1xNzaYB2GrciWx
 uaLIkjd/ZvzSP76pvPDmatKrJ6AQ45APsiwwyPkQVAh01vbYD4LmNiXdCbpy0xtqsq6q
 HSPw8YUxQgAVdJMFEf1//jWZNn5NCdmrX09N6jk4uF1Q2OPg5KAENxyZvePvxMmnFwNb
 MK4e4tDQcIkNq/05DB+L1yVa8LskIDU9Dk4dTAVcKuE3CbFbaY8RuK3Pc39u3tQHef3O cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1uv125y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 20:32:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7KWMrn010223
        for <netdev@vger.kernel.org>; Mon, 7 Nov 2022 20:32:22 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1uv125q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 20:32:22 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7KK1iX000779;
        Mon, 7 Nov 2022 20:32:21 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3kngnej02t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 20:32:21 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7KWNoU62390626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 20:32:24 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B0315805A;
        Mon,  7 Nov 2022 20:32:19 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA0775805C;
        Mon,  7 Nov 2022 20:32:18 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.87.198])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 20:32:18 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     nick.child@ibm.com, bjking1@linux.ibm.com, ricklind@us.ibm.com,
        dave.taht@gmail.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH v3 net] ibmveth: Reduce default tx queues to 8
Date:   Mon,  7 Nov 2022 14:32:15 -0600
Message-Id: <20221107203215.58206-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qIy4Dv1DQnqb7r9iXTJ0NiNvPk-9QEKG
X-Proofpoint-ORIG-GUID: ef2_SYKKIwetSIGOvQde084dstsH19m6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=449 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the default number of transmit queues was 16. Due to
resource concerns, set to 8 queues instead. Still allow the user
to set more queues (max 16) if they like.

Since the driver is virtualized away from the physical NIC, the purpose
of multiple queues is purely to allow for parallel calls to the
hypervisor. Therefore, there is no noticeable effect on performance by
reducing queue count to 8.

Fixes: d926793c1de9 ("ibmveth: Implement multi queue on xmit")
Reported-by: Dave Taht <dave.taht@gmail.com>
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---
v2 - https://lore.kernel.org/netdev/26dc5891a0244f5f834cfd95f74ee8b4@AcuMS.aculab.com/
     changes:
        - leave max queues at 16 and default to 8 on probe
        - add "Fixes:"
 drivers/net/ethernet/ibm/ibmveth.c | 3 ++-
 drivers/net/ethernet/ibm/ibmveth.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7d79006250ae..113fcb3e353e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1749,7 +1749,8 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 			kobject_uevent(kobj, KOBJ_ADD);
 	}
 
-	rc = netif_set_real_num_tx_queues(netdev, ibmveth_real_max_tx_queues());
+	rc = netif_set_real_num_tx_queues(netdev, min(num_online_cpus(),
+						      IBMVETH_DEFAULT_QUEUES));
 	if (rc) {
 		netdev_dbg(netdev, "failed to set number of tx queues rc=%d\n",
 			   rc);
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 4f8357187292..8468e2c59d7a 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -100,6 +100,7 @@ static inline long h_illan_attributes(unsigned long unit_address,
 #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
 #define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
 #define IBMVETH_MAX_QUEUES 16U
+#define IBMVETH_DEFAULT_QUEUES 8U
 
 static int pool_size[] = { 512, 1024 * 2, 1024 * 16, 1024 * 32, 1024 * 64 };
 static int pool_count[] = { 256, 512, 256, 256, 256 };
-- 
2.31.1

