Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B487723AE56
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgHCUnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:43:11 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:3002
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgHCUnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:43:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PokMveL6XWwKPnIHPuR67sXLlFSbmLOGLx1PV3AuZqmBSfHhyXiiL6lF7hQzHM/h2B3JjTKoGzygKPFnDSdNgCq79jxJ/VU5LNzjYLFlhdtpGnYSVY/3MXRljRAuVHam+VH8TFXYEO11r+AOf+ZkSwwBcP45Tn/kImaKtTipgxMq2kJdO/J7pPGQp+Xa0JpRAqKBcCGV5tWAN2SQNhkhZZM3DCynXYtKvuqaBkyEUnwcoyMAt+MSbc9TarPYV8Bcs/soGr4XhWu2USG+HB6aNsmeMxXLBzJ/3w8juZ25FPtQ7bCwkZ9W+el2eTh0joJnqBXj9J7zoFvXXHthV8Kh2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqrAfyuVsR3M6eKxmE7oZafb4vo+/pTjcl6XBcWRTxM=;
 b=LaPHxD12pSnfL9oSsEHWjMgZBeUGF1LPbZi9VJO+KHVLpnkOXhyXhg1LySAFDCIDADJ0/GKfUjF5tmJtIHC3xW9Y9ZGcofl+dI5+ePDX758sOGdElUttQzScWum76mDodm9AFn6oEwWTfX3CQEo547sNwdhXjNOsZQH0VsOCuDNBKAN+T+seKUVJ+NyeOb+e4bewVgamGZeLYxKAx27DNISulIRE5NYLWkuRQkM+6Ron3arkbtOR/ORw0NvoDAUqtjDvRK6ItbWLWKFl2kLzLF6lFWudg+YvNkdVkFzwzgGQnvhO8fvNyFjBfBCbYD2GctulV22JmPlA9yzARr5daQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqrAfyuVsR3M6eKxmE7oZafb4vo+/pTjcl6XBcWRTxM=;
 b=SpsoFUOGa02T33JXh9ST5CzUCUL31tJHIZHAyQK3dfkef26/vlQS4yh3ut8eu1v4HBHk1jbffhzZ8eFjMDe6DHvDj8Z+1yC+iU7U3rz1d/CkJdBRfbsnZ2QAa1hFb5TR5BYA3C+t05qcJpXrFp6/O3wSVvHciL2ZUYAbzfMJPFE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6110.eurprd05.prod.outlook.com (2603:10a6:803:eb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 20:43:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:43:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 5/5] net/mlx5: Delete extra dump stack that gives nothing
Date:   Mon,  3 Aug 2020 13:41:51 -0700
Message-Id: <20200803204151.120802-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803204151.120802-1-saeedm@mellanox.com>
References: <20200803204151.120802-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 20:43:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2965e2f1-252e-487c-b127-08d837edd1a0
X-MS-TrafficTypeDiagnostic: VI1PR05MB6110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB61104069595895BEEC715670BE4D0@VI1PR05MB6110.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UKQt4JuxIO1GdZiiABUoyPSpBx4f54Slab9fYtACw1/2B10o8RX6pdjQE5c5/RU6Z1V0eaeMRaTy1FOhlLcZqAc7XQ8SGSBMSUq4HZmwwcsPNl2OBySs7bV01Ak18Zv8U6AO5TmV4idMRZJgpiL57SYG8RMZk/1pUQpQ5uoilZWaVyBT5q4/y1c8hHWIoLY6lqDqj/uXWqoYWrHjBXRoQ/6TvmlkFvQDITfdiFySSijIHK2icYQ+r1oSvx+0PXh0rzDKvtsmNJ5GjTlPEEg2iZpcHh/jTdqMBLcb7GPirDBkdEto2xYyJ2ZWJN77yw3UzwZcgXKeKjW8FhLfTHUFvY/FV3eh8s0CRfqiJtEC3xKB1gti7ckDbkOonq97FDmQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(6506007)(52116002)(83380400001)(66476007)(8676002)(66556008)(66946007)(2616005)(956004)(107886003)(1076003)(16526019)(186003)(26005)(478600001)(6486002)(316002)(36756003)(5660300002)(86362001)(8936002)(54906003)(110136005)(6666004)(2906002)(4326008)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oI4bN/TM7XOMAQjXSx/QU4wVtWdyNLmu8qmHSUxt3F5h2TiNf1Dh8ZBoqgLkdLKcqLUg1ZW2CkMshIfg1t6LoyoML5PFyN3WFspJEAmVOVQFuJefj15/hnc1/Ff8xmWydYUqIEAe3MWEZcVCe5XqyJM+ckOR9eSTIUnyy9vo7uc4cXfjpxsNx/1/wqXR5ntW8tWfh5uvjeKrXJynP+nbUVHrgRm3qmhxA6dzkrnT3XVBdaNFuEkL0RyYLMlrmL2gfUDzTwv5iNOszKSxBkjRWwPLFOfRPUnFonvvhMqAGHAc8Q8I9/yTwCMZgTfeeB8cFBkZDLPEHvNwRvxYcNMrgo6sD+V9TkmJXKR1LN+Ar7krZY0/K/ezLRrbMGhSNcJ8i2U2RUfLMA4iO3yXbdjO+dEzSIBAQpZ1dTxmsD+tlFY7vwZ/ynZrIiJLAtRNwv+BIp1y+jjc7+zi9RN43u+M0N/sSxv82daiNB4ptVWLiK4vr2z4j9cq0bKmKE2gEnVI0+upyITYXMuo5JmlP1i1EFYq6aFyWJ6J2aXVSe1MgAbJAR0L82eCM8zgaV4/av+2ZazUosBnVxDtlAZGEv7t/wuDXR+Nuxx6fBRuiIqPaVPmT3pApEMFcUUuOQL9EN5aafXC9nILjGcdStZGIJrZsQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2965e2f1-252e-487c-b127-08d837edd1a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 20:43:05.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lJsYTzh5Y7B1HKoixv+y0w9Q7BTwDvZJyGZhKAKIWfuwHe35ubBD4IhRO3pMSZW3s4FEC5sq8gj8tcgnKHg8Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The WARN_*() macros are intended to catch impossible situations
from the SW point of view. They gave a little in case HW<->SW interface
is out-of-sync.

