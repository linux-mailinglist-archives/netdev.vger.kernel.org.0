Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C344843B231
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhJZMVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:21:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235845AbhJZMVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:21:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5tmuV012639;
        Tue, 26 Oct 2021 05:18:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/m/97V+GFBE+0tM42UMwda7a8psStc2Xf6Re+ccHSWs=;
 b=lYzRTQLQoyfz9vz1EcdhdlE0IDicUviq+dvRZhkrMkQp24FdTUPy0R7ZWO4BeXsrhx3C
 oy7Sm73EE6O4fb9yEqCbLNuAKNywCsUqcsOX54paauZ1WPNWZdT/1ZHtzV3t2R1gCd9c
 fXi6tLJRaTUSD+zYlxVi1LR/2vu37JCRZyfWedN+yt/iwuAhJMVVyX4aPeSPWsK56yPG
 Q+ioHx+cYQ0FGqVLvhrv5V4F0PE7YiLHHPdXz+m4pky+3Hm3FEKQLbPSbiYpYqvK/8bL
 jexlQGixUy+0PAHmXg/ML5cMLEnRr0jhvrr/1FQRzzLlR0hT+8Onr/DzMHzHXF61y//g ZQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bx4dx2ygq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 05:18:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 05:18:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 05:18:51 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B63E33F7065;
        Tue, 26 Oct 2021 05:18:48 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH v2 3/3] octeontx2-af: debugfs: Add channel and channel mask.
Date:   Tue, 26 Oct 2021 17:48:14 +0530
Message-ID: <20211026121814.27036-4-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211026121814.27036-1-rsaladi2@marvell.com>
References: <20211026121814.27036-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: dgTKcZ16MLSYZ_OkVjQWx9QP1WSYnfBA
X-Proofpoint-ORIG-GUID: dgTKcZ16MLSYZ_OkVjQWx9QP1WSYnfBA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to dispaly channel and channel_mask for each RX
interface of NPC MCAM rule.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h         | 4 ++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3144d309783c..77fd39e2c8db 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -8,6 +8,8 @@
 #ifndef NPC_H
 #define NPC_H
 
+#define NPC_KEX_CHAN_MASK	0xFFFULL
+
 enum NPC_LID_E {
 	NPC_LID_LA = 0,
 	NPC_LID_LB,
@@ -591,6 +593,8 @@ struct rvu_npc_mcam_rule {
 	u8 default_rule;
 	bool enable;
 	bool vfvlan_cfg;
+	u16 chan;
+	u16 chan_mask;
 };
 
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 205e5d203189..40196ead77c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2490,6 +2490,8 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 				seq_printf(s, "VF%d", vf);
 			}
 			seq_puts(s, "\n");
+			seq_printf(s, "\tchannel: 0x%x\n", iter->chan);
+			seq_printf(s, "\tchannel_mask: 0x%x\n", iter->chan_mask);
 		}
 
 		rvu_dbg_npc_mcam_show_action(s, iter);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 51ddc7b81d0b..ff2b21999f36 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1119,6 +1119,9 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	rule->default_rule = req->default_rule;
 	rule->owner = owner;
 	rule->enable = enable;
+	rule->chan_mask = write_req.entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
+	rule->chan = write_req.entry_data.kw[0] & NPC_KEX_CHAN_MASK;
+	rule->chan &= rule->chan_mask;
 	if (is_npc_intf_tx(req->intf))
 		rule->intf = pfvf->nix_tx_intf;
 	else
-- 
2.17.1

