Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B92D55D119
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiF0HHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiF0HHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACF95F56
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cvq9oo22KyLIpEKC3ilfspAkFtuRaPUvJLKgWZShLNnNZrqpHKW26o6SJfTcGzd63bfsNAO+qka7ouZ9cKkgUeNclCgnQPlXkrmBW/BRR7u6S+lu+xT2NzAnVNjomTc4Ewt8iNRnhLlm+sNXXups4P9tUFiqQYJobvfToRM+xzysL8S0F2lCZEWOWnkxE5VbbVCXtCnbGCsxo4bcDqB7dvHomP2ndDeuhdIaTWFGBNS3DhlKKajyOCfFOOZCh8LeHY4hgmoWIpuyK3PKYxV/9zUl27CHAJ6w82KimGQIonRgAYlUihVd9DAO3c6CHkUFerzYTDZB5OgGD9SzouUtbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bum3t0JRoQ0TQZz1rambujIUnkaKzNhXmRPtx+tM98g=;
 b=ao+G4OP/t+aed/0h1SO9iBBEi3gHI+qwms3Cza4jJH88YmeXJT3+IZk+40jlCuBrAkrnToozbqykX6hwSiu/aGer03KtQCr3hjBwezCQM4Kw3qFu7QDYfU+XeF5IDbov/swa7+glU0BjsXqK3dgFRBu0Oo3pi+fqIu0COpn0m8Htn+iqv5vRBv1+3CyTgmOBj3gLroW0sBkx4FS1QHbLUKnE1yTQjf9RHtAJZ7tv+1+xwMSpFNFA+eDKwZWh5I1+ida4yYSXpa4M37FAmOx51KxJRKYaZKj3Xy0GyzKlhAOSHcGrUWGcM+kbLWPsMudhGWe2NCjbtUfUvp/ZpHNhUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bum3t0JRoQ0TQZz1rambujIUnkaKzNhXmRPtx+tM98g=;
 b=KfjDZgvbVJhh4H4tg4JYrL1g2AqlbL0aoBrMbkmKGd5SR560QRhEZGCtAKfcFX8T72rxQa7jaHzgdRDAELt6Sq71qOTny8tpWTOoPnO0MLr+lNknki2hO9SH2MqaQRcAPNpBNHOVqapE8uiBvJbv8bucrgGBtYInz5Y/4D0ouHvLFtoRJ5xztCn+wXanBNAAbNIc4Z4DFVKkftLASES0N8RrUZOrfv33Bjo9QdaWvqUvVveX2JBV3VD1s3rwS9xBHbfD+KeVXxJnXQ3z3NKrLOe3bS3kD/6QQekh79L6coiE+Rf6tfY/SNUZWzMAZMMqRp1RXN5BR9QzQWHkbJ8WgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/13] mlxsw: Add an initial PGT table support
