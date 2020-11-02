Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D875E2A341F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgKBTec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:34:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52432 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgKBTec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 14:34:32 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JWOHJ142079;
        Mon, 2 Nov 2020 14:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Vl5/mCfkyjMl/KM+MHocjUjh5T0yil5jGKFZ8jsFLTk=;
 b=Wu/gRz56FKz7JCR5hqV8A/C1YknzeZTGTuyVEaCzElkS1irgmj87owq6IaT/7SgDWVXd
 fHufm1FTETQHXM1Srt8ehVtR5JpKu/aqM8Gv9INvf8z4ER+nGvNoJrNQxoq1kx7iMEk1
 Xa3W94jRJdCJBNTR5LTba+dnR3Mku9tbv8TYpaz2T42CEa3Qph1/Tzeo9g9Ia4pFa3c0
 VIxb+TRRV7g5ApvOuyNgTqJoJ8z/gl4jV6r5CzZbMRw08uc7dtubQ/Xi2NtuXLkvGpe5
 JChJ0yzlQsVUncH7CAcWYNhaSF6vfFjeX72Wv6pRh77SHFs5KbTom/3Jy34RlEkNntmj BA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34j94jhm7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 14:34:27 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A2JXEo0031902;
        Mon, 2 Nov 2020 19:34:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 34jbytrbb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:34:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A2JYN2N47186228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Nov 2020 19:34:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A8894C040;
        Mon,  2 Nov 2020 19:34:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 188AD4C044;
        Mon,  2 Nov 2020 19:34:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Nov 2020 19:34:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next 00/15] net/smc: extend diagnostic netlink interface
Date:   Mon,  2 Nov 2020 20:33:54 +0100
Message-Id: <20201102193409.70901-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_13:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=582
 bulkscore=0 suspectscore=1 lowpriorityscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020149
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
 15 files changed, 938 insertions(+), 124 deletions(-)

-- 
2.17.1

