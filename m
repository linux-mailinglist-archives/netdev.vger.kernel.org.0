Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B32439F2F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhJYTSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:18:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55130 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234021AbhJYTRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:17:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PIFPXp001259;
        Mon, 25 Oct 2021 12:15:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=x2KHYI46y1HmIizOKdm4wUpZd15UeW/0fqHFRoTzbaI=;
 b=RR3mu5YXeYpQm2Cc9aVMzeCUhKV68dhEJnrTrDgji1D/9oXGKLO8zbm3PSqgycF8pVhD
 lM/291hMM3HQJmY6EB4yhToTiDmga8N01Cz7CxZdGbVEqG9fNT/rvPxG89lPX2YXJcCx
 lMfedzwbnmiFBSjYjfsKbRUlLYaXc/jL5nQKpZ6suY+sCkMLWyxWfMJbpIWZqOlcJK1M
 yGKmfK2fS+obRz2XC9QjFTvBTmEZqss1RNJ/YSph7AOMQ0ZDA7uJiXvBtPQjIo4Vqtxj
 aHpCVUNZjqUmU0G3hToHxwPu99TV5AB43j6rW09Lfb4o2XM9nebVVavtLBuln7FqH0/a Ig== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bwtjrj8nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:15:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:15:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:15:25 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 7C6803F704A;
        Mon, 25 Oct 2021 12:15:22 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net-next PATCH 3/3] octeontx2-af: debugfs: Add channel and channel mask.
Date:   Tue, 26 Oct 2021 00:44:42 +0530
Message-ID: <20211025191442.10084-4-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211025191442.10084-1-rsaladi2@marvell.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: RTt_G6CxTh6FX2_LYtaAyfQJ99oPXbGZ
X-Proofpoint-GUID: RTt_G6CxTh6FX2_LYtaAyfQJ99oPXbGZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
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
index 7ff8f4045223..fb27bab33f3f 100644
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

