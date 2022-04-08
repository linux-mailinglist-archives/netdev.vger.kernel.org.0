Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3454F9911
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiDHPNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbiDHPNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:13:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0EBFFF73;
        Fri,  8 Apr 2022 08:11:03 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238Ep6G1011340;
        Fri, 8 Apr 2022 15:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=nZP5FKcJ/bDnqhaRU0bck2NjZ96F4O/Ot2aCrJylgkM=;
 b=Fq7+1ZWM/fq0QtJYzK5aVx9j0ILcdm/oGdNjyvyp5gPb7HgUEUHdkzjAPpMcdwq2gkMF
 ++3SBwgLrVQq94/HNlLpMm8I5PH8cxyOcKCrcN08LA2/4RHtSj9MJa3rcNWNb9D6B/MV
 Cph1IsTdVw/SuyxIUHHJCLNQPmJQj70IVlDDTD+g7+wDuNzuSVcJujFtaBfF57Qq/MUw
 UsAB8kv8UeN4vT1CtyUEYKVI/d7dK6zve/TateYEwuVrI1cPoCRpgNBQbbhhC0b5fdUV
 01hSN22nnkjtl6I5lktLSouwPWiQ5o12pRvA+gpDEo/HAImbZVhuf0ld0srG9wi8HbUC /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3faewj2uvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:00 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 238EfjCQ019760;
        Fri, 8 Apr 2022 15:10:59 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3faewj2uup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:10:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 238F3NGY010484;
        Fri, 8 Apr 2022 15:10:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e49416a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:10:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 238FAsLH51315014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Apr 2022 15:10:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45A2652050;
        Fri,  8 Apr 2022 15:10:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 086D95204F;
        Fri,  8 Apr 2022 15:10:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, alibuda@linux.alibaba.com
Subject: [PATCH net 0/3] net/smc: fixes 2022-04-08
Date:   Fri,  8 Apr 2022 17:10:32 +0200
Message-Id: <20220408151035.1044701-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3utuZUMh_H7s9STXMT-gSv_TSMJxLEei
X-Proofpoint-GUID: QM0Uxj-ey3m-2NU8sii6KlLN5nfOelZ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=757 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patches to netdev's net tree.

Patch 1 fixes two usages of snprintf() with non null-terminated
string which results into an out-of-bounds read.
Pach 2 fixes a syzbot finding where a pointer check was missed
before the call to dev_name().
Patch 3 fixes a crash when already released memory is used as
a function pointer.

Karsten Graul (3):
  net/smc: use memcpy instead of snprintf to avoid out of bounds read
  net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()
  net/smc: Fix af_ops of child socket pointing to released memory

 net/smc/af_smc.c   | 14 ++++++++++++--
 net/smc/smc_clc.c  |  6 ++++--
 net/smc/smc_pnet.c |  5 +++--
 3 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.32.0

