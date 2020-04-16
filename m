Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460B91ABB8F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 10:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502680AbgDPIpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 04:45:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62210 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502716AbgDPIom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8eWtd013926;
        Thu, 16 Apr 2020 01:43:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=/I9RooBI+GLQnVR4q2Q8SItKmSSDw7RNfd7UYgtaNIs=;
 b=AwJDdVNb83aIKGgZ7ux1dkoPlBd333jx6joRHiyf3QIynz2eXIWxNxvZkjsxU9Wz6BN0
 XUkHb8Sc+hQrI9eH3EayCtlj2tO4J6BptBOc2hXr3xmNrpyiXIhrXCOn5ysZbrJtDZGd
 p9W9LSHKfUpM7g4kTN3rGC97MJsoLiWTAk9I/WGBkrsSHBMaeSFIXE7ep/HuzUfZNroK
 0W3T2qLQPQGpFUgb6L01weUCA+erS4vKxUiHJYCLqc/rYyq3i3KpXbjyVYKlt/BP7IYb
 9e+LorlZAgTvR5NmfNkx49AqFsovxGQV7phA1XF51Vpwg1BdHCKeiJpFJCnavEMCLD+k /w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30dn8gp585-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:14 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 602323F7041;
        Thu, 16 Apr 2020 01:43:14 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hEE6018886;
        Thu, 16 Apr 2020 01:43:14 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hErh018885;
        Thu, 16 Apr 2020 01:43:14 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 0/9] qed/qedf: Firmware recovery, bw update and misc fixes.
Date:   Thu, 16 Apr 2020 01:43:05 -0700
Message-ID: <20200416084314.18851-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_03:2020-04-14,2020-04-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Kindly apply this series to scsi tree at your earliest convenience.

v3->v4
 - Description updated for patches 1,6,7 and 9.
 - Patch "Fix for the deviations from the SAM-4 spec." divided into 3
	- Increase the upper limit of retry delay.
	- Acquire rport_lock for resetting the delay_timestamp
	- Honor status qualifier in FCP_RSP per spec.

v2->v3
 - Removed version update patch.

v1->v2
 - Function qedf_schedule_recovery_handler marked static
 - Function qedf_recovery_handler marked static

Thanks,
~Saurav
 

Chad Dupuis (2):
  qedf: Add schedule recovery handler.
  qedf: Fix crash when MFW calls for protocol stats while function is
    still probing.

Javed Hasan (3):
  qedf: Increase the upper limit of retry delay.
  qedf: Acquire rport_lock for resetting the delay_timestamp
  qedf: Honor status qualifier in FCP_RSP per spec.

Saurav Kashyap (3):
  qedf: Keep track of num of pending flogi.
  qedf: Implement callback for bw_update.
  qedf: Get dev info after updating the params.

Sudarsana Reddy Kalluru (1):
  qed: Send BW update notifications to the protocol drivers.

 drivers/net/ethernet/qlogic/qed/qed.h      |   1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c |   9 ++
 drivers/scsi/qedf/qedf.h                   |   6 +-
 drivers/scsi/qedf/qedf_io.c                |  47 +++++++---
 drivers/scsi/qedf/qedf_main.c              | 135 ++++++++++++++++++++++++++++-
 include/linux/qed/qed_if.h                 |   1 +
 6 files changed, 184 insertions(+), 15 deletions(-)

-- 
1.8.3.1