Date:   Mon, 27 Jun 2022 10:06:15 +0300
Message-Id: <20220627070621.648499-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0219.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a5afb4-fe56-437a-759d-08da580bb959
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +oBXoIKiolesXmAmbU0OMNBHC+nKRAQLjLDvK/KJnYCWcigRMQAFDi3fzaP+HZQoU10BdE04htSMCfz4cuDf57Ir51ttuf6VKcd32NSyUgDU5pis3qSxUTjTm/3+ycvptiOVfc5ORtgbO2oP5YMzdZOkhkKo6A0hQ6qv81JDNc6EFhltheXqk0A+E6NXhn+qnSTnC/Hk/LHKOL9POF4FMINxd+i/vF6OQnNsXaZzM70pzmEz97cSqmMQ3FCibK8T2YZFowIQM8NR3fEMEAh/V5eq4O1z/rV0DYYxI5oApZmb2I0ZD4qqRS/FNqqun1dxoY4/BoZ+Lu9o0rLMYCuyukFPvMauUhqj2c5XRr637Kpq4id4C7TABe4M9QRcj6Cd4XT40cIkeLqUBcgZA/wUsCOZCmAzMhscAQMcjGkuk0V2VkBjYsek93V8UjIx3cDBp1EwXwMPTKCznhJ5JHxt96/oEEzWFcE7/CTNydxESCcyEiYOZb10E6bAOrdbMR1pQaaKC/Aayp0FZofzOE3fz9lSanuaND0vIpOqEao1NgRz5iCCnv+v6cwrlf5T/GNJuLLJpGyFEQVOGwRFy3G0lAYLQHsaLbI+k8RotfrU7FiMXmpmnuSim3HnRxL5qj9COLXUzHpzgLwQkVSvtlEtABySLGNZNOgP6EkZtwEZDkDFv56V64ZNkfQ+2MGm9yRF+w0nrEfiGzczA9L++QwrX5tfELOfbi0CFY7zrTN8kbZNFyElWC007aye3zPNzA7u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d7ucKWtiymOppxLI43UVPXP7xjXpAIwkdLfIo+wPi/1MVcde91c64YyGwvAi?=
 =?us-ascii?Q?0x/mVsyKjRDYTZGmdGAocgnhjeAOzX4YNsVzPby08MF1I8vhcb5+6Bgo/6nq?=
 =?us-ascii?Q?Is9qrf+LSDKo2M59okOEOXYvwJu/XnxuM4NPY5wf90xX2NzqDocE8YNTMMdF?=
 =?us-ascii?Q?KF/MAZrfUg5POM87JFlPCqNtHXfWrN1Cy8EyIXJq1QrTaXkErJWH6kGNeAAm?=
 =?us-ascii?Q?UxAlTIjpJZ8nAE5lX+LA28SIWUKTbKrfHeeqnnrwMskyKYZeOjUH9zXqrf/J?=
 =?us-ascii?Q?vy8vOEeScPOQapNlprqeEykm/yj8FL0qV6cwcvDuzTEYSoMHmFVr3qYxthum?=
 =?us-ascii?Q?xzPZpqGv2HMTsCEfCrcgL1G4RImX4Alp0Q53s4NulhZ9N8IZDPP/fmUBEJda?=
 =?us-ascii?Q?9mbjMd6Gl5K3fvzGJsIjgk6+zv30bYBvdp1IrWzN/k9KXHPyoXO5r3nx+v4k?=
 =?us-ascii?Q?Q4IwfRrnck07ZCUPk/p5mDERGZBByoZUCNCbYYxhPI6g59/Nhy0eDV8MfxIo?=
 =?us-ascii?Q?zAE1nRrKOxHfBs4xfwhCxQXiRCuvylS8aDSvycIGeX9pzgbl8f+S9oRZ0yW9?=
 =?us-ascii?Q?gJhuyizA/gOJ+VgqciQ8lrQIisTuCsmE/khM+ApyZKOE5Ho6Yvee40wOFZf1?=
 =?us-ascii?Q?zQ43Gl2Gg1BcE1w9jYzdR+jEmdwGYsti/9r9o0rEFf5NVEhx1RWzMsgmcBtD?=
 =?us-ascii?Q?zSxUxS0CMO7fJ1HmNf7j6123/elB7ApreihzZJWuEgbmL0KTHKDEn8OF3VIs?=
 =?us-ascii?Q?dDUyV8dY196cYMZxqyfWw0fg4Sx/eXJinrIsUSpCAnAbUDTUcWWQdUh7aHRx?=
 =?us-ascii?Q?v7Rfv4tAksavZL5YWDioqdfIaVs+F6wrTFfw3+9XHl33HmH/FYhwK+1OdCHM?=
 =?us-ascii?Q?130y7TnmRtN5ghgk2FtURA/Iq3vjO2IkSxibJVJJUyCmaJa0ikUCFmeaUpNB?=
 =?us-ascii?Q?QvfOVm71HnSiQ9FmG6847R79OKBG4QMGyc5jpzpxEuOyzh4WFA6NDJL54CZ/?=
 =?us-ascii?Q?OIy4e5+HUSFMMoTKLBjBSubuHYe6O86KwS8ZccoCr3fxhrFuPVDxWTBfIshm?=
 =?us-ascii?Q?xknQrOKlUrGNdE4wI7VMrHbTYztTIQgeARia1NQJq6+rTZZtLNJrg62rKOf/?=
 =?us-ascii?Q?QlShv9RVhlhdIyir8qiFYVLA9WeIV9WlrN7wE0Ncq4bVsgEd7FkytaSv7y8q?=
 =?us-ascii?Q?LUDMXNSF1u9dvZSdqVwU6ZAZWDpfpArwvEHAQW9GwavCV8CINnz2T8kHiNbk?=
 =?us-ascii?Q?rtwHK+kmUP9EO/QJOQI1+RBdr7agP+Z56NvNLmWUbC7K9n9fV83HPJdOqhzl?=
 =?us-ascii?Q?RM/q+KEy7W6h1PY2VR1O3HXL8mUmqSeI7kvGxo0j74eWtMCi9ibpIyysMFOn?=
 =?us-ascii?Q?Stpoh+11HIOXygL6NTHZBObRvYT2axQgRtJu0GHu9jLzTUyumc/D01kwXFFj?=
 =?us-ascii?Q?nUBaVXdd/u4uJqCOwOatEthWlf4kl4rXVwyAQVnIYhohoZEppJHdfXTqG8gs?=
 =?us-ascii?Q?S8GS6X7jOTCWRnxtXH2T79Adi2bdAxcghX2gF7mThQqQ8TtD68TIRf3uvFg8?=
 =?us-ascii?Q?cCzmMU2yz5Mtsx5bge9VQ8XGHxwOZqhNOWM9RLm5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a5afb4-fe56-437a-759d-08da580bb959
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:40.6064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hc8Depyy4g4oT4eeAHWzmDE5Qo06knlFOj5fimyX8/tPtqQmFgTkQdoLbdsfCam4Zj7HZ15Gc1FZKhg7DcmzlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The PGT (Port Group Table) table maps an index to a bitmap of local ports
to which a packet needs to be replicated. This table is used for layer 2
multicast and flooding.

