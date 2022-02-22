Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0A24C0001
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiBVRTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiBVRTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:19:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78938167FBD
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBTTe2ANpwNV6NJ6xTbIlP32snaiC32quZ4z2f1W7jGzNhesBY81SjYBuSLqxSJZVn7N9Kdyr0mLtLz8vW75bcgw5s0o242ouUE+Xe+FVoTZFKwWfHMeU6zVr2FHZgksZINaohHop09ZFpc5rglJ/IBFbOOqSJUL85oHh+Ll8ZAapwxRuVa8kyjOM59NjWQHU71KdF3QwN08HYKjIM46zA40VvEAmc/5g/G8xuMszLAwpioDMzNGNs1gS9KXUTJGjdcK5Ad+Z0F4A2/3w+iviDNi0Lf8DFDcnNlW6fKulXYWO23X4BFGTHdPToR65QfikAgdiQIHf6Nb+AaOyUzmmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAGkmLvUmz+GSb9yzZT8581wD/K4FHoZyqL4nn4vLek=;
 b=faO/8j9Ue6KjU50oawgcoWZz21AQQk3dPbLPQzei8up4QPeYXgFTcVVXh1fif8KnLMJC9MFSI0/OEvty4Pz3TCxByqIa2md7KfA2qCLvnwDQcRbIYVmNMO/ZG7jcAsKhbPmT5trjHZjIwm2eQRSiVs8qwGh6TDOrfxf/8N6V8yuXVW+tobDPPcAzuqVZnhf4ck5Of8Kj7c/bsO2ftG9tsv1ADgr6cJP5UAylHAXaoNNbZRJEOYOoNgD1k1qwUJxYgo5SI48DhkE/vL6V2QdaTsFg6msHyrJPaL8lgop/c9bWtYzj02eOM4XE+aLxKEuToDUK0cckVRiB+WQKAhDpCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAGkmLvUmz+GSb9yzZT8581wD/K4FHoZyqL4nn4vLek=;
 b=dp0PCXxkToPEUGqrNtyntwUwxfICtv4GfY4QWuJD5nsuEKLvoJSxuBVu76bvvo2SoN8AYVGIaXVcChLkiDBLDBrOKy0H+V+x9gKorWSPeAkd65MEyLqabxZwcVDyfXTabbtZ940y4+/0jCUS0weHyWOhJ5GXoJv+BRiunr5G80tc+mjA964ukAzsCQSr69I5kmyQCTAG/Xnp7+GfjJgOPeMVg9F7KLbAJ8qoj9oSBbCwNGgL+GeTpomtmMmqgFznz7BwfJW+WIhDSL7LsCPMjLtza5CCrHVv8MvdAC2/j5DmAKngERd2zqE+MA3bFjFM8lT3v29UUx6q9o7foWCsHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:32 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/12] mlxsw: spectrum: Remove SP{1,2,3} defines for FW minor and subminor
