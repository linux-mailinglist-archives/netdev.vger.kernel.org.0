Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D30318325
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 02:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBKBrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:47:47 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhBKBrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 20:47:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B1kgKj000429;
        Wed, 10 Feb 2021 17:46:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=gs6fyn9yfF9dI/JDXWijLIK39SNU6Aw87aWCNNpRHU0=;
 b=bYJ3su/hlGpEMUhNca6TwrHXFO1qJiPz5+7zKTVzKHz7qBpiDS7euJw3bCU40PZS49XJ
 HU5SYM6s11Hwd7a93HueqQdVBhtGzP0HqI324SmWxPtnfnrWXFW2zBDPR2XqZOMw3MfX
 /4qzI+xyw9n3NUg5qp+e8A004GokDRQYXP4h6lVBp1ISRvgc6Zaxrs+tD0XWBkD45htn
 FtOZn4DRpwxNYDmCpzhIUmLPOaXb9isFOsJh3lv5FUf35J6PA4mu7NJqtWv897+M/F2W
 7e7iS1S2pW9xnv6dZOwQXrIsDvOGTF8u/zZ/SslDlfo3qLRhHHp0WE+p6PlFWhkvYlmp VQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqdhb1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:46:59 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 17:46:58 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 17:46:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 17:46:57 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id D3DEA3F7040;
        Wed, 10 Feb 2021 17:46:53 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v5 00/14] Add Marvell CN10K support
Date:   Thu, 11 Feb 2021 07:16:17 +0530
Message-ID: <20210211014631.9578-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
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
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 315 ++++++---
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
 .../ethernet/marvell/octeontx2/nic/cn10k.c    | 182 ++++++
 .../ethernet/marvell/octeontx2/nic/cn10k.h    |  17 +
 .../marvell/octeontx2/nic/otx2_common.c       | 147 +++--
 .../marvell/octeontx2/nic/otx2_common.h       | 111 +++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  73 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   4 +
 .../marvell/octeontx2/nic/otx2_struct.h       |  10 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |  72 ++-
 .../marvell/octeontx2/nic/otx2_txrx.h         |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  52 +-
 include/linux/soc/marvell/octeontx2/asm.h     |   8 +
 33 files changed, 2612 insertions(+), 739 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h

-- 
2.17.1