In the legacy model, software did not interact with this table directly.
Instead, it was accessed by firmware in response to registers such as
SFTR and SMID. In the new model, the SFTR register is deprecated and
software has full control over the PGT table using the SMID register.

The entire state of the PGT table needs to be maintained in software
because member ports in a PGT entry needs to be reference counted to avoid
releasing entries which are still in use.

Add the following APIs:
1. mlxsw_sp_pgt_{init, fini}() - allocate/free the PGT table.
2. mlxsw_sp_pgt_mid_alloc_range() - allocate a range of MID indexes in PGT.
   To be used by FID code during initialization to reserve specific PGT
   indexes for flooding entries.
3. mlxsw_sp_pgt_mid_free_range() - free indexes in a given range.
4. mlxsw_sp_pgt_mid_alloc() - allocate one MID index in the PGT at a
   non-specific range, just search for free index. To be used by MDB code.
5. mlxsw_sp_pgt_mid_free() - free the given index.

Note that alloc() functions do not allocate the entries in software, just
allocate IDs using 'idr'.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   3 +-
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  12 ++
 .../ethernet/mellanox/mlxsw/spectrum_pgt.c    | 120 ++++++++++++++++++
 4 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index c57e293cca25..c2d6d64ffe4b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -28,7 +28,8 @@ mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_qdisc.o spectrum_span.o \
 				   spectrum_nve.o spectrum_nve_vxlan.o \
 				   spectrum_dpipe.o spectrum_trap.o \
-				   spectrum_ethtool.o spectrum_policer.o
+				   spectrum_ethtool.o spectrum_policer.o \
+				   spectrum_pgt.o
 mlxsw_spectrum-$(CONFIG_MLXSW_SPECTRUM_DCB)	+= spectrum_dcb.o
 mlxsw_spectrum-$(CONFIG_PTP_1588_CLOCK)		+= spectrum_ptp.o
 obj-$(CONFIG_MLXSW_MINIMAL)	+= mlxsw_minimal.o
diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index daacf6291253..826e47fb4586 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -11,6 +11,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_KVD_SIZE,
 	MLXSW_RES_ID_KVD_SINGLE_MIN_SIZE,
 	MLXSW_RES_ID_KVD_DOUBLE_MIN_SIZE,
+	MLXSW_RES_ID_PGT_SIZE,
 	MLXSW_RES_ID_MAX_KVD_LINEAR_RANGE,
 	MLXSW_RES_ID_MAX_KVD_ACTION_SETS,
 	MLXSW_RES_ID_MAX_TRAP_GROUPS,
@@ -69,6 +70,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_KVD_SIZE] = 0x1001,
 	[MLXSW_RES_ID_KVD_SINGLE_MIN_SIZE] = 0x1002,
 	[MLXSW_RES_ID_KVD_DOUBLE_MIN_SIZE] = 0x1003,
+	[MLXSW_RES_ID_PGT_SIZE] = 0x1004,
 	[MLXSW_RES_ID_MAX_KVD_LINEAR_RANGE] = 0x1005,
 	[MLXSW_RES_ID_MAX_KVD_ACTION_SETS] = 0x1007,
 	[MLXSW_RES_ID_MAX_TRAP_GROUPS] = 0x2201,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 828d5a265157..b42b23d09ab2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -143,6 +143,7 @@ struct mlxsw_sp_ptp_ops;
 struct mlxsw_sp_span_ops;
 struct mlxsw_sp_qdisc_state;
 struct mlxsw_sp_mall_entry;
