Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072834BEC32
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiBUVES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:04:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiBUVES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:04:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5956A23BCD
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:03:54 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LJGb3O009989
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 21:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2oZB/8rhLzzOkrdZaZoB9d0avIwcwiWZvS7+BQzltUY=;
 b=oWRZw6r8bcqA6IZPHc55b7y6uWqpuMtA1PfboOcZ1t5da3Yr1BxinPLuOXttyz4qkRpr
 1hT0Jlg4gMKebYrQB0d8YUb55fy6FrkQmO1U4rdB4Nehjm2qTOxa6+JOuRICDC/wtZhP
 LcUrq6gWFpVIC2FyCBmUQm1OFxbktdeeJC3OiFGLO0JDse8bbVfYOJjE+nFpJ5fKjWDp
 S4E3T06cqCifwQoqj079xbnVEm1969C3awVud0pBKGjJB44e5bUCOs89SpqxcU87Ty5X
 zR4nvYiqEFtSpmOzFvAjwPFcdfubMl7mic6OEXhsAYQHI1ZEmk5YIvVsdNeC/QhBktfK IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ecgrma1u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 21:03:53 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LKmanQ009180
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 21:03:53 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ecgrma1u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 21:03:53 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LL38Wd032303;
        Mon, 21 Feb 2022 21:03:52 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3ear6a5m0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 21:03:52 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LL3oM227132242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 21:03:50 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1AB113604F;
        Mon, 21 Feb 2022 21:03:50 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AF72136063;
        Mon, 21 Feb 2022 21:03:50 +0000 (GMT)
Received: from ltcden12-lp22.aus.stglabs.ibm.com (unknown [9.40.195.165])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 21:03:50 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, cforno12@outlook.com
Subject: [PATCH net] ibmvnic: schedule failover only if vioctl fails
Date:   Mon, 21 Feb 2022 15:05:45 -0600
Message-Id: <20220221210545.115283-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iVc8jJnHp_lVDjZVmc1iNuU8Jrpes_qz
X-Proofpoint-ORIG-GUID: MfrNzsoYFp6nsxZ3jKXuYV573NgNO3iE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_10,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

If client is unable to initiate a failover reset via H_VIOCTL hcall, then
it should schedule a failover reset as a last resort. Otherwise, there is
no need to do a last resort.

Fixes: 334c42414729 ("ibmvnic: improve failover sysfs entry")
Reported-by: Cris Forno <cforno12@outlook.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 29617a86b299..dee05a353dbd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5917,10 +5917,14 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 		   be64_to_cpu(session_token));
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
 				H_SESSION_ERR_DETECTED, session_token, 0, 0);
-	if (rc)
+	if (rc) {
 		netdev_err(netdev,
 			   "H_VIOCTL initiated failover failed, rc %ld\n",
 			   rc);
+		goto last_resort;
+	}
+
+	return count;
 
 last_resort:
 	netdev_dbg(netdev, "Trying to send CRQ_CMD, the last resort\n");
-- 
2.26.2

