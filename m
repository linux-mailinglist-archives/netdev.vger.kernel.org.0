Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B41F2A7A7D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgKEJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:29:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23368 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731348AbgKEJ3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:29:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A59PwNC011455;
        Thu, 5 Nov 2020 01:28:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ie5C+32mO3H94OyjnKwnEWwy+9pk6g2Q4eF3/nLPXBk=;
 b=NtNsStw/ApVyRtbpejvVsRvUYxtg60bnnmHyxDVolVimS7hS24cV0/ADmVlBv7sB1nh9
 ZTLDP64/CrcfRBG/SY8fCSReOIeATarQGJUXS9E89ppxOXsqRLpTr3GtStsILBJuKiNV
 QGyn1x/jUyWt5zDaiwR6XLVUZE6jtJlp3EPGA26TjWNsccPOqAZrpJULF8aWx6eLjFrK
 YqdPc1mT5eGTXqiw4fSdbQ7OAn3b1UWRkfBQiL8FYwLTVYvM/qYxfgiKJgPjfmwybDQd
 aCg5Cg0kMlzUDMZ9cDwhYRMTtZQh4RH1bbmkWxIJf1tdNfnlXb31HqaK1NmSWKRf94fk Xw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34mbfcrr9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 01:28:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Nov
 2020 01:28:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 Nov 2020 01:28:55 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 3F1193F703F;
        Thu,  5 Nov 2020 01:28:52 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH v2 net-next 07/13] octeontx2-af: Add debugfs entry to dump the MCAM rules
Date:   Thu, 5 Nov 2020 14:58:10 +0530
Message-ID: <20201105092816.819-8-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201105092816.819-1-naveenm@marvell.com>
References: <20201105092816.819-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_05:2020-11-05,2020-11-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Add debugfs support to dump the MCAM rules installed using
NPC_INSTALL_FLOW mbox message. Debugfs file can display mcam
entry, counter if any, flow type and counter hits.

Ethtool will dump the ntuple flows related to the PF only.
The debugfs file gives systemwide view of the MCAM rules
installed by all the PF's.

