Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18193EE5CF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhHQEqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:46:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50502 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237753AbhHQEqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:46:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lpri006897;
        Mon, 16 Aug 2021 21:45:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8OqO2N5MJl3DjxRITkvRf5Rlh6jbiNg9ftdV8SCEeDA=;
 b=Eu7jHHUCZoHQdIe4QnwWleU6v7t4NwMNlGdraRyAveOqkb+vHaigss36UqYrQTdDIuaH
 0/VzZIFnaS7oCtzre6F8wda+sk0gZhDyur+yxlIzfc7AG3Q8m1nClMnKzqm+4LhM+mcD
 G5eprc+wd4a9u7uwnroXpDBIQOg0ALyNyLAb4U/5IufVmF47AW5J7mqlxBQl+6LXaffW
 J9QqTbnRa/nTXPlv3eYuIDzcZAm0tlJlJTd52dkN1yl9P35w5LkAJ34i7kpOUL9IecTz
 lh2QxXng4kfLPwLS10n0oi1Dsz51sTTviK+QpX8FD9brvZVb3+xOu+Gs6pJSqyr9Qf6l 6Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:29 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 36E613F70AD;
        Mon, 16 Aug 2021 21:45:26 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Vidya <vvelumuri@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 11/11] octeontx2-af: configure npc for cn10k to allow packets from cpt
Date:   Tue, 17 Aug 2021 10:14:53 +0530
Message-ID: <1629175493-4895-12-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8cAM3xHwSLQK8PzxXd2R7BHDj_eRiIMO
X-Proofpoint-ORIG-GUID: 8cAM3xHwSLQK8PzxXd2R7BHDj_eRiIMO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vidya <vvelumuri@marvell.com>

On CN10K, the higher bits in the channel number represents the CPT
channel number. Mask out these higher bits in the npc configuration
to allow packets from cpt for parsing.

Signed-off-by: Vidya <vvelumuri@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 504dfa5..6f23100 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -724,7 +724,17 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 		action.index = pfvf->promisc_mce_idx;
 	}
 
-	req.chan_mask = 0xFFFU;
+	/* For cn10k the upper two bits of the channel number are
+	 * cpt channel number. with masking out these bits in the
+	 * mcam entry, same entry used for NIX will allow packets
+	 * received from cpt for parsing.
+	 */
+	if (!is_rvu_otx2(rvu)) {
+		req.chan_mask = NIX_CHAN_CPT_X2P_MASK;
+	} else {
+		req.chan_mask = 0xFFFU;
+	}
+
 	if (chan_cnt > 1) {
 		if (!is_power_of_2(chan_cnt)) {
 			dev_err(rvu->dev,
-- 
2.7.4

