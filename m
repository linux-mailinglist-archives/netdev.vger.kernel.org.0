Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5E519727
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbiEDGG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344787AbiEDGGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893CD1BEA1
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga0FdD6V4BA6QgNXOaJr2dwO3LKaLDTknkPu3IvAxRBg6UTdyRZojE4nX2P4okLyzDWS/NYeurZqst2neacgDFURhZla1imp2eJah4Mpw3NYE1IrEyV9erJovEZ3gmGaXG/2Trtn03cwon4irr+L5W+YAJFEoAjXa6cuR4Qw2I4MIGVGBVqA6/mVSAzaiTQ1igBwXCnFRPhOCXYW+H2telFVgAg892P0ppDvB3RoghX2z93MvqgxdGSzOJc3FGcZRkOtF+KrMxSvEAbO7tz+nnONTFh4lM0mQKAAGPxqB7UkHtH348YrERpDafo/3OXB3Mk1FYHCb9QPm7PtcMuUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cG/2CozOpgWt39RiQNIR7yPijqEyJqzmX8N74g6AsDk=;
 b=DfGLspB+SjW0G9QugSi1aO+v65AlIGRGjKOoLKNUghxwMOh1ve9npt3YcBbVuYU3FjK8Ke/Frh5o/kKCFLst3LYgJ3/112DAwNkdeiGzF8FWqHWbtNQDxcaLsHujlr/BHXf1bh2oqNwwWVFziubBsY0fIhLSnb2SxIteTkcQnBX/gy0VWdIUHvH5ruJwQSj+3byU63c4Z/jNyUVUw7lQctj3zwwjAT4ldTWCAqKHd9dJlR4wInQtWGwgO3z81/5CPr00C2WW9jsHRUInapf4qyRlKROgDhsy+L+d3X9IGK1GZ3ni1+Ws1j8ng+o4+3tEQ2eEMBZrXpnAYjobJ2GS3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cG/2CozOpgWt39RiQNIR7yPijqEyJqzmX8N74g6AsDk=;
 b=Wcf5TCI7TvltWM9QxBhVBUa/0f7iW62kiUX11Lf/4uNJKMDfqUYDlauRq+fPdgafFQuZdZbADQaDmysjhIz7g5dsjuigV/abfdCZOg+16QuM0bmY8F89Ub6eWe232JM734kCEv3o8/4mPHma2OQnZfuLE7LpaJaRoRTU64aJRgynu7Fe9jXejR/K5Um1xT4RsdXtLVgRx2uHgX81OgQFDQJBsWmNDbC00oSWZSbO3zngq14YILVGi55bQlCdSnJx7MYV2FZEzpSiA7rkk0PK5Drm6KB1qL5QT3+G9nkeVHb9T8zQq1wp+w2iuaUY8FFCyPvbaSeOSvdKO7xgtwBHBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:04 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:04 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/17] net/mlx5: Merge various control path IPsec headers into one file
