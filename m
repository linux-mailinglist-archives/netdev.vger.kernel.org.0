Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359BB504CD5
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiDRGri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbiDRGrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9AB19031
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBAOdROPHpOjlib5BLf3L8jWvp4kHXak+8Lm0YqddXOgz6YWPiZMrKvPsHsMXq8ujPTsUfEUOKFnTP2bD49WZj2tY4vqdPgEp51DPNm9updcAKdHlMj1R9CpvevPnPowqVwT+3D8zWsLz2FjqVDkvuVgtqe19HLTnkFd+OGbn53gS3Wt4xf1rmj9bfyrnenxVwVLg76nIqEX8Om64c2Zv/i9/fQP+uAYucolh0iCnUqk+X/lWQtsjmGsc8dkxVkRO5/cpKqGH9yMSCAjr4emHT7HFwxbAyNfIRKPvibpinqaaFh3kYHX/CiXy6v0ufDWxdST3OE92RSEBFtYQZ0V7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPK6gQnnLaSUilRa7TVuwRVsV/7jdUXqipB2ihWwcbo=;
 b=RBYsqERuL2Ri0OxL1PO85uGAAF2aKleS4Ca8TadBK/RvkVY6ieJzYp/wkc8qTTj3hXHXfLkCgvaGys2+xbIJnUF7KjTYdIu6zxomhwX1Y3W501HJPZnEPCNRWL4n0DXMU9cQ67Ew7Fxs9GojkAbhyqsKLDw6GDyoteopDCXRQSYDLJc+rpy3Yg/JkW/UJ/6XwCuYbxEcmoa/kv26sKrzx9dk54sjocQEfS6JdRuHLAINSX1sPhIp9TbklvlmNU7QAuN/eLknX9iSJ6EAGg74A/r5gVU4FXj4GAyq46RRusdvc1DYHrozwGygiTrOPWqggEMLmCB7F4W5NxBp/uWaxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPK6gQnnLaSUilRa7TVuwRVsV/7jdUXqipB2ihWwcbo=;
 b=W/vPwQwIp2oniLfgTTYpkMAVdYRwb90izpNQwKr2Z44CASGt8P2YKT59/33LEvK7MzyZz9Mwoxfss9AHlIgPVuCptcoMBcrwziPukOAIHtUQ7qpNWxSY3ojKfie5NHpBpd6cGsNfKXdL90M9WQS9vDvx91NWTJ63eD+sWWcVhOJxUa0E8wKvjxWu5NXVbrmW+nwQNuLd7RO1BQMIQC62BbMvAnDcmea82gjo80PC8fFyqH/sNIaougPYdv4YtP63eR1w3c4AseHUIZ71uhWG/zKV+t9tLGWAxVe8ESg5WbPbPajtzTfdRKd/hGdnHdptaO7rJEbyGweFS5QEcy5aIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:37 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/17] mlxsw: core_linecards: Add line card objects and implement provisioning
