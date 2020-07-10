Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1651221ADB1
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgGJDsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:23 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:20294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727092AbgGJDsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koc5uNhEYkVNWz5UqM+kN5tevge/SRxSTJUK5PvvQm8oZ/FO9LhH9+hJQM9IOImvxHUBHiOdvuYi2Z6LF94Gtl+DLpErSFHO4OpmutEQKtL+eOpw+eK43mL4Ok2N/zgvW57sOGeAmi9Qistb2/sseLYdWgImrFoDsubxxSyD+xCbyRn8Ewt9wrFctfhatdgO9xuIYp+WvdyjmlW/yIYgD0xvlQ8x9rqQSU0qeP5/t2Co7mGFXoW+p2NgmrgCAzUezRsBHkB3d+As6wNfgBf5i/wLZXoBvX2kVE0ltcfmb4cVmLBeJD1Bs6DVipG1o3+Q0ALfpbfvzUF23m7hJxDu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1P9vinXFOnr2zhTqt72YoXmnVscZ9TK+3gCejPkgUWQ=;
 b=mGslqrncSTEm17Sa2Dj07Y3MjqhUbrECNy9OSjRQqBgMZ7qe5QmwNdGEB1IkFaWE8YA8VHX3oDXJ712zVQyyNEt6tlpCZuTzkKrw4yNV31Aoe8Z/EevFqL/ob/XQGrZ7/nRTji0Q5fZllhLVRftX2WSMMmDSI51oCpDL4eFlFoZ9ZzDqTIiyl207KNqlOJLY+gIBVhf6l/ZSHwN/ijGL54qJ4fggRKG6OpTIvS5xkweUvxf+7Xa4eZswmJ+/7ILndN8C3oWESRPAKL7q5vIWJgI8RQ+71bilQYrPVTVd/PMLhamNpDrdQqMdtqQN3OCO7ZVLnZ390Pq4rmmFnNfGaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1P9vinXFOnr2zhTqt72YoXmnVscZ9TK+3gCejPkgUWQ=;
 b=aI9/qOSpqkGmiM7g1TXjIJ+AWxroqkX5wU4kk55HL5+3jtwOuFuLB/dcMvZ7JbfViS3FgPM3kI+XcQhL/0LK4DVJ0SDofd+vVMlJ4jOeH9wfkLD93RlesnplKf/7e7KO004tgu3+vhe6K7rSG9WN0u3S35bwmBAorAZ5rX29yZI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:48:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:48:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/13] net/mlx5e: CT: Expand tunnel register mappings
Date:   Thu,  9 Jul 2020 20:44:29 -0700
Message-Id: <20200710034432.112602-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:48:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 75995f8f-9c7b-49e8-8e33-08d824840bd0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45121C0CC22366685AD04B61BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTkPsOPwJ6BCMf1PlTyolIGfse9iKMxP9alIdSGRMzimael2bVfoudYOq7t2/pTWHfEDB7KI6O+Nx1tLl6CrC7bNmwWC74WzmN0UCfr52SzNSMLMqO59cflVbjxHVmH/RjQhGjFSsSW8kBxQzLXHEpyFLWjPq/qBGOEK1azXEVyNSB14+7R5cbRfbXjuhXKzUTaTKYUFil5g/O87dV3i/FlVlQnw2sMvr1D3ru3CQSz2XV0htifvic6tlITglLFmiXmK0ByKKcTz8vBm+DGVNPtXPCYa+lEhe5Rd9e/8KImfVnqNwMjJvuf/kYSbbK+Bb+Md2VuoRNfZ8SIAstPi76hu/ubCs4LB3XKjQzyepdRr63ltcN7lw6MJDYTLNnZf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4swCEy+Q5SuNwjYX+A/kNVxkq/5P3QV46WvRSfaOd4c3HdhHfoTalBJ+BhmCwohWbx4k0b2k3vQsmR/MwcsGYRbC5zYKUmSk8BMIpQ1feSp7T4Gk470obSh4FtDTJZhw+ho6S+QiQuS36zMYtrnyR0RU+StpuPt2sHDQwGyQIwaWe4x/IkWk4BTap9QZFR6b9ARKXvmxlt/mBVq7k0ew+NCnGK3CKvkygzWAB1zBwzmomFRZEd5WpARYbwoyYwe2yLwYOOUhSOvqDPLPNqkfD2k6TZRs5K8GNAcRfj8wVITT4eyYGkIFRFgrS06+oRBxX/ve54ORPHpRgKLscg4qYsHMfl+wKpnE2MfvIujOdFoYT32I4re7a3+iuMm+IxxuldibY9ctNAJJMmWv33/xnesPoFI2CwY6rYyDfrOgG+XxjjKTbWioNnB/psXUD47BimC9WnIEFWO/hGwMAbcsZNEuNPzQAi++qE4Veq1+gLU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75995f8f-9c7b-49e8-8e33-08d824840bd0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:48:02.9113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DQwhV41J9DM+INwzd52cg3s8Pf2fUIjPIX3Pa7EHuyg3dBpT4kE10atg2bQfHbi29OMx33XMoUkkwuZ94/ylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Reg_c1 is 32 bits wide. Originally, 24 bit were allocated for the tuple_id,
6 bits for tunnel mapping and 2 bits for tunnel options mappings.

Restoring the ct state from zone lookup instead of tuple id requires
reg_c1 to store 8 bits mapping the ct zone, leaving 24 bits for tunnel
mappings.

Expand tunnel and tunnel options register mappings to 12 bit each.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3814c70b5230..fa41c49691a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -180,8 +180,8 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	},
 	[TUNNEL_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,
-		.moffset = 3,
-		.mlen = 1,
+		.moffset = 1,
+		.mlen = 3,
 		.soffset = MLX5_BYTE_OFF(fte_match_param,
 					 misc_parameters_2.metadata_reg_c_1),
 	},
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index b69f0e376ec0..437f680728fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -70,9 +70,9 @@ struct tunnel_match_enc_opts {
  * Upper TUNNEL_INFO_BITS for general tunnel info.
  * Lower ENC_OPTS_BITS bits for enc_opts.
  */
-#define TUNNEL_INFO_BITS 6
+#define TUNNEL_INFO_BITS 12
 #define TUNNEL_INFO_BITS_MASK GENMASK(TUNNEL_INFO_BITS - 1, 0)
-#define ENC_OPTS_BITS 2
+#define ENC_OPTS_BITS 12
 #define ENC_OPTS_BITS_MASK GENMASK(ENC_OPTS_BITS - 1, 0)
 #define TUNNEL_ID_BITS (TUNNEL_INFO_BITS + ENC_OPTS_BITS)
 #define TUNNEL_ID_MASK GENMASK(TUNNEL_ID_BITS - 1, 0)
-- 
2.26.2