Date:   Tue,  3 May 2022 23:02:21 -0700
Message-Id: <20220504060231.668674-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38)
 To BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22287cb1-6762-4c7f-d427-08da2d93c0f6
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006009BA01F593CF8F32106B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZOsac0aSyI/3fOxjgS86HQ/zfKhcvuvQUbibyZIyBBZ48Y//NXCubMChTw5bFuoKB5OrTsSDorNv05GAnGPanUz94XskC0G+K6QFt971yTE525TNlBSwdaBb/49td69zHffN5XG9cLFRNtOrDf1Nnhlnzx/z2YDlbk+oooO54muKA/DRl9oXWDsce8gGMSevJpSobjO3CmMzOsUMmC8p8J4hwrAlaLBw54NOBzWfY58YGH/FSaY79rWKl2pcO0TczeUqQs/Mz+K0E9s2BZ4fDpnhfc77pfqfpSNBdpfIh2Ig0sTsJKeUEwiHZtDhcRBCpISZzOE0mioTD9AhBfoaSuEisf1crYC/9u/dzLpVZhIX7S1IcmsoWM1JrBtZlXHmuOg73NVKKCkUdH6q2UpAqywZ+nnt7dyiH00NqY1bTErrb7GcKV+WcfOm0ieUZzyp4hnzFcm49XxE3LgtYeTC6tUqOIMYN+8dEAOCI9rG9lTKbWYnTW++FuWaI+YMlmzmVdMjvK+aVHBYermISpTAQjf9ffP6/1rPDjFY84N1YmuPNVzECjCV5AWF6ZpvrYVyQL1USx5nj4AC4N28tK83UWdmFQcWyOxJugQPHGk/oGLMCzE98YHZsYQWg/QUY4fx1xpr45HouQSuyQNmDlDNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(30864003)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3832BZmr+wZPpy517H2LA3AfaQa4Gvvzf8xtvsnSZu0B9RajyXAkgOZbSKiP?=
 =?us-ascii?Q?nQeHsPKDGzL/GTgKsAkNOjKo0jVY+FzNgePaOf6VrBFpkbRzoO1q8ln38kbd?=
 =?us-ascii?Q?viXtxM6+NqJqmr1SVNVJNB4IuMXaoZS9i4HFiY8azeOXJ5RAgDdJUPpZo61W?=
 =?us-ascii?Q?TW7eiLd1yhM8ckN9UkM7ox1EWy8wNmOBOs/DFZ9icynAw6JJ6CHDXPtEDMM4?=
 =?us-ascii?Q?oJ9u3Wx7Dr/g3JYhNFyQmuFwm/64Idr1ZblrHUMoFMnWkgj/nsfE2j3Pg0Gu?=
 =?us-ascii?Q?+ye1LSXc2agqnlJHumPB/ZurbtoW5tnIgxoXc+/ch+74aRTRwv+f+N6f8UUV?=
 =?us-ascii?Q?j2VSbb8lWaFUB1u6Qs6GZztbVq+J51oaItjXCZNGvU7i8UXpbWTi31P/8dOb?=
 =?us-ascii?Q?l+s8FYWRk8PozVqLeeQlEMy49/CgVQNUc+xgUn/BPwiQNYWy06YwMLDPsl+J?=
 =?us-ascii?Q?KoMy98JlAo9hSgXxvacZgmdR2z9Kri3rt2oiJ6/p72h/e3QDSv6iDY9Sc4sE?=
 =?us-ascii?Q?4NfqAj7tCP+1/GzxNEPHiQrORY8eCepjvN1eyRs5gz+tOK4vx8Z6NKU1cfNl?=
 =?us-ascii?Q?+IS6ldiYzjHW6WAaHYjzslN6j94hoF2/5tFcndqvv2PQBym1fRhb4jrE9j3U?=
 =?us-ascii?Q?Rh4dAdzrUMc7tv4WGkUoQ+K0DcD0Wdb4xOLEzlsXZbYoKBS6ZVpcXQbiekES?=
 =?us-ascii?Q?QjagdEVjlOUZaAjHgvZDY5u+UFNswpfWp/rHfjsSPnaP2TxuR9ZLbWH6OhXX?=
 =?us-ascii?Q?RGcIizpBDhDgnJUtq/gY7rIpZwK1ilejryQbvFqc8sCB7Cqz6DEqmSvIp6Eb?=
 =?us-ascii?Q?AQHpAfQejqTCuCi/lQmmTx5UltE1ol++R90VdVqzVEDRWTYAgdg87UgfebCW?=
 =?us-ascii?Q?Lneztk+HM8slkDSmEY5k1vBGgxwuAGIV6oCkHh/H43eTPn8MuY8JBREqGJaX?=
 =?us-ascii?Q?atrq2JRu9KfRb8KGig/HJm/TGoq88fMJz/81yAcYW8FP/umSMnPoJAqL87hr?=
 =?us-ascii?Q?wjIIIp7o+2pJX9aRBa87Uk0tOBENhujnhuHF4XuRmOpqAD/QVUksWZ4dNyIS?=
 =?us-ascii?Q?4DmzD3lP5ih4mn75Z7nEQr5Eb0bteVue7JL2o/u3MZD3momHcqbAwU7/Rfah?=
 =?us-ascii?Q?TQSTrhStyrWZXFdpSSEEMYnVkaruvB3MT5NbnMT2308cNE/I4EoA16dpdtp/?=
 =?us-ascii?Q?2wljWjoMCZB1JElWtqdkutOEe6eQBMtvBmiyjb/VEHbm0JrC56HhQB4oSYne?=
 =?us-ascii?Q?jrgRCwgVn27wB4cK/ucD5DvHdn+HA/tR0sRYaLUNSGRArEiLKEf0fAwQzGbA?=
 =?us-ascii?Q?er68WQCJIeY2pkbybNCKhOuZRCk+QmI4yk5q5qSmMnp8WUCCse38vVnMHVm2?=
 =?us-ascii?Q?Wol/T/CqCmAwwxwJ7NOF1AcAG7oOmvHbB9Jf7T6Pwl+ylcMYCaria+owuajh?=
 =?us-ascii?Q?zogl3b7WVzQSOodB7sfFoQNTYTsu0FWembqH74AYzIv2EVX3gvvaUURDthJ+?=
 =?us-ascii?Q?tP8yf+ymApQ45dQxEGMq2FMAgEBmu0XgoEjVH5nIzKzkxaB5b2eiTtBWqckf?=
 =?us-ascii?Q?27xJpXwVVpXZkI2PDx8BYdtTQlBEgCOM/a8eKXxHBlVSEDRlL7jarH+jCwIm?=
 =?us-ascii?Q?yyRkhkoRYoy5JohApp/e/2UBdwa4aTKFwn3jCsmPDk6DI1R3wiPayS7fxECV?=
 =?us-ascii?Q?zSc76wttBTiSon7QKS6TAT+aflb+Q5h1aCR+YCYMh0Ums2ZVgsoKrLvxtweh?=
 =?us-ascii?Q?7eZPlP+FrneeNNtah3/5iTHU6a4WMGDmMR62s7dL3POGODXSukdN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22287cb1-6762-4c7f-d427-08da2d93c0f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:04.8740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3YnIFgSEkyeZet5/V4v1EF6JMPm44DPtoCavdG5eyPagWUhTSb3xaAql1VpeNH9VdkMViAb3vDbY72piRQCn+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The mlx5 IPsec code has logical separation between code that operates
