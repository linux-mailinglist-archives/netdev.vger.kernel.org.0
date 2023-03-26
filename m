Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CA66C9756
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 20:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCZSNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 14:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCZSNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 14:13:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3431FE6;
        Sun, 26 Mar 2023 11:13:12 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32QI02ss028508;
        Sun, 26 Mar 2023 11:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=NSkQr3KT6LHG1qgjWkSVI2IIpC5wZQ1O9StkZbsL0dQ=;
 b=hkxAVzuAiBfVCS8qDByvy/lmwNW8mnEsBDzdRnI/luIC/xpG1tnvWx33v6XDZ3AXva02
 yHidZ+P4toRsUvqRm35rATV75gzID8ZRBH2Qq6oihrnvSqLvzXMyeviU84COrv2u1zNi
 2l3acDXC93S6P+eJJ/zhHVz8CDntwelLjLSupIqJnhdNNdGi9U6+5AYF58i2z/SXwXn3
 OMkrRK/Uv5vHgSN2/Orj5rEYgeK0GhahWidwwYb8HHU/67+zkw2dB99TMIoQoka8U+4H
 uLvCuue9ys3eSnlPIQ4M832jVeDw3Xa6OYQ38DD/D29XZ6851oW25QhTQljPMWTL0MZY 3A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3phxas3ucs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 Mar 2023 11:12:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 26 Mar
 2023 11:12:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 26 Mar 2023 11:12:52 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id D70B23F7098;
        Sun, 26 Mar 2023 11:12:46 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvel.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>
Subject: [net-next Patch v5 0/6] octeontx2-pf: HTB offload support
Date:   Sun, 26 Mar 2023 23:42:39 +0530
Message-ID: <20230326181245.29149-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: kjBQ5_wo7Y42-Kk4JS1E8oUdBQnlkABd
X-Proofpoint-ORIG-GUID: kjBQ5_wo7Y42-Kk4JS1E8oUdBQnlkABd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
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

 .../ethernet/marvell/octeontx2.rst            |   39 +
 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   45 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  120 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   40 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  110 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   24 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   13 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1460 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   69 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  304 ++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |    7 +-
 include/net/pkt_cls.h                         |    1 +
 net/sched/sch_htb.c                           |    7 +-
 20 files changed, 2197 insertions(+), 105 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1
