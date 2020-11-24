Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240632C2F38
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404077AbgKXRvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404038AbgKXRvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:10 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHVIL1183311;
        Tue, 24 Nov 2020 12:51:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=ha31WKqVxW0QdZVPFmiTDhEi7aUohvmkJMZSstcUgmk=;
 b=UFRsnk2JC3q1xzm6Gs2H4Sa1do/HqBXzNa6c9F4rAAMDXvyh6QxD3hSrYimLkxvGJr+x
 H5JQuHTt2H968P2tcWUeMKg4jCQekVNN5mQfSlGu3JHTFV+rde0bvmNioZHc+ZTit7Z/
 mffrKoEfTqWwYxxnV0KnxQsosz62uZ+vsO3B+JWvTzF0ohzNcKTMSrNoQ94S8083PLyu
 of/Xpf1i2qfmHTO8I83U1YweolPCznP7I2XXYch+YCfvRuYkV8KGPXalSRKLkGg6zeSU
 yT2bc0PjtcpP137T4n67pr9UPidwHnW0X0rLwaPOpAT5cKYBquhniuhGBX7HsgTO2nWh EA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3513uwevqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:51:04 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHhU3N002686;
        Tue, 24 Nov 2020 17:51:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 350cvrsbt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:51:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHoxHg52298222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:50:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6405CA4053;
        Tue, 24 Nov 2020 17:50:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DF06A406B;
        Tue, 24 Nov 2020 17:50:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:50:59 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 00/14] net/smc: Add support for generic netlink API
Date:   Tue, 24 Nov 2020 18:50:33 +0100
Message-Id: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 mlxlogscore=762 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

Previous version of this patch series was using the sock_diag netlink
infrastructure. This version is using the generic netlink API. Generic
netlink API offers a better type safety between kernel and userspace
communication.
Using the generic netlink API, smc module can provide now information
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

 include/uapi/linux/smc.h | 126 ++++++++++++
 net/smc/Makefile         |   2 +-
 net/smc/af_smc.c         |  33 ++--
 net/smc/smc_clc.c        |   5 +
 net/smc/smc_clc.h        |   1 +
 net/smc/smc_core.c       | 407 ++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_core.h       |  49 +++++
 net/smc/smc_diag.c       |  23 +--
 net/smc/smc_ib.c         | 204 ++++++++++++++++++++
 net/smc/smc_ib.h         |   6 +
 net/smc/smc_ism.c        | 103 +++++++++-
 net/smc/smc_ism.h        |   6 +-
 net/smc/smc_netlink.c    | 104 ++++++++++
 net/smc/smc_netlink.h    |  32 +++
 net/smc/smc_pnet.c       |   2 +
 15 files changed, 1059 insertions(+), 44 deletions(-)
 create mode 100644 net/smc/smc_netlink.c
 create mode 100644 net/smc/smc_netlink.h

-- 
2.17.1

