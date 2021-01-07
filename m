Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80672ED586
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbhAGRZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:25:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728687AbhAGRZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:25:36 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107H8O7Z068554;
        Thu, 7 Jan 2021 12:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=k3avbKnpzS4lKnM+KPQB6cJP3/VcR9/pKVa1nEHJNtI=;
 b=CpaH/oguZywH8jegxmDASKY/+Lc124FnVFFGaeLzdRmcmvtOb7NGxLKM11mTOuPn/RyW
 fgyHbRaGZ+4+guJgBdcR7QUB75pjOCTJYPHkxqs5Uod/x6diZ/wbodCHFzhf6K0J5F7o
 uhx7cwEmiRfGJV1VSmygOtWN3OaagMql4xjOn3VkM4BVqegNd/IegGJ8zd8riN3tX4y/
 KOiPJeFI7L2D9GqSSKoJfAlefTM4d1t7SgGcWNo/dS68ddD8J0n21ioH+w4VVr+62F92
 /J47SdVYdVW6ugGLoKJj3qDPyEI8qsqMn1hL3o1IYtJZxvXNqATClJdzjvPFbGEZuuLx LA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x5juhxfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 12:24:52 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107HCsC6006028;
        Thu, 7 Jan 2021 17:24:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 35tgf8d2hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 17:24:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107HOltU41156898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 17:24:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B468C42042;
        Thu,  7 Jan 2021 17:24:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 621C542041;
        Thu,  7 Jan 2021 17:24:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 17:24:47 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/3] s390/qeth: fixes 2021-01-07
Date:   Thu,  7 Jan 2021 18:24:39 +0100
Message-Id: <20210107172442.1737-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=722
 malwarescore=0 impostorscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series to netdev's net tree.

This brings two locking fixes for the device control path.
Also one fix for a path where our .ndo_features_check() attempts to
access a non-existent L2 header.

Thanks,
Julian

Julian Wiedmann (3):
  s390/qeth: fix deadlock during recovery
  s390/qeth: fix locking for discipline setup / removal
  s390/qeth: fix L2 header access in qeth_l3_osa_features_check()

 drivers/s390/net/qeth_core.h      |  3 ++-
 drivers/s390/net/qeth_core_main.c | 38 ++++++++++++++++++++-----------
 drivers/s390/net/qeth_l2_main.c   |  2 +-
 drivers/s390/net/qeth_l3_main.c   |  4 ++--
 4 files changed, 30 insertions(+), 17 deletions(-)

-- 
2.17.1

