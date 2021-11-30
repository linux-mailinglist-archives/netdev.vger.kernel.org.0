Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3A946397A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244333AbhK3PNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:13:50 -0500
Received: from mail-dm3nam07on2089.outbound.protection.outlook.com ([40.107.95.89]:39597
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243997AbhK3PLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:11:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YolYduKFTSwI+tDSQvXxxP1o7odRJZGBe0KmxO9SYGJ4gk7cuhp+L7fruRhDORYUpNcuV7/SkrPX0fUTR78K4qSQxN7HpZf7ZNzwXED8LhXdi+PaNYX3Kje2WuC7ikPqx4uNqHmFOvXN2j/NvB/y5p3yIrkAJ34Gp55PxfrNl3yWeRh3I4aoyewE5lylxAakAkR/ywRk16VdSETD6g6yU6SWZBp1ls//p3z7afK//Lhcwu996yNX661Jugd3Ix9c4JcnNpLVr9W8rnlxRkHJc+umcGvdBs3nrZy0bGtgpbS4UIYPgIPz7jQEkh2CVSurhErrFFM3zaM3m4UL2AI7Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpoOUZLd3MTzPgbNV5LbehRqVMatRcpN5zB0BRUribs=;
 b=lO05LnITJnW3YKZiJeHQSkj6vF9wxn2O4D73Uudhx0m/QHLiswVs1eHPUgM/PgKnyppuHhc2LZdWcwj7O0vZbuvk4Iym8IjH3FYSLFOhMcPVxmD7VsFg/w0wUq5W7sOSkSmpK/6IRYevdmlFGXArFJhzDyJ3WR48fBHrrkTZeI2mGco3pA34eG6ebIHsDPIXuKFCWUQkKaLZ8oRtKwXlqicIbHjI59B62P6QAUlIatPBNAdbmd2LYJaF35Wn3BSOl0k1Q0LdKLFjTLY14Ou1A51oHj3O/lGdG3Z8Y2Yd6uzGsE0ENZMqpyVGt9Xe5rufJfZ1Ho3xSrFB8bLNLNVQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpoOUZLd3MTzPgbNV5LbehRqVMatRcpN5zB0BRUribs=;
 b=ief7T/NaDgVzfAk3oPiXP+U005XnJOyQ0Afc1H26za0Sf1Te7/Dqy4RvDLG4JCtwkpDEybEMvGJ+Vyxej/y7e6k6FqHO5OtjCRmxWdstqq/XAZDkvsvOulMEOT8JzT82fDpBEB9saJ+pG4SPWneTvc6Y9+kc23bIGhLGZYgrjLWv/PZlSYyJpGv7dgMHmA0h7bayvAWpMaZEj0UHt336RXeLjp9xI7MhTTpZAAx1pEuU/A32RYQny1B0BSM/hpuIWhw1QZrqZPHAAx06yuUqGgl55kDovVwnFtx/+N66Y/SXnI4QzF2YjKII4M+tYpS/dTaLA/D/JXaSskzVU06MTA==
Received: from BN6PR14CA0002.namprd14.prod.outlook.com (2603:10b6:404:79::12)
 by CY4PR12MB1559.namprd12.prod.outlook.com (2603:10b6:910:c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 15:08:18 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::eb) by BN6PR14CA0002.outlook.office365.com
 (2603:10b6:404:79::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Tue, 30 Nov 2021 15:08:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 15:08:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 07:08:09 -0800
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5;
 Tue, 30 Nov 2021 07:08:04 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 3/4] devlink: Clarifies max_macs generic devlink param
Date:   Tue, 30 Nov 2021 17:07:05 +0200
Message-ID: <20211130150705.19863-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211130150705.19863-1-shayd@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c29e0567-37e6-411a-6b41-08d9b4133d80
X-MS-TrafficTypeDiagnostic: CY4PR12MB1559:
X-Microsoft-Antispam-PRVS: <CY4PR12MB155989B85E8D06EAAD973C6DCF679@CY4PR12MB1559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: th1XSCkRbP71l+OLm9Xzb2yjL6S4xLQXTPz4pi/YGAKTr1WED7pAWcrDdN1/ifDXWfgb8sRdPGjM+ztYoJB3iQNqGZ/DaI7mHM2s9NMyLTluOnp2bpRY0yEeSgEhBOD9jq7LIVohjfwQcXmS+ThNHbkwBKdN/1GaEhWk5XgPlmdypHmO+dF02WgCP4N9UDtRlPySiFUggoenDYIhwM+CKcS0itzH87gH3km4VFbfJRbOAI9fPKxjy+lhlRFYOV5DTjLKSTgA9/kOQlEKlXIYH/tRCNuVcp6kOCNpGcOsFORm8T7vE8pf2tGkuKKWh5BhLn+Z/Tm7ryG+aIHjqRHfiC7RQNybVxUqc80kxEMEPExfGD1BL3x5Kl5V1vP64o6dTdNIjFe+3edIgmThp4erSMcbef/nyhnLxArxk18lm69WmO4WqQ55ownIf/1EDhSqnFs0vYngmXUKI+BBIAhnOJNIxpVHoW9nUHo1RrIyl9HSkduo2Ce5n/QNu310ZDsVbtFlsIS07wIarbdNMgFcNjablFaALo2uEjBHo/IQh6n0UZ2k7laItIGBm3j5zKZdRvbWysqdElCYiJBkPQAFGVQMWpFYkIFG3JFHmv49ZK47h1ZP+wh4uRpBvX5Y7sHoXsjKnPD8sfZFQkqLvWGTrE4v1MNqdRn0Rad7489WfvW3W4X1Tp5yOxt0ofhrqx/vvkakIpCLSQDRrMaNnZfWZbvyg4B6tpzs1t6pe9025VzEmJCTwzUgVil37hMUTzLi3CS2Cdc+Pk96BhAFOrhIPmhxR/okL0GwTkZ2D2CiPHE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(107886003)(316002)(8676002)(16526019)(36756003)(2616005)(5660300002)(4326008)(86362001)(336012)(1076003)(82310400004)(186003)(40460700001)(70206006)(83380400001)(356005)(7636003)(2906002)(110136005)(54906003)(47076005)(508600001)(26005)(8936002)(426003)(70586007)(36860700001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 15:08:17.7241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c29e0567-37e6-411a-6b41-08d9b4133d80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1559
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The generic param max_macs documentation isn't clear.
Replace it with a more descriptive documentation

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index b7dfe693a332..c2542dcf63c0 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -118,8 +118,10 @@ own name.
        errors.
    * - ``max_macs``
      - u32
-     - Specifies the maximum number of MAC addresses per ethernet port of
-       this device.
+     - Typically macvlan, vlan net devices mac are also programmed in their
+       parent netdevice's Function rx filter. This parameter limit the
+       maximum number of unicast mac address filters to receive traffic from
+       per ethernet port of this device.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
-- 
2.21.3

