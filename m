Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50455206A11
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbgFXCVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:43 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388095AbgFXCVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioCbazGBLtN4VdW0n64IRglaDkrWeHShLW+wKeVUWvHNn3NdpuSzbUDTJXY8odLGEOBtPpHFcatKHtmcVhvWwIwMaOakf8gWUkNaiIrI0mld8boMZ5yAhgCxEqAy/w8uqXalaRkOnI37OZTQP30B6PTuB0gwMMFJyfcewMUW0KJ8yrVDi39T3hphGr/A2j5D2gGALAz1a7NwQe4CLQ1gLxEoDvXnRomFhdN1zjK2Ue6yKMcaRvYeWTzUDvAA15+bxMhWUdFGUbQX8D/FgFItGVwpQXvl2r+4JDZyPtTAdEJMibp7Iqg7TOjyvJmehF/2NZf8i3sePjtOlQtMKZfFJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=LXnrvWxKm6j9RNY+h+sS90wLGZApR9/GA/sJ0n5Jt3lERAk29dk4OcY3s6V+jGK0ZWzEHNeHQKWgWe2LGTJWdgs5B2zXVFI3Z/mWlXKGk3wF4nKymgyJz/dLj7l/gdlAOuTbaHa4j7R+tY6/dYkeWf2gtlShafhMyaOVA3jRLJJ5M/ueOkdA8GJZJ4tNIfU6qMZ4rpvcil7aB7a1+Md/y2pcm2c8G2PqOML8Kvs8bze4KyCeVv4IIKGysAGlabNuTWLqmJWajlrvr6qOiLnYvx6dDuzN++YD5aO+nIexo5HqTYQkHnae4YqLOF+Obutv7ImyfOpJWQ/6cCOch6kZKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=IRKflEJhlBjxHdkD9JxTTOHaD7yg5S0IuLASCCcod4HeQp+pcd4q7tEwNmjTEHKcafgcf4f/FKcXHe/5UQaAgbqD0+SO5pqUH2u5g1C1v74YJUlFgAO2EkVQQKCWjIVdIv1QImxIei4xZXQBUTAmBML1V3oK1iC8NS0urXYDIjY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 09/10] net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup()
Date:   Tue, 23 Jun 2020 19:18:24 -0700
Message-Id: <20200624021825.53707-10-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:23 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fce04842-b70b-4ee5-d5f2-08d817e54b26
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7022242BFA2FDD5D37F58CF4BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 97APZxPWIXtvNOaR3SqDu6eRabZ626MZBIhToVv0ub0zjHlyYAoBAd45/wAQbwBaDz5Vg2Ij2zYJ3Uj1Le3ZU+cJdVrpi2uGZ1yTSTUnHYeIE2sQ3/kC76q0iUXjWoSviMGhSSuDDhfkKYKYHDSFKidra6hCyrd9hWbzz4nr+izIBZigN6nPcRqQaCYXBnzZSS5YmYaMT8hg1hB12HzVaqjtjdtCf3k76sVRZlX287MD2NFn5He7EoQIKGNiCbWi7c43Qw7EqM82cAdgq2OOYcOdv3puhtv4JiP5pfjSmvRQ3bvvK7OuDdFgY+Xvfem0lEBSDIAnU97i0pqF8ifOzhD7XZdGwkehkwEv0yKI4pufiOFJbAYCTAtjCg+GV4HSPkgTfMP4Y7OB2l7c/IRP0DgdIYpsJi2edwJjA2dQrmE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(43170500006)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z9GgyEL81ELRvi6cgysvURpJFmaXEldqngAsQRpVt6KNCfNKquhv/iSA+lLkHA7HokoO2S+7KC+gZeV00oNwkrW+I20c+VFPKTxhgf6Dm9IkI0GJDjIroesl7oBCv6uBTLZFbyc6+7rXJ2BB7kEQeadXGFSMZHsi3olimEREE2QWEQTibtGGWBSCqfBxY3+/O+xJFOAkKWLnyK0iLcFljWtlg7G6RUUK1WpE0fvmXS2Yo5SNyhvj9esrn0cOuYAKlK/xosF8ze0xlO/C6VLTRMkgmfvql3Q3+7CIIQOXbpa/7hS+w2tNB+zDdPl8ONmi7/utc0KFFZmk+xvLfEu5qrVgwcOHgtp/glVdGODWSbD0Qq8TlOekCA2QGImgateCXT2uI3m7lr5lvgQk11E/6hjOdaGMqRTj9yKC6ASETpKKXoGibh01H5py4iCdIy0LfQW6lktY3yIH8Y22aNT/c6/bVIb5Z9XNPoeZjb0GmZI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce04842-b70b-4ee5-d5f2-08d817e54b26
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:25.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4FCUS6x2+kXLP78Z1ADsDf2+loIdKK+xvallD7L4VlI8OLk9IqKcJyw/uTjhPZubP0hWOeU+vWs/toyKbPftyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
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

