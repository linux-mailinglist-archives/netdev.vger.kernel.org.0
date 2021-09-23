Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789F341587A
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 08:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbhIWGxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 02:53:40 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:49127
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239334AbhIWGxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 02:53:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+SFYbN3oPmvIzppUL65j7PD1DjfHN81NaM1EN8SKbiCNGkoyMz9hCNeaLB5UXhN/OPFkmXptjqVqyKUjIPta3/w3+7pYdM9QsEJt0HtorLiWyRiquv37O0xmDP/e3v8yQSRfljMxyO8baQ1lN3HGUH/O/ZWh+juGVl1Y7RgWjVN/FVnlDxYcZm82+1GTPbbmRDPQREMrihH5bdCuxW2hT33vmzy9khZQ14tkD+z8PP3XvmtWDo/dmC4jwqT67lbSrHgZStTNFYhKYtLExhnveV9jCJZ4NpzJPF4NlUdf+xkhAv5+3ReC99/f3GZYmhVVejn6JUFBglH41D2me/2zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=89SNLjOD2d4fsZqiMzaoEClJEdGXIglCYijiYCJb3L8=;
 b=oRd+WryGI1/zWjSvPbkxcKthaqNeIss6JajEIhM5o9z2p3O0ih3YvTBtisYPreN2z3D4qQrwTVdplVPxwZ2JQHJY1+SMi2WhpZSuvmgv+oG94w1OygznWV49/0JBSK/AlzoOZwnllhBiFo72eZXBkNPfzane1ZWQT4REBADOM7CAubiQ8cNTLFG57zJw7he9sp0QH91YLQdk3TXgPX1SopDtO4ElexoUf3gpi3+OQy77HZxQVZVpITK4iHwgPjMDqOfxCN3DiVwY5wdaRplL0dE3hGQM2bO/OYJ69a9whaY2YrnFbnXgaZK7Gbqym3q7mKSj83ciR8T0H5BW10FK6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89SNLjOD2d4fsZqiMzaoEClJEdGXIglCYijiYCJb3L8=;
 b=Gomi56Pr82nTEVkpk91QhO8fQqtG+HdreI+F6EMl8Ih4jBOvBXfUCJXXHtsBfkP3rVJaHhqCFQsrkvnSkD+6jTbV2t4TqL+joiOBSGuL1A18rnaNekG9vy6XI6TjpAlM7ak3zdlKRdJXPYPKQmScwTZeIiy2gQXD8X6I/pUpUDKcMfH439EZbcZxtjrDaGlgww2OD/j+NYszYJIM8M9mNc0g/6JPPuYbBtAHwqwAqCRtq/fdfWpK8YSq6o/wuIFUBf1zRaY3vqrYHDQxwOxAu+VelU9juNyZ1R29nhp590DIeOwXL0oQeQw6wjQG4jBPzaEjgz5xWFCXZ12MC/BrhQ==
Received: from BN0PR04CA0156.namprd04.prod.outlook.com (2603:10b6:408:eb::11)
 by BN8PR12MB3572.namprd12.prod.outlook.com (2603:10b6:408:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 06:52:05 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::ac) by BN0PR04CA0156.outlook.office365.com
 (2603:10b6:408:eb::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Thu, 23 Sep 2021 06:52:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 06:52:05 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 06:52:03 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Sep 2021 06:52:01 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        "Moshe Shemesh" <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx4_en: Don't allow aRFS for encapsulated packets
Date:   Thu, 23 Sep 2021 09:51:45 +0300
Message-ID: <20210923065145.27583-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a632560f-c5f0-40a8-da42-08d97e5ea7c9
X-MS-TrafficTypeDiagnostic: BN8PR12MB3572:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3572C9F9809B1205360C699DA3A39@BN8PR12MB3572.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ukwdKamz8+OXMJDs/64V8B5qae+OKb8zaB5L59xpfm5IquZfmqicSpnz4+ikaq/H3VyBn+LsDGbQP8iVlgCASUQHJp5Aq8YAzNiwuRIDmjTNNICbBU9RCCqE1ai7TsvQ6+2MTDl6NXjquDTlpsnOHb8RRYTTZk/xlBKN+ceziruxLXaAUkPizt4HbeeEyD/pWprb5zvHuAJkGbOWksLoEBPQUSDCXQnrJvGZDMhigE0LRoYPTw/1x7h75VQK3PnylOez2Z7Rzn3tm7RihqSfdspwfEOYecy0QN29+4zeQatcfdlEnb+EU5mqIOjAC8HluQ9/kczlNGv25KeZz8HQAdiJIO9ZNZy4wzO0UPFXfQaQiLplFQCJgFuKqDwULjNe/LhmeKQyghpVmhhjz3wGxdQEvPs0bKKpimRz8ms+emik/+scJxCAvanTKZPEvBqBh3dgALHbxcWWLCHp8XKx3dVACGdh0Ro8zfEm6enIaB2H+LhBhWrRMa8+eIPu9Ot9nzolxbABNYLeYzr9wFiqwEwMSzEpJFH5l+NHss5v197qX50CqbNjZA6li5p/Ykps72O9PmWaGtfUTqn+0kpBbvebPohUpLKiEtRL7Rwmv60bXtAr7kIDMxoF96HvXd1FwH8nQ4ii7fVR3I3OjdX1WPCc7v9CxXN/0vv4lXodiIz6zBDLRa9CDYGOtVR/mpGYyu9PkGfqL+rB2LaUBNg+zA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(508600001)(426003)(8676002)(4326008)(82310400003)(4744005)(2616005)(107886003)(70586007)(36756003)(2906002)(6666004)(5660300002)(47076005)(26005)(36860700001)(7636003)(7696005)(8936002)(1076003)(316002)(70206006)(336012)(36906005)(86362001)(356005)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 06:52:05.4966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a632560f-c5f0-40a8-da42-08d97e5ea7c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3572
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Driver doesn't support aRFS for encapsulated packets, return early error
in such a case.

Fixes: 1eb8c695bda9 ("net/mlx4_en: Add accelerated RFS support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

Hi,
Please queue to -stable.

Regards,
Tariq

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 35154635ec3a..8af7f2827322 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -372,6 +372,9 @@ mlx4_en_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	int nhoff = skb_network_offset(skb);
 	int ret = 0;
 
+	if (skb->encapsulation)
+		return -EPROTONOSUPPORT;
+
 	if (skb->protocol != htons(ETH_P_IP))
 		return -EPROTONOSUPPORT;
 
-- 
2.21.0

