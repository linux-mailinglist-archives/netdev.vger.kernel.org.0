Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F6D19393F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgCZHIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:08:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36988 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726332AbgCZHIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:08:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q70RBa019447;
        Thu, 26 Mar 2020 00:08:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=amTGRVy2cDza1JEHD0hIn0lUoWI5LttAlaD1GjyqLvc=;
 b=GXhSCQaE7d+uvp/llnEj7oFt+zQDNS5xZRX6kCVTPZyRavZtOk/1gGBgj4DZm/kr5Y9C
 K8v30ERCtwIy3Te7lYy4auKhNH3PGQim1DAuT3r5/aZbAR7TZ8qfO2uHQK17VqayjknO
 nl0hqZXJH86G2UQovAApsgrG0BtIhtj9JalzkpbEUo/hoUaf9LuLXJPktQySpW15BswF
 nx4m/54JPN+PiisrsHnuUDnzJHc+YFika/Dfug5FOgz7dYWcIgAiZdPiEbIRa2v7CfoP
 ghfiF9BUCZzVZulDsOgLDjIPs3KEzw/DG6EYUBBhZZFsnDs+dVlGlcOpxhjJh/QEJ+yo tg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nv944-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 00:08:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 00:08:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C9D893F703F;
        Thu, 26 Mar 2020 00:08:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02Q786Il025528;
        Thu, 26 Mar 2020 00:08:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02Q7861w025527;
        Thu, 26 Mar 2020 00:08:06 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 0/8] qed/qedf: Firmware recovery, bw update and misc fixes. 
Date:   Thu, 26 Mar 2020 00:07:58 -0700
Message-ID: <20200326070806.25493-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Kindly apply this series to scsi tree at your earliest convenience.

Thanks,
~Saurav
 
Chad Dupuis (2):
  qedf: Add schedule recovery handler.
  qedf: Fix crash when MFW calls for protocol stats while function is
    still probing.

Javed Hasan (1):
  qedf: Fix for the deviations from the SAM-4 spec.

Saurav Kashyap (4):
  qedf: Keep track of num of pending flogi.
  qedf: Implement callback for bw_update.
  qedf: Get dev info after updating the params.
  qedf: Update the driver version to 8.42.3.5.

Sudarsana Reddy Kalluru (1):
  qed: Send BW update notifications to the protocol drivers.

 drivers/net/ethernet/qlogic/qed/qed.h      |   1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c |   9 ++
 drivers/scsi/qedf/qedf.h                   |   8 +-
 drivers/scsi/qedf/qedf_io.c                |  47 +++++++---
 drivers/scsi/qedf/qedf_main.c              | 133 ++++++++++++++++++++++++++++-
 drivers/scsi/qedf/qedf_version.h           |   4 +-
 include/linux/qed/qed_if.h                 |   1 +
 7 files changed, 186 insertions(+), 17 deletions(-)

-- 
1.8.3.1

