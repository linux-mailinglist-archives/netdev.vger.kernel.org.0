Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57424519732
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344828AbiEDGHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344826AbiEDGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:07:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B901C123
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DW6tt2Whbv+2qtcdpqwtkP+ImHXE7NsvZS2qbqgw8fp38igXaIPoCUnepbgVKUucKkAL7VfB6c2IP2sHG54IpfQZomXCTtRleQwHQJQ66+SUS0zddk9u80CVlS0RFn+d7mtyn2hz9GR8Lyu/tslhtswzxIf1ihgYdqdRs7+BAvXfKrLYM8UCXGB+HB0oI5tRANPp+hqBBWZIJ5b+IBCrcuVUmxdEts43PLIRt8YImZil4wFM/e60PWQKH5O5BgK7TGRCXqAwEPhxKQW/oQwlWIAi4pqAZydLxVKV34t+gAWV89qrK7Lvq/eQHdMDT3mJfwAtOvvHzaorjWZ32nPFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMocSnjR32TogMVS4i1uUkfRxbis+mtaA74kxwquUcs=;
 b=buLOFeCfgx/osg3d73WP3g/6FKwIyG4kojLnEgjNn5eF8ZgM9DFZCc/UKW9KzAsJ0osr/m/vsLrJL6TJ+WYA8kJLz5hQjosyJ+vAW+stShZGwHFkaGfN1UmmUt06MsAdlM1Q49sCi8t41Arstu0TU+TYfCJpuITL8inVEJW78k7+H1PN7t6QdkwHF55tu/jiNthJQvIkf92jTMDlp62i08MHUFmWwnru/zlflSIOywX5ZtpjP5QHKZT5VqboxoiB7nLNgl7mFcZEt6EbwHS0vJgPeG8Rur7ZL90RbJbjYafDg28nN6TKaNwm9PSZnK+9XWjEXvWRv8dVButeOxIF8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMocSnjR32TogMVS4i1uUkfRxbis+mtaA74kxwquUcs=;
 b=qPTVYtWxElKlkjAolrYjDVFQH/31S6WlvyHXq+JrYw5DFiRkKwIk4q4LwWyhnW4TGFNjaUWCFDrKVmmf0c/xzYnqRfSkHUfw7Lw5oxU4VOBGO/anJk83zClCLfFUNXbge+cpNwESevR7MoNMwmlLFzZH8PM1FW4OKUcw5acb1U7FyiUUc1LM9yFW2NIqnTL+5JhTCYmYqWP7tuSsm4pdbB+sMNZWSQBXDPzX16auHc1/V8HAmsCRqMFPiKbk4FTpE0AYLmqYmG6VmoNrIc+QSfgXaLQLqABH1/+rzJJ6RIRuFIxNGGBMr0/tSNQr/GJKMGtfmw2VamJKbeTOWx9w0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:15 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:14 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/17] net/mlx5: Cleanup XFRM attributes struct
