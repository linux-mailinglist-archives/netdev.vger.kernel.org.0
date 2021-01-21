Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE172FE46C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbhAUHzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:55:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62156 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726553AbhAUHyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:54:46 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10L7ehY4025946;
        Wed, 20 Jan 2021 23:54:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=JsmYZN9PpCyQu1CkWPmGjWNJcnI5+VDCJo9M+O7NtqI=;
 b=Q35HyjdwJrD6FMCqwSw2lX5XZc+neS0KUk2TC7sT/5exays56YF9qgy1Jrqhk/nbPS7z
 bueJCB51O7UqGS1KSyPFrYeOD+RtbhJ51iHvgCmFfyceYWnUuRFdKd8QW/FpUsiIBqwp
 8koJgdccAznX3c6bZR1RuR1XIP3coAETVTgTqA1DxyRx9PvyrTUChuGP9bfyL9FqBwcv
 EScoBKB77BT/VSmN0dWiYXNwgdA0xshkBzfb+zUF2mrQyc7t2AVcmt4URNg2JK8GkKX3
 1UGkq4y9amrGT2c+8kyMKZT9SjNMYN9S0TOslqhfASuovrBxltWS6oS4zCVbodL+uvz1 MQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3668p7ncg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 23:54:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 Jan
 2021 23:53:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 Jan 2021 23:53:58 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id 174E43F7040;
        Wed, 20 Jan 2021 23:53:54 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Hariprasad Kelam <hkelam@marvell.com>
Subject: [net-next PATCH 0/7] ethtool support for fec and link configuration
Date:   Thu, 21 Jan 2021 13:23:22 +0530
Message-ID: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for forward error correction(fec) and
physical link configuration. Patches 1&2 adds necessary mbox handlers
for fec mode configuration request and to fetch stats. Patch 3 registers
driver callbacks for fec mode configuration and display. Patch 4&5 adds
support of mbox handlers for configuring link parameters like speed/duplex
and autoneg etc. Patche 6&7 registers driver callbacks for physical link
configuration.

Christina Jacob (6):
  octeontx2-af: forward error correction configuration
  octeontx2-pf: ethtool fec mode support
  octeontx2-af: Physical link configuration support
  octeontx2-af: advertised link modes support on cgx
  octeontx2-pf: ethtool physical link status
  octeontx2-pf: ethtool physical link configuration

Felix Manlunas (1):
  octeontx2-af: Add new CGX_CMD to get PHY FEC statistics

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 254 +++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  10 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  70 +++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  87 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  84 +++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 390 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 10 files changed, 924 insertions(+), 7 deletions(-)

--
2.7.4
