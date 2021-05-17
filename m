Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253BF383B24
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242697AbhEQRVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:30 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:52745 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242634AbhEQRV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:05:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efBlDztVTdn5C7cVTRpBD0xdMgXp++SPES2B/RIfEig5GZeUUHjVohilkqk3/i64J1LnPOieNHjJwzg/4vjdfypXdWlP5HRiTNUOXR3g/syn5UNYDSqvWZEHjdoocdgt8KHkqquggjBfyRj73GQRfzhNIA7Qigh9clDabDMhBTbZInajdgUIhS7nnWb2+3FB8zR03E8gMivazLSr5CUC182ZV66IC+i/P+F0cgztQM5dFoUpRkIvbp5ednmU6c5K3f38Yrx+j25OZ61oEINZiOVuvxjFKgcddEYPBIcITR/XleuRw6gmFx/q3HnaVBATOTosUEtPObhbS2MnSXUP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOEvS/le/p6rP2QgommtcVu/VMp2/6zoZuNjKhbdMcM=;
 b=cBNYHzaloYoeefIhzFJcFee+wXvvKl0kH721UFRLxABMUanWBosf44DPzOyO/RHI8G1MVHqZCPYyTtmA2IvOf//KdltF9t2f9Ud63H/a7bCxpRWizhQ1yI48BzE+Ix1s1K8tQjDllQj1ifIfPAKXLL8YE93ZLUGDb/IW9dt4oKLMKjxNCgZI0ylU46eTcOGtbdptvwnFsEWrP5p+6/1d4fhUrEoZBWVnBCkwwr4bI/eRq87C8ImNC+9aghwAuG+QEMchy5cZTCtKotji4cGa54DtNlKBSzpyGMtmWKI2a2dELxuU7MlN7fdnGctDO8QO8QPXdzee0Utt+wQQ2WeGUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOEvS/le/p6rP2QgommtcVu/VMp2/6zoZuNjKhbdMcM=;
 b=lHXS3xupVxFN779AeIvcaTV/tyn3yxKLofLEn1FddA0DK31qOOdudPULpDgOmZR8GU4bqhP1fWw1kU2bnslS7t7/3O740BUHhsfj3J1+bsayAMbuOMaWSV79Od97aJrkVNVbvNTj8hingcFS/dJuMEOulysECwJt3JyYMPWflsBveRSphmuZbo8Q2WzyjN8PHVaOP/CLKOWdhSq2FBQjNbzSJpai7aregSLeWvtqWW9DvwkYYaGqeAwtIr+hGVuoHuYt+3jFz1DZe0CpMjHY7H6gk3LFN6OpSsoXA6waL9Me3JTjFqAk3AmC41ihmHx9zKmepAtA/N2FxC7CHpr5dQ==
Received: from DM5PR07CA0124.namprd07.prod.outlook.com (2603:10b6:3:13e::14)
 by CY4PR12MB1701.namprd12.prod.outlook.com (2603:10b6:903:121::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 17:05:09 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::3a) by DM5PR07CA0124.outlook.office365.com
 (2603:10b6:3:13e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 17:05:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:05:09 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:05:06 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 10/11] mlxsw: Remove Mellanox SwitchIB ASIC support
