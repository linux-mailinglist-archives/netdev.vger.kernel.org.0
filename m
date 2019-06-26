Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88B756DFE
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFZPsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:48:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726104AbfFZPsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:48:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QFm1Xi141487
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:48:04 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcb189u35-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:48:04 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Wed, 26 Jun 2019 16:48:02 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Jun 2019 16:48:00 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5QFlv3h50069596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 15:47:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B347AE045;
        Wed, 26 Jun 2019 15:47:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA243AE04D;
        Wed, 26 Jun 2019 15:47:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jun 2019 15:47:56 +0000 (GMT)
From:   Ursula Braun <ubraun@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com, zhp@smail.nju.edu.cn,
        yuehaibing@huawei.com
Subject: [PATCH net 2/2] net/smc: Fix error path in smc_init
Date:   Wed, 26 Jun 2019 17:47:50 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626154750.46127-1-ubraun@linux.ibm.com>
References: <20190626154750.46127-1-ubraun@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062615-0020-0000-0000-0000034D9C20
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062615-0021-0000-0000-000021A112AB
Message-Id: <20190626154750.46127-3-ubraun@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=779 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260185
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

If register_pernet_subsys success in smc_init,
we should cleanup it in case any other error.

Fixes: 64e28b52c7a6 (net/smc: add pnet table namespace support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0c874e996f85..7621ec2f539c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2029,7 +2029,7 @@ static int __init smc_init(void)
 
 	rc = smc_pnet_init();
 	if (rc)
-		return rc;
+		goto out_pernet_subsys;
 
 	rc = smc_llc_init();
 	if (rc) {
@@ -2080,6 +2080,9 @@ static int __init smc_init(void)
 	proto_unregister(&smc_proto);
 out_pnet:
 	smc_pnet_exit();
+out_pernet_subsys:
+	unregister_pernet_subsys(&smc_net_ops);
+
 	return rc;
 }
 
-- 
2.17.1

