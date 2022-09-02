Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC325AB6C2
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbiIBQm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiIBQm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:42:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3EFF7B1D
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 09:42:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPqk+3eeJOIxA/inWbYwxu5tzBefjBFUCzjCLUt6lvTfq6HXvpjnfslRqN+p9MdUy23PlaDevzgrZfq5vjbTxxz4UuZFaixPd4wmNFTzYQQoiBPtes6rI3PC+WF/e2RTj/rOshBbeFRiEzgHsvumQMM6Zxryp4jyXEQz1xmwCOp7ZpH+lE8fIdYndl/jyUuRGV9qnHVz7tPfwc/Bm1FSEWVEteqdpDW4nXX+XF4IXiJV/bLUoyS+dK4fDIpmsRj1f1QkiiIq4BwXpUXjaAP/+UJgfzK+pFXTc/9gfBdLG61VIh1TzZHRbxh62/FAVKOCmF9hZErKM8H+VO5IZKSqBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qGTbAzN9B173NMx4ou4vtuYP+OyF24xcphBlfjSgAE=;
 b=KU0zjPzS7/wLkWAzTPDurW8kWzG1IP/5aqn48rp/RDY417oyys5qMQ39y22QHcUaTAiwFFD6J6PZKg2kUslYhWUM6kOCYpjvAa7olceyQwJ1+iPOE8yYJQP5NRUjVb2Pf8BPPqNg5ksus7BveDVBNs4YqEUTE6ekwHFlibnMnHFGjWudyw4CEndc5dU/UKJzovDKMqVtJP61CPSGdz56F3P6deUb3FQcU1ZLSeG2PsQVMLdhWCfmbQKEdXoz5BCpCErW/75fO2HqWbU4cYQqHkx8OVWm0FvkdT9QVIFEF2LYjBbgL0rj/Fj1QG0q0Bz3BpDQeX4RUbfBK0w2ACcvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qGTbAzN9B173NMx4ou4vtuYP+OyF24xcphBlfjSgAE=;
 b=bCyfH7GXERFIQHWdmNWuqz92sntkXc3zvg8xCj1+bd7Svi8c+A0pAx3DcYdHHRMvK5qk6+QUPieMZ7qQWfO8FxLyIQLwIUmoFH7sXah1VOJyf+bdQuboMF16TiNMX+PVsW/wMSudzQt5qhDttND2zpajnfxbr+6xhGhmjEgGnTRbItyJAUNoYtHaHLZJSl3F82xpw3mn84wZQUC6+ZDrQW2UFHq/rabXD1Uag9ze5mWILpRAb0I290WKrIgOVVRwP8d1CSAwvzXwNHdYJ3o6A7s3IK6W+hrziwO29f3eCAnFvHjm0fnEp/7p9mHCg7lGsX7cC3372bqb9k8Kfr8vfQ==
Received: from MW4PR04CA0388.namprd04.prod.outlook.com (2603:10b6:303:81::33)
 by CH0PR12MB5217.namprd12.prod.outlook.com (2603:10b6:610:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 16:42:55 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::76) by MW4PR04CA0388.outlook.office365.com
 (2603:10b6:303:81::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Fri, 2 Sep 2022 16:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Fri, 2 Sep 2022 16:42:55 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Fri, 2 Sep 2022 16:42:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 2 Sep 2022 09:42:54 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Fri, 2 Sep 2022 09:42:53 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net v1] mlxbf_gige: clear MDIO gateway lock after read
Date:   Fri, 2 Sep 2022 12:42:47 -0400
Message-ID: <20220902164247.19862-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b9a5e64-72ba-406d-eeec-08da8d022faf
X-MS-TrafficTypeDiagnostic: CH0PR12MB5217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jV24nLIjGC33we2Pq5WVBSyy1u/9FRZTY2r6tOUwZIOhkw/nCVg37JXCkI3AtkVS1lFT0UmJEmqqf9tkmKKq8n/ngsIjVNwI9ZTlyqzIQOwviqwqcUWCW4mes8a8SN6DckNjqqT+bvYjih5dZyO+Fe70lPP1EgDqnYohV83ce7+b8Ls+KVQV5Z5h/Go+7/K27clWx+gGlt+fKQI/Mzzr0np25wKjG9QHQFDuFJKTJ33RSiDKQD/O/WdCZK0rii3VcN02zxJVko5nRtaeWd3hOjLMba3H5nW/DNBb/2cjCQ++Ed42Zoyfj9pwQj9One8IkLq+PPZOQ13EskhBXFnZ4DMSu5lfPmCv2bPId1DF/M0QzdLM+lpKfV1E2bJQtNQ++/RLWBw2oGqqDVYFQ+4jeoNv6OYcPm+PjqEZYuGhwikNG5PYfzMuVmslWBWxXS3fUvbtcAPzp7tGpez8LXb7U8Mml46ihKzKTQateHq/KCGbM9SjGQ7oCRdt0ZYYSY/6SqXqC+j4nKzw/laozsNds4O3bb0y/t0MbOqn8nkXxK3cidRPrJ5Tm6PtRFmpO1axBGW1gnX8WODwbU88TK3ms3CAXqawAzjlCm009s5BJDz8aFxbQiGUlK5Jyavz2pZWcTWl7MyqmVP7t7WXKvn5vL9DRBYmMDP4RPCdljYNrUDDLk633rHoXkuf2I1F7Sj22Dkmg4fYf3LOJmO8TkwiuEROJCnv0pqULippKYaM2Hd1k7WTV7dm5wkQRnO63QDyav5TqUGxOqEnQmoCN9FK4cahzwoexZDPVfbsVk5+KNPpEzjng9tZXVu9pMrCz16
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(40470700004)(46966006)(47076005)(1076003)(7696005)(426003)(26005)(186003)(336012)(2616005)(40480700001)(5660300002)(8936002)(86362001)(36756003)(478600001)(41300700001)(107886003)(6666004)(36860700001)(81166007)(83380400001)(356005)(70206006)(70586007)(8676002)(82310400005)(2906002)(54906003)(316002)(40460700003)(82740400003)(110136005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:42:55.4763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9a5e64-72ba-406d-eeec-08da8d022faf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5217
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO gateway (GW) lock in BlueField-2 GIGE logic is
set after read.  This patch adds logic to make sure the
lock is always cleared at the end of each MDIO transaction.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 85155cd9405c..4aeb927c3715 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -179,6 +179,9 @@ static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
 	/* Only return ad bits of the gw register */
 	ret &= MLXBF_GIGE_MDIO_GW_AD_MASK;
 
+	/* The MDIO lock is set on read. To release it, clear gw register */
+	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
 	return ret;
 }
 
@@ -203,6 +206,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK),
 					5, 1000000);
 
+	/* The MDIO lock is set on read. To release it, clear gw register */
+	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
 	return ret;
 }
 
-- 
2.30.1

