Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6120625FF8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiKKREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiKKREB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:04:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF0371F26
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:04:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7s2ByFntN/vDr3MTtMJ2FrLFO3enZ15lgyMJlBN7qJ6WnYsr3SHg8q1YWvBgCpeP6G/6HdbkgC2ms3CsVmDzbx7Pi7vUcNTFJpIg3T0rpcMn0IOjHghUCON/6b5whvhPNsWOjmTWpgvI2ueUj1RPpUGBdme0PbCatEtwQrgRv/J0GqlZl2UoPLpq8deQTmKHm2xQAGQwsa5P3byH1OIxYpJ+Bdnx7689sFpdAnttto7XBq5PPWwQLgyjN/vWfetfYipBTRCkM3EdkBmPBgHtOthJy10hpKldWNHcOhwqmwWIlNSpe7qjvpHxEPrs9J7d7dvkJXNnC9djIpqjcCNSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4/dYI6yQWpA5E+GNFo3uYN0JR1m6O1vP3BPh9XXoVI=;
 b=X4MEkAXN6JGtPLLO4J4vUuKt9wB9DUOCDYzVER4ii14NnTDsbywE+wmuidIpAvZZXKDBapEfnZOfOSR3A67lVd4xycuLzhYkxaHhExRfjn+XaacX/4vhJq8+ZdadD3a8j3btL4HO4l1x2TDCnC3I268JNP72m5mdZt8HeNhkK/27qqosEpD47UF6VMHNKsoU/W5BxD2e0vBzBUUwPotxjGKB0XbqnGayroxmgt6HzwECPUus5Mbysgbwqy6Ht2MhEqkyQC6oaIZ2D27CKvvk8icxYYTmai+e+PG53fN8E3Qr76SQaIML02XVakmmd8qyVukg9Gx7PmoBFaLxr8Z2gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4/dYI6yQWpA5E+GNFo3uYN0JR1m6O1vP3BPh9XXoVI=;
 b=HYLEpymd+vj14zHzp8sSAMnUhrShcT5inslt8cG+D1E1jg6tao77zHwVPngy26P0AmgUxMqYustIaClYXB1JnGZqY39Ve+ORuXLEUDSTj4LMReqE/VlnXErMUDfkyOK+03qkHD+bICaXjXTI+leDoBaeHH2PyHSzRxpjKK4VBwzEzruXPMXXxW/1P4jT3C6Ki31ZbwYDhJSTB5RfP8ojgd5iTmPzxWdvKd61W1q1PnY6LW3E/kgF9F/Z4ONgqahduXWCiJnf2Y4Ncx8C20hYCjfZp+DCELk37Obif/6SgMW++J1Y2GwW6RwPJgxp67GA45EHipg4jiNTsNEoanxCPg==
Received: from DS7PR03CA0048.namprd03.prod.outlook.com (2603:10b6:5:3b5::23)
 by IA1PR12MB6409.namprd12.prod.outlook.com (2603:10b6:208:38b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 17:03:58 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::6f) by DS7PR03CA0048.outlook.office365.com
 (2603:10b6:5:3b5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Fri, 11 Nov 2022 17:03:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Fri, 11 Nov 2022 17:03:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 11 Nov
 2022 09:03:47 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 11 Nov 2022 09:03:44 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net] mlxsw: Avoid warnings when not offloaded FDB entry with IPv6 is removed
