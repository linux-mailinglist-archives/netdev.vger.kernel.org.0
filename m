Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EA32CB069
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgLAWnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16007 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgLAWnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d90001>; Tue, 01 Dec 2020 14:42:33 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:29 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Fix passing zero to 'PTR_ERR'
Date:   Tue, 1 Dec 2020 14:42:06 -0800
Message-ID: <20201201224208.73295-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201224208.73295-1-saeedm@nvidia.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606862553; bh=2yOP/XfZRWezrFLexyH7QMVCpJQJKz/rLLVO0RjbmwE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OktSj4YTD2FZKBd22LldqYC72IssXSREmt5O68CfYJsHuktDPPhcdATID6F8uPV/E
         6IizDXSjTudskFdilEYffoZHSDWBp8RL6aeYZ9NTaw/PgM3DfsSDSVMnRwXhsgrVhZ
         ViwG/3jc3fSV4K6/+h59tzuEKdD6nx3qCVxaD6DIzmGTvvuCwknbhOyxtNy2cF7t7V
         6k5joHZ7mwk4dOmOMC7vTU+ZJ05EUs5Kly7xfjY4K4nk8A3OWGjRadYMOFnZJwvfNC
         FXs39oLooAB68282vNLmHsPxKN5+6TQEapS1C7DmKy+KkA8VZgUsjHWUxlM4ul5/xo
         ZGvzK8UZQQDyw==
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

