Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034672A41BE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgKCKZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:25:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727911AbgKCKZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:51 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A2eHJ181752;
        Tue, 3 Nov 2020 05:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=zNdvT7PiLC6jTGFpSyj6GGgSUlr5glEXuy7IJRQncgk=;
 b=K8Ha7K0LafJWP7AjTgtNSmaXHVm2RPVJv+60+7wotF2gM7+L2wNHP+Omdqk521SIlbex
 bH/ODCN9aJV9MhNUxWXy10297/O4s+7QGJYgsOkXCkgRIAFBsMvaeX61zWEnEnoySOAv
 L0QZuzBRK2M5DI1lH6snGg7XvwOTPrztOvWvzBbWladyWVEf1pQgrq8MIgSwHd39Zeeh
 epFvqkf/6ymtu1zI4yy6wdBPMnJeUV9P/FjDWeDxK3w/zEmPFR0VdTtTE8Du7dcVj8TI
 jszI9a1TKomUpKWOZ5A5gFpPvq4mvI8MfriDHBNLO4CJqYl1S0NAb6fASDo6cp7UDGR3 dQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ju7c7h11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:48 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3ALaD1032646;
        Tue, 3 Nov 2020 10:25:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 34h01khkg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APhS27864840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C2EFA405B;
        Tue,  3 Nov 2020 10:25:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64248A4054;
        Tue,  3 Nov 2020 10:25:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:43 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 00/15] net/smc: extend diagnostic netlink interface
Date:   Tue,  3 Nov 2020 11:25:16 +0100
Message-Id: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=547 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030065
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

v2: in patch 10, add missing include to uapi header smc_diag.h

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
 net/smc/smc.h                 |   5 +-
 net/smc/smc_clc.c             |   6 +
 net/smc/smc_clc.h             |   1 +
 net/smc/smc_core.c            |  32 +-
 net/smc/smc_core.h            |  32 +-
 net/smc/smc_diag.c            | 766 +++++++++++++++++++++++++++++-----
 net/smc/smc_ib.c              |  49 +++
 net/smc/smc_ib.h              |   4 +-
 net/smc/smc_ism.c             |  12 +-
 net/smc/smc_ism.h             |   5 +-
 net/smc/smc_pnet.c            |   3 +
 15 files changed, 939 insertions(+), 124 deletions(-)

-- 
2.17.1

