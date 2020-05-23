Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D461DF399
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgEWAlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:47 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbgEWAlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3Cdchn37qucmm3lWaOWb2szD1NHSOko6zeoyY5O67R96weNf95mAxs+X7UiR021S82EuaRLiJGZ6q0DVHq+ClZ+SsGdWXbnImIeKV5cpYmimA0r+QKm6N2YIPz0Ylmoyd1hvqy6w0Mo/UyXu+vvuogdBKDeCtbHz+9hyLmDZk3fXaJemh8mj9ZB9NjtmALrcwtu9MCtVgARNVPNfm6G3Aj0dtZ2a8b9l6NV1IESxEnU64uiOKs+m9tSUO9B8FXp7CxGQ3uuqr8Df1ASCndasyjNi71/I5gSilNKrGzckbltF8rohUduklzud3UpIpe+4Jp2opXxSB+N/JhQVL5+lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbSR8cb6jxFav1CDMrqHEhPBV3UHiqomq/BGF2oDGMI=;
 b=WJC0z6DUDq2zr07mvNi8pXWXcsK8O4GUTXp7MmktAqjrePKDSdDG+7eqdGCe2FnGp3ITW9MIUTB2sOPl2JWMVMOr1LLfzq5GmlQuPGZPULiiql4dIzT4bghmcza8aZBxR+DfmOKYctl9YgA5VPHCgBIU9KhsZiuVjCJhuGX0mx9XeE68Kc7zqt7E2rxFnZXmD6R/quXk2R2l5ZDkDsDkn7eUo+8V4u3CdBp92YDrF5QEddqZ2rnh397D1h5XDyZk79xyeOPo9YcxAWsZjdVI+mt2xcasM06wjZoJWnfQ6+fd4OeSf18TSBRnpN6ZvI9egVIi5I+AkN9oWPm6yB8ylQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbSR8cb6jxFav1CDMrqHEhPBV3UHiqomq/BGF2oDGMI=;
 b=WxGZKUNwLxfAmUJd2XNoYVbRyMyjApD/azEqncdQEvdUDTuapaUwuKIpWvo7zduDwIGW61v1IzZfrVtP3GzQoItiJUJUnPu/PJ+30+UAzLYvI8o0tiPr7MaMzK9nNW6yNTHTO7umxWKsS8XAitdgUB4UpDCrnd4UQpHgVWrRVQc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/13] net/mlx5: Annotate mutex destroy for root ns
Date:   Fri, 22 May 2020 17:40:46 -0700
Message-Id: <20200523004049.34832-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:30 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f3ce03d-fce3-447e-0945-08d7feb20a15
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5391C5D7E30D64FB34845836BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:200;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4chigfAhielXkJ848ojh0ToG8IdkOc6iMTtaEPdb/3dqxgfwJzgKe5dg0iH5FT/fTS0FYaLuF1PDaiDPaXcKov3sE1h15EapmoNuiYrFm0gvQSD3uKaQCVU/47c438Wxup0wpb14UOenQv1HR6xzacbgUdik70wfUgUC7j6y3SNyXbXJXxcOTon7LNQT5QMzTgykNpOO95YfTwjiQ0dll+UZniFHW8BW0mjkEGt8ai7qrDuERhQozFVOKhbimBQCccezMLJ4EmH4CiZrmYwH44SUpSTfnxvZseIjdhdfLKq2yPMTxwHWj7NIbXS+T5T8GqNQHEUWf7X/T2pkKu7AcAxFxU4lrRJUOs+hhc7GjwbaghKYqMjHbAHDGDMl/o4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ArYnp1fONJnH9YQ3n4e2+EFLuh4b6c88g81NkDu2efQ0ABCxUkmMknhCGEbWgC64kb8UzYO6A4YEnQmsOZy2rgRx4TymNwxMvvrajRreQ/Z50PZXbI2XSlHaG32Y0aAkDHSgGg/8E4+MWo4I/v/zTLiM0TJVWUDjgWoUWL7RlbuZDIlpBDOtjW5VsRvWryaWR8ZLIRTyzMccmfjD6a0GREpsZzhOFjsUEbUIFT4YV5dAd8kkeE3pK993ziY5RG7fU/OXbo534bKXiFcg/SywLpbsAtrdE3BRQ7tew3l/Wgk0MDnZd9ERDdJYCPcdEIpMJXuQWQuMB1rVbJ9RfcvDV+jYrRGUHeQ34qMIxqyyc9SrnpLZH6tN2J/gJRHaxmsY4u40+gfRjzZBKFoEe7KHGMa/We5fYOwKGxNz9ItQIDo7dlwYjm7QBnsyruPJysNaZKCsZ0Vu2rW0faeV+6j9Oyo9cJUiDg5GHaUb9DmAVIE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3ce03d-fce3-447e-0945-08d7feb20a15
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:32.6477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hTftqKd98mxrv/duhe8OR3RCsgCpI5BrCrXJsU5/PSQLbL5UB3Kzvgc5UtuMyKzmel7daO7AQIKPrmA1JLFSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Invoke mutex_destroy() to catch any errors.

Fixes: 2cc43b494a6c ("net/mlx5_core: Managing root flow table")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 02d0f94eaaad..9620c8650e13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2350,6 +2350,12 @@ static int init_root_tree(struct mlx5_flow_steering *steering,
 
 static void del_sw_root_ns(struct fs_node *node)
 {
+	struct mlx5_flow_root_namespace *root_ns;
+	struct mlx5_flow_namespace *ns;
+
+	fs_get_obj(ns, node);
+	root_ns = container_of(ns, struct mlx5_flow_root_namespace, ns);
+	mutex_destroy(&root_ns->chain_lock);
 	kfree(node);
 }
 
-- 
2.25.4

