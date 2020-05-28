Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61911E674C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404997AbgE1QTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:19:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404897AbgE1QTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:19:30 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04SGIPKK033315;
        Thu, 28 May 2020 12:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=RPYdIrOwgEJRKUgO0dYDvYyj/rrejhyKyktfZRcvS68=;
 b=F4E/OjF6l7i/fg/KKj3LUDWqIsLQVaEQQ1BoauVQ7jF58YXUqDk0j3Q5bCbj9FoNY100
 YvpzZAaIzbCz89UgRQHHeO/Vbp8vWj3bV2E4wRc29WagqujplKadks6W6BTLnIgXWFwq
 Y442KiG9RjAA+8cibrWVwhTHVEudVhu7rVoUvdYOvhO1KyNvuAIyXKC//Q9S12Ft98jB
 GW2YC5myQy7rCMrK28/wMhuo6tdGXEuWlhP0up7rpww1gQClovibKAQ5JLmX2uDuunwD
 FFnWAjY0avDvhW5OvnO9UVkVEB4fN/NKv1CAdKe+Pj0VCnWM0zWGm7/2t6rTAcPpYvl1 3Q== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 319shjgvpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 12:19:25 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04SGF5Iv015683;
        Thu, 28 May 2020 16:19:24 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 316ufax7h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 16:19:24 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04SGJMON19792352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 16:19:22 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3CC2BE04F;
        Thu, 28 May 2020 16:19:22 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5CB0BE053;
        Thu, 28 May 2020 16:19:22 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.163.50.102])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 28 May 2020 16:19:22 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] drivers/net/ibmvnic: Update VNIC protocol version reporting
Date:   Thu, 28 May 2020 11:19:17 -0500
Message-Id: <1590682757-3814-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-28_03:2020-05-28,2020-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 mlxlogscore=952 priorityscore=1501 clxscore=1011 spamscore=0
 lowpriorityscore=0 suspectscore=1 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VNIC protocol version is reported in big-endian format, but it
is not byteswapped before logging. Fix that, and remove version
comparison as only one protocol version exists at this time.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 621a6e0..f2c7160 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4689,12 +4689,10 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			dev_err(dev, "Error %ld in VERSION_EXCHG_RSP\n", rc);
 			break;
 		}
-		dev_info(dev, "Partner protocol version is %d\n",
-			 crq->version_exchange_rsp.version);
-		if (be16_to_cpu(crq->version_exchange_rsp.version) <
-		    ibmvnic_version)
-			ibmvnic_version =
+		ibmvnic_version =
 			    be16_to_cpu(crq->version_exchange_rsp.version);
+		dev_info(dev, "Partner protocol version is %d\n",
+			 ibmvnic_version);
 		send_cap_queries(adapter);
 		break;
 	case QUERY_CAPABILITY_RSP:
-- 
1.8.3.1

