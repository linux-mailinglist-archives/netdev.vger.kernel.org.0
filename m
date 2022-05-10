Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A83520D73
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiEJGDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236979AbiEJGCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56811293B7C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF08tVWBCkyofge3ugmb7rE9sKQiHXTlNP5L8z1bgjMUadVA1eKoqFWBbuDaxsOiYj/ti7Ngi6IaFH+YRT6GCSBdgj6KKq2pjuss/SBK3ekDJU9kcpsZCII9OfMMHsQdRaI2y9GaT6X212sXt37RzM2s+rKFcQlMrQPwPk9xk53A4CayXD9d/AIsKUvP8KjzrW9mxTSaXbWiBmcN7Y2GD7XKM5B3OEqjWORx/uqJwEt8ICV+DvOZ9wpa/NRf8QPMDhRmsKj7Tgkl6cDx+Gcb/4g3n3o9SdOMPSRo9t/iTda8AqzErYe2gHcjruV96sJ1OWOI/HDI35An/5YkiiqYew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPZf+iJzEWpqDDY8gZgmCbX7InvxiPdbJhZS3MzsU6w=;
 b=R1woVDJ5GNs6HaDAdoEZvuWEPRsjBctW8PYcfFXEbNajVSVpO3/k9qbzDm4oG7+lTycHfVAkRDbt7XPg46JfI14UWkR36MEaeGig0ytW+rgywN2IrOa/18YUVWgDOd+JFyDmSPddMioe8VkzBC02fYkSgDSGSiTN3umFF62LlWEuHFjYwKAtNSdcyaBEjeNTVRnEdnfrZFHydhQNT+JDEWO4RZnuFkTPWPWR9I9hE1YxNTHQLv7EoqB5gvPP6AdjinBHKZ6+kUR4eUG1qTA+vGlemg3xktzYXVB1bh6T6lw5srmNd7PKR5WW87s6yOXy7Us+DSdHanaqMhvtJxpTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPZf+iJzEWpqDDY8gZgmCbX7InvxiPdbJhZS3MzsU6w=;
 b=hRxq0Seq3f7UWYZ3mhI4VG4WZ4DP/MEsWe8E86DCubuj/NPD309hp1eKe+uDzs40XyWg72hg64apsQXLMnbjOKRHnXz2nC+dpv33st31gjg8rAbLn/OFajfSwTVTcG8Vu+shF3aBzWVl3IJvZMB2dwILMJl47Jnb83dYrBYfVjzneuHVMZdUPgp5qNMzK9oPKJJyA17uz1LiPmK2vusRUfxKh9onzSAruTH8oGaLvI0DiqFUjZTmH2L4bhBEIDjANvzFC34Lyzs9BchT+uAvJJxw28ZqGJwnZHnbOjvid4HUMzb0mFeO9vEQZLBwb6w+329f9v/Hsxad1aYGhVi6Sw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3882.namprd12.prod.outlook.com (2603:10b6:5:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 05:58:17 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:17 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Lag, add debugfs to query hardware lag state
Date:   Mon,  9 May 2022 22:57:43 -0700
Message-Id: <20220510055743.118828-16-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0124.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::9) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d9b9906-50a5-47cb-1eaa-08da324a140b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3882:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3882E81987B15D15049C5F05B3C99@DM6PR12MB3882.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WiUYvQT6IE21tYM47e6gYDbX8lg73g9UcloGtpetRp4TCofFMWHqH3HRG+xj9+txxk7X5zqMId4CWuek10F/+mFYi951SEDrEtDS/VLY897Idqp4eZ0nmrb6V26PAFoVv57CUywT6ZSwAq/RXoVOpn6CNc54deR/rVpy8k1jqI+5jEY7hOE1rLyQICQLGCM9m1jPw5s+BXAF4DLqMCyDYsKG7U/EscagFRqmzYf8ABFmKBZ7aO/ja8brevzWLpE9Ex9Rw+ypM1eXguAOUfqKoA7iYR8SwrcI0xrUCigATrZxypoxSB/EqI5fJvdv19yyWW/RIN91yL98Jeu09ID1uBMZ7/bZI95a7TIX+xfplCTCbk8vSDJPC2KgKqS9HRXxHFMozkrRfNOliVGZLFM4c4p5oV736LtdTCMdEl7DFYDf+UrWXVQc7Y21TRv1aiKlft6Y5+eUkhjoAkhWOznUadGlm3uuV7V4JSgx2Vpx5Mo2IMajngBQiYgGVJQNAxIoyjLnU5vHRRpgic4G8+5pEkdgMoZBrRG4mNRmXJxXfuO3MVZ/ujNZ8EswMAxPN8PJfXDsCcRwhijdVyQ+G2LoSwgtMHCpBAUTdZvnfitMe0l8PW8wRp8B8wj2AvDHb9SVxADB4B/8+HNbRy8XoIw8ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2906002)(38100700002)(508600001)(36756003)(5660300002)(8676002)(30864003)(186003)(83380400001)(66556008)(110136005)(8936002)(2616005)(316002)(107886003)(66946007)(4326008)(54906003)(66476007)(86362001)(1076003)(6666004)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tw5HHg3iDDTA+h46T7WITIn0jiTJx7edOd8BnBB0Pgr74o05V1cA2/3VhsRj?=
 =?us-ascii?Q?Jq4o50eDewv+OHjNPSAdIYG/r/WP73ijsc/ebjmIbFA4TThTemdYjF8S+4XY?=
 =?us-ascii?Q?fgcQkT2fkb6beJ53ck9XZeb8jTtddAsP9arMBwFqDsRImaLV1rBVdLU79s6f?=
 =?us-ascii?Q?sVz2GOqWgD6vYcVQFZdAEZFyiZzXk9u/CCXq+p24dBaWXLxe2c2tEURgTLDZ?=
 =?us-ascii?Q?ScyKHo8m2Qhm+59q8X2WZJVN0Y+sPp5L29B/Ia4Hplg8Srnjtp48KtrMOpyI?=
 =?us-ascii?Q?78DG1qnyM+0GSy197dwnIF1EsWg0XpGJhSAcSbmPq2/dLwYFI7o3I6xFYtYw?=
 =?us-ascii?Q?IsiFEflxCy3C6kQ4dlByMSfmVri1WdIVJ1HTKY0dO+sX5M5nRbglL/74ELM4?=
 =?us-ascii?Q?F29oHBeOyGjrwkUe1iDA6B0ipZK+LxbYB9C0afLSrtzeYJ/bin7if32xA8rg?=
 =?us-ascii?Q?FDLUClRMYgc+wLaErmg3O6LZTf+0fXDGzoj8HZtxOBijJ3l9WuKlHq+Ski8/?=
 =?us-ascii?Q?Dx5Hz0SrW1+T4eKBxtsu0i41HWQyf52+XzUn4XxdaI/OFHYalnU7mzJFbjps?=
 =?us-ascii?Q?e02jjBFtWgSnWfvntMGoWSIDl1e0Ju9wYoYxL4zFYZl9erDZp9AlQx9i2LQz?=
 =?us-ascii?Q?zZuf8SFXUCU0DuzR3q3ILK3IkUJ6yJRYpbipO72lR5TV9AP+xBW9uCtubyjN?=
 =?us-ascii?Q?DZ4YSmEtcZkC64fFKDzkIQ9Km+vi822H7cqE/fohdVnCUloVHk2c5pK5v0n9?=
 =?us-ascii?Q?+FPbCaxLHISwdE+bt2AU0iwF0zDL0pERO/OQ3V7Fd4aT3d9DJhgkPGEJMYKj?=
 =?us-ascii?Q?QSU9SfDeFeATdiabJo+vjdBGio95+WG/hgvgDT4yHKELdeJ5L/EjwvuNyZhH?=
 =?us-ascii?Q?Sy5/4eddp6ePMP9NwyrvQoYkCCL/sP8Bo/JdqjfbSRBDRKC8GRp8/e+HC7nH?=
 =?us-ascii?Q?yEYNRNhW6GnMEAInDBgfCXNEgDlzZ7a3j7KWSsSj3o0GeS1DSOOFMSxh8rUc?=
 =?us-ascii?Q?ekYPyOPhMyPr21RAUy2N39CPJ1CZfXnBTfDMExD3IRWP5W9dAGferlvCM/1V?=
 =?us-ascii?Q?lkjNT245P5O8EjP6bAflkqYIexkgJo47NMblhXlDJ7A75E6e0OykkNYsfN3Y?=
 =?us-ascii?Q?1R5Y3rdDmPf8aLZ5lkAD8Es2jod5SBrVvcMVMeVjW5tjF73YS89hPI5CmEAK?=
 =?us-ascii?Q?mXK19+DYrNnxkogYu8fGLkQde2Ip65nM8URwwH/+EcqYoWZGL6A1rWI+l8mH?=
 =?us-ascii?Q?EviNfcjOk/BD4s+7MnvO260rd6Z+f+bECDw3hU6ZcaAf+gRKmyO5UMLYWVL9?=
 =?us-ascii?Q?FiMhEQH8Tq3w8XaXUYQGQ/RTygMiy6625vcrDEqTOshno6Dnmf2mqBLG4WdP?=
 =?us-ascii?Q?oVB451/BR+ebaYgZ4nCxSJDGNOWZtBE+dUS5eqCQ0b1FzlSOSdGe8rhpmcQb?=
 =?us-ascii?Q?nO2tVah8Xss3sh9TxOyMfU7HzdboyPZZU2uQvrktM2DXs95K11TeSY/FVHEw?=
 =?us-ascii?Q?znUE4yL7BYpL8WTj3SP8QfvVb3Fcq+Zg3+KazFXup74L/S+VTp56NkiwLp5u?=
 =?us-ascii?Q?WTpjgu+j4es+NGhe+rJ734OZ7+6IhZh/1CDpFCztkag/M/PwG7ewT0NgiJg2?=
 =?us-ascii?Q?1bbizoI0l0tT+cPxD6hduO/lJ0CvhdQUE1XVDE7keJPhcMggB5OH/oYN1FKJ?=
 =?us-ascii?Q?mqUIdrpdQoAs5KDvloiEc5sLuSoxMerMscrZwJAeU6mbREaLbSuHGcb24IB/?=
 =?us-ascii?Q?JkpHIIezclPWdoWGcTwAB3LOfLF4pmYO7bKI3YD4H3veSBvDdN/i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9b9906-50a5-47cb-1eaa-08da324a140b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:17.3150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAZnx6tYeKoeNAHU3wwwPiN59O2k5QYPS4oPIejWfAsb5wb3txYag3DtfST9qNh8jgVL3AMumwNDJdsZgAsKlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3882
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Lag state has become very complicated with many modes, flags, types and
port selections methods and future work will add additional features.

