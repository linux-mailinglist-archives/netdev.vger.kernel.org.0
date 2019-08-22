Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D3E9A157
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404535AbfHVUlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:41:47 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:41706
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731775AbfHVUlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:41:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8QB0as4WhSqM4vv5lFjCoVCWw2puSZGDfJG+avrKX/te7Juu7M8wsGW4kaeX3PUZZBk+CyuzTcA/zNYFyWadjCS2sNrxI4AtA7AJNjht2qrqvxl8bY4Cr14Ww3suz6DSibhD82ItaLo5kufZnUkGUdhHj9y7iCkcQEzR0YR86GdAuthXuWkL3X3e+7biesWzfrbxAnJQTdU9zT1mNuzbPSoYDTM+PlrnfvPj5cFzaBiJaGuKL2yT6cpvOFJqDC5FvooCH2q1g2vnAFySjctvCgKjMNX++QK7+7mRP9WTxNwGIPTKxt/0li13WW36kW1vDvLybQ8I24BOHBJbcNRhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPNV4UNN+cz8eocWf5xNuLAgnqT/GrUnuJ4ANNdk6SE=;
 b=ax2kkND7Rp/MES0ES5tYZ879N5JX82+YB/n86T/oX15mOIP8MppJ7fO41e7J2r7WejC0NBXAAZ+pMllKGD2oB6JL2e1gaCaZxLs8dR9GKUNX2XKD/TxpcgRGA7bocl6aaskB/y/f/+vcZg02YpVfcvlkbYJRlfe8VCU4+nG+DrjqxbzklsBZJo+hT889UpaeEca4VP3pLYcw/fIOgHkKMXEj5ynnu9akQMWb8wiRdgba82dnzRgp+3qwMF7A/hbpef5tzHqiY7efINm0tBHZkBi68f4K2I3TI5MHwb5WD5+B43ts8M5qQjMkh0MHatJ6zbJbdAyPCbO210v5x/Qhpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPNV4UNN+cz8eocWf5xNuLAgnqT/GrUnuJ4ANNdk6SE=;
 b=ghhNV5QQ/hpTnYV67VvNCZ8lGRgvbThnHN/kDNVcc/MciT4tPtjJSHs5nSSMapyaUtyry9y4HIDj2rvis+oRkMg6OdNQCvmYhcv6BKuhvSlSfSOCDoR62hv18xkuMJJYej7FHtBMwZkF1WJ71jM2NSZOmDEHvJKmaxldfflMwTg=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2724.eurprd05.prod.outlook.com (10.172.221.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 20:41:42 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:41:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/4] net/mlx5e: Remove ethernet segment from dump WQE
Thread-Topic: [net 4/4] net/mlx5e: Remove ethernet segment from dump WQE
Thread-Index: AQHVWSoBXWzh9hvP10OYiVpuvWRQkg==
Date:   Thu, 22 Aug 2019 20:41:42 +0000
Message-ID: <20190822204121.16954-5-saeedm@mellanox.com>
References: <20190822204121.16954-1-saeedm@mellanox.com>
In-Reply-To: <20190822204121.16954-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff9bfef1-7f90-416e-77eb-08d727412381
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2724;
x-ms-traffictypediagnostic: AM4PR0501MB2724:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2724006D54A1FF6532860A59BEA50@AM4PR0501MB2724.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(446003)(36756003)(316002)(54906003)(478600001)(476003)(66946007)(64756008)(11346002)(8936002)(81156014)(50226002)(66556008)(8676002)(81166006)(4326008)(66476007)(486006)(2616005)(102836004)(66066001)(386003)(1076003)(6506007)(7736002)(305945005)(5660300002)(66446008)(26005)(6486002)(6916009)(71190400001)(71200400001)(6116002)(53936002)(256004)(3846002)(14454004)(107886003)(186003)(25786009)(99286004)(76176011)(52116002)(2906002)(6512007)(6436002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2724;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 51EwsDjbQ3hqfFJePqlYIdKHr7OVIyHPzvulMnK3vcopSwor3XZuoHWjMWEx3P6fD4ZI/2tKJSoONQkmJqTP9tg7hOwdV1m0SCHZkvwSlosDkJEUYYBjxL3BTl7O+9hfzgl0SEZBxXxNj03fpEqKwuL8JdRoO5y2ROLRFet2mVpKJ3siTPY1a2SoVe56EISXR3e9rjfZINNd+KFw7Hbh2kx9qln9Xr9S1ZMvAW6IfTwyAvEZ7HOzrqluyLrkI1GGo/izy7oZkQ52yYHcEjzzdpy/3hE8T/XapR2/FGYvaBCCFTyjdtemDgHc4FhiYM++FmHPENJ7toFgN/2iDBJ/LNup8CsLrEstNG+zGR8lFzCGd6o3s2wCwQetbCgdHM6IwiSIEwwW0z94lDbsMbX2gjW6GhfFJSnaDBrO0GMUHNE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff9bfef1-7f90-416e-77eb-08d727412381
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:41:42.1457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BchNFOtQHzdUxaTIp0ZtA9dP6aayx9kVTzyIXo2BXdkqOf2CB2G6sE+sAz0MFo2rRkr3OXHtmkrsAnfgZuS3PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2724
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Dump WQE shall not include Ethernet segment. Define mlx5e_dump_wqe to be
used for "Dump WQEs" instead of sharing it with the general mlx5e_tx_wqe
layout.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 26 +++++++------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0681735ea398..7833ddef0427 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -250,43 +250,37 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 	mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, skip_static_post, true);
 }
=20
+struct mlx5e_dump_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_data_seg data;
+};
+
 static int
 tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		    skb_frag_t *frag, u32 tisn, bool first)
 {
 	struct mlx5_wqe_ctrl_seg *cseg;
-	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
-	struct mlx5e_tx_wqe *wqe;
+	struct mlx5e_dump_wqe *wqe;
 	dma_addr_t dma_addr =3D 0;
-	u16 ds_cnt, ds_cnt_inl;
 	u8  num_wqebbs;
-	u16 pi, ihs;
+	u16 ds_cnt;
 	int fsz;
-
-	ds_cnt =3D sizeof(*wqe) / MLX5_SEND_WQE_DS;
-	ihs    =3D eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
-	ds_cnt_inl =3D DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
-	ds_cnt +=3D ds_cnt_inl;
-	ds_cnt +=3D 1; /* one frag */
+	u16 pi;
=20
 	wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
=20
+	ds_cnt =3D sizeof(*wqe) / MLX5_SEND_WQE_DS;
 	num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
=20
 	cseg =3D &wqe->ctrl;
-	eseg =3D &wqe->eth;
-	dseg =3D  wqe->data;
+	dseg =3D &wqe->data;
=20
 	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP)=
;
 	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | ds_cnt);
 	cseg->tisn             =3D cpu_to_be32(tisn << 8);
 	cseg->fm_ce_se         =3D first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
=20
-	eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
-	memcpy(eseg->inline_hdr.start, skb->data, ihs);
-	dseg +=3D ds_cnt_inl;
-
 	fsz =3D skb_frag_size(frag);
 	dma_addr =3D skb_frag_dma_map(sq->pdev, frag, 0, fsz,
 				    DMA_TO_DEVICE);
--=20
2.21.0

