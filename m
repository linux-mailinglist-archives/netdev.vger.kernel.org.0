Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E17B222E11
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGPVeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:23 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:32841
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727101AbgGPVeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tm6LGT47tDccl0WRQSoQs3yiN/wNQ6Hl9t4i6FVstJ4AwxsFxXO4k3VYjViKfmJegU5i0uHZB5NFygwVSnmSuPwZyhJmg2NpHARPTBzKCZx98g08W2bgk7JHQ/6sbPxppUmZu5xnjsTuQnERyq6x2UjwDnCNKPh4X/TjcxRExmywIysRgnVx89oH7+Sh5RvHNRTT+4HqwkJ67/9yxT3v+SOhMNTWEvBNWL5zL9Ti9D2CfWaMOtd1k3Na1X9ww9NDqiYhihS/SEQjdjt9sLxTfpC4pFBprI8CJn+LqsiYpXscRS1Zc56mGaj+GKjisHTeYhHLQtvvPadW+osUyWhAcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS8o16qP/Gh7NWN46bmIiEPYAcbL7f0pdUgm2S5EZbA=;
 b=TDusiObkaq3U5+SXoN1MSFwbY9iH69/CmjPn+hrZWEjqOnnCBR4NSjdIsRYy9qH3HeH3dlvRXjQDlIiRM6mR8v5ulNY8LgVLGL+qqEJk3YxUWoUHrDx6HUobozfpwPmg89KId+Em/gKRTvbm2WEbDDxcrMDARXzglxpTjVc6VhlGrwj8lQjCN0sfufRxSAvI6fQKBhhqR370auXSNoqEqeSZuJ5nIRKTFBnXgD8ywUt7CBQBxweZG+qUHjxwx2GkSk6RK8PuhIqZw0Nik8mohQgpNn7RAlQaY/4qNNc6wLL8MKn/zISpnDalZ3udu6pePgfxhWOqsTOMglM4RX3zjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS8o16qP/Gh7NWN46bmIiEPYAcbL7f0pdUgm2S5EZbA=;
 b=P7ae8hosjWL14xmLgPngnPkfNOKDdCwhldOT70aRmHM/OkPzz+f+7n8qpDG4F9WRSeaXzldyH7GHAk+i/peaoPu0xW4DWeBoNWgH+xMTItcAhFcxwPQGNiNwyj/gHN/ZH8X2C/3PCrwmx+v5+PpC7l536nTEmx33MCVbApYAI9E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/15] net/mlx5e: IPsec: Add Connect-X IPsec ESN update offload support
Date:   Thu, 16 Jul 2020 14:33:17 -0700
Message-Id: <20200716213321.29468-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 995f37d1-9c31-48e3-a4e3-08d829cff7ab
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB29927EE501D3CB9146CCABABBE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HwO40H6qNaEp8xzUIodkZ6hJNbJ60pHt733R66BRANPNwDS3n0F7ht4WPRP3rfYOoGx+CLjVNSkXP8/e21oi2GsMkSevT4RZsLDlMjW8HbRBR9+mx9uZm9lMjUgIAywYw9kzMrOxEF0eXk7WocjBkEzkveSSJepLXHHi5CH4OLDInn3yoS9BlRxuoi77BtC5q93ekpdVcthCi+jl4//CUBCmKnNZSW1sIjZ4YpHGzS96OYxPYgbgquK4ceAOUlFyr17xlNeC8fnwi133joFNG8EWr87tFgYLRGBKB+hf/yrO5Oi4HNb7OUo725AzilIo7lJVz0Ljg+uKXk/6zZAHKlqHRn5axdEw/yX60BdtAmNHbwN/o4MjiEKzvJCbbB6I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GGv0li/sW6mPJnKbGTZAlJCWLFTjgiQ9QDsDUzCPpa2ojLqTgYlP2W6EKjfW2WtCx1nL/r1dZISj/oV8lsK+7hFMeyEGOTbRlxkmxxyQX3CjOGVinKbkH9tBZkyBVOvaA5hyd20SqTj/EOoBkTxd2DeuK3uYYDQX7LcFGrBU2+lo+drDzrOg5y0CplmOjrFD+nC1t2JJTN61QC3XC89IpEtkV33YAs5PwASHV80UNJ+nMQNmpzDfwasPmaG1Q+SUnubL3d44kaOp5zMQd7g8N1McANm+eA4HUatZDh9Pi7HPFy+mzTe40sZJhinsA0f3RVNJcpwpxbbbLE0OB74Kt4t4HdUboy7nYGpYgJdrQWU9iMdOwOngsg1jY7/9S8Zm2IKWj46WLnzl/zi0hFZc/dzXvFAw50ihjzQ0F0YFxWBFOfyZZ1Q8K5v6IBV+vL2YrspEcA3aT/MVuJCW2ptQStbLoH5Gtbl3MbAIdTnAv30=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995f37d1-9c31-48e3-a4e3-08d829cff7ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:06.5284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UV71jKKdD8r+Zp5ycvTEd3SKel0BTgdISVtzhMSeS6iAi/sDWtALYSy+VbhzgUG24i7lB0jlK0TS22pDWDuQQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Synchronize offloading device ESN with xfrm received SN
by updating an existing IPsec HW context with the new SN.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/accel/ipsec_offload.c  | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
index c49699d580fff..2f13a250aab3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
@@ -279,6 +279,93 @@ static int mlx5_ipsec_offload_init(struct mlx5_core_dev *mdev)
 	return 0;
 }
 
