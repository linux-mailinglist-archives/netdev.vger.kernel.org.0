Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA24744D9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhLNO0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:32 -0500
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:62001
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231909AbhLNO0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bW7mHp46LLpn1oVbv3z+YGuAfhgHLrhve4LI6buZHP7QGnSch/hC/UEWBUQp6ordJPGP6KHANzHqkn9zPyf4Gd8Z5bGfjy0e9gwpzxAQ75c8bl7NwJRSVuxQM4OeuOc9MxKXnn2Wyro6lMGbygCt6NDSpHF4DNTtRrQSG9yK3bshsLQUZkUOXq6K5WvQ1oJzjh7yaCe5q0f/sPUkKzesFQMkj+yhjV8IoSWmYVC58ML0+jpPaVbWcM/4aGt4qf8/grvcpj61mhjpmbYFNs0+KKuC95KKeolyyapvF1bweyBfq+AEpkWMUSay8I3fV8FaNhmAudMZvySWwf+3tGHDKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XquaiKsjOoyFTCTgQ/mJwXP0G/3qt/0YelHgenQaNqM=;
 b=T0TDf74SSMBjmENtK0cFZf6bi2LVpErgaa1NXcjxrG9WH88ApXvHL46Lhxy6MWMO3VLuUsLN6i6Zu+ql6q2s5yxyIaCOLf667FNuZocLW9t3HDCRTlDJ5p95fv+3qUnk4K2Aj94eoTp9mkOrTk0YRUMiuGkppv9Znkitf0AxEh/o6mw8FBegoAmgkL3KAPkEbJ14q1Mvd4xQw8/UEEUgi1Fe9BQxfJmY1nB2kxhw7N1HZseMy/vXfEQbdUHjPEXqUIlD8vMJgBpBHMECdbIg/BI7b41CkM5NQooqAWdLCZYGbRhhnedv1YiffZJboZ3suLFvV9x0Y+Ojc9sR8zfncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XquaiKsjOoyFTCTgQ/mJwXP0G/3qt/0YelHgenQaNqM=;
 b=U1lMQhroz5RGjTFRPYy6qqEHENrPqBMP9YSNYKnnAaF5NmWsKu3+JRgfr+TJp1kKduCiXoMnndptWNPbosKbO+fgB4Dl8kRjLBhsumhoP5AgbssAjF4MY5huTBqPdHOlbiJjKHLZaMxZ6gC+NQajhE92Wv4VyfZa12osHk9R9CNnbCkXNqJd2Hy98aSmfJtDWWFlTiYEJbEdIrWTgmiHnitFfYBE4T/QCUBsAlSuZ+yAd57EzpQGEcwyjmgrXFjGJHwFm6ppUIm9tCVcGvUq0xd/tT5gcU7mftjQ8OXYpVzCW7KpwPzksjiPE0ja7xuSoeqpAe4a6sWX+LFf8kyvcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BY5PR12MB3955.namprd12.prod.outlook.com (2603:10b6:a03:1a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 14:26:29 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum_nve_vxlan: Make VxLAN flags check per address family
Date:   Tue, 14 Dec 2021 16:25:46 +0200
Message-Id: <20211214142551.606542-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0065.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::29) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0065.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::29) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 399f24cd-ba36-4003-4581-08d9bf0db82d
X-MS-TrafficTypeDiagnostic: BY5PR12MB3955:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB395506E4BC16BEC66CE84741B2759@BY5PR12MB3955.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gI2GRpj29OpZ+wKya62f4e+JmvGDC8Esurx0iBOJhk2oNf+b+KEIfZBypZNQvs/4RxR7lmLkL8G7FbFHaWctBgq6+S/mCXGsXCHydJ69f+8Zlinl/+Skez0laKeM/ok64Yx+5KPus3MPlE9DaIZINbQbz5H/rPVQxBFQ5fnoTKmKZkNCDPYFyZ+6IeI3YMJM4xDNL6IvSBwjwYfmAO/HhWMl9jamE5/KC1lHgtppifoqfSSXAarMFBosY7K05UGhndagnAixOcu0kJCKTyMGrEKW54M/egUo7zFXUqGaroPIslY3NJyNvo8/QW3OOEOag6EgxAh0KXyLeHokjPaFdpkYgbs1uMt236gq+0hA46wr08tGs3bqcrvlKM5PHCtQTbPKtI3VN4xZWfz73Re8nNo6tlMnVGsIuTY3y1F8/ovo7mvazyyQ2er/K/BuLlntxUuPI6ik8A8tNP7LbNPTp4JlmDw/yxINYRBY/rvqtGz/IQi+VBQjCrl+mddr6W++VkEx3272a7YhX1Zu2AYILSrN1ua+LV2N/oxjdxhzjVn/H6iGm8SCgrNvRICb0Dwm3X/W94N8Dt7FEMiL7FHwCrTA7Hd27QYijN1bdxBdAfnqw5tpVv3X5DJr8C58qeyf481T/irXvJegiCfihypttQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6666004)(6486002)(6496006)(508600001)(2906002)(6916009)(186003)(86362001)(5660300002)(66556008)(4326008)(316002)(38100700002)(8676002)(66946007)(107886003)(8936002)(83380400001)(66476007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3zgukSZft0hDbx7qjiSJFdKm6onSCyOu2hRdf2Gh55lPsKtzxpPiT+Tb3RGn?=
 =?us-ascii?Q?dhbFM7LBQpGLZLg8jfW+SOg1CPDVsIG04sFO/vsaHYZmHyb5Y6Sfe0/6D32f?=
 =?us-ascii?Q?M+9RhDiiGrtsNsDSqearvf5LkI2vQx+ZxmTD8H/wnXOOceDFnIsVKhJHSm9F?=
 =?us-ascii?Q?VEZb8GZ3XlYzZUzlTl1dPVC/LdzLMC0c3g3KYC9hlH4vhjXjLYHP0fXzRqnx?=
 =?us-ascii?Q?IylA2RGwnyyz73whY+RcTENszhbgqTlr29XqtxoenVZCZZhxf7Xe9ezBJv60?=
 =?us-ascii?Q?xE03QZjubmCFWN9W9fkQ2LUggmyRLdEaqDgMYbPLHJRiCCbvt/gH1mKtGCZm?=
 =?us-ascii?Q?KzUey2oQ752awUk6Scn8zx/I2RtiZ4kXC8672+nbJm87ePjBNx6mngt+pSak?=
 =?us-ascii?Q?z0L+ua5vSAXDfZYxAWveAIEn2CtcPUC0Kz30WSOmaEBrxi1zDMt05odHpkSI?=
 =?us-ascii?Q?kxSmIffyD74MSRKhv9+8y4cDGsZC9BhbQNqWNOKP9p13CQWjn0T4aAxpX5Ss?=
 =?us-ascii?Q?SFtBxevoSlD3MD66zU1odwrikvKIzXRJDgdSfwJXo7Blh4RzWrj3JC5iKDSP?=
 =?us-ascii?Q?TFcJJCFJbVdmNl9Q/VK5pPtenXzUtSZH2jtqeUeZQElv8RAdkDmk7Qiu/yoi?=
 =?us-ascii?Q?DRbvpUN1QVeyCRNEeYQG1huZ959Kd6hMeGU8u6AlUe+a2PfDqzZpslH4bktp?=
 =?us-ascii?Q?g+50uxL7/ZAS3ksJj+0X+ChgFRYYy35yWj+3Y5o+To7K/2ABxIE/2ZJvPTxm?=
 =?us-ascii?Q?NvaF9EpU2RdHF8sPQoilAL/oJNlCQB08sHPGO4OnqHuK+bcfEysaJs9aCQNS?=
 =?us-ascii?Q?83uDO7e4Indqc9XCkN9Pcn+vQzDlstQivFrzu8AJhTmvG0+gv0WO7V0I4nnb?=
 =?us-ascii?Q?1GFhE5+8Wrrxo2s9xWowMXgSB/+mp16s+eelonBvr47r5LRDkpAwQctTW3OF?=
 =?us-ascii?Q?hFi1+EbDF0hG5AbvfZx0mwaTZINsd8s9hqVw7guJALaIspnopj6GjUali1BH?=
 =?us-ascii?Q?kq5lv1AalNNSSXognp2JoVutz91DrhndCYgvaxT2RlBSjuGzfPUGl2GSh03R?=
 =?us-ascii?Q?Xt9tO+4GPb07Bd5dhBX53tj6RtxG/9mxC/LHmT9V0koQyR31Vz6cp26BfREn?=
 =?us-ascii?Q?j+EO4VuhpNMy+2SmkPrH3U1D4FizbyQTuQJZ/XI/k6fMlENLHj9+3oT/HUYE?=
 =?us-ascii?Q?nIi48iBF8F0CUFWzrO9lEZ8QY3LnuXN3Go8GAypSb3wLl3kfPWXCWOi+Q82K?=
 =?us-ascii?Q?+KpO8OnNSZ4+rc1fQjcaMawGA5AhC8JrMwwtjo+l4DB8Mz2QmV5fcNvWOIrE?=
 =?us-ascii?Q?TZkOQZ+jx/HFlQ6CGTe7wW7jhUIrqJY9YE4InGbnVtSt0N8Cdb0vqM4CSlFU?=
 =?us-ascii?Q?c2T/VC/N+gFCRj3ZLEhQWcplI7GqwQaMBscqOSPRWPngfnvYEJ2gVlk20BP+?=
 =?us-ascii?Q?t8uOYjZjglBRxgGQ0E0GUhTj7pBgxSitkJ5qw2jF+ai228KyIcJJ73cfgq4L?=
 =?us-ascii?Q?PQzA0JlIKQDPXQWIlMHwMs48fIimCnV1u8F+VGFH2kcaA3u3leh+QfJkpvH+?=
 =?us-ascii?Q?9LxWZn9upJtKXzW0AW7qU0bSxiH9zMhcQus4E53ps1IXxhKk9Qb5gqIaY8v1?=
 =?us-ascii?Q?+Gr92/uChamDtCZw7O38zYJqL9MyoQCylNSrL0eoQp6xNODcqgc34IGehr5o?=
 =?us-ascii?Q?ziBKvz5uGyVbhS9d8cW+vY0sl/o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399f24cd-ba36-4003-4581-08d9bf0db82d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:29.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ibj/79thuWUkzs/ge1OnzevWf0F1vTYoqQUCM4oXwakdo4P0AbtAbgqGuEHW+AsN72wmQ5JvFuF7a6lWiWv7yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As part of 'can_offload' checks, there is a check of VxLAN flags.

The supported flags for IPv6 VxLAN will be different from the existing
flags because of some limitations.

As preparation for IPv6 underlay support, make this check per address
family.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 31 +++++++++++++------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index d018d2da5949..766a20e05393 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -10,9 +10,25 @@
 #include "spectrum.h"
 #include "spectrum_nve.h"
 
-#define MLXSW_SP_NVE_VXLAN_SUPPORTED_FLAGS	(VXLAN_F_UDP_ZERO_CSUM_TX | \
+#define MLXSW_SP_NVE_VXLAN_IPV4_SUPPORTED_FLAGS (VXLAN_F_UDP_ZERO_CSUM_TX | \
 						 VXLAN_F_LEARN)
 
