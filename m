Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93602C5D16
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390862AbgKZUja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:39:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731876AbgKZUja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 15:39:30 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKWYwt135982;
        Thu, 26 Nov 2020 15:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=pmIMzYQBt29CRMNybnh56i8MrKprOvl+WEisRXkv0fs=;
 b=fMh2kghYLUoSkMPzFvjJh4RtYuIXaMd5Br3l1UuaOTARK0j7TGm+4sWJuo8FDpw1Xj3J
 lZKLnBarlkgP3+nl6kcZFZOQhZsxOosVozawzR6TyeY6TAUPCudFP4xV9NvZJzRq1PWg
 NSAJOE89uX0dLBN02x+H6/4U6VWYt3Q2FcfA6jWOD1WsKF+XzCAgmI5gDidnBNOyRP7C
 Dr/EmN2lN8o5bUGQmbl+YUCm998/O1Mv3jkGfxcVplI+aXyH0EvsktwEe1s6kcZft8TH
 Nsrf0y3Y+Q4PvZemDgqQ+WUeTJCCb/t0a2nLe9uGJpDN3XUMDuGTvAx2VnJY4jmNgaHQ bg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352kdg05kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:39:26 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKbO9i001629;
        Thu, 26 Nov 2020 20:39:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 351pca0qk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 20:39:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQKdLcs55902638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 20:39:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03D25A404D;
        Thu, 26 Nov 2020 20:39:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1DF1A4040;
        Thu, 26 Nov 2020 20:39:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 20:39:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v6 00/14] net/smc: Add support for generic netlink API
Date:   Thu, 26 Nov 2020 21:39:02 +0100
Message-Id: <20201126203916.56071-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_09:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=740 suspectscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

Up to version 4 this patch series was using the sock_diag netlink
infrastructure. This version is using the generic netlink API. Generic
netlink API offers a better type safety between kernel and userspace
communication.
Using the generic netlink API the smc module can now provide information
about SMC linkgroups, links and devices (both for SMC-R and SMC-D).

v2: Add missing include to uapi header smc_diag.h.

v3: Apply code style recommendations from review comments.
    Instead of using EXPORTs to allow the smc_diag module to access
    data of the smc module, introduce struct smc_diag_ops and let
    smc_diag access the required data using function pointers.

v4: Address checkpatch.pl warnings. Do not use static inline for
    functions.

v5: Use generic netlink API instead of the sock_diag netlink
    infrastructure.

v6: Integrate more review comments from Jakub.

Guvenc Gulce (13):
  net/smc: Use active link of the connection
  net/smc: Add connection counters for links
  net/smc: Add link counters for IB device ports
  net/smc: Add diagnostic information to smc ib-device
  net/smc: Add diagnostic information to link structure
  net/smc: Refactor smc ism v2 capability handling
  net/smc: Introduce generic netlink interface for diagnostic purposes
  net/smc: Add support for obtaining system information
  net/smc: Introduce SMCR get linkgroup command
  net/smc: Introduce SMCR get link command
  net/smc: Add SMC-D Linkgroup diagnostic support
  net/smc: Add support for obtaining SMCD device list
  net/smc: Add support for obtaining SMCR device list

Karsten Graul (1):
  net/smc: use helper smc_conn_abort() in listen processing

 include/uapi/linux/smc.h | 126 +++++++++++++
 net/smc/Makefile         |   2 +-
 net/smc/af_smc.c         |  39 ++--
 net/smc/smc_clc.c        |   5 +
 net/smc/smc_clc.h        |   1 +
 net/smc/smc_core.c       | 399 ++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_core.h       |  49 +++++
 net/smc/smc_diag.c       |  23 +--
 net/smc/smc_ib.c         | 200 ++++++++++++++++++++
 net/smc/smc_ib.h         |   6 +
 net/smc/smc_ism.c        |  99 +++++++++-
 net/smc/smc_ism.h        |   6 +-
 net/smc/smc_netlink.c    |  78 ++++++++
 net/smc/smc_netlink.h    |  32 ++++
 net/smc/smc_pnet.c       |   2 +
 15 files changed, 1022 insertions(+), 45 deletions(-)
 create mode 100644 net/smc/smc_netlink.c
 create mode 100644 net/smc/smc_netlink.h

-- 
2.17.1

