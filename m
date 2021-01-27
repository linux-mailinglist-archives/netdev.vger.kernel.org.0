Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2339D305516
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhA0HzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:55:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48756 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229739AbhA0Hrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:47:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10R7eAhD007630;
        Tue, 26 Jan 2021 23:46:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=b7xhoi28+9w/ILTDolXNdBJFU/uuf1HPxZ/4/WVauMc=;
 b=AvkLpJ9vHso/H3Y5NgnCIpCc9lUMAfrPf6kIBvTEkDjId5hr92miNMh0eAa3ZriefbWc
 xc1Wvk1OwBlA2/ENZDlFZ1MGfY4TTZ1OnjdDBDpfzv6wL6S0ZRynGTRt7iZlh1Zk3EG8
 qdlBA8mDGhYo9+VsXd0MBpkKQfMYTFZO5m9nuGpag/Lgv3gFt+bB15bjigKilQwL9Qez
 bYiEyDh7T7srj7wafl6Uwskng0uR/Q5I0haQw8NxQ/gupc9pu7Upi3Yqx3Q9Y4inhNVP
 LJst/tsOt+Mu2kKT6UHGoE01jFrukBAJ6PO/8tlZPja+CFf19UmiAJCpU10MyOy7Z3RY Mg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xpg9q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jan 2021 23:46:58 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jan
 2021 23:46:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jan
 2021 23:46:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jan 2021 23:46:56 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id D95673F7040;
        Tue, 26 Jan 2021 23:46:52 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [Patch v2 net-next 7/7] octeontx2-pf: ethtool physical link configuration
Date:   Wed, 27 Jan 2021 13:15:52 +0530
Message-ID: <1611733552-150419-8-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_03:2021-01-26,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

Register set_link_ksetting callback with driver such that
link configurations parameters like advertised mode,speed, duplex
and autoneg can be configured.

below command
ethtool -s eth0 advertise 0x1 speed 10 duplex full autoneg on

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 53 ++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index b99f4bb..395a00d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1178,6 +1178,58 @@ static int otx2_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
+static int otx2_set_link_ksettings(struct net_device *netdev,
+				   const struct ethtool_link_ksettings *cmd)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct ethtool_link_ksettings req_ks;
+	struct ethtool_link_ksettings cur_ks;
+	struct cgx_set_link_mode_req *req;
+	struct mbox *mbox = &pf->mbox;
+	int err = 0;
+
+	/* save requested link settings */
+	memcpy(&req_ks, cmd, sizeof(struct ethtool_link_ksettings));
+
+	memset(&cur_ks, 0, sizeof(struct ethtool_link_ksettings));
+
+	if (!ethtool_validate_speed(cmd->base.speed) ||
+	    !ethtool_validate_duplex(cmd->base.duplex))
+		return -EINVAL;
+
+	if (cmd->base.autoneg != AUTONEG_ENABLE &&
+	    cmd->base.autoneg != AUTONEG_DISABLE)
+		return -EINVAL;
+
+	otx2_get_link_ksettings(netdev, &cur_ks);
+
+	/* Check requested modes against supported modes by hardware */
+	if (!bitmap_subset(req_ks.link_modes.advertising,
+			   cur_ks.link_modes.supported,
+			   __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return -EINVAL;
+
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_cgx_set_link_mode(&pf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto end;
+	}
+
+	req->args.speed = req_ks.base.speed;
+	/* firmware expects 1 for half duplex and 0 for full duplex
+	 * hence inverting
+	 */
+	req->args.duplex = req_ks.base.duplex ^ 0x1;
+	req->args.an =  req_ks.base.autoneg;
+	req->args.mode   = *req_ks.link_modes.advertising;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+end:
+	mutex_unlock(&mbox->lock);
+	return err;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -1208,6 +1260,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_fecparam		= otx2_get_fecparam,
 	.set_fecparam		= otx2_set_fecparam,
 	.get_link_ksettings     = otx2_get_link_ksettings,
+	.set_link_ksettings     = otx2_set_link_ksettings,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
-- 
2.7.4

