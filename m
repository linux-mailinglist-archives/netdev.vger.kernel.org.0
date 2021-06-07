Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D73639E669
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFGSWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:22:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230266AbhFGSW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:22:29 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157I372K135897;
        Mon, 7 Jun 2021 14:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gGaZcnGDLWgZB6TLbn7fB/8GElv3gNq4DTe/6Ybs81g=;
 b=QCxOQ/d02XIChJMXoCzxym6CyOsVhJM6QGBngiG14Ltp/Wt9fu9Wq2NfdK2B5aOyEXpR
 OCLg0nnVSk8C2fnDc/RDl8iaewqNrY4aGJJGeiVSSYq2+74ebm1BFt/csqyHFTz6YGtP
 WZG9F3Ucj5trZwQRGgngCRxyrC5knVGr4i4zyVgmAyJo/7FLpUSxYaPqroDOhG/jlwko
 3TnzCwSF4sMO/kIskmxj2G2U8u6pR83h3hJ/0AO0c6Hu44RLm6bY31BwyzWh3KDWCk8D
 O+VLnvTUXu25DadAiVrTAgeeJJoxC2wAc0ULRaMdkUvjuRMlGHLGRhO3DajGZ5Qv8Xhk 1g== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 391r9q0ksc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 14:20:36 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 157IBlmv025552;
        Mon, 7 Jun 2021 18:20:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3900hhgke6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Jun 2021 18:20:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 157IKU6723134660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Jun 2021 18:20:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54887A4055;
        Mon,  7 Jun 2021 18:20:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A4C9A4053;
        Mon,  7 Jun 2021 18:20:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Jun 2021 18:20:30 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 0/4] net/smc: Add SMC statistic support
Date:   Mon,  7 Jun 2021 20:20:10 +0200
Message-Id: <20210607182014.3384922-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f-YetUM1KquOa2xrEFfX4K08FEdE4AGO
X-Proofpoint-GUID: f-YetUM1KquOa2xrEFfX4K08FEdE4AGO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_14:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=996
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

The patchset adds statistic support to the SMC protocol. Per-cpu
variables are used to collect the statistic information for better
performance and for reducing concurrency pitfalls. The code that is
collecting statistic data is implemented in macros to increase code
reuse and readability.
The generic netlink mechanism in SMC is extended to provide the
collected statistics to userspace.
Network namespace awareness is also part of the statistics
implementation.

Guvenc Gulce (4):
  net/smc: Add SMC statistics support
  net/smc: Add netlink support for SMC statistics
  net/smc: Add netlink support for SMC fallback statistics
  net/smc: Make SMC statistics network namespace aware

 include/net/net_namespace.h |   4 +
 include/net/netns/smc.h     |  16 ++
 include/uapi/linux/smc.h    |  83 ++++++++
 net/smc/Makefile            |   2 +-
 net/smc/af_smc.c            | 102 +++++++--
 net/smc/smc_core.c          |  13 +-
 net/smc/smc_netlink.c       |  11 +
 net/smc/smc_netlink.h       |   2 +-
 net/smc/smc_rx.c            |   8 +
 net/smc/smc_stats.c         | 413 ++++++++++++++++++++++++++++++++++++
 net/smc/smc_stats.h         | 266 +++++++++++++++++++++++
 net/smc/smc_tx.c            |  18 +-
 12 files changed, 917 insertions(+), 21 deletions(-)
 create mode 100644 include/net/netns/smc.h
 create mode 100644 net/smc/smc_stats.c
 create mode 100644 net/smc/smc_stats.h

-- 
2.25.1

