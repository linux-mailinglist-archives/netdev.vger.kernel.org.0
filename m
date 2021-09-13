Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4342E409827
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345159AbhIMP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:58:57 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:10104
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345685AbhIMP6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 11:58:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqByQ28Nq/k/Ulpsnbw4x3MJH1PTBsX/wY8Bia6wTMrEWUSbO1d0yoPKMVjf8LtLNpiWj2Z/OScoLt/xDZMbr3+26ROiHQUI3VX33qLpjpp5Xyla9DtylMvTDni037u8UwZ+nzFqD74AIXym9ADpisWJ60NrhesWOTLv+EY3iuiFAqRdKVqbcVW9VaT8Z1kK1eCMgKD+09eFbTQvnvCJQQiqCygbydcoMD0nJE3464omVxTyFvSzyk4xm1AhEc8NiHBvf+rgpbSM51/JMGpBjc2aHc8PoWPke86hRVtu0lJI+5YxwhqAiWkVJxtuwhXibENmkc2lFNsFuQinDooI/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3aiEYMmdOiE2275kc6q2PVZZcePHnZ1fmMvQ1IImPdM=;
 b=Y+oMrf2I+0PSVDm0jWgyh1E8fwdXXMAa+79q9Z0TEnAzYRs692iRugLSP/XrqWDJgHMyFoO/rtmogcq5tULSj8jn/3Y85pgoSmmB0Pj7X01FdYBe2ghpFqNN9An7Ds9Eyvg5kwSF5HucAM7WuJIZFobKM086JSUGLcbO/YvkAB/FR6k0z1g4x4TDPRLhgHvVUD7wJY79KPiHQ1FNEJ8M7vZutQyaUAhy3rb8jq6/K4rrv5gInw5oojJMq8NcpwkX+6Jsd8M5diHI5pmePOHVwtPzIJEm6/1c06bK9J2P4c0tF4R/HLa+mmuef9NQdDPOoA43t8MgqCWF/tMq0blySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aiEYMmdOiE2275kc6q2PVZZcePHnZ1fmMvQ1IImPdM=;
 b=NyXkLtYk+wi8POqgGnO86M2XqX3ZplXz6Mmlpzlv8aj4Eq0SMWG8dtptCC4HJhQTHZayqOzSPwlCnSqkXxT06opO11AFW3jFqVFzI0tvVCNGOAZ5bt4W3X/8F5YV1V6VnW83T2TUvyPwL3G9o6y5OWCsYXRskojsUMMEbmlpFlzmccpjNEc3Ut8bYgO28ekGKoDsQadzIj+46jE/M7tYSxtSTLy9ZrsTX+bpFAXJWlKf8axT7PsbE46bEM9oxXzSQwlVn1Kfj9tJVW3jadTnTssPcaky6gFFDds3tMYdxTX+zP5JMHeysMburOBWfwqTUHzluOunl3LbbZOSnU/1NA==
Received: from DM5PR07CA0100.namprd07.prod.outlook.com (2603:10b6:4:ae::29) by
 DM8PR12MB5447.namprd12.prod.outlook.com (2603:10b6:8:36::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Mon, 13 Sep 2021 15:57:20 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::c1) by DM5PR07CA0100.outlook.office365.com
 (2603:10b6:4:ae::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Mon, 13 Sep 2021 15:57:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:57:20 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 08:57:19 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Sep 2021 15:57:18 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v1] mlxbf_gige: clear valid_polarity upon open
Date:   Mon, 13 Sep 2021 11:57:11 -0400
Message-ID: <20210913155711.8732-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c52ab5b-8e78-4e0f-a920-08d976cf2b03
X-MS-TrafficTypeDiagnostic: DM8PR12MB5447:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5447614EC8B5148CA681CB41C7D99@DM8PR12MB5447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/G5Fp8gLV2HrdUZinwmvNWqqh/zPo1LyaiBh7NtYhqSQfHN6NpcuAEsiaEyQeY+JEFErgIWzwZau/N7b8mPLtrx4cQp4ml8FSg2lN4p765N2sk+Z0HaB6783kHOtnL6JtlykfQMsOoU1WusNBatLFLjnOurxzWni+X1QgfoTw6dGYoqod0ckR9JIW8AMxh7g/QcoSuf0ONbwgddngEh9h/lhj7A4523Y4FyhsZBAgu4yXX1bVgu2ejA9+sbBM5vd7mWONFBUupOJCiWr9AsU2xTAd4Tfj9Hj0/dU4jypgIAJyAa0nmhrtHfnPWrcEp850dmbzJns4BI134t/iA/3i6/ylonhDRvyk627jcsv/XwntIaWpU4IJScnSP6oArOVbMa3qz5j6hYRr3bQnLWKo/kQIzBqCn8HW9Pd1s9K6DAvI2UevpKkuJqwGM3FjW99UUzfT+eLyxl7/3fpSoqCz0f/jBNcf5jtoUmsL+s/uMs5TCD8cWxpz/romJjHy9eQ45w13xPx+pqcNwVgPUbkIDveMVPWaUtxz+WHZV009/fI8WHAj9opMM982eb6lWKCKhTa2KwLumgAVUGrj/Zx4tA5R6JRvBJ4S0hPlhMqcF8BbiXM7pC0KVY4YH5G2yB6uAq+EW5GpdJxpvMmGx9mAU3wqBnNmGsmJd6zd9PLots1aQN4XjLbYe60KwW+6nw3aB5VE+hlfWvp1ulaARGcg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(36840700001)(46966006)(86362001)(8676002)(7696005)(110136005)(36756003)(26005)(54906003)(186003)(107886003)(47076005)(316002)(82740400003)(36860700001)(70586007)(6666004)(82310400003)(70206006)(4326008)(426003)(7636003)(2616005)(1076003)(5660300002)(336012)(2906002)(478600001)(356005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:57:20.0534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c52ab5b-8e78-4e0f-a920-08d976cf2b03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5447
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch ensures that the driver's valid_polarity
is cleared during the open() method so that it always
matches the receive polarity used by hardware.

Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 3e85b17f5857..6704f5c1aa32 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -142,6 +142,13 @@ static int mlxbf_gige_open(struct net_device *netdev)
 	err = mlxbf_gige_clean_port(priv);
 	if (err)
 		goto free_irqs;
+
+	/* Clear driver's valid_polarity to match hardware,
+	 * since the above call to clean_port() resets the
+	 * receive polarity used by hardware.
+	 */
+	priv->valid_polarity = 0;
+
 	err = mlxbf_gige_rx_init(priv);
 	if (err)
 		goto free_irqs;
-- 
2.30.1

