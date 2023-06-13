Return-Path: <netdev+bounces-10373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F6072E2D3
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE24E1C208E1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E96930B78;
	Tue, 13 Jun 2023 12:25:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137F33C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:25:45 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6010CE;
	Tue, 13 Jun 2023 05:25:44 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35DCNfkV006121;
	Tue, 13 Jun 2023 12:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id : to
 : cc; s=pp1; bh=0QJ5OOSqOBhOpoGHM9mIKfqtD9U6FDSmgII1zFfBG7w=;
 b=STSeSzyvzvJkHYgGju6hWsQcfKBHjy6WBf47K+whSQUV+GYHorIEU91AR+m2gohqu+Am
 PN0a3aZttQlnreCeSxtwd3mT5A6PNY9Vh0P6w5G3ShdkvZsnqIgbPqFZofPukkwWxjx3
 BRVVBSMRdPH/xTQeHvnQOqnISkb4L33h+REHp81fqdtrY2eCW17o1zTjYWyZUhU+jAOm
 v4GB208KCoe2X9e3wEfAK3joq3OnGBGSUo8Yq/EyD6pyQtckFuOWFEanFiTFVwyuPAc5
 IJUTQp3DS+nrRDiJuPvQxVc/yzSyNnUa5IscMQvxvIzE1hux4XMTaJF2Ejs+s7npPiqv vw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r6re2r1f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jun 2023 12:25:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35D4mTIc016530;
	Tue, 13 Jun 2023 12:25:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r4gee246e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jun 2023 12:25:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35DCPcig42467876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jun 2023 12:25:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19F1D20040;
	Tue, 13 Jun 2023 12:25:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5ED9720043;
	Tue, 13 Jun 2023 12:25:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 13 Jun 2023 12:25:37 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Date: Tue, 13 Jun 2023 14:25:37 +0200
Subject: [PATCH] s390/ism: Fix trying to free already-freed IRQ by repeated
 ism_dev_exit()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230613-ism-rmmod-crash-v1-1-359ac51e18c9@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAEBgiGQC/x2NQQqDQAxFryJZN6AzIqVXKUXiGDtZzChJkYJ49
 6Yu3+c9/gHGKmzwaA5Q3sVkrQ7drYGUqb4ZZXaG0IbYDl1EsYJayjpjUrKMc7/EPoRIwz2CVxM
 Z46RUU/53ro+XPm708cmNTXmR7/X5fJ3nD9slGreDAAAA
To: Julian Ruess <julianr@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Karcher <jaka@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.12.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1aIL0rMSPM2ipBYuvnwOYpT3DYv2dmrH
X-Proofpoint-ORIG-GUID: 1aIL0rMSPM2ipBYuvnwOYpT3DYv2dmrH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-13_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=960 spamscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306130107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch prevents the system from crashing when unloading the ISM module.

How to reproduce: Attach an ISM device and execute 'rmmod ism'.

Error-Log:
- Trying to free already-free IRQ 0
- WARNING: CPU: 1 PID: 966 at kernel/irq/manage.c:1890 free_irq+0x140/0x540

After calling ism_dev_exit() for each ISM device in the exit routine,
pci_unregister_driver() will execute ism_remove() for each ISM device.
Because ism_remove() also calls ism_dev_exit(),
free_irq(pci_irq_vector(pdev, 0), ism) is called twice for each ISM
device. This results in a crash with the error
'Trying to free already-free IRQ'.

In the exit routine, it is enough to call pci_unregister_driver()
because it ensures that ism_dev_exit() is called once per
ISM device.

Cc: <stable@vger.kernel.org> # 6.3+
Fixes: 89e7d2ba61b7 ("net/ism: Add new API for client registration")
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 8acb9eba691b..c2096e4bba31 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -771,14 +771,6 @@ static int __init ism_init(void)
 
 static void __exit ism_exit(void)
 {
-	struct ism_dev *ism;
-
-	mutex_lock(&ism_dev_list.mutex);
-	list_for_each_entry(ism, &ism_dev_list.list, list) {
-		ism_dev_exit(ism);
-	}
-	mutex_unlock(&ism_dev_list.mutex);
-
 	pci_unregister_driver(&ism_driver);
 	debug_unregister(ism_debug_info);
 }

---
base-commit: 858fd168a95c5b9669aac8db6c14a9aeab446375
change-id: 20230613-ism-rmmod-crash-d4f34223a683

Best regards,
-- 
Julian Ruess <julianr@linux.ibm.com>


