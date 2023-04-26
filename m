Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01CA6EEF88
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbjDZHoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbjDZHoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:44:02 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77A140DA;
        Wed, 26 Apr 2023 00:44:01 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q75YDl012965;
        Wed, 26 Apr 2023 00:43:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=lgcwLKgBO7h/Ua8se3me3hRYrL9EOm7LZW5GePlBYDs=;
 b=i2CYnjrb9NFcSxOHm04/LezZsch6xZWgOPPifNTWRClztZ0KTBOKm51aBgHirYUdWipE
 9yoDvJ860gg8SszxQVds+YznST9h1L3aYps6q5k2kaqtcB7qx54Cw8u1bz3hJriEPF75
 IvrAdOj+LNYJFAu1/2iW6+ujzvO9BkYgn15bOJHtkinjzpVY1rDoE7ZU45E29FL72vHI
 e5xBIu0gDAY7XKSNjpbnkluvb8LT6IOt8bZfePqVWB3+xLjIrXaEs0xflOH276hcGFfa
 wYFzrVvdhJsAmU3FFzVFKOfQWJFeCq5P415hEQc6VQFMaVy0KtpOa0A4oyNEs8L3Zvx5 fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2fdd2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 00:43:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 26 Apr
 2023 00:43:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 26 Apr 2023 00:43:52 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 455DB3F7069;
        Wed, 26 Apr 2023 00:43:48 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v4 00/10] octeontx2: Miscellaneous fixes
Date:   Wed, 26 Apr 2023 13:13:35 +0530
Message-ID: <20230426074345.750135-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: fbvkzEEegbkC9XBm1iYy7F_kQ0uShf-E
X-Proofpoint-ORIG-GUID: fbvkzEEegbkC9XBm1iYy7F_kQ0uShf-E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
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
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  44 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |  13 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  26 ++--
 .../marvell/octeontx2/af/rvu_npc_fs.h         |   4 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 125 ++++++++++--------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  10 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   2 +-
 13 files changed, 185 insertions(+), 88 deletions(-)

-- 
2.25.1

