Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E742139D2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 14:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgGCMJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 08:09:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725984AbgGCMJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 08:09:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063BxvLA032267;
        Fri, 3 Jul 2020 05:09:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=ap/k5j7l4RG3w1tMG4Znv4J89ZEdb/VTOvqpf/1oVKU=;
 b=s8zzqugwMCuM8V8r7XJz2blsEhpU8hncmKw+HIUb/ULW9FgoC6wCI7W5Sh+f8g5kGaQg
 DZ7TEReYBrk6jdicRRj5YRp3y5maEJIMMNXPnqWfWDkjJkD3HGg+ouCKgFQ1KZNtO6FF
 4O988Tw/RY4dBCtpUUrUdAFKRSbQcpcDBi8Y5VPNkaIElN0PyJwVh4zlrvhui87tI9hc
 vCD6/bljSKmBU/CJQGXaBUDb9RfUMcI5dEuFs+1819guHqRvbjBX1s7981PFEmIGBwRE
 u6bZANPXjJFPjPw5iq9NnoMx5Qkb4jeZMlcnLdC/mbgk24ytjwf1cJyFTSayi+zuYMhn nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92uhr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 05:09:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 05:09:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 05:09:56 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id 1974B3F703F;
        Fri,  3 Jul 2020 05:09:53 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v2 0/4] bnx2x: Perform IdleChk dump.
Date:   Fri, 3 Jul 2020 17:39:46 +0530
Message-ID: <1593778190-1818-1-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Idlechk test verifies that the chip is in idle state. If there are any
errors, Idlechk dump would capture the same. This would help in debugging
the device related issues.
The patch series adds driver support for dumping IdleChk data during the
debug dump collection.
Patch (1) adds register definitions required in this implementation.
Patch (2) adds database of self test checks (registers and predicates).
Patch (3) adds the implementation for Idlechk test.
Patch (4) adds driver changes to invoke Idlechk implementation.


Changes from previous version:
-------------------------------
v2: Addressed issues reported by kernel test robot.


Please consider applying to net-next tree.

Sudarsana Reddy Kalluru (4):
  bnx2x: Add Idlechk related register definitions.
  bnx2x: Populate database for Idlechk tests.
  bnx2x: Add support for idlechk tests.
  bnx2x: Perform Idlechk dump during the debug collection.

 drivers/net/ethernet/broadcom/bnx2x/Makefile       |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   16 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |   78 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_self_test.c  | 3184 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |    2 +
 6 files changed, 3282 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c

-- 
1.8.3.1