Date:   Tue, 22 Feb 2022 19:17:00 +0200
Message-Id: <20220222171703.499645-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0312.eurprd07.prod.outlook.com
 (2603:10a6:800:130::40) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a57bd6f3-b1c2-4628-e795-08d9f62759c5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42627C8395E7D00B825591F5B23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gyiLrlZeYUK+xxgu7j/5zTYsRHkR9YTl6SqiICuvpZQbWX61XMBgHAowVCBwivF009y2WLbWi4UOIOYizppUfpGNRJlBm98ZF9kVzrdjojvLORS/yoCBLIK//Gx6ldfk5lPYB2ZSJVLf2QdYDzvJPChjoM9xwtjhFRoTABsx3LCJgQ9W0BGxz0bFWhyCtn7jmmo+S+xqGm8g14t4HzGUxWvJCMeNBZ1ZaNKNvHku7JiYDW1U6QdEhU0z+Narmoy1FciEmeflK86oaSZTEgk+JsXRGhVdyHxLTpLb2RMbSQwLXh0eE30Pkgj/pLAFngxWvcfQ+/xqz+NQZ+WOqqfdjcXz/NtM1s7l8YHUm/FnXblw0lwb76/2xpdnuETX3bEpzEtiTVF0/OJDOH8f1Oc3ZA4hhJLr+GKKZw9czT0rbTu/gNIYBuDtGzMw9alm8olW/YJgcpwwmqKnPeSQfZ2EiLcxMO+RumCOSBdMcNGcGVtKpkogOAKWxpjjEJohObNXljWZA1Tb8XlwTCsZQQTctADyu+X6NoHLDcvRJusc/WL2jVxrf/UYgD8CxRfWeY9Llrdi4CE39ynRH23Z61v2BfqROJNCn1/nEXyD02aPV/9MiNlAQNv/zCLPSwKTKkgX2aM3/gJQrUvry/CUBA1+LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UYVz7yGbIAgA0S9BoqiFT3jL7KJ/ikrVPSrAY41VQZMyKBdRvnXulenQe/9s?=
 =?us-ascii?Q?8KoiKIAVnHzLV6sPIsYJJa8dzr5lJEqEW293Hmqmljgx9hgJ1xvy1p+ZOsDS?=
 =?us-ascii?Q?5+DGMnPPbhhKQuIWfcbziN/dAZHdTde6tY4uT/Q/kCPEmUmfRDjOvk6PrBtP?=
 =?us-ascii?Q?Iw2FrsEaC3z2ea6culXyUxfjSKRkvfIHJ4qJsDwslTPhAByYzdiXPlMb2FT/?=
 =?us-ascii?Q?hPnowEiRpJX14sXU+93MbjDI/3jfd4axxJUpciXob1bRrX5vQvF9qIyMXvTJ?=
 =?us-ascii?Q?vJ6id01NrhKhWUjaawzdoF9nU+yn/f6NRYOT8n1n2aBtXlimK1GKhl0HfMQ7?=
 =?us-ascii?Q?qM2RYtmjFPToPbbunhTK8+aT7PKMgawrTGmrV8vrjPF+PGjV8sjMbTBMf+H+?=
 =?us-ascii?Q?SeciSStGW0yTsAuD0cagpEJqnI2xDIMp8uJIdw+eHIRDDFnWj2KIuj7iscIO?=
 =?us-ascii?Q?QLrC6vpGlgBMI5YHYIUaOEMmW8xoWX9SuM49u9gGJZTOUe6n3M3G1pQJIBuE?=
 =?us-ascii?Q?lOOUWg04JR7V+6kSqL8sz9bETz6ibrkA6Ot1oj0n034DigwtGJSpWCiGZbit?=
 =?us-ascii?Q?aCvrRfKdvvcHiOnNPrCg4aBIr7xkDj7VGIGH2vC/DNEgWh6qw5KY5v8OYJMx?=
 =?us-ascii?Q?HXoUGE5oAiTm4SpsdMW03ZqkOMGqBzM5+QjQPk3iJWe/stXDtIfkxycYDZBn?=
 =?us-ascii?Q?7gs2nu2EFcC1Rwt2IN+RYPWfedsWiqGTNp1W9k/azWIPZs+/vvjivaz/ynOs?=
 =?us-ascii?Q?05LZO1M96wHp+VBb68ija7CZS286S4wJ1UJ0eBU4FxjHMHWq7e7ekulOAFQz?=
 =?us-ascii?Q?v8ls8giGO//HNyClyFQtEBRRkDpTf+1r4pYiat785AAd7JVz1W4kqvrZ9t2M?=
 =?us-ascii?Q?XmL7vhfqNpLsYqGlJMhCzbz4NVgcb3Z0hdvTCHDOi92I6o1YYDQ9/qzT7kmB?=
 =?us-ascii?Q?RrBHI1eUTIQG/Hs2X46sQ40x1XzNM4BP2Fj2ArWZIsO4IdjU0rdj7UaNZxkK?=
 =?us-ascii?Q?ov3oRYTG53wrcxviGFf9ZNYhyx1bug4bB3MeJY/snbEzcZ2NSCWzviNFVn6i?=
 =?us-ascii?Q?CoZUeFnkP08xMtvHQ5dCRufjhBhaa9xyrOoP0d7HJjSSRlEiZOeUMbrRagEn?=
 =?us-ascii?Q?oOR8tZRQXXWPDgSNXHAXwavRxB27oMGwEOU+r3Q2plA86yT9vcu0msKflDRk?=
 =?us-ascii?Q?x8w+PeGtI1VjLiMKO6ukeu9ORufzQdx9TCo87qqLuKHkgRCrUe6UtAyNHArY?=
 =?us-ascii?Q?PZlnOYlfH1TsJZcQs8oqWpLIo3am6shiDWpeTGbHpkRMjQSc+dUVwVU0EDhr?=
 =?us-ascii?Q?oPGrZdsUC3y9yYjwymrmhdazNBieYgnfTIoPki0Jzj2VhilrrqeyPsGn6606?=
 =?us-ascii?Q?oyMShdPXzo/WV7pZwHHuVyXvt2iNcOZqGEBCg7hHyHp9m/7xDnligETnR6yn?=
 =?us-ascii?Q?H3R8RkdPHa6m+ymCkRuykue+ZIk9xgBVE113NJnMz7jT0FEpgxFeI4MB85WS?=
 =?us-ascii?Q?uQG4c6UcswbsrWM0i7lQ3BtyT8oyX7bIa7AEyZ7r9UFPMtHhzu/Dx2aibKW5?=
 =?us-ascii?Q?rgNmZFuKl13XC7Snr8NZRGn1EEmFRCADwf+fmzsruQDdfUBDIg3lroEqNYUd?=
 =?us-ascii?Q?5g3OQ3m/4jYAfCnXNJJEVUY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57bd6f3-b1c2-4628-e795-08d9f62759c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:32.2747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNqM4/T+JIKU8fMvyd0jxycZjRZ+ayVzaSW7I54oqppRUkVCJX5NWZgV4MqJJuPFLGs0syuw0FwJSFIqi35tcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The FW minor and subminor versions are the same for all generations of
