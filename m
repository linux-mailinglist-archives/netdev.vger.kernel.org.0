Return-Path: <netdev+bounces-12139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A6B73664C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F3FD1C20BCD
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA1E883A;
	Tue, 20 Jun 2023 08:35:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A238465
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:35:00 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E729410C1;
	Tue, 20 Jun 2023 01:34:58 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35K8UU66012680;
	Tue, 20 Jun 2023 08:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Zs0I8954+CpE1hlQmdbAmVL+Yew6k6c5fVAOWB5T3vU=;
 b=qURHtHYGNlkLwIeglACA/AWqaI54N1x//6WPoM4OcQJQ1v20mDB87x+T0SwXqrUW6W+Q
 +HVtEpqzE6Ry1S62jPwxiez2y+W8TZnF3pRoRUjULgNd9yA3hSqmmGq9G5TLDQ+Oxea9
 4+oL5jYH7kPhRDiVt1p0N7PlVmYYNqm0TyvY7cle0ec5PIq2goiAP0F0xfjvfy8frh1o
 Ddc7XnOaQJUf1iuyJ7FRP9KAVhfEKIccY84xd9+mdVrOawKpz/7hIWUWzZ+rnZEEzeyF
 ZW/+bp3932BUUyZeF+XU9Ue497R3vtt/KezvMDp/0ND7D+jzfZuwAI/UKY2pcQ2gsLOW 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8nfr5ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:50 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35K8VfqO016252;
	Tue, 20 Jun 2023 08:34:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rb8nfr5d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35K3Oblk009323;
	Tue, 20 Jun 2023 08:34:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3r94f51f5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 08:34:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35K8YivI43057704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jun 2023 08:34:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 082B820043;
	Tue, 20 Jun 2023 08:34:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA0F820040;
	Tue, 20 Jun 2023 08:34:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Jun 2023 08:34:43 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
	id 9A118E08F9; Tue, 20 Jun 2023 10:34:43 +0200 (CEST)
From: Alexandra Winter <wintera@linux.ibm.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 3/4] s390/ctcm: Convert sysfs sprintf to sysfs_emit
Date: Tue, 20 Jun 2023 10:34:10 +0200
Message-Id: <20230620083411.508797-4-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620083411.508797-1-wintera@linux.ibm.com>
References: <20230620083411.508797-1-wintera@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eY7RQ3mYcKm7GUnsNpNZp7HhHorgnzyD
X-Proofpoint-GUID: 0sF7iwXEybGQf5DVC-9XrdHQSVTWXbMp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_05,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Thorsten Winkler <twinkler@linux.ibm.com>

Following the advice of the Documentation/filesystems/sysfs.rst.
All sysfs related show()-functions should only use sysfs_emit() or
sysfs_emit_at() when formatting the value to be returned to user space.

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/ctcm_sysfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index e3813a7aa5e6..98680c2cc4e4 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -28,7 +28,7 @@ static ssize_t ctcm_buffer_show(struct device *dev,
 
 	if (!priv)
 		return -ENODEV;
-	return sprintf(buf, "%d\n", priv->buffer_size);
+	return sysfs_emit(buf, "%d\n", priv->buffer_size);
 }
 
 static ssize_t ctcm_buffer_write(struct device *dev,
@@ -120,7 +120,7 @@ static ssize_t stats_show(struct device *dev,
 	if (!priv || gdev->state != CCWGROUP_ONLINE)
 		return -ENODEV;
 	ctcm_print_statistics(priv);
-	return sprintf(buf, "0\n");
+	return sysfs_emit(buf, "0\n");
 }
 
 static ssize_t stats_write(struct device *dev, struct device_attribute *attr,
@@ -142,7 +142,7 @@ static ssize_t ctcm_proto_show(struct device *dev,
 	if (!priv)
 		return -ENODEV;
 
-	return sprintf(buf, "%d\n", priv->protocol);
+	return sysfs_emit(buf, "%d\n", priv->protocol);
 }
 
 static ssize_t ctcm_proto_store(struct device *dev,
@@ -184,8 +184,8 @@ static ssize_t ctcm_type_show(struct device *dev,
 	if (!cgdev)
 		return -ENODEV;
 
-	return sprintf(buf, "%s\n",
-			ctcm_type[cgdev->cdev[0]->id.driver_info]);
+	return sysfs_emit(buf, "%s\n",
+			  ctcm_type[cgdev->cdev[0]->id.driver_info]);
 }
 
 static DEVICE_ATTR(buffer, 0644, ctcm_buffer_show, ctcm_buffer_write);
-- 
2.39.2


