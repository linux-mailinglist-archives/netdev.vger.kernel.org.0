Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1C82CCDE2
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgLCEWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:45 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18397 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCEWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867cf0003>; Wed, 02 Dec 2020 20:21:35 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:30 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 13/15] net/mlx5: Fix passing zero to 'PTR_ERR'
Date:   Wed, 2 Dec 2020 20:21:06 -0800
Message-ID: <20201203042108.232706-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969295; bh=2yOP/XfZRWezrFLexyH7QMVCpJQJKz/rLLVO0RjbmwE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=avFR8Lqfep2BZHqwmrTxX/Ef3XdJzDhLk3mA6nOe/rctAhZ2/5lE0DsK2LSEAwR/q
         0Uqqp9iulLulBn/jgIohEW3pupzKPkSUnGmKZtY+1lXwortsiKxnD+R6biImCD4yBl
         xLS8JG+WEdaafnEHeboH69DcEhHz+a5ZxarlzGCtrV1kdgwU4px3dXPDrH4TLaSViU
         0r3rkUGm+o1ZaJNEhd7CjZWUARe3hEmjZUJdU/U67jYLgKupVX7mfEl7A+vtv330/+
         HAC6FEj3McuGd2/C5tGRjP22RtGZX6a78O3H22T56iPE1sIq5A9cmaFcUDYfEiiRy+
         8qmgQiHx5NrpA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix smatch warnings:

drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c:105 esw_acl_e=
gress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c:177 esw_acl_e=
gress_ofld_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c:184 esw_acl_=
ingress_lgcy_setup() warn: passing zero to 'PTR_ERR'
drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c:262 esw_acl_=
ingress_ofld_setup() warn: passing zero to 'PTR_ERR'

esw_acl_table_create() never returns NULL, so
NULL test should be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c =
b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index d46f8b225ebe..2b85d4777303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -101,7 +101,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	vport->egress.acl =3D esw_acl_table_create(esw, vport->vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
 						 table_size);
-	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+	if (IS_ERR(vport->egress.acl)) {
 		err =3D PTR_ERR(vport->egress.acl);
 		vport->egress.acl =3D NULL;
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c =
b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index c3faae67e4d6..4c74e2690d57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -173,7 +173,7 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw,=
 struct mlx5_vport *vport
 		table_size++;
 	vport->egress.acl =3D esw_acl_table_create(esw, vport->vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, table_size);
-	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+	if (IS_ERR(vport->egress.acl)) {
 		err =3D PTR_ERR(vport->egress.acl);
 		vport->egress.acl =3D NULL;
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index b68976b378b8..d64fad2823e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -180,7 +180,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw=
,
 		vport->ingress.acl =3D esw_acl_table_create(esw, vport->vport,
 							  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 							  table_size);
-		if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+		if (IS_ERR(vport->ingress.acl)) {
 			err =3D PTR_ERR(vport->ingress.acl);
 			vport->ingress.acl =3D NULL;
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 4e55d7225a26..548c005ea633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -258,7 +258,7 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw=
,
 	vport->ingress.acl =3D esw_acl_table_create(esw, vport->vport,
 						  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 						  num_ftes);
-	if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+	if (IS_ERR(vport->ingress.acl)) {
 		err =3D PTR_ERR(vport->ingress.acl);
 		vport->ingress.acl =3D NULL;
 		return err;
--=20
2.26.2

