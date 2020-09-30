Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B103027EF81
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbgI3QoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:44:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59090 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725355AbgI3QoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:44:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UGfLRd023424;
        Wed, 30 Sep 2020 09:44:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=1UGaJPzTfyB8nPYo1hRE692Gb3T/PR+4SYCr720aunA=;
 b=etGS+zFf4qM8mO2aLza6uJ6/LBgd4uMPYbnJwPqlEtik9DS5pLdSlYD3sQy3khJC9p1V
 xLvAl/FVLiyL+hNu6uF/PPxgMoL6k+IJTS3caxNXS24mJB+0b1Osh8p73ZReJfhx92k8
 j5s5YeEXBQR1nfxnUHCFeyeG0IJIVRyR8dO8oachLS+WMkLPckPrCN3NSCnRd1pgsq8a
 0XZm3TbcDRJxsTYq9IERwEomaLwzFAhTrxRRX2PRAWNAAzn/E1mq4Z8bPij4niNXOwdT
 FZ6UGAySUPXkaBMJ6zqNjn4YEG3eZWzxhOz7JIT2PFBZ+LyXIyuVOHy2J9vvhUeVHd1u Qg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemh54m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 09:44:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 09:44:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Sep 2020 09:44:00 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id DFAA63F703F;
        Wed, 30 Sep 2020 09:43:58 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <davem@davemloft.net>, Geetha sowjanya <gakula@marvell.com>
Subject: [net PATCH v2 0/4] Fix bugs in Octeontx2 netdev driver
Date:   Wed, 30 Sep 2020 21:38:10 +0530
Message-ID: <1601482090-14906-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In existing Octeontx2 network drivers code has issues
like stale entries in broadcast replication list, missing
L3TYPE for IPv6 frames, running tx queues on error and 
race condition in mbox reset.
This patch set fixes the above issues.

Geethe sowjanya (1):
  octeontx2-pf: Fix TCP/UDP checksum offload for IPv6 frames

Hariprasad Kelam (2):
  octeontx2-pf: Fix the device state on error
  octeontx2-pf: Fix synchnorization issue in mbox

Subbaraya Sundeep (1):
  octeontx2-af: Fix enable/disable of default NPC entries

 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   | 12 ++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  3 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  5 ++---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 26 ++++++++++++++++------
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 16 ++++++++-----
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  4 ++--
 8 files changed, 47 insertions(+), 21 deletions(-)

-- 
2.7.4

