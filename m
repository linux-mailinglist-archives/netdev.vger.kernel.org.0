Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475AB520EB4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbiEJHh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbiEJHJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:09:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEE028FE9E;
        Tue, 10 May 2022 00:05:23 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A5Uwno007538;
        Tue, 10 May 2022 07:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Uev775ajJKB6nn1CC3E0xG33HCGkmMqZ0qE/0h6f/Xs=;
 b=U94dxPAm+PPQhpealysugn+H1FAPfD0YkoAyPcGZtRL1K/ImT0NwCFi9Ykp+y6pV7sWu
 bdXpgTe9soYF9j6t1bbqs5mCnD5RCttANfLf5/ZIkZkhlqn7TQ6bcXb3KRKOjTf96BbC
 DMmZJoernO5iST+tuElu7cKlMO/8/ne4ZEOzPsAqL5859Qq+yca6qSW3Vf0PoanVK0Cd
 aIb//kVPYrpg84Kz/m4bVz7o8Sq0E01C7y8+o8U0IlNp0BfZEyiAtcvVHFDE8e4uspNE
 v7u3m5G36xmou6RyaWRQelU5SLTTqtHc5/ozB1xa769b5UNd1wvPU4rES3h1JdrHKVKU 4w== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyhyjhgx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:05:20 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24A71fRt002912;
        Tue, 10 May 2022 07:05:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3fwgd8tsjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:05:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24A75Fdt55247284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 07:05:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E60ABA405B;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4BFCA4054;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 94DF4E05FE; Tue, 10 May 2022 09:05:14 +0200 (CEST)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 0/3] s390/net: Cleanup some code checker findings
Date:   Tue, 10 May 2022 09:05:05 +0200
Message-Id: <20220510070508.334726-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fpuN6MBf6yE92oTlBj5WyDaPBPK6Lz3y
X-Proofpoint-GUID: fpuN6MBf6yE92oTlBj5WyDaPBPK6Lz3y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clean up smatch findings in legacy code. I was not able to provoke
any real failures on my systems, but other hardware reactions,
timing conditions or compiler output, may cause failures.

There are still 2 smatch warnings left in s390/net:

drivers/s390/net/ctcm_main.c:1326 add_channel() warn: missing error code 'rc'
This one is a false positive.

drivers/s390/net/netiucv.c:1355 netiucv_check_user() warn: argument 3 to %02x specifier has type 'char'
Postponing this one, need to better understand string handling in iucv.

There are several sparse warnings left in ctcm, like:
drivers/s390/net/ctcm_fsms.c:573:9: warning: context imbalance in 'ctcm_chx_setmode' - different lock contexts for basic block
Those are mentioned in the source, no plan to rework.

Alexandra Winter (3):
  s390/ctcm: fix variable dereferenced before check
  s390/ctcm: fix potential memory leak
  s390/lcs: fix variable dereferenced before check

 drivers/s390/net/ctcm_mpc.c   | 6 +-----
 drivers/s390/net/ctcm_sysfs.c | 5 +++--
 drivers/s390/net/lcs.c        | 7 ++++---
 3 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.32.0

