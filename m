Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B6A6E9D27
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjDTU2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjDTU1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:27:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E13030FD;
        Thu, 20 Apr 2023 13:27:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KJaRGq016598;
        Thu, 20 Apr 2023 20:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=ViPN6vwzcg76h2PD/fnhDwwebCGyQ98TLoe/yxKe1wY=;
 b=PPkWc0ov81C7mSjfuk3e3UJRfg36xxragNCMG2PJ/NQJYg5/3BRCv1zG+9kw/3qvap+Q
 wEtRv4FgkbrLqdYHqkeiKFx2mKMxsdOddaRyYZXi6YFtB+yOaDroYCqtTwauJueKWWWg
 vy4g+0b8NMoxFYq07za08kqJdHHAJ2U3z3KYvxhvNFEHGhJM0VzmBIx5T1tupWvME41n
 T/qjKP+lLYL/89vyGfxTbVYOzjILGhBOIcyPpIiFelZI8KZvRwCW0m3+eLNptpqTP+J3
 AEYiVWCT5hmG/WJLYnEwPl0HtnOEOa3K0rmOh5AfBOcUg1xs+UrMEyXJYCrmdFZ+ddSD KQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjq4byjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 20:27:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KK2pNx026301;
        Thu, 20 Apr 2023 20:27:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcf2e5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 20:27:12 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33KKRCYW027077;
        Thu, 20 Apr 2023 20:27:12 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pyjcf2e4y-1;
        Thu, 20 Apr 2023 20:27:11 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v5 0/6] Process connector bug fixes & enhancements
Date:   Thu, 20 Apr 2023 13:27:03 -0700
Message-Id: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_15,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=887 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200171
X-Proofpoint-GUID: -bHSq85jN9dl2X7OjXKVDQGlrLmqbeqg
X-Proofpoint-ORIG-GUID: -bHSq85jN9dl2X7OjXKVDQGlrLmqbeqg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oracle DB is trying to solve a performance overhead problem it has been
facing for the past 10 years and using this patch series, we can fix this 
issue.  

Oracle DB runs on a large scale with 100000s of short lived processes,
starting up and exiting quickly. A process monitoring DB daemon which
tracks and cleans up after processes that have died without a proper exit
needs notifications only when a process died with a non-zero exit code
(which should be rare).

Due to the pmon architecture, which is distributed, each process is
independent and has minimal interaction with pmon. Hence fd based
solutions to track a process's spawning and exit cannot be used. Pmon
needs to detect the abnormal death of a process so it can cleanup after.
Currently it resorts to checking /proc every few seconds. Other methods
we tried like using system call to reduce the above overhead were not 
accepted upstream.

With this change, we add event based filtering to proc connector module
so that DB can only listen to the events it is interested in. A new
event type PROC_EVENT_NONZERO_EXIT is added, which is only sent by kernel
to a listening application when any process exiting has a non-zero exit
status.

This change will give Oracle DB substantial performance savings - it takes
50ms to scan about 8K PIDs in /proc, about 500ms for 100K PIDs. DB does
this check every 3 secs, so over an hour we save 10secs for 100K PIDs.
 
With this, a client can register to listen for only exit or fork or a mix or
all of the events. This greatly enhances performance - currently, we
need to listen to all events, and there are 9 different types of events.
For eg. handling 3 types of events - 8K-forks + 8K-exits + 8K-execs takes
200ms, whereas handling 2 types - 8K-forks + 8K-exits takes about 150ms,
and handling just one type - 8K exits takes about 70ms.

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

v4->v5 changes:
- Change the cover letter
- Fix a small issue in proc_filter.c

v3->v4 changes:
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

