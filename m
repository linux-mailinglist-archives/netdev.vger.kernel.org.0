Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B561F2804CA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbgJARMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:12:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732867AbgJARL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:59 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H1PhF104246;
        Thu, 1 Oct 2020 13:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=dKve+i1khI7AxYHFR+g9kWGeVX6QMyEXVDbKGoQaF6o=;
 b=JqPawCcqudCjDSei1arQewUwiDdv/98J6Ko6qLChCqT5I2cqKqsQ9tSrTUAAJ7zdHS7y
 TbpqbJ4DL5KA60ivlnYcXMgAe9ugHWZRdWpe2OP5jphCZ38KGS7C58nCWAfBcpSBqj/d
 QVPr6XOz5eyjszt5Tb+aplStatlomYkUncowMlkLAocSxIUWO2p4/EQ9cMVeWQTo69xM
 vRfzIklDxZ8Ogdmky9FkGVbMTr0p3QohKuyZiz5fEiv2ADSn8r8m50+AQdsnpd5CI5BX
 Ss/69TykB7//gegIWaKQ+ZVN9LxkHNO6CFxCVfRwhBxQoEdQ7vXITQG/jPy6A1uMmSqS qg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33wjkehecg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:52 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H3XrJ022841;
        Thu, 1 Oct 2020 17:11:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 33sw983121-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBhY213697426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52B82A4040;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1289EA4057;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/7] s390/qeth: constify the disciplines
Date:   Thu,  1 Oct 2020 19:11:33 +0200
Message-Id: <20201001171136.46830-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The discipline struct is a fixed group of function pointers.
So declare the L2 and L3 disciplines as constant.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    | 6 +++---
 drivers/s390/net/qeth_l2_main.c | 2 +-
 drivers/s390/net/qeth_l3_main.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 707a1634f621..e5f47a823a11 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -858,7 +858,7 @@ struct qeth_card {
 	struct qeth_qdio_info qdio;
 	int read_or_write_problem;
 	struct qeth_osn_info osn_info;
-	struct qeth_discipline *discipline;
+	const struct qeth_discipline *discipline;
 	atomic_t force_alloc_skb;
 	struct service_level qeth_service_level;
 	struct qdio_ssqd_desc ssqd;
@@ -1051,8 +1051,8 @@ static inline int qeth_send_simple_setassparms_v6(struct qeth_card *card,
 
 int qeth_get_priority_queue(struct qeth_card *card, struct sk_buff *skb);
 
-extern struct qeth_discipline qeth_l2_discipline;
-extern struct qeth_discipline qeth_l3_discipline;
+extern const struct qeth_discipline qeth_l2_discipline;
+extern const struct qeth_discipline qeth_l3_discipline;
 extern const struct ethtool_ops qeth_ethtool_ops;
 extern const struct ethtool_ops qeth_osn_ethtool_ops;
 extern const struct attribute_group *qeth_generic_attr_groups[];
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c0ceeddd1549..2e9d3fea60e6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2340,7 +2340,7 @@ static int qeth_l2_control_event(struct qeth_card *card,
 	}
 }
 
-struct qeth_discipline qeth_l2_discipline = {
+const struct qeth_discipline qeth_l2_discipline = {
 	.devtype = &qeth_l2_devtype,
 	.setup = qeth_l2_probe_device,
 	.remove = qeth_l2_remove_device,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 803ccbcf3511..4db7ded88fc8 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2073,7 +2073,7 @@ static int qeth_l3_control_event(struct qeth_card *card,
 	return 1;
 }
 
-struct qeth_discipline qeth_l3_discipline = {
+const struct qeth_discipline qeth_l3_discipline = {
 	.devtype = &qeth_l3_devtype,
 	.setup = qeth_l3_probe_device,
 	.remove = qeth_l3_remove_device,
-- 
2.17.1