Date:   Tue,  3 May 2022 23:02:29 -0700
Message-Id: <20220504060231.668674-16-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:217::33) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7cc422-c8a3-48f3-a331-08da2d93c6ef
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00060690D25C07A33F577C11B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IoTbglocv7oXXhuwH8/7cnvKJZGPga+/8vtXebvk4b2LDB50FndO+/nPsf65FEN5uhZiYbcqm1vqYy9i0/crI9Vu74dbLz8uTgbv1xoUXCQg9hlc06K5nAz8Qe6ZYm/F1eO3ZxzceBon887Fz/8iyIbQSQuKTyxxpZhtaom2YUPakNrqxQKUlDKIJBjYxb3WFW6HQvsftmSc5U5a9+SySykA+CnwptaggN5pE6CeHdOYEciszj4aFR4oCOmXpi4dKA9HD4kP7r6kf4o5RutSK0X56f0oJTJfotfnVdMc7yB4s72ovi9NokmV9pvBK8MBYfjqsrLjRtf3WxALqiwcqzmMylDD++SfsqRPx6hNNyolLLHYJgKUIuIEZUo3BjVZyb8TTy215G6jbIRfYFHJVM7qJczSVc4BJhUliACH+KWgAbARDdyECz0tBkqold0HfjUIyH0fFksvPezIlBB2386IqvyTh+drnSlngxpI+RoMNXYrQY+MpCaUWSu5gJNiwhvnto9YWvNgnymLByWMJ3hDYk1JJbfsi35U2MKicFrXMRMrug9g1ftNf+FXL2oem/A64M/fI2PNAfk3oV5dgimtcv2C8SwWHOImKsj/T4U7mVm6IvwoSiI9QXrQf3Dw6VODmyzY6+j0GdxIXjEJBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UbvPbYk/d/VXrr8xzJorYjsw8mzUQPsamtJGQalqJ5rpcBIDYi6fcouvbHlI?=
 =?us-ascii?Q?rReIey68++644IfSo+K6cY4XNLJOzHhRrsUxxEvGIVBXnhdvFWExaOy+GxLM?=
 =?us-ascii?Q?i5QAJVHcJGe0CoHE0CGZCLBJ9+jAVDinBZp9cu232k8/jMQJWMc2EnAddYEc?=
 =?us-ascii?Q?qz3kQG7awQIqAg6IjVhbsdjTyzYSN21UyaSffRbSmlWuSdLpgdXslxytc02G?=
 =?us-ascii?Q?q2INaHf+UbcQzCgOUeZQOwwgOkICdpoGZ7AVJsNRhjT0qW4QKAb3G+kLWcbq?=
 =?us-ascii?Q?19qtxGwzqaB3lnj1OfpHngeVIzXsEDa7CbyedpOzD7SPq7vmryYf9Mgt/a/L?=
 =?us-ascii?Q?uDnPF1pbk6V2oLNdfsF51T87lMHgrs/3N6lpWrO38nEhP/hG4Gr+Dylxe24H?=
 =?us-ascii?Q?XB8NKNaR9N2rMLcIk4T9ckdajINOPhd3HlC2dl5urp/kqGURMccD57sy7k0F?=
 =?us-ascii?Q?efjd05a9equuNs8sfp6EGYnHz17cRDUVfkAETkv6lxWQJXloxkFDC+cLSBOn?=
 =?us-ascii?Q?xwcmhZD86fiHmAJZASj46xgfzNyAjJg65xmvuk64+S5UqfVvaPr5cP+FZ0jW?=
 =?us-ascii?Q?hCe1qOeCsLAVjMZtTlHUKYTcHLl/DvRzGpo6Q33BBY0erSNS/TuVoQTHxtKS?=
 =?us-ascii?Q?CDXgLkcEB1Ims3m9qAD6wgPd9pJFhSbAuN0Kn1WbS82OTWecfR+1EouQlaHw?=
 =?us-ascii?Q?FpF8EPYNaQwasrUQmAYyMIGBWWhSKtm2oEq7XfwqelHAE7bJHKg8Zucb2ceJ?=
 =?us-ascii?Q?+D3HxIEOLv0V1taIh+XT02DoIpL2Pju2LnWvga/FxESE4awnJOsKQ0UxNEbm?=
 =?us-ascii?Q?ZFTzBPIqgpdS6ICtdWTTAOmDqD5zXd+DIxk3Heqkdkv7esWTVmB9XTWsbEXW?=
 =?us-ascii?Q?AUHRmqJU08tBdnrv10+rQWbz5LWIgim+W5yOFC379rAie1+Cqv3mdkokCB8G?=
 =?us-ascii?Q?yv75All4as4B49HZjlXvrgsv5ppc18dDNK9VbXzYn2RZ5BeERdElWz1Akrjm?=
 =?us-ascii?Q?APkmJeE+Dmz4Qn/rmw8oMnGDcMVALxThCLyIGFSP0CdNUgpLdTYFG51LXK3o?=
 =?us-ascii?Q?SRf+FXI01RCqGzhcphMMsNMLOF4CQN4LMNub+kcQwk+Zvy+buZ/+G/XElBzo?=
 =?us-ascii?Q?rzQFg/kDMSrF2kCkW19L1Cb+XtTPWx1/g9KKZ2JZIvLsi49/BkULdGcwW7mv?=
 =?us-ascii?Q?0yccrKZ9OzyLam9SBq+XwHgHjSfRn6dOz3lLeR/PSfEvsxFDyjB6CzjQlvdl?=
 =?us-ascii?Q?T2FECBbb91sRv0kgkd/SIF+WXig8iLatoN3htew2LIeSq5NNWSDSbV7Khx7x?=
 =?us-ascii?Q?KpVlN9Y0NyYD1abYD/gQOrtcYwM4CuAyjyTj46j+vo45vf4QFjgrhPw18W9N?=
 =?us-ascii?Q?ZWOXeHGsQ3pYkQ/43Wlf3U6hxLOj/pJeBw0Z+Gq7Gt4vWewKxEwRvl7gz1OK?=
 =?us-ascii?Q?Kujoc+HYje/DxdkOBMuBLREA8SFNTDjf5kFbLClXeZ38g9+j6jqOIqGsnusl?=
 =?us-ascii?Q?K2RubtGclh3EKP++607q3pnOoErz/Q488X0oH2dEOYP12+eMqXNcPgIJc1Vu?=
 =?us-ascii?Q?MDa3UJo6ahswOYgAsqn1/1LvZOwcnWQ3OyarMdRn0v883kNeDTO9ZMLwI/2t?=
 =?us-ascii?Q?CU8Pk+inx6SVTkHaRyzdnpNO9sJZOYEbvd/nCp3ln14eZdDksWUCaASut3ej?=
 =?us-ascii?Q?ZhuMrzmNqkqlI9M8hXl/khOtWOBmcE9BpjC75Vy5Juf7MMCcOKHa9ztFparM?=
 =?us-ascii?Q?uJovfsvzieYynNBDu2To/4H//nDp4VCcXN9kxAcGo4X0/yaswxyz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7cc422-c8a3-48f3-a331-08da2d93c6ef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:14.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBa5cPcvZyj2QQh472V7OMEjChJeUQz2HpqXrMtT5uNoVQQ4TDrcfTQ6yAhyvRN1DoRGFAySyR1kYvAYrn2J4A==
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

