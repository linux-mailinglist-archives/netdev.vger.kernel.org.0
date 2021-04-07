Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291B935690A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244712AbhDGKHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:07:47 -0400
Received: from mail-bn8nam11on2071.outbound.protection.outlook.com ([40.107.236.71]:25152
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346626AbhDGKHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 06:07:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9DQL6FOglJupxoJvF83FB8X/1faD9VDlSQn9FKNbrSunAu6CPtOSf1zBNpXy3l0bXTfxmcCvBwqGmQzzdF4RacdaZ7NrfG5oloObsw9uv0ozTFIA2qlSdS/edbUe7CkfVZK/c8wX6NU+2vSkk3xqZa4LBfWvsyFNLonTJTs0fZz/6etK7BlnsqHzye20OMjJqryeFP4Jsc/2xpiwjxbXOBHnKqtgBM3yD+zvtspO+UM6P94t3Q0rcYFpFwOw9ratbFtgXdQ/KISmBcu4/yekbuB27O4HtxYsl/DK6ze2KIQnTvIdaOMfhHAqZNhV18GodJFi3qldiXRhsL0CCkChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3+pICsOyWBKA3XVi46fWXHs5CWPXGUAFHJ04RbQz80=;
 b=E5H9hDydRtgLCbcAEILqllVptOA/RdtoqI9PHcKdncz2hLgqcjxaGVe64DAorMu9PBjhC9S4Fqp1ivCPMxR8orEpjfJI40rQxByMDjKAVbZzKi0wb0hQYVTNABY1c81SpViUW0+yaj8GnaSctlN6LXY+UwQGT7ClllhBJy1KTAwre/hcCPnuaAIzdWpT7iJpthMxozdLVPSaboBv4dn/X3oYPO43HsJpG4BJcIjXTZW86UTnwyhTwCxSIzr2T3r5XghHlNxnzYYNzVO0Z03ZNsescJAKwJLfRhy5x/zfzlYbhbqYMpG/1hDBkH1AHwOHfluN/FCAsqbPmkV1VcqNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=embeddedor.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3+pICsOyWBKA3XVi46fWXHs5CWPXGUAFHJ04RbQz80=;
 b=VwxD1Zuocx3n0igXTh3st33sb8EHfMp3AVZqnQFdXNpl0gNhI4P44hISmULy+Pkw55ci65km7lHFIo0WQLTqdzZDWgeiW8MDzPdYtTBXx4qJbjyrWcfZOtEyX572zIeA5AZrQXSLEa9l2idpQ3/XyZ5qwJ6xG3uaK3cwE93axjP4dfIyZ7rxe/8SHNgYVusn6EI4CUEc0JQ428GXkzzeCldgJAF/X8GjNmXUBgNyLy9dtRiHQ11FpSr0JVmSgb8JT1aiBTWPUmeRWJd/q+6hBzsiBDvXsPIDqOk4gJzE4o0snwxnpymP7pFBwJaDXTEkktgTQz29Wyq8hApgn+9coQ==
Received: from MWHPR21CA0037.namprd21.prod.outlook.com (2603:10b6:300:129::23)
 by CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 10:07:23 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::33) by MWHPR21CA0037.outlook.office365.com
 (2603:10b6:300:129::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.3 via Frontend
 Transport; Wed, 7 Apr 2021 10:07:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 10:07:23 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 7 Apr 2021 10:07:18 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net v3 1/2] ethtool: Remove link_mode param and derive link params from driver