Below is the example output when the debugfs file is read:
~ # mount -t debugfs none /sys/kernel/debug
~ # cat /sys/kernel/debug/octeontx2/npc/mcam_rules

	Installed by: PF1
	direction: RX
        mcam entry: 227
	udp source port 23 mask 0xffff
	Forward to: PF1 VF0
        action: Direct to queue 0
	enabled: yes
        counter: 1
        hits: 0

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 197 +++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index b7b6b6f8865a..39e1a614aaf8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1770,6 +1770,198 @@ static int rvu_dbg_npc_rx_miss_stats_display(struct seq_file *filp,
 
 RVU_DEBUG_SEQ_FOPS(npc_rx_miss_act, npc_rx_miss_stats_display, NULL);
 
+static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
+					struct rvu_npc_mcam_rule *rule)
+{
+	u8 bit;
+
+	for_each_set_bit(bit, (unsigned long *)&rule->features, 64) {
+		seq_printf(s, "\t%s  ", npc_get_field_name(bit));
+		switch (bit) {
+		case NPC_DMAC:
+			seq_printf(s, "%pM ", rule->packet.dmac);
+			seq_printf(s, "mask %pM\n", rule->mask.dmac);
+			break;
+		case NPC_SMAC:
+			seq_printf(s, "%pM ", rule->packet.smac);
+			seq_printf(s, "mask %pM\n", rule->mask.smac);
+			break;
+		case NPC_ETYPE:
+			seq_printf(s, "0x%x ", ntohs(rule->packet.etype));
+			seq_printf(s, "mask 0x%x\n", ntohs(rule->mask.etype));
+			break;
+		case NPC_OUTER_VID:
+			seq_printf(s, "%d ", ntohs(rule->packet.vlan_tci));
+			seq_printf(s, "mask 0x%x\n",
+				   ntohs(rule->mask.vlan_tci));
+			break;
+		case NPC_TOS:
+			seq_printf(s, "%d ", rule->packet.tos);
+			seq_printf(s, "mask 0x%x\n", rule->mask.tos);
+			break;
+		case NPC_SIP_IPV4:
+			seq_printf(s, "%pI4 ", &rule->packet.ip4src);
+			seq_printf(s, "mask %pI4\n", &rule->mask.ip4src);
+			break;
+		case NPC_DIP_IPV4:
+			seq_printf(s, "%pI4 ", &rule->packet.ip4dst);
+			seq_printf(s, "mask %pI4\n", &rule->mask.ip4dst);
+			break;
+		case NPC_SIP_IPV6:
+			seq_printf(s, "%pI6 ", rule->packet.ip6src);
+			seq_printf(s, "mask %pI6\n", rule->mask.ip6src);
+			break;
+		case NPC_DIP_IPV6:
+			seq_printf(s, "%pI6 ", rule->packet.ip6dst);
+			seq_printf(s, "mask %pI6\n", rule->mask.ip6dst);
+			break;
+		case NPC_SPORT_TCP:
+		case NPC_SPORT_UDP:
+		case NPC_SPORT_SCTP:
+			seq_printf(s, "%d ", ntohs(rule->packet.sport));
+			seq_printf(s, "mask 0x%x\n", ntohs(rule->mask.sport));
+			break;
+		case NPC_DPORT_TCP:
+		case NPC_DPORT_UDP:
+		case NPC_DPORT_SCTP:
+			seq_printf(s, "%d ", ntohs(rule->packet.dport));
+			seq_printf(s, "mask 0x%x\n", ntohs(rule->mask.dport));
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void rvu_dbg_npc_mcam_show_action(struct seq_file *s,
+					 struct rvu_npc_mcam_rule *rule)
+{
+	if (rule->intf == NIX_INTF_TX) {
+		switch (rule->tx_action.op) {
+		case NIX_TX_ACTIONOP_DROP:
+			seq_puts(s, "\taction: Drop\n");
+			break;
+		case NIX_TX_ACTIONOP_UCAST_DEFAULT:
+			seq_puts(s, "\taction: Unicast to default channel\n");
+			break;
+		case NIX_TX_ACTIONOP_UCAST_CHAN:
+			seq_printf(s, "\taction: Unicast to channel %d\n",
+				   rule->tx_action.index);
+			break;
+		case NIX_TX_ACTIONOP_MCAST:
+			seq_puts(s, "\taction: Multicast\n");
+			break;
+		case NIX_TX_ACTIONOP_DROP_VIOL:
+			seq_puts(s, "\taction: Lockdown Violation Drop\n");
+			break;
+		default:
+			break;
+		};
+	} else {
+		switch (rule->rx_action.op) {
+		case NIX_RX_ACTIONOP_DROP:
+			seq_puts(s, "\taction: Drop\n");
+			break;
+		case NIX_RX_ACTIONOP_UCAST:
+			seq_printf(s, "\taction: Direct to queue %d\n",
+				   rule->rx_action.index);
+			break;
+		case NIX_RX_ACTIONOP_RSS:
+			seq_puts(s, "\taction: RSS\n");
+			break;
+		case NIX_RX_ACTIONOP_UCAST_IPSEC:
+			seq_puts(s, "\taction: Unicast ipsec\n");
+			break;
+		case NIX_RX_ACTIONOP_MCAST:
+			seq_puts(s, "\taction: Multicast\n");
+			break;
+		default:
+			break;
+		};
+	}
+}
+
+static const char *rvu_dbg_get_intf_name(int intf)
+{
+	switch (intf) {
+	case NIX_INTFX_RX(0):
+		return "NIX0_RX";
+	case NIX_INTFX_RX(1):
+		return "NIX1_RX";
+	case NIX_INTFX_TX(0):
+		return "NIX0_TX";
+	case NIX_INTFX_TX(1):
+		return "NIX1_TX";
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
+static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
+{
+	struct rvu_npc_mcam_rule *iter;
+	struct rvu *rvu = s->private;
+	struct npc_mcam *mcam;
+	int pf, vf = -1;
+	int blkaddr;
+	u16 target;
+	u64 hits;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return 0;
+
+	mcam = &rvu->hw->mcam;
+
+	mutex_lock(&mcam->lock);
+	list_for_each_entry(iter, &mcam->mcam_rules, list) {
+		pf = (iter->owner >> RVU_PFVF_PF_SHIFT) & RVU_PFVF_PF_MASK;
+		seq_printf(s, "\n\tInstalled by: PF%d ", pf);
+
+		if (iter->owner & RVU_PFVF_FUNC_MASK) {
+			vf = (iter->owner & RVU_PFVF_FUNC_MASK) - 1;
+			seq_printf(s, "VF%d", vf);
+		}
+		seq_puts(s, "\n");
+
+		seq_printf(s, "\tdirection: %s\n", is_npc_intf_rx(iter->intf) ?
+						    "RX" : "TX");
+		seq_printf(s, "\tinterface: %s\n",
+			   rvu_dbg_get_intf_name(iter->intf));
+		seq_printf(s, "\tmcam entry: %d\n", iter->entry);
+
+		rvu_dbg_npc_mcam_show_flows(s, iter);
+		if (iter->intf == NIX_INTF_RX) {
+			target = iter->rx_action.pf_func;
+			pf = (target >> RVU_PFVF_PF_SHIFT) & RVU_PFVF_PF_MASK;
+			seq_printf(s, "\tForward to: PF%d ", pf);
+
+			if (target & RVU_PFVF_FUNC_MASK) {
+				vf = (target & RVU_PFVF_FUNC_MASK) - 1;
+				seq_printf(s, "VF%d", vf);
+			}
+			seq_puts(s, "\n");
+		}
+
+		rvu_dbg_npc_mcam_show_action(s, iter);
+		seq_printf(s, "\tenabled: %s\n", iter->enable ? "yes" : "no");
+
+		if (!iter->has_cntr)
+			continue;
+		seq_printf(s, "\tcounter: %d\n", iter->cntr);
+
+		hits = rvu_read64(rvu, blkaddr, NPC_AF_MATCH_STATX(iter->cntr));
+		seq_printf(s, "\thits: %lld\n", hits);
+	}
+	mutex_unlock(&mcam->lock);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(npc_mcam_rules, npc_mcam_show_rules, NULL);
+
 static void rvu_dbg_npc_init(struct rvu *rvu)
 {
 	const struct device *dev = &rvu->pdev->dev;
@@ -1784,6 +1976,11 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 	if (!pfile)
 		goto create_failed;
 
+	pfile = debugfs_create_file("mcam_rules", 0444, rvu->rvu_dbg.npc,
+				    rvu, &rvu_dbg_npc_mcam_rules_fops);
+	if (!pfile)
+		goto create_failed;
+
 	pfile = debugfs_create_file("rx_miss_act_stats", 0444, rvu->rvu_dbg.npc,
 				    rvu, &rvu_dbg_npc_rx_miss_act_fops);
 	if (!pfile)
-- 
2.16.5

