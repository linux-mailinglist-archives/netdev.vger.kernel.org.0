Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF3533D0BC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhCPJ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231604AbhCPJ1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QeTm020277;
        Tue, 16 Mar 2021 02:27:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=c4AFbGjTD99ZnkbohjoYrGynKHUDIeKZj20qRjiS+7Y=;
 b=BEkKOkx5sOXnWQHXmizTKios01/xCBFB7cOCDdDkAzjrrK6gy3/UmbkvQ5edL8zPu3Uc
 RQfdbPEZmY+if0XPZfM/E4T5Sq7Qg8OCAqPApEkhsHlUkUL7ITXB5y/ybU+ilecZ3pGe
 LlGY8cAq1cEHp91HWe0HfhFawAEtixCG3BnUaVs9kPlfv5pegcxZFG2TwVa5ybq/xAGk
 LHGiWrbEYNQOMft/I9ddLHQe4iegBVmSFKcyaO1Q3bm16BTTgZAmk15Dh8IHFt5FL6VA
 3ZfP+R3wu3/RNX3NA/zQ9TdhJY1Zts9AV/Mx8GFWV5SCU6K3xLZ0AAK9ZLXOFuyfjnj8 Rg== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:19 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:18 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:18 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id CF8E53F704D;
        Tue, 16 Mar 2021 02:27:14 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 0/9] octeontx2: miscellaneous fixes
Date:   Tue, 16 Mar 2021 14:57:04 +0530
Message-ID: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches fixes various issues related to NPC MCAM entry
management, debugfs, devlink, CGX LMAC mapping, RSS config etc

Geetha sowjanya (2):
  octeontx2-af: Fix irq free in rvu teardown
  octeontx2-pf: Clear RSS enable flag on interace down

Hariprasad Kelam (1):
  octeontx2-af: fix infinite loop in unmapping counter

Rakesh Babu (1):
  octeontx2-af: Formatting debugfs entry rsrc_alloc.

Subbaraya Sundeep (5):
  octeontx2-pf: Do not modify number of rules
  octeontx2-af: Do not allocate memory for devlink private
  octeontx2-af: Remove TOS field from MKEX TX
  octeontx2-af: Return correct CGX RX fifo size
  octeontx2-af: Fix uninitialized variable warning

 .../ethernet/marvell/octeontx2/af/npc_profile.h    |  2 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  6 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 18 ++++++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 55 +++++++++++++---------
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  7 +--
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  5 ++
 10 files changed, 66 insertions(+), 36 deletions(-)

--
2.7.4