Date:   Wed, 7 Apr 2021 13:06:51 +0300
Message-ID: <20210407100652.2150415-2-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407100652.2150415-1-danieller@nvidia.com>
References: <20210407100652.2150415-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0b06c96-e61b-4525-5ffb-08d8f9acf031
X-MS-TrafficTypeDiagnostic: CH0PR12MB5091:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5091486F93B44C630D89CD17D8759@CH0PR12MB5091.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9acc/BEaTSnJMtohWLPZI8kKTVtzK1YvQrYib5C6SAz4RYggqQlkdsop8r2ZUfEXVRa+yKW157e0k5gbeTVcduDjwbNfxBymTBFm52p8N8i3cJCNNwmuvAi0eUMGXViRgVkSSaKni3Itk/bCca1/OMtbgGrkP06AmLLvCiujdbwxIwwxfq4JCDn06KtB7oX6d2yxybnku4mCUc1S/2igWZlidk1CU8CbZdNFpBA3YshdNaz0gC2VwPb8/K2yloXudfQ8hG6XXRbCXfpdpEG+l73UbbiftMHBctORF3yWA/fGSLQibhcd4q0X1f4SKf5xHhr5hTAyUXT8OTno7k664v2uUtlZBxGmmtP4c0NXR35X/ZkKRCf2mdRPbL7mRelCivNuv2JeV6MrmoikgmNwpbNEDLFdQK7plRCAxnQsw8bjqv/VWSE4K8r03iaGdAT3y5swOfGH1HdZ737udiwoP2IblufpKI6WzcHxY6I+2eInRqPo+Trp19pWMzo8HIZbPHUPeYSd0266obM8FDVeWjGxf6otJ8vHFyS65M1Ae242iIZHjbTOnW1i/kbqZhXtveTzRrC07QmrAhB/psBWUziCcUDxumLwboKmmLLgSMoS5i3wMmbYBIOMnWYVVFCq6C4KKStRnitjGply3hLdA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(36840700001)(316002)(107886003)(83380400001)(478600001)(36860700001)(356005)(16526019)(36756003)(7416002)(54906003)(82740400003)(7636003)(4326008)(82310400003)(426003)(336012)(6666004)(36906005)(2906002)(1076003)(26005)(86362001)(5660300002)(47076005)(8936002)(70586007)(70206006)(2616005)(8676002)(186003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 10:07:23.0465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b06c96-e61b-4525-5ffb-08d8f9acf031
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers clear the 'ethtool_link_ksettings' struct in their
get_link_ksettings() callback, before populating it with actual values.
Such drivers will set the new 'link_mode' field to zero, resulting in
user space receiving wrong link mode information given that zero is a
valid value for the field.

Another problem is that some drivers (notably tun) can report random
values in the 'link_mode' field. This can result in a general protection
fault when the field is used as an index to the 'link_mode_params' array
[1].

This happens because such drivers implement their set_link_ksettings()
callback by simply overwriting their private copy of
'ethtool_link_ksettings' struct with the one they get from the stack,
which is not always properly initialized.

Fix these problems by removing 'link_mode' from 'ethtool_link_ksettings'
and instead have drivers call ethtool_params_from_link_mode() with the
current link mode. The function will derive the link parameters (e.g.,
speed) from the link mode and fill them in the 'ethtool_link_ksettings'
struct.

v3:
	* Remove link_mode parameter and derive the link parameters in
	  the driver instead of passing link_mode parameter to ethtool
	  and derive it there.

v2:
	* Introduce 'cap_link_mode_supported' instead of adding a
	  validity field to 'ethtool_link_ksettings' struct.

[1]
general protection fault, probably for non-canonical address 0xdffffc00f14cc32c: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000000078a661960-0x000000078a661967]
CPU: 0 PID: 8452 Comm: syz-executor360 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__ethtool_get_link_ksettings+0x1a3/0x3a0 net/ethtool/ioctl.c:446
Code: b7 3e fa 83 fd ff 0f 84 30 01 00 00 e8 16 b0 3e fa 48 8d 3c ed 60 d5 69 8a 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03
+38 d0 7c 08 84 d2 0f 85 b9
RSP: 0018:ffffc900019df7a0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888026136008 RCX: 0000000000000000
RDX: 00000000f14cc32c RSI: ffffffff873439ca RDI: 000000078a661960
RBP: 00000000ffff8880 R08: 00000000ffffffff R09: ffff88802613606f
R10: ffffffff873439bc R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802613606c R14: ffff888011d0c210 R15: ffff888011d0c210
FS:  0000000000749300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b60f0 CR3: 00000000185c2000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 linkinfo_prepare_data+0xfd/0x280 net/ethtool/linkinfo.c:37
 ethnl_default_notify+0x1dc/0x630 net/ethtool/netlink.c:586
 ethtool_notify+0xbd/0x1f0 net/ethtool/netlink.c:656
 ethtool_set_link_ksettings+0x277/0x330 net/ethtool/ioctl.c:620
 dev_ethtool+0x2b35/0x45d0 net/ethtool/ioctl.c:2842
 dev_ioctl+0x463/0xb70 net/core/dev_ioctl.c:440
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: c8907043c6ac9 ("ethtool: Get link mode in use instead of speed and duplex parameters")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 19 ++++++++++++++-----
 include/linux/ethtool.h                       |  9 ++++++++-
 net/ethtool/common.c                          | 16 ++++++++++++++++
 net/ethtool/ioctl.c                           | 18 +-----------------
 4 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 0bd64169bf81..078601d31cde 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1230,16 +1230,22 @@ mlxsw_sp1_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 			      u32 ptys_eth_proto,
 			      struct ethtool_link_ksettings *cmd)
 {
+	struct mlxsw_sp1_port_link_mode link;
 	int i;
 
-	cmd->link_mode = -1;
+	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+	cmd->lanes = 0;
 
 	if (!carrier_ok)
 		return;
 
 	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
-			cmd->link_mode = mlxsw_sp1_port_link_mode[i].mask_ethtool;
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask) {
+			link = mlxsw_sp1_port_link_mode[i];
+			ethtool_params_from_link_mode(cmd,
+						      link.mask_ethtool);
+		}
 	}
 }
 
