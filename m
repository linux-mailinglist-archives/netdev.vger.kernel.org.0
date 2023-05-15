Return-Path: <netdev+bounces-2606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 164E7702AFA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6E99280F79
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDA58BFA;
	Mon, 15 May 2023 10:59:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63D2F33
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:59:05 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4478693
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:59:02 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F9MMjf012992;
	Mon, 15 May 2023 03:58:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=k56xxObBmxGE4Pk+9XCvOwr3dyLK14PyGBYqfbsvptg=;
 b=Pes5VBqUymfnhlsAJ84J8LIaz0V6rmv9DNryTn2lkI4eRFqznPmWojzBIEYrjOhjRr1O
 v1U7aDEVyKQGy4ysP+ncK44xjLXpkBin6MW72zjE4rNsihovSpcq3LdAe8igdRDUzzvP
 BZKh5G4+Hv3jw39DWX5/xF5xqEq7D529rDA1ryxjVmhjHxGmcXDWSLO6C/6Ib1u99anW
 LnEsjFSFaiKp05BIu6LsOFuPR49dYuP0iZ1AH5FX+vIycthWNeKZJ1jZo4My0/+LfeJT
 IC4uk8/tzk1o5XVlvxso2E+Kn6QMqbmBJHKVWrSEGqZhupZvYK22ywHDD5BSEjZnwAE6 /w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qja2jmy71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 03:58:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 15 May
 2023 03:58:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 15 May 2023 03:58:52 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
	by maili.marvell.com (Postfix) with ESMTP id 26DBD3F705D;
	Mon, 15 May 2023 03:58:48 -0700 (PDT)
From: Subbaraya Sundeep <sbhatta@marvell.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC: <gakula@marvell.com>, <naveenm@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
        "Sunil
 Kovvuri Goutham" <sgoutham@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: mcs: Support VLAN in clear text
Date: Mon, 15 May 2023 16:28:46 +0530
Message-ID: <1684148326-29569-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Al4proaJC_avfqWJLfpinvk3kH_gd33Z
X-Proofpoint-ORIG-GUID: Al4proaJC_avfqWJLfpinvk3kH_gd33Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_08,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Detect whether macsec secy is running on top of VLAN
which implies transmitting VLAN tag in clear text before
macsec SecTag. In this case configure hardware to insert
SecTag after VLAN tag.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 7 +++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index b59532c..c5e6d57 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -426,8 +426,10 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
 	struct mcs_secy_plcy_write_req *req;
 	struct mbox *mbox = &pfvf->mbox;
 	struct macsec_tx_sc *sw_tx_sc;
-	/* Insert SecTag after 12 bytes (DA+SA)*/
-	u8 tag_offset = 12;
+	/* Insert SecTag after 12 bytes (DA+SA) or 16 bytes
+	 * if VLAN tag needs to be sent in clear text.
+	 */
+	u8 tag_offset = txsc->vlan_dev ? 16 : 12;
 	u8 sectag_tci = 0;
 	u64 policy;
 	u8 cipher;
@@ -1163,6 +1165,7 @@ static int cn10k_mdo_add_secy(struct macsec_context *ctx)
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


