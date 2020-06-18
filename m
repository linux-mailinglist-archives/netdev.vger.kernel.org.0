Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371261FF8C7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbgFRQJw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:09:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729057AbgFRQJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:50 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05IG7bhp013412
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:49 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31q644vse3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:49 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 5B1CD3D44E148; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 13/21] netdevice: add SETUP_NETGPU to the netdev_bpf structure
Date:   Thu, 18 Jun 2020 09:09:33 -0700
Message-ID: <20200618160941.879717-14-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 cotscore=-2147483648 suspectscore=3 adultscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=609 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This command will be used to setup/tear down netgpu queues.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6fc613ed8eae..ea3c15ef0f29 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -880,6 +880,7 @@ enum bpf_netdev_command {
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
 	XDP_SETUP_XSK_UMEM,
+	XDP_SETUP_NETGPU,
 };
 
 struct bpf_prog_offload_ops;
@@ -911,6 +912,11 @@ struct netdev_bpf {
 			struct xdp_umem *umem;
 			u16 queue_id;
 		} xsk;
+		/* XDP_SETUP_NETGPU */
+		struct {
+			struct netgpu_ctx *ctx;
+			u16 queue_id;
+		} netgpu;
 	};
 };
 
-- 
2.24.1