Such out-of-sync scenario can be due to SW errors that are not part
of this flow or because some HW errors, where dump stack won't help
either.

This specific WARN_ON() is useless because mlx5_core code is prepared
to handle such situations and will unfold everything correctly while
providing enough information to the users to understand why FS is not
working.

WARNING: CPU: 0 PID: 3222 at drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:825 connect_fts_in_prio.isra.20+0x1dd/0x260 linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:825
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 3222 Comm: syz-executor861 Not tainted 5.5.0-rc6+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack linux/lib/dump_stack.c:77 [inline]
 dump_stack+0x94/0xce linux/lib/dump_stack.c:118
 panic+0x234/0x56f linux/kernel/panic.c:221
 __warn+0x1cc/0x1e1 linux/kernel/panic.c:582
 report_bug+0x200/0x310 linux/lib/bug.c:195
 fixup_bug.part.11+0x32/0x80 linux/arch/x86/kernel/traps.c:174
 fixup_bug linux/arch/x86/kernel/traps.c:273 [inline]
 do_error_trap+0xd3/0x100 linux/arch/x86/kernel/traps.c:267
 do_invalid_op+0x31/0x40 linux/arch/x86/kernel/traps.c:286
 invalid_op+0x1e/0x30 linux/arch/x86/entry/entry_64.S:1027
RIP: 0010:connect_fts_in_prio.isra.20+0x1dd/0x260
linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:825
Code: 00 00 48 c7 c2 60 8c 31 84 48 c7 c6 00 81 31 84 48 8b 38 e8 3c a8
cb ff 41 83 fd 01 8b 04 24 0f 8e 29 ff ff ff e8 83 7b bc fe <0f> 0b 8b
04 24 e9 1a ff ff ff 89 04 24 e8 c1 20 e0 fe 8b 04 24 eb
RSP: 0018:ffffc90004bb7858 EFLAGS: 00010293
RAX: ffff88805de98e80 RBX: 0000000000000c96 RCX: ffffffff827a853d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffff52000976efa
RBP: 0000000000000007 R08: ffffed100da060e3 R09: ffffed100da060e3
R10: 0000000000000001 R11: ffffed100da060e2 R12: dffffc0000000000
R13: 0000000000000002 R14: ffff8880683a1a10 R15: ffffed100d07bc1c
 connect_prev_fts linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:844 [inline]
 connect_flow_table linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:975 [inline]
 __mlx5_create_flow_table+0x8f8/0x1710 linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:1064
 mlx5_create_flow_table linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:1094 [inline]
 mlx5_create_auto_grouped_flow_table+0xe1/0x210 linux/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:1136
 _get_prio linux/drivers/infiniband/hw/mlx5/main.c:3286 [inline]
 get_flow_table+0x2ea/0x760 linux/drivers/infiniband/hw/mlx5/main.c:3376
 mlx5_ib_create_flow+0x331/0x11c0 linux/drivers/infiniband/hw/mlx5/main.c:3896
 ib_uverbs_ex_create_flow+0x13e8/0x1b40 linux/drivers/infiniband/core/uverbs_cmd.c:3311
 ib_uverbs_write+0xaa5/0xdf0 linux/drivers/infiniband/core/uverbs_main.c:769
 __vfs_write+0x7c/0x100 linux/fs/read_write.c:494
 vfs_write+0x168/0x4a0 linux/fs/read_write.c:558
 ksys_write+0xc8/0x200 linux/fs/read_write.c:611
 do_syscall_64+0x9c/0x390 linux/arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a059
Code: 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcc17564c98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fcc17564ca0 RCX: 000000000045a059
RDX: 0000000000000030 RSI: 00000000200003c0 RDI: 0000000000000005
RBP: 0000000000000007 R08: 0000000000000002 R09: 0000000000003131
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e636c
R13: 0000000000000000 R14: 00000000006e6360 R15: 00007ffdcbdaf6a0
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..

Fixes: f90edfd279f3 ("net/mlx5_core: Connect flow tables")
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index a108148148568..7e70a8178a462 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -846,18 +846,15 @@ static int connect_fts_in_prio(struct mlx5_core_dev *dev,
 {
 	struct mlx5_flow_root_namespace *root = find_root(&prio->node);
 	struct mlx5_flow_table *iter;
-	int i = 0;
 	int err;
 
 	fs_for_each_ft(iter, prio) {
-		i++;
 		err = root->cmds->modify_flow_table(root, iter, ft);
 		if (err) {
-			mlx5_core_warn(dev, "Failed to modify flow table %d\n",
-				       iter->id);
+			mlx5_core_err(dev,
+				      "Failed to modify flow table id %d, type %d, err %d\n",
+				      iter->id, iter->type, err);
 			/* The driver is out of sync with the FW */
-			if (i > 1)
-				WARN_ON(true);
 			return err;
 		}
 	}
-- 
2.26.2

