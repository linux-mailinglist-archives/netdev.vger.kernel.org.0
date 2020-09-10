Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AEE264B27
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIJRZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:25:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726967AbgIJRYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:05 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AH4nxA156022;
        Thu, 10 Sep 2020 13:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=B/KfGYejqjie/gSWYTbi+6yzvu+9NHReodSGXv+HyYk=;
 b=WOdRIXlpuLcckhmAzdDrgPTCZtYFwqTE0bxKDMAy94hRY83Oi7yW4CnKlvIsvaYFlWqY
 A0XY/7CTfGrQqflkipdiI7iwpYkzMS6+dQ1aI4CJlMqJM3aJzqmTHiMyXSBBnoYEUDIP
 tc8lHS1Mdee65Sl4hZnv2TEPG3bfwjh5glDAthcRxC06CNkY/3M+ZhHJUitU2t234B82
 g3+cXmrVBU4PPJCEQEigqqq7YYqtTJaSe3xbjpYYpgnWQVxBooGP3dnOycuuTxHjdk+O
 b0dGtQJWO6biXV8fva/grPk1zsECFJfk8hLV8O2bNYxRW7ACxWan+a2Ed1i/P+A5rvYz 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fqts1bwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:01 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AH5FZI157481;
        Thu, 10 Sep 2020 13:24:00 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fqts1bvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:00 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHJ7Jm004662;
        Thu, 10 Sep 2020 17:23:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 33e5gmsp67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:23:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHMMCc59245008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:22:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ED1142041;
        Thu, 10 Sep 2020 17:23:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94CB94204C;
        Thu, 10 Sep 2020 17:23:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 17:23:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH net-next 0/8] s390/qeth: updates 2020-09-10
Date:   Thu, 10 Sep 2020 19:23:43 +0200
Message-Id: <20200910172351.5622-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 clxscore=1015 mlxlogscore=860 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

subject to positive review by the bridge maintainers on patch 5,
please apply the following patch series to netdev's net-next tree.

Alexandra adds BR_LEARNING_SYNC support to qeth. In addition to the
main qeth changes (controlling the feature, and raising switchdev
events), this also needs
- Patch 1 and 2 for some s390/cio infrastructure improvements
  (acked by Heiko to go in via net-next), and
- Patch 5 to introduce a new switchdev_notifier_type, so that a driver
  can clear all previously learned entries from the bridge FDB in case
  things go out-of-sync later on.

Thanks,
Julian

Alexandra Winter (8):
  s390/cio: Add new Operation Code OC3 to PNSO
  s390/cio: Helper functions to read CSSID, IID, and CHID
  s390/qeth: Detect PNSO OC3 capability
  s390/qeth: Translate address events into switchdev notifiers
  bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE notifier
  s390/qeth: Reset address notification in case of buffer overflow
  s390/qeth: implement ndo_bridge_getlink for learning_sync
  s390/qeth: implement ndo_bridge_setlink for learning_sync

 arch/s390/include/asm/ccwdev.h    |   9 +-
 arch/s390/include/asm/chsc.h      |   7 +
 arch/s390/include/asm/css_chars.h |   4 +-
 drivers/s390/cio/chsc.c           |  22 +-
 drivers/s390/cio/chsc.h           |   8 +-
 drivers/s390/cio/css.c            |  11 +-
 drivers/s390/cio/css.h            |   4 +-
 drivers/s390/cio/device_ops.c     |  93 ++++++-
 drivers/s390/net/qeth_core.h      |  12 +-
 drivers/s390/net/qeth_core_main.c |  40 ++-
 drivers/s390/net/qeth_l2.h        |   2 +-
 drivers/s390/net/qeth_l2_main.c   | 430 +++++++++++++++++++++++++++++-
 drivers/s390/net/qeth_l2_sys.c    |  16 +-
 include/net/switchdev.h           |   1 +
 net/bridge/br.c                   |   5 +
 15 files changed, 611 insertions(+), 53 deletions(-)

-- 
2.17.1

