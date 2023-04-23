Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C166EBE5A
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjDWJzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjDWJzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:18 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DA1703;
        Sun, 23 Apr 2023 02:55:17 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N2Avve020680;
        Sun, 23 Apr 2023 02:55:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=xJ0QXmlo+0URGn2dy/zxkOUA+avNLemgvdRx0tjoefA=;
 b=D2Lu6fyeEBcujWJV4nWg6FeB/EEZfZp4y81Xd+DBbs7DUCb+hr4TZtxSqghP603ivJf4
 vTeSlc8P/fANI6HJ4NfSf8g7EucqFzH+WAxJTeA+lJU0370hrSGAbMxkefKvvQKVzYuP
 lPoaQYgWmkzWYd3wBOth2H494LGxg61fA/C+1H7Ewtotq+bEYbUgaYcrVfLlhz3ms24d
 Yj7pbHvMPujQLuoSE58KcwLUNskqPJoL1N3+RUHvmluutYw9eKot8r9AJ/FaRwpldw07
 nLp8BCf+WiqGYurf1naLs9DsUmAaONi1ldXnjKzzUPTvf/CvuqkITr+ZahGqcEm+aDgs QQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:54:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:54:58 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 73C6B3F706A;
        Sun, 23 Apr 2023 02:54:55 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 0/9] Macsec fixes for CN10KB
Date:   Sun, 23 Apr 2023 15:24:45 +0530
Message-ID: <20230423095454.21049-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SS54Asifv1uFFWQ2gdMcryV6LXDy_BMq
X-Proofpoint-GUID: SS54Asifv1uFFWQ2gdMcryV6LXDy_BMq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set has fixes for the issues encountered while
testing macsec on CN10KB silicon. Below is the description
of patches:

Patch 1: For each LMAC two MCSX_MCS_TOP_SLAVE_CHANNEL_CFG registers exist
	 in CN10KB. Bypass has to be disabled in two registers.

Patch 2: Add workaround for errata w.r.t accessing TCAM DATA and MASK registers.

Patch 3: Fixes the parser configuration to allow PTP traffic.

Patch 4: Addresses the IP vector and block level interrupt mask changes.
 
Patch 5: Fix NULL pointer crashes when rebooting

Patch 6: Since MCS is global block shared by all LMACS the TCAM match
	 must include macsec DMAC also to distinguish each macsec interface

Patch 7: Before freeing MCS hardware resource to AF clear the stats also.

Patch 8: Stats which share single counter in hardware are tracked in software.
	 This tracking was based on wrong secy mode params.
	 Use correct secy mode params

Patch 9: When updating secy mode params, PN number was also reset to
	 initial values. Hence do not write to PN value register when
	 updating secy.


Geetha sowjanya (3):
  octeonxt2-af: mcs: Fix per port bypass config
  octeontx2-af: mcs: Config parser to skip 8B header
  octeontx2-af: mcs: Fix MCS block interrupt  

Subbaraya Sundeep (6):
  octeontx2-af: mcs: Write TCAM_DATA and TCAM_MASK registers at once
  octeontx2-pf: mcs: Fix NULL pointer dereferences
  octeontx2-pf: mcs: Match macsec ethertype along with DMAC
  octeontx2-pf: mcs: Clear stats before freeing resource
  octeontx2-pf: mcs: Fix shared counters logic
  octeontx2-pf: mcs: Do not reset PN when updating secy

 .../net/ethernet/marvell/octeontx2/af/mcs.c   | 106 +++++++++---------
 .../net/ethernet/marvell/octeontx2/af/mcs.h   |  26 ++---
 .../marvell/octeontx2/af/mcs_cnf10kb.c        |  63 +++++++++++
 .../ethernet/marvell/octeontx2/af/mcs_reg.h   |   6 +-
 .../marvell/octeontx2/af/mcs_rvu_if.c         |  37 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   2 +
 .../marvell/octeontx2/af/rvu_debugfs.c        |   4 +-
 .../marvell/octeontx2/nic/cn10k_macsec.c      |  54 ++++++---
 .../marvell/octeontx2/nic/otx2_common.h       |   2 +-
 10 files changed, 217 insertions(+), 84 deletions(-)

-- 
2.25.1

