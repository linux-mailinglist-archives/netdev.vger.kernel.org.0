Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52520A679
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407063AbgFYUO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:14:29 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:6196
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406983AbgFYUO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:14:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGykFIFQMRJbXUdvCTDE26//mPIviii9AB4XluPeosSvusYzVuVpH+rafePDyEIB0nYR32H/5x19ay00CkYaBTT39Q3jV+/z7GmoAUOKq0zz3AghYtkC3wbZQZAT2mfdJRp67yOOmjZCaNnAceqNVWdMYlRt9FIXQrEEIxiCS5xXsPX4UYV5qbyqCI69FqPLJTbBQ+Lx8VOVIs9i3O8RA0ELTo9Xwdhz0Ths0kwx2JPKpEmpSEBn/gDBo/eEI8gK2BPtuVLzg8HQ6waMgKXCNCqZmModSEmaZnYCBSnds/f9ftSP+LITjTjIGDp0a85SmSB57XSJVaAz49MSK4uPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=RUgZtgvopEQ5I7YfIeowSWk/ufKG3HwyK0wy1n0a7bgG2hMh7tXF8uPMwuImmOn3/fNY0iUPJgbVRQZ6A7R1QWqFAuNSZLE9Lkpow92Jqx936eRFQKjj5iZppIV8pNmDqc76ms2onkmnNwnelKYSTdBtRTeKYhnFhMSiL9UKhsdYb/8Iy+XGm/tDJzpBsVSi6r2By/JuLu30ctuAUGLN47nDuwuzSufuardTWhSbO+R9v8fMBwU5vrazaJP7kpmeqO5HuayWz1IkbcekKMslyR0MMUh/7R1E/XLcttzrDByeiMtYAROy+dgx0pE4Le22Do2YZNDmQLV6zocBNzXMHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO3DnVWv1QEqusc+nGUHwMvFvdcoYJPgoujYQZhZ7O8=;
 b=EsNWSJHSp9f5CA6dAZC2kG16sPsmETcPcOAoPHX2QEtJQG2CElbgR5HnhnIJOpymBUA98U1VVfi+LyIhsH7KWeCBTkBo7o1CLfFpoUO9x29pW0G+ScpfKNvPQfi1pi+jNVznH7OILFCCNSC2YpfqPUQ5Y7hq1CcTfZD5ko2UCmM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:14:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:14:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 8/8] net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup()
Date:   Thu, 25 Jun 2020 13:13:29 -0700
Message-Id: <20200625201329.45679-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:14:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a8b1b7f9-88b9-40ed-22c3-08d819444f6a
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24481A3B5067E82AE52F54A9BE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmvM5W30FG5iQX9ZHPaLPDX4AvJ5jipKOcZNVqkv/47jZGBBpu2j3qQN4bB6cTnX/UBVA05JxhJl4jKEkd0jd6H0wkfkhZUYOGcvjshlM3EYGQ+3lEBTKI2BzpfnofSTI8A+8Vow6uQd1llaXjIFh8NIhlHjgpy6Xzr23PMTilqMZDjisk5Hdghi3M8gxVoIvMsMJ0gtTVQP881f6OQFG8SGYNOzzOzFqRGF8NGr0/mHMwUvXfU1z3WRcmKbQR3ARkSyCistC+mup1nBRgiBDuQZyaF6WWDt/dv/9BHRwBZtf3UxMnDkaKjXbEfbo4btxyfvDnQAWvVosm9qG4bkKpT8hZBraudf2xZs1nSniAX/5+lLS+Yrmoi3305fBV0EWEC3h5YdBJpHOHk12SX/nf8iI2Bhdm02QG2xTVCTC2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(43170500006)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uK2lhr4Gd1AqakyF/4vnebL6kgsn9tK3eJr7QfXmF3GmU5vhq5D0ircja4OnMhu1Ryr17M00XxS6Bwj8VOFENYb3yWrtjGt8szX2Gcx9q2yk19g8NLoAzUYtukweVgdMrlQsz6rBI1vI0/iT8SbYEmDPBhojfIu7jH6O1yj/aFBHtg4YxzCwMH5zPO4wWkoFVyKR29ziS6lHgKWDke8v2VarIBEgtW6tpyBrF+P9O/Y8wtEYUy27FYqJoPhyy7abD7765LnXQTY8FyynBrwIjS3tIWhr6UmKejwAT26cOGlQWLxDRxiR9AZqmC9zndLKibrZ/gH/FLwcRpjZdx8FkbUjY2qQCdgm+ijxLGvIQR3sKXtpDZ1aBL8qz91z2wRd4DqydJf6bbNAmALNNqLou0Mf8JwoJ16Eqw1rqyOpc7r1RApwGEZhCTMUdvKCMRYJ8cDtwBqqxAMpA+Sew/wZdaJdWY49tBbxzbuofA+1ibU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b1b7f9-88b9-40ed-22c3-08d819444f6a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:14:05.6669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqEVIBX8yL311UoFG0hJLzz1w8Tb5yy2pYk1n7KE7UVmGExQCySWOs39e8jsj6Yy/ybY1qzCRNt/NnezeGmY8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

