Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9672D309D7C
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhAaOPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:15:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231872AbhAaN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:29:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VD7Nxd023047;
        Sun, 31 Jan 2021 05:11:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=M607Xx7ODJ4SslAPfQywdejQPMsoVMNdNbBPDkA7ImQ=;
 b=beBm/yp7UnvSWQ0IEQXaI7Hr/cUKrb5uJfu3WEUd2XHjt9KEWpUznZajtgmKYO6Wa/5E
 Wniifv/rajFw3XN4m8rIgcwSnUw8ikJ5lA2SytjrhBI/NaLetBzrTOjoOfxcvXKLtrIN
 qgUmp8Xfqre3uhAEQF7IzKpPXUFCjf2PIoL/xk4xrB3fCFc1oEs2PvJcwa1hwQGB84ox
 YPrehbyR88/U15j1z5p/YR2WZ4IcfLtzJc6/zadHETiZnM84NQQkLvIw/2Zzyo6p5w03
 dKpb9mMJQMQkXJYwzsPeKjSvAeWOoaPBnyRBMD8/3bkKxgPBo5iY2Rm2dfb9y4/CJ0Kc Eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psss5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 05:11:11 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:09 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 05:11:09 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 35CA83F7041;
        Sun, 31 Jan 2021 05:11:05 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 0/7] ethtool support for fec and link configuration
Date:   Sun, 31 Jan 2021 18:40:58 +0530
Message-ID: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for forward error correction(fec) and
physical link configuration. Patches 1&2 adds necessary mbox handlers for fec
mode configuration request and to fetch stats. Patch 3 registers driver
callbacks for fec mode configuration and display. Patch 4&5 adds support of mbox
handlers for configuring link parameters like speed/duplex and autoneg etc.
Patche 6&7 registers driver callbacks for physical link configuration.

Change-log:
v2:
	- Fixed review comments
	- Corrected indentation issues
        - Return -ENOMEM incase of mbox allocation failure
	- added validation for input fecparams bitmask values
        - added more comments

V3:
	- Removed inline functions
        - Make use of ethtool helpers APIs to display supported
          advertised modes
        - corrected indentation issues
        - code changes such that return early in case of failure
          to aid branch prediction


Christina Jacob (6):
  octeontx2-af: forward error correction configuration
  octeontx2-pf: ethtool fec mode support
  octeontx2-af: Physical link configuration support
  octeontx2-af: advertised link modes support on cgx
  octeontx2-pf: ethtool physical link status
  octeontx2-pf: ethtool physical link configuration

Felix Manlunas (1):
  octeontx2-af: Add new CGX_CMD to get PHY FEC statistics

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 258 ++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  10 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  70 +++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  87 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  80 +++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 399 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 10 files changed, 930 insertions(+), 7 deletions(-)

--
2.7.4
