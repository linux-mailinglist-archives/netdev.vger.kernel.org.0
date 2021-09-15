Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1DD40CC59
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhIOSKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 14:10:16 -0400
Received: from mail-bn8nam08on2080.outbound.protection.outlook.com ([40.107.100.80]:38720
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhIOSKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 14:10:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAFhYfI2ZO06fHhSR79IMJPyI3ms3sVqjEB5kWVsd2b9An4dh9/LXHEpe2RsNk64cZsmKfpHmyNeklqQ/KS2aw7Mlr6oje9id8m0q2MGWfTukzt6kCTYHCDXMwVD+rZtEOR5Qilr2ghkwMHO87/aJZLQayPZsGktM3++TQLh5Xhh78r2vldN9Lha2C+EvCrq88SDylLGEk+sXTNlCwVU2/DzwnE5qj28/0/Nq6rKyKDMFoEDRJu2X2RAdS5ourlMEXvYhG12W3sDk1UWEu4Pnnd36rLKh4ZXfAtfbOxcjAvKcGrpSygkRmZry3IFsFNc3StbNjN+wFLnKO+e1rOr5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JaZvy6kfioGOXBtAgeiFOpWEYoQWHldP5uMqbWbgmPI=;
 b=QXwvOecxC0O0SM6W6S4xYAFOQG+BIC7YQgKt3o4+2w/srymEb+tWbY+6Yvyj4Ud96AvwGVKbv8GppyqtmCtiG5Cplbz52ekbBO2CKIO3lcmYayngiq/DnV2vTtpSF6Mc5AP3wf+50UYxPCkNEX+Jf6+0mfRfaeMxG2avtTEQ/x4sv03Or0bVEICA31wNZm09dz9XYnqqWXJvvkZcLAADFXNKOvmtCOskFV6D0HRN4X2MqTaQjTMAlpEBSMyIMfI+t6ZiQ0ZW6iGCDfP6WF4jS2PHbJUJS9lXV6RkhgSJFWcb9znX+/vPyK0PBolFx0x0IVsro2fV7/NRrqGZMxlioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=arndb.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaZvy6kfioGOXBtAgeiFOpWEYoQWHldP5uMqbWbgmPI=;
 b=YBysDnnS0Ivtk/wClALodcg1Xkrq/v5TRav5elhK3+RVziklh2E64Yi4zuHXH+era5SRSg8dDIR6FKpxPxCCbkwI/yZ2E0AwrLQgRp3hAIFujks/QskbVQe+ezEXYpo9mK1RRaT0XN2tOvm3QjctYL8tL5QhfPo4YAFD/9zlTKcRcJMjy8YAs50vMnp1ZDyi2/6E6f2NS7X1blYQcKTO+uyu7dztN8f6J/UKxmStqxRSFMSaepW5f3/rndM+ZVBxDuu1tNz2aHFzaTlsIe8k7Q/pqgJvMQNmyMUN8dnB8UyLqkT4Pmz/JdXQ1PV3tpUAHgGorczZejEZT4Ze21flEw==
Received: from MW4PR04CA0127.namprd04.prod.outlook.com (2603:10b6:303:84::12)
 by DM6PR12MB3339.namprd12.prod.outlook.com (2603:10b6:5:119::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 18:08:54 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::b2) by MW4PR04CA0127.outlook.office365.com
 (2603:10b6:303:84::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Wed, 15 Sep 2021 18:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 18:08:54 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Sep
 2021 18:08:54 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Sep 2021 18:08:52 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <limings@nvidia.com>, <arnd@arndb.de>,
        <jgg@ziepe.ca>, <=caihuoqing@baidu.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net v2] mlxbf_gige: clear valid_polarity upon open
Date:   Wed, 15 Sep 2021 14:08:48 -0400
Message-ID: <20210915180848.32166-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9d71cf7-584f-46fb-1383-08d97873e14f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3339:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3339B54A38321969449C3DEAC7DB9@DM6PR12MB3339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W478cBQEMRG8HQ2IRoRrO6ozXMUYCvOUwXsklxU9aFP0RbcaJYlvKlMA8OruC+vTU9bjsAwaoidxRst7TTftSepVX+MpB45Wb8xNXidy9cI35w3qUhpTF99p+pxcs13nWhNnfl2yRkeSWSrRnrOnDBCUpdSN4txRcLUEcmHJiR4s+U0/MKd1kBmyBrY1LFIOyxyqLsB+9yZ+qjdIdVdfSuH1zM+bsQeHMfjSG73ILPEiR5FQEn+GG0J5Zg+9WAekaULEFqtxlP3L7eLT42fU6iFaVdyt4EcHE0ZwHmZbWcOiw9gljwx5bIJj+vCJaKwK3h6RWf5eNSrgmKSikdVJptvE183BD3RJcWmBUrDFiL/DMTP/b8SA6ptosd8109WokNpSGOIkQKygNV/t6jZPNGqEifp0Q+u4u0SGpS/dcHhSbuWfJZCkaUYE2Lvwl75Emdu9YFQtFRHLyp4oHl4X0OkRPuQQtnoO7fD8SIQWJt2NVpni9dZesOy0DYfB6G4wtd7G6Lwae69i3t2SjJC8MkcX0U6BJXaSWzEEMlQfwnDp20CmkKk2w/404XR+zkyI0Gu8plOTTGGJEAuNt7291KhGufhaDZfpORLOxn1xL9S1QWg+jHl+6Rz04Zr/Yhi8UKK3p5XdouIVS39FRuoV03XCaPBU3248i3/OndA3EvbzPcpelrOhbehF4vXiYZ+DTUZdQc/y4PvSYU+Ug/cK9A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(7696005)(36906005)(107886003)(83380400001)(70206006)(82310400003)(70586007)(316002)(86362001)(7636003)(6666004)(47076005)(1076003)(186003)(2906002)(2616005)(5660300002)(478600001)(26005)(8936002)(36756003)(8676002)(356005)(110136005)(54906003)(336012)(4326008)(426003)(36860700001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 18:08:54.5154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d71cf7-584f-46fb-1383-08d97873e14f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3339
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The network interface managed by the mlxbf_gige driver can
get into a problem state where traffic does not flow.
In this state, the interface will be up and enabled, but
will stop processing received packets.  This problem state
will happen if three specific conditions occur:
    1) driver has received more than (N * RxRingSize) packets but
       less than (N+1 * RxRingSize) packets, where N is an odd number
       Note: the command "ethtool -g <interface>" will display the
       current receive ring size, which currently defaults to 128
    2) the driver's interface was disabled via "ifconfig oob_net0 down"
       during the window described in #1.
    3) the driver's interface is re-enabled via "ifconfig oob_net0 up"

This patch ensures that the driver's "valid_polarity" field is
cleared during the open() method so that it always matches the
receive polarity used by hardware.  Without this fix, the driver
needs to be unloaded and reloaded to correct this problem state.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
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

