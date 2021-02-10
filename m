Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C63315FE5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhBJHQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:16:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230357AbhBJHQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:16:26 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11A7DQsw015194
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 02:15:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=cJuSFmGLdxQu+oxTazVlPWsmrJEtZ85b151jKw6okvw=;
 b=P3b0BmtB1014cxDb9mYza3lqVJWQgPOkoA1F6lQdidqNh18jq6UIlOKNv0uaQtCJ5P3L
 +ey0K7qWs/R3+r+C3w2Kl1qjgbtgQvLbd/pZ8GeATQGgXC7Hv9VyNvVQdgXKXT2K2I/Z
 7oCc2pBJQKl4rr8U+aJoUFelw8HSE2RIlzT0vRwgBxDBLrm9D++2ngnEMMgWOZK1WBqu
 HDuF78MQJi8tJVfoMtLU8u+bNubi8lamoDaQuy492+s0wh03D+FT5baPLcEOeUgzt7ea
 L6wZ2F8mhnAuXIUX7SrVxH1yS/GNL/g4StPK/8uANK/mEUZ4fKXF+y0D4NgmqQb/iaem IA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mawer21j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 02:15:45 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11A72hBo020270
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:15:44 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 36hjr9bf00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:15:44 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11A7FgXh38404518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 07:15:42 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30E306E058;
        Wed, 10 Feb 2021 07:15:42 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B80C6E05D;
        Wed, 10 Feb 2021 07:15:41 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.171.114])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 07:15:41 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 12C972E2713; Tue,  9 Feb 2021 23:15:39 -0800 (PST)
Date:   Tue, 9 Feb 2021 23:15:38 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@us.ibm.com,
        abdhalee@in.ibm.com
Subject: [PATCH net] ibmvnic: Set to CLOSED state even on error
Message-ID: <20210210071538.GB852317@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_02:2021-02-09,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=990 clxscore=1015 malwarescore=0 impostorscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From f6a04bc0abfae1065577888fc6467f9f162863f6 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Wed, 3 Feb 2021 13:15:23 -0800
Subject: [PATCH net] ibmvnic: Set to CLOSED state even on error

If set_link_state() fails for any reason, we still cleanup the adapter
state and cannot recover from a partial close anyway. Also, the reset
functions do not check for the CLOSING state. So better to set adapter
to CLOSED state.

Found this while investigating a problem reported by Abdul Haleem.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e51a7f2d00cb..1ec0dca80738 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1367,10 +1367,8 @@ static int __ibmvnic_close(struct net_device *netdev)
 
 	adapter->state = VNIC_CLOSING;
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
-	if (rc)
-		return rc;
 	adapter->state = VNIC_CLOSED;
-	return 0;
+	return rc;
 }
 
 static int ibmvnic_close(struct net_device *netdev)
-- 
2.26.2

