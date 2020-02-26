Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1964A16F4E0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgBZBNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:49 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:6064
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730135AbgBZBNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gq0FKxSP9V6YORRk/RyKFbLv/6SvoE5HwuB0g4BorHv14K8/kbbGfjjJfyDsFlx5c20HdQn+ENkVNM9gK8EaJHPtbRfDUABezJsMeWVPTTcH0h36U/BbPb0ZlfIM4XWk/oiR77Wj185nrYVjkVQaQqmAVEXSPCZTbvca76XCHE+P+0OKyYUdY0JoGJ0vLZeKSeY4jJ+L1fGbRT6c/buwoe5J66khFERdVI/tZxFQXB+dFn6AVjCkeD8uTDR7rVYAQ/aliUN3tmKvjku0FIYSXXf/WpYPtrXKTNAnDupSk3JEoLX8hW28ZUpb1wQYr0bb5Ev5enj3N9fqEqWHFxhPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wyg0Z9fl6yKI4oz8M96xMlpgrohIYmsbmgEE7BBeGfw=;
 b=I5gYx8Ex1vL6J9kSdeEtlxdxoSIvOW2mM8pCHzimGSvanBolaKeiE0k8MmekVnYNVKTsmqzKg9szjPmYyN6jyXLhAnuZQ+bjyZYfo6u7fG07AErjoZWn5OcTQFt5mLCh2IxquTGQYcjfgCvXu6wxHQtP0GGWrc+61Sw04NQJgSG7weWkJajHbJTtflbPEZw8xdGF674+wuHGyFAWPXV0LQ7ObmuZ48MdgXyPe87Lprm4Js9DtX/gp80HzKdcMvPCMLCRNGnlEN2f5Sc36A/f8JMFwSoTYNLAC1Kqs8NiMUOevaa0iDYc4U36mcTVYb4nk94kWfB2eU4TdL7ns/jgFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wyg0Z9fl6yKI4oz8M96xMlpgrohIYmsbmgEE7BBeGfw=;
 b=k62Tdgv9jpazHJOAP7hfyCJXShdUp6fsnju7/fdR1xWrtyHifUi0e1x3BE0OkEld+566O6EO8ponxGcaRclgaxnGxoy9tuFUMqCdhqAWlOi16aTdogPXHByYXBe1FoR84G/CmGGcLvm5KSoCeRDYqqzwB6RtcGoiKl4Hoxq8r3o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/16] net/mlx5: Fix header guard in rsc_dump.h
Date:   Tue, 25 Feb 2020 17:12:44 -0800
Message-Id: <20200226011246.70129-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:40 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6650f9b-5001-4008-276f-08d7ba591e4f
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB58692CD26FB8CBDCEFACEFE7BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(966005)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cEpE+033h8GIppgEf5QQDSjYsuCTuY9ZpTRmNezkMfRWSkefPbbDdYbAHmJ4Jxv1vG+uiQdDJYV+h4rw79uXjPwml0dJPH3RtaB9nnovkg+2osGCga6p+Ey3g+4WEfz6gLev3HP1md9TmaQq8VgFiknXZj9TU1zQKzgtd3IwrF3tzqF7V7/xbWKzqJ3E4aDRB6NpLxh4Qv7rs9fyzKKXFAXSRSUe+XnRkVE7djGF4fjsI5nPmflCzJNQAffQ/OGUFQYegpA0YyR6I6Q7StELFhZW4uV+3bBDQpdTlMDE0PzllDJdYfhyjaiFlGY7+tFlLgkgjzVwoQ5OqA+H3Bq6F6ThwPvWsQo7tA7QmzwAs3Y2b8VR6iR5O8vJp5DX8/Uf/zpXErnemnspLX4d7qxs+j8wRhqaLSY2JA8t0soUibYRoRdms22O40R77kXZbk0TtD313dA9ErI1XmBcBdsV6LSxIJp5wpMrd6wiHD3+sEp4osAM1OkzszoJAZybPeNYXyiLpRGi5hbLG7BzHKlOH17j/oGO+SZGImVHEoy/Qfnee8pYtYJKUWlGvLhj45VrzHAqd+dBXO6Yu8cPmbGn/U7tkXBeQZU50tqeGlorRDU=
X-MS-Exchange-AntiSpam-MessageData: QBAdC2PZpFSQZKXQfSuOwbWf4P1IYgnA8UwU2ghMpj80NXzdvRLn1G7X5La9E2au43qfKMtQ+ePuV8sBEj07speezKWJjTo76LpsxzIyjmm/kV1T25PzYJBiSFAUCpTeI8p6ACnyn3xi54BNwc4SOg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6650f9b-5001-4008-276f-08d7ba591e4f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:42.1672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYcEuC0YVIuSm8Gm7cK1QBh1+wuqs8VEQrTUy0ir9N2DBQXlUALFIhvUel4clODn62rd4Jbz5cunoYqmWTou7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Clang warns:

 In file included from
 ../drivers/net/ethernet/mellanox/mlx5/core/main.c:73:
 ../drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h:4:9: warning:
 '__MLX5_RSC_DUMP_H' is used as a header guard here, followed by #define
 of a different macro [-Wheader-guard]
 #ifndef __MLX5_RSC_DUMP_H
         ^~~~~~~~~~~~~~~~~
 ../drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h:5:9: note:
 '__MLX5_RSC_DUMP__H' is defined here; did you mean '__MLX5_RSC_DUMP_H'?
 #define __MLX5_RSC_DUMP__H
         ^~~~~~~~~~~~~~~~~~
         __MLX5_RSC_DUMP_H
 1 warning generated.

Make them match to get the intended behavior and remove the warning.

Fixes: 12206b17235a ("net/mlx5: Add support for resource dump")
Link: https://github.com/ClangBuiltLinux/linux/issues/897
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
index 3b7573461a45..148270073e71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #ifndef __MLX5_RSC_DUMP_H
-#define __MLX5_RSC_DUMP__H
+#define __MLX5_RSC_DUMP_H
 
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
-- 
2.24.1

