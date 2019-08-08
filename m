Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CB986B64
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404836AbfHHUWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:22 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404800AbfHHUWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM3HhSLLvnZOnZg3fHbuPXABNf91xJhGqwfZs0At3owWjZDmych2BOgi0APkl1wRO1GLnaaOqrvgSxKJLSHqk7pGfKWZiwlYhiugA6EMI2N1KRSC2eTr/W9AgorF539DfbLe88+Y2ttmpv5CB7SuyclWo7SQ4v9kTctiHodut0H0Wc2xxDttfGrGSO103tm+4kaZMxqP7/jElWYBjwg8CcMfDrgEdHQ2wNhyLSzmwZwKf2SbzWf5hF9fr6Bq5C5YXPj5kUEhVkI8VXdg4rsLg35rc33Gtr59CYuClPtDPQ4ovygBCvYd2S/gN9QoXm5W8ReTCCIZpE9utVTOu6d1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wx5CHL/eD8GqkCOTRWsyl8PEM6ReZ4o2cVAzPMOu4+s=;
 b=TgqqKVJKpm37YhqKByRTlMBtqRVqzFjyAiesVcfgL/fdFhiyDs6PyrZ/lryfGqHprflcvNR3c7aA45C1M6ra2t6DEKz2Tl8SlJilNUAFntf0lc3lEwBRw/sFKnseeLEE/IHs2Wbx3gTxgXRgoKk/LduKi3omE8jhatn6MAf13YYCYPY1CqTDpQwDX1bpmhW1Cmad3NqroPEgWxx7/o+g/xL8HIJ1Mq6Q99083+rryy4zSlztY4u0Pm2MiKw12c7JgmI8O34e44OG/FysaJgSzXpwpzccB8+LgeUQFCzfRloFZ4aDm/GmFlrMvfV7vJ+jbuzHq/pRMRugY6CQPO4+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wx5CHL/eD8GqkCOTRWsyl8PEM6ReZ4o2cVAzPMOu4+s=;
 b=XJF2Mql1eQ0GUjijDlSh8TAZoXxRdLoasJWqdUI+LiLMVID89RklVK6qTeItfjp4kd9XZyL8IMjy020jkwsppMeQ9Cux5M2GcQjJmkNQnAnvsCsEgt834/BV+8Kgi4XXXGEaCTrxir6OI+Pgi5nTh88bJjhymXj4TiKufS+dX3I=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:11 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/12] net/mlx5e: kTLS, Fix progress params context WQE layout
Thread-Topic: [net 07/12] net/mlx5e: kTLS, Fix progress params context WQE
 layout
Thread-Index: AQHVTib1OtUz1/RH9EWblEgJIutqtA==
Date:   Thu, 8 Aug 2019 20:22:11 +0000
Message-ID: <20190808202025.11303-8-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d75de4cc-0784-4188-ea07-08d71c3e180f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22576E879F5142703A67E63EBED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OW1RSDz2IHiyAY/MOsHW9pHToivbemzagW8HnrIMQhEiBn2v36lq/H5p6ugcG0JbqZA9GzMCTcED79Rn0VAbJqEx+Y1v/7TBNQ0/2rkCMTeK16Zsknva5IbJtmjlbxb7lJkBZqJS+uSDZpIHV3FSnxmhcqWKasTmn5JtmqW1zDkvMIzSu++rWeAmtP9Iq5XqDkBE8KEm/EY9HTee8LVLOKVqbmS89CiDYd96vMIci0v1XMyo/buKNtCvlFNx7ez+RvsSi4GpTQl5vWF03ztxSILvLnnmqdQACOJpHwAohVoQy2cc0pAGUyQ1u0GbJqpNdy8Gz+FEby60PvGL0ADfQJk6z5PLue5+Fx/+XQqB2U9QX9KcN7yfvhs6YOhtkRI08oD5soIkqh/4mUMj0BSpwITDQ11JNTFWivU+csXfYpo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75de4cc-0784-4188-ea07-08d71c3e180f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:11.5639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WraOBwexZNJoYdgOEfCd9ZzF4kGhNer5J6ykqa6s1YTjCjCYaxwWmmB7ArQYhEjjDSuKpANmtmPOLvvY5y+pcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The TLS progress params context WQE should not include an
Eth segment, drop it.
In addition, align the tls_progress_params layout with the
HW specification document:
- fix the tisn field name.
- remove the valid bit.

