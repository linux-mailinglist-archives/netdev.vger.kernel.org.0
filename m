Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D5D6B19E6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCIDUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 22:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCIDUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:20:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C3012F2E;
        Wed,  8 Mar 2023 19:20:21 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328N4VoF015865;
        Thu, 9 Mar 2023 03:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=QRt4YAdTiZeDMCcYTiGjJS1xzx8pV60zEPhaTxIBt6c=;
 b=mjAb/XTdWR4/7iD5ekytaykwzLaOjPLHWnnnerWEjHBLsEsLRX947Qe7Yzu/aRGbpUky
 Fk2e5EjQPhUB1LonsRN88ZA3DiVAqwGNJOPZkT7knSiMJgZJw8l62ekkYBgN7yjPxF9D
 4GfBKh49VlrRvhDfXGoUPGHTBfW7SnfauoDjVxLvxb8OeSR3FRdHj/lTygx7uefFjR3C
 qHbSnqwZI064FoYbC1wCvK6p2SfiKikQnMz0ySa1Y+I1fH6LqWOlvDvBLbSTJA4LpEEY
 PDkzzsHWRFbMg1HpZ63UN6vFfHkq8MiEj47DH+ue4onQ0Rux8ZxqfYo+JTYhGl+8+bG7 Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn960w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 03:19:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32931tmG022310;
        Thu, 9 Mar 2023 03:19:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9p4r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 03:19:58 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3293Iwm6022200;
        Thu, 9 Mar 2023 03:19:57 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3p6fr9p4pq-1;
        Thu, 09 Mar 2023 03:19:57 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        anjali.k.kulkarni@oracle.com
Subject: [PATCH 0/5] Process connector bug fixes & enhancements
Date:   Wed,  8 Mar 2023 19:19:48 -0800
Message-Id: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090025
X-Proofpoint-GUID: ES1mUgtgU-1aCl4NnT8WX8M9jLOuPO2P
X-Proofpoint-ORIG-GUID: ES1mUgtgU-1aCl4NnT8WX8M9jLOuPO2P
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

In this series, we add back filtering to the proc connector module. This
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

Patch 1    : Is needed for patches 2 & 3 to work.
Patches 2-3: Fixes some bugs in proc connector, details in the patches.
Patch 4    : Allow non-root users access to proc connector events.
Patch 5    : Adds event based filtering for performance enhancements.

Anjali Kulkarni (5):
  netlink: Reverse the patch which removed filtering
  connector/cn_proc: Add filtering to fix some bugs
  connector/cn_proc: Test code for proc connector
  connector/cn_proc: Allow non-root users access
  connector/cn_proc: Performance improvements

 drivers/connector/cn_proc.c     | 103 +++++++++--
 drivers/connector/connector.c   |  13 +-
 drivers/w1/w1_netlink.c         |   6 +-
 include/linux/connector.h       |   6 +-
 include/linux/netlink.h         |   5 +
 include/uapi/linux/cn_proc.h    |  62 +++++--
 net/netlink/af_netlink.c        |  35 +++-
 samples/connector/proc_filter.c | 299 ++++++++++++++++++++++++++++++++
 8 files changed, 485 insertions(+), 44 deletions(-)
 create mode 100644 samples/connector/proc_filter.c

-- 
2.39.2

