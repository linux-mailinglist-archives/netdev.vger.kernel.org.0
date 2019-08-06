Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A488388A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfHFS2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:28:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbfHFS2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:28:21 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x76I8kmZ015609
        for <netdev@vger.kernel.org>; Tue, 6 Aug 2019 11:28:20 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u72sajq5f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:28:20 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Aug 2019 11:28:20 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 3C21325BBCB35; Tue,  6 Aug 2019 11:28:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <saeedm@mellanox.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH net-next] mlx5: use correct counter
Date:   Tue, 6 Aug 2019 11:28:19 -0700
Message-ID: <20190806182819.788750-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=804 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_grp_q_update_stats seems to be using the wrong counter
for if_down_packets.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6eee3c7d4b06..1d16e03a987d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -363,7 +363,7 @@ static void mlx5e_grp_q_update_stats(struct mlx5e_priv *priv)
 	    !mlx5_core_query_q_counter(priv->mdev, priv->drop_rq_q_counter, 0,
 				       out, sizeof(out)))
 		qcnt->rx_if_down_packets = MLX5_GET(query_q_counter_out, out,
-						    out_of_buffer);
+						    rx_if_down_packets);
 }
 
 #define VNIC_ENV_OFF(c) MLX5_BYTE_OFF(query_vnic_env_out, c)
-- 
2.17.1

