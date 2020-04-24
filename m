Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437971B7F45
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgDXTqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:09 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729175AbgDXTqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5YHnfyVv7E14puQ/pJLHmqeL/WfXuHtgo1pFs36mCqY35NL2lSvVnPIkagdfHVj3UGo5ry3Zpk2SVBpGP3w5Awmq+h8Wf13wGmc0VeQfiT5KLZA2eXKSfhwdo0O/9YuWsSrRowQxIMLBRzhw45lQO/SmSItY6CF/4IsbXdcgoA7HOlrgbTTkKKSXK09DSqE0rIIRS4Q+9wFEgFrsG3wK3u4wPCISthkAfIxZRQWSaU1IYAk7IPYRwurlivpum8l9XIUnL8ta1fVRtq/KHIDtwfjfnLEfg+GU7yqHpLtlSZyJkENJ7Knroq9gX6DRywBnsDzgybEXLh9sv9NYg9miA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5xRLFA1Tle0XqLn/wfcUDVCWJTjiLV5LVbyE3WW3F0=;
 b=R+2LWBwkSVTSZf6sBrMo/mxm+DyfHepZ6Jhg0vZyPUTmqC4RPAI8spRDGFMWRAaxhIA8/2ywpD5rS3/YHzNt7UlrZEiFPYwDVBgV7k+oTx36po2uxPi8XaH4JySO1yl2cHisciohyUxBViUpIQUmdfG/ExmKsFBcvYXVs62VeqTSj90NFrNbe49t6rLjysJt5r9Ig2VBB6o3K9Pa6ad2pESy3b+4tYAjPu9gD6cR8S/nl2XPGjpV+BEERkd1fIVCqzuEpYAZ6vRgKulK0+6l8B8Ln0EOEjmyTZb2TVJuhX5P1sQn0yQWyz3JNQIr5kgENms2EFAovtSVRv0R2gOdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5xRLFA1Tle0XqLn/wfcUDVCWJTjiLV5LVbyE3WW3F0=;
 b=BerH3Qg9YOEo9QlRTyeWZPkc7YkHN0kxVyTKLSz3ktXObv1PMvqElR9+J8mTJ4U3b19J4r9I04+Mj5LeXGN0OBJL/9tCAInp2xx6P6QcW3AwXbk6PPUd1WV9kFhfYfR0KxmIX/RPUbM41125tCOPzt9S2UX7mvJFW12aPc0KFiI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 5/9] net/mlx5: Add structure layout and defines for MFRL register
Date:   Fri, 24 Apr 2020 12:45:06 -0700
Message-Id: <20200424194510.11221-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:44 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fecf1454-f203-44eb-56f0-08d7e88814b9
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB507234A50EB9D02609111E96BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LD01Hx++sexolPrX7qZJ199xqKpIp0GHcDYinorsbZfsia1isOBLdT+izz/v2QrtuNfFkfx8rQ3wKQaDizIqlC7VAu6VamxsSye7tlVT8CwKF+3mCOs4E7XoHGaGA46AIu6PRImhl1CNnE5uNlvWc2Fm0VO4bIiLiXn3jJFp3TnkxHQcUPPA6D1acSKGz1MDEZO75vj9Yv6quL7FNeRiPd1hmaWSKIEcchm5+YkwSzOoehogSji7VA+tMDd5BsvsVthzf4lkgtZjUYDzru2Z46fJ778mXBkkwH95Qqc+6fqwRNuoQ2A7ZmPCZQnLUzTo3hio6c8vp2KM8OJ8cQozuPovHzO1BruykMINKsoTD12es95jD3Lny9C4X+/J98ROgKJ8akxEtH2Oro+AryMdQBBk/81cLTohZW5sj8v6rcEr7nLdC5UUq1VufQGB4xismjqP8cvvSacFv8IL9aoG5J0KUY9DKMEaBwuli555z78xQu7DgqSRO80L8NQGabcV
X-MS-Exchange-AntiSpam-MessageData: qZeNH+pEzzY3rFTZTIwSRmRZbTXycydaDhQxn8unK1fwpu+80ku/l2VmlSzGR+LBc6J3ar690VI+At1HIPCXNWhmksJ/s3LgPS9gmkV+c9gyG9IBBihEL5rk/Q7278hi0JvQiPwD0YmKKSsghfv+QA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fecf1454-f203-44eb-56f0-08d7e88814b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:46.3907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmHIcjEWx7/Ae0tZCpzUlc2yY8R8nLPRQFGowvq69fU+YaKz3W8QEpHwieeLAeFmo4+cC2VnWsOMBhC7ZotS9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Add needed structure layouts and defines for MFRL (Management Firmware
Reset Level) register. This structure will be used for the firmware
upgrade and reset flow in the downstream patches.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b46537a81703..d82dbbab8179 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -130,6 +130,7 @@ enum {
 	MLX5_REG_NODE_DESC	 = 0x6001,
 	MLX5_REG_HOST_ENDIANNESS = 0x7004,
 	MLX5_REG_MCIA		 = 0x9014,
+	MLX5_REG_MFRL		 = 0x9028,
 	MLX5_REG_MLCR		 = 0x902b,
 	MLX5_REG_MTRC_CAP	 = 0x9040,
 	MLX5_REG_MTRC_CONF	 = 0x9041,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index cf971d341189..9e6a3cec1e32 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9703,6 +9703,29 @@ struct mlx5_ifc_mcda_reg_bits {
 	u8         data[0][0x20];
 };
 
+enum {
+	MLX5_MFRL_REG_RESET_TYPE_FULL_CHIP = BIT(0),
+	MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE = BIT(1),
+};
+
+enum {
+	MLX5_MFRL_REG_RESET_LEVEL0 = BIT(0),
+	MLX5_MFRL_REG_RESET_LEVEL3 = BIT(3),
+	MLX5_MFRL_REG_RESET_LEVEL6 = BIT(6),
+};
+
+struct mlx5_ifc_mfrl_reg_bits {
+	u8         reserved_at_0[0x20];
+
+	u8         reserved_at_20[0x2];
+	u8         pci_sync_for_fw_update_start[0x1];
+	u8         pci_sync_for_fw_update_resp[0x2];
+	u8         rst_type_sel[0x3];
+	u8         reserved_at_28[0x8];
+	u8         reset_type[0x8];
+	u8         reset_level[0x8];
+};
+
 struct mlx5_ifc_mirc_reg_bits {
 	u8         reserved_at_0[0x18];
 	u8         status_code[0x8];
@@ -9766,6 +9789,7 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_mcc_reg_bits mcc_reg;
 	struct mlx5_ifc_mcda_reg_bits mcda_reg;
 	struct mlx5_ifc_mirc_reg_bits mirc_reg;
+	struct mlx5_ifc_mfrl_reg_bits mfrl_reg;
 	u8         reserved_at_0[0x60e0];
 };
 
-- 
2.25.3

