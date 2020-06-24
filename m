Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB84206B63
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgFXEsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:48:20 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:46690
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728812AbgFXEsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:48:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cphpqSGbuBmjnSht3Qzjw14nCCZ8PtIXCl0Tcb1E+iMEHmnRCve9oWp3M531r3ChOqSmHJszyvcPlNkAb+pEZN5do1fSbXIldJxzI+eBIC93DggXgbk6bY4IsXLHGwpDw4brUMIK9UCd5iVlv0CLPwkipHn3c0PzrWI8W8dAlBbCxHOdx+X+ezLor9aw7jjSL4HDaj33pOTVFpXwj2XkeMvRlML+DB0W+H0Qj4kX64p4D8djeIpDxZj8JhsbdlJ9L8noGn01n/6oICEhC98y/o0yfNVeSLhXiwAZWthQ3SPg0ZpUrgoOnyKKz6UarucI1iQVp9hj4/Y1dsFplqumxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=ZRqyLlX5Rrzi/5kpjZNg/98hHx5s5XlsEydVre2WVIFFEmX6p7VRmu7K8qv7qco3hx3f+mwh135E1kenT6KODVSCp1axke0/S0I/LI8TYZMbPhWEzyNCGcCmdpw11pcYopnx2FpMIQyMMueUakPP8yRpwsOVBbla+4QBOMFn41viYSWvgNaRxwzNnBESVKRBodSsj7x/22qLMeZns2d0WQV7HYglXl3rE7ygTnyIfiOKRTTqv0kkTMXuIrOJpzWQHous3uZKw9OWKbGUsh8ONppuc4458LO6TT6aS4DzM7ThO70L3y+7plxLyXqbzRI7ecM2bkvHdsjgnM+a+QfpFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=kDyR634F+l9mFEGWTuGE5GKbuqhJyDxGnUmzGHHLt27z2sU4xY/T/fbXqPClmRJbId7SGZgOv2bILXQbyNlQwXG5GiB7sFz8u+9B+MJz33O4XfP6OQYhFs+Ls65OofrhuYU/cyU2ltk9OfOuxKZRd5IQ4N/nSjjfMz2wweAiTx0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 8/9] net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup()
Date:   Tue, 23 Jun 2020 21:46:14 -0700
Message-Id: <20200624044615.64553-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:33 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ec2595b-028e-4a4d-0e14-08d817f9b63a
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5135C787F964430E4947580CBE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sw2p37KNSGOlEZpWrMrrBAs3X2B7iCUYoYY28BALSzkm7xUY6TlBjeENEDQ5ZsNu6tZioFZbOvjO6Q+AIIaBQXRQn7mZ5YguiRPGDlvIxdasMF3/Y2oX9saa6tICw5fzZkwqzFoOEPQvzQfyer9WlnDB19RgsSU6IxSpQKtXQsoQqMN3lcfOfRvncWygOu6VBEU7AjKYUGH1Abj6SovzwUTRMGZ+TfvkRraizelYktAdS7vCpCl1w1cyNJzzaXyqonSyh1mn4vkbRULwZYr7eX39R0rv4151imR5pGyzNArDdJpEVPkgxfr+l81/L+X5PaQ4dU86pAPLfrSbR1VjIRZZix9LTVgH/RV62GIUjWcFsU8ry/NSfSu9m919jkIO76Zd+xUW7HyPfRFq7qidWLXeEFiRKHiyKHDalS020zc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(43170500006)(26005)(83380400001)(5660300002)(6512007)(2906002)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9CDfDo2Wtura9k/t/QpJHormNgCrf1PfNVGJM4wTpeBX29O1Jj2lEeftNVt7GX4jSaxZiUIcbn3EBBBeCk4XBMBFM5R4aZ7P3m9j7RaWLLueM1TbkfALa5sGpA6fpmp6kD8mlel0bQCRhNhATa7XtO1kXqOBzFkL31mjavKIBjlz1F1bBzaDXfKlx/T3pfWp7RsSJIAQ0z+DQlleMTdB7PEfC9Hhf8KKibdwwA/hJtWSTVz+8xmP7UUFYt39EVF36A2viZd0HRMrLn4JwDrF0Z0GZVOn2qmxfqqBXIHRldJGtBF7gKU+Ehf9x2+1jRG+lzSVc67cEQpSBxaXGOl4E0bY9SYZi301ewhmEEYpuxI/3kbHCd/UrKNsVV5ifPDUTk2b4SJ1warhJhlAvx2lkrXrGpTaJ+Hqzwme7y+L+lMB8RLKoA2lNaBmxEKV+pGklC/XU9Q4joxIxPB6thmupGsaYhuld88FD2U4lVE8U/irJ5B0Q9hwx7XNKQ8S7jPK
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec2595b-028e-4a4d-0e14-08d817f9b63a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:34.9665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMp1Ty1H/Z5FpKZ0QthyS4Fd7nGBjAFRnRhgsFJib4au7555iR9rppqqkPHvD06Md2Oti9dW7zCB0sMmBMhmMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct mlx5_vxlan_port is not exposed to the outside callers, it is
redundant to return a pointer to it from mlx5_vxlan_port_lookup(), to be
only used as a boolean, so just return a boolean.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h | 5 ++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index 85cbc42955859..be34330d89cc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -77,9 +77,10 @@ static int mlx5_vxlan_core_del_port_cmd(struct mlx5_core_dev *mdev, u16 port)
 	return mlx5_cmd_exec_in(mdev, delete_vxlan_udp_dport, in);
 }
 
-struct mlx5_vxlan_port *mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port)
+bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port)
 {
-	struct mlx5_vxlan_port *retptr = NULL, *vxlanp;
+	struct mlx5_vxlan_port *vxlanp;
+	bool found = false;
 
 	if (!mlx5_vxlan_allowed(vxlan))
 		return NULL;
@@ -87,12 +88,12 @@ struct mlx5_vxlan_port *mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 por
 	rcu_read_lock();
 	hash_for_each_possible_rcu(vxlan->htable, vxlanp, hlist, port)
 		if (vxlanp->udp_port == port) {
-			retptr = vxlanp;
+			found = true;
 			break;
 		}
 	rcu_read_unlock();
 
-	return retptr;
+	return found;
 }
 
 static struct mlx5_vxlan_port *vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
index 8fb0eb08fa6d2..6d599f4a8acdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
@@ -50,15 +50,14 @@ struct mlx5_vxlan *mlx5_vxlan_create(struct mlx5_core_dev *mdev);
 void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan);
 int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port);
 int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port);
-struct mlx5_vxlan_port *mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port);
+bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port);
 #else
 static inline struct mlx5_vxlan*
 mlx5_vxlan_create(struct mlx5_core_dev *mdev) { return ERR_PTR(-EOPNOTSUPP); }
 static inline void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan) { return; }
 static inline int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port) { return -EOPNOTSUPP; }
 static inline int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port) { return -EOPNOTSUPP; }
-static inline struct mx5_vxlan_port*
-mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port) { return NULL; }
+static inline bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port) { return false; }
 #endif
 
 #endif /* __MLX5_VXLAN_H__ */
-- 
2.26.2

