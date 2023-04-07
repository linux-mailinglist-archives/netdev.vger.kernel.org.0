Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723E06DAC93
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240699AbjDGMYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDGMYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:24:07 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4E186B9;
        Fri,  7 Apr 2023 05:24:06 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337B0M3m002949;
        Fri, 7 Apr 2023 05:23:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=cojIDBESowPznVAXT0YzIOILGif8DCfqVOJ1fMUhloA=;
 b=kTKiMtcCucXhXAJ6bg+4dCJJWBgLJnfbgtvoy+y6meratXO1Lv4+XKEMBJDMWypr/L9w
 lLbrzzvYym2UCEgqW2Hsq/LJnEDPAmzDwzezQDxeF2Se6DOL4TV/E7RXfnxhl1vdZd4n
 bImoPnHx02RxEfYG1CTr5MqajYmqV51CVlvCA+LCOEGQTn6KVJ8lcjcZzwbR7RnzSKta
 lAnNgfp4tdpZ+f4gZKY/DmHntCLf1j/2RsL9raYKd9fsOeXVI+Eq7BO9pHTkpkGESxbb
 cnUPaLFFrlZ9XW3KvLNHF/RprS5RecYdLs6hIMLXywr1/yDGNKMY6Q4HQGB9//yRusGM SA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pthvw88ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Apr 2023 05:23:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 7 Apr
 2023 05:23:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 7 Apr 2023 05:23:52 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id AABB13F7060;
        Fri,  7 Apr 2023 05:23:48 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <richardcochran@gmail.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v2 0/7] octeontx2: Miscellaneous fixes
Date:   Fri, 7 Apr 2023 17:53:37 +0530
Message-ID: <20230407122344.4059-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: aWtCol3TtqEQO5ZBInPcnF2n20KRsY-u
X-Proofpoint-GUID: aWtCol3TtqEQO5ZBInPcnF2n20KRsY-u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_08,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes following fixes.

Patch #1 Fix for the race condition while updating APR table 
 
Patch #2 Fix for bit positions in NPC, MCAM table entries

Patch #3 Fix driver crash resulting from invalid interface type
information retrieved from firmware

Patch #4 Fix incorrect mask used while installing filters inlovling
fragmented packets

Patch #5 Fixes for NPC field hash extract w.r.t IPV6 hash reduction,
         IPV6 filed hash configuration, parser confiuration destination 
         address hash.

Patch #6 Fix for skipping mbox initialization for PFs disabled by firmware.

Patch #7 Fix disabling packet I/O in case of mailbox timeout.

Geetha sowjanya (1):
  octeontx2-af: Secure APR table update with the lock

Hariprasad Kelam (1):
  octeontx2-af: Add validation for lmac type

Ratheesh Kannoth (3):
  octeontx2-af: Fix start and end bit for scan config
  octeontx2-af: Fix issues with NPC field hash extract
  octeontx2-af: Skip PFs if not enabled

Subbaraya Sundeep (1):
  octeontx2-pf: Disable packet I/O for graceful exit

Suman Ghosh (1):
  octeontx2-af: Update correct mask to filter IPv4 fragments

---
v2 changes:
	Fixed review comments given by Leon Romanovsky
	1. Updated lmac_type in case of invalid lmac
	2. Modified commit message

 .../net/ethernet/marvell/octeontx2/af/cgx.c   |   8 ++
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |   5 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  19 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  38 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   8 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  28 ++--
 .../marvell/octeontx2/af/rvu_npc_fs.h         |   4 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 125 ++++++++++--------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  10 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   8 +-
 13 files changed, 182 insertions(+), 88 deletions(-)

-- 
2.25.1