with XFRM objects (ipsec.c), HW objects (ipsec_offload.c), flow steering
logic (ipsec_fs.c) and data path (ipsec_rxtx.c).

Such separation makes sense for C-files, but isn't needed at all for
H-files as they are included in batch anyway.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 101 +++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  17 +-
 .../mlx5/core/en_accel/ipsec_offload.c        |   3 +-
 .../mlx5/core/en_accel/ipsec_offload.h        |  14 --
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
 include/linux/mlx5/accel.h                    | 145 ------------------
 12 files changed, 117 insertions(+), 184 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 delete mode 100644 include/linux/mlx5/accel.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 1e8700957280..3c1edfa33aa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -5,7 +5,7 @@
 #include "en/txrx.h"
 #include "en/port.h"
 #include "en_accel/en_accel.h"
-#include "en_accel/ipsec_offload.h"
+#include "en_accel/ipsec.h"
 
 static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 8283cf273a63..0daf9350471f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -37,9 +37,8 @@
 #include <linux/netdevice.h>
 
 #include "en.h"
-#include "en_accel/ipsec.h"
-#include "en_accel/ipsec_rxtx.h"
-#include "en_accel/ipsec_fs.h"
+#include "ipsec.h"
+#include "ipsec_rxtx.h"
 
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 35a751faeb33..b438b0358c36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -40,11 +40,81 @@
 #include <net/xfrm.h>
 #include <linux/idr.h>
 
-#include "ipsec_offload.h"
-
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
 
