Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F42221C9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgGPLzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:55:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726855AbgGPLzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:55:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBpRlH032117;
        Thu, 16 Jul 2020 04:55:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=zkt6g5gh0HiU+37ddd5luZcJaLMS2v4jLyGRzTgIdxM=;
 b=bIjjhfvXHAo9Kn8xq0u406VOi4wT20XYSLf8219VXy05vXMA6BlOcRF0jTZ6MC8Og8AS
 vLVHjynOUSXdzUY0tqcuJsrwPRCMaERH4skGbfjX+12cKKp8SkRd/rgP6wR1I074pby4
 97y7BzgXzGlnvAF7LVwofv5tY5CIgJmd6WepVsdcZBS7u0DElK2weCSn8kaKIIfPKstE
 +ObanoeecywXnRjMrTzJTsGOVPwnV7MW3zl0MYxvmhg9Btsa1bnOiKLYp2CSuzsvsS+h
 AhLt/9Kni/u3qZNyXhCZNMSKFnoif5SJvmr7XsUehnegxJpcQMw6iIaBuWAFgZeOoNQT wA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7v81nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:55:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:55:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:55:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 04:55:27 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id A3EB53F703F;
        Thu, 16 Jul 2020 04:55:22 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 00/13] qed/qede: add support for new operating modes
Date:   Thu, 16 Jul 2020 14:54:33 +0300
Message-ID: <20200716115446.994-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series covers the support for the following:
 - new port modes;
 - loopback modes, previously missing;
 - new speed/link modes;
 - several FEC modes;
 - multi-rate transceivers;

and also cleans up and optimizes several related parts of code.

Alexander Lobakin (13):
  qed: convert link mode from u32 to bitmap
  qed: reformat public_port::transceiver_data a bit
  qed: add support for multi-rate transceivers
  qed: use transceiver data to fill link partner's advertising speeds
  qed: reformat several structures a bit
  qed: add support for Forward Error Correction
  qede: format qede{,_vf}_ethtool_ops
  qede: introduce support for FEC control
  qed: reformat several structures a bit
  qed: add support for new port modes
  qed: add missing loopback modes
  qed: populate supported link modes maps on module init
  qed/qede: add support for the extended speed and FEC modes

 drivers/net/ethernet/qlogic/qed/qed.h         |  68 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 161 +++-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 786 ++++++++++--------
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 757 +++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 126 ++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 146 ++--
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 468 ++++++-----
 drivers/scsi/qedf/qedf_main.c                 |  77 +-
 include/linux/qed/qed_if.h                    | 185 +++--
 9 files changed, 1863 insertions(+), 911 deletions(-)

-- 

Dave, patch #0001 affects qedf under scsi tree, but could you take it
through yours? It will break incremental buildability and bisecting
otherwise. Thanks.

-- 
2.25.1

