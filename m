Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15F127987E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgIZKo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 06:44:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbgIZKox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 06:44:53 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QAO97I074351;
        Sat, 26 Sep 2020 06:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=iDELbzXbzEsXXcVFgko5fSvNKFL+f7Dld8fkBhIjkH8=;
 b=oNwqPBkVjpH3TFIRLf/iZFHEJ4vXdk/Jk/OBIpLQVTOW8hQ1i019m3hdOehH4qhjVFFb
 tbCeAbwr/J78aDCY3j/tQpWt1qnAwE8P4h69Glpc0J+qbK0WMFAJOXhlThJGOBDUA1Hz
 bGrEFPRqURhZv3SQPwq/U3w+tjdFQeT4kr98E36SRHjLmhn6nkUXxD8tu5XGIslCL3lz
 c2sSyQv/7A6NENjquBnFluiql9LAx/s1SMcJLSHf3JbCxvCmlGx5UorsEahXb1umXpjt
 4uKJ6B+4rAnm6Vt49mvZwcsnLacn9z5cLmCY3WX6Xk0QujjMVVxtNy57o8WyVfWtljLM 7g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33t3uyg9wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 06:44:49 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QAg5xW023007;
        Sat, 26 Sep 2020 10:44:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 33sw9884nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 10:44:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QAiiZn32768286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 10:44:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1434A4054;
        Sat, 26 Sep 2020 10:44:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75D4EA405B;
        Sat, 26 Sep 2020 10:44:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 10:44:44 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/14] net/smc: introduce SMC-Dv2 support
Date:   Sat, 26 Sep 2020 12:44:18 +0200
Message-Id: <20200926104432.74293-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=255 impostorscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009260091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

SMC-Dv2 support (see https://www.ibm.com/support/pages/node/6326337)
provides multi-subnet support for SMC-D, eliminating the current
same-subnet restriction. The new version detects if any of the virtual
ISM devices are on the same system and can therefore be used for an
SMC-Dv2 connection. Furthermore, SMC-Dv2 eliminates the need for
PNET IDs on s390.

Karsten Graul (1):
  net/smc: remove constant and introduce helper to check for a pnet id

Ursula Braun (13):
  net/smc: CLC header fields renaming
  net/smc: separate find device functions
  net/smc: split CLC confirm/accept data to be sent
  net/smc: prepare for more proposed ISM devices
  net/smc: introduce System Enterprise ID (SEID)
  net/smc: introduce CHID callback for ISM devices
  net/smc: introduce list of pnetids for Ethernet devices
  net/smc: determine proposed ISM devices
  net/smc: build and send V2 CLC proposal
  net/smc: determine accepted ISM devices
  net/smc: CLC accept / confirm V2
  net/smc: introduce CLC first contact extension
  net/smc: CLC decline - V2 enhancements

 drivers/s390/net/ism.h     |   7 +
 drivers/s390/net/ism_drv.c |  47 +++
 include/net/smc.h          |   4 +
 net/smc/af_smc.c           | 613 +++++++++++++++++++++++++++++--------
 net/smc/smc.h              |  12 +
 net/smc/smc_clc.c          | 337 +++++++++++++++-----
 net/smc/smc_clc.h          | 179 +++++++++--
 net/smc/smc_core.c         |  25 +-
 net/smc/smc_core.h         |  15 +-
 net/smc/smc_ism.c          |  32 +-
 net/smc/smc_ism.h          |   8 +-
 net/smc/smc_netns.h        |   1 +
 net/smc/smc_pnet.c         | 173 +++++++++--
 net/smc/smc_pnet.h         |  15 +
 14 files changed, 1206 insertions(+), 262 deletions(-)

-- 
2.17.1

