Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86225509A4
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiFSKaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiFSKaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98776DF89
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8wCp6pxNJ+OypCpzm9cfSoMJmq3tsW5q7f0S1sfhQ4elUK9Ofc8rR0ZrymGPdNNWXYuLQF++aHdXGNqajKeduHlcmuw3zAPRUV3sjfbuHaysyzkMkV9NhAt1pkCyQx4Sklr3QyUMVfBUvTV/KuN6/uNVXDWnb7XHMO8AHWgdafrXn5mdxEyyd58HVH6SaT8ies+9A9c2OHcsAMoLFlrN6T5qiHKoMrRUfErMsPoHNXeD7ZNahWNB/FLJDzubihchbI/iEfp91cgNuNWT880rWy7qkGAs6931MgVo8uOMIOEXEYQsrjaHOuZjNi2r9Iul0n96njTWjvwiaYW8txbdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blcJrhiJmMQ4qiZh+AWqA0Os8jjRhXrBp3iO04DG4+I=;
 b=njBZCk6sH4AbJgQ5uIDxhsweO3b3NNDMLPZQdtQLRrfMrYmwUf4uMyvGmLgfqYWubIx6CmMOFPJ7whUEtP4fJJ57xSbPdN4eF3yx5jWns2iBqRhs5MSaKPEKUQeITkeGNDusoa9G/Z0+QxrmP2byQLKjPoT1pq4P/mlctK9PkDKVhuPJ8pVD9jn/OUpKh7kNvblVn5ghJ7ovf5DbaDH1YzjkfN9ito0syG79NFF38vTbMuzd5un7xyfrTLuPqaKTGI0RUbCyF2dC0IPM7BY3QWORcjhlnrOld9vE7pZ3cJZqHoTBAEo4yvYzGdqfCgsN/HyJD7yn4ShJpty11GZDiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blcJrhiJmMQ4qiZh+AWqA0Os8jjRhXrBp3iO04DG4+I=;
 b=ig2fHk/zYufnzEiPiaIfPv5q3FanaZBY5rZmbNukzQedbUCvoDxyjJvxAHQVtWlhpxPjeF7GkvuicjbhXa51wnD/m6TFKSiS1c624+a5bUXOzrnFmIDDzQ2Zura/vsr2Ec3yytJ30uvbHVam9cr9pJi6Yi6gtRn79QZOMDW3Rk2ifHHItMl0x1VWGZFkyoAyRrwndZzWhORl9x8CEWli9blMRpYk20Yt5L2Wv3o9li+oOXRHbjQnFfEVuiY+IExU5U7ap/GQ1Z1JsRPI5lC0I+mpXFqH3iRziq/KTpK2ekxnFAolIM5imAgItIc5r844uNUQ81Z75QoAIsD01Zfcxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/13] mlxsw: reg: Add Switch Multicast Port to Egress VID Register
