Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117963584EB
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhDHNkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:25 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:10976
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231722AbhDHNkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCedl1+DGLm77Yn2HounT966vW6I1JnlPk8W/jRHLe4zrL8ca+5uPOUh4HX5Qy7Hw9j26qPx8nk16CWL97ST47PX5pL1sfs833gi2SY8InDeJ1tkauLfQCxFei071bJq5uwk8vts2h/SzSpOo+yoMzT7qCWxGYqxkTAU/NOnDYz7PH8K6h0b4RIZ6fP2CRjIQ+U6tokkPjXP3oNLaG+6u7A0jmxbQs5d8IILYvryEP54ms7c73QeJiIv7uN4D1VYhNWgytRDUb8d8K7bZL0NxX2/n6ka5pgEJEwild6APEXFoQZarG60N54N/OfSndfAEOGTDp5QKFPMqQUzvSGKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/q5XYYrG4nRl3Biq6XUQoR0svlOdf7wRrnfFd80t0c=;
 b=bVSlF5H0dXEZyXdmi4JIRalqmaAnUTW9FSTL7yt6B5RlZ144zFXSMUFAyL5jbvKpOcTuDokUONgChzVsBKxHXvzBjZ9VoksRJQFmGbCwVMTuWiCAOza8z9AwK/pTdfqYfWM8dovz4NYXXdEgzZd0BiOZBiXwUdNSF+lPaBZSG1V1oTDNtYNDF9cCiksIWjn8si0si/uEEAWbVrxacFti968p87oaUEKE2A2vtad2l6W1cffaQXbnGRWwthQjSSckUjpdxWc9owaJDmi7O5ju2JvJrl1PUEeVDgbjWRc/TvF7jgRwqVOBc4bnd4nQFUtEUMU5DWVN5A2M6ZshevipMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/q5XYYrG4nRl3Biq6XUQoR0svlOdf7wRrnfFd80t0c=;
 b=i1jtWoHNgZImZLs8v3GdD5GvHuoSBo06DBFJJXZFIvY/UsIm0oeWhHGyg1TaeHHDjPO16o3tloAjlvxW8FfLk8qErIlxv9u7Uz2jCXauAJg+jlIpvY4RoAMggzYXusJFXMoE3dmEBUp+8UFgEGxBNbEgE6YyjBiy56HrCZBfZHxQ8qnf1DgRDLo3T7AjIoRfEAKLKTt2kgIeY1i5QJ2I99hnJbcLFiJxZu+sBvkcQHBxNmpa4BKFD1z8+4a9sA1eiEUGVjHMdXQhvWxAWfn1SA4w8iZPye6p++5tinH4xKmlFh9wOwv1Xm4YNIfy81xgTidC/aq5woFYUUGXJdtCIg==
Received: from BN0PR04CA0044.namprd04.prod.outlook.com (2603:10b6:408:e8::19)
 by BYAPR12MB4727.namprd12.prod.outlook.com (2603:10b6:a03:99::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 13:40:07 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::f) by BN0PR04CA0044.outlook.office365.com
 (2603:10b6:408:e8::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Thu, 8 Apr 2021 13:40:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:40:06 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:40:03 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 4/7] mlxsw: Propagate extack to mlxsw_afa_block_commit()
Date:   Thu, 8 Apr 2021 15:38:26 +0200
Message-ID: <20210408133829.2135103-5-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8609ba12-8a93-4141-9dd4-08d8fa93d253
X-MS-TrafficTypeDiagnostic: BYAPR12MB4727:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4727B24595F16E015EA05A9CD6749@BYAPR12MB4727.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sm1PlADQalwOAdcEUUkXSYK6OQyDD3CEf2kpDr6UsoahEJRRCUbBtFmaYZ5JxSjurmlr/iXypvZrMacgSW9RKMy7cy5McJnlCGR4wSXWz0h9D3xXckGGdLfHjoAXXz+Y8sZTpkXNmxE3JMN2TV6pk8FzuXLF8cXWOZAN0WCMIk4lbOTRLMwI+5AIlJkys5JAie/k7OQI0fB4PxWAD8XJN03W+ZjwiRkl9lc066WmyrtKDCdP2TUXl6GaF7dBd83WV5RBPkWHrkv6ikd1y35hr4Ss6d4/kGFlgfhWcgPWy5JlKbntFak0gJLbpcBfJn2zHpBxKi38u4are6rw+yoUj6ryCx+tE8ACjPiwA84L7C3GOvicELMLPfU1K0VW2iavq0Vs9fNBrLvhQ2pwWqj2upbKdG1hhPY4LyVp1cc661R5/PogBQZhdBzBOQ7xNrvsrEjWWRdbXK0E6GIymQgHJ9Rqr9COLGMRvlwncgkyvL/rcLxmtuSl8hr0RMgzhQliX2TdabGQ3+W8XIjqrbw9JxTpXP4082zw86EcEJBzYQYF3o1xbtPNq+mvEQU3on0XRDFHAj1/HfOhPid5xP1m6IcnYsQRMVDvk+sG7DxQCZs+qqXr/+Du2xrnkJ7DzyIxQmX80oM/GYNpYVw9JLvL8HHRHuoitOI+40+O3wUw7l8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(46966006)(36840700001)(2616005)(1076003)(426003)(6666004)(7636003)(82740400003)(8936002)(47076005)(83380400001)(36860700001)(336012)(4326008)(316002)(5660300002)(26005)(82310400003)(2906002)(16526019)(54906003)(36756003)(186003)(86362001)(6916009)(478600001)(8676002)(70586007)(36906005)(70206006)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:40:06.6508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8609ba12-8a93-4141-9dd4-08d8fa93d253
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4727
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following patch, attempts to change the next/goto of a flexible
action set from goto to next will be rejected for action sets that contain
a trap_fwd action. Propagate extack to make it possible to communicate the
issue to the user.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c  | 9 ++++++---
 .../net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h  | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h           | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum1_acl_tcam.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c       | 5 +++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c    | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c   | 2 +-
 7 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 78d9c0196f2b..faa90cc31376 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -264,7 +264,8 @@ static void mlxsw_afa_set_goto_set(struct mlxsw_afa_set *set,
 }
 
 static void mlxsw_afa_set_next_set(struct mlxsw_afa_set *set,
-				   u32 next_set_kvdl_index)
+				  u32 next_set_kvdl_index,
+				  struct netlink_ext_ack *extack)
 {
 	char *actions = set->ht_key.enc_actions;
 
@@ -455,7 +456,8 @@ void mlxsw_afa_block_destroy(struct mlxsw_afa_block *block)
 }
 EXPORT_SYMBOL(mlxsw_afa_block_destroy);
 
