Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E291A41C464
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343713AbhI2MQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:16:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1343566AbhI2MQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TBKfbx014735;
        Wed, 29 Sep 2021 05:12:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=MX5uqXWCePYkA3aMi1IuiknY/mxJ4knP5JFMrx5TtKc=;
 b=a2NksK8xVm9s7KZm5+T3zK7ffekuDJZE6BnXgudRLk2t2EdGgOU/Jm3SYvfB/CsO1HiY
 flcY8RuSGE3muJW2Cwki3upo3jzgyj7LIqYi/TC4986emRRBqEcceEZLPL2JZfX9WXDt
 xBkxeUv9/UKumRgkGYgsVzS3k8Fff1qUaKwclWNh1tR6oIcEfPysLDCw1lHhKAUXMHPC
 zbyROWqL0UyVt9arHMSrRJoZN09Bkxx9PlPynmGPpDqXHijuTp4CnuD1GyamW01+emK1
 cw8bHdkTWlDD0yqerOiJDy9oMR1vs4v1Aw71zvVHJOfv9bH1a3Ut8Rk4WR/5U3ETakI5 Sg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bcq67g5wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:12:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:12:24 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:12:21 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>
Subject: [PATCH 00/12] qed: new firmware version 8.59.1.0 support
Date:   Wed, 29 Sep 2021 15:12:03 +0300
Message-ID: <20210929121215.17864-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ngX1wBKostFjF1AkQtPj75m1OFWawcHR
X-Proofpoint-GUID: ngX1wBKostFjF1AkQtPj75m1OFWawcHR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
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
patch 1     - qed: Remove e4_ and _e4 from FW HSI
patch 2     - qed: split huge qed_hsi.h header file
patch 3-7   - HSI (hardware software interface) changes
patch 8     - qed: Add '_GTT' suffix to the IRO RAM macros
patch 9     - qed: Update debug related changes
patch 10    - qed: rdma: Update TCP silly-window-syndrome timeout
patch 11    - qed: Update the TCP active termination 2  MSL timer
patch 12    - qed: fix ll2 establishment during load of RDMA driver

In addition, this patch series also fixes existing checkpatch warnings
and checks which are missing.


Manish Chopra (1):
  qed: fix ll2 establishment during load of RDMA driver

Nikolay Assa (1):
  qed: Update TCP silly-window-syndrome timeout for iwarp, scsi

Omkar Kulkarni (2):
  qed: Split huge qed_hsi.h header file
  qed: Update FW init functions to support FW 8.59.1.0

Prabhakar Kushwaha (7):
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
 drivers/net/ethernet/qlogic/qed/qed.h         |    35 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |    16 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h     |     5 +-
 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h |  1478 ++
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h    |    11 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |  1398 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.h   |     7 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |   122 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h |     6 +-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c    |    25 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 12265 ++++++----------
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   |   405 +-
 .../net/ethernet/qlogic/qed/qed_init_ops.c    |    98 +-
 .../net/ethernet/qlogic/qed/qed_init_ops.h    |     2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     |     4 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h     |     2 +-
 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h |   500 +
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |    15 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   |     2 +
 drivers/net/ethernet/qlogic/qed/qed_l2.c      |    18 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.h      |     5 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |    64 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h     |     1 -
 drivers/net/ethernet/qlogic/qed/qed_main.c    |    17 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     |    64 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |    11 +-
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h |  2474 ++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    |     7 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.h    |     7 +-
 .../net/ethernet/qlogic/qed/qed_reg_addr.h    |    95 +-
 drivers/net/ethernet/qlogic/qed/qed_roce.c    |     1 -
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |     8 +-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |    10 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |    63 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |   200 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h   |    26 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |    11 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.h      |    11 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |     2 +-
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
 include/linux/qed/qed_if.h                    |     8 +-
 include/linux/qed/rdma_common.h               |     1 +
 59 files changed, 11687 insertions(+), 8814 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h

-- 
2.24.1

