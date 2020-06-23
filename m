Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B712205C3C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbgFWTx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:26 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387457AbgFWTxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx7JUZ0LGvXK/umg2/DCbC61u33awUwFEOJebLn9vXhNtS04O5TLhCCi4nbwqTn4/z7joiklKr6JUymFyQelX8KWk1h67cy3FxlPJ07JZWiHoAjGJvzzbU3ZZ9XmewM/agIOQs096n2OrmYW5KA7Ag1gEEO9e6uJS1ZotsDTn7/TxA4UoRwZj7H7EsJUbi31rOrv05Rzg04lwnmFEWPZJq7/Y574o8sLRMg2Sa/5IvnEFRyL17XNN3wyApxzkVTwqonOqLVlMnc0gowStip6kHzG5foDH8UBJpJK7tvlAkZqkJX/oQbU8vU6sJPcEy81ftyb2tAyECYdjTqAxHgf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=FkPqEiN12J07Way8CK/5f02uUTsf9t41Ib0e3/IMNQhmWoFklshJba2qFnJ4I0MRGoIold4AYGVdj/YFdA5hpwb6u5ikbZtB2JIDq3gn1t5yWqp12z6WpJC7dvW6LhUE1IO0VUZ0rerNAx2lOhbmuK0A1pzPsO7PtRfM0f39/+iGhwDCBa1XzOjcR8Bambn1OsD91L3qpKRUKZ3ixzL7MpQwj23IenSew2/5QIXNxNM8SzNnS9CjWWVgBk9o37YUYe81fM//uFwhb7Uu0TB5oNE+aLY7ZLIcAIkGXqgOru/KvGjsCEoNFC6LHAW4oE7hVAih0KcDvE+hrFKz6ugm6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=hjWPQyPuui4Cwm6YgZr9EF+ndJPITcCEqWgUKJibqA7p6yUIzdPS5qFun76o7G2p34+pJvc5Jiym/qG3vaRK3WBZLC1yDIiNeLag4yUbYe6DWEAnvjRnElTJDG74CklRma/HsF15tKyV864aCCxGtMr7oIx1Pk0qDjmEz0Ufp84=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:53:11 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:53:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/10] net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup()
Date:   Tue, 23 Jun 2020 12:52:28 -0700
Message-Id: <20200623195229.26411-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:53:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dfda49e3-b9e6-48d1-ffdb-08d817af0efa
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6101C4C2DC894BB1557B691FBE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyQMNWbChBnfEBOngEy/+VYG7BjOmoAtet50ZeByZhGgG1TD0vJpFa4SRHhyViGMi7iDuxDhN3WHLTAX4WAc0zeYbF8gGzy7ihHNsmVWWnZDxKUmnktfayvF0OtzME7UMD/WxZsz9MsgZQwG1kJpj8smElUaLIIHVRbg73wRGXwJKjPogkVGjA74np3Z0EullbCHrVY2mH09KF2prcBgwQcR0F26oDvEfxTZAFTsLYpqv64lY9hY/iGpQP2i+LO4jhDhtBX68TC0TWya8KHhjZTrtxe3k2X2HUUisUJcaZsDYooQ7kuVEsy417VjCcBpKUYXBzp67vhxkN+oySyLzOGrl4kIeUDHATuEtY0sVVIEdl1y946fYG8YvP3Lo9up9mi/YKxTMd7mVsUecdFNO71i7U+D3LZW1xTDa4bxDkY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(43170500006)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zq+y8O+tPWnMq0LcoWLwmluZrvpDspmfZi47W5sOLeXy1XuzG8lmT9TN/saLhVB3V0TMm/xQs02pSpLDGeh67GC8lgQP4qWEgSe593+DDirjC9ceLLi+Qu7VCkvoaU2bHl1phuU+5qknHlV31V35QZhLprWoYJ8JOPVKwaLpqWuE/nOpLiNqG4S3aWe9EXb06Kj2kblb92nGgajW3GxDxszWsdQ6MOjAFiAGfkjJp/ZJzGs5sdpAqTtMEt4fPB70q+QzrlP5FE8a/zRDOOe5lXOFJGv0tNAh5hmYPIK65+6cVEzNmI3HW29PzFEQvZTS1uimdzqsh56lJAb5ZXUQ6Frd8CFbTalegoRf37uTBy365i09oJK9DwMzUBFm50O2gkVFYcYuAyJvIqTkN+3+4dP1hbv79hf1ylK6//U9kQ7bzGIh4MPQUcxjGPLUa21Rm4PyRWAhOh3W9N1Ur/ps9Ae7lpkVdm9060wk/cwX85Q=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfda49e3-b9e6-48d1-ffdb-08d817af0efa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:53:11.2550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4M81+xVkGY52+MzPJ7BEdoy+U4D6O4lgiV+fMgXxrHhoZNlgOHx9LEd+ugraFVPSGG2Iyp5X2fHjWpIgWbmGnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
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