Add a debugfs to query the current lag state. A new directory named "lag"
will be created under the mlx5 debugfs directory. As the driver has
debugfs per pci function the location will be: <debugfs>/mlx5/<BDF>/lag

For example:
/sys/kernel/debug/mlx5/0000:08:00.0/lag

The following files are exposed:

- state: Returns "active" or "disabled". If "active" it means hardware
         lag is active.

- members: Returns the BDFs of all the members of lag object.

- type: Returns the type of the lag currently configured. Valid only
	if hardware lag is active.
	* "roce" - Members are bare metal PFs.
	* "switchdev" - Members are in switchdev mode.
	* "multipath" - ECMP offloads.

- port_sel_mode: Returns the egress port selection method, valid
		 only if hardware lag is active.
		 * "queue_affinity" - Egress port is selected by
		   the QP/SQ affinity.
		 * "hash" - Egress port is selected by hash done on
		   each packet. Controlled by: xmit_hash_policy of the
		   bond device.
- flags: Returns flags that are specific per lag @type. Valid only if
	 hardware lag is active.
	 * "shared_fdb" - "on" or "off", if "on" single FDB is used.

- mapping: Returns the mapping which is used to select egress port.
	   Valid only if hardware lag is active.
	   If @port_sel_mode is "hash" returns the active egress ports.
	   The hash result will select only active ports.
	   if @port_sel_mode is "queue_affinity" returns the mapping
	   between the configured port affinity of the QP/SQ and actual
	   egress port. For example:
	   * 1:1 - Mapping means if the configured affinity is port 1
	           traffic will egress via port 1.
	   * 1:2 - Mapping means if the configured affinity is port 1
		   traffic will egress via port 2. This can happen
		   if port 1 is down or in active/backup mode and port 1
		   is backup.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c | 173 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  11 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |   9 +
 include/linux/mlx5/driver.h                   |   1 +
 5 files changed, 192 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 81620c25c77e..7895ed7cc285 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		health.o mcg.o cq.o alloc.o port.o mr.o pd.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
