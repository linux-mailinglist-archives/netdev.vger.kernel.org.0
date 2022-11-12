Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769DB6266E8
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiKLEcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiKLEcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:03 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F075D697;
        Fri, 11 Nov 2022 20:32:02 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC4P1av017181;
        Fri, 11 Nov 2022 20:31:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=onc0iUOJCiEjMHdcph/EcvpHR1oCwbsiyzH3+kekBbg=;
 b=DD9BTXmeK1dfmIiGfL2cPQcdjW0HBmpXVaKWTcU212QZbgOPcNrPJWdbdFSLcyWoV0ms
 rE5jXFNqLwL5dKJnVmzlSNNyNt/VITOjoUvpst07fG+A8/rpOonjYckOJmTkazcE5920
 h92UYnw5Vu6tjQVTozYASSqMjxli8w/SpfpWcTtTthebHJL8t5Vppc1YoGkPmrvGuxqB
 o80+EZpyYt5Cw3Qm2iV7zehkAJauJyV2hQG1MG2TkpL3EFK3SUlYOWwFAvcNQjA98ji7
 ieOW1miqHLMscV5/RFyJfd4EGpr1vCJX8321gcqvpJnuliL6UXyKc26Lc29TifpVrRcz Gw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1jn8by2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:31:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Nov
 2022 20:31:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 11 Nov 2022 20:31:46 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id D55A53F7043;
        Fri, 11 Nov 2022 20:31:42 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 0/9] CN10KB MAC block support
Date:   Sat, 12 Nov 2022 10:01:32 +0530
Message-ID: <20221112043141.13291-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Y2EQ2b1TdexC4RsMVdYVi_E2o2chyRfU
X-Proofpoint-ORIG-GUID: Y2EQ2b1TdexC4RsMVdYVi_E2o2chyRfU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_02,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nextgen silicon CN10KB supports new MAC block RPM2
and has a variable number of LMACS. This series of patches
defines new mac_ops and configures csrs specific to new
MAC.

Defines new mailbox support to Reset LMAC stats, read
FEC stats and set Physical state such that PF netdev
can use mailbox support to use the features.

Extends debugfs support for MAC block to show dropped
packets by DMAC filters and show FEC stats

Hariprasad Kelam (5):
  octeontx2-af: Support More number of MAC blocks
  octeontx2-af: CN10KB MAC RPM_100/USX support
  octeontx2-af: Reset MAC specific csrs on FLR
  octeontx2-af: Show count of dropped packets by DMAC filters
  octeontx2-af: Add support for RPM FEC stats

Naveen Mamindlapalli (1):
  octeontx2-af: Add proper return codes for AF mbox handlers

Revital Regev (1):
  octeontx2-af: Reset MAC block RX/TX statistics

Vamsi Attunuru (1):
  octeontx2-af: physical link state change

Vidhya Vidhyaraman (1):
  octeontx2-af: Add programmed macaddr to RVU pfvf

 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 169 ++++++++--
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  15 +-
 .../marvell/octeontx2/af/lmac_common.h        |  19 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |   8 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 298 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  42 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  14 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 193 +++++++++---
 .../marvell/octeontx2/af/rvu_debugfs.c        |  16 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  10 +-
 .../marvell/octeontx2/af/rvu_npc_hash.c       |   2 +-
 12 files changed, 667 insertions(+), 120 deletions(-)

--
2.17.1