Fixes: a12ff35e0fb7 ("net/mlx5: Introduce TLS TX offload hardware bits and =
structures")
Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h             | 9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h  | 6 ++++--
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c   | 4 ++--
 include/linux/mlx5/mlx5_ifc.h                            | 5 ++---
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index ce1be2a84231..f6b64a03cd06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -184,8 +184,13 @@ static inline int mlx5e_get_max_num_channels(struct ml=
x5_core_dev *mdev)
=20
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
-	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	union {
+		struct {
+			struct mlx5_wqe_eth_seg  eth;
+			struct mlx5_wqe_data_seg data[0];
+		};
+		u8 tls_progress_params_ctx[0];
+	};
 };
=20
 struct mlx5e_rx_wqe_ll {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 407da83474ef..b7298f9ee3d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -11,12 +11,14 @@
 #include "accel/tls.h"
=20
 #define MLX5E_KTLS_STATIC_UMR_WQE_SZ \
-	(sizeof(struct mlx5e_umr_wqe) + MLX5_ST_SZ_BYTES(tls_static_params))
+	(offsetof(struct mlx5e_umr_wqe, tls_static_params_ctx) + \
+	 MLX5_ST_SZ_BYTES(tls_static_params))
 #define MLX5E_KTLS_STATIC_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_BB))
=20
 #define MLX5E_KTLS_PROGRESS_WQE_SZ \
-	(sizeof(struct mlx5e_tx_wqe) + MLX5_ST_SZ_BYTES(tls_progress_params))
+	(offsetof(struct mlx5e_tx_wqe, tls_progress_params_ctx) + \
+	 MLX5_ST_SZ_BYTES(tls_progress_params))
 #define MLX5E_KTLS_PROGRESS_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_BB))
 #define MLX5E_KTLS_MAX_DUMP_WQEBBS 2
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 3766545ce259..9f67bfb559f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -80,7 +80,7 @@ build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u3=
2 sqn,
 static void
 fill_progress_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *=
priv_tx)
 {
-	MLX5_SET(tls_progress_params, ctx, pd, priv_tx->tisn);
+	MLX5_SET(tls_progress_params, ctx, tisn, priv_tx->tisn);
 	MLX5_SET(tls_progress_params, ctx, record_tracker_state,
 		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
 	MLX5_SET(tls_progress_params, ctx, auth_state,
@@ -104,7 +104,7 @@ build_progress_params(struct mlx5e_tx_wqe *wqe, u16 pc,=
 u32 sqn,
 					     PROGRESS_PARAMS_DS_CNT);
 	cseg->fm_ce_se         =3D fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
=20
-	fill_progress_params_ctx(wqe->data, priv_tx);
+	fill_progress_params_ctx(wqe->tls_progress_params_ctx, priv_tx);
 }
=20
 static void tx_fill_wi(struct mlx5e_txqsq *sq,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ec571fd7fcf8..b8b570c30b5e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10054,9 +10054,8 @@ struct mlx5_ifc_tls_static_params_bits {
 };
=20
 struct mlx5_ifc_tls_progress_params_bits {
-	u8         valid[0x1];
-	u8         reserved_at_1[0x7];
-	u8         pd[0x18];
+	u8         reserved_at_0[0x8];
+	u8         tisn[0x18];
=20
 	u8         next_record_tcp_sn[0x20];
=20
--=20
2.21.0

