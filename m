Return-Path: <netdev+bounces-753-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D9C96F98C1
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 15:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C1EE280EBC
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 13:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982095239;
	Sun,  7 May 2023 13:58:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7833A2567
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 13:58:00 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A991811B6D;
	Sun,  7 May 2023 06:57:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/iF20N1Z6ifKsdejpbMDQDS48ZyZf/EJqDLkb22BItMHpXTZ0byJAZts3y/a50rxoqJusQCnthkFKwZSGblm196hMALLZuNcqkPupLAlTosAWpufVyqFNgI/R1Qu+aqD9oLc5WNdjNd3OgLEWKvYywzFETMmIeT4eLM2hWRslDNtEhclg7a+6TCnAjqfdrSNcQgHJspkxsgrO0YSbXZTC07ud0PNzS+eDvrEibyMQM3jU7rFxsZnWuiLmpPLD9V+/k9ovEIJ9LbyBSyF/3XozbrhgD5N4gtlb4cI/I2oVhBXk5WPVEw3kyqA/kyIPW8SzOZdVE389CiHHB+MX41zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRJS0KNyc/MTvVBvE0iGyeJWIaPr15T9xBvjYYxV5AU=;
 b=BsifZI+uydKiDbzY8G4zfTmJ9dkbtVUmV9alXjpvpsGZd5bGCoHRiSE570NlNDgtoS0ZdIhbCu9i/5RQK+b+ZLHKfVmsN75FigLrkmqVsZBEaoWOQ//Jx0olseWV1Gm3gTh9FFJF4OafTTgiY2+omlI+QenDSUFuvXrvjoZUnMmoARoNnc2h5ykwASoykTppU0DPsWa2KbLlzMRVH1JzymeSzSI5DmRzkTaH5bqQ3NUgfSb5aqF2t1fnYuRYVjwnwjLAtPwMuJSm5bBliZ+zPh9Ae/LD2MYhYC85vssaKvpj3ZxXhR1EkK1bEPIFA5Zrw8ZqWaAuW5AV33yJS/2NCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRJS0KNyc/MTvVBvE0iGyeJWIaPr15T9xBvjYYxV5AU=;
 b=DM7rGjDbr5MSd8f/FMWKMvDACuIzijGAzSM0YYu8+MgVBRlzC4oFMG9gqvmEZ6JP9Y77gy0zIktdgHbdEJ+bNt97VuaLzyTbKGPL0hdlvREsJS2HZWu0tIvoAHDmmjBXUbZWuz32TphwECENK3BhIESpl/WL+4LdF/ddjQ0TMKwhVzuznONZh5+osW7216/AZaSv3Z4p+mYjTJb/wWVvfOT+mrwf0v8WX9hFMU4o9tocOp0Rq5Zhfn4z/7/rJWmwrs4GWsx26YUl5V5Gtev046Pf2H1TJv7BYJvixgk6MiK3M395Rt2omGbccM/mSyet5BsnQjZ9t/kqjHZgf2HHTw==
Received: from MW4PR04CA0215.namprd04.prod.outlook.com (2603:10b6:303:87::10)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.30; Sun, 7 May
 2023 13:57:55 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::7f) by MW4PR04CA0215.outlook.office365.com
 (2603:10b6:303:87::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31 via Frontend
 Transport; Sun, 7 May 2023 13:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.31 via Frontend Transport; Sun, 7 May 2023 13:57:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 7 May 2023
 06:57:51 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 7 May 2023
 06:57:51 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sun, 7 May
 2023 06:57:47 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, John Fastabend
	<john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Gal Pressman <gal@nvidia.com>, Tal Gilboa
	<talgi@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, Roy Novich
	<royno@nvidia.com>, Aya Levin <ayal@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net] linux/dim: Do nothing if no time delta between samples
