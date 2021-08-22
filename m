Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5253F3F28
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhHVMDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32656 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229961AbhHVMDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MBT0DO006873;
        Sun, 22 Aug 2021 05:02:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=08/i3YXEf9l4k0G2E40h2ijiHZV4hGhgND/Uc+L4eI4=;
 b=JyQTkyIy4ww4P5GKme82zZGZggjZ1wNdiBfs0NSlAiVhliVxSpbRYpCM2pwSZSTcw8zJ
 L/4pb+X8LRXOtPWizM1dSLMBkqRK+3tXWJDOSHKg0dN6V4vV319waqHGI/apVRHuoK4B
 wbw96sbU/+tGfwj0ta3Ebfr9Ey8tda97PJgn79SpsV34sd80ObQXAiFd4Bu/vgYuTxyX
 QIJMgHbpUzwZLn71NZd5sbYmWsKPQsI2UYlBLLYVBar5WeqcM75JISzC+r5oB1JjVhiu
 9e+/cwqrSl+ZAEiTsNaUA+359uGhEpSfADE24kS6PsJEbRBIrmjjmenPTbq4bUZT0RV5 Lw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3akj8dghay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:36 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id C22AA3F7060;
        Sun, 22 Aug 2021 05:02:34 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 00/10] Miscellaneous fixes
Date:   Sun, 22 Aug 2021 17:32:17 +0530
Message-ID: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: YrmBKk-urXDpf8d7mvFnKXPVhYZZXNaK
X-Proofpoint-ORIG-GUID: YrmBKk-urXDpf8d7mvFnKXPVhYZZXNaK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains a bunch of miscellaneous fixes
for various issues like
- Free unallocated memory during driver unload
- HW reading transmit descriptor from wrong address
- VF VLAN strip offload MCAM entry installation failure
- Pkts not being distributed across queues in RSS context
- Wrong interface backpressure configuration for NIX1 block on 98xx
- etc

Geetha sowjanya (4):
  octeontx2-af: Handle return value in block reset.
  octeontx2-af: Use DMA_ATTR_FORCE_CONTIGUOUS attribute in DMA alloc
  octeontx2-af: Check capability flag while freeing ipolicer memory
  octeontx2-af: cn10k: Use FLIT0 register instead of FLIT1

Hariprasad Kelam (1):
  octeontx2-pf: Don't mask out supported link modes

Naveen Mamindlapalli (1):
  octeontx2-pf: send correct vlan priority mask to npc_install_flow_req

Subbaraya Sundeep (2):
  octeontx2-pf: Fix NIX1_RX interface backpressure
  octeontx2-af: cn10k: Fix SDP base channel number

Sunil Goutham (2):
  octeontx2-pf: Don't install VLAN offload rule if netdev is down
  octeontx2-pf: Fix algorithm index in MCAM rules with RSS action

 drivers/net/ethernet/marvell/octeontx2/af/common.h | 13 ++++----
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  5 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 35 +++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  9 ++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 29 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  3 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  5 ----
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  4 +--
 10 files changed, 75 insertions(+), 31 deletions(-)

-- 
2.7.4

