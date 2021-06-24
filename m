Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6463B2613
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhFXEQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:16:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230020AbhFXEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O43xXE146950
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=09hO6cMfAvFjCA4MhOG11U/cPVddaXswRwTLzdtX6uw=;
 b=TDJ3lRBHc6+nSIleD4gi/n2bjhbi6upq5A1iIimEXLh8npdSKQAnZZSX2jZlEntwZlBC
 z0g9T1jiOnqbV3ym76vG8q2xzOFgV2pmUT3H7bY24wSCa8AR4/KbKiDnxLE+GeTeRKU/
 41VzGR65HB78HRPB4YQvbohZqB3O+ebxLjQt5tNxBvEAt6cn02ILW9FTWNvycPGbRbQ5
 svVbyenSDv6viM3XW1YNKGBcWyiLk41e6qwsGWabSyZlBXPzR5NWj6Ikl3QBDe7H1jXL
 hk03JUiJbRuhrOuJQ935ursJhe/89EAWip/g9XTldNAH9Zqr5iWVuENkJEf/8LTEZba0 iA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39cg7cbja6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:20 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O4AQuD009788
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:19 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 399wjgqf06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:19 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DI7E24445318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:18 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169AE6A04D;
        Thu, 24 Jun 2021 04:13:18 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02BA36A047;
        Thu, 24 Jun 2021 04:13:16 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:16 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 0/7] ibmvnic: Assorted bug fixes
Date:   Wed, 23 Jun 2021 21:13:09 -0700
Message-Id: <20210624041316.567622-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6GmzOuhsDfMsxWVBcq_EVHl93CFAIT4j
X-Proofpoint-GUID: 6GmzOuhsDfMsxWVBcq_EVHl93CFAIT4j
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 clxscore=1011 phishscore=0 mlxlogscore=868
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assorted bug fixes that we tested over the last several weeks.

Thanks to Brian King, Cris Forno, Dany Madden and Rick Lindsley for
reviews and help with testing.

Dany Madden (1):
  Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Sukadev Bhattiprolu (6):
  Revert "ibmvnic: simplify reset_long_term_buff function"
  ibmvnic: clean pending indirect buffs during reset
  ibmvnic: account for bufs already saved in indir_buf
  ibmvnic: set ltb->buff to NULL after freeing
  ibmvnic: free tx_pool if tso_pool alloc fails
  ibmvnic: parenthesize a check

 drivers/net/ethernet/ibm/ibmvnic.c | 101 ++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 24 deletions(-)

-- 
2.31.1

