Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A9D6E730C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjDSGUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjDSGUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:20:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0410759F8;
        Tue, 18 Apr 2023 23:20:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J49ZMM013371;
        Tue, 18 Apr 2023 23:20:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=83P7c1LA0JRpo8hPHmlWTWp4ja9G957oE5P2pQdZMp4=;
 b=SLFchzSqum+m1LuPzoTyzCJs74ME1mnWcWfMGfvqTL130Rz7BREPO+OseOmsaZqHpLJ0
 /yGJXNVlLc+6kd5o1fuH3nLfS6K3JvJUW4wsN+Ymws+qoUnFU5UEyGqjkWjs+Grex6Fs
 OTXcRJcTZySFyNcfZmZObyep+oXQIraGNRBfrviM2R+HG3+6L0b04uKGZD7T2uXJGNkX
 wbxIQjWsU3KCze55C6fDZT4XX3U+QTO24vABAuM2zFbvR1Kqo4zijZYQPp797IF8Gjmh
 UFyFybmrkaVCZHRGlwsNurWoc3AWCssgp2ITyEsurfnZyikGuUJ943WGj0fUR4PDZGgD Jg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q2917rjr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 23:20:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 18 Apr
 2023 23:20:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 18 Apr 2023 23:20:26 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 0142F3F7055;
        Tue, 18 Apr 2023 23:20:21 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v3 00/10] octeontx2: Miscellaneous fixes
Date:   Wed, 19 Apr 2023 11:50:08 +0530
Message-ID: <20230419062018.286136-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mFaPy7m53JGqrtbC1JmC8GlS7iZQoo9O
X-Proofpoint-ORIG-GUID: mFaPy7m53JGqrtbC1JmC8GlS7iZQoo9O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_02,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes following fixes.

Patch #1 Fix for the race condition while updating APR table 
 
Patch #2 Fix start and end bit positions in NPC scan config 

Patch #3 Fix depth of CAM, MEM table entries

Patch #4 Fix in increase the size of DMAC filter flows

Patch #5 Fix driver crash resulting from invalid interface type
information retrieved from firmware

Patch #6 Fix incorrect mask used while installing filters involving
fragmented packets

Patch #7 Fixes for NPC field hash extract w.r.t IPV6 hash reduction,
         IPV6 filed hash configuration.

Patch #8 Fix for NPC hardware parser configuration destination 
         address hash, IPV6 endianness issues.

Patch #9 Fix for skipping mbox initialization for PFs disabled by firmware.

Patch #10 Fix disabling packet I/O in case of mailbox timeout.

Geetha sowjanya (1):
  octeontx2-af: Secure APR table update with the lock

Hariprasad Kelam (1):
  octeontx2-af: Add validation for lmac type

Ratheesh Kannoth (6):
  octeontx2-af: Fix start and end bit for scan config
  octeontx2-af: Fix depth of cam and mem table.
  octeontx2-pf: Increase the size of dmac filter flows
  octeontx2-af: Update/Fix NPC field hash extract feature
  octeontx2-af: Fix issues with NPC field hash extract
  octeontx2-af: Skip PFs if not enabled

Subbaraya Sundeep (1):
  octeontx2-pf: Disable packet I/O for graceful exit

Suman Ghosh (1):
  octeontx2-af: Update correct mask to filter IPv4 fragments

---
v3 changes:
	Fixed review comments given by Simon Horman
        1. Split the patches
        2. Replaced devm_kcalloc() with kcalloc.
        3. Remove un-necessary validation before free_percpu
	4. Modified/Elaborated commit message
        5. Move the lock to inner function "rvu_get_lmtaddr()" to
           avoid synchronization issues.

v2 changes:
	Fixed review comments given by Leon Romanovsky
	1. Updated lmac_type in case of invalid lmac
	2. Modified commit message

 .../net/ethernet/marvell/octeontx2/af/cgx.c   |   8 ++
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |   5 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  19 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  40 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |  13 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  28 ++--
 .../marvell/octeontx2/af/rvu_npc_fs.h         |   4 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 125 ++++++++++--------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  10 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   2 +-
 13 files changed, 183 insertions(+), 88 deletions(-)

-- 
2.25.1

