Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C7019D667
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 14:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403852AbgDCMKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 08:10:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13194 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgDCMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 08:10:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033C1IgD019931;
        Fri, 3 Apr 2020 05:10:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=fRaZruGGDWLtejOLJXgU2iAFBH6q0SkL+iIka5gHwjE=;
 b=iUPrG7K62Z7UM7wMunKC/jaJTLB1Op7g985Uw9qN+g75hcZvi7b2l0LR/hNj6C5s9zuc
 ldarRBP/59ISB5uumROfEdLDtF8gYcRTpebfLfawwoz+UN7HzsDPRjg0fZ74UiaplG2h
 FtaaBTb5CvN/6jBwLwsS6XjMa12uO7onCKeh74xIeaPJyYFFD83qmxgsgyKXGq/7y6Cv
 G1rb5pQXaT5e10gGgcAS/v+/dja4emkiBQ6O1OBYSJy9O0OYq+FQmKBV67nWGGmcWpdY
 HWjYDcQj/gg6ZQ4aeTo1zstnQs3L9RzgNwyTj6bMzQAyT3UhfRPyZMqU+DaaUyxkxj2R vA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3046h66swt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Apr 2020 05:09:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 05:09:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 05:09:58 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A67A43F703F;
        Fri,  3 Apr 2020 05:09:57 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 033C9vWv002466;
        Fri, 3 Apr 2020 05:09:57 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 033C9vnO002465;
        Fri, 3 Apr 2020 05:09:57 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 0/7] qed/qedf: Firmware recovery, bw update and misc fixes.
Date:   Fri, 3 Apr 2020 05:09:50 -0700
Message-ID: <20200403120957.2431-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_07:2020-04-02,2020-04-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Kindly apply this series to scsi tree at your earliest convenience.

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

Javed Hasan (1):
  qedf: Fix for the deviations from the SAM-4 spec.

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