Date:   Fri, 11 Nov 2022 18:03:27 +0100
Message-ID: <c186de8cbd28e3eb661e06f31f7f2f2dff30020f.1668184350.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|IA1PR12MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c37996-88d7-4032-c64a-08dac406b904
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5OWMy1uGFxiAFo5zUzZBxEe69wB4x6wuFwHMbHsCkRzdOEKfjTAbxwWkLgyGy6hwGgXhWouoriV+ThW/w4Zt04A0AKsVpuKxSk/TA6gmSbDxnYykaF0aHUghD2mVPdn8dwW4jk5hbq4NsQg6JUjvYAeZ2hv4xHPC4F+aWW1KJcsQGRj1buR8JqlrfIj6kIewcESzMTL/sZHJI4+8AmLwjFXv7687qZiOiy6Nl9w0kcaci3aNutzxasKMJuKkc99ylX4lTZaGIYHu79EfvMAYNwY187DMGeC+XxnI2JmXwsotvKE4oxKmEgQs3TaFP0SdjbbJOczHUZSTRkqY2tp9J61YtBnj0dd7h39tbS5RdSW/CxnErX0xTAqMwEbU2Zq9N6shgoxuoImvYziOfdKidU7Ekb90owsPiLGdy9YjlY7wx4BGkLj6sXTe3FA9qhviBJf/YhJQJ53FciyFBVHjlUjDUHJbi+/4N96KtXP8/Z+5UDXu8rDSDcnpClOnakzbp88IufxbmYfJT8IUhz7LAcZIvd1HuwJJq3dNPRU2v4PWCF3SWyLEGoykJW/JVTXgtpnwb8eVW8ttnzXjhkOa70rc96rpPbIvnuxVpOgtIspLQkNJknApldTwacOGIh0/8K2mZ4kPxCAE+Tx9YbS9xMcY/LhdUaKsW1IbNipCmJTiAsqmZXXk4QobXTYIS6UpqOxwqlwBuUQYzzoDpVC7b5C0ug9TAF2lnHi4Ry60J/jSM5n0pdW3iFqQB3deCG42SFclAR0xGe8L9600LUmBOA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(7696005)(16526019)(2906002)(336012)(8936002)(186003)(26005)(2616005)(70206006)(426003)(70586007)(47076005)(8676002)(4326008)(356005)(41300700001)(82740400003)(36756003)(86362001)(82310400005)(40460700003)(7636003)(83380400001)(36860700001)(6666004)(107886003)(5660300002)(478600001)(40480700001)(110136005)(54906003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 17:03:57.7729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c37996-88d7-4032-c64a-08dac406b904
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6409
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

FDB entries that perform VXLAN encapsulation with an IPv6 underlay hold
a reference on a resource - the KVDL entry where the IPv6 underlay
destination IP is stored. For that, the driver maintains two hash tables:
1. Maps IPv6 to KVDL index
2. Maps {MAC, FID index} to IPv6 address

When a FDB entry is removed, the second table is used to find the relevant
IPv6 address and the first table is used to remove the reference count and
free the index if is not used anymore.

In order for a packet to be forwarded to a single remote VTEP, FDB
entries need to be configured at both the bridge and VXLAN devices' FDB
tables. Both entries are squashed into one {MAC, VLAN/VNI} -> IP entry
in the hardware. Therefore, in case one entry is removed, the entry will
be removed from the hardware and the remaining entry will be unmarked
with 'offload' flag since it is not offloaded anymore.

For example, the two FDB entries should be added to allow packets to be
forwarded via vx10:
$ bridge fdb add dev vx10 aa:bb:cc:dd:ee:ff self static dst 2001:db8:5::1
$ bridge fdb add dev vx10 aa:bb:cc:dd:ee:ff master static vlan 10

When one entry will be removed, the second one will not be offloaded
anymore. When the first entry (in VXLAN FDB) will be removed / will not be
offloaded anymore, the two mappings in IPv6 hash tables will be removed.

In case that the second entry is removed before the first one, unexpected
warnings[1][2] will be shown in user space as a result of removing the
first entry. The issue is that not offloaded entry is removed, the driver
tries to search the relevant entries in the hash tables, does not find them
and therefore warns.

Do not handle removing of not offloaded VXLAN FDB entries, as they were
already removed when the offload flag was removed.

[1]:
WARNING: CPU: 1 PID: 239 at drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c:914 mlxsw_sp_nve_ipv6_addr_map_del+0x6b/0x80 [mlxsw_spectrum]
...
Hardware name: Mellanox Technologies Ltd. Mellanox switch/Mellanox switch, BIOS 4.6.5 05/21/2015
Workqueue: mlxsw_core_ordered mlxsw_sp_switchdev_vxlan_fdb_event_work [mlxsw_spectrum]
RIP: 0010:mlxsw_sp_nve_ipv6_addr_map_del+0x6b/0x80 [mlxsw_spectrum]
...
Call Trace:
  <TASK>
  mlxsw_sp_port_fdb_tunnel_uc_op+0x6cf/0x7b0 [mlxsw_spectrum]
  mlxsw_sp_switchdev_vxlan_fdb_event_work+0x17c/0x420 [mlxsw_spectrum]
  ? finish_task_switch.isra.0+0x8c/0x290
  process_one_work+0x1cd/0x390
  worker_thread+0x48/0x3c0
  ? process_one_work+0x390/0x390
  kthread+0xe0/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

[2]:
WARNING: CPU: 0 PID: 239 at drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3035 mlxsw_sp_ipv6_addr_put+0x142/0x220 [mlxsw_spectrum]
...
Hardware name: Mellanox Technologies Ltd. Mellanox switch/Mellanox switch, BIOS 4.6.5 05/21/2015
Workqueue: mlxsw_core_ordered mlxsw_sp_switchdev_vxlan_fdb_event_work [mlxsw_spectrum]
RIP: 0010:mlxsw_sp_ipv6_addr_put+0x142/0x220 [mlxsw_spectrum]
...
Call Trace:
  <TASK>
  ? mlxsw_sp_port_fdb_tun_uc_op6_sfd_write+0x5c1/0x610 [mlxsw_spectrum]
  mlxsw_sp_port_fdb_tunnel_uc_op+0x6ec/0x7b0 [mlxsw_spectrum]
  mlxsw_sp_switchdev_vxlan_fdb_event_work+0x17c/0x420 [mlxsw_spectrum]
  ? finish_task_switch.isra.0+0x8c/0x290
  process_one_work+0x1cd/0x390
  worker_thread+0x48/0x3c0
  ? process_one_work+0x390/0x390
  kthread+0xe0/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

Fixes: 0860c7641634 ("mlxsw: spectrum_nve: Keep track of IPv6 addresses used by FDB entries")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index accea95cae5d..d88e62bc759f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3511,6 +3511,8 @@ mlxsw_sp_switchdev_vxlan_fdb_del(struct mlxsw_sp *mlxsw_sp,
 	u16 vid;
 
 	vxlan_fdb_info = &switchdev_work->vxlan_fdb_info;
+	if (!vxlan_fdb_info->offloaded)
+		return;
 
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)
-- 
2.35.3