+static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
+				 struct mlx5_ipsec_obj_attrs *attrs,
+				 u32 ipsec_id)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_ipsec_obj_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(query_ipsec_obj_out)];
+	u64 modify_field_select = 0;
+	u64 general_obj_types;
+	void *obj;
+	int err;
+
+	if (!(attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
+		return 0;
+
+	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
+	if (!(general_obj_types & MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
+		return -EINVAL;
+
+	/* general object fields set */
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_IPSEC);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err) {
+		mlx5_core_err(mdev, "Query IPsec object failed (Object id %d), err = %d\n",
+			      ipsec_id, err);
+		return err;
+	}
+
+	obj = MLX5_ADDR_OF(query_ipsec_obj_out, out, ipsec_object);
+	modify_field_select = MLX5_GET64(ipsec_obj, obj, modify_field_select);
+
+	/* esn */
+	if (!(modify_field_select & MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP) ||
+	    !(modify_field_select & MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB))
+		return -EOPNOTSUPP;
+
+	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
+	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
+	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
+		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
+
+	/* general object fields set */
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+					      const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
+	struct mlx5_core_dev *mdev = xfrm->mdev;
+	struct mlx5_ipsec_esp_xfrm *mxfrm;
+
+	int err = 0;
+
+	if (!memcmp(&xfrm->attrs, attrs, sizeof(xfrm->attrs)))
+		return 0;
+
+	if (mlx5_ipsec_offload_esp_validate_xfrm_attrs(mdev, attrs))
+		return -EOPNOTSUPP;
+
+	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
+
+	mutex_lock(&mxfrm->lock);
+
+	if (!mxfrm->sa_ctx)
+		/* Not bound xfrm, change only sw attrs */
+		goto change_sw_xfrm_attrs;
+
+	/* need to add find and replace in ipsec_rhash_sa the sa_ctx */
+	/* modify device with new hw_sa */
+	ipsec_attrs.accel_flags = attrs->flags;
+	ipsec_attrs.esn_msb = attrs->esn;
+	err = mlx5_modify_ipsec_obj(mdev,
+				    &ipsec_attrs,
+				    mxfrm->sa_ctx->ipsec_obj_id);
+
+change_sw_xfrm_attrs:
+	if (!err)
+		memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
+
+	mutex_unlock(&mxfrm->lock);
+	return err;
+}
+
 static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
 	.device_caps = mlx5_ipsec_offload_device_caps,
 	.create_hw_context = mlx5_ipsec_offload_create_sa_ctx,
@@ -286,6 +373,7 @@ static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
 	.init = mlx5_ipsec_offload_init,
 	.esp_create_xfrm = mlx5_ipsec_offload_esp_create_xfrm,
 	.esp_destroy_xfrm = mlx5_ipsec_offload_esp_destroy_xfrm,
+	.esp_modify_xfrm = mlx5_ipsec_offload_esp_modify_xfrm,
 };
 
 const struct mlx5_accel_ipsec_ops *mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev)
-- 
2.26.2

