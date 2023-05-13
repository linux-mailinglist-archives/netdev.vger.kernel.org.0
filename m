Return-Path: <netdev+bounces-2347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AC77015F1
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 11:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B5CB1C2090F
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 09:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA59B1846;
	Sat, 13 May 2023 09:56:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BB137B
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 09:56:13 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB046CE;
	Sat, 13 May 2023 02:56:11 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34D9QTZv019979;
	Sat, 13 May 2023 02:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=JTfxwqkfeo+OZ4ivi5IkCaSG/A/YyNvJhN2rrPjPEW8=;
 b=DHhcsjjwWrRiKDXq8mXFLKYhgXPcYIlcXqSSwgrUYzMBlifRpAIlOGq3JjWYmOeqRJLe
 d/WvpcNTmrS5ns72tlyg/e3Bc34qom5e59HecbGMRHo/giZXHFeAL7Evkr6p8D+rP+aL
 Z5OtwMB61I5zpgWG/kSeYEuDxc/rHkhTqOO73OXklKfQX8W1IynN/v+3sduIWiaysmV+
 ujcuqi9c+J7yC+ujyT5aP5HO3Erq6z6xPodP8HiJQOqLC5c4PsyaPqk740BduYpOsFaQ
 FcGJrRmifWhGyri9GV+GUu09MCE/zuLpqOvlAE7kLq1ZD5nsfHCEfd9hA7ic+EHICn7J Ig== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qj7wnr2ju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sat, 13 May 2023 02:56:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 13 May
 2023 02:55:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sat, 13 May 2023 02:55:59 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
	by maili.marvell.com (Postfix) with ESMTP id 653996267B9;
	Sat, 13 May 2023 01:51:44 -0700 (PDT)
From: Hariprasad Kelam <hkelam@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>
Subject: [net-next Patch v10 0/8] octeontx2-pf: HTB offload support
Date: Sat, 13 May 2023 14:21:35 +0530
Message-ID: <20230513085143.3289-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 7WhnyDlunQ-Zvf2FAeoejvQrEHsj_J1K
X-Proofpoint-ORIG-GUID: 7WhnyDlunQ-Zvf2FAeoejvQrEHsj_J1K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-13_06,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

Patch2: Rename existing total tx queues for better readability

Patch3: defines APIs such that the driver can dynamically initialize/
        deinitialize the send queues.

Patch4: Refactors transmit alloc/free calls as preparation for QOS
        offload code.

Patch5: moves rate limiting logic to common header which will be used
        by qos offload code.

Patch6: Adds actual HTB offload support.

Patch7: exposes qos send queue stats over ethtool.

Patch8: Add documentation about htb offload flow in driver

Hariprasad Kelam (5):
  octeontx2-pf: Rename tot_tx_queues to non_qos_queues
  octeontx2-pf: Refactor schedular queue alloc/free calls
  octeontx2-pf: Prepare for QOS offload
  octeontx2-pf: ethtool expose qos stats
  docs: octeontx2: Add Documentation for QOS

Naveen Mamindlapalli (2):
  sch_htb: Allow HTB priority parameter in offload mode
  octeontx2-pf: Add support for HTB offload

Subbaraya Sundeep (1):
  octeontx2-pf: qos send queues management
-----
v1 -> v2 :
          ensure other drivers won't affect by allowing 'prio'
          a parameter in htb offload mode.

v2 -> v3 :
          1. discard patch supporting devlink to configure TL1 round
             robin priority
          2. replace NL_SET_ERR_MSG with NL_SET_ERR_MSG_MOD
          3. use max3 instead of using max couple of times and use a better
             naming convention in send queue management code.

v3 -> v4:
	  1. fix sparse warnings.
	  2. release mutex lock in error conditions.

v4 -> v5:
	  1. fix pahole reported issues
          2. add documentation for htb offload flow.

v5 -> v6:
	  1. fix synchronization issues w.r.t hlist accessing
             from ndo_select_queue with rcu lock.
          2. initialize qos related resources in device init.

v6 -> v7:
	  1. fix erros reported by sparse and clang

v7 -> v8:
	  1. cover letter header is malformed in last version.
             correct the cover letter
v8 -> v9:
	  1. fix issues reported by smatch

v9 -> v10:
         1. split the htb offload patch
         2. define helper APIs for txschq config
         3. update commit description and documentation.


 .../ethernet/marvell/octeontx2.rst            |   45 +
 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   45 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  121 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   82 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   29 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  114 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |   29 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   24 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   14 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1363 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   69 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  296 ++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |    7 +-
 include/net/pkt_cls.h                         |    1 +
 net/sched/sch_htb.c                           |    7 +-
 20 files changed, 2144 insertions(+), 127 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1

