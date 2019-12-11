Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8814311BADD
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbfLKSAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:00:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20596 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730430AbfLKSAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:00:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBHuMQn002268;
        Wed, 11 Dec 2019 10:00:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=GamqZC8XV8DskjUsQEM8IDdAJlevLDfVNeLPvpufndY=;
 b=GDy6NflxA2buS9EXr/hiGNBD4HPVEu9JdlFYuNpI7FHu1+QeXpgY8/OriEpoXhSkGOoj
 sdCwreJ0j28xc9fsklFVRj5K2hp21IBSxVvVtHBQYvG6uOyLdj607o3TniX+u6NvSo89
 QGIF0NZm4W5JSOVxW3FKClFgcXGKURl27YeS3M12pmp9bZlVL5x956VsSnMBheph6+6R
 EuLUJ5SH+5OJc7KzzhXXVuQRhAuUX/3WOc+w4PF0+aachKgOXq9uqhf7ewr2U55ueL3N
 AuRMNv6S09wPU+c5ZpFF86tEU/OZxoO1pK+qobJzJShe/NzCGzA8hdOVdwT6sEEHBG5x 8Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg6fsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 10:00:00 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Dec
 2019 09:59:58 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 11 Dec 2019 09:59:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5F4583F703F;
        Wed, 11 Dec 2019 09:59:58 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBBHxws6011985;
        Wed, 11 Dec 2019 09:59:58 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBBHxvYe011984;
        Wed, 11 Dec 2019 09:59:57 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH v2 net 0/2] bnx2x: bug fixes
Date:   Wed, 11 Dec 2019 09:59:54 -0800
Message-ID: <20191211175956.11948-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_05:2019-12-11,2019-12-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This series has two driver changes, one to fix some unexpected
hardware behaviour casued during the parity error recovery in
presence of SR-IOV VFs and another one related for fixing resource
management in the driver among the PFs configured on an engine.

Please consider applying it to "net".

V1->V2:
=======
Fix the compilation errors reported by kbuild test robot
on the patch #1 with CONFIG_BNX2X_SRIOV=n

Thanks,
Manish
 
Manish Chopra (2):
  bnx2x: Do not handle requests from VFs after parity
  bnx2x: Fix logic to get total no. of PFs per engine

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 12 ++++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 12 ++++++++++++
 4 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.18.1

