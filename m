Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175523B76CA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhF2RCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:02:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234420AbhF2RCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:02:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TGoc8m024537;
        Tue, 29 Jun 2021 10:00:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=hQnphqu6iSqjXrQLHJyoT/cKNMkXzybiL8AkYKM3fS0=;
 b=Hmuz930V67jEsELXG+4N1uISpZsn2TmNqTQHIzVtn6QwriquSps1fMcAHpNDQqGLa6NE
 kuHe+VPZYMTrOHFI8Rho1ohPgwH1odVv2tl+/KYk/1dj3gxX+5Ns8Gw6+e0cDcFHC01M
 1Bm3uPHZ+ZjaNgtMKHDSJkMleDIk4qpSL5uACJ86CGmy3N/66wm5uCqKale/csVhQap8
 dHO3atM0SqmvxOKFxc/MKmmtkCwz+VYq3WDqZUymODekaT8+LdMhXpXOp5fr7twpXM9m
 ImAlBeY3PXELpsTRlQqPFGpd0ofwEVj+Bn4XpfkQuL9n9R8jwRPFI6YbsbI/2JKLOpsY pg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39fuw53151-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 10:00:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 10:00:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Jun 2021 10:00:13 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A20055B6967;
        Tue, 29 Jun 2021 10:00:07 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <sgoutham@marvell.com>,
        <hkalra@marvell.com>
Subject: [net-next PATCH 0/3] Dynamic LMTST region setup
Date:   Tue, 29 Jun 2021 22:30:03 +0530
Message-ID: <20210629170006.722-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: n0i5lOYUtagThwdbPUYGhpD-ZYfC1bBw
X-Proofpoint-GUID: n0i5lOYUtagThwdbPUYGhpD-ZYfC1bBw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series allows RVU PF/VF to allocate memory for
LMTST operations instead of using memory reserved by firmware
which is mapped as device memory.
The LMTST mapping table contains the RVU PF/VF LMTST memory base
address entries. This table is used by hardware for LMTST operations.
Patch1 introduces new mailbox message to update the LMTST table with
the new allocated memory address.

Geetha sowjanya (2):
  octeontx2-af: Support configurable LMTST regions
  octeontx2-pf: Use runtime allocated LMTLINE region

Harman Kalra (1):
  octeontx2-af: cn10k: setting up lmtst map table

 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  10 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c | 202 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  10 +
 .../marvell/octeontx2/af/rvu_struct.h         |   3 +-
 .../ethernet/marvell/octeontx2/nic/cn10k.c    |  87 +++-----
 .../ethernet/marvell/octeontx2/nic/cn10k.h    |   3 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   7 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  17 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  12 +-
 12 files changed, 283 insertions(+), 74 deletions(-)

-- 
2.17.1

