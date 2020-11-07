Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0081F2AA524
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgKGNAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:00:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgKGNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:00:17 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CWrN0016031;
        Sat, 7 Nov 2020 08:00:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=IkwfmOnXdTUefnGmqDZ/gtbeDsXILkzqkhZqPZ5QHUY=;
 b=isQHfJi/XBVvbxv6XjZ+FsdfGEiDSvZ0k0ged9XbM3jmNgW2C/0G7/jCJ4AQXphFsZBI
 wA3ewM9XIN7GD2zLK2zz63MO5vrGv+kwpLWXGeCUDH1Np+qlVgdvfZ+rJXxl5hwKSX9D
 183LXEZ6kNhKRKa2XlfXSPUMTq/M+oMIzNKmJEraR0d0Yjpu1OjLb1sX7iok7cMIJs2Q
 oi+fE4BJMGtFbldk1HAyAP/laUMFDIVYvu9hh3tCdxC/esOluhLVATSq19c8/EXeWkQy
 WfAGl/X1lFwwufHibpxAUcEQ4ZHGMbSuLct95En0MmGhJrzhgUZW9cLyn0hDM5iCylik FQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ns0nbmu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 08:00:13 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A7CvCCU016083;
        Sat, 7 Nov 2020 13:00:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34nk788ag5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Nov 2020 13:00:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A7D05bO5440056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 7 Nov 2020 13:00:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DD8EA405E;
        Sat,  7 Nov 2020 13:00:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76EC1A4040;
        Sat,  7 Nov 2020 13:00:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  7 Nov 2020 13:00:05 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v3 00/15] net/smc: extend diagnostic netlink interface
Date:   Sat,  7 Nov 2020 13:59:43 +0100
Message-Id: <20201107125958.16384-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_07:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 malwarescore=0
 mlxscore=100 phishscore=0 priorityscore=1501 spamscore=100 clxscore=1015
 mlxlogscore=-1000 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

This patch series refactors the current netlink API in smc_diag module
which is used for diagnostic purposes and extends the netlink API in a
backward compatible way so that the extended API can provide information
about SMC linkgroups, links and devices (both for SMC-R and SMC-D) and
can still work with the legacy netlink API.

Please note that patch 9 triggers a checkpatch warning because a comment
line was added using the style of the already existing comment block.

v2: In patch 10, add missing include to uapi header smc_diag.h.

v3: Apply code style recommendations from review comments.
    Instead of using EXPORTs to allow the smc_diag module to access
    data of the smc module, introduce struct smc_diag_ops and let
    smc_diag access the required data using function pointers.

Guvenc Gulce (14):
  net/smc: Use active link of the connection
  net/smc: Add connection counters for links
  net/smc: Add link counters for IB device ports
  net/smc: Add diagnostic information to smc ib-device
  net/smc: Add diagnostic information to link structure
  net/smc: Refactor the netlink reply processing routine
  net/smc: Add ability to work with extended SMC netlink API
  net/smc: Introduce SMCR get linkgroup command
  net/smc: Introduce SMCR get link command
  net/smc: Add SMC-D Linkgroup diagnostic support
  net/smc: Add support for obtaining SMCD device list
  net/smc: Add support for obtaining SMCR device list
  net/smc: Refactor smc ism v2 capability handling
  net/smc: Add support for obtaining system information

Karsten Graul (1):
  net/smc: use helper smc_conn_abort() in listen processing

 include/net/smc.h             |   2 +-
 include/uapi/linux/smc.h      |   8 +
 include/uapi/linux/smc_diag.h | 109 +++++
 net/smc/af_smc.c              |  29 +-
 net/smc/smc.h                 |   4 +-
 net/smc/smc_clc.c             |   5 +
 net/smc/smc_clc.h             |   1 +
 net/smc/smc_core.c            |  62 ++-
 net/smc/smc_core.h            |  55 ++-
 net/smc/smc_diag.c            | 768 ++++++++++++++++++++++++++++++----
 net/smc/smc_ib.c              |  45 ++
 net/smc/smc_ib.h              |   5 +-
 net/smc/smc_ism.c             |   8 +-
 net/smc/smc_ism.h             |   5 +-
 net/smc/smc_pnet.c            |   3 +
 15 files changed, 986 insertions(+), 123 deletions(-)

-- 
2.17.1