+struct mlxsw_sp_pgt;
 
 struct mlxsw_sp_port_mapping {
 	u8 module;
@@ -217,6 +218,7 @@ struct mlxsw_sp {
 	struct rhashtable ipv6_addr_ht;
 	struct mutex ipv6_addr_ht_lock; /* Protects ipv6_addr_ht */
 	bool ubridge;
+	struct mlxsw_sp_pgt *pgt;
 };
 
 struct mlxsw_sp_ptp_ops {
@@ -1448,4 +1450,14 @@ int mlxsw_sp_policers_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_policers_fini(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_policer_resources_register(struct mlxsw_core *mlxsw_core);
 
+/* spectrum_pgt.c */
+int mlxsw_sp_pgt_mid_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_mid);
+void mlxsw_sp_pgt_mid_free(struct mlxsw_sp *mlxsw_sp, u16 mid_base);
+int mlxsw_sp_pgt_mid_alloc_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base,
+				 u16 count);
+void mlxsw_sp_pgt_mid_free_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base,
+				 u16 count);
+int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp);
+void mlxsw_sp_pgt_fini(struct mlxsw_sp *mlxsw_sp);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
new file mode 100644
index 000000000000..27db277bc906
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/refcount.h>
+#include <linux/idr.h>
+
+#include "spectrum.h"
+#include "reg.h"
+
+struct mlxsw_sp_pgt {
+	struct idr pgt_idr;
+	u16 end_index; /* Exclusive. */
+	struct mutex lock; /* Protects PGT. */
+};
+
+int mlxsw_sp_pgt_mid_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_mid)
+{
+	int index, err = 0;
+
+	mutex_lock(&mlxsw_sp->pgt->lock);
+	index = idr_alloc(&mlxsw_sp->pgt->pgt_idr, NULL, 0,
+			  mlxsw_sp->pgt->end_index, GFP_KERNEL);
+
+	if (index < 0) {
+		err = index;
+		goto err_idr_alloc;
+	}
+
+	*p_mid = index;
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+	return 0;
+
+err_idr_alloc:
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+	return err;
+}
+
+void mlxsw_sp_pgt_mid_free(struct mlxsw_sp *mlxsw_sp, u16 mid_base)
+{
+	mutex_lock(&mlxsw_sp->pgt->lock);
+	WARN_ON(idr_remove(&mlxsw_sp->pgt->pgt_idr, mid_base));
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+}
+
+int
+mlxsw_sp_pgt_mid_alloc_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base, u16 count)
+{
+	unsigned int idr_cursor;
+	int i, err;
+
+	mutex_lock(&mlxsw_sp->pgt->lock);
+
+	/* This function is supposed to be called several times as part of
+	 * driver init, in specific order. Verify that the mid_index is the
+	 * first free index in the idr, to be able to free the indexes in case
+	 * of error.
+	 */
+	idr_cursor = idr_get_cursor(&mlxsw_sp->pgt->pgt_idr);
+	if (WARN_ON(idr_cursor != mid_base)) {
+		err = -EINVAL;
+		goto err_idr_cursor;
+	}
+
+	for (i = 0; i < count; i++) {
+		err = idr_alloc_cyclic(&mlxsw_sp->pgt->pgt_idr, NULL,
+				       mid_base, mid_base + count, GFP_KERNEL);
+		if (err < 0)
+			goto err_idr_alloc_cyclic;
+	}
+
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+	return 0;
+
+err_idr_alloc_cyclic:
+	for (i--; i >= 0; i--)
+		idr_remove(&mlxsw_sp->pgt->pgt_idr, mid_base + i);
+err_idr_cursor:
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+	return err;
+}
+
+void
+mlxsw_sp_pgt_mid_free_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base, u16 count)
+{
+	struct idr *pgt_idr = &mlxsw_sp->pgt->pgt_idr;
+	int i;
+
+	mutex_lock(&mlxsw_sp->pgt->lock);
+
+	for (i = 0; i < count; i++)
+		WARN_ON_ONCE(idr_remove(pgt_idr, mid_base + i));
+
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+}
+
+int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_pgt *pgt;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, PGT_SIZE))
+		return -EIO;
+
+	pgt = kzalloc(sizeof(*mlxsw_sp->pgt), GFP_KERNEL);
+	if (!pgt)
+		return -ENOMEM;
+
+	idr_init(&pgt->pgt_idr);
+	pgt->end_index = MLXSW_CORE_RES_GET(mlxsw_sp->core, PGT_SIZE);
+	mutex_init(&pgt->lock);
+	mlxsw_sp->pgt = pgt;
+	return 0;
+}
+
+void mlxsw_sp_pgt_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	mutex_destroy(&mlxsw_sp->pgt->lock);
+	WARN_ON(!idr_is_empty(&mlxsw_sp->pgt->pgt_idr));
+	idr_destroy(&mlxsw_sp->pgt->pgt_idr);
+	kfree(mlxsw_sp->pgt);
+}
-- 
2.36.1

