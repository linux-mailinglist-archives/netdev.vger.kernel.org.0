Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA72BB941
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgKTWk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62444 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729048AbgKTWk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMZUJF152794
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jkS+MWeWO14I1ytfUlJep0XYSgaXWpyvHbZPhiEsKXo=;
 b=dwrVri+BM19n9UqCTIXET3JDjyOcSHXKVMtjSp5ugAQ7jr/K0MsMNe9TuO6CLs1xARlD
 z1WsA8JRq3xGd6WvDVY4MfEqdYlXuuJN00cu+U7w/VRsXNentpPwUVFLWOpC7aALMJLi
 H3oF95KZLQj99isptzIDSBMzp04Vq0OMzJo5QkT3mgeVbBoI6A1UkWmFmdKVnSe2oxOI
 LN16yjKha0ULCcF68ERJaNCQ0pwGF9+IILH+HCGR7VG9N5BZciVwaTNMZZvH1qBhlHgM
 wkQF1Pz+V7/Vcza+BNR80cVSu7nJAiuCcBqHHGgEY+v1uq2iQxhWZvZTtirYzyn3A/c5 NA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xdt082xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:56 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbiRL019549
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:55 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 34w263h7yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMespo7144100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:54 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D18D6E052;
        Fri, 20 Nov 2020 22:40:54 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99A006E050;
        Fri, 20 Nov 2020 22:40:53 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:53 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 04/15] ibmvnic: remove free_all_rwi function
Date:   Fri, 20 Nov 2020 16:40:38 -0600
Message-Id: <20201120224049.46933-5-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 suspectscore=3
 adultscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=897 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

Remove free_all_rwi() since it is no longer used. (__ibmvnic_remove() was
the last user of free_all_rwi()).

Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9e097c05e249..f0924019e617 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2211,17 +2211,6 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
 	return rwi;
 }
 
-static void free_all_rwi(struct ibmvnic_adapter *adapter)
-{
-	struct ibmvnic_rwi *rwi;
-
-	rwi = get_next_rwi(adapter);
-	while (rwi) {
-		kfree(rwi);
-		rwi = get_next_rwi(adapter);
-	}
-}
-
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_rwi *rwi;
-- 
2.23.0

