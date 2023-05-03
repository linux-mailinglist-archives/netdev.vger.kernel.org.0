Return-Path: <netdev+bounces-80-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC356F50D2
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B924280F93
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A05D46B2;
	Wed,  3 May 2023 07:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEEC4A0E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:10:24 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8944E4227;
	Wed,  3 May 2023 00:10:20 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3436A4il003430;
	Wed, 3 May 2023 00:10:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=c3cSGBdd33u15K/8c9xWQAxDg4P0TadDZwx94vassMs=;
 b=Os04Qm33lUu9sprcuTfOqe110LksylE8pMgPmt77MGAe+6ZopDyN1PD6c1E6vumko6gB
 ObwnS9IO+Ezsnvc/xWYi72YCn/Cmlvh2Sv7ku0RL/WUQN8grplbeeBdCjGCGc5GQTTHc
 c6g0dFlqTXm45/DrPB+DJblQZ6T5CjunP2M+raGInJnc55T1J+VplzDVcTqv1sKdRyLn
 JzJMsqqJOuP5IvYJcpmPKcNAS4tAtswGdwvOwdYu8PhdNpAFing10a48R6pDw22GZ3tg
 3Y6oO+95hOG+4ZwMfuofpV0N7NOdFak4H782Rj+ijiTGDkpzJp7ugXU8kkgPX8pXgTW1 CA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q92rp3m7m-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 00:10:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 3 May
 2023 00:10:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 3 May 2023 00:10:10 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
	by maili.marvell.com (Postfix) with ESMTP id 51B7A3F70EE;
	Wed,  3 May 2023 00:10:06 -0700 (PDT)
From: Sai Krishna <saikrishnag@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC: Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna
	<saikrishnag@marvell.com>
Subject: [net PATCH v5 04/11] octeontx2-pf: Increase the size of dmac filter flows
Date: Wed, 3 May 2023 12:39:37 +0530
Message-ID: <20230503070944.960190-5-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230503070944.960190-1-saikrishnag@marvell.com>
References: <20230503070944.960190-1-saikrishnag@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0O9sNZLQwZP1zBipVk47tyB6O5_zm8n9
X-Proofpoint-GUID: 0O9sNZLQwZP1zBipVk47tyB6O5_zm8n9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_04,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Ratheesh Kannoth <rkannoth@marvell.com>

CN10kb supports large number of dmac filter flows to be
inserted. Increase the field size to accommodate the same

Fixes: b747923afff8 ("octeontx2-af: Exact match support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index f42b2b65bfd7..0c8fc66ade82 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -335,11 +335,11 @@ struct otx2_flow_config {
 #define OTX2_PER_VF_VLAN_FLOWS	2 /* Rx + Tx per VF */
 #define OTX2_VF_VLAN_RX_INDEX	0
 #define OTX2_VF_VLAN_TX_INDEX	1
-	u16			max_flows;
-	u8			dmacflt_max_flows;
 	u32			*bmap_to_dmacindex;
 	unsigned long		*dmacflt_bmap;
 	struct list_head	flow_list;
+	u32			dmacflt_max_flows;
+	u16                     max_flows;
 };
 
 struct otx2_tc_info {
-- 
2.25.1


