Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59A3FB686
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhH3M4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:56:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4496 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232454AbhH3M4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:56:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17U2ELf9025338;
        Mon, 30 Aug 2021 05:55:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=s8DXCJtPPB4B9qw38n/M0aDBPSIzcd2a8g2zHwhODMY=;
 b=HGnJdvz3WV/SSKS9/bBqnOGcdu5JuwCxwyDMshRPqlFwtWAteIzP/Y+R4IoMli9u64Wo
 JMSuGw4x6c3tLf6GtBwXZ4ivHEGsaPPMI6g3a7QifPKY12ea06YtY7sRS4RXIbbamtS9
 aMnh1yTWT7KjPdFIPeZF3T34P1ajvzDVW6+BanpfhBDnIRYw6u4U0jamrq6Sdc8+lR2J
 o9wvdcdDOxYg3e8/3/4lcPYBzM0Ln0mkX/1iHnILc8COa1iaqHSTaXCMMg4mBSlh6aDE
 lxtP9O785skb2cM6vmEv8Py9rWCYOviCJXy9VJT8fAh+EAPnQykidOkgIGctY3Ldu7SH DQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3arpcahsqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 05:55:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 Aug
 2021 05:55:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 Aug 2021 05:55:22 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id AD8F53F7078;
        Mon, 30 Aug 2021 05:55:19 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Use NDC TX for transmit packet data
Date:   Mon, 30 Aug 2021 18:25:18 +0530
Message-ID: <20210830125518.20419-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: q3a96sC8PqlhS7t9Ocbdx2eWFnzl39dL
X-Proofpoint-ORIG-GUID: q3a96sC8PqlhS7t9Ocbdx2eWFnzl39dL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-30_05,2021-08-30_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better performance set hardware to use NDC TX for reading packet
data specified NIX_SEND_SG_S.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8f37477e0cb5..9ef4e942e31e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4200,6 +4200,9 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	/* Restore CINT timer delay to HW reset values */
 	rvu_write64(rvu, blkaddr, NIX_AF_CINT_DELAY, 0x0ULL);
 
+	/* For better performance use NDC TX instead of NDC RX for SQ's SQEs" */
+	rvu_write64(rvu, blkaddr, NIX_AF_SEB_CFG, 0x1ULL);
+
 	if (is_block_implemented(hw, blkaddr)) {
 		err = nix_setup_txschq(rvu, nix_hw, blkaddr);
 		if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 576b037a00f0..21f1ed4e222f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -263,6 +263,7 @@
 #define NIX_AF_SDP_TX_FIFO_STATUS	(0x0640)
 #define NIX_AF_TX_NPC_CAPTURE_CONFIG	(0x0660)
 #define NIX_AF_TX_NPC_CAPTURE_INFO	(0x0670)
+#define NIX_AF_SEB_CFG			(0x05F0)
 
 #define NIX_AF_DEBUG_NPC_RESP_DATAX(a)          (0x680 | (a) << 3)
 #define NIX_AF_SMQX_CFG(a)                      (0x700 | (a) << 16)
-- 
2.17.1

