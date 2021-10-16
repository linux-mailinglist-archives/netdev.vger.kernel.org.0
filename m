Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC73C430189
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243961AbhJPJki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:40:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240032AbhJPJkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:40:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19G6VWmh018537;
        Sat, 16 Oct 2021 05:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=nlm6TeUpa3wo4o7+D4VnfaNWFqyTjzNRzH2v01K8rqw=;
 b=JbF5+BUsk6GFSwJXkQCh9aUA6e0rC1/HPcxxmhlLMFY0U9WMKCSyIfYW5QCgYxn+I6Ym
 1tBlpxeIyz+FmOuQEl8yTDjFengojPIKe/lz7UTjr+mU3jMdLza6OfOSA7lGggaFuVi1
 Bkp6dMrRp3Mnl7dVkzuH/Mtv/TeFxGlwv2dosNBvqgsNujdOQzz/8PSy5tPyRmd2PFxy
 jQPke+bVUVRlpeb9nOcsNE/cKA4qU8HgOqZ8GU/wQ5lsosVHO8s8yD9AX6uv5zu6HUel
 6YLvLZHEP8SYJfDPn1TuSd3aflNxfMoJj4wYxM65lIzTXd7lvZZgA4pmDyBTO/DtUbzl mg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bqshxajbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 05:38:28 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19G9bvPU004515;
        Sat, 16 Oct 2021 09:38:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3bqpc99622-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 09:38:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19G9cN7G63963480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Oct 2021 09:38:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B6104C040;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8DB44C04E;
        Sat, 16 Oct 2021 09:38:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Oct 2021 09:38:22 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 00/10] net/smc: introduce SMC-Rv2 support
Date:   Sat, 16 Oct 2021 11:37:42 +0200
Message-Id: <20211016093752.3564615-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TpbjcRAoVVKlUSmrXrrS8JY5LjY7ykR5
X-Proofpoint-GUID: TpbjcRAoVVKlUSmrXrrS8JY5LjY7ykR5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-16_02,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=625
 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110160058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net-next tree.

SMC-Rv2 support (see https://www.ibm.com/support/pages/node/6326337)
provides routable RoCE support for SMC-R, eliminating the current
same-subnet restriction, by exploiting the UDP encapsulation feature
of the RoCE adapter hardware.

v2: resend of the v1 patch series, and CC linux-rdma this time
v3: rebase after net tree was merged into net-next

Karsten Graul (10):
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
 net/smc/af_smc.c         | 431 +++++++++++++++++++--------
 net/smc/smc.h            |  20 +-
 net/smc/smc_clc.c        | 147 +++++++--
 net/smc/smc_clc.h        |  55 +++-
 net/smc/smc_core.c       | 173 ++++++++---
 net/smc/smc_core.h       |  50 +++-
 net/smc/smc_ib.c         | 160 +++++++++-
 net/smc/smc_ib.h         |  16 +-
 net/smc/smc_llc.c        | 623 +++++++++++++++++++++++++++++++--------
 net/smc/smc_llc.h        |  12 +-
 net/smc/smc_pnet.c       |  41 ++-
 net/smc/smc_wr.c         | 237 +++++++++++++--
 net/smc/smc_wr.h         |   8 +
 14 files changed, 1607 insertions(+), 383 deletions(-)

-- 
2.25.1

