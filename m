Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843BC57F3E0
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbiGXIEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbiGXIEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0908B186C7
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQEiIWFSbYnrnagLEjiCIiVwaPb8s6TbAwSgI4dXtZYmhT7P6Ee+MKpkBp/l6tqK0GIlut7ZKJvx8dNwA7cUCv1Yo4T7NJfNLqO6K1ap3ZOVlvTgQPz+PJNL/VzS9zQrg8yNFQFuU9BSMEX/vxIA5zNYflPZjKXZz7TJTsdCI7jpj1gpcMe0Un/l8MFqF4OXkjzS/buMRsnr9Cqi59okwLG6pQiAcmQntxpFeDsMjcJPVhj8Pextg+GjEdL3TEymcgPuz2HXvTv6p1aDSAV03ZjrMWsUAN337D0i04Vfak/wKitTmg3QfUUpcMQ2qH0E9LPHk5q9QrcjsFQ9oOJu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rA2P+ch/EwRfOEUwK0mVBtBbetr7iuAlEPJc2a7be9A=;
 b=GwRMhSUejWwjdUVB5g8zOEUxsZ8IDFcFx3dstTxU6UkhdBPCqYXXUk0U7UGUVy0+Rw7/FvM6Baykk6AKBppqX+5y+kBjQzKeePXQq31spVCEkfIvGm+fEj+WM7JNo8NyrZJIN5lwIQz9GmmoemGbaj7+znGS+YHblEt6LrHqlBGpifu9RgWM2R6wd/6WuE2GsK8WGBrQIPyqvC6qAgxV/tz7q8adjEshfRfWgsL7bPJT0o4uuSnd3lytdN3cwpHX9vmsASosGQOgvPsvGI/hWXxRa5fnednVPNjARGaSfgmC6U4xPX0xcwcuG3gL5zn3dl1FyWo4jIT/EV4xl3U9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rA2P+ch/EwRfOEUwK0mVBtBbetr7iuAlEPJc2a7be9A=;
 b=MKJtpoBXWQgy99xyKxU7lTQbDLyC8GxJ7CRkNDnH71dqb7/z2wv1reBclWooI3diRSBIje7+W2tEIkwFDWXPJzHXq9qvvvLJaceREd+lUMt9mUa2LBi+8ohmEA4cDC0Arn6kAZaKGgQs/V/ptqjkKwNGh2HCgr/br86OYhl0fTeJWvwK74VTzXWfBJh1AqdvxalPfUwsp1MRPJN3Vv+sC+Ix6ym6VOb/bo1Rcg0toPNlrijnXPUpMqwZdx0TG6qmPRXyfNfVHXU/2wO87yLlKHKfMx7p8/YmUc8ViD0+cQc0CqT+eGwa9iWAu+Pd/M1ybg7gZuQB5Kiini7kK3GC7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/15] mlxsw: pci_hw: Add 'time_stamp' and 'time_stamp_type' fields to CQEv2
