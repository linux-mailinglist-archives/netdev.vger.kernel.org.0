Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073C46B5413
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjCJWQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjCJWQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:16:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F090113F68A;
        Fri, 10 Mar 2023 14:16:11 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ALholf012427;
        Fri, 10 Mar 2023 22:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=4sw2HeuGxVCItj5kq+7Wcn54vrLyTMgyTL2eioZ0Xog=;
 b=yzv88G/Ta2eeTmGdA4PnhxEN974Ls0gT20BM6MiQKPA8bzau3+NNEQXEs8RCn6Gn177X
 5tGXibT/5e1RzeEaK0nhAwt+pJrsiTDvfsQYtQLuUgv/3Jw+1DAUzElbLcgQL5Mairq+
 DCXbRaE3e97JukY+Xuii27nUJZVmZIBZ0W6Nhhj3DD8GUjQQsxzR78gAyP3zfKzscnw1
 3y8gfn+ni7LM/TH767KzAlFbhALIkutPMyj/Ek/TkMQBWFpaSLYLAcJVctUEYnGIE48r
 pOdmXw5jl2WEpzE9w90Nmkr754wI0ZvrawNc7Y4FjIgl3URQkC/XoOOmQM1XcfesHr39 Ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p7v3w20tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AM2gul031561;
        Fri, 10 Mar 2023 22:15:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6feqs9rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 22:15:54 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AMFrOt028711;
        Fri, 10 Mar 2023 22:15:53 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6feqs9nh-1;
        Fri, 10 Mar 2023 22:15:53 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v1 0/5] Process connector bug fixes & enhancements
Date:   Fri, 10 Mar 2023 14:15:42 -0800
Message-Id: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_10,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100177
X-Proofpoint-ORIG-GUID: y8YTL7_mXTO9B89ahX7uRctx9_ikEwwh
X-Proofpoint-GUID: y8YTL7_mXTO9B89ahX7uRctx9_ikEwwh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

Patch 1 : Is needed for patches 2 & 3 to work.
Patch 2 : Fixes some bugs in proc connector, details in the patch.
Patch 3 : Test code for proc connector.
Patch 4 : Allow non-root users access to proc connector events.
Patch 5 : Adds event based filtering for performance enhancements.

v->v1 changes:
- Changed commit log in patch 4 as suggested by Christian Brauner
- Changed patch 4 to make more fine grained access to non-root users
- Fixed warning in cn_proc.c, 
  Reported-by: kernel test robot <lkp@intel.com>
- Fixed some existing warnings in cn_proc.c

Anjali Kulkarni (5):
  netlink: Reverse the patch which removed filtering
  connector/cn_proc: Add filtering to fix some bugs
  connector/cn_proc: Test code for proc connector
  connector/cn_proc: Allow non-root users access
  connector/cn_proc: Performance improvements

 drivers/connector/cn_proc.c     | 105 +++++++++--
 drivers/connector/connector.c   |  12 +-
 drivers/w1/w1_netlink.c         |   6 +-
 include/linux/connector.h       |   6 +-
 include/linux/netlink.h         |   5 +
 include/uapi/linux/cn_proc.h    |  62 +++++--
 net/netlink/af_netlink.c        |  48 ++++-
 samples/connector/proc_filter.c | 301 ++++++++++++++++++++++++++++++++
 8 files changed, 499 insertions(+), 46 deletions(-)
 create mode 100644 samples/connector/proc_filter.c

-- 
2.31.1