+enum mlx5_accel_esp_flags {
+	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
+	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
+	MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED     = 1UL << 1,
+	MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP = 1UL << 2,
+};
+
+enum mlx5_accel_esp_action {
+	MLX5_ACCEL_ESP_ACTION_DECRYPT,
+	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
+};
+
+enum mlx5_accel_esp_keymats {
+	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
+	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
+};
+
+struct aes_gcm_keymat {
+	u64   seq_iv;
+
+	u32   salt;
+	u32   icv_len;
+
+	u32   key_len;
+	u32   aes_key[256 / 32];
+};
+
+struct mlx5_accel_esp_xfrm_attrs {
+	enum mlx5_accel_esp_action action;
+	u32   esn;
+	__be32 spi;
+	u32   seq;
+	u32   tfc_pad;
+	u32   flags;
+	u32   sa_handle;
+	union {
+		struct {
+			u32 size;
+
+		} bmp;
+	} replay;
+	enum mlx5_accel_esp_keymats keymat_type;
+	union {
+		struct aes_gcm_keymat aes_gcm;
+	} keymat;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} saddr;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} daddr;
+
+	u8 is_ipv6;
+};
+
+struct mlx5_accel_esp_xfrm {
+	struct mlx5_core_dev  *mdev;
+	struct mlx5_accel_esp_xfrm_attrs attrs;
+};
+
+enum mlx5_accel_ipsec_cap {
+	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
+	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
+	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
+	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
+	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
+};
+
 struct mlx5e_priv;
 
 struct mlx5e_ipsec_sw_stats {
@@ -108,6 +178,29 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
 struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
 					      unsigned int handle);
 
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
+int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
+				  struct mlx5_accel_esp_xfrm_attrs *attrs,
+				  u32 ipsec_obj_id,
+				  struct mlx5e_ipsec_rule *ipsec_rule);
+void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
+				   struct mlx5_accel_esp_xfrm_attrs *attrs,
+				   struct mlx5e_ipsec_rule *ipsec_rule);
+
+void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
+				       struct mlx5_accel_esp_xfrm *xfrm,
+				       u32 *sa_handle);
+void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
+
+u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
+
+struct mlx5_accel_esp_xfrm *
+mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
+void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 #else
 static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
@@ -122,6 +215,10 @@ static inline void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
+static inline u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
 #endif
 
 #endif	/* __MLX5E_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index bffad18a59d6..96ab2e9d6f9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2,8 +2,9 @@
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
 
 #include <linux/netdevice.h>
-#include "ipsec_offload.h"
-#include "ipsec_fs.h"
+#include "en.h"
+#include "en/fs.h"
+#include "ipsec.h"
 #include "fs_core.h"
 
 #define NUM_IPSEC_FTE BIT(15)
@@ -565,7 +566,7 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
-			   attrs->action, err);
+				attrs->action, err);
 		goto out;
 	}
 
@@ -579,8 +580,8 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 }
 
 static void rx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5_accel_esp_xfrm_attrs *attrs,
-			struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5_accel_esp_xfrm_attrs *attrs,
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	mlx5_del_flow_rules(ipsec_rule->rule);
 	ipsec_rule->rule = NULL;
@@ -592,7 +593,7 @@ static void rx_del_rule(struct mlx5e_priv *priv,
 }
 
 static void tx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	mlx5_del_flow_rules(ipsec_rule->rule);
 	ipsec_rule->rule = NULL;
@@ -612,8 +613,8 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 }
 
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-			     struct mlx5_accel_esp_xfrm_attrs *attrs,
-			     struct mlx5e_ipsec_rule *ipsec_rule)
+		struct mlx5_accel_esp_xfrm_attrs *attrs,
+		struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 9d2932cf12f1..6c03ce8aba92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -2,9 +2,8 @@
 /* Copyright (c) 2017, Mellanox Technologies inc. All rights reserved. */
 
 #include "mlx5_core.h"
-#include "ipsec_offload.h"
+#include "ipsec.h"
 #include "lib/mlx5.h"