@@ -1672,7 +1678,9 @@ mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 	struct mlxsw_sp2_port_link_mode link;
 	int i;
 
-	cmd->link_mode = -1;
+	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+	cmd->lanes = 0;
 
 	if (!carrier_ok)
 		return;
@@ -1680,7 +1688,8 @@ mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
 		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
 			link = mlxsw_sp2_port_link_mode[i];
-			cmd->link_mode = link.mask_ethtool[1];
+			ethtool_params_from_link_mode(cmd,
+						      link.mask_ethtool[1]);
 		}
 	}
 }
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..7a106a022506 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -129,7 +129,6 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
 	u32	lanes;
-	enum ethtool_link_mode_bit_indices link_mode;
 };
 
 /**
@@ -571,4 +570,12 @@ struct ethtool_phy_ops {
  */
 void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 
+/*
+ * ethtool_params_from_link_mode - Derive link parameters from a given link mode
+ * @link_ksettings: Link parameters to be derived from the link mode
+ * @link_mode: Link mode
+ */
+void
+ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
+			      enum ethtool_link_mode_bit_indices link_mode);
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index c6a383dfd6c2..030aa7984a91 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -562,3 +562,19 @@ void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
 	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(ethtool_set_ethtool_phy_ops);
+
+void
+ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
+			      enum ethtool_link_mode_bit_indices link_mode)
+{
+	const struct link_mode_info *link_info;
+
+	if (WARN_ON_ONCE(link_mode >= __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return;
+
+	link_info = &link_mode_params[link_mode];
+	link_ksettings->base.speed = link_info->speed;
+	link_ksettings->lanes = link_info->lanes;
+	link_ksettings->base.duplex = link_info->duplex;
+}
+EXPORT_SYMBOL_GPL(ethtool_params_from_link_mode);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 24783b71c584..771688e1b0da 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -426,29 +426,13 @@ struct ethtool_link_usettings {
 int __ethtool_get_link_ksettings(struct net_device *dev,
 				 struct ethtool_link_ksettings *link_ksettings)
 {
-	const struct link_mode_info *link_info;
-	int err;
-
 	ASSERT_RTNL();
 
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
 
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
-
-	link_ksettings->link_mode = -1;
-	err = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
-	if (err)
-		return err;
-
-	if (link_ksettings->link_mode != -1) {
-		link_info = &link_mode_params[link_ksettings->link_mode];
-		link_ksettings->base.speed = link_info->speed;
-		link_ksettings->lanes = link_info->lanes;
-		link_ksettings->base.duplex = link_info->duplex;
-	}
-
-	return 0;
+	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 }
 EXPORT_SYMBOL(__ethtool_get_link_ksettings);
 
-- 
2.26.2