-		fs_counters.o fs_ft_pool.o rl.o lag/lag.o dev.o events.o wq.o lib/gid.o \
+		fs_counters.o fs_ft_pool.o rl.o lag/debugfs.o lag/lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
 		fw_reset.o qos.o lib/tout.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
new file mode 100644
index 000000000000..443daf6e3d4b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "lag.h"
+
+static char *get_str_mode_type(struct mlx5_lag *ldev)
+{
+	if (ldev->flags & MLX5_LAG_FLAG_ROCE)
+		return "roce";
+	if (ldev->flags & MLX5_LAG_FLAG_SRIOV)
+		return "switchdev";
+	if (ldev->flags & MLX5_LAG_FLAG_MULTIPATH)
+		return "multipath";
+
+	return NULL;
+}
+
+static int type_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	struct mlx5_lag *ldev;
+	char *mode = NULL;
+
+	ldev = dev->priv.lag;
+	mutex_lock(&ldev->lock);
+	if (__mlx5_lag_is_active(ldev))
+		mode = get_str_mode_type(ldev);
+	mutex_unlock(&ldev->lock);
+	if (!mode)
+		return -EINVAL;
+	seq_printf(file, "%s\n", mode);
+
+	return 0;
+}
+
+static int port_sel_mode_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	struct mlx5_lag *ldev;
+	int ret = 0;
+	char *mode;
+
+	ldev = dev->priv.lag;
+	mutex_lock(&ldev->lock);
+	if (__mlx5_lag_is_active(ldev))
+		mode = get_str_port_sel_mode(ldev->flags);
+	else
+		ret = -EINVAL;
+	mutex_unlock(&ldev->lock);
+	if (ret || !mode)
+		return ret;
+
+	seq_printf(file, "%s\n", mode);
+	return 0;
+}
+
+static int state_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	struct mlx5_lag *ldev;
+	bool active;
+
+	ldev = dev->priv.lag;
+	mutex_lock(&ldev->lock);
+	active = __mlx5_lag_is_active(ldev);
+	mutex_unlock(&ldev->lock);
+	seq_printf(file, "%s\n", active ? "active" : "disabled");
+	return 0;
+}
+
+static int flags_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	struct mlx5_lag *ldev;
+	bool shared_fdb;
+	bool lag_active;
+
+	ldev = dev->priv.lag;
+	mutex_lock(&ldev->lock);
+	lag_active = __mlx5_lag_is_active(ldev);
+	if (lag_active)
+		shared_fdb = ldev->shared_fdb;
+
+	mutex_unlock(&ldev->lock);
+	if (!lag_active)
+		return -EINVAL;
+
+	seq_printf(file, "%s:%s\n", "shared_fdb", shared_fdb ? "on" : "off");
+	return 0;
+}
+
+static int mapping_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	u8 ports[MLX5_MAX_PORTS] = {};
+	struct mlx5_lag *ldev;
+	bool hash = false;
+	bool lag_active;
+	int num_ports;
+	int i;
+
+	ldev = dev->priv.lag;
+	mutex_lock(&ldev->lock);
+	lag_active = __mlx5_lag_is_active(ldev);
+	if (lag_active) {
+		if (ldev->flags & MLX5_LAG_FLAG_HASH_BASED) {
+			mlx5_infer_tx_enabled(&ldev->tracker, ldev->ports, ports,
+					      &num_ports);
+			hash = true;
+		} else {
+			for (i = 0; i < ldev->ports; i++)
+				ports[i] = ldev->v2p_map[i];
+			num_ports = ldev->ports;
+		}
+	}
+	mutex_unlock(&ldev->lock);
+	if (!lag_active)
+		return -EINVAL;
+
+	for (i = 0; i < num_ports; i++) {
+		if (hash)
+			seq_printf(file, "%d\n", ports[i] + 1);
+		else
+			seq_printf(file, "%d:%d\n", i + 1, ports[i]);
+	}
+
+	return 0;
+}
+
+static int members_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	struct mlx5_lag *ldev;
+	int i;
+
+	ldev = dev->priv.lag;
+	mutex_lock(&ldev->lock);
+	for (i = 0; i < ldev->ports; i++) {
+		if (!ldev->pf[i].dev)
+			continue;
+		seq_printf(file, "%s\n", dev_name(ldev->pf[i].dev->device));
+	}
+	mutex_unlock(&ldev->lock);
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(type);
+DEFINE_SHOW_ATTRIBUTE(port_sel_mode);
+DEFINE_SHOW_ATTRIBUTE(state);
+DEFINE_SHOW_ATTRIBUTE(flags);
+DEFINE_SHOW_ATTRIBUTE(mapping);
+DEFINE_SHOW_ATTRIBUTE(members);
+
+void mlx5_ldev_add_debugfs(struct mlx5_core_dev *dev)
+{
+	struct dentry *dbg;
+
+	dbg = debugfs_create_dir("lag", mlx5_debugfs_get_dev_root(dev));
+	dev->priv.dbg.lag_debugfs = dbg;
+
+	debugfs_create_file("type", 0444, dbg, dev, &type_fops);
+	debugfs_create_file("port_sel_mode", 0444, dbg, dev, &port_sel_mode_fops);
+	debugfs_create_file("state", 0444, dbg, dev, &state_fops);
+	debugfs_create_file("flags", 0444, dbg, dev, &flags_fops);
+	debugfs_create_file("mapping", 0444, dbg, dev, &mapping_fops);
+	debugfs_create_file("members", 0444, dbg, dev, &members_fops);
+}
+
+void mlx5_ldev_remove_debugfs(struct dentry *dbg)
+{
+	debugfs_remove_recursive(dbg);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 8a74c409b501..b6dd9043061f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -120,8 +120,8 @@ static void mlx5_infer_tx_disabled(struct lag_tracker *tracker, u8 num_ports,
 	}
 }
 