Date:   Sun, 24 Jul 2022 11:03:18 +0300
Message-Id: <20220724080329.2613617-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0128.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::7) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43aee81c-7c13-482d-a772-08da6d4b2a1f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGAlbBPA+1ACO+xT2DPqJs/8UdUJFWsEi9uACOLWcCOF7H7tmb2fHroq+dl73xJ0eFPwdnyElsKzoH4YGZEZET/7neJJUQ1myxDL5/iunON32ENuxkEIE6IfLcE5SK/RP/+1ky0rMmUlmriiN1lKgpIFvnOcF9vM0pj1qLGfsHBrIM4JCBIPrpX50BaaXj1lwMODgk6m19YUnHw08i8X5kdH0Bqhf/JPMMkPB3uq+AVIkkUB+Yc80PrzUYdBCk6LiwFn+h6saji8h1yHpN7v05hfStaTxQccBJ1389dw5Cwen2+NxXjpSvEhFRJqu3FEa111JMRSD6u6fNh4PFUskSeKywfqs+/ld4A8zdPU7S5PXVJxMRKIyNTnqBrhKTt10+E57XhreM3b/sQscqWGuaNFIxFQIjE0uvWKCXUxTy68W5BxPRCN4B900uGML9C0pmx1Yza6+YQrofoQoOHOHeMoD5nn313RRqqBK/19azcVyoZ6DaelC6W64HydyU6igUvq/3MyyRCruqiTyeS1Es2VxE9VcNW3lZf+4+UHGGHrMZRPCHkzNEU05TTP+No1oZH91DCleHYx/QCSPg+mLjpaGQHhAGxbLq/wvZfZ2gLpnHB16G//X6Pe0A2iGQ7F/tJ8CLX6PRW8CmNoBDEbF3hRporj0qc3pKN4wvdfLCWNnvFZzIF3JM0D2Vd+VV4BAySpmo1r7GEUbuSjtAy5Gx0IxJ3fObtyUuLVvsSJ4Xok8JGSKB41ZU+Ia3RUioDy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ib4qb52+EAjfmDYv8tXMWLVo1P5SECexfET29TwaIxnq9N3fdwrb0kDNReNh?=
 =?us-ascii?Q?37sTbsvqzSP2rOJOake9HElyMr1VUFBiBzHB2eWw+adQtGrgGQbYyjdYzFbY?=
 =?us-ascii?Q?Dohe/yTldcjrKIwuvCBWnpiYL/0JxoYpwloXgcq875UDq9nVUNRyV9EDD30P?=
 =?us-ascii?Q?1X0YgxnJJoJhuIfPMhSkWduqs5netYtocEhVJQqIZRJuaufJd20KtaJWGL0e?=
 =?us-ascii?Q?QF6UEnSF1ECjMRqnZeBF7sp99/1nk4WKauLVj1pyREUBTZ61dw+cu0Lxazk/?=
 =?us-ascii?Q?OlXCat3YMfWBIYUZXG2DfjiZONYQ6pOPoSjd5WSWH6m/PmrUXNVwlEZbqbTk?=
 =?us-ascii?Q?4pJin7x/uOkKyBLjklHVwfOdYlpFTJWfY4kkmhQdO5vNaNlpT6+GM0URqRUP?=
 =?us-ascii?Q?ONNxRj1YonwwhZWFx7k/LqkXu0+hHq7Oe5esZjHgSKNDvcn777c43aoxu102?=
 =?us-ascii?Q?hOIMQsjRy8OKYjHScy1nPpq6GOofZDcyCerBDLhB+06vqATHEweKgJtbHq+U?=
 =?us-ascii?Q?X9row3/VV8r/5mm9HWFhhMxh9fBxsB0bYWis+wwV+g5AOBGb6kFcei6yWoUp?=
 =?us-ascii?Q?gP4hIg5LljIIUV/WW/1XzVxFHcmw48f2TgchiQZH7QH63cujPtedfm6p3SOn?=
 =?us-ascii?Q?pioKuyP/hwY8ArP5k4/r1aW2xt8RNYf6Z/H2yB1LVFBSxoXqBpCgSRl13XjA?=
 =?us-ascii?Q?m7MiiKtfHaEj4T4q7vj+5qbnO6/6G3+nGuKF1M3it8Yxs5k48U+Nv0SXIf/o?=
 =?us-ascii?Q?q6SxmSgPQP08/QY4FT3HhD10aWg8gqE2oyEqO/78fNllDvkKeE0EIjZizI5i?=
 =?us-ascii?Q?/wSVBrC7SR/+NfaKiPN/4d1GZWNeHkluhUwh1vNmv55kwJ9vZ4snky9Vf11x?=
 =?us-ascii?Q?X4x0/gWb80hN1WKoxsa4OdluS/F70zoWXJJsQ+uMcjswYnofB5vXL2ubH/OQ?=
 =?us-ascii?Q?u5m0/DF901Dr4ekOa2OOHpBm4APqEKKuDSMqzs8umXuG6X0f2SG6AXc5Wt6e?=
 =?us-ascii?Q?t+vD/5ddEjAe7Mq6LuzvvrE6j7e0TJiFrbdqnHGJqoFkj8xae7V8L3xzbb28?=
 =?us-ascii?Q?71C6QYgST1ZDD/gRLn8VBB3F8Aii1bP2LuJh82wdvSbeQbYdxkPJOBRVYRpH?=
 =?us-ascii?Q?r8GsWKdEFMCD6PY+EW2RaFFsNFjTq9gwbgkjKR0aewFg8bjd5o6nj9FqWGNM?=
 =?us-ascii?Q?x5E+wUN+vjPbpk4vI1ZjfPHTHMWryQgi71UCtA4NVVya6+q/0ZVaELqic5o5?=
 =?us-ascii?Q?EKRkNmEv+kWC54jmrr2SgINo0vaZ8Q342fHNoZqVcV1oBabm4NYpfa1qvFx0?=
 =?us-ascii?Q?n4jArqsjEPuKeVPtr83wtqJl1dI+AI0CARhCRKOacCfuHxCl09MLUd34gRLb?=
 =?us-ascii?Q?FRso2dBxVgSLdz3F/MTHHm+XtxHZez75OMDxqotXQeybN6+mH59UZCET89op?=
 =?us-ascii?Q?YiRV0bQHOTFFbsuxqeyyA84TzrdJiMi3qXe1gi2Ikgg9WwvwfdLzvgYmH7ns?=
 =?us-ascii?Q?09PX7Wr4UYrXj2M9jjpW6xWZ+q0OyYxgvcuWdiJpaZt0tX8DqHipnom0Omcu?=
 =?us-ascii?Q?yaT4lIrooT/yzaSy/P8HgCkNGSHS9OkMlWkRQ3Zp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43aee81c-7c13-482d-a772-08da6d4b2a1f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:42.3975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eE1w54Cr8MM7cmtiYVoM0LtFvVV9yVS+ajTwDYw8GngGQlvNGo024baF1sD2KsZ9J5e3hidH2rgdejHnPqxkXw==
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

The Completion Queue Element version 2 (CQEv2) includes various metadata
fields of packets.

