Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CCA172DA3
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgB1Apt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:49 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:43406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730447AbgB1Aps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zu5JyK+UCOq5l5JufEnRM6TxGfrvbkpCtJR/2F9sNeXbKDVvIJvVlqX93FFz0z8Jpb1Pxc/+Gt8QMimfoixk5mmugFFa0sJLbTAch/6mYTpRU+68gjg5Bym7hjfdpJPQtJ8z9jH0le2S1jNT0xUbjpfBeqOrG5kDP1tlwLm6vD3eoo7Z/yNGptF1Y3E0LA0Zzptg0cHsT7p3+woWS8UglZ2unlahwrEgD5RYP5GTf0P7RRiDqxJKJse+nugxxNzTNsJIsf9pLMwBXt6MzDPDgem8RVf8dl/+Yj7FhgvIyc0k7JFWyoLW700Gt2C8wP5WbW5YsdmzhQYMW/FeBub4Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0ZI2qeVjH/0po0DEQn10Mq6ebPVsx5oc8IrATbR83Q=;
 b=RmkIyYPMwzPH+u4sD7fgLXkUlHQb9Lylkh02Tzbkx0lSLE0NH4yumpfg45P6P/UyRQj1U05FI9Hxhvhw4RZs3ltl9E58ArO5ieT6MSZYV+VlRvZJODoh2zbl/46hxMsg8dzKzb40mo78O2K/XPXrXQb4HyL+r5qPZbufv6YOg+nBZ/bfaqdWsGScyv1mYn/XH4SlnSD6wHcwEq0LBCdvYSGTuAgxbKrKGYh/g/4LOiTcQMkywV58t0i31PegYVFZWMT8Hw9FDXZ2qRUKAWeC3loGikIwxdkXa6SeHqvDr0opNtYh4+WiCAC1KyWcwhyCWOI7AJ2r2EbCF6h8Crwsog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0ZI2qeVjH/0po0DEQn10Mq6ebPVsx5oc8IrATbR83Q=;
 b=ZNtCO2ymAdKbA6/GOgSzlMjV58j290Jgf0JFV56vgsx3l9bh2PHjCLHwXqe0vcJcjdeGVGBE1NwoYQ/LjQRotTyaLA/VRIu5F3Xy15cnlW48FsoawbAVSXAwN9inINAQKU0O0eFO4tFAVDK+lvE7+SXX9qRqnc5iOYJNqoTqOzw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/16] net/mlx5e: Use netdev_warn() instead of pr_err() for errors
Date:   Thu, 27 Feb 2020 16:44:42 -0800
Message-Id: <20200228004446.159497-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:34 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b70de7df-6076-407a-7252-08d7bbe7861c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189E2F0C93CAFC3A0D1C62CBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dKiFluTSkKkj8+/OVq4gJ8QfXanvhzTfTgZQj27KEQ1EGNDViudzdkA5l7WFmys5aUdpChcNwu+PGD446yrDYAQiFO7v8QLuScz3FhXuTPnU6hRFLED2KA1ObSxYBou8uxmM2uVRhtztsUYPT6F7d2ibdOYf0+OSUGrCQkl+0+xixwpBsb6F4/iuEerjK/hdYuUEtHXiBiH8z/gWJpQTXPDkxe1TA5/A0uTwceA+uyjk1hZ/+PBQrVceqa4OstfN03ASyq4LsA3weeuq2txetYac2JpjX1JygFRtJ35kTy3ktPZrHHb/F133mCCxO5HrvEC5X8P6coVALYhvcyVnyUatomXlu6Cgw2Qjh/wcloqhifAMjaU3Qw15JhPHVF4zxPaCj4GbaBeKn4M7ZMo+EJ+Mx6ZPxhpEPY6kN84KgOZ0LbDxOxILFrTlLImOfnOewOwlWpNsn+KO5fF85TOwRuv15kgyMvfOO/mOBB0d+n7MYB+3K4QdwtifguiC54ujDFwaBcRBKwopXkkgwxBMMZcUIRrudydEBSfQlG2e/+8=
X-MS-Exchange-AntiSpam-MessageData: aifFfH3QwUwb9xbJqDAkaVuiomTHD2pGKWTqv/HjYjlAwTzOp8EHxuOo1+KoGUwfP+XS7DrKRLfw+iKH9KVkG56qpIkM4X2LfB6ON5Aj5HutHskqZut0mkH5kEj+70WM2AxX865VRd/2HWIsIwk5mg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70de7df-6076-407a-7252-08d7bbe7861c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:36.1213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKdZjtWfr5PRHd7OuxJ4L5PP7u2WiKvFR4vJ2kkiJiqQCyn4xh8DX3foSjncjwEi14CHPS3kdQEzphapURhAVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

This is for added netdev prefix that helps identify
the source of the message.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3be654ce83e5..14b5a0607f67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3381,8 +3381,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (attr->out_count >= MLX5_MAX_FLOW_FWD_VPORTS) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "can't support more output ports, can't offload forwarding");
-				pr_err("can't support more than %d output ports, can't offload forwarding\n",
-				       attr->out_count);
+				netdev_warn(priv->netdev,
+					    "can't support more than %d output ports, can't offload forwarding\n",
+					    attr->out_count);
 				return -EOPNOTSUPP;
 			}
 
@@ -3460,8 +3461,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-					pr_err("devices %s %s not on same switch HW, can't offload forwarding\n",
-					       priv->netdev->name, out_dev->name);
+					netdev_warn(priv->netdev,
+						    "devices %s %s not on same switch HW, can't offload forwarding\n",
+						    priv->netdev->name,
+						    out_dev->name);
 					return -EOPNOTSUPP;
 				}
 
@@ -3480,8 +3483,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			} else {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "devices are not on same switch HW, can't offload forwarding");
-				pr_err("devices %s %s not on same switch HW, can't offload forwarding\n",
-				       priv->netdev->name, out_dev->name);
+				netdev_warn(priv->netdev,
+					    "devices %s %s not on same switch HW, can't offload forwarding\n",
+					    priv->netdev->name,
+					    out_dev->name);
 				return -EINVAL;
 			}
 			}
-- 
2.24.1