Date: Sun, 7 May 2023 16:57:43 +0300
Message-ID: <20230507135743.138993-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|SA1PR12MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: ff812044-c2b9-4a76-219a-08db4f030e6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EyWxR0YtU6CnJuFsfConf78VfdfA6DpdhO/SaPdUustgMsY716wOhmUHHUvOknQctVQkUwOTBZIChpxk8A1G+tIbDZ8YOKR89XFr2oaNd9xHXi7hPX1FZ6SfOTGLvjmqLh/gYmXXzslWwe1bJceHz4yUSv0S5lCdehlgvVT4FH3O1shz+A6tLFzhO2vSlkzzafsg1yDd3vnL0UrK9btdVhxnd5aW6zt2BvYzuTyAATiR/+FhKwr3e7SLuIkvg1hvN2Skc6AmC5chKF3DpDDJZ5+HNxny4U9Oa4Fl3PtanJ1KhhBzJhCEi0FFBMyyNQZA/kEmM06akBifxtEdiI/ZEpQWXESW8PzxH8aXotR9Pkd4qJ0XNA8u2Reklw4b4eXggJBwKzdKq+W5LjbvC0NXeK62l/0hBD2y/0EaVRuMBbVYaQbItYZgZULX6a6cTzfCr4eVcPMS15KRZqumVOEyWjbc4HQL3YRtSs79oSYS54dsCZyZ61Ly5KSU201r3KBTXlBDHbgFU8xjRzS7epR6qnFCnzD4rE3a9o5ITjeXW+8nl5kAG9+cxSwRfwzKtR4Bwa5vTOB/dQjd7b2tE/bEhmldkQTNA9T3ZUJ0rVud3ZUeOg6M0/xveC8kOpTH2AjGb5zsCpyz4sKs3cUb/gOz6STjoN/dYDCO8La99xwJe/qpgtKH4sXg3qIfKBA7ZNsy5J6VsRdKFcpiZPR+oiMNhA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(6666004)(7696005)(70586007)(70206006)(4326008)(478600001)(316002)(54906003)(110136005)(86362001)(36756003)(47076005)(426003)(1076003)(83380400001)(107886003)(2616005)(36860700001)(26005)(336012)(8936002)(356005)(2906002)(8676002)(5660300002)(41300700001)(82310400005)(40480700001)(82740400003)(186003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2023 13:57:54.7361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff812044-c2b9-4a76-219a-08db4f030e6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Roy Novich <royno@nvidia.com>

Add return value for dim_calc_stats. This is an indication for the
caller if curr_stats was assigned by the function. Avoid using
curr_stats uninitialized over {rdma/net}_dim, when no time delta between
samples. Coverity reported this potential use of an uninitialized
variable.

Fixes: 4c4dbb4a7363 ("net/mlx5e: Move dynamic interrupt coalescing code to include/linux")
Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/dim.h | 3 ++-
 lib/dim/dim.c       | 5 +++--
 lib/dim/net_dim.c   | 3 ++-
 lib/dim/rdma_dim.c  | 3 ++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/dim.h b/include/linux/dim.h
index 6c5733981563..f343bc9aa2ec 100644
--- a/include/linux/dim.h
+++ b/include/linux/dim.h
@@ -236,8 +236,9 @@ void dim_park_tired(struct dim *dim);
  *
  * Calculate the delta between two samples (in data rates).
  * Takes into consideration counter wrap-around.
+ * Returned boolean indicates whether curr_stats are reliable.
  */
-void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
+bool dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 		    struct dim_stats *curr_stats);
 
 /**
diff --git a/lib/dim/dim.c b/lib/dim/dim.c
index 38045d6d0538..e89aaf07bde5 100644
--- a/lib/dim/dim.c
+++ b/lib/dim/dim.c
@@ -54,7 +54,7 @@ void dim_park_tired(struct dim *dim)
 }
 EXPORT_SYMBOL(dim_park_tired);
 
-void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
+bool dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 		    struct dim_stats *curr_stats)
 {
 	/* u32 holds up to 71 minutes, should be enough */
@@ -66,7 +66,7 @@ void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 			     start->comp_ctr);
 
 	if (!delta_us)
-		return;
+		return false;
 
 	curr_stats->ppms = DIV_ROUND_UP(npkts * USEC_PER_MSEC, delta_us);
 	curr_stats->bpms = DIV_ROUND_UP(nbytes * USEC_PER_MSEC, delta_us);
@@ -79,5 +79,6 @@ void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 	else
 		curr_stats->cpe_ratio = 0;
 
+	return true;
 }
 EXPORT_SYMBOL(dim_calc_stats);
diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index 53f6b9c6e936..4e32f7aaac86 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -227,7 +227,8 @@ void net_dim(struct dim *dim, struct dim_sample end_sample)
 				  dim->start_sample.event_ctr);
 		if (nevents < DIM_NEVENTS)
 			break;
-		dim_calc_stats(&dim->start_sample, &end_sample, &curr_stats);
+		if (!dim_calc_stats(&dim->start_sample, &end_sample, &curr_stats))
+			break;
 		if (net_dim_decision(&curr_stats, dim)) {
 			dim->state = DIM_APPLY_NEW_PROFILE;
 			schedule_work(&dim->work);
diff --git a/lib/dim/rdma_dim.c b/lib/dim/rdma_dim.c
index 15462d54758d..88f779486707 100644
--- a/lib/dim/rdma_dim.c
+++ b/lib/dim/rdma_dim.c
@@ -88,7 +88,8 @@ void rdma_dim(struct dim *dim, u64 completions)
 		nevents = curr_sample->event_ctr - dim->start_sample.event_ctr;
 		if (nevents < DIM_NEVENTS)
 			break;
-		dim_calc_stats(&dim->start_sample, curr_sample, &curr_stats);
+		if (!dim_calc_stats(&dim->start_sample, curr_sample, &curr_stats))
+			break;
 		if (rdma_dim_decision(&curr_stats, dim)) {
 			dim->state = DIM_APPLY_NEW_PROFILE;
 			schedule_work(&dim->work);
-- 
2.34.1


