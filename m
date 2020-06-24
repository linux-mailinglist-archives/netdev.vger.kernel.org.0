Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755D3206A0B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388230AbgFXCVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:21 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387898AbgFXCVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O41PaLSOW37ci1V9cYWoJrjuou7HeM0Ou3LYTMABrKheMQ/6/1XOFG4vNIG4lgV2M9VqY3R64uabif5T0CjxpxAh0KyWfYI4g9nbzCzI4BO8k/zAallhBQVvkWSDwbYBM12/bBHwHnUs0lNoK0idf182C9Oqoe2WAWLiW9GM0iCPROwUsztphZglRSjJu5eALFzT6JZL1QpkB+2mrqnU8354S6r9hdUi+/YYT4D+6b/mqbSn4ufB/RelpgArjnqSqGGWY/THE+KoM3Le+agIxJe3i91OMREdgui5Ebc58cr5T9iVNQ5ETYyrmU1rNth7ldSLGM3kE3YXbGKrE9VIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Znk5QwGW175BvUBP0Wht/sVVWuqnGkW98nuAdNdjMtU=;
 b=M+7AiTwLgnpo3JT8UPgzUlTe+DigZ7/KJ1VTnkLMFMefZRyEdEZUMmD44GWyIPt4D2nPyUIRZtvK/WOK1dOq02SDtFmWQGb5CQqV5G1Axo+jnimUAgUArN8I9SMtjO2g4F15SCRK/Tt+ekvsv6F0gj9mtTsu/HD7k+XWuPsgxdO86AQQReCfGcyQLIzg5ufWsnF61nbb/uGfuuJIcK642hzdDIK/dDKBNsAdDP3QUviKnfljdqHu+V6yRqS+W9ksarad970bNgYVSm90UxXnHKO2RmcLmB/rprkJO4sCU8m1Tn4EEP1uB7cifZMIz7oWke7gytSQcanyrodH7m2yVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Znk5QwGW175BvUBP0Wht/sVVWuqnGkW98nuAdNdjMtU=;
 b=qbI2gk4v1VreXlSeLo+XDbfTY+9Y6oTKLfbB9jszRxnOSFzPhWa57/m2bwgwLqIW+1vGIMIPkP3DHXWXZtih5fOx6nDpmYKHR+X+UjEslf9aPXTUd0ojgLnBgGAw1ifYo1AOOXMloFUjFJqgx6elbYdDdOlCuLEcoiD6IuDnFAQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 03/10] net/mlx5: Add a missing macro undefinition
Date:   Tue, 23 Jun 2020 19:18:18 -0700
Message-Id: <20200624021825.53707-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f732237f-8b73-4d83-dcd4-08d817e54439
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7022379882A94D6EA8CF2866BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TGwNs0PVGWYuOKbHMElBpv5g3VEqonrjiJlzNgAG/2g2UsziQZz4zprlzNvxe60FW+4DEraprEYzndK8je5qqRKOLqpVtgYI7oRUD/d+3JUEq+pPDh3VvG9znJsWUfmOinj+q5eHbYX0sGEMZ4G1RpNtgqz+Q55fhvYlpB6Ur815ZOLX1nqIdbWuPp7bIW98e+Zgnz7Qu9kB2YlaSH+Opnek8UESxzYeFJUis1XOkTQATaINYd5yOzO7SQ0cijq9qYx9PXNYcel7E8gy70hNPsuslC7hNY2IuwfWtIecQDrg/0GEMZY0GD4Jo5ogPo4LOItU3CcHohFI0mYUtUxaxHbxnn53qj+t62yzU24dvDKeztq1GDYdsumvCLUNwsl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(4744005)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: G5TQ+YHJzPGHDsb5OyGa78jCG3fu+IZGtCeGnLc6aUSc1WfFx0SsApEyLSqM7fQ8IULeaaAuq8ZQ+8Wf+Qx7FtLUsgonzz/5iHnp4A0YsXB+G8ELN6dmeT3ur84ldv9TfF0zaqCCT55OgxYtEMHPxJcwiywlhZXsQedVZ27FJZ3+L/LNCYbdD3FYaKV7t/+Y/S1ssJdEOnsKR5760+RC6IymCJDnfBLJ9fyt0kwZcMQ5/VpHDp575FSbSxk7XcZz26mqcacbp7NwSXGS8yLbcCRSVArcEBLyiK+snuP2FlaVKsOJRbuo3Ojb/e1zO5oAew+U2N9Qxg0ExNzn4b1um8IMhCWBZmFtC0UPpIMge8i3SS3knuv37mx4z/2ddJ4qjXlPQiPNxwRKBkH5dot3B7ewMxR05ON2lzn9eNAHQyjDPoIBNCg5gWX8qY5TT5N5NIXnOJhbmxj+ZoGkik23HAG7i9rDeTQBoEjr7cRqVBg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f732237f-8b73-4d83-dcd4-08d817e54439
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:13.6035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLCRvhgcTOGmZO06kFKI7cqXyoLYlvbwUcYtGfjwxp5Sw9lm2FXC/wKSiHFFHhD/C/b4U9wqCrzOBFX/HdjOpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hu Haowen <xianfengting221@163.com>

The macro ODP_CAP_SET_MAX is only used in function handle_hca_cap_odp()
in file main.c, so it should be undefined when there are no more uses
of it.

Signed-off-by: Hu Haowen <xianfengting221@163.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b658908f0442..be038ed1658b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -489,6 +489,8 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
+#undef ODP_CAP_SET_MAX
+
 	if (!do_set)
 		return 0;
 
-- 
2.26.2

