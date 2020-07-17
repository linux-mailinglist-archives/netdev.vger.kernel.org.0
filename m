Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A4B222FAC
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgGQAFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:07 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:33630
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbgGQAFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:05:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bX4xNjzzE5ziLipGzkW/TqThddGURLbmmbJiG9UbfldUEcwbGZjvJEhIYei2121pOSsWXSeX9f3/cM789i+Z7yrWtMRNxkmqOZpWreAWu78nu3V2piLMwXwqMYqgyKVwlfMgrM7hT2OZG7g7oWlOZgZVv39jWGgn5SwCpQ1El8p3t/peioP1d8LEZWwq9WgNRFsxDgH08tHbSeh2qvv9P15RA2AR84gHkA+l6n+JXNjTElxjYB19g/ZexwsOdfRFiNZzRqvVY5WVuPCFyvhwIRL90fO7shYymAz4azHzA1uatCPaYOHBBjS/kiC8kgGsuOjxFt10iSBnF3fQ44Jdtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS8o16qP/Gh7NWN46bmIiEPYAcbL7f0pdUgm2S5EZbA=;
 b=lTipDV5F36NeXk8b3iHpVr3T9IXd+8r17OjUaoOglICumyunfE2f5bsjSDZqz7gZuPeZ3dsHrL6T+x/teB7gF0GqwaTZAdPRdCp+gVLC4uFg3dUwcdthOBUCjhmTjqEygZ3RW7/9h//EopDpwtviLfBXvvYeE4cYO1yDF12/NbUzuwdtMMNnPtmjRO9ycNzAgFbsdTkrPkNrbMKx/iIptCIN/Z5iFfc1RnXqWpYQLKVAT8xxl265ccsPgq6tHfiEm3BaHcXpfrLLIO1ilcs90BytVQllwSn8dRgzgXx2rdoe+Oo2nc8v3Vtg5QKc/RscmiEXRvZ3g4mOO8e1w8Evpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS8o16qP/Gh7NWN46bmIiEPYAcbL7f0pdUgm2S5EZbA=;
 b=Im7nc7nTtn39fXGMBE0znZuUuAGMTkkT19pRs0O1rFFLNeHXoL5nlkEEfMU3/c6PvCzF4cE16/f+Xi27zKJIbxZ2GcZ7oasGH24vqtrxu/CDJj9rNMyGzd0IMznnrIEFwvYwPBihwKurd0l47boOlSR0YH7APZzPd2Wyn8qrtzA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 11/15] net/mlx5e: IPsec: Add Connect-X IPsec ESN update offload support
Date:   Thu, 16 Jul 2020 17:04:06 -0700
Message-Id: <20200717000410.55600-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ae6f3098-b6aa-4fb8-db5c-08d829e50a32
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24484526E78EE05EC5E4AE43BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Udjgol4QVr0M9sl/kJtzDrFCXSfaV+nBTu//ZEA30Q3S+Bu31oqYdvQZFf896eAco4DUDq0xxEP6C2akZ8G8/quoIgCRVY3PNQwZ8TjEcpzzR01vkC4r1iLO9y/cv2gDGpDdCnHUYKtDPLsSDK5QS0J5xh+u+UgS/24EnQYQIGWky5rxv29h5R2FJ7vc0iNy9wUcTNN8UFsGnrpNJrSkEXsO2Uncv7ve0czKEQfyo5gUDM0QuEls43AqQvD1HA4aqG1etWKSBCNEMGjx1ny/i/tiUchhtS3fsQp1+6WJFFA+wfoYyW6sWMJ+Y79s/6qjQMsIewxNN333k+YaWTSn86tIdE3/nc6HhEnX1DeGMnNy7npbP3xEX1MVn1vpJ3pC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gC8Aan9CMYANN6YLGtDuabt69i9GkhlpQyKQdTP630yXiYbpYUEDG448WH2bACUr0d7pyis9UGU6+1QWJd7mpTPWCNqdTd/eSKUD9qk/i8iLIHs3guIfVmF7Ew0rGpV976FAzfszho4QQolXY7gTPIy7kC1KBKlzTnn2LQFsBQD7r/dWpURdTd0dOAibhj3Wvrj0dNktQ2+bApSRwvPSbLoDVxyIZBdmvlghxRuel5UO1XB5+OBZrP02RkyBMfmnylTv2yDglrMMT+x4+RxX/aHfGlcf8TYy7A89knjfeweo4553LINKQqX/E6WN7dbzN+k28gZVFeUYHGpNagJydtRi/WYKHO1fBYHdBhvRKpsD+5pXkVjKPc9s7va8IRaLF6YgclA+nWFKryranLnnJ5d2tDm4YKTvre7tdsKpCXL38scWS7JgY8A0mosys73QZGIi+vOCMjUL3I3m+pECUujTuZ87kZz7AI59ZrfX+aQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6f3098-b6aa-4fb8-db5c-08d829e50a32
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:57.2267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJ6gBp+1D9F7sWF3F84ohOqzg1UdttgpjzD9bnNL+hUiTRq77FqFkBDEEH1iyWYyf1D2oz278kjJrDQwZRJJ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