Date:   Mon, 17 May 2021 20:04:00 +0300
Message-ID: <20210517170401.188563-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1be3331-5bcd-4ace-6e2f-08d91955ed70
X-MS-TrafficTypeDiagnostic: CY4PR12MB1701:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1701C779F412541621136909B22D9@CY4PR12MB1701.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7L/orxJWX6Dp5HlRrmQJTwWw0gL4Y1nNsWlnvTu/hsmzFUl3hrAbKUOqPQwvLbXjyvmqJSfiMV05k1g3QMDGu5H0f5ZK5vjvHmDZtj/IYEev5s/yiCi6dBJT+Znz4ELv2/XnJSriQq8AMroE5hCpTRmwz48ePQ/5OKqPLBIpfAuT24TGEqpL6AmZtC7/NGl7pA/IfxtppcrjNirzFZACjS8/x27BhzXzmcvlKEHEnfkBz8KKB9OWRfP/Tcs2UTyKWxLKa6fQgagvxtagO7s6dY/lL9zTs88I1Us+8DITtvVSeF4OhUWHwvwLAV89k89tW65cO5pSQH9oAkUrp+EeN1yl6hNseNLq0Z5nG0GKRARjUO1xYFIYY7EHAnH0ZKJewLiREsP9Mzj0D2YMMGCrVdF6aGBQYB7Asoq4Zld8Oe5wSXi7OsiQ/Hd4Ag4nmPFs7RLU3Px3Z+C93sixwK3kAG3OOsh3eqXP+LXCHpsQ+cyKQ7XqVQHT+EAjEUSfIVBoMxzWAaLrY5pmYgroeETuhHeVQRD+b3xhimXUuJfaalupoMgLoVpotB8qyNxKWV8vhTqpBuGlFyCRTZh4BstcgQKK+qvqq83d3/7l3eKrqnwYZoCFlcb9KkArIKs5ntk+REIDbkPrRP7s15A7K2kqdjGLrU3qQQM4oaLFLX7wDu0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(36840700001)(46966006)(2906002)(8676002)(54906003)(26005)(16526019)(186003)(70586007)(82310400003)(4326008)(83380400001)(2616005)(30864003)(426003)(478600001)(6916009)(82740400003)(336012)(36860700001)(47076005)(5660300002)(70206006)(1076003)(8936002)(107886003)(6666004)(86362001)(7636003)(36906005)(356005)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:05:09.4849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1be3331-5bcd-4ace-6e2f-08d91955ed70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Initial support for the Mellanox SwitchIB and SwitchIB-2 ASICs was added
in October 2016, but since then development of this driver stopped.
Therefore, the driver does not support any offloads and simply registers
devlink ports for its front panel ports, rendering it irrelevant for
deployment.

Given the driver is not used by any users and that there is no intention
of investing in its development, remove it from the kernel.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |  11 -
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 -
 drivers/net/ethernet/mellanox/mlxsw/pci.h     |   2 -
 .../net/ethernet/mellanox/mlxsw/switchib.c    | 595 ------------------
 4 files changed, 610 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/switchib.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index a619d90559f7..6509b5fab936 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -49,17 +49,6 @@ config MLXSW_I2C
 	  To compile this driver as a module, choose M here: the
 	  module will be called mlxsw_i2c.
 
-config MLXSW_SWITCHIB
-	tristate "Mellanox Technologies SwitchIB and SwitchIB-2 support"
-	depends on MLXSW_CORE && MLXSW_PCI && NET_SWITCHDEV
-	default m
-	help
-	  This driver supports Mellanox Technologies SwitchIB and SwitchIB-2
-	  Infiniband Switch ASICs.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mlxsw_switchib.
-
 config MLXSW_SWITCHX2
 	tristate "Mellanox Technologies SwitchX-2 support"
 	depends on MLXSW_CORE && MLXSW_PCI && NET_SWITCHDEV
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index f545fd2c5896..b68e5ba323cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -8,8 +8,6 @@ obj-$(CONFIG_MLXSW_PCI)		+= mlxsw_pci.o
 mlxsw_pci-objs			:= pci.o
 obj-$(CONFIG_MLXSW_I2C)		+= mlxsw_i2c.o
 mlxsw_i2c-objs			:= i2c.o