Date:   Sun, 19 Jun 2022 13:29:12 +0300
Message-Id: <20220619102921.33158-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0155.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ec5cc1b-95b8-4a6d-7dab-08da51deb43f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193A1C9CA6EA8B9418222AFB2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WoqDRfpT+X7MEh9sZACKtCWW4/bed+Ox1qFnF3nQLf9GbeIu/fBaSh7Im6QfpORvOFuv5kmD49+uEIJ4Z340IyJnLn4gOSbSvvM/cC0kMOtuaStXNymweFTMQZvx2UE9STVffyvHM7GaHt+t9I/JVke6of7pZFp36ggDtpdHju1aRS49BjMZ4pYscFvtrVYClh1jDhWl/cXxeQSi+MNi36RhI52EnXZK3h134bykTh94x01UPaAXVrK2f5hVxc/+bDfaBoXIKgu+F2uVK877ULr6WEpXVIIetmTd07WoxqlXC6mhrD3wcyys3t9YWQgkQdHQdlUBrNJ0CbQF+kDUx5gnKS7LN8FTfcFrWjhpFvW9DJ+sC8QPUm76FksCBam/ka+21Mj1y6hxM8xo2zEBmqqepAz+RF7egIeg8047dKNTu1/lZbCR+Dtw45rmmjWo4GBW2fK6jvbTvhPSOz0UTjwlCIzpkv9pgSeMaYfdzUoYpXc7havEIw7lVaI9ijyAZGrmC1xLHRvkvRiyLj6oco/bP6wrSA+x5pylhk9AT42mHJ/fFgs/rFi5A2MJcIHDZpZ8BkUIqkvwpRzeisBXpC15VdMGGo+7MulDXGeEqhXB1y9HaHc8OzzktV2MZ5Tka0vT/WTCWevLezPJK/b8PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h+Xsf9Np/vpK+mbmtle8QAEJbgSDGh8x9ns4Nr3QACucJRqK2sOgtF6RtcmC?=
 =?us-ascii?Q?fzOHNcZL5wFlLh83fFh/hH4uMNdMN/0JXXfVALyTsjj/u+fmFqFJf03HZr1+?=
 =?us-ascii?Q?H1RjRhXb68pyW9CJriXWWOD+fWGgvtjsFZeEnZXw4eiM+WEU8DuRW1UnZY7/?=
 =?us-ascii?Q?lHhCzWPHQ3aX/rNjUI671ep40ArTUgjqOAxXwurQGA5Q41ShLAFjcTfXXdtr?=
 =?us-ascii?Q?0w50xRMlt2Gnu6vc/yQjF3XtEsxv4i8rwqL3EBObgLOBJ4BMwXa6ig0BpPh3?=
 =?us-ascii?Q?yv97DSgzMdT4O/DwBF2d2bIok9wV72jTGabub/rcyXZ2Q6g4J9EBi+Ol/eX7?=
 =?us-ascii?Q?cnDtDkhbh8PbXAOJweGgvrFpjDfDjCSgYHSJsgyBlKdAixu1w924iAJcCXIN?=
 =?us-ascii?Q?t3uonGdIi2rAX+ARXSMvkojz5Ib/mP1VjVecR6nvYmdQYioHlybwv7WxtaJ+?=
 =?us-ascii?Q?07XLVkNTs1cs+0Vo9pW7W77wAfJpPe4lHpmsYrRya1yf9v1J4c2oYb5P/YT7?=
 =?us-ascii?Q?eew7zYr+Eqe1ES8anAnT9glmy7R1pHd52hzo4UmE1gx1Hd0mdnXT8TK/sRnG?=
 =?us-ascii?Q?P/uwwX3uiF/ngwGU1HadDsQafIFWM6stGqKjnD3qxgfPKLqrMPQi8MC+SgXP?=
 =?us-ascii?Q?GAsbY+LG/ba17nsym/+KcrA6XunjZeXX1+jyak8TDfZbM3AqpEGFbVjZa6ia?=
 =?us-ascii?Q?mafry71kY3J+hTNWnWkNLB0hqJN3Qv9bLUhNe12MhMPGlY60EoVEYpGd8xce?=
 =?us-ascii?Q?m4XUtRsnBXLKBQspqK6eBB8blABG7skSYpTT8KGIVLW+Xk2+gry+YOoIKN2t?=
 =?us-ascii?Q?Gu6l4mIwtMYw9ThN9SwOIbPyhk0A3s/AjY/1NCDZRb9qwyoYN0uaJ4iVpzu4?=
 =?us-ascii?Q?d0QYpLcoJHl9mI/qnNfmDe2neLxJ2YicHAAy4i/evDcckDdEh66vThVqPR14?=
 =?us-ascii?Q?R8Xrf/J4JCpjINSVWrvGfnSCjYaZzmM6cY8Exrogx3Kql8slL9YlwOSKY9oB?=
 =?us-ascii?Q?KXVZYMbU6Rp6JCLZmivgOeMZUknpe6O+v+4BpD0tCr3JTzMZmq5Ux7HCDapc?=
 =?us-ascii?Q?LkoI+WB5HYpVXX3ZSh58nc4LBWxAMI2L73JMpiKt69ggs651qOIT+A75jq/P?=
 =?us-ascii?Q?EaewDQAYYtyGSNV7HgVIPScEgf4zY8j70MVfPVmc10IYBi3947qhHy2/xq8G?=
 =?us-ascii?Q?PfTHgqAstMGtXc9WZUIIn3eiY+hVxIC3C+qmt81BIlPQuqYxKjLDIhBXW/DN?=
 =?us-ascii?Q?3i1AILEF0tlgWNVbKizrY4gLXtMOIG9SnMc1UpINr5KyLloD1rUKgxG+SGVO?=
 =?us-ascii?Q?DAPWKZf5uRsLjPXeSZdLeAnqZWLvSkPOqExFinis6LSiOLYu+kvzXQonz2nc?=
 =?us-ascii?Q?YV04C8ut2ZMcxfRqtiFT6A+PakhRVgV5aO6xPU7MJdlhwpoeqTOBuxzV/8rC?=
 =?us-ascii?Q?rlGEvaC69DPMOXnSj2WwOfaP3e7Q1+C2Rw0464MDlXIbblGx5EYuVuh/YsF5?=
 =?us-ascii?Q?RKc5T7ob0oEDs5V8i5IrqiK8gsZLdI7TER/wEPxLs8BXst+4DsnFbgF1sSiJ?=
 =?us-ascii?Q?EXaAGlXIr/5qzCOKS4C9N49nyXaeGnn+YYyYU/Tb1eJatdxlKP6o/7aSE6dp?=
 =?us-ascii?Q?gE6Wi4HTFwAdLr+qTeEgVnXR5xcF5iETfoegeCjAmaElfdPY5heIg+q6pJin?=
 =?us-ascii?Q?qTdQhosv/lRkoAPwCS3QFPJDhTu5Up2/oGbsUm78+p57XoJalIYip+ZLqtYN?=
 =?us-ascii?Q?nrYR1Da4AA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec5cc1b-95b8-4a6d-7dab-08da51deb43f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:17.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6uZWB+DvsptkDDhy84pwQWtsX6BAnVR0zEUT/98rfcqyI/yEU2x72WEY9UO2j1zlfOwKadFaQzHa2iIoAecoZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The SMPE register maps {egress_port, SMPE index} -> VID.

