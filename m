Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D513D228A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhGVK0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:52 -0400
Received: from mail-dm6nam08on2066.outbound.protection.outlook.com ([40.107.102.66]:20160
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231853AbhGVK0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Odu3KXK+s7tNVZAcdY8JV+4fTbaC4Uc12lRetBSzxdv9VQYd3CshpmGz948XIns+tnxCOgEnd/KiHMkKuHWTL05RdCbdYozynAclnxpx7jG3c7FrJkEPYSeWRPt5ZRHMl1Nrf6SGq2us/PZB1V6A8dCrwjybXPMKwBkZXxtFzquibdhMV/389KP8Z1N24W/27a0XAqPi5DYfGU0VQgky0igPJDk5Y6BNt0NmHOJd5goUJmrLh13QPvCmyWyFJ8M1mvMYg5fd1w4PHBO0GRMBVVmSq0svvPO0iQGrHvlkL5qqnU/i5SH4v4ocVP4v/6T3zac/VrHEmKA7kn4gaQ8lkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm331QKlAmKTku+aZJp2m5o27Sbebm/ySHZoVcSOFyI=;
 b=VAMy2KTayxaC6R7G+EW33oXvAktP0P861ZPbNleCYbc3dMZy1gcyi4GuapQYTvjINKQodwdnhcg+5/Dc8YUJp6XYe+oviLsur3tOlIvCE5/mMM2Y5wU9PrgzDv3I6nm9In88gIKUkbOF0U+942aZ/kho0sniiQwPw9KF9JQCiCocT6lqjMaMZwVxIBX7vQ6+ubhlWBMHmhxfwc04k1BH0XV87EcoNHXcDz0GNhoXdu1Vf20GsJBEgpB5NMNh3axgqE6MRiwltuzPZPHEr3ivK4dEz8LoN6rC6wvDw+52E0Ey62YxJvtF9/c0Qw/c98VNukrijjJrWcbDkioUmFfkdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm331QKlAmKTku+aZJp2m5o27Sbebm/ySHZoVcSOFyI=;
 b=DqS6uRQgalx8192k1meAv6XfWHIUJygemhUmZwSsq3C0jCNieFOZNG7zIwb7z0KXG+H5hs22uMtc3DhRHxcxeOi2G7EUE2fKM6QyElEcew8C9jqVBpkfNl6ue5+P9mbupdOeuYE/H7TYYPJ78k/O1D4JquYiHRMqsvckVSQW+xI6S+WF2krvYB9S1LfgPFvYFHV90CIjtPcwHShk8pblYpm0ImtGt65OBuCunOZPN3lhr7iv5e0U30EZ5KTKhZQBGuJAxmy+tgPl9nLTf05V3ggi4Oph/Jv9a9Z3KTfvrdpgymbsUETemzntXCbBowsyzwvvmsWmN0LKuKU/EaEAmA==
Received: from DM6PR06CA0033.namprd06.prod.outlook.com (2603:10b6:5:120::46)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 11:07:16 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::a3) by DM6PR06CA0033.outlook.office365.com
 (2603:10b6:5:120::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:07:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:07:16 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:07:15 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:07:15 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:07:08 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 35/36] net/mlx5e: NVMEoTCP DDGST TX offload optimization
