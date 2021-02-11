Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEC5318F61
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhBKQCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:02:18 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31898 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229889AbhBKP7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:59:38 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BFuZWm009103;
        Thu, 11 Feb 2021 07:58:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=8XM9Z1z1KIa3JAI/IomL0njTXksPQI7QgTYHG+XjgEM=;
 b=DmD7pV2brjvhz+tJ+dH+YJUJ6H5VeppATS7IR6gq00RiN0Vk079sJAM8vNuoRWzbCdoD
 WAG2Z432HH8+8AoQmcfNsl2GaK4GSvnrb7Ojn52EwfThSYDdu+3SkmXXK+kCt5j9oHna
 E14k0moTm1dmNRyLeICtGERXVxAQe2DDq5KW+8ltskrLPkyAo3onG1jYvBQu04EXHDxp
 qIo1wCfy2oD/Y/cqRhHtTCNIhRH3zAXXX0YR0NX/5CIlcwQyLzQEH2AIhA/tmZ6v2tc9
 KTJNzBW3S2emLgoe79Fuo+AW0a2h5pZGnOh0Gg1Eo3wP2wqb+Q+6lkSn6CAMlqEv8/qA Yg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrqjg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:58:51 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:58:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:58:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 07:58:49 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 337DD3F703F;
        Thu, 11 Feb 2021 07:58:44 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v6 00/14] Add Marvell CN10K support
Date:   Thu, 11 Feb 2021 21:28:20 +0530
Message-ID: <20210211155834.31874-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current admin function (AF) driver and the netdev driver supports
OcteonTx2 silicon variants. The same OcteonTx2's
Resource Virtualization Unit (RVU) is carried forward to the next-gen
silicon ie OcteonTx3, with some changes and feature enhancements.

This patch set adds support for OcteonTx3 (CN10K) silicon and gets
the drivers to the same level as OcteonTx2. No new OcteonTx3 specific
features are added.

Changes cover below HW level differences
- PCIe BAR address changes wrt shared mailbox memory region
- Receive buffer freeing to HW
- Transmit packet's descriptor submission to HW
- Programmable HW interface identifiers (channels)
- Increased MTU support
- A Serdes MAC block (RPM) configuration

v5-v6
Rebased on top of latest net-next branch.

v4-v5
Fixed sparse warnings.

v3-v4
Fixed compiler warnings.

v2-v3
Reposting as a single thread.
Rebased on top latest net-next branch.

v1-v2
Fixed check-patch reported issues.

Geetha sowjanya (5):
  octeontx2-af: cn10k: Update NIX/NPA context structure
  octeontx2-af: cn10k: Update NIX and NPA context in debugfs
  octeontx2-pf: cn10k: Initialise NIX context
  octeontx2-pf: cn10k: Map LMTST region
  octeontx2-pf: cn10k: Use LMTST lines for NPA/NIX operations

Hariprasad Kelam (5):
  octeontx2-af: cn10k: Add RPM MAC support
  octeontx2-af: cn10K: Add MTU configuration
  octeontx2-pf: cn10k: Get max mtu supported from admin function
  octeontx2-af: cn10k: Add RPM Rx/Tx stats support
  octeontx2-af: cn10k: MAC internal loopback support

Rakesh Babu (1):
  octeontx2-af: cn10k: Add RPM LMAC pause frame support

Subbaraya Sundeep (3):
  octeontx2-af: cn10k: Add mbox support for CN10K platform
  octeontx2-pf: cn10k: Add mbox support for CN10K
  octeontx2-af: cn10k: Add support for programmable channels

 MAINTAINERS                                   |   2 +
 .../ethernet/marvell/octeontx2/af/Makefile    |  10 +-
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 313 ++++++---
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  15 +-
 .../ethernet/marvell/octeontx2/af/cgx_fw_if.h |   1 +
 .../ethernet/marvell/octeontx2/af/common.h    |   5 +
 .../marvell/octeontx2/af/lmac_common.h        | 131 ++++
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |  59 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  70 +-
 .../net/ethernet/marvell/octeontx2/af/ptp.c   |  12 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 272 ++++++++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  57 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 159 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  71 ++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 134 +++-
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c | 261 ++++++++
 .../marvell/octeontx2/af/rvu_debugfs.c        | 339 +++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 112 +++-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |   4 +-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  24 +
 .../marvell/octeontx2/af/rvu_struct.h         | 604 ++++++------------
 .../ethernet/marvell/octeontx2/nic/Makefile   |  10 +-
 .../ethernet/marvell/octeontx2/nic/cn10k.c    | 181 ++++++
 .../ethernet/marvell/octeontx2/nic/cn10k.h    |  17 +
 .../marvell/octeontx2/nic/otx2_common.c       | 150 +++--
 .../marvell/octeontx2/nic/otx2_common.h       | 112 +++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  73 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   4 +
 .../marvell/octeontx2/nic/otx2_struct.h       |  10 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |  72 ++-
 .../marvell/octeontx2/nic/otx2_txrx.h         |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  52 +-
 include/linux/soc/marvell/octeontx2/asm.h     |   8 +
 33 files changed, 2613 insertions(+), 739 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h

-- 
2.17.1

