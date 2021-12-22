Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A7E47CE87
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 09:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243523AbhLVI4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 03:56:35 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15959 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243503AbhLVI4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 03:56:33 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JJnD23SCyzZdm0;
        Wed, 22 Dec 2021 16:53:22 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 16:56:31 +0800
Received: from compute.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 16:56:30 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/2] xfrm: Add support for SM4 symmetric cipher algorithm
Date:   Wed, 22 Dec 2021 17:06:59 +0800
Message-ID: <1640164019-42341-3-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
References: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds SM4 encryption algorithm entry to ealg_list.

Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 include/uapi/linux/pfkeyv2.h |  1 +
 net/xfrm/xfrm_algo.c         | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/pfkeyv2.h b/include/uapi/linux/pfkeyv2.h
index 798ba9f..8abae1f 100644
--- a/include/uapi/linux/pfkeyv2.h
+++ b/include/uapi/linux/pfkeyv2.h
@@ -330,6 +330,7 @@ struct sadb_x_filter {
 #define SADB_X_EALG_AES_GCM_ICV16	20
 #define SADB_X_EALG_CAMELLIACBC		22
 #define SADB_X_EALG_NULL_AES_GMAC	23
+#define SADB_X_EALG_SM4CBC		24
 #define SADB_EALG_MAX                   253 /* last EALG */
 /* private allocations should use 249-255 (RFC2407) */
 #define SADB_X_EALG_SERPENTCBC  252     /* draft-ietf-ipsec-ciph-aes-cbc-00 */
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 00b5444..094734f 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -572,6 +572,27 @@
 		.sadb_alg_maxbits = 288
 	}
 },
+{
+	.name = "cbc(sm4)",
+	.compat = "sm4",
+
+	.uinfo = {
+		.encr = {
+			.geniv = "echainiv",
+			.blockbits = 128,
+			.defkeybits = 128,
+		}
+	},
+
+	.pfkey_supported = 1,
+
+	.desc = {
+		.sadb_alg_id = SADB_X_EALG_SM4CBC,
+		.sadb_alg_ivlen	= 16,
+		.sadb_alg_minbits = 128,
+		.sadb_alg_maxbits = 256
+	}
+},
 };
 
 static struct xfrm_algo_desc calg_list[] = {
-- 
1.8.3.1

