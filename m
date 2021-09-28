Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1331B41ADD3
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbhI1Lcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:32:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62908 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240364AbhI1Lcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:32:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAF7qO019504;
        Tue, 28 Sep 2021 04:31:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=HIPtblOvT19HP94QWSC2gOYyVo6O86ek2i0HsUcyLEM=;
 b=DjzzsZHw0ykMlbN3VYD52B7bo49iJn1t5S5VXUrOaU9m8i1hNMHp56pdLkZj9pdYLtI2
 Bb68yIUnsGkpHFHRMxwYAOmG7nkjIOfUG1zyRFgQDnuZuCRII0wiTehj34vWt1jCDae0
 /MsPnvV+rdopoTXkEXcrt4eug4JkeAtq2rz7aJ6qMVpn9OKUdeRTRODgimQaCQHJauyo
 xe2lhPXM82PUVg01hh0tOSzDE8mgl2bO7B7EKACqywPXzwFx9clB2w3Z1vbA4N9L+PBP
 5+9AzQLVcjwaLu4xfhM2Ap/xkT+U55OqnZkCK68gvg+3+Hh76Hddi9vUwtfX+PLoMQto XA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bc14pr83u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 04:31:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 04:31:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 04:31:07 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 603313F7098;
        Tue, 28 Sep 2021 04:31:04 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 0/4] Externel ptp clock support
Date:   Tue, 28 Sep 2021 17:00:57 +0530
Message-ID: <20210928113101.16580-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4bsRoqC8DOhrHy7CzWhBAFOp_WKlN9Qz
X-Proofpoint-GUID: 4bsRoqC8DOhrHy7CzWhBAFOp_WKlN9Qz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Externel ptp support is required in a scenario like connecting
a external timing device to the chip for time synchronization.
This series of patches adds support to ptp driver to use external
clock and enables PTP config in CN10K MAC block (RPM). Currently
PTP configuration is left unchanged in FLR handler these patches
addresses the same.

Hariprasad Kelam (1):
  octeontx2-af: cn10k: RPM hardware timestamp configuration

Harman Kalra (1):
  octeontx2-af: Reset PTP config in FLR handler

Subbaraya Sundeep (1):
  octeontx2-af: Use ptp input clock info from firmware data

Yi Guo (1):
  octeontx2-af: Add external ptp input clock

 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  10 +-
 .../marvell/octeontx2/af/lmac_common.h        |   5 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  44 +++---
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 133 +++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/ptp.h   |   1 +
 .../net/ethernet/marvell/octeontx2/af/rpm.c   |  17 +++
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |   3 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   5 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   7 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  16 +++
 .../marvell/octeontx2/nic/otx2_common.h       |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ptp.c | 120 +++++++++++++++-
 13 files changed, 292 insertions(+), 79 deletions(-)

--
2.17.1
