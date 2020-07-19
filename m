Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C9C2253E8
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGSUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:15:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23376 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbgGSUPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:15:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKDQiB014975;
        Sun, 19 Jul 2020 13:15:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=dOLzVjziv+ZS2I4BMX+OggUWyQ4mBfOX4Ct9st4bvI8=;
 b=IMkP5iFY8n14Gm3J0vFvyi7zGFp9EMqbI+7TyUSf0PE1QzI93kYhTYLhgUOqJ6KwkfH8
 BYIMiOUgu8L1bzNz5VY/METjDQ0gBzwsfWaWx1RxDa48uh34Ja+SmGOp3Dmz9TuGcxjr
 UI1ElfRxsvKlDy2rLh90ZDZBISkQIIdqTXdmDTb3el9uev3K5CI7/PTGYS5ybdHy2Tpl
 pHa0bRhwQJUFkLX0extXstriPl92YaAkuXDdtb8OXJIaTHzbR4T5nB8MSTzuBQUV+V82
 57BkUA7vOtrRZe7Bn3dBLDyrJGIX7JBX9wQpvjr13o5DS/33L4dj2DFv2QvBa2asBqkh qQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkbf2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:15:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:15:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:15:17 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C12AE3F703F;
        Sun, 19 Jul 2020 13:15:13 -0700 (PDT)
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
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 00/14] qed/qede: add support for new operating modes
Date:   Sun, 19 Jul 2020 23:14:39 +0300
Message-ID: <20200719201453.3648-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-19_04:2020-07-17,2020-07-19 signatures=0
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

v2 (from [1]):
 - added a patch (#0010) that drops discussed dead struct member;
 - addressed checkpatch complaints on #0014 (former #0013);
 - rebased on top of latest net-next;
 - no other changes.

[1] https://lore.kernel.org/netdev/20200716115446.994-1-alobakin@marvell.com/

Alexander Lobakin (14):
  qed: convert link mode from u32 to bitmap
  qed: reformat public_port::transceiver_data a bit
  qed: add support for multi-rate transceivers
  qed: use transceiver data to fill link partner's advertising speeds
  qed: reformat several structures a bit
  qed: add support for Forward Error Correction
  qede: format qede{,_vf}_ethtool_ops
  qede: introduce support for FEC control
  qed: reformat several structures a bit
  qed: remove unused qed_hw_info::port_mode and QED_PORT_MODE
  qed: add support for new port modes
  qed: add missing loopback modes
  qed: populate supported link modes maps on module init
  qed/qede: add support for the extended speed and FEC modes

 drivers/net/ethernet/qlogic/qed/qed.h         | 125 ++-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 172 +++-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 786 ++++++++++--------
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 764 +++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 126 ++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     | 146 ++--
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 468 ++++++-----
 drivers/scsi/qedf/qedf_main.c                 |  77 +-
 include/linux/qed/qed_if.h                    | 185 +++--
 9 files changed, 1879 insertions(+), 970 deletions(-)

--

Netdev maintainers, patch #0001 affects qedf under scsi tree, but could
you take it through yours after all necessary acks? It will break
incremental buildability and bisecting otherwise. Thanks.

-- 
2.25.1

