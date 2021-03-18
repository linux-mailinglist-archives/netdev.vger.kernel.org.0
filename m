Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D4340797
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhCROQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231429AbhCROQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEEopY027789;
        Thu, 18 Mar 2021 07:15:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=wPUNDCLGskU7nQIK/sddSZ6z442UETQh33ZYC0h8KJA=;
 b=jEhVrO5WeAMHLobe+DAUuQjjcItrxPEd6nJSY8cnsjdTdG+3flE9AW4xJfCvYYTMGjgs
 IIRCU+4QEuKqz8u0LCt8fBwyX5cw4ihH1kLjIL9ofA+ifs5Zq4RSCHwXx2GgmvFAiIXR
 m2bA3eFk1m2rjzElPtH0ugw7Zt2V95gOPs8Qt7UgSrBsrSQVnQ+bM79mw5eQV3/kh2/S
 544tQ9cfBOoM+7F9XsQq7sWZoXtxmSlXasUP7R29614l4KmPjak9unABzPSpHOLsTxlk
 /sQ4pl/N6KEBlnxqWv7kce8yvUygfTcQSLysl94cARWisrpdQcKPngudOMZAfTfe2D55 PA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37c5bf0q3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:15:55 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:15:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:15:53 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 2DB323F703F;
        Thu, 18 Mar 2021 07:15:49 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 0/8] octeontx2: miscellaneous fixes
Date:   Thu, 18 Mar 2021 19:45:41 +0530
Message-ID: <20210318141549.2622-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches fixes various issues related to NPC MCAM entry
management, debugfs, devlink, CGX LMAC mapping, RSS config etc

Change-log:
v2:
Fixed below review comments
	- corrected Fixed tag syntax with 12 digits SHA1
          and providing space between SHA1 and subject line
	- remove code improvement patch
	- make commit description more clear

Geetha sowjanya (2):
  octeontx2-af: Fix irq free in rvu teardown
  octeontx2-pf: Clear RSS enable flag on interace down

Hariprasad Kelam (1):
  octeontx2-af: fix infinite loop in unmapping NPC counter

Rakesh Babu (1):
  octeontx2-af: Formatting debugfs entry rsrc_alloc.

Subbaraya Sundeep (4):
  octeontx2-pf: Do not modify number of rules
  octeontx2-af: Remove TOS field from MKEX TX
  octeontx2-af: Return correct CGX RX fifo size
  octeontx2-af: Fix uninitialized variable warning

 .../marvell/octeontx2/af/npc_profile.h        |  2 -
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 18 +++++-
 .../marvell/octeontx2/af/rvu_debugfs.c        | 55 ++++++++++++-------
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  2 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  2 +-
 .../marvell/octeontx2/nic/otx2_flows.c        |  4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  5 ++
 9 files changed, 65 insertions(+), 30 deletions(-)

--
2.17.1
