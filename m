Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094221FF8CF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbgFRQKI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731945AbgFRQKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG1stI013601
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:03 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31q660vyjx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:03 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:59 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 7A7CD3D44E158; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 21/21] mlx5: add XDP_SETUP_NETGPU hook
Date:   Thu, 18 Jun 2020 09:09:41 -0700
Message-ID: <20200618160941.879717-22-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 clxscore=1034 mlxscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 mlxlogscore=639 adultscore=0 impostorscore=0 malwarescore=0
 cotscore=-2147483648 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006180121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the hook which enables and disables the zero copy queues.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c791578be5ea..05f93f78ebbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4598,6 +4598,9 @@ static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_XSK_UMEM:
 		return mlx5e_xsk_setup_umem(dev, xdp->xsk.umem,
 					    xdp->xsk.queue_id);
+	case XDP_SETUP_NETGPU:
+		return mlx5e_netgpu_setup_ctx(dev, xdp->netgpu.ctx,
+					      xdp->netgpu.queue_id);
 	default:
 		return -EINVAL;
 	}
-- 
2.24.1

