Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4684224947D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgHSFfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:35:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726408AbgHSFfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:35:19 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J5VlD0109554;
        Wed, 19 Aug 2020 01:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vwr/HM6Tx4UUYPe1DHe4AhZf2+E+q7+xfzMK4iL5iQE=;
 b=Jg0xhwZsdMPvcv9YngWpldrtviFEEmoaqVvhFg8dX5sKpfsrC9j/JWWthZQfVMdUbNnA
 gC9cNIjCbhnYfHh0lTPe3cj/Z+DelqvcyXcMKPDHVpJ/Rg7tdAUJKi8Y56MKRxGgaaw0
 Ah1AdlQG//f+d/tUUKXV8syrPji2RmOd9DH1VxaU3j0kPVkZjpaWa+Uselv8w/Z0Lb3i
 q7My1m0zj4HtYpQp1peGP1YtUt+YyFHWluc4DVRVgnDaK+wVKFFys+vH6mxKTBeu0tAw
 ISuSFbyer83oxS3J5Gk2TMljo4POJNVCzvnGdSVgD6YD4yF5StP48wUrtPa+Hf/Hqoje 9g== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 330ucn3acs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 01:35:14 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J5Yk4S029063;
        Wed, 19 Aug 2020 05:35:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3304tkhew6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 05:35:13 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J5ZDxs57540912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 05:35:13 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67161AC05B;
        Wed, 19 Aug 2020 05:35:13 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F1A1AC059;
        Wed, 19 Aug 2020 05:35:13 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.104.33])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 05:35:12 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 1/5] ibmvnic: print caller in several error messages
Date:   Wed, 19 Aug 2020 00:35:08 -0500
Message-Id: <20200819053512.3619-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200819053512.3619-1-ljp@linux.ibm.com>
References: <20200819053512.3619-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 impostorscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190042
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error messages in the changed functions are exactly the same.
In order to differentiate them and make debugging easier,
we print the function names in the error messages.

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5afb3c9c52d2..aba1cd9862ac 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1864,7 +1864,7 @@ static int do_change_param_reset(struct ibmvnic_adapter *adapter,
 
 	if (rc) {
 		netdev_err(adapter->netdev,
-			   "Couldn't initialize crq. rc=%d\n", rc);
+			   "%s: Couldn't initialize crq. rc=%d\n", __func__, rc);
 		return rc;
 	}
 
@@ -2089,7 +2089,7 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	rc = init_crq_queue(adapter);
 	if (rc) {
 		netdev_err(adapter->netdev,
-			   "Couldn't initialize crq. rc=%d\n", rc);
+			   "%s: Couldn't initialize crq. rc=%d\n", __func__, rc);
 		return rc;
 	}
 
@@ -2912,7 +2912,7 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 		rc = ibmvnic_reset_crq(adapter);
 
 	if (rc == H_CLOSED) {
-		dev_warn(dev, "Partner adapter not ready, waiting.\n");
+		dev_warn(dev, "%s: Partner adapter not ready, waiting.\n", __func__);
 	} else if (rc) {
 		dev_warn(dev, "Error %d registering sub-crq\n", rc);
 		goto reg_failed;
@@ -4865,7 +4865,7 @@ static int ibmvnic_reset_crq(struct ibmvnic_adapter *adapter)
 
 	if (rc == H_CLOSED)
 		/* Adapter is good, but other end is not ready */
-		dev_warn(dev, "Partner adapter not ready\n");
+		dev_warn(dev, "%s: Partner adapter not ready\n", __func__);
 	else if (rc != 0)
 		dev_warn(dev, "Couldn't register crq (rc=%d)\n", rc);
 
@@ -4926,7 +4926,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	retrc = rc;
 
 	if (rc == H_CLOSED) {
-		dev_warn(dev, "Partner adapter not ready\n");
+		dev_warn(dev, "%s: Partner adapter not ready\n", __func__);
 	} else if (rc) {
 		dev_warn(dev, "Error %d opening adapter\n", rc);
 		goto reg_crq_failed;
@@ -5129,8 +5129,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	do {
 		rc = init_crq_queue(adapter);
 		if (rc) {
-			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
-				rc);
+			dev_err(&dev->dev, "%s: Couldn't initialize crq. rc=%d\n",
+				__func__, rc);
 			goto ibmvnic_init_fail;
 		}
 
-- 
2.23.0