Date:   Mon, 18 Apr 2022 09:42:37 +0300
Message-Id: <20220418064241.2925668-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9499b130-37ff-4858-662d-08da2106e810
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB366474D6EE8BC0471779F407B2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tyUJK6p/mihVU4lr4NOxFu45UWSHOJ2wWdhbKwrFp/o8kwlujIykK05eENqkIGsvV3zygXf/xMFJ81ati880iYxnsoZoE9mGmmE+sNiI3YgSriS6p34fjlw+Y+2Tgt96XYMjd1YXxCT7Lls/QiFQMSSZzlGMnykMnxid1PalbCKM8Zi73QUqhwEdpvTJEjTMnquOdkrDbmJhHGYitNYbju5Z4ohtmyC2JKRBrPEnEy3f0c0y1S3K9bjBhgRCtk54889Xhm5Wjc/wLKMOCY2Kb8LPwzAo45WoKkZwMjklHc0hdeBuq53Qkuo6yxSX41eaBaPveNhyGk6HE3C1tZXG+g08ufU4CfpgrPitt8LRq7rAGhEBYaEmFauYdEHdMRtFQTQAV0mPbBXWDqyF3p9UXX870OFy5cpCLu6OeTqjvJGC8rI+8GcFfLCp2FjTscQTPXH/RhNO46u0d27u2tTC79sPKnzq3ZFoeevxY5SFQ0H7VpWr7wJrQ2Ph/8uBXEFj9ezrb1FQNjs+mRDOnNmR+jfzFLCzXt30mhy7Zn1PfksYrLlKWCc2EyGX2s6/uv+JyfrPFF0Zhwn5aQwLG2UNZstTbLwgA+SB20+HXpy2N6+u79ePohoJK+vJ2mRR9yWGhCDYa1dieTzGO3183OMzvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h2dMT2OU3pHAIJa2z6GS7wvfLFlrQLJxRPA3dYapA013qEi0Y/O6zXvdyxUn?=
 =?us-ascii?Q?Wt/iEB9QcoFW3nx222wp1DtURIYmjqxNtyU+66+4SZlOdre2vksJe7GYdxjR?=
 =?us-ascii?Q?kCUt5ZjfRHwfy+5dnU/8VS8eD8z+9MVYyzb7jxjYhIn5+xI/ONSple1WC6A6?=
 =?us-ascii?Q?r4U3pa/5wQjgjxBFdZNtwq7yGozwXYOE0xEKfJsjWoInsYhkVct2zIXojv3a?=
 =?us-ascii?Q?c25i5L4d2BHp4gVDktj4Uyw1KVNjILU57SRdgkvYuRduzA0qZ3pEWdmBpCjb?=
 =?us-ascii?Q?B+YJWqQD+KPZXxRMuH9+KvL6lWq/J/BlhdrT+sGSO+GNptO3gc51VKCDrho4?=
 =?us-ascii?Q?es0fS2laL2iI0E2LeEUYxA1iFkAqahQo4TNMnVllATl7SkO+mKIf6JcC32ok?=
 =?us-ascii?Q?S+EvwPnRcYunnrj0UdIWdQZT8AXQpBLGsRmsYWcgAiFMFr0bcuoIBWmCEgcA?=
 =?us-ascii?Q?owVOdLTsCnJa+a3b6ht7o0iwb0bXOdY8oXQelGDcWIhSyo9L/XHpJF9mpFmC?=
 =?us-ascii?Q?FwjqOI6iAuLIh1svPqMLKYa+rpnsq6WJ5mBPRCu+sVlL8qdX0yn/c1imM13u?=
 =?us-ascii?Q?u2qTj6BwYSEFejCM8BGxuSFdB1bMewgdYGo1bKbBTxh5m0O/urJ76pzZUXrV?=
 =?us-ascii?Q?ueC+0gvpmlrnsTodDX3gZP8kbfbyF8K2QvZaDXFhcKUb3CpjZEFYE3vkJxmi?=
 =?us-ascii?Q?MS2FSbq/hfoCJTI3mdUejjh2WXfnd1jyPgE8xZPcAGsMYWweNS0qt9WUS16c?=
 =?us-ascii?Q?xfkRN68CQRL8V7WEEqnmT9slhLOhh1A6dyX/GhEE0Plfp9Y6oQEUKWaUnjPi?=
 =?us-ascii?Q?qAgWKCjyOJ9U6xgurvU2g77FQ+H+1b/OsS9ERtHalinpIOxzlUMUgY5N/eI/?=
 =?us-ascii?Q?S3eC2PQKN+UN+jZQgeXDxPaWSwlUY0WjadElKQ0KizSRbPL5BE3oUQplU0cO?=
 =?us-ascii?Q?R6X/alc28duX75rzZTDclEcTSN0yoXnEFOJYadhMsg2jc5NnMAenbGX/r/GW?=
 =?us-ascii?Q?0BVwfT1AwzGCToa5W38n5C0MQ22BtFcC4h5IQFXFTc2lf1x/EQbiFMWqU6Og?=
 =?us-ascii?Q?qKNfw/iSBL7o53njWBjHFOtJ74zpPJmAZc07v4EkIO5K5U7sOLjA0VF63RBn?=
 =?us-ascii?Q?bbt6M6hecL3Pke+zI0Ncb3iaC+Uny5jqPYyXPp/cjMmT8oHnHXVor7whU9YN?=
 =?us-ascii?Q?5IoC9Wuov2NqBbTkRP2V0S0Y+JVjRqe+CHawhbQEGFBgHbWc5iFmGAssrNGe?=
 =?us-ascii?Q?zYIKwviMEfrmqbp+2UYXetsKRceM4NPv3targqF1FpMB06IIVYqiOG76GL6h?=
 =?us-ascii?Q?zymTJfrsCYgJnjnzpvf7h8SGiegq6As/Y72FR1SRZUJ9rEDz4KMMsfKwq+em?=
 =?us-ascii?Q?TF0j51LvossLKCCzy87C9iaiW94P31Z04isbougEKMwDmY0uZNZnIyAa8eB6?=
 =?us-ascii?Q?5TNaRpSrEpPl3gLP82OhluOV2x4i6TFN9O9wGEkoufvUhJs0K+cVJgZgzvip?=
 =?us-ascii?Q?Fd7XSOD9Fi8ATKczNSm4BUZvuy6vxDSA2ED4iDW8GNu9fwp3Qm5cDP8+mB2C?=
 =?us-ascii?Q?x/qctpGcYD8kPEk4J+Tnqws8bK3TUc/JRfrwsxCjRCaXXsxCUt0oKa7qs8jK?=
 =?us-ascii?Q?pWJ1Mj/8I4aGhBrQXRByfySYMCBJRFfwUdkS5/+x0/sme/izoNMjElC6L6vN?=
 =?us-ascii?Q?XPGAPYcampBQPZTxT/xMIDThY1S42iNM04c5uYXXRbITjg+8Cc1X2QCbOSaF?=
 =?us-ascii?Q?qgmMGqdsBw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9499b130-37ff-4858-662d-08da2106e810
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:37.6214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uOHf7DrR5C/MPQOt9weyHekPtWJoIpCsCfNxMdcYWOEtE8lYFw0Cw4cy2UPtuMcDZ4WIn5tmnJf9LsOvFPovA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce objects for line cards and an infrastructure around that.
Use devlink_linecard_create/destroy() to register the line card with
devlink core. Implement provisioning ops with a list of supported
line cards.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  19 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  46 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 929 ++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   6 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   4 +
 6 files changed, 1006 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index 196adeb33495..1a465fd5d8b3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MLXSW_CORE)	+= mlxsw_core.o
 mlxsw_core-objs			:= core.o core_acl_flex_keys.o \
-				   core_acl_flex_actions.o core_env.o
+				   core_acl_flex_actions.o core_env.o \
+				   core_linecards.o
 mlxsw_core-$(CONFIG_MLXSW_CORE_HWMON) += core_hwmon.o
 mlxsw_core-$(CONFIG_MLXSW_CORE_THERMAL) += core_thermal.o
 obj-$(CONFIG_MLXSW_PCI)		+= mlxsw_pci.o
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index b13e0f8d232a..5e1855f752d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -82,6 +82,7 @@ struct mlxsw_core {
 	struct mlxsw_res res;
 	struct mlxsw_hwmon *hwmon;
 	struct mlxsw_thermal *thermal;
+	struct mlxsw_linecards *linecards;
 	struct mlxsw_core_port *ports;
 	unsigned int max_ports;
 	atomic_t active_ports_count;
@@ -94,6 +95,17 @@ struct mlxsw_core {
 	/* driver_priv has to be always the last item */
 };
 
+struct mlxsw_linecards *mlxsw_core_linecards(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->linecards;
+}
+
+void mlxsw_core_linecards_set(struct mlxsw_core *mlxsw_core,
+			      struct mlxsw_linecards *linecards)
+{
+	mlxsw_core->linecards = linecards;
+}
+
 #define MLXSW_PORT_MAX_PORTS_DEFAULT	0x40
 
 static u64 mlxsw_ports_occ_get(void *priv)
@@ -2145,6 +2157,10 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_fw_rev_validate;
 
+	err = mlxsw_linecards_init(mlxsw_core, mlxsw_bus_info);
+	if (err)
+		goto err_linecards_init;
+
 	err = mlxsw_core_health_init(mlxsw_core);
 	if (err)
 		goto err_health_init;
@@ -2183,6 +2199,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 err_hwmon_init:
 	mlxsw_core_health_fini(mlxsw_core);
 err_health_init:
+	mlxsw_linecards_fini(mlxsw_core);
+err_linecards_init:
 err_fw_rev_validate:
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
@@ -2255,6 +2273,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 	mlxsw_core_health_fini(mlxsw_core);
+	mlxsw_linecards_fini(mlxsw_core);
 	if (!reload)
 		mlxsw_core_params_unregister(mlxsw_core);
 	mlxsw_emad_fini(mlxsw_core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 16ee5e90973d..44c8a7888985 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -35,6 +35,11 @@ unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core);
 
 void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
+struct mlxsw_linecards *mlxsw_core_linecards(struct mlxsw_core *mlxsw_core);
+
+void mlxsw_core_linecards_set(struct mlxsw_core *mlxsw_core,
+			      struct mlxsw_linecards *linecard);
+
 bool
 mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
 					  const struct mlxsw_fw_rev *req_rev);
