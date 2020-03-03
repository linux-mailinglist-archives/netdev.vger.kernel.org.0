Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B526176931
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCCAPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:15:52 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:56068
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgCCAPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 19:15:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6QbBFFsdVgCAQgRKkEpn7JSWd/IYeEnyC3pxZH7mhMYSVg0nuQCLb1aFaQYD2GKKaJNMK6JZkEFtn0Sob1vggzTqMUYATktuFY+fQk3lE+8JbuEYJZkmhy1W35tKmBQYHtTArZ36ysvthb5WRctVn2C94li+mP2qRNo7E9CbZBWW4wRIVN8mMOkuU5SzB0J/qPPkNPbf9sYS9eMnFcZpplHGogvf1JzJ+YGkz79aYL26ztGLYkPx2CTl0ptWPdjl3jucdgK6eU4YDTQ34zjClcwB9e/rOhJImBhz6PPJnmyrhfNhYtnrZbX0UODqebr/eomf9XlxnJc/bXgyqxUJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXbZ2ILvX87fAESdFMFuWrlLSuClmph+JzTBHD+Qa3k=;
 b=nzekEHTfrnnNl/NBY4TDOKk4AWanIxRnx8ySdfFnaGJWCtTf6w1krJ49NN0yI4lVvWctegXXDdcgxSdJnpZgr7AWSCWzkNWgiMgTqh3ltRo1Pe7rgQujRURWeLtJ8jITt3Pu/aaxOdMrNbh4EBY6dI2QfpuKGKGRvmM8s9tZ3NJ1T4DoaXkhw1c14g3BMmdk9fAfzjPC0Zu5MfrSNiatix+Ye2r2cEzlZ9uW0YyOUDzy70FwjruhKQ770jSScwjxjqxrBlgmSRpJtYpkMPmCDGaFAmuBnB3OV6aCtkYfbV0+oC+QFlKqorYLAy51o1K08EZNK/FuAgvDm6aPOoIAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXbZ2ILvX87fAESdFMFuWrlLSuClmph+JzTBHD+Qa3k=;
 b=lYpmYbl3En6vOZ5LvXQYOmzP9QqIV2Ev5Ms4DNYVBWOchxRuphO42gq8UWI7w5/wg/u8SBZHDJeagz4+FJkIypzROg3GzBXvtdViE7LOlLeNqGSks8U2WG6NXm5vDQVJBctYOVK/vWyrSZtPw0Oes7zJa8ujMBuAFueE3Dgg9No=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3166.eurprd05.prod.outlook.com (10.170.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 00:15:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 00:15:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 2/4] net/mlx5: Introduce TLS and IPSec objects enums
Date:   Mon,  2 Mar 2020 16:15:20 -0800
Message-Id: <20200303001522.54067-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303001522.54067-1-saeedm@mellanox.com>
References: <20200303001522.54067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Tue, 3 Mar 2020 00:15:44 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 65f117f2-91de-4948-a9a9-08d7bf080496
X-MS-TrafficTypeDiagnostic: VI1PR05MB3166:|VI1PR05MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3166E713690761A89C06BD3CBEE40@VI1PR05MB3166.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(110136005)(316002)(52116002)(6512007)(6506007)(8936002)(6666004)(6486002)(36756003)(86362001)(81156014)(81166006)(8676002)(1076003)(2616005)(16526019)(4326008)(450100002)(5660300002)(2906002)(186003)(956004)(478600001)(26005)(66476007)(66946007)(66556008)(7049001)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3166;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKTBbSrAwqHL1ORXgNw1xPKLm+QlM9OOYnpxZXb5JhdFCqMqDRv3NbaZW8DqwTV1VQqX2uMNAxVu9CQTREvM69AIWEqnZXzHyLGufx2dr8r1J7ZgKh1J1nk6Ff4iDFkCdg5ZkmRW/hxHqF9MyrE2oq81/2N+bexE8IQjfm0bU96xUKN0JxisrH+4M/rVSpWezQoZmVKZphrYDuGLLJ84Fnuz9ePN6FKob7hLXNhyb1ZhW0ayWVzPU/BP7QbWLhzRmWZppgsF5S1rU9GB+IR7DDs0OSrJ7SajLLqC8XK4viJ0TWrgEC2bb/tm9wTLf5Yiep2c6insHTq2aNToKhrBTaMk6Wr3BQjj5fx6ezJxzXik3ry7TBxKDx3cHQdnLGbnGq6eaWOUXXPHR9smh1Q2d3Px7orWkLyC7M2qW9jfFItKNellx6OW7+agI5Ds2BVyYCAGQacASytvLyZ9LBSfNhOlttbcUWkd0urCpe41iJlMBnJpVzsm3SRWJkFT7PYNGo8x9oCpUE29+y/+kJ8S20wErYNMVOGAtjKV1zW1qxE=
X-MS-Exchange-AntiSpam-MessageData: 9J0ZkSP9I9duvfa0YUJvMq0I4dni4+4Lamb3ATzrixXDOsHdX4QGMK3tKF5wIVh4dci+WuH262iqhkyXgjxL1JvIzIPrbOvTBdufNACv/Jo0oXDUZGkpMIFt9bPiqbz1/pf2DoYnDSm3AtAG0ciQqQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f117f2-91de-4948-a9a9-08d7bf080496
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 00:15:45.6939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HAIN8akVdxmKW5PjzNO5v2dWSFNBX1p23kTaXOhD4jP5S489uJJxYnPczjHtyqtOiHmuKPS1rFwmhuRYr1PN0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the TLS encryption key general object type enum correctly,
and add the IPSec encryption key general object type enum.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                        | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 3fc575d1c3ec..dcea87ec5977 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -42,7 +42,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(encryption_key_obj, obj, key_size, general_obj_key_size);
 	MLX5_SET(encryption_key_obj, obj, key_type,
-		 MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_DEK);
+		 MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS);
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
 		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ea4a28ff5281..471e26c1e8d9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10483,7 +10483,8 @@ enum {
 };
 
 enum {
-	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_DEK = 0x1,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS = 0x1,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC = 0x2,
 };
 
 struct mlx5_ifc_tls_static_params_bits {
-- 
2.24.1

