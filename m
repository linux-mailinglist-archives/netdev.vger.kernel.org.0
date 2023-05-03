Return-Path: <netdev+bounces-77-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AA76F50C4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1FF51C20B4F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A31C1FA6;
	Wed,  3 May 2023 07:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB41C39
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:10:21 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27212736;
	Wed,  3 May 2023 00:10:14 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34369xsr003337;
	Wed, 3 May 2023 00:09:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=6Mcsx5t9iR9kcFBpaV+wzj9CUlqadPfT07oLtT9p/0k=;
 b=a6iHMGBVq87mTHctmJEogOUBVU7gDbHsdggE48vyKmjn99es2ofQhEnwFMHRyxfa+BZm
 BLH9QsrULCCwQyIgMZW/ryG3lXemCIeFwICXgHI9zlCX13JjYXLc6ZpDBQGwcABwDIY6
 iaXatoil+aOONwfjD47JyRcuIj1JWHofuEBKAp43SrrcoqM8SZl1hRTtPI1ld2HAqfqc
 O6g18CG/diFxHPdUgXx7SUNhxSumCOCNSooYoi7Ioihc9bVvRJufpin83siKyYGHTBiy
 foBorHIgRiOOFdXq1J8BQpYnYxelSg1gIRTYlgUlabhNmYLpTNaew4lXGyxxyWPZMgrJ fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q92rp3m6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 00:09:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 3 May
 2023 00:09:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 3 May 2023 00:09:51 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
	by maili.marvell.com (Postfix) with ESMTP id 1D3D23F70A6;
	Wed,  3 May 2023 00:09:46 -0700 (PDT)
From: Sai Krishna <saikrishnag@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC: Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v5 00/11] octeontx2: Miscellaneous fixes
Date: Wed, 3 May 2023 12:39:33 +0530
Message-ID: <20230503070944.960190-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QrAfS2EDw5wxNmfugFTLrNCvJlDd8Xho
X-Proofpoint-GUID: QrAfS2EDw5wxNmfugFTLrNCvJlDd8Xho
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_04,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset includes following fixes.

Patch #1 Fix for the race condition while updating APR table 
 
Patch #2 Fix end bit position in NPC scan config 

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

Patch #11 Fix detaching LF resources in case of VF probe fail.

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

Subbaraya Sundeep (2):
  octeontx2-pf: Disable packet I/O for graceful exit
  octeontx2-vf: Detach LF resources on probe cleanup

Suman Ghosh (1):
  octeontx2-af: Update correct mask to filter IPv4 fragments

---
v5 changes:
	Fixed review comments given by Simon Horman
        1. Split the patch.
	2. Modified/Elaborated commit messages.
	3. Fixed duplicate code using goto statements.

v4 changes:
	Fixed review comments given by Simon Horman
        1. Replaced kcalloc() with bitmap_zalloc().
	2. Modified/Elaborated commit messages.
        3. Fixed end bit position in NPC exact match bitmap enable.

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
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  49 +++++--
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |  13 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  26 ++--
 .../marvell/octeontx2/af/rvu_npc_fs.h         |   4 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 125 ++++++++++--------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  10 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   2 +-
 13 files changed, 187 insertions(+), 91 deletions(-)

-- 
2.25.1


