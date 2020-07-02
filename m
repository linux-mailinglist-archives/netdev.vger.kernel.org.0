Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A02125BC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgGBOKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:10:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63904 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729263AbgGBOKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:10:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062Dlgpr030670;
        Thu, 2 Jul 2020 07:10:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=mG7Lj/OAXEmbVOmpGLAcPSJm4i2CNoivC+4lVUHnOoo=;
 b=OYDxeUcaZrlkO/DzcBdzj9vjqP51U6q+SmiqfKmbspPDh4rFRHcvnxr5m35QH64tk92F
 IddtI2ezoJsJpg9JICk3KwfwedSiMar6Mhry/J21sFiNrV3ci6d9o3ZSx9qEu9DhlZ5+
 3T6lG6nlwquiC5Cq30qCeCCYTs+SczwlHbuMvWW36zz+kYLitOf1OaY2h7FaZQg75GZQ
 Bb/UcWoZhsSlZDAXmHTsOHsvt/2gUAcZw//LXbjppxBlZR4jPfbAgFiuNX2C7INLSjKa
 RT5+ff55yRTTncfS8TNVKfBnpjSmRpsBjIJ6NFXUXcdb9qyUON13kefdiaaUalJwXrnV Ag== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mnwj8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 07:10:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 07:10:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 07:10:34 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id E5C5C3F703F;
        Thu,  2 Jul 2020 07:10:32 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 0/4] bnx2x: Perform IdleChk dump.
Date:   Thu, 2 Jul 2020 19:40:25 +0530
Message-ID: <1593699029-18937-1-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
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


Sudarsana Reddy Kalluru (4):
  bnx2x: Add Idlechk related register definitions.
  bnx2x: Populate database for Idlechk tests.
  bnx2x: Add support for idlechk tests.
  bnx2x: Perform Idlechk dump during the debug collection.

 drivers/net/ethernet/broadcom/bnx2x/Makefile       |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |    3 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    9 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |   78 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_self_test.c  | 3184 ++++++++++++++++++++
 5 files changed, 3273 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c

-- 
1.8.3.1