Spectrum ASICs. Unify them into a single set of defines.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 33 +++++++++----------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a4b94eecea98..e39de7e28be9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -45,52 +45,49 @@
 #include "spectrum_ptp.h"
 #include "spectrum_trap.h"
 
+#define MLXSW_SP_FWREV_MINOR 2010
+#define MLXSW_SP_FWREV_SUBMINOR 1006
+
 #define MLXSW_SP1_FWREV_MAJOR 13
-#define MLXSW_SP1_FWREV_MINOR 2010
-#define MLXSW_SP1_FWREV_SUBMINOR 1006
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 	.major = MLXSW_SP1_FWREV_MAJOR,
-	.minor = MLXSW_SP1_FWREV_MINOR,
-	.subminor = MLXSW_SP1_FWREV_SUBMINOR,
+	.minor = MLXSW_SP_FWREV_MINOR,
+	.subminor = MLXSW_SP_FWREV_SUBMINOR,
 	.can_reset_minor = MLXSW_SP1_FWREV_CAN_RESET_MINOR,
 };
 
 #define MLXSW_SP1_FW_FILENAME \
 	"mellanox/mlxsw_spectrum-" __stringify(MLXSW_SP1_FWREV_MAJOR) \
-	"." __stringify(MLXSW_SP1_FWREV_MINOR) \
-	"." __stringify(MLXSW_SP1_FWREV_SUBMINOR) ".mfa2"
+	"." __stringify(MLXSW_SP_FWREV_MINOR) \
+	"." __stringify(MLXSW_SP_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP2_FWREV_MAJOR 29
-#define MLXSW_SP2_FWREV_MINOR 2010
-#define MLXSW_SP2_FWREV_SUBMINOR 1006
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
-	.minor = MLXSW_SP2_FWREV_MINOR,
-	.subminor = MLXSW_SP2_FWREV_SUBMINOR,
+	.minor = MLXSW_SP_FWREV_MINOR,
+	.subminor = MLXSW_SP_FWREV_SUBMINOR,
 };
 
 #define MLXSW_SP2_FW_FILENAME \
 	"mellanox/mlxsw_spectrum2-" __stringify(MLXSW_SP2_FWREV_MAJOR) \
-	"." __stringify(MLXSW_SP2_FWREV_MINOR) \
-	"." __stringify(MLXSW_SP2_FWREV_SUBMINOR) ".mfa2"
+	"." __stringify(MLXSW_SP_FWREV_MINOR) \
+	"." __stringify(MLXSW_SP_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP3_FWREV_MAJOR 30
-#define MLXSW_SP3_FWREV_MINOR 2010
-#define MLXSW_SP3_FWREV_SUBMINOR 1006
 
 static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	.major = MLXSW_SP3_FWREV_MAJOR,
-	.minor = MLXSW_SP3_FWREV_MINOR,
-	.subminor = MLXSW_SP3_FWREV_SUBMINOR,
+	.minor = MLXSW_SP_FWREV_MINOR,
+	.subminor = MLXSW_SP_FWREV_SUBMINOR,
 };
 
 #define MLXSW_SP3_FW_FILENAME \
 	"mellanox/mlxsw_spectrum3-" __stringify(MLXSW_SP3_FWREV_MAJOR) \
-	"." __stringify(MLXSW_SP3_FWREV_MINOR) \
-	"." __stringify(MLXSW_SP3_FWREV_SUBMINOR) ".mfa2"
+	"." __stringify(MLXSW_SP_FWREV_MINOR) \
+	"." __stringify(MLXSW_SP_FWREV_SUBMINOR) ".mfa2"
 
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
-- 
2.33.1

