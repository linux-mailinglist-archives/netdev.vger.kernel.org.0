Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EED1D5C22
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgEOWRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:17:30 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:6026
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726226AbgEOWR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:17:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNK9KEDEWwhvShHJdGpm8rzqfhXZCbkhLjTPiLMW6OKbSwrohUAjPABiBngzxPQYSInnfTWI+e1sIO4uOoMdzXjkqR3CbwIp3j8ddTpFXeJzsG/BsqJuS1E5K1BsRh5bM0zp7wAQYtY71PPynkAdleB6+fPo6C/qACOFdiRN9O62Ix87qqijWjZGKGhGttyKTdpY9tCTMI3goepCPF197TJ8UiJocvCuRczsWeN+Ay+0N50YMzEmquVxduDPRuLGEbId5mRTpI9Qlqtc4i7Oy3wajDytiCVMiuC8u3H4fIgwvPdHxB9sDLFpZhhvWVkCtVSqZjRrmsZ9QoiBzU8ALQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ0m82lqCiXtfXmRysBMJRQFCxqNP0T7BVXgAs5nuDw=;
 b=bh/q3JTDz+sYv8Xn6RdDFRqPPcStM/ee9QjpRC/wsRBYbnTlT/mPB62BgjUKwsFIoH5FR5Sr4mQp7+JgadP9hdF2md7blhUmPL+lBQKZZvu4MAVZlQrW4lZcaJ6Qt4QTJ6sESIpyk7JCD+fPXyxKMzXpwM5GHPEz1cNJte339DFuj39/wsuatplOGNkEseqjYIO0qEus88I6CkC3SvAceDzkLOAPq4shB2baNlQMAi2uPCnGl+uXuz1eVwFolbdhwtzoSaGGzPKoCDRFlVyWOp18wtH8rkU57A4Kp6pQ7FtTeIsD6QJD4Sln7zZIyczFuW6cZGLOixR3yVxikpgTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ0m82lqCiXtfXmRysBMJRQFCxqNP0T7BVXgAs5nuDw=;
 b=I5BKbqOB2UC4AWdPNfRFmeX7ztou4+Hi05A6CUnpMvrgKWwuQ7dEBAzRVh/iBhpc24Hqt1IKZmbtcQZBmVQt4QL3fTrX5dH6aU7DrJ8+Gph+521jiD167aGzj8fc576mtwoI26YtWDnavD7+cajNejt1DFa4dh+iyy+R10KlC8k=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4301.eurprd05.prod.outlook.com (2603:10a6:803:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 15 May
 2020 22:17:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:17:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Raed Salem <raeds@mellanox.com>,
        Alex Vesker <valex@mellanox.com>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Cleanup mlx5_ifc_fte_match_set_misc2_bits
Date:   Fri, 15 May 2020 15:16:52 -0700
Message-Id: <20200515221654.14224-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515221654.14224-1-saeedm@mellanox.com>
References: <20200515221654.14224-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:17:23 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c96ce904-a496-4bde-1795-08d7f91dbf43
X-MS-TrafficTypeDiagnostic: VI1PR05MB4301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB430108A798CB2954E0523429BEBD0@VI1PR05MB4301.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/Bt4XsJf3gBwzylcFQh+zf4wxsn/meJS7s0Bef66spLWL0nDfhDm3DiCZRS6JCWvtYP7elJ/WNIUdhcCe2tnHkqqXUj2HPC60lCwnVDQaiCp0h0V9XFt3qnzs8mzCgxsmPbyQ5Y7zsjrsJON7WajbHrSWgg1moNb/ycs660ObjZ+pYN1e6+R6/8evZyaV2l4XzbGWp1Qf3rl7EdC9n9GAhS5j8m34LYapyNfOR3+imA3iXoy23DYRGXBQzhpOL0qMdfkYyHyKYI3X735QbMRpcsekRU8Mk1OzCZyIAiYl+NDBc+vjtOcaPOZ4FzGuDgSpWT4BQBCxwhv8HNNtefyPTHg6xe8f0J0jl++RJuREKBUrqwFIBW75IYDAaet56GU//H0qtNrCZXDExQqo775wzv30jyns5s3cFpOP5NUP2k1xwvFtJgPjou++j5/5kQHaS58viaqUrBMFjn/VteZaOLwETwh1HWyKeB3Yeim8TCJiLluaNT68mOxg4QgOan
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(107886003)(86362001)(6512007)(450100002)(4326008)(8676002)(5660300002)(478600001)(6486002)(6636002)(1076003)(66946007)(316002)(66556008)(66476007)(110136005)(54906003)(52116002)(6506007)(8936002)(16526019)(26005)(186003)(2616005)(36756003)(956004)(2906002)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oNygDZe6XEft6vGp0qwLsFKJ10LBvM60BHMnPthjusOhYsY082bJXYh7WIW8URmwSFPr9oDctHLxap3GRl5bQ992nZpDeaBc98QAdLDv4dL5vRvYBTHCG9K79VGsgkoUCE4S+0b1GtTchTGncrtyRb+AGVs5r1Cz3myAWcupnI6Dm19NABGCbv/ElKr+4XtHJ/IJknbnPznWxZOdH1q8ufRAHa4Cmnzh/95MXrCrET97ixjjIPhSJWkOkVlIqogv7X4KL2YQ0hC8lsva3hFxbKbv68JPV5OWW36sGfh4m8CL82n9a/aT7JOJ3n5MDCTGsuT5y+pgKDjR5G3RsGUWjBbH80YuDPDQjcL5/dB1tRrYXsCO/AxNbagOSQ97sBd3tu6ULauMJsLElsT7IP3RKse+Yk1kxsokPLUl016hkfGdtWbGW58M3egWcNF43xZsdk0R7BJA7w3vI9/YsseQkAQTTk7xmvt7dW/w545FKYk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c96ce904-a496-4bde-1795-08d7f91dbf43
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:17:25.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzFafNDj4HOVhPmdYYkasTEaNNbC6Na5By1SmHayupK9Niq6kZYhV8ZkDpad9wknOXEFU1mabLgH2wE5Haeh8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4301
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Remove the "metadata_reg_b" field and all uses of this field in code
to match the device specification. As this field is not in use in SW
steering it is safe to remove it.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c   | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 3 +--
 include/linux/mlx5/mlx5_ifc.h                               | 4 +---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index c0e3a1e7389d..78c884911ceb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -961,7 +961,6 @@ static void dr_ste_copy_mask_misc2(char *mask, struct mlx5dr_match_misc2 *spec)
 	spec->metadata_reg_c_1 = MLX5_GET(fte_match_set_misc2, mask, metadata_reg_c_1);
 	spec->metadata_reg_c_0 = MLX5_GET(fte_match_set_misc2, mask, metadata_reg_c_0);
 	spec->metadata_reg_a = MLX5_GET(fte_match_set_misc2, mask, metadata_reg_a);
-	spec->metadata_reg_b = MLX5_GET(fte_match_set_misc2, mask, metadata_reg_b);
 }
 
 static void dr_ste_copy_mask_misc3(char *mask, struct mlx5dr_match_misc3 *spec)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 984783238baa..71fa01ce348a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -554,8 +554,7 @@ struct mlx5dr_match_misc2 {
 	u32 metadata_reg_c_1;			/* metadata_reg_c_1 */
 	u32 metadata_reg_c_0;			/* metadata_reg_c_0 */
 	u32 metadata_reg_a;			/* metadata_reg_a */
-	u32 metadata_reg_b;			/* metadata_reg_b */
-	u8 reserved_auto2[8];
+	u8 reserved_auto2[12];
 };
 
 struct mlx5dr_match_misc3 {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c9dd6e99ad56..fd8da4875ea0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -584,9 +584,7 @@ struct mlx5_ifc_fte_match_set_misc2_bits {
 
 	u8         metadata_reg_a[0x20];
 
-	u8         metadata_reg_b[0x20];
-
-	u8         reserved_at_1c0[0x40];
+	u8         reserved_at_1a0[0x60];
 };
 
 struct mlx5_ifc_fte_match_set_misc3_bits {
-- 
2.25.4

