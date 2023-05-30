Return-Path: <netdev+bounces-6411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA99716362
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33D071C20BF1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED68021094;
	Tue, 30 May 2023 14:14:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAE921083
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:14:08 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1E1118;
	Tue, 30 May 2023 07:13:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCiCoE012781;
	Tue, 30 May 2023 14:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AZtoqKgahSWJ6g/3Z96owHtQnsAiBOwZ/kF6K43u7AI=;
 b=E6hufbc4iRnr/7JobblZyKiuQtEQKYTVmSwqYWL5DPOwm6y4TgOs+2Wlikcu45Fc7cSe
 y2rJpote6G9Y82wo2jn9Ux20Mzdvl40F6903PFO8x9G7I+mNLip9N+krZVr6jB6PltzF
 rzqhxdsAbMtfFaFpy7jFMw0PHr9AS917047kBwe3r+ofeWG92X2R4o+wroOQ23YFE7Vb
 6dlyCIWP2aZVZkCzQj6iJQG40tdM+bHNrnqDbUW50XNvHvZ1iM73sAdkx5CGs8Cd3hSo
 pREsDfwEbp8K/2MI+pReW2EUGGQCd0MlbaSwFsb3MuiWuNSDGYC4C+xriu3X4rEdAXCn 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwhdeanqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 14:13:10 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UE84oT004235;
	Tue, 30 May 2023 14:13:09 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwhdeanq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 14:13:09 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U9agtV021188;
	Tue, 30 May 2023 14:13:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qu9g519bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 14:13:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UED5aP22282948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 14:13:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4642820040;
	Tue, 30 May 2023 14:13:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F138A2004F;
	Tue, 30 May 2023 14:13:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 May 2023 14:13:04 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net] net/mlx5: Fix setting of irq->map.index for static IRQ case
Date: Tue, 30 May 2023 16:13:04 +0200
Message-Id: <20230530141304.1850195-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PpH9Jwcn3GEH2oLKFKX4J00puGn9yG1P
X-Proofpoint-GUID: -TmNF_qtAEjvWc7ImQDTjOEO__qkDZai
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_10,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 clxscore=1011 impostorscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When dynamic IRQ allocation is not supported all IRQs are allocated up
front in mlx5_irq_table_create() instead of dynamically as part of
mlx5_irq_alloc(). In the latter dynamic case irq->map.index is set
via the mapping returned by pci_msix_alloc_irq_at(). In the static case
and prior to commit 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
irq->map.index was set in mlx4_irq_alloc() twice once initially to 0 and
then to the requested index before storing in the xarray. After this
commit it is only set to 0 which breaks all other IRQ mappins.

Fix this by setting irq->map.index to the requested index together with
irq->map.virq and improve the related comment to make it clearer which
cases it deals with.

Fixes: 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index db5687d9fec9..fd5b43e8f3bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -232,12 +232,13 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 	if (!i || !pci_msix_can_alloc_dyn(dev->pdev)) {
-		/* The vector at index 0 was already allocated.
-		 * Just get the irq number. If dynamic irq is not supported
-		 * vectors have also been allocated.
+		/* The vector at index 0 is always statically allocated. If
+		 * dynamic irq is not supported all vectors are statically
+		 * allocated. In both cases just get the irq number and set
+		 * the index.
 		 */
 		irq->map.virq = pci_irq_vector(dev->pdev, i);
-		irq->map.index = 0;
+		irq->map.index = i;
 	} else {
 		irq->map = pci_msix_alloc_irq_at(dev->pdev, MSI_ANY_INDEX, af_desc);
 		if (!irq->map.virq) {
-- 
2.39.2


