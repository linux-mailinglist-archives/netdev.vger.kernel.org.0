Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116D6206A0C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388244AbgFXCV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:27 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388207AbgFXCVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP1gMmYre6C/RzPsa6AN+g92Ad3hhZF7QCNzpRZqHAxdK2RuHmCmoYOeEpkxW9U/l5XTK59Dn8anP8WmJt091gtN79hlW2HiQVIi7kzrFmtbOFCGUwolnCwdBOauNao2GKVRs8uC/84Cv9KXl8pVAFBywXcnXheFE/nAuwMCAM908R7cxI2avJXItUC5ZnsV1btscjy0cWClvBNtpNh3cUMYZORY4h25WYYl7MMac4gaY6PsWzr2IdPGAJw5Fd0LU1g5t6l/dDmL9zonbrDhOBCxDBuPtAwIGY9KACC9b7dIDtdh5PjaBp8Y7SQp5O39+nc3vCJfwiDQjo3rt6x8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=PlZVTsIig2jg1VNC9Qo2L6MoEc3dJMWwLotrsmNZdYzpVPXPKQTqk8GG3kIcL8pdA5oJ69quo6sxNMWNYebBo9EvnTv42tckEHNPQreB7tbq0qK8V4/xegSfWqWcGtxFHVhJvb9ZM6Z8kKbAuVvSh2teqrP7xHBt06GXYTrP56fIRYTjA3rLMagsMYmo7B2IZiQu8mdNQWf3ucVRhA9fVIjam6dcKg/MrGfZ00WI4/o1ElGuCUhNkUe4bI7sOgJ+Fclff8CJJNLxDEp0SvVLMPfLRQObDUJ8cJDXmQbWRrWkhaVgMk+SeKQu9IBhZhaTg9eWOGLcZj3HB9fNBtSUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=X7Sk/2EVsy7qpXLjup6kxTP7VGstI4b/TThIA4Fla5Q+gymlttlCKRyZlm9eZ8XibD5l0zAH+hitlxHElJ/UyDhiWVxJ54nFYn0Cw/1Z1D7a2Tqvmup7Vzykg/7O7HyyOa++N3xGhN7oykN191XYuwIRo4wWztP/v7go2iKTLUM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 04/10] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date:   Tue, 23 Jun 2020 19:18:19 -0700
Message-Id: <20200624021825.53707-5-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:13 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5182e54d-3f52-47b4-005b-08d817e54564
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB702266A1ABB2A76874045C27BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WiXQ1eE85/HaF7N9z6XfnnRkE8Swjlh9ywbK59vFkeTt3X+HCJjfLOXMll9+V9IZWFsqJxWs40cjUTknH9+cS8vGYv5/PYjsV6dX5SPd9yvftnMLM8o4L9yPVlUl9qJzrMDhMzi0N1uGTeXAIgUumz+FyARTliM62Cymwv+URJjprsHgCxY+e5u5xlpHMx7A4yoTr/U1FSmqRdqQkclgiKDpB86VS9S9ehX5qyv6tEiHz96wHWJ6OEn8I+WffyTdV+7p17fTLdLf64QK1g8LEdRsQqOSJ5c4IzVXne57hssTwzFIhgt1wuBnoHTQMbSvZ6B1M1XV46wMbFXbFKie0sJcpe8ZG75CQHz68bkbYhWuxBN9jy8TM4zk08GSYJN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(4744005)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lQ8HbgkBueNbAhO9+inRbknp09yX0Eg4JeN8Wv+oxyXHI/wuij34QdFzuxL7+IWqG183R2cChew5jkLb20jXH+negKzXrVZCPRMU7gFTTY1gKDEtO5xnF5u80w9DCDXeOYuPzlwrikDiVz1rNm0ZTIHFqlfXfI7KshhgynPGjn3F+QIq2QKx1PEby7eP6J6+DhP4p7Pt5fmzdBgNkTApZXdQHI26TZaCbe/1+bKtunKRYr5PZvNCI2H1PmZH+TkNJkG4SsnNoLy1+rVfE3yh4emdRkGDh20aWK1coLZ2t58A3V80MPfvcq9/L3kiYJoSthtgl4qXY6BvRX2DTyk+SgrKKb31EcPpVxx9EDVMnCmVv1VIz7Z+p2b53JEt5qSP5WtRpQ08TL1fcCAmzZf3Mx+UVXcFz7Lkem990ky++9Obp1LqdYFvWa+iDV0T4EhXkW2YcPoIYy6DHYawKjJKATFyuw3QO96+xlAZwpjUMaU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5182e54d-3f52-47b4-005b-08d817e54564
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:15.5614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUqZInMIjzp+EIJg0pxrsFsLQLiYXuux6HEqTU6TXf5XBm94G0x376sJTLqMoTLxQLo78YeGcFieNwjQPuMb6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
the memory is allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 014639ea06e34..c4c9d6cda7e62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -220,7 +220,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 			sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.26.2

