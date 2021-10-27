Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E5C43D052
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243450AbhJ0SLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:11:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243449AbhJ0SLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:11:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFH24T032380;
        Wed, 27 Oct 2021 11:08:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=du1rK0R2FFRRVnHVWNMs5DMFsYbg7ez6Svrn+E5nTi8=;
 b=eTb08ecY7o4dnltuV4eEMAcnLhcE1jz2+GFAi/wvuONcRs+j1qHFk4tLhTJ0p9z4ZYvy
 DksUFzvRpuRPNi0yvGBNEdYidvcnwY5TUts+vBSakIurkQq/Gf3sV2rBcODSWT0b5+T3
 FGJZve8b34XfY1wg9wxLDQV67T0H+kJqA5yeM9OznECSuBBHDEN1qcuZHptQS2Wz83Uo
 HUcTb0XnXMh1Psvth5fBt6z1fEgBVygdwNC8luZxq8yzXj9GJic43spaWCLv9VFCtGDY
 gj/Kij1MBUsTMTiNjwXoknjLbghrHyZXB6aamj4GEw2n8we9yUK8z+v085qetq8vYG29 6Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1caausf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 11:08:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 11:08:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 11:08:46 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 7B4043F706D;
        Wed, 27 Oct 2021 11:08:44 -0700 (PDT)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH v3 3/3] octeontx2-af: debugfs: Add channel and channel mask.
Date:   Wed, 27 Oct 2021 23:37:45 +0530
Message-ID: <20211027180745.27947-4-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211027180745.27947-1-rsaladi2@marvell.com>
References: <20211027180745.27947-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: SvSMsu_eBwAwbJOXZ2KiqNDiCXzl5OFF
X-Proofpoint-ORIG-GUID: SvSMsu_eBwAwbJOXZ2KiqNDiCXzl5OFF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

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
index 62dd9d723bc8..94d479010410 100644
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

