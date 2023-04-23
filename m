Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4EC6EBE67
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjDWJ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjDWJ4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:56:25 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BF273A;
        Sun, 23 Apr 2023 02:55:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N4iPJW009043;
        Sun, 23 Apr 2023 02:55:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rWYnN6oOOSKQumjx6Xkd4ZNAgEqtsYFhL4sV/ZNKiwM=;
 b=Xl0MGaEq0ToDfVhnDTg6OvBCL7Xy2qODJkKWC01gVo1hp2Q0nM+vzh+IAEim7uTkSmdX
 sfdqE4XKy47KaL8/ttU6uHxtde7VIixD13s4o85jpqpYSmlZmj49sfpbcU2/Eh8GaOKP
 Xd3FgKOdyW/5dFLr73ZPwwsEE7mwSQF1MtoghlXte6cvAsZLOLtnDLOhhcNoAtge1KJB
 drgFVIvKE8/JSjxSp5Dye68ADcFuNYY5HiLaYrmK7tQ5hwrw1qE5rY+O8fHw1dm42daB
 hfsIlBTv1qheIaPVXn3eX+9MWvetupxC17Ee9sTgZ8LrYB6i95L96EPQefA2ld8I+kkZ 5w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:34 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 85B1E3F706A;
        Sun, 23 Apr 2023 02:55:30 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 9/9] octeontx2-pf: mcs: Do not reset PN while updating secy
Date:   Sun, 23 Apr 2023 15:24:54 +0530
Message-ID: <20230423095454.21049-10-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4BHql2XAa2T1xiVf7I1SLr7PFsiTds_i
X-Proofpoint-GUID: 4BHql2XAa2T1xiVf7I1SLr7PFsiTds_i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

After creating SecYs, SCs and SAs a SecY can be modified
to change attributes like validation mode, protect frames
mode etc. During this SecY update, packet number is reset to
initial user given value by mistake. Hence do not reset
PN when updating SecY parameters.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 0ef44faa1ee8..9ef70980f786 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1137,6 +1137,7 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 	struct macsec_secy *secy = ctx->secy;
 	struct macsec_tx_sa *sw_tx_sa;
 	struct cn10k_mcs_txsc *txsc;
+	bool active;
 	u8 sa_num;
 	int err;
 
@@ -1144,15 +1145,19 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 	if (!txsc)
 		return -ENOENT;
 
-	txsc->encoding_sa = secy->tx_sc.encoding_sa;
-
-	sa_num = txsc->encoding_sa;
-	sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+	/* Encoding SA got changed */
+	if (txsc->encoding_sa != secy->tx_sc.encoding_sa) {
+		txsc->encoding_sa = secy->tx_sc.encoding_sa;
+		sa_num = txsc->encoding_sa;
+		sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+		active = sw_tx_sa ? sw_tx_sa->active : false;
+		cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc, sa_num, active);
+	}
 
 	if (netif_running(secy->netdev)) {
 		cn10k_mcs_sync_stats(pfvf, secy, txsc);
 
-		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, sw_tx_sa, sa_num);
+		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, NULL, 0);
 		if (err)
 			return err;
 	}
-- 
2.25.1

