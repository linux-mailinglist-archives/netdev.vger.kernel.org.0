Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C5A6DBA4E
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjDHK6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 06:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjDHK6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 06:58:20 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5043EFAD
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:58:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FavVEYEWgDxpsivh2cxZ4wNSY8Rbibm4LNlErsoDii40wKRnKVjY/m7PFabCOM8axgg9gSlgYIIN7YPxUh7eN0f8MxGxHqy2gFYrZ0jgZ/f/0bxL9bDC95Cx8GgOaYrFyn/6Z59huIkSiK/rAtKnXom8ymIzCfHyXT5TOl+I07uxPbCdmpNgnkv8v8JNsd+uX4aazMxW6OdQKziwQv+SP3MZvpUq6uCTfHOXoJ5Rk5lgq2fyXMwfzlc7LDBDcRzm5Bdwn1whHDZi/6uKIxr0Y+QxBWMhMQ72aobG6XaDNTH/0dJm1poBdq4veFziBxo61+gcbR/kP1rfw8rMRA5UmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=cmcuuytR6vQX9PyJWoeTzxYDQ6k+QDn7/4SOBzM/7X/5TsS/i3Nebz1eG3gwJUFEFzJnDHI0pYiRnf9WXMvt+frW9InRJKKWAhKuZIwjsup/Qw4Bn/wabodDinET3ysW6Rhzl82nSU7kSwhgE432SLBCn9D6BusIzkQBx+Snk5Zb6kFU+6X08jVFTPaYzS9zOSzaACaTugFsjPcEZJKysytPVn7FQcfgyK1hr5k6cHfCHxNcH4Th5OvftqvgicuhB6ChRjdlL0csQdSNVPWhY+4rXFgp3QtbPHNTanpCVgyu5vzdN3xSQKhMNN3O+ldf/DWsuMTBZME5q9pWdgmxRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=RR6nODOH/dgOe6SbeTSnR1YnXGQypPuNRQ5pRDp/z2hezQdOxHidEv/QhzI2SUIbj+gx8xUpCQc1RI8xU7CZDbrGCr3x0dHydA6GsD/PThqZZDlvI6FP95oiCdNr6di7kRuic2QNV6QHQMt8OC/NOEaJA2mHnfWB0JkzA5tkwjXxyIvyVy8Nq/cjTqqjNf/NCy8d7aHXCCcHQuVM8C+QGM2qQIqHYWppRph+L//WpgKK/IdAJTpHA89aerbTKO3DCSo8totmhzlN9mltdpohTl+QWAzIJwu4nxMHxCKNpPi9za532bvJps7xFz9zdHl8jM3sdgeft6B6Q4v7sxqInw==
Received: from DS7PR05CA0015.namprd05.prod.outlook.com (2603:10b6:5:3b9::20)
 by SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Sat, 8 Apr
 2023 10:58:05 +0000
Received: from DS1PEPF0000B078.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::b1) by DS7PR05CA0015.outlook.office365.com
 (2603:10b6:5:3b9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.21 via Frontend
 Transport; Sat, 8 Apr 2023 10:58:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000B078.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Sat, 8 Apr 2023 10:58:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sat, 8 Apr 2023
 03:57:51 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sat, 8 Apr 2023 03:57:50 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Sat, 8 Apr
 2023 03:57:48 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 4/5] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Sat, 8 Apr 2023 13:57:34 +0300
Message-ID: <20230408105735.22935-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230408105735.22935-1-ehakim@nvidia.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B078:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: fd3ec76e-e19f-42f3-adc1-08db38202138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VnfG7fjXz/Iw0NKn6aJzQZy4I3+eJ7WxOwTIpB3IJ/mvtf3GpaKOHbVwuehfatNlos5VcLJ0IoNW4NqWZRklFR3dUm2r9S6wLBsgkDfo0fglHI6oAYJ1spt7uzQm3EAn0zrXWBW+HQuwbj6Z/UevRIihZt52pa42YRUY5jmDbZwSJUmf3CTlS7cYhZj4Skw+lSdRgURkOuJ2qHw6cjkY5YjyYDvruEAXM7GZYWKkgbiMqn7cCvymD8AarLT9kCiU3jF/chpk5uGIXaz3nY6fP1sFaL3SCzuumt5zeneRP6i9OrfcRC24+Ppiv/7fe7k21x7OoUAQLAEKzsRwNh6zYhNB50+iDZwKQaX20zmzyoKw0Mvq1ujKdwWI2Gm2JQNZc53hKuC7wRCt6P99MWsfFhfsZFXiNmz/FAGqyxqVuJIeXzh8DJKhg5i7QNiDrjDbWqyYx4bKS/o6PagK63V0ZNiT/zl6eCmJBhRcsIbZrMlL5CebWujnv0tMv4D1tEs1jL4Xk3kze0O1wWNEzwZx8PC00T5aZH6xK/g1slGDE7j84FZl+Fuh9wRx6dK/Sd46CGUlQnU2AqpR6SgGm6ihVr+RAwH4yCfTxQzD/rNgZIWgq1bAV6I8jsgyk3uNkslqWgfm5S63Gv6LS9wrki3RZdMzq9nFw/A5R55vxfqauPXgWidG4UqryVMRb2prQX9JSV04hKSgLd6oH3sakvc04LXcnKN5cEd3bRl2PLlArzFshkuM1PpGCTVscHc1wurA
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(336012)(426003)(5660300002)(41300700001)(40480700001)(8676002)(36756003)(8936002)(6666004)(70586007)(70206006)(316002)(478600001)(40460700003)(54906003)(4326008)(7696005)(2616005)(82740400003)(83380400001)(1076003)(107886003)(356005)(26005)(7636003)(47076005)(86362001)(82310400005)(110136005)(36860700001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 10:58:04.9122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3ec76e-e19f-42f3-adc1-08db38202138
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B078.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading MACsec when its configured over VLAN with current MACsec
TX steering rules will wrongly insert MACsec sec tag after inserting
the VLAN header leading to a ETHERNET | SECTAG | VLAN packet when
ETHERNET | VLAN | SECTAG is configured.

The above issue is due to adding the SECTAG by HW which is a later
stage compared to the VLAN header insertion stage.

Detect such a case and adjust TX steering rules to insert the
SECTAG in the correct place by using reformat_param_0 field in
the packet reformat to indicate the offset of SECTAG from end of
the MAC header to account for VLANs in granularity of 4Bytes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c   | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 9173b67becef..7fc901a6ec5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -4,6 +4,7 @@
 #include <net/macsec.h>
 #include <linux/netdevice.h>
 #include <linux/mlx5/qp.h>
+#include <linux/if_vlan.h>
 #include "fs_core.h"
 #include "en/fs.h"
 #include "en_accel/macsec_fs.h"
@@ -508,6 +509,8 @@ static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+#define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
+
 static union mlx5e_macsec_rule *
 macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		      const struct macsec_context *macsec_ctx,
@@ -553,6 +556,10 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	reformat_params.type = MLX5_REFORMAT_TYPE_ADD_MACSEC;
 	reformat_params.size = reformat_size;
 	reformat_params.data = reformatbf;
+
+	if (is_vlan_dev(macsec_ctx->netdev))
+		reformat_params.param_0 = MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES;
+
 	flow_act.pkt_reformat = mlx5_packet_reformat_alloc(macsec_fs->mdev,
 							   &reformat_params,
 							   MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
-- 
2.21.3

