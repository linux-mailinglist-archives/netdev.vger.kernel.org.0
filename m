Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6FA6BA51C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 03:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjCOCT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 22:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCOCT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 22:19:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8C9136CD;
        Tue, 14 Mar 2023 19:19:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F1nDSi002519;
        Wed, 15 Mar 2023 02:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=fFwleNDSd+6f+3kM2KIPVc/1Hj5ceVwjARMgxv5cYt8=;
 b=PWBKW5p45M04hLLdjYtCyPJcuxUeY8g/LOoh7ok5ZgDQjp9+OBqCsaXgUaYPWHly+L+e
 sSqIiitSFbZcov4KV3HwM0XTTaL85mzCHckWGBRD6EERzEcmJJZweqX0jppNgjwgmEjx
 j12mOpE7WE5fRuPP+pqUdM6rWkbT7PjDNLUXfXi0sTrJ44SVwMWTwUBGgl6fqDQc83JE
 Izh+AA0V/U+KYsGYL0re+MriOx9a0ZYNmqrKeSheNXADXdw1b0zzeHUpvYzk7tIdNaMW
 UfyuXoMH4uSqYzuZ0GDV8lD5/Qqnm3hxnW2IO0o8AC005uOHxG8y5mH3HQZcdvy6AJoV 3w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2c1r91d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 02:18:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32F1qpfv001446;
        Wed, 15 Mar 2023 02:18:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2m2n6q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 02:18:53 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32F2Gh2A030879;
        Wed, 15 Mar 2023 02:18:52 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pb2m2n6p2-1;
        Wed, 15 Mar 2023 02:18:52 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH v2 0/5] Process connector bug fixes & enhancements
Date:   Tue, 14 Mar 2023 19:18:45 -0700
Message-Id: <20230315021850.2788946-1-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_16,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150018
X-Proofpoint-GUID: 7tloKwsl3wKeWiIRK23h2ISIERke83f-
X-Proofpoint-ORIG-GUID: 7tloKwsl3wKeWiIRK23h2ISIERke83f-
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
Patch 4 : Adds event based filtering for performance enhancements.
Patch 5 : Allow non-root users access to proc connector events.

v1->v2 changes:
- Fix comments by Jakub Kicinski to keep layering within netlink and
  update kdocs.
- Move non-root users access patch last in series so remaining patches
  can go in first.

Anjali Kulkarni (5):
  netlink: Reverse the patch which removed filtering
  connector/cn_proc: Add filtering to fix some bugs
  connector/cn_proc: Test code for proc connector
  connector/cn_proc: Performance improvements
  connector/cn_proc: Allow non-root users access

 drivers/connector/cn_proc.c     | 103 +++++++++--
 drivers/connector/connector.c   |  22 ++-
 drivers/w1/w1_netlink.c         |   6 +-
 include/linux/connector.h       |   8 +-
 include/linux/netlink.h         |   6 +
 include/uapi/linux/cn_proc.h    |  62 +++++--
 net/netlink/af_netlink.c        |  35 +++-
 net/netlink/af_netlink.h        |   4 +
 samples/connector/proc_filter.c | 301 ++++++++++++++++++++++++++++++++
 9 files changed, 503 insertions(+), 44 deletions(-)
 create mode 100644 samples/connector/proc_filter.c

-- 
2.39.2