Date:   Thu, 22 Jul 2021 14:03:24 +0300
Message-ID: <20210722110325.371-36-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 371a4635-8d1e-4382-9a46-08d94d00dda6
X-MS-TrafficTypeDiagnostic: BY5PR12MB4148:
X-Microsoft-Antispam-PRVS: <BY5PR12MB414859F79C480616273300E6BDE49@BY5PR12MB4148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q8cR7d2DgHGos9DHKpWzPI46BSgnQcF6FD/CjbW/VW9rsPc1NrlMyS+C7g+CxRzCKjXkGXVj6VXeCGCoiGU+1ZWVRhP0jW77sXo/vQgAyRnZiWzWqgufLoyD4Ls8U53kkTsjeJ7OMhQ9vj3D3mv0la44UOxZ9due/7VKsBhbno14GqCQgX7X+qn8ve0yadOrJnczLrdsbAhlCOMPJeXTOi7rp2LwtG/Y3cq76pJu2TNTOFAKYwD0rKXM3oC7G30bcxEG1YbooEw/8ReBATBJOqh3MBMxszxJuqbQHimFCZJzyexnQPcy2ZyluCVZtFUH6qsHu+UdM1N2EFIgQcWgw8SQIT5acDjqspBhyU5fsEWFpgMVL6+abbHGNMKg6b3HoSpNv6scqpFPtnoVnA31vonZiizUz/TOa0uXlPw/D4StYtPNnNPzo0dnMGWvHCYuFkyO/4cQX7P/hVJehEK77uwDCvZfTigzj0q7QNIdECOKx4BfZI9BZxPW5Umgo04j02qKaxBDuLfQ9kFt9xE8/YyWXPwGzWq0ypOyKAxQhoX27I2Xfp5pcl29f51NNWtQXE3cTv9OjwrkbxB+yJ0aIvSM/W20RBq49MqEnVhHNycIZ0QNGNFWveE1I3k0pDMainZJmzAIPG9GyUuWuZTBzh4Cp3itjoQ5hbO68BQBXDrnP4ipRWUdHGqIadhaMjpfWqfgGfm2u1ZoVcgG21KTQQyw7o81NwwTBw/69htyxrc=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(26005)(4326008)(7696005)(107886003)(2906002)(110136005)(921005)(5660300002)(36860700001)(6666004)(7636003)(8676002)(7416002)(86362001)(70206006)(336012)(82310400003)(316002)(356005)(54906003)(8936002)(2616005)(70586007)(36906005)(47076005)(426003)(186003)(83380400001)(508600001)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:07:16.2248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 371a4635-8d1e-4382-9a46-08d94d00dda6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Stop offloading NVMEoTCP OOO packets which aren't contains the pdu DDGST field.

When the driver indicate an OOO NVMEoTCP packet he check if it contains
NVMEoTCP PDU DDGST field, if so he offloads it, otherwise he isn't.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index f8cba90679ea..f3ef92167e25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -1393,6 +1393,20 @@ bool mlx5e_nvmeotcp_resync_cap(struct mlx5e_nvmeotcp_queue *queue,
 	return false;
 }
 
+static
+bool mlx5e_nvmeotcp_check_if_need_offload(struct mlx5e_nvmeotcp_queue *queue,
+					  u32  end_seq, u32 start_seq)
+{
+	if (!queue->end_seq_hint)
+		return false;
+
+	/* check if skb end after pdu crc start */
+	if (before(queue->end_seq_hint, end_seq) || before(start_seq, queue->start_pdu_hint))
+		return false;
+
+	return true;
+}
+
 static enum mlx5e_nvmeotcp_resync_retval
 mlx5e_nvmeotcp_handle_ooo_skb(struct mlx5e_nvmeotcp_queue *queue,
 			      struct mlx5e_txqsq *sq, struct sk_buff *skb,
@@ -1400,12 +1414,21 @@ mlx5e_nvmeotcp_handle_ooo_skb(struct mlx5e_nvmeotcp_queue *queue,
 {
 	struct ulp_ddp_pdu_info *pdu_info = NULL;
 
+	if (mlx5e_nvmeotcp_check_if_need_offload(queue, seq + datalen, seq)) {
+		return MLX5E_NVMEOTCP_RESYNC_SKIP;
+
 	/* ask for pdu_info that includes the tcp_seq */
 	pdu_info = ulp_ddp_get_pdu_info(skb->sk, seq);
 
 	if (!pdu_info)
 		return MLX5E_NVMEOTCP_RESYNC_SKIP;
 
+	queue->end_seq_hint = pdu_info->end_seq - 4;
+	queue->start_pdu_hint = pdu_info->start_seq;
+	/* check if this packet contain crc - if so offload else no */
+	if (mlx5e_nvmeotcp_check_if_need_offload(queue, seq + datalen, seq)) {
+		return MLX5E_NVMEOTCP_RESYNC_SKIP;
+
 	/*update NIC about resync - he will rebuild parse machine
 	 *send psv with small fence
 	 */
-- 
2.24.1

