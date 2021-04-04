Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C7353762
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 10:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhDDIPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 04:15:08 -0400
Received: from mail-dm3nam07on2048.outbound.protection.outlook.com ([40.107.95.48]:20576
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229483AbhDDIPG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 04:15:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBh8ssJRMooDqAuGGMhXI6SdiERIp3hJ8D4fOJ7aTvq1uUcXuhmLbCI4Ry9/ZbkQaLFzyXUOyLnGlnPC1GeDAp9E5qqB3krQKkKiOQd5B4XsxwVcssWW0vuwar6omILDJaCWLZ+Zh3tNdproFoQ0QYSK3veCPK2M+SJZUI4mhofTdzkjZp1UQFgRMrUdh6VX1yes8dz1NlrEoQmBKeG6MZoGhNQWccc/KlWGc0J4fZvdZybkhfjihML1jZAgGOzf1FcJysOrnYbYqsXQzD1o+5HD4IhUo6gZ/bcpZSUE+BBuJyLpN30xtOqoQb49LOfQdL+gdvrWGtRBzWg/9GNLMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyzAfvy3Axgpy1j9w7I8lrMLRWEl7HfUilS/DU4rJpI=;
 b=oVaHUCsUv/jtqNIa2DMrWOM3wBixvmRrMKTNST9lhJRH5CPoeMWuy+LRCGICGgyCZqloia8Qmf8SEyROiYYho8vZOraKUONxPDFeRhB0PsYTHAwamKxOC20+PeHeWLElS1pu4mmdFrvO8xH8RD7w4VrHBVd5shrT0D+1EAZgfCBKzmkXkgSj6ezqX18Gwl4h05xgunNEYTFJ0BSnsD9rhR/OU4fbkGE8c/SJ/fwRrmsqTqtAxs0FOQTrkgFgcAey76HvJqIzUBxYXLX0ezzNH5HIUj2CiTUEar7KOwTlYiD98zJORMRDrMJVLch/blOq2/67/vglviXk4IlynS1SiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=embeddedor.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyzAfvy3Axgpy1j9w7I8lrMLRWEl7HfUilS/DU4rJpI=;
 b=HnZE/XIloKgMoQkkXRRopqk+EBTyTLC5qlu/CfSGdQTfZNliq2ME4TNG7JWrVKQEaHUNj+jIpO6WyZ35zvMEq4UaIydipxGZMlwqYzDZ4pUEWpKpsmx/Zf5kCwB6dd80kXrd0l++D2UUyLcMLs0QX7GE8af+vDxp+oWk4fbwOPx9XN2HKFgB9hb+GoWysUiplyqt/KC0leEvmgjeZX10+jouVrFBYJWbk8+vjPnWnxUdQrXFmdNTB1lCWxlPkluiqx1PB2w3D9Sfk3V7kv1mKSmvzCou6rHNVEkSHwYR6WC6pJcQuFlI+wU0Sk74HlxrU+YEonC+sLro2CIRk/vzmA==
Received: from DM5PR19CA0037.namprd19.prod.outlook.com (2603:10b6:3:9a::23) by
 DM6PR12MB3322.namprd12.prod.outlook.com (2603:10b6:5:119::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Sun, 4 Apr 2021 08:15:01 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::e) by DM5PR19CA0037.outlook.office365.com
 (2603:10b6:3:9a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend
 Transport; Sun, 4 Apr 2021 08:15:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Sun, 4 Apr 2021 08:15:00 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 4 Apr 2021 08:14:56 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability bit to ethtool_ops
Date:   Sun, 4 Apr 2021 11:14:32 +0300
Message-ID: <20210404081433.1260889-2-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210404081433.1260889-1-danieller@nvidia.com>
References: <20210404081433.1260889-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2eec65bb-e138-43cc-eb3d-08d8f741be46
X-MS-TrafficTypeDiagnostic: DM6PR12MB3322:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33223FE257585481D6338843D8789@DM6PR12MB3322.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g55C/IX9ohLxDQFZbLalt0POcrcWmZEZIRpY5fuPCHiIgK5IRjHu4veXJRvFRoTm80YwqsjhYWrwECc1uusefvBtDUyvDXnw82tKdNi9Mo7Asb8sIdOXchOPh7y7PpDQ6dEsTHjcPJXhnkspxOWAfp5URIuolwZKSEQH32C/7upIo6YjHVwYdTgDCrpn8r8CqbyeQhMTr02hlrYKRodQ8UnQJsuwiRr3Jf935a2jYa15TjlcnzOPI3OjzWBQXP3rXESB87IBPiNQNDn9+cYlySd8vYAdLfZuVhrxBcYR2pK8zjz8+fhgX9QBHfYo1GRn1q/qDKFYD3MOZeBsmLsjeXLRABO6WHzMVtbKC6MrkiU6Y8HkGAB7mh9/vkleqhXSg+pef6Qsa2b0AcQstHfPc8jlnLU9Y3k58FYXe6jakyVynmaWnAQy8hhpQ2+hcrjK8nKSpbFRu1dMO7zhHIKrleP5fhncy9bElp6ewNkMCfPZ0/NJFHS2gHEolkpISyu+Xal6klZbGMgppNX6xlWR8/GMHjyRKNtNSuLJqB7++fqLlzh1+/byQnL66HidBrYS13mDpyXggtJ47w1odSfivaqJAZ/XZCSWxoJLfxkLEHdZ05Xa/1MKOO77avygEX0yc8wH9OWZ9YtP3tXLE/FPUvJGm/AILTkG+dH5DZhVG8c=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(70586007)(316002)(8936002)(47076005)(70206006)(2906002)(82310400003)(7416002)(36756003)(83380400001)(6666004)(336012)(426003)(54906003)(86362001)(478600001)(356005)(82740400003)(2616005)(7636003)(5660300002)(36860700001)(6916009)(4326008)(1076003)(186003)(107886003)(16526019)(8676002)(36906005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 08:15:00.8959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eec65bb-e138-43cc-eb3d-08d8f741be46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3322
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers clear the 'ethtool_link_ksettings' struct in their
get_link_ksettings() callback, before populating it with actual values.
Such drivers will set the new 'link_mode' field to zero, resulting in
user space receiving wrong link mode information given that zero is a
valid value for the field.

Fix this by introducing a new capability bit ('cap_link_mode_supported')
to ethtool_ops, which indicates whether the driver supports 'link_mode'
parameter or not. Set it to true in mlxsw which is currently the only
driver supporting 'link_mode'.

Another problem is that some drivers (notably tun) can report random
values in the 'link_mode' field. This can result in a general protection
fault when the field is used as an index to the 'link_mode_params' array
[1].

This happens because such drivers implement their set_link_ksettings()
callback by simply overwriting their private copy of
'ethtool_link_ksettings' struct with the one they get from the stack,
which is not always properly initialized.

Fix this by making sure that the implied parameters will be derived from
the 'link_mode' parameter only when the 'cap_link_mode_supported' is set.

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
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 1 +
 include/linux/ethtool.h                                | 5 ++++-
 net/ethtool/ioctl.c                                    | 8 ++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 0bd64169bf81..54f04c94210c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1061,6 +1061,7 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.cap_link_lanes_supported	= true,
+	.cap_link_mode_supported	= true,
 	.get_drvinfo			= mlxsw_sp_port_get_drvinfo,
 	.get_link			= ethtool_op_get_link,
 	.get_link_ext_state		= mlxsw_sp_port_get_link_ext_state,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..9e6eb6df375d 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -269,6 +269,8 @@ struct ethtool_pause_stats {
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
  *	parameter.
+ * @cap_link_mode_supported: indicates if the driver supports link_mode
+ *	parameter.
  * @supported_coalesce_params: supported types of interrupt coalescing.
  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
@@ -424,7 +426,8 @@ struct ethtool_pause_stats {
  * of the generic netdev features interface.
  */
 struct ethtool_ops {
-	u32     cap_link_lanes_supported:1;
+	u32     cap_link_lanes_supported:1,
+		cap_link_mode_supported:1;
 	u32	supported_coalesce_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 24783b71c584..cebbf93b27a7 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -436,12 +436,16 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
 
-	link_ksettings->link_mode = -1;
 	err = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 	if (err)
 		return err;
 
-	if (link_ksettings->link_mode != -1) {
+	if (dev->ethtool_ops->cap_link_mode_supported &&
+	    link_ksettings->link_mode != -1) {
+		if (WARN_ON_ONCE(link_ksettings->link_mode >=
+				 __ETHTOOL_LINK_MODE_MASK_NBITS))
+			return -EINVAL;
+
 		link_info = &link_mode_params[link_ksettings->link_mode];
 		link_ksettings->base.speed = link_info->speed;
 		link_ksettings->lanes = link_info->lanes;
-- 
2.26.2