@@ -543,4 +548,45 @@ static inline struct mlxsw_skb_cb *mlxsw_skb_cb(struct sk_buff *skb)
 	return (struct mlxsw_skb_cb *) skb->cb;
 }
 
+struct mlxsw_linecards;
+
+enum mlxsw_linecard_status_event_type {
+	MLXSW_LINECARD_STATUS_EVENT_TYPE_PROVISION,
+	MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION,
+};
+
+struct mlxsw_linecard {
+	u8 slot_index;
+	struct mlxsw_linecards *linecards;
+	struct devlink_linecard *devlink_linecard;
+	struct mutex lock; /* Locks accesses to the linecard structure */
+	char name[MLXSW_REG_MDDQ_SLOT_ASCII_NAME_LEN];
+	char mbct_pl[MLXSW_REG_MBCT_LEN]; /* Too big for stack */
+	enum mlxsw_linecard_status_event_type status_event_type_to;
+	struct delayed_work status_event_to_dw;
+	u8 provisioned:1;
+	u16 hw_revision;
+	u16 ini_version;
+};
+
+struct mlxsw_linecard_types_info;
+
+struct mlxsw_linecards {
+	struct mlxsw_core *mlxsw_core;
+	const struct mlxsw_bus_info *bus_info;
+	u8 count;
+	struct mlxsw_linecard_types_info *types_info;
+	struct mlxsw_linecard linecards[];
+};
+
+static inline struct mlxsw_linecard *
+mlxsw_linecard_get(struct mlxsw_linecards *linecards, u8 slot_index)
+{
+	return &linecards->linecards[slot_index - 1];
+}
+
+int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
+			 const struct mlxsw_bus_info *bus_info);
+void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
new file mode 100644
index 000000000000..1401f6d34635
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -0,0 +1,929 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2022 NVIDIA Corporation and Mellanox Technologies. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/workqueue.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/vmalloc.h>
+
+#include "core.h"
+
+struct mlxsw_linecard_ini_file {
+	__le16 size;
+	union {
+		u8 data[0];
+		struct {
+			__be16 hw_revision;
+			__be16 ini_version;
+			u8 __dontcare[3];
+			u8 type;
+			u8 name[20];
+		} format;
+	};
+};
+
+struct mlxsw_linecard_types_info {
+	struct mlxsw_linecard_ini_file **ini_files;
+	unsigned int count;
+	size_t data_size;
+	char *data;
+};
+
+#define MLXSW_LINECARD_STATUS_EVENT_TO (10 * MSEC_PER_SEC)
+
+static void
+mlxsw_linecard_status_event_to_schedule(struct mlxsw_linecard *linecard,
+					enum mlxsw_linecard_status_event_type status_event_type)
+{
+	cancel_delayed_work_sync(&linecard->status_event_to_dw);
+	linecard->status_event_type_to = status_event_type;
+	mlxsw_core_schedule_dw(&linecard->status_event_to_dw,
+			       msecs_to_jiffies(MLXSW_LINECARD_STATUS_EVENT_TO));
+}
+
+static void
+mlxsw_linecard_status_event_done(struct mlxsw_linecard *linecard,
+				 enum mlxsw_linecard_status_event_type status_event_type)
+{
+	if (linecard->status_event_type_to == status_event_type)
+		cancel_delayed_work_sync(&linecard->status_event_to_dw);
+}
+
+static const char *
+mlxsw_linecard_types_lookup(struct mlxsw_linecards *linecards, u8 card_type)
+{
+	struct mlxsw_linecard_types_info *types_info;
+	struct mlxsw_linecard_ini_file *ini_file;
+	int i;
+
+	types_info = linecards->types_info;
+	if (!types_info)
+		return NULL;
+	for (i = 0; i < types_info->count; i++) {
+		ini_file = linecards->types_info->ini_files[i];
+		if (ini_file->format.type == card_type)
+			return ini_file->format.name;
+	}
+	return NULL;
+}
+
+static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	char mddq_pl[MLXSW_REG_MDDQ_LEN];
+	int err;
+
+	mlxsw_reg_mddq_slot_name_pack(mddq_pl, linecard->slot_index);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
+	if (err)
+		return ERR_PTR(err);
+	mlxsw_reg_mddq_slot_name_unpack(mddq_pl, linecard->name);
+	return linecard->name;
+}
+
+static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
+{
+	linecard->provisioned = false;
+	devlink_linecard_provision_fail(linecard->devlink_linecard);
+}
+
+static int
+mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
+			     u16 hw_revision, u16 ini_version)
+{
+	struct mlxsw_linecards *linecards = linecard->linecards;
+	const char *type;
+
+	type = mlxsw_linecard_types_lookup(linecards, card_type);
+	mlxsw_linecard_status_event_done(linecard,
+					 MLXSW_LINECARD_STATUS_EVENT_TYPE_PROVISION);
+	if (!type) {
+		/* It is possible for a line card to be provisioned before
+		 * driver initialization. Due to a missing INI bundle file
+		 * or an outdated one, the queried card's type might not
+		 * be recognized by the driver. In this case, try to query
+		 * the card's name from the device.
+		 */
+		type = mlxsw_linecard_type_name(linecard);
+		if (IS_ERR(type)) {
+			mlxsw_linecard_provision_fail(linecard);
+			return PTR_ERR(type);
+		}
+	}
+	linecard->provisioned = true;
+	linecard->hw_revision = hw_revision;
+	linecard->ini_version = ini_version;
+	devlink_linecard_provision_set(linecard->devlink_linecard, type);
+	return 0;
+}
+
+static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
+{
+	mlxsw_linecard_status_event_done(linecard,
+					 MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
+	linecard->provisioned = false;
+	devlink_linecard_provision_clear(linecard->devlink_linecard);
+}
+
+static int mlxsw_linecard_status_process(struct mlxsw_linecards *linecards,
+					 struct mlxsw_linecard *linecard,
+					 const char *mddq_pl)
+{
+	enum mlxsw_reg_mddq_slot_info_ready ready;
+	bool provisioned, sr_valid, active;
+	u16 ini_version, hw_revision;
+	u8 slot_index, card_type;
+	int err = 0;
+
+	mlxsw_reg_mddq_slot_info_unpack(mddq_pl, &slot_index, &provisioned,
+					&sr_valid, &ready, &active,
+					&hw_revision, &ini_version,
+					&card_type);
+
+	if (linecard) {
+		if (WARN_ON(slot_index != linecard->slot_index))
+			return -EINVAL;
+	} else {
+		if (WARN_ON(slot_index > linecards->count))
+			return -EINVAL;
+		linecard = mlxsw_linecard_get(linecards, slot_index);
+	}
+
+	mutex_lock(&linecard->lock);
+
+	if (provisioned && linecard->provisioned != provisioned) {
+		err = mlxsw_linecard_provision_set(linecard, card_type,
+						   hw_revision, ini_version);
+		if (err)
+			goto out;
+	}
+
+	if (!provisioned && linecard->provisioned != provisioned)
+		mlxsw_linecard_provision_clear(linecard);
+
+out:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
+static int mlxsw_linecard_status_get_and_process(struct mlxsw_core *mlxsw_core,
+						 struct mlxsw_linecards *linecards,
+						 struct mlxsw_linecard *linecard)
+{
+	char mddq_pl[MLXSW_REG_MDDQ_LEN];
+	int err;
+
+	mlxsw_reg_mddq_slot_info_pack(mddq_pl, linecard->slot_index, false);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
+	if (err)
+		return err;
+
+	return mlxsw_linecard_status_process(linecards, linecard, mddq_pl);
+}
+
+static const char * const mlxsw_linecard_status_event_type_name[] = {
+	[MLXSW_LINECARD_STATUS_EVENT_TYPE_PROVISION] = "provision",
+	[MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION] = "unprovision",
+};
+
+static void mlxsw_linecard_status_event_to_work(struct work_struct *work)
+{
+	struct mlxsw_linecard *linecard =
+		container_of(work, struct mlxsw_linecard,
+			     status_event_to_dw.work);
+
+	mutex_lock(&linecard->lock);
+	dev_err(linecard->linecards->bus_info->dev, "linecard %u: Timeout reached waiting on %s status event",
+		linecard->slot_index,
+		mlxsw_linecard_status_event_type_name[linecard->status_event_type_to]);
+	mlxsw_linecard_provision_fail(linecard);
+	mutex_unlock(&linecard->lock);
+}
+
+static int __mlxsw_linecard_fix_fsm_state(struct mlxsw_linecard *linecard)
+{
+	dev_info(linecard->linecards->bus_info->dev, "linecard %u: Clearing FSM state error",
+		 linecard->slot_index);
+	mlxsw_reg_mbct_pack(linecard->mbct_pl, linecard->slot_index,
+			    MLXSW_REG_MBCT_OP_CLEAR_ERRORS, false);
+	return mlxsw_reg_write(linecard->linecards->mlxsw_core,
+			       MLXSW_REG(mbct), linecard->mbct_pl);
+}
+
+static int mlxsw_linecard_fix_fsm_state(struct mlxsw_linecard *linecard,
+					enum mlxsw_reg_mbct_fsm_state fsm_state)
+{
+	if (fsm_state != MLXSW_REG_MBCT_FSM_STATE_ERROR)
+		return 0;
+	return __mlxsw_linecard_fix_fsm_state(linecard);
+}
+
+static int
+mlxsw_linecard_query_ini_status(struct mlxsw_linecard *linecard,
+				enum mlxsw_reg_mbct_status *status,
+				enum mlxsw_reg_mbct_fsm_state *fsm_state,
+				struct netlink_ext_ack *extack)
+{
+	int err;
+
+	mlxsw_reg_mbct_pack(linecard->mbct_pl, linecard->slot_index,
+			    MLXSW_REG_MBCT_OP_QUERY_STATUS, false);
+	err = mlxsw_reg_query(linecard->linecards->mlxsw_core, MLXSW_REG(mbct),
+			      linecard->mbct_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to query linecard INI status");
+		return err;
+	}
+	mlxsw_reg_mbct_unpack(linecard->mbct_pl, NULL, status, fsm_state);
+	return err;
+}
+
+static int
+mlxsw_linecard_ini_transfer(struct mlxsw_core *mlxsw_core,
+			    struct mlxsw_linecard *linecard,
+			    const struct mlxsw_linecard_ini_file *ini_file,
+			    struct netlink_ext_ack *extack)
+{
+	enum mlxsw_reg_mbct_fsm_state fsm_state;
+	enum mlxsw_reg_mbct_status status;
+	size_t size_left;
+	const u8 *data;
+	int err;
+
+	size_left = le16_to_cpu(ini_file->size);
+	data = ini_file->data;
+	while (size_left) {
+		size_t data_size = MLXSW_REG_MBCT_DATA_LEN;
+		bool is_last = false;
+
+		if (size_left <= MLXSW_REG_MBCT_DATA_LEN) {
+			data_size = size_left;
+			is_last = true;
+		}
+
+		mlxsw_reg_mbct_pack(linecard->mbct_pl, linecard->slot_index,
+				    MLXSW_REG_MBCT_OP_DATA_TRANSFER, false);
+		mlxsw_reg_mbct_dt_pack(linecard->mbct_pl, data_size,
+				       is_last, data);
+		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mbct),
+				      linecard->mbct_pl);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to issue linecard INI data transfer");
+			return err;
+		}
+		mlxsw_reg_mbct_unpack(linecard->mbct_pl, NULL,
+				      &status, &fsm_state);
+		if ((!is_last && status != MLXSW_REG_MBCT_STATUS_PART_DATA) ||
+		    (is_last && status != MLXSW_REG_MBCT_STATUS_LAST_DATA)) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to transfer linecard INI data");
+			mlxsw_linecard_fix_fsm_state(linecard, fsm_state);
+			return -EINVAL;
+		}
+		size_left -= data_size;
+		data += data_size;
+	}
+
+	return 0;
+}
+
+static int
+mlxsw_linecard_ini_erase(struct mlxsw_core *mlxsw_core,
+			 struct mlxsw_linecard *linecard,
+			 struct netlink_ext_ack *extack)
+{
+	enum mlxsw_reg_mbct_fsm_state fsm_state;
+	enum mlxsw_reg_mbct_status status;
+	int err;
+
+	mlxsw_reg_mbct_pack(linecard->mbct_pl, linecard->slot_index,
+			    MLXSW_REG_MBCT_OP_ERASE_INI_IMAGE, false);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mbct),
+			      linecard->mbct_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to issue linecard INI erase");
+		return err;
+	}
+	mlxsw_reg_mbct_unpack(linecard->mbct_pl, NULL, &status, &fsm_state);
+	switch (status) {
+	case MLXSW_REG_MBCT_STATUS_ERASE_COMPLETE:
+		break;
+	default:
+		/* Should not happen */
+		fallthrough;
+	case MLXSW_REG_MBCT_STATUS_ERASE_FAILED:
+		NL_SET_ERR_MSG_MOD(extack, "Failed to erase linecard INI");
+		goto fix_fsm_err_out;
+	case MLXSW_REG_MBCT_STATUS_ERROR_INI_IN_USE:
+		NL_SET_ERR_MSG_MOD(extack, "Failed to erase linecard INI while being used");
+		goto fix_fsm_err_out;
+	}
+	return 0;
+
+fix_fsm_err_out:
+	mlxsw_linecard_fix_fsm_state(linecard, fsm_state);
+	return -EINVAL;
+}
+
+static void mlxsw_linecard_bct_process(struct mlxsw_core *mlxsw_core,
+				       const char *mbct_pl)
+{
+	struct mlxsw_linecards *linecards = mlxsw_core_linecards(mlxsw_core);
+	enum mlxsw_reg_mbct_fsm_state fsm_state;
+	enum mlxsw_reg_mbct_status status;
+	struct mlxsw_linecard *linecard;
+	u8 slot_index;
+
+	mlxsw_reg_mbct_unpack(mbct_pl, &slot_index, &status, &fsm_state);
+	if (WARN_ON(slot_index > linecards->count))
+		return;
+	linecard = mlxsw_linecard_get(linecards, slot_index);
+	mutex_lock(&linecard->lock);
+	if (status == MLXSW_REG_MBCT_STATUS_ACTIVATION_FAILED) {
+		dev_err(linecards->bus_info->dev, "linecard %u: Failed to activate INI",
+			linecard->slot_index);
+		goto fix_fsm_out;
+	}
+	mutex_unlock(&linecard->lock);
+	return;
+
+fix_fsm_out:
+	mlxsw_linecard_fix_fsm_state(linecard, fsm_state);
+	mlxsw_linecard_provision_fail(linecard);
+	mutex_unlock(&linecard->lock);
+}
+
+static int
+mlxsw_linecard_ini_activate(struct mlxsw_core *mlxsw_core,
+			    struct mlxsw_linecard *linecard,
+			    struct netlink_ext_ack *extack)
+{
+	enum mlxsw_reg_mbct_fsm_state fsm_state;
+	enum mlxsw_reg_mbct_status status;
+	int err;
+
+	mlxsw_reg_mbct_pack(linecard->mbct_pl, linecard->slot_index,
+			    MLXSW_REG_MBCT_OP_ACTIVATE, true);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mbct), linecard->mbct_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to issue linecard INI activation");
+		return err;
+	}
+	mlxsw_reg_mbct_unpack(linecard->mbct_pl, NULL, &status, &fsm_state);
+	if (status == MLXSW_REG_MBCT_STATUS_ACTIVATION_FAILED) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to activate linecard INI");
+		goto fix_fsm_err_out;
+	}
+
+	return 0;
+
+fix_fsm_err_out:
+	mlxsw_linecard_fix_fsm_state(linecard, fsm_state);
+	return -EINVAL;
+}
+
+#define MLXSW_LINECARD_INI_WAIT_RETRIES 10
+#define MLXSW_LINECARD_INI_WAIT_MS 500
+
+static int
+mlxsw_linecard_ini_in_use_wait(struct mlxsw_core *mlxsw_core,
+			       struct mlxsw_linecard *linecard,
+			       struct netlink_ext_ack *extack)
+{
+	enum mlxsw_reg_mbct_fsm_state fsm_state;
+	enum mlxsw_reg_mbct_status status;
+	unsigned int ini_wait_retries = 0;
+	int err;
+
+query_ini_status:
+	err = mlxsw_linecard_query_ini_status(linecard, &status,
+					      &fsm_state, extack);
+	if (err)
+		return err;
+
+	switch (fsm_state) {
+	case MLXSW_REG_MBCT_FSM_STATE_INI_IN_USE:
+		if (ini_wait_retries++ > MLXSW_LINECARD_INI_WAIT_RETRIES) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to wait for linecard INI to be unused");
+			return -EINVAL;
+		}
+		mdelay(MLXSW_LINECARD_INI_WAIT_MS);
+		goto query_ini_status;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int mlxsw_linecard_provision(struct devlink_linecard *devlink_linecard,
+				    void *priv, const char *type,
+				    const void *type_priv,
+				    struct netlink_ext_ack *extack)
+{
+	const struct mlxsw_linecard_ini_file *ini_file = type_priv;
+	struct mlxsw_linecard *linecard = priv;
+	struct mlxsw_core *mlxsw_core;
+	int err;
+
+	mutex_lock(&linecard->lock);
+
+	mlxsw_core = linecard->linecards->mlxsw_core;
+
+	err = mlxsw_linecard_ini_erase(mlxsw_core, linecard, extack);
+	if (err)
+		goto err_out;
+
+	err = mlxsw_linecard_ini_transfer(mlxsw_core, linecard,
+					  ini_file, extack);
+	if (err)
+		goto err_out;
+
+	mlxsw_linecard_status_event_to_schedule(linecard,
+						MLXSW_LINECARD_STATUS_EVENT_TYPE_PROVISION);
+	err = mlxsw_linecard_ini_activate(mlxsw_core, linecard, extack);
+	if (err)
+		goto err_out;
+
+	goto out;
+
+err_out:
+	mlxsw_linecard_provision_fail(linecard);
+out:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
+static int mlxsw_linecard_unprovision(struct devlink_linecard *devlink_linecard,
+				      void *priv,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlxsw_linecard *linecard = priv;
+	struct mlxsw_core *mlxsw_core;
+	int err;
+
+	mutex_lock(&linecard->lock);
+
+	mlxsw_core = linecard->linecards->mlxsw_core;
+
+	err = mlxsw_linecard_ini_in_use_wait(mlxsw_core, linecard, extack);
+	if (err)
+		goto err_out;
+
+	mlxsw_linecard_status_event_to_schedule(linecard,
+						MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
+	err = mlxsw_linecard_ini_erase(mlxsw_core, linecard, extack);
+	if (err)
+		goto err_out;
+
+	goto out;
+
+err_out:
+	mlxsw_linecard_provision_fail(linecard);
+out:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
+static bool mlxsw_linecard_same_provision(struct devlink_linecard *devlink_linecard,
+					  void *priv, const char *type,
+					  const void *type_priv)
+{
+	const struct mlxsw_linecard_ini_file *ini_file = type_priv;
+	struct mlxsw_linecard *linecard = priv;
+	bool ret;
+
+	mutex_lock(&linecard->lock);
+	ret = linecard->hw_revision == be16_to_cpu(ini_file->format.hw_revision) &&
+	      linecard->ini_version == be16_to_cpu(ini_file->format.ini_version);
+	mutex_unlock(&linecard->lock);
+	return ret;
+}
+
+static unsigned int
+mlxsw_linecard_types_count(struct devlink_linecard *devlink_linecard,
+			   void *priv)
+{
+	struct mlxsw_linecard *linecard = priv;
+
+	return linecard->linecards->types_info ?
+	       linecard->linecards->types_info->count : 0;
+}
+
+static void mlxsw_linecard_types_get(struct devlink_linecard *devlink_linecard,
+				     void *priv, unsigned int index,
+				     const char **type, const void **type_priv)
+{
+	struct mlxsw_linecard_types_info *types_info;
+	struct mlxsw_linecard_ini_file *ini_file;
+	struct mlxsw_linecard *linecard = priv;
+
+	types_info = linecard->linecards->types_info;
+	if (WARN_ON_ONCE(!types_info))
+		return;
+	ini_file = types_info->ini_files[index];
+	*type = ini_file->format.name;
+	*type_priv = ini_file;
+}
+
+static const struct devlink_linecard_ops mlxsw_linecard_ops = {
+	.provision = mlxsw_linecard_provision,
+	.unprovision = mlxsw_linecard_unprovision,
+	.same_provision = mlxsw_linecard_same_provision,
+	.types_count = mlxsw_linecard_types_count,
+	.types_get = mlxsw_linecard_types_get,
+};
+
+struct mlxsw_linecard_status_event {
+	struct mlxsw_core *mlxsw_core;
+	char mddq_pl[MLXSW_REG_MDDQ_LEN];
+	struct work_struct work;
+};
+
+static void mlxsw_linecard_status_event_work(struct work_struct *work)
+{
+	struct mlxsw_linecard_status_event *event;
+	struct mlxsw_linecards *linecards;
+	struct mlxsw_core *mlxsw_core;
+
+	event = container_of(work, struct mlxsw_linecard_status_event, work);
+	mlxsw_core = event->mlxsw_core;
+	linecards = mlxsw_core_linecards(mlxsw_core);
+	mlxsw_linecard_status_process(linecards, NULL, event->mddq_pl);
+	kfree(event);
+}
+
+static void
+mlxsw_linecard_status_listener_func(const struct mlxsw_reg_info *reg,
+				    char *mddq_pl, void *priv)
+{
+	struct mlxsw_linecard_status_event *event;
+	struct mlxsw_core *mlxsw_core = priv;
+
+	event = kmalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return;
+	event->mlxsw_core = mlxsw_core;
+	memcpy(event->mddq_pl, mddq_pl, sizeof(event->mddq_pl));
+	INIT_WORK(&event->work, mlxsw_linecard_status_event_work);
+	mlxsw_core_schedule_work(&event->work);
+}
+
+struct mlxsw_linecard_bct_event {
+	struct mlxsw_core *mlxsw_core;
+	char mbct_pl[MLXSW_REG_MBCT_LEN];
+	struct work_struct work;
+};
+
+static void mlxsw_linecard_bct_event_work(struct work_struct *work)
+{
+	struct mlxsw_linecard_bct_event *event;
+	struct mlxsw_core *mlxsw_core;
+
+	event = container_of(work, struct mlxsw_linecard_bct_event, work);
+	mlxsw_core = event->mlxsw_core;
+	mlxsw_linecard_bct_process(mlxsw_core, event->mbct_pl);
+	kfree(event);
+}
+
+static void
+mlxsw_linecard_bct_listener_func(const struct mlxsw_reg_info *reg,
+				 char *mbct_pl, void *priv)
+{
+	struct mlxsw_linecard_bct_event *event;
+	struct mlxsw_core *mlxsw_core = priv;
+
+	event = kmalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return;
+	event->mlxsw_core = mlxsw_core;
+	memcpy(event->mbct_pl, mbct_pl, sizeof(event->mbct_pl));
+	INIT_WORK(&event->work, mlxsw_linecard_bct_event_work);
+	mlxsw_core_schedule_work(&event->work);
+}
+
+static const struct mlxsw_listener mlxsw_linecard_listener[] = {
+	MLXSW_CORE_EVENTL(mlxsw_linecard_status_listener_func, DSDSC),
+	MLXSW_CORE_EVENTL(mlxsw_linecard_bct_listener_func, BCTOE),
+};
+
+static int mlxsw_linecard_event_delivery_set(struct mlxsw_core *mlxsw_core,
+					     struct mlxsw_linecard *linecard,
+					     bool enable)
+{
+	char mddq_pl[MLXSW_REG_MDDQ_LEN];
+
+	mlxsw_reg_mddq_slot_info_pack(mddq_pl, linecard->slot_index, enable);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
+}
+
+static int mlxsw_linecard_init(struct mlxsw_core *mlxsw_core,
+			       struct mlxsw_linecards *linecards,
+			       u8 slot_index)
+{
+	struct devlink_linecard *devlink_linecard;
+	struct mlxsw_linecard *linecard;
+	int err;
+
+	linecard = mlxsw_linecard_get(linecards, slot_index);
+	linecard->slot_index = slot_index;
+	linecard->linecards = linecards;
+	mutex_init(&linecard->lock);
+
+	devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
+						   slot_index, &mlxsw_linecard_ops,
+						   linecard);
+	if (IS_ERR(devlink_linecard)) {
+		err = PTR_ERR(devlink_linecard);
+		goto err_devlink_linecard_create;
+	}
+	linecard->devlink_linecard = devlink_linecard;
+	INIT_DELAYED_WORK(&linecard->status_event_to_dw,
+			  &mlxsw_linecard_status_event_to_work);
+
+	err = mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, true);
+	if (err)
+		goto err_event_delivery_set;
+
+	err = mlxsw_linecard_status_get_and_process(mlxsw_core, linecards,
+						    linecard);
+	if (err)
+		goto err_status_get_and_process;
+
+	return 0;
+
+err_status_get_and_process:
+	mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, false);
+err_event_delivery_set:
+	devlink_linecard_destroy(linecard->devlink_linecard);
+err_devlink_linecard_create:
+	mutex_destroy(&linecard->lock);
+	return err;
+}
+
+static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
+				struct mlxsw_linecards *linecards,
+				u8 slot_index)
+{
+	struct mlxsw_linecard *linecard;
+
+	linecard = mlxsw_linecard_get(linecards, slot_index);
+	mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, false);
+	cancel_delayed_work_sync(&linecard->status_event_to_dw);
+	/* Make sure all scheduled events are processed */
+	mlxsw_core_flush_owq();
+	devlink_linecard_destroy(linecard->devlink_linecard);
+	mutex_destroy(&linecard->lock);
+}
+
+/*       LINECARDS INI BUNDLE FILE
+ *  +----------------------------------+
+ *  |        MAGIC ("NVLCINI+")        |
+ *  +----------------------------------+     +--------------------+
+ *  |  INI 0                           +---> | __le16 size        |
+ *  +----------------------------------+     | __be16 hw_revision |
+ *  |  INI 1                           |     | __be16 ini_version |
+ *  +----------------------------------+     | u8 __dontcare[3]   |
+ *  |  ...                             |     | u8 type            |
+ *  +----------------------------------+     | u8 name[20]        |
+ *  |  INI N                           |     | ...                |
+ *  +----------------------------------+     +--------------------+
+ */
+
+#define MLXSW_LINECARDS_INI_BUNDLE_MAGIC "NVLCINI+"
+
+static int
+mlxsw_linecard_types_file_validate(struct mlxsw_linecards *linecards,
+				   struct mlxsw_linecard_types_info *types_info)
+{
+	size_t magic_size = strlen(MLXSW_LINECARDS_INI_BUNDLE_MAGIC);
+	struct mlxsw_linecard_ini_file *ini_file;
+	size_t size = types_info->data_size;
+	const u8 *data = types_info->data;
+	unsigned int count = 0;
+	u16 ini_file_size;
+
+	if (size < magic_size) {
+		dev_warn(linecards->bus_info->dev, "Invalid linecards INIs file size, smaller than magic size\n");
+		return -EINVAL;
+	}
+	if (memcmp(data, MLXSW_LINECARDS_INI_BUNDLE_MAGIC, magic_size)) {
+		dev_warn(linecards->bus_info->dev, "Invalid linecards INIs file magic pattern\n");
+		return -EINVAL;
+	}
+
+	data += magic_size;
+	size -= magic_size;
+
+	while (size > 0) {
+		if (size < sizeof(*ini_file)) {
+			dev_warn(linecards->bus_info->dev, "Linecards INIs file contains INI which is smaller than bare minimum\n");
+			return -EINVAL;
+		}
+		ini_file = (struct mlxsw_linecard_ini_file *) data;
+		ini_file_size = le16_to_cpu(ini_file->size);
+		if (ini_file_size + sizeof(__le16) > size) {
+			dev_warn(linecards->bus_info->dev, "Linecards INIs file appears to be truncated\n");
+			return -EINVAL;
+		}
+		if (ini_file_size % 4) {
+			dev_warn(linecards->bus_info->dev, "Linecards INIs file contains INI with invalid size\n");
+			return -EINVAL;
+		}
+		data += ini_file_size + sizeof(__le16);
+		size -= ini_file_size + sizeof(__le16);
+		count++;
+	}
+	if (!count) {
+		dev_warn(linecards->bus_info->dev, "Linecards INIs file does not contain any INI\n");
+		return -EINVAL;
+	}
+	types_info->count = count;
+	return 0;
+}
+
+static void
+mlxsw_linecard_types_file_parse(struct mlxsw_linecard_types_info *types_info)
+{
+	size_t magic_size = strlen(MLXSW_LINECARDS_INI_BUNDLE_MAGIC);
+	size_t size = types_info->data_size - magic_size;
+	const u8 *data = types_info->data + magic_size;
+	struct mlxsw_linecard_ini_file *ini_file;
+	unsigned int count = 0;
+	u16 ini_file_size;
+	int i;
+
+	while (size) {
+		ini_file = (struct mlxsw_linecard_ini_file *) data;
+		ini_file_size = le16_to_cpu(ini_file->size);
+		for (i = 0; i < ini_file_size / 4; i++) {
+			u32 *val = &((u32 *) ini_file->data)[i];
+
+			*val = swab32(*val);
+		}
+		types_info->ini_files[count] = ini_file;
+		data += ini_file_size + sizeof(__le16);
+		size -= ini_file_size + sizeof(__le16);
+		count++;
+	}
+}
+
+#define MLXSW_LINECARDS_INI_BUNDLE_FILENAME_FMT \
+	"mellanox/lc_ini_bundle_%u_%u.bin"
+#define MLXSW_LINECARDS_INI_BUNDLE_FILENAME_LEN \
+	(sizeof(MLXSW_LINECARDS_INI_BUNDLE_FILENAME_FMT) + 4)
+
+static int mlxsw_linecard_types_init(struct mlxsw_core *mlxsw_core,
+				     struct mlxsw_linecards *linecards)
+{
+	const struct mlxsw_fw_rev *rev = &linecards->bus_info->fw_rev;
+	char filename[MLXSW_LINECARDS_INI_BUNDLE_FILENAME_LEN];
+	struct mlxsw_linecard_types_info *types_info;
+	const struct firmware *firmware;
+	int err;
+
+	err = snprintf(filename, sizeof(filename),
+		       MLXSW_LINECARDS_INI_BUNDLE_FILENAME_FMT,
+		       rev->minor, rev->subminor);
+	WARN_ON(err >= sizeof(filename));
+
+	err = request_firmware_direct(&firmware, filename,
+				      linecards->bus_info->dev);
+	if (err) {
+		dev_warn(linecards->bus_info->dev, "Could not request linecards INI file \"%s\", provisioning will not be possible\n",
+			 filename);
+		return 0;
+	}
+
+	types_info = kzalloc(sizeof(*types_info), GFP_KERNEL);
+	if (!types_info) {
+		release_firmware(firmware);
+		return -ENOMEM;
+	}
+	linecards->types_info = types_info;
+
+	types_info->data_size = firmware->size;
+	types_info->data = vmalloc(types_info->data_size);
+	if (!types_info->data) {
+		err = -ENOMEM;
+		release_firmware(firmware);
+		goto err_data_alloc;
+	}
+	memcpy(types_info->data, firmware->data, types_info->data_size);
+	release_firmware(firmware);
+
+	err = mlxsw_linecard_types_file_validate(linecards, types_info);
+	if (err) {
+		err = 0;
+		goto err_type_file_file_validate;
+	}
+
+	types_info->ini_files = kmalloc_array(types_info->count,
+					      sizeof(struct mlxsw_linecard_ini_file),
+					      GFP_KERNEL);
+	if (!types_info->ini_files) {
+		err = -ENOMEM;
+		goto err_ini_files_alloc;
+	}
+
+	mlxsw_linecard_types_file_parse(types_info);
+
+	return 0;
+
+err_ini_files_alloc:
+err_type_file_file_validate:
+	vfree(types_info->data);
+err_data_alloc:
+	kfree(types_info);
+	return err;
+}
+
+static void mlxsw_linecard_types_fini(struct mlxsw_linecards *linecards)
+{
+	struct mlxsw_linecard_types_info *types_info = linecards->types_info;
+
+	if (!types_info)
+		return;
+	kfree(types_info->ini_files);
+	vfree(types_info->data);
+	kfree(types_info);
+}
+
+int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
+			 const struct mlxsw_bus_info *bus_info)
+{
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	struct mlxsw_linecards *linecards;
+	u8 slot_count;
+	int err;
+	int i;
+
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
+			       NULL, &slot_count);
+	if (!slot_count)
+		return 0;
+
+	linecards = vzalloc(struct_size(linecards, linecards, slot_count));
+	if (!linecards)
+		return -ENOMEM;
+	linecards->count = slot_count;
+	linecards->mlxsw_core = mlxsw_core;
+	linecards->bus_info = bus_info;
+
+	err = mlxsw_linecard_types_init(mlxsw_core, linecards);
+	if (err)
+		goto err_types_init;
+
+	err = mlxsw_core_traps_register(mlxsw_core, mlxsw_linecard_listener,
+					ARRAY_SIZE(mlxsw_linecard_listener),
+					mlxsw_core);
+	if (err)
+		goto err_traps_register;
+
+	mlxsw_core_linecards_set(mlxsw_core, linecards);
+
+	for (i = 0; i < linecards->count; i++) {
+		err = mlxsw_linecard_init(mlxsw_core, linecards, i + 1);
+		if (err)
+			goto err_linecard_init;
+	}
+
+	return 0;
+
+err_linecard_init:
+	for (i--; i >= 0; i--)
+		mlxsw_linecard_fini(mlxsw_core, linecards, i + 1);
+	mlxsw_core_traps_unregister(mlxsw_core, mlxsw_linecard_listener,
+				    ARRAY_SIZE(mlxsw_linecard_listener),
+				    mlxsw_core);
+err_traps_register:
+	mlxsw_linecard_types_fini(linecards);
+err_types_init:
+	vfree(linecards);
+	return err;
+}
+
+void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_linecards *linecards = mlxsw_core_linecards(mlxsw_core);
+	int i;
+
+	if (!linecards)
+		return;
+	for (i = 0; i < linecards->count; i++)
+		mlxsw_linecard_fini(mlxsw_core, linecards, i + 1);
+	mlxsw_core_traps_unregister(mlxsw_core, mlxsw_linecard_listener,
+				    ARRAY_SIZE(mlxsw_linecard_listener),
+				    mlxsw_core);
+	mlxsw_linecard_types_fini(linecards);
+	vfree(linecards);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c3457a216642..b4e064bd77bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -89,6 +89,11 @@ static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	"." __stringify(MLXSW_SP_FWREV_MINOR) \
 	"." __stringify(MLXSW_SP_FWREV_SUBMINOR) ".mfa2"
 