The device includes two main tables to support layer 2 multicast (i.e.,
MDB and flooding). These are the PGT (Port Group Table) and the
MPE (Multicast Port Egress) table.
- PGT is {MID -> (bitmap of local_port, SPME index)}
- MPE is {(Local port, SMPE index) -> eVID}

In Spectrum-1, the index into the MPE table - called switch multicast to
port egress VID (SMPE) - is derived from the PGT entry, whereas in
Spectrum-2 and later ASICs it is derived from the FID.

In the legacy model, software did not interact with this table as it was
completely hidden in firmware. In the new model, software needs to
populate the table itself in order to map from {Local port, SMPE index} to
an egress VID. This is done using the SMPE register.

Add the register for future use.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 40 +++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d237f889bdcc..03c9fa21acd0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2065,6 +2065,45 @@ static inline void mlxsw_reg_spevet_pack(char *payload, u16 local_port,
 	mlxsw_reg_spevet_et_vlan_set(payload, et_vlan);
 }
 
+/* SMPE - Switch Multicast Port to Egress VID
+ * ------------------------------------------
+ * The switch multicast port to egress VID maps
+ * {egress_port, SMPE index} -> {VID}.
+ */
+#define MLXSW_REG_SMPE_ID 0x202B
+#define MLXSW_REG_SMPE_LEN 0x0C
+
+MLXSW_REG_DEFINE(smpe, MLXSW_REG_SMPE_ID, MLXSW_REG_SMPE_LEN);
+
+/* reg_smpe_local_port
+ * Local port number.
+ * CPU port is not supported.
+ * Access: Index
+ */
+MLXSW_ITEM32_LP(reg, smpe, 0x00, 16, 0x00, 12);
+
+/* reg_smpe_smpe_index
+ * Switch multicast port to egress VID.
+ * Range is 0..cap_max_rmpe-1.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, smpe, smpe_index, 0x04, 0, 16);
+
+/* reg_smpe_evid
+ * Egress VID.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, smpe, evid, 0x08, 0, 12);
+
+static inline void mlxsw_reg_smpe_pack(char *payload, u16 local_port,
+				       u16 smpe_index, u16 evid)
+{
+	MLXSW_REG_ZERO(smpe, payload);
+	mlxsw_reg_smpe_local_port_set(payload, local_port);
+	mlxsw_reg_smpe_smpe_index_set(payload, smpe_index);
+	mlxsw_reg_smpe_evid_set(payload, evid);
+}
+
 /* SFTR-V2 - Switch Flooding Table Version 2 Register
  * --------------------------------------------------
  * The switch flooding table is used for flooding packet replication. The table
@@ -12409,6 +12448,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(spvmlr),
 	MLXSW_REG(spvc),
 	MLXSW_REG(spevet),
+	MLXSW_REG(smpe),
 	MLXSW_REG(sftr2),
 	MLXSW_REG(smid2),
 	MLXSW_REG(cwtp),
-- 
2.36.1

