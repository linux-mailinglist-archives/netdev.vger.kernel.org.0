Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51F915D34A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 08:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgBNH7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 02:59:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728833AbgBNH7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 02:59:17 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01E7xGxJ124317
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:59:16 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y57at6jvs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:59:16 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Fri, 14 Feb 2020 07:59:11 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 07:59:09 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01E7x8mO30212538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 07:59:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA7E311C050;
        Fri, 14 Feb 2020 07:59:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6E0D11C05B;
        Fri, 14 Feb 2020 07:59:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 07:59:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 2/2] net/smc: no peer ID in CLC decline for SMCD
Date:   Fri, 14 Feb 2020 08:59:00 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214075900.31624-1-kgraul@linux.ibm.com>
References: <20200214075900.31624-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20021407-4275-0000-0000-000003A15C0F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021407-4276-0000-0000-000038B55F86
Message-Id: <20200214075900.31624-3-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_02:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 suspectscore=1 mlxscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=689 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Just SMCR requires a CLC Peer ID, but not SMCD. The field should be
zero for SMCD.

Fixes: c758dfddc1b5 ("net/smc: add SMC-D support in CLC messages")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 0879f7bed967..86cccc24e52e 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -372,7 +372,9 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
 	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
 	dclc.hdr.version = SMC_CLC_V1;
 	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
-	memcpy(dclc.id_for_peer, local_systemid, sizeof(local_systemid));
+	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
+		memcpy(dclc.id_for_peer, local_systemid,
+		       sizeof(local_systemid));
 	dclc.peer_diagnosis = htonl(peer_diag_info);
 	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
 
-- 
2.17.1

