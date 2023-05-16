Return-Path: <netdev+bounces-2976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CED4704C86
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 127571C20BAC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E46F24EA7;
	Tue, 16 May 2023 11:40:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208734CEB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:40:44 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43362D4C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:40:43 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34G7CKCb020489;
	Tue, 16 May 2023 04:40:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=trVaEcEBAWCwREmjSGgh1hnmTuilXS9fBzjNfNgKoYs=;
 b=KBiuWHwMqd/qsxXWn1xvBzujGak3ZJiMmAujcwKS7JV3hj/O8uS5lRhuBe148puuLjeC
 BSHWRrkG2BCYpqqpBf/kGYQ98BMA8sMVI98xp9qGtVykD3GWdM2wJW+zX3mUOuzjtFG7
 FqQrDbGJ79uEtbi9S8S0S+3GTa26s2YfYz60LYodxeUDM38tFaorQwKj13/yb7eAOFU0
 Y5O+nIkbqQSzDPv+rEtycB1ffHG41DwsqmEWRn8Th3vDQi83UgwT1XDxteGdGyuVXgAZ
 f+bh8VlFW9AZMA4L56lI0uwSS07t3g+HaJ7ieLChTQi9g75N9INTB0vwW0FecsRdmWLX hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qkvbmk1yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 04:40:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 16 May
 2023 04:40:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 16 May 2023 04:40:36 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
	by maili.marvell.com (Postfix) with ESMTP id 028133F7074;
	Tue, 16 May 2023 04:40:32 -0700 (PDT)
From: Subbaraya Sundeep <sbhatta@marvell.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC: <gakula@marvell.com>, <naveenm@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
        "Sunil
 Kovvuri Goutham" <sgoutham@marvell.com>
Subject: [net-next PATCH v2] octeontx2-pf: mcs: Support VLAN in clear text
Date: Tue, 16 May 2023 17:10:31 +0530
Message-ID: <1684237231-14217-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 798Qp_m7qRs-nAWaZe3NJ_lZg88gCAqE
X-Proofpoint-ORIG-GUID: 798Qp_m7qRs-nAWaZe3NJ_lZg88gCAqE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_04,2023-05-16_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Detect whether macsec secy is running on top of VLAN
which implies transmitting VLAN tag in clear text before
macsec SecTag. In this case configure hardware to insert
SecTag after VLAN tag.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v2:
 Arranged variable tag_offset in reverse christmas tree order

 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 8 ++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index b59532c..6e2fb24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -426,13 +426,16 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
 	struct mcs_secy_plcy_write_req *req;
 	struct mbox *mbox = &pfvf->mbox;
 	struct macsec_tx_sc *sw_tx_sc;
-	/* Insert SecTag after 12 bytes (DA+SA)*/
-	u8 tag_offset = 12;
 	u8 sectag_tci = 0;
+	u8 tag_offset;
 	u64 policy;
 	u8 cipher;
 	int ret;
 
+	/* Insert SecTag after 12 bytes (DA+SA) or 16 bytes
+	 * if VLAN tag needs to be sent in clear text.
+	 */
+	tag_offset = txsc->vlan_dev ? 16 : 12;
 	sw_tx_sc = &secy->tx_sc;
 
 	mutex_lock(&mbox->lock);
@@ -1163,6 +1166,7 @@ static int cn10k_mdo_add_secy(struct macsec_context *ctx)
 	txsc->encoding_sa = secy->tx_sc.encoding_sa;
 	txsc->last_validate_frames = secy->validate_frames;
 	txsc->last_replay_protect = secy->replay_protect;
+	txsc->vlan_dev = is_vlan_dev(ctx->netdev);
 
 	list_add(&txsc->entry, &cfg->txsc_list);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 0f2b2a9..b2267c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -419,6 +419,7 @@ struct cn10k_mcs_txsc {
 	u8 encoding_sa;
 	u8 salt[CN10K_MCS_SA_PER_SC][MACSEC_SALT_LEN];
 	ssci_t ssci[CN10K_MCS_SA_PER_SC];
+	bool vlan_dev; /* macsec running on VLAN ? */
 };
 
 struct cn10k_mcs_rxsc {
-- 
2.7.4


