Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1E42ABFAD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbgKIPS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:18:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730083AbgKIPSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:18:24 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9F3EXk056588;
        Mon, 9 Nov 2020 10:18:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=YfXgGDbpt+PYTwJmIRjS9G7dlFdhUObIO9koW3C2Dmc=;
 b=rcIl0sohXXyl9SD2VhFU0AKiwbK9JTTI1o+5x7RE4eU/sWF/eCEnDzq3LXaFQCDJbyFa
 5ge2fREYsyX9lptlaj8DvB7LpVJ+l9Z1rnxxKqtDTUU0Jqkk4WtRa8AaAN1GGpoGHWzi
 UfzOIK0I0D2oCmNuMXC3RPgYOR9L7NAkmn6cj/Pq+zv985pWdimWozSOzh2xypGL3QbZ
 ICCJp6cP6QY/NUhyYlZMZwDQUaXNJ3ekPncSpTpHMmHypmZT6dbFpzvd25geT9UiHNKq
 ifrFjlNSyPqxS8Nc8z4b4T7KaiTOOYXhxIIbrWvmwbSTkxOOH1sGJMOpiaPTkvMkSh5P QQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34q74ejsjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 10:18:22 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FCTk9014578;
        Mon, 9 Nov 2020 15:18:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 34nk77s3tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 15:18:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A9FIGbY4260452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 15:18:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5A4FA4060;
        Mon,  9 Nov 2020 15:18:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BB0AA4054;
        Mon,  9 Nov 2020 15:18:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 15:18:16 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v4 00/15] net/smc: extend diagnostic netlink interface
Date:   Mon,  9 Nov 2020 16:17:59 +0100
Message-Id: <20201109151814.15040-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_07:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 mlxlogscore=567 phishscore=0 spamscore=0
 impostorscore=0 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090102
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

v4: Address checkpatch.pl warnings. Do not use static inline for
    functions.

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
 include/uapi/linux/smc_diag.h | 108 +++++
 net/smc/af_smc.c              |  29 +-
 net/smc/smc.h                 |   4 +-
 net/smc/smc_clc.c             |   5 +
 net/smc/smc_clc.h             |   1 +
 net/smc/smc_core.c            |  72 +++-
 net/smc/smc_core.h            |  26 +-
 net/smc/smc_diag.c            | 788 ++++++++++++++++++++++++++++++----
 net/smc/smc_ib.c              |  45 ++
 net/smc/smc_ib.h              |   5 +-
 net/smc/smc_ism.c             |   8 +-
 net/smc/smc_ism.h             |   5 +-
 net/smc/smc_pnet.c            |   3 +
 15 files changed, 986 insertions(+), 123 deletions(-)

-- 
2.17.1

