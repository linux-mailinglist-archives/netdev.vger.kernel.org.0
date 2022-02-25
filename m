Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E54C4E44
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiBYTFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiBYTFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:05:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2CE1B8BD2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:04:29 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PIUqRv028322;
        Fri, 25 Feb 2022 19:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=tILJ63lwMli/7ObXqYB088vpVKDbCGKSh5/KbR1qUNE=;
 b=CGBdOIOozLeNkzshAxZSB9f9a7wxWq+fZsnRxwtYFskBvOwUugQiBwISJvS7YRDO5YWM
 r2P8nSVnnVGCZCuaawDmGRe1BDiZYatnZus/zEJvyuWIgeg5aGIEEg0BSdrM/yl52iOg
 6RNxL6vWSrkTJegzCflkYA1z3JVZxFxOrh7VqJXZ4/i3dOttnLRZuTc6arzdNXR0mLV+
 wJiQeusvutqq4uJlm7gU0VC7EuI/MSH/QINWUHr4U58WgzweI+qwa1iuDQQN0PuB+olB
 NWLHC9zYnQXReh0wmEGjQIVbgh5qFBe4TxuSpizJ7VAIOQP/mt/DOCzNRNou/YBGzKfO XQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ef4ey8pxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 19:04:26 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PIwXes016838;
        Fri, 25 Feb 2022 19:04:25 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3ed22fd4d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 19:04:25 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PJ4O1q47907298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 19:04:24 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B156812405C;
        Fri, 25 Feb 2022 19:04:24 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4F8F124054;
        Fri, 25 Feb 2022 19:04:23 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.165.221])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 19:04:23 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/1] ibmvnic: make reinit_init_done() non-inline
Date:   Fri, 25 Feb 2022 11:04:23 -0800
Message-Id: <20220225190423.1442437-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9LhjT5wmGP2yGosISTpQxwQVOtAaXpPf
X-Proofpoint-GUID: 9LhjT5wmGP2yGosISTpQxwQVOtAaXpPf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per netdev recommendations, drop the inline on reinit_init_done().

Fixes: ae16bf15374d ("ibmvnic: init init_done_rc earlier")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b423e94956f1..a9966819f12f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2219,7 +2219,7 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
  * we don't miss the notification/error, initialize these _before_
  * regisering the CRQ.
  */
-static inline void reinit_init_done(struct ibmvnic_adapter *adapter)
+static void reinit_init_done(struct ibmvnic_adapter *adapter)
 {
 	reinit_completion(&adapter->init_done);
 	adapter->init_done_rc = 0;
-- 
2.27.0

