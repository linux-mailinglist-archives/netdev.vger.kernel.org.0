Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEE827A4AD
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 02:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgI1AG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 20:06:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7712 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgI1AG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 20:06:28 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S01S8A011919
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9c4DDlsDiq2dkrbteCIFGwD981XIXtBxfO/3AneyRUk=;
 b=J+RA0z0z0r9mv6i+nP/mpb5HWn295P+YHudu/d3Sr2CRJD3PSar9RSY8TIROnG9CdOJn
 T5vmU3nNJRvHPDWRVYID+aiIC9d95L9L4hy8fn2TRkk7D60BcsCpxCPfd8XBsEAv+4yv
 rXuun1dRR9Vd3Yy5OwltVlv+LaowqOgbvjSJ6YwCVCRWm0hEtIgVRHciBv3YJtVnBdFE
 P8xye7VNRRQT6mABwx4Q3OgBtsOZXzZuOpIjo7es69e88Ua8075JezABRcISaaLqNwhr
 wLe0HjzmGpKeiQlOyAqtoj2S8FYOcB1iYN+fTEZ6tINfnh72Z6kC0Im6/0mOS7euO0od AQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33u46ursx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:06:26 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S020mm020398
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:06:26 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 33sw98e1xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:06:26 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S06PnT27394394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 00:06:25 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA94D124052;
        Mon, 28 Sep 2020 00:06:25 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 738CD124054;
        Mon, 28 Sep 2020 00:06:25 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.151.55])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 00:06:25 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] ibmvnic: set up 200GBPS speed
Date:   Sun, 27 Sep 2020 19:06:25 -0500
Message-Id: <20200928000625.79280-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-27_18:2020-09-24,2020-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=856 lowpriorityscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009270226
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the speed according to crq->query_phys_parms.rsp.speed.
Fix IBMVNIC_10GBPS typo.

Fixes: f8d6ae0d27ec ("ibmvnic: Report actual backing device speed and duplex values")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
 drivers/net/ethernet/ibm/ibmvnic.h | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cfaac1a2db7b..c3f6aa87a34d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4590,7 +4590,7 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 	case IBMVNIC_1GBPS:
 		adapter->speed = SPEED_1000;
 		break;
-	case IBMVNIC_10GBP:
+	case IBMVNIC_10GBPS:
 		adapter->speed = SPEED_10000;
 		break;
 	case IBMVNIC_25GBPS:
@@ -4605,6 +4605,9 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 	case IBMVNIC_100GBPS:
 		adapter->speed = SPEED_100000;
 		break;
+	case IBMVNIC_200GBPS:
+		adapter->speed = SPEED_200000;
+		break;
 	default:
 		if (netif_carrier_ok(netdev))
 			netdev_warn(netdev, "Unknown speed 0x%08x\n", rspeed);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index f8416e1d4cf0..43feb96b0a68 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -373,7 +373,7 @@ struct ibmvnic_phys_parms {
 #define IBMVNIC_10MBPS		0x40000000
 #define IBMVNIC_100MBPS		0x20000000
 #define IBMVNIC_1GBPS		0x10000000
-#define IBMVNIC_10GBP		0x08000000
+#define IBMVNIC_10GBPS		0x08000000
 #define IBMVNIC_40GBPS		0x04000000
 #define IBMVNIC_100GBPS		0x02000000
 #define IBMVNIC_25GBPS		0x01000000
-- 
2.22.0

