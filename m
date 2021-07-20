Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEA3CF4A1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhGTF6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 01:58:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242476AbhGTF6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 01:58:24 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K6Wpad028470;
        Tue, 20 Jul 2021 02:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FHOIWUlL8Qe0gVRHaMq87iFtVKpWm99PIGzxYqRHovE=;
 b=UOhq/Dt1MFoK4UiLDyBp7xf2vN9NM7jZQPiJ/ONqw1xbkXYIadhs1IISxzCWQKJfkRdp
 4uNoWjpREpGyYe/4iudeXvGFj7y+u+PDDM9/Ipug2SfiUpCKAEgHBCglJj+RD+AAhAlD
 9FsY+ZshNlLum1p5nyctPhnd8xPVniIhC+JFxyo2lxIl+lh2RyL10+Ckyh0BP8q+H7oz
 c2Wu35N6t+quKGj6kaSTMGcTHO3EFXpA/PfPDf76z4ISOxVBcNYh3aNhzGLSwVbQRga/
 ND1M6TwbFKdfPNqHpFo+QTFW/RCgN4UqkM5DB2Cm2tuUYYxzgL2L3ReqlD1LApH4N1bj cQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wr5ahy42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 02:39:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16K6cxsx031726;
        Tue, 20 Jul 2021 06:38:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 39upu893vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 06:38:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16K6cuQ132964880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 06:38:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17E0CA404D;
        Tue, 20 Jul 2021 06:38:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5A50A4059;
        Tue, 20 Jul 2021 06:38:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Jul 2021 06:38:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/3] s390/qeth: clean up device_type management
Date:   Tue, 20 Jul 2021 08:38:49 +0200
Message-Id: <20210720063849.2646776-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720063849.2646776-1-jwi@linux.ibm.com>
References: <20210720063849.2646776-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nbrIQxF5l-omlx5tpqFL5sBiCZO_cpiD
X-Proofpoint-GUID: nbrIQxF5l-omlx5tpqFL5sBiCZO_cpiD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_04:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth uses three device_type structs - a generic one, and one for each
sub-driver (which is used for fixed-layer devices only). Instead of
exporting these device_types back&forth between the driver's modules,
make all the logic self-contained within the sub-drivers.

On disc->setup() they either install their own device_type, or add the
sysfs attributes that are missing in the generic device_type. Later on
disc->remove() these attributes are removed again from any device that
has the generic device_type.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 2 --
 drivers/s390/net/qeth_core_main.c | 4 +---
 drivers/s390/net/qeth_l2_main.c   | 8 +++++---
 drivers/s390/net/qeth_l3_main.c   | 7 ++++---
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6819cc82fc00..c17031519900 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -767,7 +767,6 @@ enum qeth_threads {
 };
 
 struct qeth_discipline {
-	const struct device_type *devtype;
 	int (*setup) (struct ccwgroup_device *);
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online)(struct qeth_card *card, bool carrier_ok);
@@ -1040,7 +1039,6 @@ extern const struct qeth_discipline qeth_l2_discipline;
 extern const struct qeth_discipline qeth_l3_discipline;
 extern const struct ethtool_ops qeth_ethtool_ops;
 extern const struct attribute_group *qeth_dev_groups[];
-extern const struct device_type qeth_generic_devtype;
 
 const char *qeth_get_cardname_short(struct qeth_card *);
 int qeth_resize_buffer_pool(struct qeth_card *card, unsigned int count);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 02a12f984ce2..7f486212c6aa 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6286,10 +6286,9 @@ void qeth_remove_discipline(struct qeth_card *card)
 	card->discipline = NULL;
 }
 
-const struct device_type qeth_generic_devtype = {
+static const struct device_type qeth_generic_devtype = {
 	.name = "qeth_generic",
 };
-EXPORT_SYMBOL_GPL(qeth_generic_devtype);
 
 #define DBF_NAME_LEN	20
 
@@ -6474,7 +6473,6 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 		if (rc)
 			goto err_setup_disc;
 
-		gdev->dev.type = card->discipline->devtype;
 		break;
 	}
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c00cc6ea721f..7fe0f1aea3cb 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2056,10 +2056,12 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 	qeth_l2_vnicc_set_defaults(card);
 	mutex_init(&card->sbp_lock);
 
-	if (gdev->dev.type == &qeth_generic_devtype) {
+	if (gdev->dev.type) {
 		rc = device_add_groups(&gdev->dev, qeth_l2_attr_groups);
 		if (rc)
 			return rc;
+	} else {
+		gdev->dev.type = &qeth_l2_devtype;
 	}
 
 	INIT_WORK(&card->rx_mode_work, qeth_l2_rx_mode_work);
@@ -2070,8 +2072,9 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
 
-	if (gdev->dev.type == &qeth_generic_devtype)
+	if (gdev->dev.type != &qeth_l2_devtype)
 		device_remove_groups(&gdev->dev, qeth_l2_attr_groups);
+
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
@@ -2191,7 +2194,6 @@ static int qeth_l2_control_event(struct qeth_card *card,
 }
 
 const struct qeth_discipline qeth_l2_discipline = {
-	.devtype = &qeth_l2_devtype,
 	.setup = qeth_l2_probe_device,
 	.remove = qeth_l2_remove_device,
 	.set_online = qeth_l2_set_online,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d308ff744a29..959ba62ccbb7 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1939,12 +1939,14 @@ static int qeth_l3_probe_device(struct ccwgroup_device *gdev)
 	if (!card->cmd_wq)
 		return -ENOMEM;
 
-	if (gdev->dev.type == &qeth_generic_devtype) {
+	if (gdev->dev.type) {
 		rc = device_add_groups(&gdev->dev, qeth_l3_attr_groups);
 		if (rc) {
 			destroy_workqueue(card->cmd_wq);
 			return rc;
 		}
+	} else {
+		gdev->dev.type = &qeth_l3_devtype;
 	}
 
 	INIT_WORK(&card->rx_mode_work, qeth_l3_rx_mode_work);
@@ -1955,7 +1957,7 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&cgdev->dev);
 
-	if (cgdev->dev.type == &qeth_generic_devtype)
+	if (cgdev->dev.type != &qeth_l3_devtype)
 		device_remove_groups(&cgdev->dev, qeth_l3_attr_groups);
 
 	qeth_set_allowed_threads(card, 0, 1);
@@ -2064,7 +2066,6 @@ static int qeth_l3_control_event(struct qeth_card *card,
 }
 
 const struct qeth_discipline qeth_l3_discipline = {
-	.devtype = &qeth_l3_devtype,
 	.setup = qeth_l3_probe_device,
 	.remove = qeth_l3_remove_device,
 	.set_online = qeth_l3_set_online,
-- 
2.25.1