+static bool mlxsw_sp_nve_vxlan_ipv4_flags_check(const struct vxlan_config *cfg,
+						struct netlink_ext_ack *extack)
+{
+	if (!(cfg->flags & VXLAN_F_UDP_ZERO_CSUM_TX)) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Zero UDP checksum must be allowed for TX");
+		return false;
+	}
+
+	if (cfg->flags & ~MLXSW_SP_NVE_VXLAN_IPV4_SUPPORTED_FLAGS) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Unsupported flag");
+		return false;
+	}
+
+	return true;
+}
+
 static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 					   const struct mlxsw_sp_nve_params *params,
 					   struct netlink_ext_ack *extack)
@@ -55,14 +71,11 @@ static bool mlxsw_sp_nve_vxlan_can_offload(const struct mlxsw_sp_nve *nve,
 		return false;
 	}
 
-	if (!(cfg->flags & VXLAN_F_UDP_ZERO_CSUM_TX)) {
-		NL_SET_ERR_MSG_MOD(extack, "VxLAN: UDP checksum is not supported");
-		return false;
-	}
-
-	if (cfg->flags & ~MLXSW_SP_NVE_VXLAN_SUPPORTED_FLAGS) {
-		NL_SET_ERR_MSG_MOD(extack, "VxLAN: Unsupported flag");
-		return false;
+	switch (cfg->saddr.sa.sa_family) {
+	case AF_INET:
+		if (!mlxsw_sp_nve_vxlan_ipv4_flags_check(cfg, extack))
+			return false;
+		break;
 	}
 
 	if (cfg->ttl == 0) {
-- 
2.31.1