Remove everything that is not used or from mlx5_accel_esp_xfrm_attrs,
together with change type of spi to store proper type from the beginning.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 ++-------
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 21 ++-----------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
 .../mlx5/core/en_accel/ipsec_offload.c        |  4 ++--
 4 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index be7650d2cfd3..35e2bb301c26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -137,7 +137,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct xfrm_state *x = sa_entry->x;
-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	struct aead_geniv_ctx *geniv_ctx;
 	struct crypto_aead *aead;
 	unsigned int crypto_data_len, key_len;
@@ -171,12 +171,6 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
 	}
 
-	/* rx handle */
-	attrs->sa_handle = sa_entry->handle;
-
-	/* algo type */
-	attrs->keymat_type = MLX5_ACCEL_ESP_KEYMAT_AES_GCM;
-
 	/* action */
 	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
 			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
@@ -187,7 +181,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
 
 	/* spi */
-	attrs->spi = x->id.spi;
+	attrs->spi = be32_to_cpu(x->id.spi);
 
 	/* source , destination ips */
 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 97c55620089d..16bcceec16c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -55,11 +55,6 @@ enum mlx5_accel_esp_action {
 	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
 };
 
-enum mlx5_accel_esp_keymats {
-	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
-	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
-};
-
 struct aes_gcm_keymat {
 	u64   seq_iv;
 
@@ -73,21 +68,9 @@ struct aes_gcm_keymat {
 struct mlx5_accel_esp_xfrm_attrs {
 	enum mlx5_accel_esp_action action;
 	u32   esn;
-	__be32 spi;
-	u32   seq;
-	u32   tfc_pad;
+	u32   spi;
 	u32   flags;
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
+	struct aes_gcm_keymat aes_gcm;
 
 	union {
 		__be32 a4;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9d95a0025fd6..8315e8f603d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -356,8 +356,8 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 
 	/* SPI number */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi,
-		 be32_to_cpu(attrs->spi));
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters.outer_esp_spi, attrs->spi);
 
 	if (ip_version == 4) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 91ec8b8bf1ec..b13e152fe9fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -50,7 +50,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
 	void *obj, *salt_p, *salt_iv_p;
@@ -106,7 +106,7 @@ static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.aes_gcm;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	int err;
 
-- 
2.35.1