+#define MLXSW_SP_LINECARDS_INI_BUNDLE_FILENAME \
+	"mellanox/lc_ini_bundle_" \
+	__stringify(MLXSW_SP_FWREV_MINOR) "_" \
+	__stringify(MLXSW_SP_FWREV_SUBMINOR) ".bin"
+
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
 static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
@@ -5159,3 +5164,4 @@ MODULE_DEVICE_TABLE(pci, mlxsw_sp4_pci_id_table);
 MODULE_FIRMWARE(MLXSW_SP1_FW_FILENAME);
 MODULE_FIRMWARE(MLXSW_SP2_FW_FILENAME);
 MODULE_FIRMWARE(MLXSW_SP3_FW_FILENAME);
+MODULE_FIRMWARE(MLXSW_SP_LINECARDS_INI_BUNDLE_FILENAME);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 7405c400f09b..d888498aed33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -133,6 +133,10 @@ enum mlxsw_event_trap_id {
 	MLXSW_TRAP_ID_PTP_ING_FIFO = 0x2D,
 	/* PTP Egress FIFO has a new entry */
 	MLXSW_TRAP_ID_PTP_EGR_FIFO = 0x2E,
+	/* Downstream Device Status Change */
+	MLXSW_TRAP_ID_DSDSC = 0x321,
+	/* Binary Code Transfer Operation Executed Event */
+	MLXSW_TRAP_ID_BCTOE = 0x322,
 	/* Port mapping change */
 	MLXSW_TRAP_ID_PMLPE = 0x32E,
 };
-- 
2.33.1

