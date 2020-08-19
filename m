Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE43324A9B7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgHSWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:52:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11794 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbgHSWwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:52:35 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JMZO0q141415;
        Wed, 19 Aug 2020 18:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hf7lEKz91x4x/xMqUfsAq8ICRpolLRo5guvOINRuTGM=;
 b=l1XnvpoL0vJhIuQNQSjFfHr/ZNLVOwcUJsEMHvPd7FoFaRvBHNcAb8p46FsKkr0OVRe2
 gHRmTBFDqe85ktM4mrHBzylE3jULxl14D96T5NxkZ5wXwg1eL571x2JVIVpeYtgh+hcR
 uv81XD1ewC2+fdafjt2nCpyGi4OXErLvHFQmmcAYudGe7w7xLqy1UPaXFukCMDfALTWG
 MWRyGsXEcUSZXvrjKmF1mRNWqd0iI/lZlgE/LPmXZJ3dLhJr80orBIzspWpp4oOczr37
 44Mq/kwixpD8eOzrt4t0UghxZABiOzH6fW4htlK9UGD6uqCjAbesbsiIiryvTt9rr+Os 2Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r4xwp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 18:52:30 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JMnYKF016677;
        Wed, 19 Aug 2020 22:52:29 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3304ccucs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 22:52:29 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JMqRRc44040466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 22:52:27 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFD8DBE04F;
        Wed, 19 Aug 2020 22:52:27 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40AA5BE051;
        Wed, 19 Aug 2020 22:52:27 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.63.43])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 22:52:27 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 0/4] refactoring of ibmvnic code
Date:   Wed, 19 Aug 2020 17:52:22 -0500
Message-Id: <20200819225226.10152-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 priorityscore=1501 suspectscore=1 mlxlogscore=700 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series refactor reset_init and init functions,
and make some other cosmetic changes to make the code
easier to read and debug. v2 removes __func__ and v1's 1/5.

Lijun Pan (4):
  ibmvnic: compare adapter->init_done_rc with more readable
    ibmvnic_rc_codes
  ibmvnic: improve ibmvnic_init and ibmvnic_reset_init
  ibmvnic: remove never executed if statement
  ibmvnic: merge ibmvnic_reset_init and ibmvnic_init

 drivers/net/ethernet/ibm/ibmvnic.c | 84 ++++++++----------------------
 1 file changed, 21 insertions(+), 63 deletions(-)

-- 
2.23.0

