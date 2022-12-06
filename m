Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CC1644C08
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLFSwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLFSwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:52:02 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187D23D902
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:51:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVYZUInk70y3QK0PhhAWp2dwMNZXe+t7Xd+plYZ6kiGdu2+KwvwzOqo4gCLWUO5wEP4CseXtCf9Ce7mXPWLpC7hbLUHFFMhyaivjWtg0I2THH59RI3Qe2OvzRGR03my18PU2+fJXBvznM6G7pgwYDjCJC/AV/b1XQXtOq/cFSWYtVqeTwRR+uVKOOz9bGcMv4wSjohobcOyl6mWHTXGCbbUhxh2thIClKTnuzse0unJAVjHif0wNRnPMNZJ/T/KE2xmvZ/cZwVyuOAGNLaeUcU1A8oySN6s5kAPRCIUpHqVMnIu18vBrUkCEJYI7wyLoC/F44fSBnWAV3sG3ZZsjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTny/6TSqOFfO8nfwISfiiAAkcHEXJpf2tH80vHe5Fw=;
 b=dgKu1zwvX/S1CEuJXhTCqjZnl8hX43S+2ny9wxgWJxsOk3lYrUQ4RKIhhMKuRviLdi+qbQdNUXFCYzwg9Peclb7aagoEThErQCIsTJkMlOxVKZgFHeCLr3+nvgzK4KzxiOyrH1XCMGOAUrRS14iswMItc8soe6XomT7lBCAWm0tkx1Z/N4r1d3N//+/vEAa731feFSSxGz1GSyNvZsyfZGRlP8RZtbbtCzQYcHV6NZjhY68/wP6Trj9YlAz2xHwzvPD1o34fPVLcEae1jPPWa1AJzmUB4trhYXloc8MG3gJHdx/fcaXB/9K/M1eOBqorPhAH2jKp2gBzhVZbBYRqeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTny/6TSqOFfO8nfwISfiiAAkcHEXJpf2tH80vHe5Fw=;
 b=GW/xvObYY1wPiQXP71J623M3sdh6tE5KvoIBesIcHtTG8uU530/lsjNr24RWiYwoUkUUs+iDsbJq9geC9juW90jqH8cBaO/pVHmB+NlFAZCJINKgXUNuc0Sql+B1dZx5XS8OmBE3hLBfJrw3Yk8IAOO6sA2qYdPBctOyKqNY5C+73GjXG9GnCXF8kUI0s6dQJaPK6SllvKWNMGrGPUQ+dcJY7tJ9EySGp2+Q91rMRrnml6TcehOKGFK/YQG2UrM1He23HPDNC+7qGF6pfO/WSKWirV6DWtLVWpB6tYSi/CyOwLYo8xU/YLuWIyBCX0/2CE3lAaAHWUA8FKdnhF+bFQ==
Received: from BN8PR12CA0009.namprd12.prod.outlook.com (2603:10b6:408:60::22)
 by SJ1PR12MB6291.namprd12.prod.outlook.com (2603:10b6:a03:456::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:51:57 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::e9) by BN8PR12CA0009.outlook.office365.com
 (2603:10b6:408:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 18:51:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 18:51:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:33 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:30 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V4 1/8] net/mlx5: Introduce IFC bits for migratable
Date:   Tue, 6 Dec 2022 20:51:12 +0200
Message-ID: <20221206185119.380138-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
References: <20221206185119.380138-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT025:EE_|SJ1PR12MB6291:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0e3a5f-ba51-461d-5ed3-08dad7baf2c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ALvhjv/IvfRDqXoefz1cgIOVOwpzez+OZvfnL1dnYhfHqWzaQ9jzbeG9tCePf35K6b+eOr+J8fgZt5EGMLfdOztVurq0YqtG4cj1XdC3xzF2IMscvyBb/gfxj74nEO91KyfRvbq9zVcunoK3uXmKlJWf9TsDNd6PqR/4Ue86yvjvS/MhPicM8Ko0ueEn75cWJIe7rA9viGa/AGok//nMPly+S5qJqfXwuT1x22ZWJQhKNxReE8uBHJXZ+fnsXXHggurXdE1i/BdKs1w6hKJDmfK64xdWXeQGI9EgJFHLj6FXHg0aDpvdHLpVWBTZBoiMng6GhYLnYvVAXXSVzV6wjyd1QwcDZ5gyRaV6LsFK9CA5F9ruAmTDvBaZEoRvd4kpzIJvjC1j8uPyD61VZ9B60UJMoCbl9qyPb32F6FzCA6Un3RYIky81fGKLPhn9QTSnv34HviVnlS1RN74CgS/e6i6JonCrgr3+W4I+Q+Rd24hYqDw7p6/gLwr6FKj+yokdiJudlrpu4nKrbkzLpR3epEyEusJPkKmlpzqsXBzVQQRk6Q5yGtJ+DVQhYv3oTLbjxqm0BJAcvjNYClqdEbFstITPht3ROJyDZKyi6ItD0XFcJ2w0EC+3NdX1a4ZHEVEda+vnyJTpQLbGTiyBWbSvZV7PBjOAtPE886WE0+e2duVKIFgXsMwC+1apO0xEnZd3IWYiRRyOjDu1fEEAD4hBQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(478600001)(16526019)(107886003)(47076005)(316002)(82740400003)(2906002)(41300700001)(26005)(6666004)(186003)(110136005)(82310400005)(86362001)(40460700003)(336012)(54906003)(36756003)(40480700001)(426003)(36860700001)(70586007)(70206006)(5660300002)(2616005)(8936002)(356005)(7636003)(1076003)(4326008)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:51:56.1094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0e3a5f-ba51-461d-5ed3-08dad7baf2c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6291
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Introduce IFC related capabilities to enable setting VF to be able to
perform live migration. e.g.: to be migratable.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..2093131483c7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -68,6 +68,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
+	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE2       = 0x20,
 	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
 };
 
@@ -1875,7 +1876,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 };
 
 struct mlx5_ifc_cmd_hca_cap_2_bits {
-	u8	   reserved_at_0[0xa0];
+	u8	   reserved_at_0[0x80];
+
+	u8         migratable[0x1];
+	u8         reserved_at_81[0x1f];
 
 	u8	   max_reformat_insert_size[0x8];
 	u8	   max_reformat_insert_offset[0x8];
-- 
2.38.1

