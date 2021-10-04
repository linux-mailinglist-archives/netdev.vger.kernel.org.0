Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2DF420620
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 08:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhJDHAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:00:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41392 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232940AbhJDHAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 03:00:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19419DPt032665;
        Sun, 3 Oct 2021 23:58:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=RPXeK0JWSI011uOg22qqmVR3lC45HXoodzNvir7l5a4=;
 b=Y4jgCfDHJ3eMrEiNKETv4SNei7QEYXaTghqaiG6AEXxXm1CElsZh+EMsWQSYViXZqfuQ
 8WdgnK0utCT+S2BDyyettNpEv4XVYpRbauBF+LiBWqR5sfBI0ahRfBhgVgdWfCsI+V9U
 6/By0Q6iHBodEfMMRHbcF+QkBZLNXXmluvdLgJQD6dcGPQi3pkY4sXyTwK0YvwYTuTLg
 xNuT0PRkrH3gi0+ItgLtSWrBBiWO4KuqqWfs4O24Wnk5ThGg72WYROpEe5n4q05LKon3
 YXXfKfyOYjQLw/2hY+B+yVPqbjbf3ldE2Ymy4jsqH1Dp9ctbGEG38/lwJ7tJeF1blljL Sw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bfqptrnqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 03 Oct 2021 23:58:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 3 Oct
 2021 23:58:58 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 3 Oct 2021 23:58:55 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>
Subject: [PATCH v2 00/13] qed: new firmware version 8.59.1.0 support
Date:   Mon, 4 Oct 2021 09:58:38 +0300
Message-ID: <20211004065851.1903-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: fOc3eJaFNv_syti1Zq40fXrrlDfIlJaz
X-Proofpoint-ORIG-GUID: fOc3eJaFNv_syti1Zq40fXrrlDfIlJaz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_02,2021-10-01_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series integrate new firmware version 8.59.1.0, along with updated
HSI (hardware software interface) to use the FW, into the family of
qed drivers (fastlinq devices). This FW does not reside in the NVRAM.
It needs to be programmed to device during driver load as the part of
initialization sequence.

Similar to previous FW support series, this FW is tightly linked to
software and pf function driver. This means FW release is not backward
compatible, and driver should always run with the FW it was designed
against.

FW binary blob is already submitted & accepted in linux-firmware repo.

Patches in the series include:
patch 1     - qed: Fix kernel-doc warnings
patch 2     - qed: Remove e4_ and _e4 from FW HSI
patch 3     - qed: split huge qed_hsi.h header file
patch 4-8   - HSI (hardware software interface) changes
patch 9     - qed: Add '_GTT' suffix to the IRO RAM macros
patch 10    - qed: Update debug related changes
patch 11    - qed: rdma: Update TCP silly-window-syndrome timeout
patch 12    - qed: Update the TCP active termination 2  MSL timer
patch 13    - qed: fix ll2 establishment during load of RDMA driver

In addition, this patch series also fixes existing checkpatch warnings
and checks which are missing.

Changes for v2:
 - Incorporated Jakub's comments.
   - New patch introduced to fix all kernel-doc issue in qed driver.
   - Fixed warning: ‘qed_mfw_ext_20g’ defined but not used.
   - Fixed warning related to kernel-doc wrt to this series.
   - Removed inline function declaration.

Manish Chopra (1):
  qed: fix ll2 establishment during load of RDMA driver

Nikolay Assa (1):
  qed: Update TCP silly-window-syndrome timeout for iwarp, scsi

Omkar Kulkarni (2):
  qed: Split huge qed_hsi.h header file
  qed: Update FW init functions to support FW 8.59.1.0

Prabhakar Kushwaha (8):
  qed: Fix kernel-doc warnings
  qed: Update common_hsi for FW ver 8.59.1.0
  qed: Update qed_mfw_hsi.h for FW ver 8.59.1.0
  qed: Update qed_hsi.h for fw 8.59.1.0
  qed: Use enum as per FW 8.59.1.0 in qed_iro_hsi.h
  qed: Add '_GTT' suffix to the IRO RAM macros
  qed: Update debug related changes
  qed: Update the TCP active termination 2 MSL timer ("TIME_WAIT")

Shai Malin (1):
  qed: Remove e4_ and _e4 from FW HSI

 drivers/infiniband/hw/qedr/main.c             |     2 +-
 drivers/net/ethernet/qlogic/qed/qed.h         |    44 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |    16 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h     |   143 +-
 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h |  1491 ++
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h    |    11 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |  1394 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.h   |     7 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |   122 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h |   345 +-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c    |    25 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 12643 +++++++---------
 drivers/net/ethernet/qlogic/qed/qed_hw.h      |   222 +-
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   |   405 +-
 .../net/ethernet/qlogic/qed/qed_init_ops.c    |    98 +-
 .../net/ethernet/qlogic/qed/qed_init_ops.h    |    60 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     |     4 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h     |   286 +-
 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h |   500 +
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |    15 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.h   |     9 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   |     2 +
 drivers/net/ethernet/qlogic/qed/qed_l2.c      |    18 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.h      |   135 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |    64 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h     |   131 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |    21 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |    64 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |   763 +-
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h |  2474 +++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    |     7 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.h    |     7 +-
 .../net/ethernet/qlogic/qed/qed_reg_addr.h    |    95 +-
 drivers/net/ethernet/qlogic/qed/qed_roce.c    |     1 -
 .../net/ethernet/qlogic/qed/qed_selftest.h    |    30 +-
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   223 +-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |    10 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |    63 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |   200 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h   |   126 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |    11 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.h      |   307 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |     7 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.c         |     8 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h         |     2 +-
 drivers/scsi/qedf/qedf.h                      |     4 +-
 drivers/scsi/qedf/qedf_els.c                  |     2 +-
 drivers/scsi/qedf/qedf_io.c                   |    12 +-
 drivers/scsi/qedf/qedf_main.c                 |     8 +-
 drivers/scsi/qedi/qedi_debugfs.c              |     4 +-
 drivers/scsi/qedi/qedi_fw.c                   |    40 +-
 drivers/scsi/qedi/qedi_fw_api.c               |    22 +-
 drivers/scsi/qedi/qedi_fw_iscsi.h             |     2 +-
 drivers/scsi/qedi/qedi_iscsi.h                |     2 +-
 drivers/scsi/qedi/qedi_main.c                 |    11 +-
 include/linux/qed/common_hsi.h                |   141 +-
 include/linux/qed/eth_common.h                |     1 +
 include/linux/qed/fcoe_common.h               |   362 +-
 include/linux/qed/iscsi_common.h              |   360 +-
 include/linux/qed/nvmetcp_common.h            |    18 +-
 include/linux/qed/qed_chain.h                 |    97 +-
 include/linux/qed/qed_if.h                    |   263 +-
 include/linux/qed/qed_iscsi_if.h              |     2 +-
 include/linux/qed/qed_ll2_if.h                |    42 +-
 include/linux/qed/qed_nvmetcp_if.h            |    17 +
 include/linux/qed/rdma_common.h               |     1 +
 66 files changed, 13577 insertions(+), 10445 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h

-- 
2.24.1

