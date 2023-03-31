Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E49B6D2BE2
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 01:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjCaXz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 19:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjCaXzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 19:55:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E621C1F0;
        Fri, 31 Mar 2023 16:55:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VKsDYj018042;
        Fri, 31 Mar 2023 23:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=GgX7VEeBj7SLEWDmUbJhn1hsn//HWaA7pJ0MQlhURws=;
 b=I4G8+JOxN6N+LTigPcXuBasgpbqD+Sh0yqXxF/Pt/fAqkdVV0eDaDcaODiLvuym/U5WK
 bK9EkAzYsH/EHRs2dVft3GmgpYdmNLlzc2+unGyFQn4Idz2KLRthj2iBU48kpRVLd7iO
 59e/zW29XF1Bbhv8WSvjLkwsKBhx4wjLjdJF+kBwJye03sAxFE4G2DgaimhRv9zpqeZL
 c0la0wBT41b1WgCX5vYHaVeDUt1p7i8H3e7ZA9rvhEuKPSBV8nmL5h91YfSNximH3ZHr
 hgHbqzf26LaaLduiI0BzYujUGB2eRdGuJ9m1efgvv57ZuL/pgDBbIxPPcAT/TA78a760 hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpmpf8bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 23:55:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32VLp81b023516;
        Fri, 31 Mar 2023 23:55:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdkm2pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 23:55:31 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VNtUIZ019347;
        Fri, 31 Mar 2023 23:55:31 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3phqdkm2p9-1;
        Fri, 31 Mar 2023 23:55:30 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v4 0/6] Process connector bug fixes & enhancements
Date:   Fri, 31 Mar 2023 16:55:22 -0700
Message-Id: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303310196
X-Proofpoint-GUID: TWNJ3LkP2jE3xwyuoSLbuzXosJnMncl-
X-Proofpoint-ORIG-GUID: TWNJ3LkP2jE3xwyuoSLbuzXosJnMncl-
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>

In this series, we add filtering to the proc connector module. This
is required to fix some bugs and also will enable the addition of event
based filtering, which will improve performance for anyone interested
in a subset of process events, as compared to the current approach,
which is to send all event notifications.

Thus, a client can register to listen for only exit or fork or a mix or
all of the events. This greatly enhances performance - currently, we
need to listen to all events, and there are 9 different types of events.
For eg. handling 3 types of events - 8K-forks + 8K-exits + 8K-execs takes
200ms, whereas handling 2 types - 8K-forks + 8K-exits takes about 150ms,
and handling just one type - 8K exits takes about 70ms.

Reason why we need the above changes and also a new event type
PROC_EVENT_NONZERO_EXIT, which is only sent by kernel to a listening
application when any process exiting has a non-zero exit status is:

Oracle DB runs on a large scale with 100000s of short lived processes,
starting up and exiting quickly. A process monitoring DB daemon which
tracks and cleans up after processes that have died without a proper exit
needs notifications only when a process died with a non-zero exit code
(which should be rare).

This change will give Oracle DB substantial performance savings - it takes
50ms to scan about 8K PIDs in /proc, about 500ms for 100K PIDs. DB does
this check every 3 secs, so over an hour we save 10secs for 100K PIDs.

Measuring the time using pidfds for monitoring 8K process exits took 4
times longer - 200ms, as compared to 70ms using only exit notifications
of proc connector. Hence, we cannot use pidfd for our use case.

This kind of a new event could also be useful to other applications like
Google's lmkd daemon, which needs a killed process's exit notification.

This patch series is organized as follows -

Patch 1 : Needed for patch 3 to work.
Patch 2 : Needed for patch 3 to work.
Patch 3 : Fixes some bugs in proc connector, details in the patch.
Patch 4 : Test code for proc connector.
Patch 5 : Adds event based filtering for performance enhancements.
Patch 6 : Allow non-root users access to proc connector events.

v3->v4 changes;
- Fix comments by Jakub Kicinski to incorporate root access changes
  within bind call of connector

v2->v3 changes:
- Fix comments by Jakub Kicinski to separate netlink (patch 2) (after
  layering) from connector fixes (patch 3). 
- Minor fixes suggested by Jakub.
- Add new multicast group level permissions check at netlink layer.
  Split this into netlink & connector layers (patches 6 & 7)

v1->v2 changes:
- Fix comments by Jakub Kicinski to keep layering within netlink and
  update kdocs.
- Move non-root users access patch last in series so remaining patches
  can go in first.

v->v1 changes:
- Changed commit log in patch 4 as suggested by Christian Brauner
- Changed patch 4 to make more fine grained access to non-root users
- Fixed warning in cn_proc.c, 
  Reported-by: kernel test robot <lkp@intel.com>
- Fixed some existing warnings in cn_proc.c

Anjali Kulkarni (6):
  netlink: Reverse the patch which removed filtering
  netlink: Add new netlink_release function
  connector/cn_proc: Add filtering to fix some bugs
  connector/cn_proc: Test code for proc connector
  connector/cn_proc: Performance improvements
  connector/cn_proc: Allow non-root users access

 drivers/connector/cn_proc.c     | 105 +++++++++--
 drivers/connector/connector.c   |  35 +++-
 drivers/w1/w1_netlink.c         |   6 +-
 include/linux/connector.h       |   8 +-
 include/linux/netlink.h         |   6 +
 include/uapi/linux/cn_proc.h    |  62 +++++--
 net/netlink/af_netlink.c        |  31 +++-
 net/netlink/af_netlink.h        |   4 +
 samples/connector/proc_filter.c | 301 ++++++++++++++++++++++++++++++++
 9 files changed, 515 insertions(+), 43 deletions(-)
 create mode 100644 samples/connector/proc_filter.c

-- 
2.40.0

