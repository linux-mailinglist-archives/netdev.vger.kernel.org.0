Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D1B33F147
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhCQNg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:36:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32526 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231319AbhCQNgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:36:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HDQChO006923;
        Wed, 17 Mar 2021 06:36:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zB6eTJUWL178xs2K+6wZHEaibom7pg++pbf4JFKlwo8=;
 b=elucLP/CuESy9Af9UUX+gVroGL8dfoBw9yIyIwRXvspLsZlHfGxCrfzpyeAKLF4tXuat
 AdJsU77r9NuR1FyvJ4owONgC+yXGcIwU5540u0hhcdxVTx8J5MSThWNnnJ8wc4e2uBrc
 g76s2O3y6LGNfw7TQ1BtFYzttfY6WDYrwVuCiiJa5SNmg8qv8DZZHeTxJyBXEGLQF5zy
 +8nm5cqoAhxGo37LIFyEdlKUsQdkwVX0Y+bcMhLfAatHkNnUGxY4/uIUIluFHR/aOmKJ
 mRqQ4ADi/fivXjcIdFbnjYl844DvIFYgobD9RzQ03wZlTscDJcl85ENVcyy+xLQ1vOXF PQ== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqvf4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 06:36:05 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Mar 2021 09:36:03 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Mar 2021 09:36:03 -0400
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 68D9B3F7044;
        Wed, 17 Mar 2021 06:36:00 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 5/5] octeontx2-af: Modify the return code for unsupported flow keys
Date:   Wed, 17 Mar 2021 19:05:38 +0530
Message-ID: <20210317133538.15609-6-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210317133538.15609-1-naveenm@marvell.com>
References: <20210317133538.15609-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_07:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mbox handler npc_install_flow returns ENOTSUPP for unsupported
flow keys. This patch modifies the return value to AF driver defined
error code for debugging purpose.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h       | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 1dca2ca115c7..46f919625464 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -605,6 +605,7 @@ enum nix_af_status {
 	NIX_AF_INVAL_SSO_PF_FUNC    = -420,
 	NIX_AF_ERR_TX_VTAG_NOSPC    = -421,
 	NIX_AF_ERR_RX_VTAG_INUSE    = -422,
+	NIX_AF_ERR_NPC_KEY_NOT_SUPP = -423,
 };
 
 /* For NIX RX vtag action  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index a31b46d65cc5..d805a189a268 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -597,7 +597,7 @@ static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
 		dev_info(rvu->dev, "Unsupported flow(s):\n");
 		for_each_set_bit(bit, (unsigned long *)&unsupported, 64)
 			dev_info(rvu->dev, "%s ", npc_get_field_name(bit));
-		return -EOPNOTSUPP;
+		return NIX_AF_ERR_NPC_KEY_NOT_SUPP;
 	}
 
 	return 0;
@@ -1143,8 +1143,9 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (!is_pffunc_af(req->hdr.pcifunc))
 		req->chan_mask = 0xFFF;
 
-	if (npc_check_unsupported_flows(rvu, req->features, req->intf))
-		return -EOPNOTSUPP;
+	err = npc_check_unsupported_flows(rvu, req->features, req->intf);
+	if (err)
+		return err;
 
 	if (npc_mcam_verify_channel(rvu, target, req->intf, req->channel))
 		return -EINVAL;
-- 
2.16.5

