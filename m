Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC91E8923
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgE2Uqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:46:50 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727024AbgE2Uqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Llf99k+T1pAxd+ot1uLPfPHsR5RMIj0ls2gcT3xDP1k0FO7U6q/N4uY0DCkPSxSXun4CYWss489YNM6XijEHhUjnSKQuMYl2vgNnDpVajwnENIxJiRRummwuGsojdOQL3LnN+UZYbJIVDYOyo5LSrT+5A65Ufdt2USjxkOwt81UBAeZ01iEiRRyZGD30TmseXR0HsNGSwZ4HsTIor2hKXa7ErmMhenVA0OkZT+8Xc9SzwcwVgFVupTU8PsBWV+uel8/kRm9N8SLmHN7c5zdzW6NZgn1f57X6U3pXofZRwKHgDs2cGCQDZmZrmt/S/QDQWqr04ljnmbq7GyFta/xifw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnat0Bq/4z/ViIn1HSsIFbry/t0hSasaGLExmVRQHpw=;
 b=Oj8JU3h+W6Rh2TFFlYVmBL2ykkBOeyH9AP3Xfi84umxtaAzRjiTu+OajmUBtMiwM3WM21Jl4Q9gSddvORl90TSAYiz/6SLCVVlVk/V4nP5khXhEQd060Tgyy//zRSPDvQ/ETtEu/uE4p6rbmQb2YbSYHTBUCiW3Bc2mZMS3Mpf0TMYKv53jn9MvvqmI4SgDh1EXm0PdTPCexrGxueN078hCVB6ocDxlk4CJJlWOXGa8mggVCxIVyKpKydbIT1yV+nSMd8SQVl9n73vAhW11iyeKRNwwQqqfJcYaTdiTq34GHYIFaL9ddFxuJh+gMHWZMbDCo8PNTiW+ypdZk0y50VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnat0Bq/4z/ViIn1HSsIFbry/t0hSasaGLExmVRQHpw=;
 b=ij6y/Os344LLPAW3++BJs7//wsgN86pcD1qDp0zXBZLli0zDVrqNWFW2xgcpRjlTy09FzOSYGEAmpusUS4VyGq55KPj0lHmRk29dPsPOtx1129mhYS0mIUhdiRYLoVg73PNg7KdCdt8sRM9zHq0KJil0MLI4uOoOGAZnIFYnW8k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 3/7] net/mlx5e: Remove warning "devices are not on same switch HW"
Date:   Fri, 29 May 2020 13:46:06 -0700
Message-Id: <20200529204610.253456-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb64b38f-fb0f-432b-8bc6-08d8041166c6
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3359990A655DC07F5F3B8937BE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WchjU9Z7PtExMnOKCpujVqvuUVaA6TKWVv1JVihq8ZPtxozx1SsJ7SJdCaCSBbjGR5z6APrbxoKOABeWsCBNrXFCK1GJGRmamtZ4EXoBWpkKfLewbdXjiQIz/XTZBG8gusenthxR0H7WjXUGpmWKWwuQnhsAeQaxV57TL28eRa3B5YMg+3ickF6/FJrvtXoRmKMIwNY/slDj2gzHKDm6qz4+iqJ30iW4u9//oCUg3kCzj7DmL2wmQ0meuPc4ASzfoIdIBTOE7evgcrYjDDOyTmDbYua9uCbebW8IfhIdMulVs4qmsXtqOcfeNjZPdzDFZZb3v8GATXFenJyXlBeKqHcXV/A9d5qlPGvGsZBWMWSpUgHiUXtbAtLyMoMcndqb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xKajZ+rTAXJQLrYCWS9WvxWVUnOTZMu/EWFphD8C6Ldf9FnVlfsa+Q2Iiv6X3uKO/t9KLWcIUfGQRl2X1QzFk8KHZR4fR68Vt8j269y7LZI8j2U9QgEuHdXSNdwESGUKe7r4mBGNr2nrMmd8XvmSzfm2cRXETcNaqoCyAOA7NhnJehHPVI1zDleAqCpZ3+UN+WedZ+Zmc7QTK1qtLS5LOXcOlhBAvHExpsXhUyJIZ8xm6Ew3PUDMsrgYgRoL1aB3CEW30Ed+uSRDahjiqY0WP22CaWx6gLdRWbV/oCpRu51Z5pDyN4++NH4J7lWY3QyiDMxKbRyOBH6+q40RTeEPS93L6QvLNbt7zhWJgzDWPJN6gN2ZOAxqU0uC90reRu1/ipoS/upFI5BMYtjHxVb/u9XIXWw/MPl/JJeAZFtSnZ5vLOk5EYEP3IvXc3fy/glGBxvfKUTZ2MsKO5oe/lZ0HEGri8TyKBvrPY8mcBXmjHo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb64b38f-fb0f-432b-8bc6-08d8041166c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:46.0167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qv+ORZ4OGMWeS7pC1OHgOsjZT+yxbBziuAybyhEXDnIgaf1xjWOfcwIMJGMqFyGCA72lFQaJ3IjSKpOoBhSLRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

On tunnel decap rule insertion, the indirect mechanism will attempt to
offload the rule on all uplink representors which will trigger the
"devices are not on same switch HW, can't offload forwarding" message
for the uplink which isn't on the same switch HW as the VF representor.

The above flow is valid and shouldn't cause warning message,
fix by removing the warning and only report this flow using extack.

Fixes: 321348475d54 ("net/mlx5e: Fix allowed tc redirect merged eswitch offload cases")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cac36c27c7fa4..6e7b2ce29d411 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3849,10 +3849,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-					netdev_warn(priv->netdev,
-						    "devices %s %s not on same switch HW, can't offload forwarding\n",
-						    priv->netdev->name,
-						    out_dev->name);
 					return -EOPNOTSUPP;
 				}
 
-- 
2.26.2

