Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F77E640BD
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfGJFdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:33:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfGJFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:33:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5SXfQ016538;
        Wed, 10 Jul 2019 05:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=Mo/Hz5Imd3TIbbIuQQiuHWDSGpaRexvnT5gDf762yCw=;
 b=mQ0o70gZXO+TdEtxhrLHKavjm7Rzl1rqoGsYfTMiaBtkWxbbc5LqrRNJHvsS0DwZ6XoX
 1QYPrDhmvBOIu6FsifFQeaPT5syPj9/ZnbgRwC2Kkj5pgXmsoRZczTutEDNvL8klgdhk
 AkDqnCi4hwd9ijXuVlxcR+YuLzU3v1x8hnsPaiU/RB0ckzZ5stuHa7HKElhl6XknRUge
 uPDYgkKEblhwrHblztqUYxpO3U6MPALybdeBjzpoBrpBBzpNa+LzM28BqZieNHD5fH8Q
 1kj3FUBYbxp1lNyI/a/q0axD84CSx9WPtAHldY0d0GgG0Fn0/HaaHqTtDjsyF8V6aCXe cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tjk2tqxf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5WvCk003812;
        Wed, 10 Jul 2019 05:33:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tmmh3bctk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6A5X7AG016455;
        Wed, 10 Jul 2019 05:33:07 GMT
Received: from localhost.localdomain (/10.159.154.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 22:33:07 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net][PATCH 0/5] rds fixes
Date:   Tue,  9 Jul 2019 22:32:39 -0700
Message-Id: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=998
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few rds fixes which makes rds rdma transport reliably working on mainline

First two fixes are applicable to v4.11+ stable versions and last
three patches applies to only v5.1 stable and current mainline.

Patchset is re-based against 'net' and also available on below tree

The following changes since commit 1ff2f0fa450ea4e4f87793d9ed513098ec6e12be:

  net/mlx5e: Return in default case statement in tx_post_resync_params (2019-07-09 21:40:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux.git net/rds-fixes

for you to fetch changes up to dc205a8d34228809dedab94a85a866cbb255248f:

  rds: avoid version downgrade to legitimate newer peer connections (2019-07-09 21:45:43 -0700)

----------------------------------------------------------------
Gerd Rausch (3):
      Revert "RDS: IB: split the mr registration and invalidation path"
      rds: Accept peer connection reject messages due to incompatible version
      rds: Return proper "tos" value to user-space

Santosh Shilimkar (2):
      rds: fix reordering with composite message notification
      rds: avoid version downgrade to legitimate newer peer connections

 net/rds/connection.c     |  1 +
 net/rds/ib.h             |  4 +---
 net/rds/ib_cm.c          |  9 ++-------
 net/rds/ib_frmr.c        | 11 +++++------
 net/rds/ib_send.c        | 29 +++++++++++++----------------
 net/rds/rdma.c           | 10 ----------
 net/rds/rdma_transport.c | 11 +++++++----
 net/rds/rds.h            |  1 -
 net/rds/send.c           |  4 +---
 9 files changed, 30 insertions(+), 50 deletions(-)

-- 
1.9.1

