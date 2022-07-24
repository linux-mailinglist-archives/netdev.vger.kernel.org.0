Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D957F3DE
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbiGXIEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbiGXIEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A081659A
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NL0x1bHtq6va5vaJLDq6mfGJSF3KFhhkSl6CdKCI/B5RlrY7UK4bhXcHtnpCVd9S2JxnbI0Q+bXJF9OQj79seNQkNdqK59UrU2yBm9T1WJ9mjOd2VeNdCaKrndP+857lXfAKXtuJJciFMYCrEm1JmCfeFJUVnUF+D0slvlK4ep3fHTlyEBYQzRCWiFYtam8/zK9HetyPm/IZ1R2RiY1wAMIpxrAtfYmrsrz7t5CA3KRKt3dBorVgLkn9XNly4qYhrB7YZJ3q/2aHS20ioiv3ljY35yp5zvgSOkx5gfU2/TLRQGnLtuP3WJ4SA0UXl6G5IbEzy21X84jusfUIpr7i7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJxVwDKt24LpxwLYCVP+g9B2F5XDTbUJk8ORMPWe8lE=;
 b=VLW1p5s1Pl6W5ENvLCcPKKhe9w4fJ51xDNdeB9mraPuLclrfaBdfPO1opnByvwseA2b/ZBj/8R+s1V2IqGrxOW6uvj4rsxs4hGWI8ZNcQzCfWKX1aQsdia86S6JsLJKpX0597ch9h5J/eNvGjUPGPVf+NL1Cnme+YUksERt+EWip5U0lLG/RIUGzr2wf5L98cBkAViznrI/AObrqUIL/vzBGwiwWUsya5Ih3f6jhDSzEFw82zwqYhYRroxvziKhriVZD6DrNruObHKkdNzLwtd3YC+sT5VPf1xXmxk/Iey/ux3OQJCeTtvCDqp+PAQ78lRzG5WQENoBlkXUgCNkvmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJxVwDKt24LpxwLYCVP+g9B2F5XDTbUJk8ORMPWe8lE=;
 b=mq2HDdzPqxgwfyMSiQCvBamZPm9qJzxBNyGYDTeXFGxZ2J/7OF1Rqi+gra4/Qkd22Fbjo/LLj43LLN3rp7Z65180PVnZTf+AGGWJOTsq0yO3muWNlLOjN22k7vNU/In9pGYkQwW/BvdG20pYWu38m/bGickQZ/AvcI3+41gKufs6CAQVSPp5r7uIG7mOvEYQ8JhcR2UIaKDNJCXIwRxmvB7LoW+oIHXdqpWhVYKMmBjqEzh6O3A4JKi8wLySgvvjornBSY/biv5NwzzJg2vvHRDCpe4GEJ9FrdhzjernuhKZ+YG5InbeZJTS1mmowwnHJY/wEfvB9DV9mRtvWP2xnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/15] mlxsw: reg: Add MTUTC register's fields for supporting PTP in Spectrum-2
