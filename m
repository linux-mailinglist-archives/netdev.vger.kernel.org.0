Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C69667D7B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbjALSFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbjALSEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:04:22 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91DE63;
        Thu, 12 Jan 2023 09:31:48 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C9dq5X021083;
        Thu, 12 Jan 2023 09:31:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=+ufZ9aus4PpprdGXBnt4QMTNSc9n49WJ5C2QQA94+N8=;
 b=QAVEnJc3H5nS18B0GYYAqn8/K6V5x3I+7vpvfbyF6wGCz3nLkvEFLdkpH9mOZx6yF5Jk
 Rey8ePv0uyIuXjdu0csi6k2Jk2w6VM1BCgBVTjJDinsaWp0kHIwTGOlNN/TuIVk20yHk
 SlH92mSTB6fJSVcFDtUb2c40EnVYqVNbiq3WQb8SgJU7yO3njMxJr3Ze8ji+uD6/J/II
 jH83T49KNH8tjPy/3WMnPTlkKdYOzSYXCY2YGlqwvsltBNWLefG1inAR/EXhZqnYw0Ac
 MxzUVYbELadIxASsRf9A9/b92IKLPoyU3Nlbz/4prK7V5Sy/C1jx6ngY6ZuBDsT1A7Jx xA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k57198h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 09:31:39 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 12 Jan
 2023 09:31:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 12 Jan 2023 09:31:37 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 37A743F7076;
        Thu, 12 Jan 2023 09:31:33 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, "Hariprasad Kelam" <hkelam@marvell.com>
Subject: [net-next PATCH 0/5] octeontx2-pf: HTB offload support
Date:   Thu, 12 Jan 2023 23:01:15 +0530
Message-ID: <20230112173120.23312-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: h1c5XC4vskDvIZfpJY0yX0n9QciATYGJ
X-Proofpoint-GUID: h1c5XC4vskDvIZfpJY0yX0n9QciATYGJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_10,2023-01-12_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

octeontx2 silicon and CN10K transmit interface consists of five
transmit levels starting from MDQ, TL4 to TL1. Once packets are
submitted to MDQ, hardware picks all active MDQs using strict
priority, and MDQs having the same priority level are chosen using
round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
Each level contains an array of queues to support scheduling and
shaping.

As HTB supports classful queuing mechanism by supporting rate and
ceil and allow the user to control the absolute bandwidth to
particular classes of traffic the same can be achieved by
configuring shapers and schedulers on different transmit levels.

This series of patches adds support for HTB offload,

Patch1: Allow strict priority parameter in HTB offload mode.

Patch2: defines APIs such that the driver can dynamically initialize/
        deinitialize the send queues.

Patch3: Refactors transmit alloc/free calls as preparation for QOS
        offload code.

Patch4: Adds devlink support for the user to configure round-robin
        priority at TL1

Patch5:  Adds actual HTB offload support.


Hariprasad Kelam (2):
  octeontx2-pf: Refactor schedular queue alloc/free calls
  octeontx2-pf: Add devlink support to configure TL1 RR_PRIO

Naveen Mamindlapalli (2):
  sch_htb: Allow HTB priority parameter in offload mode
  octeontx2-pf: Add support for HTB offload

Subbaraya Sundeep (1):
  octeontx2-pf: qos send queues management

 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |    9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   15 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    1 +
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   84 +-
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  115 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   30 +-
 .../marvell/octeontx2/nic/otx2_devlink.c      |   84 +
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   93 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   27 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    8 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1547 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   71 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  304 ++++
 include/net/pkt_cls.h                         |    1 +
 net/sched/sch_htb.c                           |    7 +-
 22 files changed, 2372 insertions(+), 87 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1
