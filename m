Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D435D42DF96
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhJNQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:50:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232496AbhJNQuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:50:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EGUiZ1003161;
        Thu, 14 Oct 2021 12:48:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=m8MvNHUp7uWpH0JtP1UpT7gLDncA2QZjKLaP7beoh94=;
 b=DEVkUo9d5pgYq4T3ZhNoTTTYVnFesNFLnAnMONMqFGYXfw3H/MPe00rs9vCLfWtQT1KE
 JGTRIS+gaxBjUpb+ST0Vgt1Qo7rzXEkjh2ecwr0UCJzPSR2otH98tBZcM4xHwxae6a2u
 rY/QK+Pwcg0Sy1rEIeklENolWLN/LLKUUkURVUbkyBs9v/QG6eweGG38AKp5m0VWNw+c
 eZok5hujGNSfYxQa04CDNK3e3p1tgeyC+qMdkBtAJPoCFcmKxzwqCwRLLVsrgmkQL0yl
 DAp+SIfR+EliOhfcumaT1A2F/ktxms4T8Jum4MylyJzD/Hu/pfqcwKuPpcK41wwJ8Gkm Lw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bpgv4mktg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:48:42 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EGbpxG011898;
        Thu, 14 Oct 2021 16:48:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3bk2qavkaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 16:48:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EGmb1G61604168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 16:48:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCBDBA405C;
        Thu, 14 Oct 2021 16:48:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE97FA405F;
        Thu, 14 Oct 2021 16:48:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 16:48:36 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 00/11] net/smc: introduce SMC-Rv2 support
Date:   Thu, 14 Oct 2021 18:47:41 +0200
Message-Id: <20211014164752.3647027-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5S6gpfzkkJzQV_NPiQiyOSz5qEZePZRo
X-Proofpoint-ORIG-GUID: 5S6gpfzkkJzQV_NPiQiyOSz5qEZePZRo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=800 impostorscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
provides routable RoCE support for SMC-R, eliminating the current
same-subnet restriction, by exploiting the UDP encapsulation feature
of the RoCE adapter hardware.

Patch 1 ("net/smc: improved fix wait on already cleared link") is
already applied on netdevs net tree but its changes are needed for
this series on net-next. The patch is unchanged compared to the
version on the net tree.

v2: resend of the v1 patch series, and CC linux-rdma this time

Karsten Graul (11):
  net/smc: improved fix wait on already cleared link
  net/smc: save stack space and allocate smc_init_info
  net/smc: prepare for SMC-Rv2 connection
  net/smc: add SMC-Rv2 connection establishment
  net/smc: add listen processing for SMC-Rv2
  net/smc: add v2 format of CLC decline message
  net/smc: retrieve v2 gid from IB device
  net/smc: add v2 support to the work request layer
  net/smc: extend LLC layer for SMC-Rv2
  net/smc: add netlink support for SMC-Rv2
  net/smc: stop links when their GID is removed

 include/uapi/linux/smc.h |  17 +-
 net/smc/af_smc.c         | 431 +++++++++++++++++-------
 net/smc/smc.h            |  20 +-
 net/smc/smc_cdc.c        |   7 +-
 net/smc/smc_clc.c        | 147 +++++++--
 net/smc/smc_clc.h        |  55 +++-
 net/smc/smc_core.c       | 193 +++++++----
 net/smc/smc_core.h       |  50 ++-
 net/smc/smc_ib.c         | 160 ++++++++-
 net/smc/smc_ib.h         |  16 +-
 net/smc/smc_llc.c        | 684 ++++++++++++++++++++++++++++++---------
 net/smc/smc_llc.h        |  12 +-
 net/smc/smc_pnet.c       |  41 ++-
 net/smc/smc_tx.c         |  22 +-
 net/smc/smc_wr.c         | 237 ++++++++++++--
 net/smc/smc_wr.h         |  22 ++
 16 files changed, 1691 insertions(+), 423 deletions(-)

-- 
2.25.1

