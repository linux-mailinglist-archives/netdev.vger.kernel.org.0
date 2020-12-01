Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42D62CABAC
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbgLATVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727356AbgLATVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:44 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J1mYV016338;
        Tue, 1 Dec 2020 14:20:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=nJ73qEeoPcFco+yh31NxdCpItmVWgECyZxJ7ymn532M=;
 b=oVrrpE5zgjbfFIQqaGT+KmI6LccX+ccNqPjKy/alSHgVIH6++0JIl6R/imrqnxgDyMlN
 CXLZHgmOmDOmx6VlwSsvsOViSvl1/ziYtB5OXmfnOdgBX9cQPC4CuJyQV74/qgC4Ef7i
 I0uSWY+CoRbPz/GuX51K0aEAFvkHgR0zy/4TQJEjEq+D46YmVaDZSzXE+sN3Yxrhmzfx
 z3iQcGuXKiXZhwm3dsSRr1CJ2Jy86l4XD/kpy6oGdDxUemFLZWWz95ANLPiNK0WmsV5/
 Of5NGWTH6zNOhp29QNRJgTYzaWmWOEg/3iMRQQ79CIeEs5XR1uttAtTkpciYuSbAgxoo Sg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355jpwujn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:20:59 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JI9kv018316;
        Tue, 1 Dec 2020 19:20:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 353e683ett-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:20:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKssv62915042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51424AE055;
        Tue,  1 Dec 2020 19:20:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16664AE04D;
        Tue,  1 Dec 2020 19:20:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 00/14] net/smc: Add support for generic netlink API
Date:   Tue,  1 Dec 2020 20:20:35 +0100
Message-Id: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 mlxlogscore=926 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010112
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

v7: Use nla_nest_start() with the new family. Use .maxattr=1 in the
    genl family and define one entry for attribute 1 in the policy to
    reject this attritbute for all commands. All other possible attributes
    are rejected because NL_VALIDATE_STRICT is set for the policy
    implicitely, which includes NL_VALIDATE_MAXTYPE.
    Setting policy[0].strict_start_type=1 does not work here because there
    is no valid attribute defined for this family, only plain commands. For
    any type > maxtype (which is .maxattr) validate_nla() would return 0 to
    userspace instead of -EINVAL. What helps here is __nla_validate_parse()
    which checks for type > maxtype and returns -EINVAL when NL_VALIDATE_MAXTYPE
    is set. This requires the one entry for type == .maxattr with
    .type = NLA_REJECT in the nla_policy.
    When a future command wants to allow attributes then it can easily specify a
    dedicated .policy for this new command in the genl_ops array. This dedicated
    policy overlays the global policy specified in the genl_family structure.

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
 net/smc/smc_netlink.c    |  85 +++++++++
 net/smc/smc_netlink.h    |  32 ++++
 net/smc/smc_pnet.c       |   2 +
 15 files changed, 1029 insertions(+), 45 deletions(-)
 create mode 100644 net/smc/smc_netlink.c
 create mode 100644 net/smc/smc_netlink.h

-- 
2.17.1