Date:   Sun, 24 Jul 2022 11:03:16 +0300
Message-Id: <20220724080329.2613617-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0502.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::9) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4cf228c-4ecc-46c7-55b9-08da6d4b22d8
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oz/6+sO5GqVNH6am33+k6y7IkvBrY1tGNTUh+nApVgSuZbY5RY3ck/E5z8f+q2MVthDAbfE2oZNUHGJgDdhtayqvsNvTzF2re2gpJ+8Nc5wCZT/FRzxJfv9V7vFP44Yy15ZXUgriB0brPnuEIgHrzmQ+tJCxMI/i8aFRBFOHFTGAi7UhbxvjFpgBaGaRXNV+mCQYsN+p43lJR7UCQMgP7tw7uU5zwPemd6M9Zm0VdnOdnA16pK2k5Dvv3mkZfpCwl7H8D/p9V66LNBqbfuBBxBoez+zNaiNKrjK4HaNB2NShpof422zP4Pd8K17d+5B6ca548OTVb6dgl97g+aGperVtBq7d/66dyphCTyacQQ61R+L51M3mbGc9Qul+MmtlA6AYDjKRwOf01u+VCJI+Se6pwQrQMHJXNLtEp+KNb74N0rIL89HO4K9qq6Yn36lJKhu7LEwdBj7/3l8KO7Z94bxJrRD+MURIxhbgesxuFG3Tq6ys62uZPQ43qffnfbajj3poVdcLv8OflrOVFXXwXi6/7UWhMxH4PB1uPxYVgEJSxW/T6qlGG0doYrF0068EkQiEGAbP/OeZahV8Y41vS1fV3XdZXnW8Uu/tJyHEam1z67WDw1rsubsfgE+t2t5Ew4eESs63wYO8/SIVXAOIWvBQ9NPvIAlfUDe8X54xT9ffQaOWGKGBK049eDLLMD0M8Cy9RQpup5n9hVFhB/8kx6TQo88G4PLMdLPxirHZAtCNLr8Ytz5WaCd+ac54zphF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kLoc/ZjTrpub/MCP4Om5Yrbm5q2zrX2pUxgQGKJ2Cg244hVU4Dzr7IFdYctY?=
 =?us-ascii?Q?TByG/s9yG8B+t/91Hp8VrWO7M7xaXpzEkqb6lqNaHpoKI/bxLqd3IPwaRVjd?=
 =?us-ascii?Q?ElrDw64UuXAGEIt/5CX6XmHTWKQPtJeqQBNvPPfe9rPqcyHOZtiulTFwyil+?=
 =?us-ascii?Q?tSqCrP7SPzDkpnRPkFIVDFCK3aXtSJu+U7acaQQkztmcjyAoa/mlRmSAwIOK?=
 =?us-ascii?Q?tU/Poi0RQAAbxN3iZtgbwYh+8DDneQuUbO4VC0RstpAVOo8B0/ITC3fQv0cr?=
 =?us-ascii?Q?pepeju/WtdGivD5eRBUhT9TCRgRJDk3Hduh4xYCsJizq6sxZMhAjRAZ6A0oI?=
 =?us-ascii?Q?cmXxC3Q/DbkivPWOwtpa4aRCehD3gkOXjwm/PzHdNHzk5KFJsqIOIUudFwV8?=
 =?us-ascii?Q?Xwuk/kK7K4gzdvm3dmHIZTessEG7C/gejCJZtcKnW4sW2Slvxu/aNSugG5qO?=
 =?us-ascii?Q?BXRfT8cdlPRX2IG+KcSUgZwxx15rFnVPq2yiuiuxwZ1PJ4/VKUTXgIVTcVHK?=
 =?us-ascii?Q?ob3aOlchu1z6HHR1pCajS5L0Q4RaZpnMoU1Xj1vdGykgotjjCBbRTbWN8AuL?=
 =?us-ascii?Q?kRWSjpNbyLqIgGFgSfutSLJ+qrSdYa3e84DX3e+WJltJptE8uHmH+8+2q4GS?=
 =?us-ascii?Q?62mUY2KNIUIc9QsnJ0Kw2r2CBl422GnP1sB7ijSp42xbJhZ2yqYC7HPoxTw8?=
 =?us-ascii?Q?e2u8mn9VHQDabmpBImmHGPuR9j7/zMjRN7m17wTOkTvF3VG9hDec3oUEbZcg?=
 =?us-ascii?Q?rLlsAReSeGLrovMplw4skUeD8ekTOTCowWI3JKiqGwGpb8zmRRFZjEi52m/Q?=
 =?us-ascii?Q?G4ACOaL3OMqLDILU/t3jbFq5nxifyfT013uF2Aq6gFWC31RIqt8lYVRSSepq?=
 =?us-ascii?Q?ROQZo7lsf4HohUMVoA8WSKE2vUSofJmgPR9cAYtJC0xAygaiyydMDxPFN6ib?=
 =?us-ascii?Q?l+Z4zgGuu6STFI9OChwtBU6SYW2TrJbCNVgVdDmbZbBeW5K5jramO76u00Lq?=
 =?us-ascii?Q?T1Gr9v9ZjJUNGRLaFohJ87VkEDRcK8PcqSKe2ei4Xu4skB/Ka/Nx1ZejrEd+?=
 =?us-ascii?Q?c2+w9IJeF8mirOvd2sycAOzgXgSCY9j8a083trTzoAdZiN+BF7yzZuWh3mjT?=
 =?us-ascii?Q?fkn+jeV4ovaY1GfITwnRnDKT8UhBkpCU8o51c7qLpbVfe+I7NTKGnQmq69Nl?=
 =?us-ascii?Q?cA1eFULIRfrYWulPN2Tr+c7+W4qHO0lwxK2QfhWq70htqdwJNWDzjkOIBOxJ?=
 =?us-ascii?Q?qT9hv9UTTczllk+Y33vDunoK5FCp22Lp1jM+V1/p6khCMzWR4+OPYc8FkHjI?=
 =?us-ascii?Q?DIcC4HSOkLvrcXs8W1SUT0omREkZyOKm/FLSzaDV/SIeGjkfPJs3YUd6Sgoe?=
 =?us-ascii?Q?3KdRQulE4QowVQF2mQVqbcgFtTx2Kk/FKuGZVoOtREecdcFKJwQcIGOnBdoB?=
 =?us-ascii?Q?dzXklOBn6tMbK4ABRrx+Fcuh4CQCDwsAPTt3DqBLAu+mGGkohgmpHeQhlsNy?=
 =?us-ascii?Q?3UeFLPAZ4a1iM4uAatDnRgvzLH3x4y4Xuu0HGxxCxEAWI1WV6Tq7cRp4Jrym?=
 =?us-ascii?Q?dewW5fsICFz4sKRKENagC96Xu3kOZh3gjT4zm9NJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4cf228c-4ecc-46c7-55b9-08da6d4b22d8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:30.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3uw8UbTixz7n8eR0kNWCjnnspWWvGFA7Z7FAKeOY8OuXtfKCW/CjkqksTW0I/cx+TgwJ3WG4QIIwYLY0uIPWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The MTUTC register configures the HW UTC counter.

