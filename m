Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2862461EBE2
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiKGHZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiKGHZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:25:49 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBA7FE7;
        Sun,  6 Nov 2022 23:25:48 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A76WkaT004205;
        Sun, 6 Nov 2022 23:25:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=dR84L5M7f0rEp14WkHYS3A0CrieBvZ3Ul0UZdPrab3s=;
 b=f72elxwjs9jaqhp2sVRBDloP4Pxnmw3IZBsa13dSnzz32C92WtUrldP6nH48Ix+gBTsh
 SjUAgS34z/kNdncOBdG7zOhhXCsR3fphEH6aC9skzCraf1l9CwoT+XFXJj5gU7ym8qE2
 3lhVpJQ2OXl99HPt6hAwpilVFsnbkDn7CreOzf6z9aiH0uZDV4uauaesuZ6dKmMeeZLs
 9QPkQDESQEgqPU2BzYsToB9xrZWthdspY0BdEA08PUwMwVdZCEEJBH1P0FYkuR08bgUX
 7IrxVjoKxbYnZfUFGlmtEzrAK2A6Zd1CypBNy0TZKRdTDhkrqqommaVdqp3UjwCTxSzy fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kpvuk858a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 23:25:40 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 6 Nov
 2022 23:25:38 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 6 Nov 2022 23:25:38 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 0D4AF3F704F;
        Sun,  6 Nov 2022 23:25:38 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/9] octeon_ep: Update PF mailbox for VF
Date:   Sun, 6 Nov 2022 23:25:14 -0800
Message-ID: <20221107072524.9485-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: KXCrLo-q7l4yAu92coZCPN-Z4oGFL_Yk
X-Proofpoint-ORIG-GUID: KXCrLo-q7l4yAu92coZCPN-Z4oGFL_Yk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update PF mailbox for VF support.
Octeon VF driver will be submitted as separate patchset.

Veerasenareddy Burru (9):
  octeon_ep: wait for firmware ready
  octeon_ep: poll for control messages
  octeon_ep: control mailbox for multiple PFs
  octeon_ep: enhance control mailbox for VF support
  octeon_ep: support asynchronous notifications
  octeon_ep: control mbox support for VF stats and link info
  octeon_ep: add SRIOV VF creation
  octeon_ep: add PF-VF mailbox communication
  octeon_ep: add heartbeat monitor

 .../net/ethernet/marvell/octeon_ep/Makefile   |   3 +-
 .../marvell/octeon_ep/octep_cn9k_pf.c         | 114 +++--
 .../ethernet/marvell/octeon_ep/octep_config.h |   6 +
 .../marvell/octeon_ep/octep_ctrl_mbox.c       | 318 ++++++++------
 .../marvell/octeon_ep/octep_ctrl_mbox.h       | 102 +++--
 .../marvell/octeon_ep/octep_ctrl_net.c        | 404 ++++++++++++------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 196 +++++----
 .../marvell/octeon_ep/octep_ethtool.c         |  12 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   | 378 ++++++++++++----
 .../ethernet/marvell/octeon_ep/octep_main.h   |  81 +++-
 .../marvell/octeon_ep/octep_pfvf_mbox.c       | 306 +++++++++++++
 .../marvell/octeon_ep/octep_pfvf_mbox.h       | 126 ++++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  15 +
 .../net/ethernet/marvell/octeon_ep/octep_tx.h |  24 +-
 14 files changed, 1544 insertions(+), 541 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.h


base-commit: 63d9e12914840400e9f96c2ae9a51cd9702c2daf
-- 
2.36.0