-int mlxsw_afa_block_commit(struct mlxsw_afa_block *block)
+int mlxsw_afa_block_commit(struct mlxsw_afa_block *block,
+			   struct netlink_ext_ack *extack)
 {
 	struct mlxsw_afa_set *set = block->cur_set;
 	struct mlxsw_afa_set *prev_set;
@@ -479,7 +481,8 @@ int mlxsw_afa_block_commit(struct mlxsw_afa_block *block)
 			return PTR_ERR(set);
 		if (prev_set) {
 			prev_set->next = set;
-			mlxsw_afa_set_next_set(prev_set, set->kvdl_index);
+			mlxsw_afa_set_next_set(prev_set, set->kvdl_index,
+					       extack);
 			set = prev_set;
 		}
 	} while (prev_set);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index b65bf98eb5ab..24350f9470f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -45,7 +45,8 @@ struct mlxsw_afa *mlxsw_afa_create(unsigned int max_acts_per_set,
 void mlxsw_afa_destroy(struct mlxsw_afa *mlxsw_afa);
 struct mlxsw_afa_block *mlxsw_afa_block_create(struct mlxsw_afa *mlxsw_afa);
 void mlxsw_afa_block_destroy(struct mlxsw_afa_block *block);
-int mlxsw_afa_block_commit(struct mlxsw_afa_block *block);
+int mlxsw_afa_block_commit(struct mlxsw_afa_block *block,
+			   struct netlink_ext_ack *extack);
 char *mlxsw_afa_block_first_set(struct mlxsw_afa_block *block);
 char *mlxsw_afa_block_cur_set(struct mlxsw_afa_block *block);
 u32 mlxsw_afa_block_first_kvdl_index(struct mlxsw_afa_block *block);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index f99db88ee884..d74fc7ff8083 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -920,7 +920,8 @@ struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
 			  struct mlxsw_afa_block *afa_block);
 void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp_acl_rule_info *rulei);
-int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei);
+int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei,
+			      struct netlink_ext_ack *extack);
 void mlxsw_sp_acl_rulei_priority(struct mlxsw_sp_acl_rule_info *rulei,
 				 unsigned int priority);
 void mlxsw_sp_acl_rulei_keymask_u32(struct mlxsw_sp_acl_rule_info *rulei,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_acl_tcam.c
index 3a636f753607..cda04bc4453f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_acl_tcam.c
@@ -75,7 +75,7 @@ mlxsw_sp1_acl_ctcam_region_catchall_add(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_rulei_act_continue(rulei);
 	if (WARN_ON(err))
 		goto err_rulei_act_continue;
-	err = mlxsw_sp_acl_rulei_commit(rulei);
+	err = mlxsw_sp_acl_rulei_commit(rulei, NULL);
 	if (err)
 		goto err_rulei_commit;
 	err = mlxsw_sp_acl_ctcam_entry_add(mlxsw_sp, &region->cregion,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 67cedfa76f78..b9c4c1feba6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -341,9 +341,10 @@ void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp_acl_rule_info *rulei)
 	kfree(rulei);
 }
 
-int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei)
+int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei,
+			      struct netlink_ext_ack *extack)
 {
-	return mlxsw_afa_block_commit(rulei->act_block);
+	return mlxsw_afa_block_commit(rulei->act_block, extack);
 }
 
 void mlxsw_sp_acl_rulei_priority(struct mlxsw_sp_acl_rule_info *rulei,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index be3791ca6069..936788f741dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -611,7 +611,7 @@ int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_flower_parse;
 
-	err = mlxsw_sp_acl_rulei_commit(rulei);
+	err = mlxsw_sp_acl_rulei_commit(rulei, f->common.extack);
 	if (err)
 		goto err_rulei_commit;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
index 221aa6a474eb..f81e8d25987b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c
@@ -241,7 +241,7 @@ mlxsw_sp_mr_tcam_afa_block_create(struct mlxsw_sp *mlxsw_sp,
 		goto err;
 	}
 
-	err = mlxsw_afa_block_commit(afa_block);
+	err = mlxsw_afa_block_commit(afa_block, NULL);
 	if (err)
 		goto err;
 	return afa_block;
-- 
2.26.2