Add 'time_stamp' and 'time_stamp_type' fields along with functions to
extract the seconds and nanoseconds for a future use.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 78 ++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 7b531228d6c0..543eb8c8a983 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -217,6 +217,25 @@ MLXSW_ITEM32(pci, cqe0, dqn, 0x0C, 1, 5);
 MLXSW_ITEM32(pci, cqe12, dqn, 0x0C, 1, 6);
 mlxsw_pci_cqe_item_helpers(dqn, 0, 12, 12);
 
+/* pci_cqe_time_stamp_low
+ * Time stamp of the CQE
+ * Format according to time_stamp_type:
+ * 0: uSec - 1.024uSec (default for devices which do not support
+ * time_stamp_type). Only bits 15:0 are valid
+ * 1: FRC - Free Running Clock - units of 1nSec
+ * 2: UTC - time_stamp[37:30] = Sec
+ *	  - time_stamp[29:0] = nSec
+ * 3: Mirror_UTC. UTC time stamp of the original packet that has
+ * MIRROR_SESSION traps
+ *   - time_stamp[37:30] = Sec
+ *   - time_stamp[29:0] = nSec
+ *   Formats 0..2 are configured by
+ *   CONFIG_PROFILE.cqe_time_stamp_type for PTP traps
+ *   Format 3 is used for MIRROR_SESSION traps
+ *   Note that Spectrum does not reveal FRC, UTC and Mirror_UTC
+ */
+MLXSW_ITEM32(pci, cqe2, time_stamp_low, 0x0C, 16, 16);
+
 #define MLXSW_PCI_CQE2_MIRROR_TCLASS_INVALID	0x1F
 
 /* pci_cqe_mirror_tclass
@@ -280,8 +299,67 @@ MLXSW_ITEM32(pci, cqe2, user_def_val_orig_pkt_len, 0x14, 0, 20);
  */
 MLXSW_ITEM32(pci, cqe2, mirror_reason, 0x18, 24, 8);
 
+enum mlxsw_pci_cqe_time_stamp_type {
+	MLXSW_PCI_CQE_TIME_STAMP_TYPE_USEC,
+	MLXSW_PCI_CQE_TIME_STAMP_TYPE_FRC,
+	MLXSW_PCI_CQE_TIME_STAMP_TYPE_UTC,
+	MLXSW_PCI_CQE_TIME_STAMP_TYPE_MIRROR_UTC,
+};
+
+/* pci_cqe_time_stamp_type
+ * Time stamp type:
+ * 0: uSec - 1.024uSec (default for devices which do not support
+ * time_stamp_type)
+ * 1: FRC - Free Running Clock - units of 1nSec
+ * 2: UTC
+ * 3: Mirror_UTC. UTC time stamp of the original packet that has
+ * MIRROR_SESSION traps
+ */
+MLXSW_ITEM32(pci, cqe2, time_stamp_type, 0x18, 22, 2);
+
 #define MLXSW_PCI_CQE2_MIRROR_LATENCY_INVALID	0xFFFFFF
 
+/* pci_cqe_time_stamp_high
+ * Time stamp of the CQE
+ * Format according to time_stamp_type:
+ * 0: uSec - 1.024uSec (default for devices which do not support
+ * time_stamp_type). Only bits 15:0 are valid
+ * 1: FRC - Free Running Clock - units of 1nSec
+ * 2: UTC - time_stamp[37:30] = Sec
+ *	  - time_stamp[29:0] = nSec
+ * 3: Mirror_UTC. UTC time stamp of the original packet that has
+ * MIRROR_SESSION traps
+ *   - time_stamp[37:30] = Sec
+ *   - time_stamp[29:0] = nSec
+ *   Formats 0..2 are configured by
+ *   CONFIG_PROFILE.cqe_time_stamp_type for PTP traps
+ *   Format 3 is used for MIRROR_SESSION traps
+ *   Note that Spectrum does not reveal FRC, UTC and Mirror_UTC
+ */
+MLXSW_ITEM32(pci, cqe2, time_stamp_high, 0x18, 0, 22);
+
+static inline u64 mlxsw_pci_cqe2_time_stamp_get(const char *cqe)
+{
+	u64 ts_high = mlxsw_pci_cqe2_time_stamp_high_get(cqe);
+	u64 ts_low = mlxsw_pci_cqe2_time_stamp_low_get(cqe);
+
+	return ts_high << 16 | ts_low;
+}
+
+static inline u8 mlxsw_pci_cqe2_time_stamp_sec_get(const char *cqe)
+{
+	u64 full_ts = mlxsw_pci_cqe2_time_stamp_get(cqe);
+
+	return full_ts >> 30 & 0xFF;
+}
+
+static inline u32 mlxsw_pci_cqe2_time_stamp_nsec_get(const char *cqe)
+{
+	u64 full_ts = mlxsw_pci_cqe2_time_stamp_get(cqe);
+
+	return full_ts & 0x3FFFFFFF;
+}
+
 /* pci_cqe_mirror_latency
  * End-to-end latency of the original packet that does mirroring to the CPU.
  * Value of 0xFFFFFF means that the latency is invalid. Units are according to
-- 
2.36.1

