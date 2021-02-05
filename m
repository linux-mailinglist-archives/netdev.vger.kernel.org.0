Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C793118EA
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhBFCtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:49:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7742 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231555AbhBFCkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:40:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MfQHK030586;
        Fri, 5 Feb 2021 14:50:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=vfOQ1VnegVmaby9MAg21ZlokPM8roM+7ZnH/VFAl+JE=;
 b=hEeCRATzIlksQR8Bd/+K7ywNqcjhRs4uLKXx9K3BCAQXxmfYRtHsalWS/stIjrOUBNay
 WLIb+sKvxZAFFnZhOD7iaNAy8yNqybekHN2W22RqPgr2QX2xP6fEhounSiXtHwDglSYs
 lTHaSwWxLQ6AhNzjDLeC4DTN6/AcxFBG/oqWduZSo6qSVh0J6A355drlb+/uZKUGRXex
 fCDoGd80WAMl0r1VxBkmeEvZTj4R1j/d6IDuWfbTo83LEgXqw6BNTCRvzFxiMH+xPQHq
 6gGn2mOR7atiylbxQXakovOOn2u3ysSyYI9TWGemHeYmffcr7tK7afKnhIRehwXmLxYZ IA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr6ag0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:50:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:50:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:50:47 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 638343F703F;
        Fri,  5 Feb 2021 14:50:43 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v4 00/14] Add Marvell CN10K support
Date:   Sat, 6 Feb 2021 04:19:59 +0530
Message-ID: <20210205225013.15961-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
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

v3-v4
Fixed compiler warnings.

v2-v3
Reposting as a single thread.
Rebased on top latest net-next branch.

v1-v2
Fixed check-patch reported issues.

Geetha sowjanya (6):
  octeontx2-af: cn10k: Add mbox support for CN10K platform
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

Subbaraya Sundeep (2):
  octeontx2-pf: cn10k: Add mbox support for CN10K
  octeontx2-af: cn10k: Add support for programmable channels

 MAINTAINERS                                        |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 315 ++++++++---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  15 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    | 131 +++++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  59 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  70 ++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |  12 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 272 ++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  57 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 159 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  71 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 134 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 261 +++++++++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 339 +++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 112 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  24 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h | 604 ++++++---------------
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |  10 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 182 +++++++
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  17 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 145 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 111 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  73 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  10 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  70 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  52 +-
 include/linux/soc/marvell/octeontx2/asm.h          |   8 +
 33 files changed, 2609 insertions(+), 738 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h

-- 
2.7.4