-static void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
-				  u8 *ports, int *num_enabled)
+void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
+			   u8 *ports, int *num_enabled)
 {
 	int i;
 
@@ -454,7 +454,7 @@ static int mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
 	return mlx5_lag_set_port_sel_mode_offloads(ldev, tracker, flags);
 }
 
-static char *get_str_port_sel_mode(u8 flags)
+char *get_str_port_sel_mode(u8 flags)
 {
 	if (flags &  MLX5_LAG_FLAG_HASH_BASED)
 		return "hash";
@@ -1106,6 +1106,10 @@ void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return;
 
+	/* mdev is being removed, might as well remove debugfs
+	 * as early as possible.
+	 */
+	mlx5_ldev_remove_debugfs(dev->priv.dbg.lag_debugfs);
 recheck:
 	mutex_lock(&ldev->lock);
 	if (ldev->mode_changes_in_progress) {
@@ -1137,6 +1141,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 		msleep(100);
 		goto recheck;
 	}
+	mlx5_ldev_add_debugfs(dev);
 }
 
 void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 0c90d0ed03be..46683b84ff84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -4,6 +4,8 @@
 #ifndef __MLX5_LAG_H__
 #define __MLX5_LAG_H__
 
+#include <linux/debugfs.h>
+
 #define MLX5_LAG_MAX_HASH_BUCKETS 16
 #include "mlx5_core.h"
 #include "mp.h"
@@ -90,4 +92,11 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev);
 
+char *get_str_port_sel_mode(u8 flags);
+void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
+			   u8 *ports, int *num_enabled);
+
+void mlx5_ldev_add_debugfs(struct mlx5_core_dev *dev);
+void mlx5_ldev_remove_debugfs(struct dentry *dbg);
+
 #endif /* __MLX5_LAG_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index fdb9d07a05a4..d6bac3976913 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -558,6 +558,7 @@ struct mlx5_debugfs_entries {
 	struct dentry *cq_debugfs;
 	struct dentry *cmdif_debugfs;
 	struct dentry *pages_debugfs;
+	struct dentry *lag_debugfs;
 };
 
 struct mlx5_ft_pool;
-- 
2.35.1

