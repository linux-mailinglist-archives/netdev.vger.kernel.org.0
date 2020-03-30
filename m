Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80B5197484
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgC3Gaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:30:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728065AbgC3Gai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:30:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6UPMT015736;
        Sun, 29 Mar 2020 23:30:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=ij5IRaxp+RXjdNuJ4VRLZDanjqLeUUXAjFcQnlPax/I=;
 b=hQQ9y5hyZe75y6yi21VUmli9Id+LtKvkTypBHBqTKrCq1dD2U6gHKAdD4yEwtFg0T2aM
 nolmHrewsE+GFcNxM0bTYxte4dxCGp10q55JY6iQfkvXWRm10bTJMWqiy5Z5hlPsTnwG
 vEhr8V6qKEdQUXymQS/E0BMsFjTiNWjagimb5brYNuwwOll55bP8nS8gen3h5n7X+RYD
 j63P2kMb7JvmAvRbwBGFTyWTr1l/seCFAl107LFvtEM+ETIOoPaYCDM/eckbLkC0q7l+
 zAPXHtGETY5tUkhQQBCmhjYEjqbaArSmw08Fa7Nntey4T2Cc7Ya29NTVoMNig4UgAfTQ 0g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30263kd1j9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:30:37 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:35 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:30:35 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 10F2F3F703F;
        Sun, 29 Mar 2020 23:30:35 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6UYuL027344;
        Sun, 29 Mar 2020 23:30:34 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6UYPU027343;
        Sun, 29 Mar 2020 23:30:34 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update and misc fixes.
Date:   Sun, 29 Mar 2020 23:30:26 -0700
Message-ID: <20200330063034.27309-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Kindly apply this series to scsi tree at your earliest convenience.

v1->v2
 - Function qedf_schedule_recovery_handler marked static
 - Function qedf_recovery_handler marked static

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
 drivers/scsi/qedf/qedf.h                   |   6 +-
 drivers/scsi/qedf/qedf_io.c                |  47 +++++++---
 drivers/scsi/qedf/qedf_main.c              | 135 ++++++++++++++++++++++++++++-
 drivers/scsi/qedf/qedf_version.h           |   4 +-
 include/linux/qed/qed_if.h                 |   1 +
 7 files changed, 186 insertions(+), 17 deletions(-)

-- 
1.8.3.1

