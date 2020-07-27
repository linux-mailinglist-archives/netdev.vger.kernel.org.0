Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F81C22FC5F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgG0Woz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgG0Wow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:52 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfs9U003723
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4ed6t0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:50 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id CB6DA3FAB6F67; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 07/21] netdevice: add SETUP_NETGPU to the netdev_bpf structure
Date:   Mon, 27 Jul 2020 15:44:30 -0700
Message-ID: <20200727224444.2987641-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1034
 suspectscore=3 mlxlogscore=675 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

This command will be used to setup/tear down netgpu queues.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ac2cd3f49aba..df72c762e562 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -882,6 +882,7 @@ enum bpf_netdev_command {
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
 	XDP_SETUP_XSK_UMEM,
+	XDP_SETUP_NETGPU,
 };
 
 struct bpf_prog_offload_ops;
@@ -913,6 +914,11 @@ struct netdev_bpf {
 			struct xdp_umem *umem;
 			u16 queue_id;
 		} xsk;
+		/* XDP_SETUP_NETGPU */
+		struct {
+			struct netgpu_ifq *ifq;
+			u16 queue_id;
+		} netgpu;
 	};
 };
 
-- 
2.24.1

