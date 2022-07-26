Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E4A5810B9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiGZKEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiGZKD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:03:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187A531227;
        Tue, 26 Jul 2022 03:03:58 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q9DxB6030689;
        Tue, 26 Jul 2022 10:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VzKNt+VZeeZVvf1ZRLZXpgNCAhggO9tP4SXhEgmwlDI=;
 b=BzNypzYDovRGDHnr1aINlqn7vyADPXvauE1XyGZu3sPIsjZxnqS4MQ64B5+pnrolU7Fm
 KHPxT8Q6/3gZhDEpTAhOuIWNw6i162ug5SG9NgiGV31K2/OQjS6AWn3s49AwVeC5ds5G
 7KX2qgMiQGBC3marASlHdUk0wqcWZ3dw5afkrzUB60nmE7Le5fya9FcYdjGr5UgAPnJD
 3HDByK4PDIY5Kd6So4Mk+Rzg6dqvpwGsSitFEBxpCu+vCmA/xXJ5+9EK7z8CarzNw8h9
 x+05c9hZYaufkwHMKjfDbd654i5RNoOvI2YmBbfmaXmYw2bsAJ8Q221C7fofihU6pSiV 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjdeu1aec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:53 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26Q9rYAJ014769;
        Tue, 26 Jul 2022 10:03:53 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjdeu1acw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26Q9pLBq011040;
        Tue, 26 Jul 2022 10:03:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6euja1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 10:03:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QA1nN016843106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 10:01:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E38D4C044;
        Tue, 26 Jul 2022 10:03:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 549FA4C046;
        Tue, 26 Jul 2022 10:03:44 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.107.22])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 10:03:44 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next v2 2/4] s390/ism: Cleanups
Date:   Tue, 26 Jul 2022 12:03:28 +0200
Message-Id: <20220726100330.75191-3-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220726100330.75191-1-wenjia@linux.ibm.com>
References: <20220726100330.75191-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lxzBac3XSGWpo2VwSZNF_lYZOMohQvQX
X-Proofpoint-ORIG-GUID: Z6bo7BO56QUZqStYvUjIzKdTpwx536Po
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_02,2022-07-25_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Reworked signature of the function to retrieve the system EID: No plausible
reason to use a double pointer. And neither to pass in the device as an
argument, as this identifier is by definition per system, not per device.
Plus some minor consistency edits.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 11 +++++------
 include/net/smc.h          |  2 +-
 net/smc/smc_ism.c          |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 5f7e28de8b15..4665e9a0e048 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -409,20 +409,19 @@ static void ism_create_system_eid(void)
 	memcpy(&SYSTEM_EID.type, tmp, 4);
 }
 
-static void ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
+static u8 *ism_get_system_eid(void)
 {
-	*eid = &SYSTEM_EID.seid_string[0];
+	return SYSTEM_EID.seid_string;
 }
 
 static u16 ism_get_chid(struct smcd_dev *smcd)
 {
-	struct ism_dev *ismdev;
+	struct ism_dev *ism = (struct ism_dev *)smcd->priv;
 
-	ismdev = (struct ism_dev *)smcd->priv;
-	if (!ismdev || !ismdev->pdev)
+	if (!ism || !ism->pdev)
 		return 0;
 
-	return to_zpci(ismdev->pdev)->pchid;
+	return to_zpci(ism->pdev)->pchid;
 }
 
 static void ism_handle_event(struct ism_dev *ism)
diff --git a/include/net/smc.h b/include/net/smc.h
index 37f829d9c6e5..1868a5014dea 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -72,7 +72,7 @@ struct smcd_ops {
 	int (*move_data)(struct smcd_dev *dev, u64 dmb_tok, unsigned int idx,
 			 bool sf, unsigned int offset, void *data,
 			 unsigned int size);
-	void (*get_system_eid)(struct smcd_dev *dev, u8 **eid);
+	u8* (*get_system_eid)(void);
 	u16 (*get_chid)(struct smcd_dev *dev);
 };
 
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index c656ef25ee4b..e51c0cdff8e0 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -429,7 +429,7 @@ int smcd_register_dev(struct smcd_dev *smcd)
 	if (list_empty(&smcd_dev_list.list)) {
 		u8 *system_eid = NULL;
 
-		smcd->ops->get_system_eid(smcd, &system_eid);
+		system_eid = smcd->ops->get_system_eid();
 		if (system_eid[24] != '0' || system_eid[28] != '0') {
 			smc_ism_v2_capable = true;
 			memcpy(smc_ism_v2_system_eid, system_eid,
-- 
2.35.2

