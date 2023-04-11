Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1E26DD628
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDKJEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjDKJE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:04:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF8C272A;
        Tue, 11 Apr 2023 02:04:25 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33B8gJhx016441;
        Tue, 11 Apr 2023 02:04:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=6o2rBgykC8Yu4jkvUQ2I3kS56PNQdDNDrBL1udv6o1M=;
 b=BByZMSHLPrU2koY2qnSHCp3e4wmisNOfJ738H1caJyVas1O86lAPQlT9MccrClzw9uiV
 Qz1IdG0XYKIzKIiCc2mc6KYqBnyI8y8YJiD8jcFApKXl/HeWUvuImgiHwKXPGIEfIDkw
 q4XEXEVsnUHp8V0bhOvIg9ey8pm7+/poArWgvjTDaIkLMw7qlLikZZsVuaI4ikWezF6W
 Ve3BkZypaJQ+J/c8ml47ZWtwGqqcI7JpfGMXoRZJ9bjmAiW5OZkb/Pfj9H4pzt/w301Z
 KOexMtEM7VujR9ngegSYaYOvDnrJkYh3oFZQkQFMZx/YvWG5VUY0ZCO/32AOBIhLSUe9 Hw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3purfs939m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 02:04:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 11 Apr
 2023 02:04:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 11 Apr 2023 02:04:06 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 9FDA43F706A;
        Tue, 11 Apr 2023 02:04:00 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v9 0/6] octeontx2-pf: HTB offload support
Date:   Tue, 11 Apr 2023 14:33:53 +0530
Message-ID: <20230411090359.5134-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -7j2OvWsK_sXSHEguxbGGveHQSuAGIMB
X-Proofpoint-GUID: -7j2OvWsK_sXSHEguxbGGveHQSuAGIMB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_05,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Patch2: Rename existing total tx queues for better readability

Patch3: defines APIs such that the driver can dynamically initialize/
        deinitialize the send queues.

Patch4: Refactors transmit alloc/free calls as preparation for QOS
        offload code.

Patch5: Adds actual HTB offload support.

Patch6: Add documentation about htb offload flow in driver

Hariprasad Kelam (3):
  octeontx2-pf: Rename tot_tx_queues to non_qos_queues
  octeontx2-pf: Refactor schedular queue alloc/free calls
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

 .../ethernet/marvell/octeontx2.rst            |   39 +
 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   45 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  120 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   56 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  114 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   24 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   14 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1476 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   69 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  296 ++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |    7 +-
 include/net/pkt_cls.h                         |    1 +
 net/sched/sch_htb.c                           |    7 +-
 20 files changed, 2224 insertions(+), 107 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1