-#include "en_accel/ipsec_fs.h"
 
 struct mlx5_ipsec_sa_ctx {
 	struct rhash_head hash;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
deleted file mode 100644
index 7dac104e6ef1..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
-
-#ifndef __MLX5_IPSEC_OFFLOAD_H__
-#define __MLX5_IPSEC_OFFLOAD_H__
-
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/accel.h>
-
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle);
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
-#endif /* __MLX5_IPSEC_OFFLOAD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 9b65c765cbd9..d30922e1b60f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -34,9 +34,8 @@
 #include <crypto/aead.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
-#include "ipsec_offload.h"
-#include "en_accel/ipsec_rxtx.h"
-#include "en_accel/ipsec.h"
+#include "ipsec.h"
+#include "ipsec_rxtx.h"
 #include "en.h"
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 3aace1c2a763..9de84821dafb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -35,9 +35,7 @@
 #include <net/sock.h>
 
 #include "en.h"
-#include "ipsec_offload.h"
-#include "fpga/sdk.h"
-#include "en_accel/ipsec.h"
+#include "ipsec.h"
 
 static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_rx_drop_sp_alloc) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 12b72a0bcb1a..d27986869b8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -48,7 +48,6 @@
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ktls.h"
-#include "en_accel/ipsec_offload.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
 #include "en/port.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 2dea9e4649a6..fb11081001a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,7 +48,7 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
-#include "en_accel/ipsec_offload.h"
+#include "en_accel/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
 #include "en/xdp.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 95d7712c2d9a..35e48ef04845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -62,7 +62,7 @@
 #include "lib/mlx5.h"
 #include "lib/tout.h"
 #include "fpga/core.h"
-#include "en_accel/ipsec_offload.h"
+#include "en_accel/ipsec.h"
 #include "lib/clock.h"
 #include "lib/vxlan.h"
 #include "lib/geneve.h"
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
deleted file mode 100644
index 9c511d466e55..000000000000
--- a/include/linux/mlx5/accel.h
+++ /dev/null
@@ -1,145 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#ifndef __MLX5_ACCEL_H__
-#define __MLX5_ACCEL_H__
-
-#include <linux/mlx5/driver.h>
-
-enum mlx5_accel_esp_flags {
-	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
-	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
-	MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED     = 1UL << 1,
-	MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP = 1UL << 2,
-};
-
-enum mlx5_accel_esp_action {
-	MLX5_ACCEL_ESP_ACTION_DECRYPT,
-	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
-};
-
-enum mlx5_accel_esp_keymats {
-	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
-	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
-};
-
-
-struct aes_gcm_keymat {
-	u64   seq_iv;
-
-	u32   salt;
-	u32   icv_len;
-
-	u32   key_len;
-	u32   aes_key[256 / 32];
-};
-
-struct mlx5_accel_esp_xfrm_attrs {
-	enum mlx5_accel_esp_action action;
-	u32   esn;
-	__be32 spi;
-	u32   seq;
-	u32   tfc_pad;
-	u32   flags;
-	u32   sa_handle;
-	union {
-		struct {
-			u32 size;
-
-		} bmp;
-	} replay;
-	enum mlx5_accel_esp_keymats keymat_type;
-	union {
-		struct aes_gcm_keymat aes_gcm;
-	} keymat;
-
-	union {
-		__be32 a4;
-		__be32 a6[4];
-	} saddr;
-
-	union {
-		__be32 a4;
-		__be32 a6[4];
-	} daddr;
-
-	u8 is_ipv6;
-};
-
-struct mlx5_accel_esp_xfrm {
-	struct mlx5_core_dev  *mdev;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-};
-
-enum mlx5_accel_ipsec_cap {
-	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
-	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
-	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
-	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
-	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
-};
-
-#ifdef CONFIG_MLX5_EN_IPSEC
-
-u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
-
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-				const struct mlx5_accel_esp_xfrm_attrs *attrs);
-
-#else
-
-static inline u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
-static inline struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-static inline void
-mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm) {}
-static inline void
-mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-}
-
-#endif /* CONFIG_MLX5_EN_IPSEC */
-#endif /* __MLX5_ACCEL_H__ */
-- 
2.35.1