-obj-$(CONFIG_MLXSW_SWITCHIB)	+= mlxsw_switchib.o
-mlxsw_switchib-objs		:= switchib.o
 obj-$(CONFIG_MLXSW_SWITCHX2)	+= mlxsw_switchx2.o
 mlxsw_switchx2-objs		:= switchx2.o
 obj-$(CONFIG_MLXSW_SPECTRUM)	+= mlxsw_spectrum.o
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.h b/drivers/net/ethernet/mellanox/mlxsw/pci.h
index 5b1323645a5d..b0702947d895 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.h
@@ -10,8 +10,6 @@
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM		0xcb84
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM2	0xcf6c
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM3	0xcf70
-#define PCI_DEVICE_ID_MELLANOX_SWITCHIB		0xcb20
-#define PCI_DEVICE_ID_MELLANOX_SWITCHIB2	0xcf08
 
 #if IS_ENABLED(CONFIG_MLXSW_PCI)
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
deleted file mode 100644
index 1e561132eb1e..000000000000
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ /dev/null
@@ -1,595 +0,0 @@
-// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
-/* Copyright (c) 2016-2018 Mellanox Technologies. All rights reserved */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/skbuff.h>
-#include <linux/if_vlan.h>
-#include <net/switchdev.h>
-
-#include "pci.h"
-#include "core.h"
-#include "reg.h"
-#include "port.h"
-#include "trap.h"
-#include "txheader.h"
-#include "ib.h"
-
-static const char mlxsw_sib_driver_name[] = "mlxsw_switchib";
-static const char mlxsw_sib2_driver_name[] = "mlxsw_switchib2";
-
-struct mlxsw_sib_port;
-
-struct mlxsw_sib {
-	struct mlxsw_sib_port **ports;
-	struct mlxsw_core *core;
-	const struct mlxsw_bus_info *bus_info;
-	u8 hw_id[ETH_ALEN];
-};
-
-struct mlxsw_sib_port {
-	struct mlxsw_sib *mlxsw_sib;
-	u8 local_port;
-	struct {
-		u8 module;
-	} mapping;
-};
-
-/* tx_v1_hdr_version
- * Tx header version.
- * Must be set to 1.
- */
-MLXSW_ITEM32(tx_v1, hdr, version, 0x00, 28, 4);
-
-/* tx_v1_hdr_ctl
- * Packet control type.
- * 0 - Ethernet control (e.g. EMADs, LACP)
- * 1 - Ethernet data
- */
-MLXSW_ITEM32(tx_v1, hdr, ctl, 0x00, 26, 2);
-
-/* tx_v1_hdr_proto
- * Packet protocol type. Must be set to 1 (Ethernet).
- */
-MLXSW_ITEM32(tx_v1, hdr, proto, 0x00, 21, 3);
-
-/* tx_v1_hdr_swid
- * Switch partition ID. Must be set to 0.
- */
-MLXSW_ITEM32(tx_v1, hdr, swid, 0x00, 12, 3);
-
-/* tx_v1_hdr_control_tclass
- * Indicates if the packet should use the control TClass and not one
- * of the data TClasses.
- */
-MLXSW_ITEM32(tx_v1, hdr, control_tclass, 0x00, 6, 1);
-
-/* tx_v1_hdr_port_mid
- * Destination local port for unicast packets.
- * Destination multicast ID for multicast packets.
- *
- * Control packets are directed to a specific egress port, while data
- * packets are transmitted through the CPU port (0) into the switch partition,
- * where forwarding rules are applied.
- */
-MLXSW_ITEM32(tx_v1, hdr, port_mid, 0x04, 16, 16);
-
-/* tx_v1_hdr_type
- * 0 - Data packets
- * 6 - Control packets
- */
-MLXSW_ITEM32(tx_v1, hdr, type, 0x0C, 0, 4);
-
-static void
-mlxsw_sib_tx_v1_hdr_construct(struct sk_buff *skb,
-			      const struct mlxsw_tx_info *tx_info)
-{
-	char *txhdr = skb_push(skb, MLXSW_TXHDR_LEN);
-
-	memset(txhdr, 0, MLXSW_TXHDR_LEN);
-
-	mlxsw_tx_v1_hdr_version_set(txhdr, MLXSW_TXHDR_VERSION_1);
-	mlxsw_tx_v1_hdr_ctl_set(txhdr, MLXSW_TXHDR_ETH_CTL);
-	mlxsw_tx_v1_hdr_proto_set(txhdr, MLXSW_TXHDR_PROTO_ETH);
-	mlxsw_tx_v1_hdr_swid_set(txhdr, 0);
-	mlxsw_tx_v1_hdr_control_tclass_set(txhdr, 1);
-	mlxsw_tx_v1_hdr_port_mid_set(txhdr, tx_info->local_port);
-	mlxsw_tx_v1_hdr_type_set(txhdr, MLXSW_TXHDR_TYPE_CONTROL);
-}
-
-static int mlxsw_sib_hw_id_get(struct mlxsw_sib *mlxsw_sib)
-{
-	char spad_pl[MLXSW_REG_SPAD_LEN] = {0};
-	int err;
-
-	err = mlxsw_reg_query(mlxsw_sib->core, MLXSW_REG(spad), spad_pl);
-	if (err)
-		return err;
-	mlxsw_reg_spad_base_mac_memcpy_from(spad_pl, mlxsw_sib->hw_id);
-	return 0;
-}
-
-static int
-mlxsw_sib_port_admin_status_set(struct mlxsw_sib_port *mlxsw_sib_port,
-				bool is_up)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_sib_port->mlxsw_sib;
-	char paos_pl[MLXSW_REG_PAOS_LEN];
-
-	mlxsw_reg_paos_pack(paos_pl, mlxsw_sib_port->local_port,
-			    is_up ? MLXSW_PORT_ADMIN_STATUS_UP :
-			    MLXSW_PORT_ADMIN_STATUS_DOWN);
-	return mlxsw_reg_write(mlxsw_sib->core, MLXSW_REG(paos), paos_pl);
-}
-
-static int mlxsw_sib_port_mtu_set(struct mlxsw_sib_port *mlxsw_sib_port,
-				  u16 mtu)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_sib_port->mlxsw_sib;
-	char pmtu_pl[MLXSW_REG_PMTU_LEN];
-	int max_mtu;
-	int err;
-
-	mlxsw_reg_pmtu_pack(pmtu_pl, mlxsw_sib_port->local_port, 0);
-	err = mlxsw_reg_query(mlxsw_sib->core, MLXSW_REG(pmtu), pmtu_pl);
-	if (err)
-		return err;
-	max_mtu = mlxsw_reg_pmtu_max_mtu_get(pmtu_pl);
-
-	if (mtu > max_mtu)
-		return -EINVAL;
-
-	mlxsw_reg_pmtu_pack(pmtu_pl, mlxsw_sib_port->local_port, mtu);
-	return mlxsw_reg_write(mlxsw_sib->core, MLXSW_REG(pmtu), pmtu_pl);
-}
-
-static int mlxsw_sib_port_set(struct mlxsw_sib_port *mlxsw_sib_port, u8 port)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_sib_port->mlxsw_sib;
-	char plib_pl[MLXSW_REG_PLIB_LEN] = {0};
-	int err;
-
-	mlxsw_reg_plib_local_port_set(plib_pl, mlxsw_sib_port->local_port);
-	mlxsw_reg_plib_ib_port_set(plib_pl, port);
-	err = mlxsw_reg_write(mlxsw_sib->core, MLXSW_REG(plib), plib_pl);
-	return err;
-}
-
-static int mlxsw_sib_port_swid_set(struct mlxsw_sib_port *mlxsw_sib_port,
-				   u8 swid)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_sib_port->mlxsw_sib;
-	char pspa_pl[MLXSW_REG_PSPA_LEN];
-
-	mlxsw_reg_pspa_pack(pspa_pl, swid, mlxsw_sib_port->local_port);
-	return mlxsw_reg_write(mlxsw_sib->core, MLXSW_REG(pspa), pspa_pl);
-}
-
-static int mlxsw_sib_port_module_info_get(struct mlxsw_sib *mlxsw_sib,
-					  u8 local_port, u8 *p_module,
-					  u8 *p_width)
-{
-	char pmlp_pl[MLXSW_REG_PMLP_LEN];
-	int err;
-
-	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
-	err = mlxsw_reg_query(mlxsw_sib->core, MLXSW_REG(pmlp), pmlp_pl);
-	if (err)
-		return err;
-	*p_module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
-	*p_width = mlxsw_reg_pmlp_width_get(pmlp_pl);
-	return 0;
-}
-
-static int mlxsw_sib_port_speed_set(struct mlxsw_sib_port *mlxsw_sib_port,
-				    u16 speed, u16 width)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_sib_port->mlxsw_sib;
-	char ptys_pl[MLXSW_REG_PTYS_LEN];
-
-	mlxsw_reg_ptys_ib_pack(ptys_pl, mlxsw_sib_port->local_port, speed,
-			       width);
-	return mlxsw_reg_write(mlxsw_sib->core, MLXSW_REG(ptys), ptys_pl);
-}
-
-static bool mlxsw_sib_port_created(struct mlxsw_sib *mlxsw_sib, u8 local_port)
-{
-	return mlxsw_sib->ports[local_port] != NULL;
-}
-
-static int __mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
-				   u8 module, u8 width)
-{
-	struct mlxsw_sib_port *mlxsw_sib_port;
-	int err;
-
-	mlxsw_sib_port = kzalloc(sizeof(*mlxsw_sib_port), GFP_KERNEL);
-	if (!mlxsw_sib_port)
-		return -ENOMEM;
-	mlxsw_sib_port->mlxsw_sib = mlxsw_sib;
-	mlxsw_sib_port->local_port = local_port;
-	mlxsw_sib_port->mapping.module = module;
-
-	err = mlxsw_sib_port_swid_set(mlxsw_sib_port, 0);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to set SWID\n",
-			mlxsw_sib_port->local_port);
-		goto err_port_swid_set;
-	}
-
-	/* Expose the IB port number as it's front panel name */
-	err = mlxsw_sib_port_set(mlxsw_sib_port, module + 1);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to set IB port\n",
-			mlxsw_sib_port->local_port);
-		goto err_port_ib_set;
-	}
-
-	/* Supports all speeds from SDR to FDR (bitmask) and support bus width
-	 * of 1x, 2x and 4x (3 bits bitmask)
-	 */
-	err = mlxsw_sib_port_speed_set(mlxsw_sib_port,
-				       MLXSW_REG_PTYS_IB_SPEED_EDR - 1,
-				       BIT(3) - 1);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to set speed\n",
-			mlxsw_sib_port->local_port);
-		goto err_port_speed_set;
-	}
-
-	/* Change to the maximum MTU the device supports, the SMA will take
-	 * care of the active MTU
-	 */
-	err = mlxsw_sib_port_mtu_set(mlxsw_sib_port, MLXSW_IB_DEFAULT_MTU);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to set MTU\n",
-			mlxsw_sib_port->local_port);
-		goto err_port_mtu_set;
-	}
-
-	err = mlxsw_sib_port_admin_status_set(mlxsw_sib_port, true);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to change admin state to UP\n",
-			mlxsw_sib_port->local_port);
-		goto err_port_admin_set;
-	}
-
-	mlxsw_core_port_ib_set(mlxsw_sib->core, mlxsw_sib_port->local_port,
-			       mlxsw_sib_port);
-	mlxsw_sib->ports[local_port] = mlxsw_sib_port;
-	return 0;
-
-err_port_admin_set:
-err_port_mtu_set:
-err_port_speed_set:
-err_port_ib_set:
-	mlxsw_sib_port_swid_set(mlxsw_sib_port, MLXSW_PORT_SWID_DISABLED_PORT);
-err_port_swid_set:
-	kfree(mlxsw_sib_port);
-	return err;
-}
-
-static int mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
-				 u8 module, u8 width)
-{
-	int err;
-
-	err = mlxsw_core_port_init(mlxsw_sib->core, local_port,
-				   module + 1, false, 0, false, 0,
-				   mlxsw_sib->hw_id, sizeof(mlxsw_sib->hw_id));
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to init core port\n",
-			local_port);
-		return err;
-	}
-	err = __mlxsw_sib_port_create(mlxsw_sib, local_port, module, width);
-	if (err)
-		goto err_port_create;
-
-	return 0;
-
-err_port_create:
-	mlxsw_core_port_fini(mlxsw_sib->core, local_port);
-	return err;
-}
-
-static void __mlxsw_sib_port_remove(struct mlxsw_sib *mlxsw_sib, u8 local_port)
-{
-	struct mlxsw_sib_port *mlxsw_sib_port = mlxsw_sib->ports[local_port];
-
-	mlxsw_core_port_clear(mlxsw_sib->core, local_port, mlxsw_sib);
-	mlxsw_sib->ports[local_port] = NULL;
-	mlxsw_sib_port_admin_status_set(mlxsw_sib_port, false);
-	mlxsw_sib_port_swid_set(mlxsw_sib_port, MLXSW_PORT_SWID_DISABLED_PORT);
-	kfree(mlxsw_sib_port);
-}
-
-static void mlxsw_sib_port_remove(struct mlxsw_sib *mlxsw_sib, u8 local_port)
-{
-	__mlxsw_sib_port_remove(mlxsw_sib, local_port);
-	mlxsw_core_port_fini(mlxsw_sib->core, local_port);
-}
-
-static void mlxsw_sib_ports_remove(struct mlxsw_sib *mlxsw_sib)
-{
-	int i;
-
-	for (i = 1; i < MLXSW_PORT_MAX_IB_PORTS; i++)
-		if (mlxsw_sib_port_created(mlxsw_sib, i))
-			mlxsw_sib_port_remove(mlxsw_sib, i);
-	kfree(mlxsw_sib->ports);
-}
-
-static int mlxsw_sib_ports_create(struct mlxsw_sib *mlxsw_sib)
-{
-	size_t alloc_size;
-	u8 module, width;
-	int i;
-	int err;
-
-	alloc_size = sizeof(struct mlxsw_sib_port *) * MLXSW_PORT_MAX_IB_PORTS;
-	mlxsw_sib->ports = kzalloc(alloc_size, GFP_KERNEL);
-	if (!mlxsw_sib->ports)
-		return -ENOMEM;
-
-	for (i = 1; i < MLXSW_PORT_MAX_IB_PORTS; i++) {
-		err = mlxsw_sib_port_module_info_get(mlxsw_sib, i, &module,
-						     &width);
-		if (err)
-			goto err_port_module_info_get;
-		if (!width)
-			continue;
-		err = mlxsw_sib_port_create(mlxsw_sib, i, module, width);
-		if (err)
-			goto err_port_create;
-	}
-	return 0;
-
-err_port_create:
-err_port_module_info_get:
-	for (i--; i >= 1; i--)
-		if (mlxsw_sib_port_created(mlxsw_sib, i))
-			mlxsw_sib_port_remove(mlxsw_sib, i);
-	kfree(mlxsw_sib->ports);
-	return err;
-}
-
-static void
-mlxsw_sib_pude_ib_event_func(struct mlxsw_sib_port *mlxsw_sib_port,
-			     enum mlxsw_reg_pude_oper_status status)
-{
-	if (status == MLXSW_PORT_OPER_STATUS_UP)
-		pr_info("ib link for port %d - up\n",
-			mlxsw_sib_port->mapping.module + 1);
-	else
-		pr_info("ib link for port %d - down\n",
-			mlxsw_sib_port->mapping.module + 1);
-}
-
-static void mlxsw_sib_pude_event_func(const struct mlxsw_reg_info *reg,
-				      char *pude_pl, void *priv)
-{
-	struct mlxsw_sib *mlxsw_sib = priv;
-	struct mlxsw_sib_port *mlxsw_sib_port;
-	enum mlxsw_reg_pude_oper_status status;
-	u8 local_port;
-
-	local_port = mlxsw_reg_pude_local_port_get(pude_pl);
-	mlxsw_sib_port = mlxsw_sib->ports[local_port];
-	if (!mlxsw_sib_port) {
-		dev_warn(mlxsw_sib->bus_info->dev, "Port %d: Link event received for non-existent port\n",
-			 local_port);
-		return;
-	}
-
-	status = mlxsw_reg_pude_oper_status_get(pude_pl);
-	mlxsw_sib_pude_ib_event_func(mlxsw_sib_port, status);
-}
-
-static const struct mlxsw_listener mlxsw_sib_listener[] = {
-	MLXSW_EVENTL(mlxsw_sib_pude_event_func, PUDE, EMAD),
-};
-
-static int mlxsw_sib_taps_init(struct mlxsw_sib *mlxsw_sib)
-{
-	int i;
-	int err;
-
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sib_listener); i++) {
-		err = mlxsw_core_trap_register(mlxsw_sib->core,
-					       &mlxsw_sib_listener[i],
-					       mlxsw_sib);
-		if (err)
-			goto err_rx_listener_register;
-	}
-
-	return 0;
-
-err_rx_listener_register:
-	for (i--; i >= 0; i--) {
-		mlxsw_core_trap_unregister(mlxsw_sib->core,
-					   &mlxsw_sib_listener[i],
-					   mlxsw_sib);
-	}
-
-	return err;
-}
-
-static void mlxsw_sib_traps_fini(struct mlxsw_sib *mlxsw_sib)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sib_listener); i++) {
-		mlxsw_core_trap_unregister(mlxsw_sib->core,
-					   &mlxsw_sib_listener[i], mlxsw_sib);
-	}
-}
-
-static int mlxsw_sib_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
-{
-	char htgt_pl[MLXSW_REG_HTGT_LEN];
-
-	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
-			    MLXSW_REG_HTGT_INVALID_POLICER,
-			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
-			    MLXSW_REG_HTGT_DEFAULT_TC);
-	mlxsw_reg_htgt_swid_set(htgt_pl, MLXSW_PORT_SWID_ALL_SWIDS);
-	mlxsw_reg_htgt_local_path_rdq_set(htgt_pl,
-					MLXSW_REG_HTGT_LOCAL_PATH_RDQ_SIB_EMAD);
-	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
-}
-
-static int mlxsw_sib_init(struct mlxsw_core *mlxsw_core,
-			  const struct mlxsw_bus_info *mlxsw_bus_info,
-			  struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_core_driver_priv(mlxsw_core);
-	int err;
-
-	mlxsw_sib->core = mlxsw_core;
-	mlxsw_sib->bus_info = mlxsw_bus_info;
-
-	err = mlxsw_sib_hw_id_get(mlxsw_sib);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Failed to get switch HW ID\n");
-		return err;
-	}
-
-	err = mlxsw_sib_ports_create(mlxsw_sib);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Failed to create ports\n");
-		return err;
-	}
-
-	err = mlxsw_sib_taps_init(mlxsw_sib);
-	if (err) {
-		dev_err(mlxsw_sib->bus_info->dev, "Failed to set traps\n");
-		goto err_traps_init_err;
-	}
-
-	return 0;
-
-err_traps_init_err:
-	mlxsw_sib_ports_remove(mlxsw_sib);
-	return err;
-}
-
-static void mlxsw_sib_fini(struct mlxsw_core *mlxsw_core)
-{
-	struct mlxsw_sib *mlxsw_sib = mlxsw_core_driver_priv(mlxsw_core);
-
-	mlxsw_sib_traps_fini(mlxsw_sib);
-	mlxsw_sib_ports_remove(mlxsw_sib);
-}
-
-static const struct mlxsw_config_profile mlxsw_sib_config_profile = {
-	.used_max_system_port		= 1,
-	.max_system_port		= 48000,
-	.used_max_ib_mc			= 1,
-	.max_ib_mc			= 27,
-	.used_max_pkey			= 1,
-	.max_pkey			= 32,
-	.swid_config			= {
-		{
-			.used_type	= 1,
-			.type		= MLXSW_PORT_SWID_TYPE_IB,
-		}
-	},
-};
-
-static struct mlxsw_driver mlxsw_sib_driver = {
-	.kind			= mlxsw_sib_driver_name,
-	.priv_size		= sizeof(struct mlxsw_sib),
-	.init			= mlxsw_sib_init,
-	.fini			= mlxsw_sib_fini,
-	.basic_trap_groups_set	= mlxsw_sib_basic_trap_groups_set,
-	.txhdr_construct	= mlxsw_sib_tx_v1_hdr_construct,
-	.txhdr_len		= MLXSW_TXHDR_LEN,
-	.profile		= &mlxsw_sib_config_profile,
-};
-
-static struct mlxsw_driver mlxsw_sib2_driver = {
-	.kind			= mlxsw_sib2_driver_name,
-	.priv_size		= sizeof(struct mlxsw_sib),
-	.init			= mlxsw_sib_init,
-	.fini			= mlxsw_sib_fini,
-	.basic_trap_groups_set	= mlxsw_sib_basic_trap_groups_set,
-	.txhdr_construct	= mlxsw_sib_tx_v1_hdr_construct,
-	.txhdr_len		= MLXSW_TXHDR_LEN,
-	.profile		= &mlxsw_sib_config_profile,
-};
-
-static const struct pci_device_id mlxsw_sib_pci_id_table[] = {
-	{PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_SWITCHIB), 0},
-	{0, },
-};
-
-static struct pci_driver mlxsw_sib_pci_driver = {
-	.name = mlxsw_sib_driver_name,
-	.id_table = mlxsw_sib_pci_id_table,
-};
-
-static const struct pci_device_id mlxsw_sib2_pci_id_table[] = {
-	{PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_SWITCHIB2), 0},
-	{0, },
-};
-
-static struct pci_driver mlxsw_sib2_pci_driver = {
-	.name = mlxsw_sib2_driver_name,
-	.id_table = mlxsw_sib2_pci_id_table,
-};
-
-static int __init mlxsw_sib_module_init(void)
-{
-	int err;
-
-	err = mlxsw_core_driver_register(&mlxsw_sib_driver);
-	if (err)
-		return err;
-
-	err = mlxsw_core_driver_register(&mlxsw_sib2_driver);
-	if (err)
-		goto err_sib2_driver_register;
-
-	err = mlxsw_pci_driver_register(&mlxsw_sib_pci_driver);
-	if (err)
-		goto err_sib_pci_driver_register;
-
-	err = mlxsw_pci_driver_register(&mlxsw_sib2_pci_driver);
-	if (err)
-		goto err_sib2_pci_driver_register;
-
-	return 0;
-
-err_sib2_pci_driver_register:
-	mlxsw_pci_driver_unregister(&mlxsw_sib_pci_driver);
-err_sib_pci_driver_register:
-	mlxsw_core_driver_unregister(&mlxsw_sib2_driver);
-err_sib2_driver_register:
-	mlxsw_core_driver_unregister(&mlxsw_sib_driver);
-	return err;
-}
-
-static void __exit mlxsw_sib_module_exit(void)
-{
-	mlxsw_pci_driver_unregister(&mlxsw_sib2_pci_driver);
-	mlxsw_pci_driver_unregister(&mlxsw_sib_pci_driver);
-	mlxsw_core_driver_unregister(&mlxsw_sib2_driver);
-	mlxsw_core_driver_unregister(&mlxsw_sib_driver);
-}
-
-module_init(mlxsw_sib_module_init);
-module_exit(mlxsw_sib_module_exit);
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_AUTHOR("Elad Raz <eladr@@mellanox.com>");
-MODULE_DESCRIPTION("Mellanox SwitchIB and SwitchIB-2 driver");
-MODULE_ALIAS("mlxsw_switchib2");
-MODULE_DEVICE_TABLE(pci, mlxsw_sib_pci_id_table);
-MODULE_DEVICE_TABLE(pci, mlxsw_sib2_pci_id_table);
-- 
2.31.1