Add the relevant fields and operations to support PTP in Spectrum-2 and
update mlxsw_reg_mtutc_pack() with the new fields for a future use.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 31 +++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  4 +--
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0ed2a805ce83..5665a60afc3f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10347,6 +10347,8 @@ MLXSW_REG_DEFINE(mtutc, MLXSW_REG_MTUTC_ID, MLXSW_REG_MTUTC_LEN);
 
 enum mlxsw_reg_mtutc_operation {
 	MLXSW_REG_MTUTC_OPERATION_SET_TIME_AT_NEXT_SEC = 0,
+	MLXSW_REG_MTUTC_OPERATION_SET_TIME_IMMEDIATE = 1,
+	MLXSW_REG_MTUTC_OPERATION_ADJUST_TIME = 2,
 	MLXSW_REG_MTUTC_OPERATION_ADJUST_FREQ = 3,
 };
 
@@ -10359,25 +10361,50 @@ MLXSW_ITEM32(reg, mtutc, operation, 0x00, 0, 4);
 /* reg_mtutc_freq_adjustment
  * Frequency adjustment: Every PPS the HW frequency will be
  * adjusted by this value. Units of HW clock, where HW counts
- * 10^9 HW clocks for 1 HW second.
+ * 10^9 HW clocks for 1 HW second. Range is from -50,000,000 to +50,000,000.
+ * In Spectrum-2, the field is reversed, positive values mean to decrease the
+ * frequency.
  * Access: RW
  */
 MLXSW_ITEM32(reg, mtutc, freq_adjustment, 0x04, 0, 32);
 
+#define MLXSW_REG_MTUTC_MAX_FREQ_ADJ (50 * 1000 * 1000)
+
 /* reg_mtutc_utc_sec
  * UTC seconds.
  * Access: WO
  */
 MLXSW_ITEM32(reg, mtutc, utc_sec, 0x10, 0, 32);
 
+/* reg_mtutc_utc_nsec
+ * UTC nSecs.
+ * Range 0..(10^9-1)
+ * Updated when operation is SET_TIME_IMMEDIATE.
+ * Reserved on Spectrum-1.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mtutc, utc_nsec, 0x14, 0, 30);
+
+/* reg_mtutc_time_adjustment
+ * Time adjustment.
+ * Units of nSec.
+ * Range is from -32768 to +32767.
+ * Updated when operation is ADJUST_TIME.
+ * Reserved on Spectrum-1.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mtutc, time_adjustment, 0x18, 0, 32);
+
 static inline void
 mlxsw_reg_mtutc_pack(char *payload, enum mlxsw_reg_mtutc_operation oper,
-		     u32 freq_adj, u32 utc_sec)
+		     u32 freq_adj, u32 utc_sec, u32 utc_nsec, u32 time_adj)
 {
 	MLXSW_REG_ZERO(mtutc, payload);
 	mlxsw_reg_mtutc_operation_set(payload, oper);
 	mlxsw_reg_mtutc_freq_adjustment_set(payload, freq_adj);
 	mlxsw_reg_mtutc_utc_sec_set(payload, utc_sec);
+	mlxsw_reg_mtutc_utc_nsec_set(payload, utc_nsec);
+	mlxsw_reg_mtutc_time_adjustment_set(payload, time_adj);
 }
 
 /* MCQI - Management Component Query Information
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index a976c7fbb04a..39586673b395 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -107,7 +107,7 @@ mlxsw_sp1_ptp_phc_adjfreq(struct mlxsw_sp_ptp_clock *clock, int freq_adj)
 	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
 
 	mlxsw_reg_mtutc_pack(mtutc_pl, MLXSW_REG_MTUTC_OPERATION_ADJUST_FREQ,
-			     freq_adj, 0);
+			     freq_adj, 0, 0, 0);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
 }
 
@@ -144,7 +144,7 @@ mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
 
 	mlxsw_reg_mtutc_pack(mtutc_pl,
 			     MLXSW_REG_MTUTC_OPERATION_SET_TIME_AT_NEXT_SEC,
-			     0, next_sec);
+			     0, next_sec, 0, 0);
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
 }
 
-- 
2.36.1

