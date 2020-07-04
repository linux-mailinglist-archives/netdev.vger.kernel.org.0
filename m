Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF5214429
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 06:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgGDEnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 00:43:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgGDEnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 00:43:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0644a0ks008524;
        Fri, 3 Jul 2020 21:43:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=CupylDSfpjwxDofIcUtYNGsy/mGRxONb9LVG4WwGGOc=;
 b=q0VnJdUoXCUhCy+8IKP13QJ0tN/J5y8TYgmwjvlu0gyYghARNDw4QLzrKHPBU8J10tcZ
 AmbXlAolJTT1SixEn13Uk3SzAwKAyqiFvbd4cj14gNv3EUKIzETlM994lEMMH95MARB2
 WwFCN9VjgcU3fPWETBWWhionMkDnwDzwoTDR6NU9x3ZGeN84Z3ej46muitcUCR3mjrih
 p8ZfihOh6MQV7UOmQTlRCPhxEz9Hjr7ic90A2q0WmrwgxdCJGWUSMrXJtjjxzgwkWUBu
 3E0/Rj9jt7CNkhF462vLeoOa7Tp1ngklx9HNeMwPeUnoqfnARk01fZIzc2LaA0/8fLEI 4Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92xay3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 21:43:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 21:43:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 21:43:50 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id 848BD3F703F;
        Fri,  3 Jul 2020 21:43:48 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v3 0/3] bnx2x: Perform IdleChk dump.
Date:   Sat, 4 Jul 2020 10:13:41 +0530
Message-ID: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-04_03:2020-07-02,2020-07-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Idlechk test verifies that the chip is in idle state. If there are any
errors, Idlechk dump would capture the same. This data will help in
debugging the device related issues.
The patch series adds driver support for dumping IdleChk data during the
debug dump collection.
Patch (1) adds register definitions required in this implementation.
Patch (2) adds the implementation for Idlechk tests.
Patch (3) adds driver changes to invoke Idlechk implementation.


Changes from previous version:
-------------------------------
v3: Combined the test data creation and implementation to a single patch.
v2: Addressed issues reported by kernel test robot.


Please consider applying to net-next tree.


Sudarsana Reddy Kalluru (3):
  bnx2x: Add Idlechk related register definitions.
  bnx2x: Add support for idlechk tests.
  bnx2x: Perform Idlechk dump during the debug collection.

 drivers/net/ethernet/broadcom/bnx2x/Makefile       |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   16 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |   78 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_self_test.c  | 3183 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |    2 +
 6 files changed, 3281 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c

-- 
1.8.3.1

