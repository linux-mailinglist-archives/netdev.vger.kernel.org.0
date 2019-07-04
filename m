Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EF35FCCD
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfGDSQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:26 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:28482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbfGDSQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSBSl+WPa5S0DjgqrtLam8CmwAoGNmyKNudMxCS8jhQ=;
 b=g1+IqAboqv4x2PjauBTscyix65Kt4sp98kcdLdP/h+N4NqBXWhqOyn51zVbaroyzfOwimNL+YkiWkVu0RX0mSnVgCCjQwXFhQEEchCkCfHkrVEwWJEfrZKPJQ1t3PzFsMR3pjcfROhllCqe4NzQbJJcKK/9ulnYWgb8zMFhLoq4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:12 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/14] net/mlx5e: Introduce a fenced NOP WQE posting
 function
Thread-Topic: [net-next 13/14] net/mlx5e: Introduce a fenced NOP WQE posting
 function
Thread-Index: AQHVMpSPCEWYw9puoUyUmfUQlm0oXg==
Date:   Thu, 4 Jul 2019 18:16:12 +0000
Message-ID: <20190704181235.8966-14-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91aaeb95-5ee6-4d2e-3e6a-08d700abb20e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB25848A899A5FDB1CA7884EA9BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dZs7ET+GlfMOwP1S37XLkpHczAqGEQmegRBnNWGRufxTIpiWyrC4yIxIPR04snGhSgkcgsUmnObKCb8IUhT0yP9BVyGN3/k0SXVToW9t8UxrsZ9iMP/DuvHaIfQYDi8bHjV9ug4ydONNBzJw4vzNYhtjn+3nvGB3fLuNf0ATaKbe782q/IJERkHHpvyEGm2+AxovsXliHpP6wdaEEclkWxH4SqsoDbmS37LwathsvRs3sHQc+ADAu3tZ1OrrjmFIyELzzSkdLZ5nT/1Cm44Pialbeaq/bZW3eD7OXFlGMmUH49cgIl7uxQ+AaImcQqDEOCowbjPJutQbteKn289ts6o5r8loKcK0r42oIpUJq7ilPpkClnj4ASEj0hn65oK18AWUyAl4MJPyotyOpWu0e79gu7bf3yRvtNhxeNeyqD4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91aaeb95-5ee6-4d2e-3e6a-08d700abb20e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:12.7323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Similar to the existing mlx5e_post_nop(), but marks a fence
in the WQE control segment.

Added as a separate new function to not hurt the performance
of the common case.

To be used in a downstream patch of the series.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index af6aec717d4e..ef16f9e41cf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -58,6 +58,24 @@ mlx5e_post_nop(struct mlx5_wq_cyc *wq, u32 sqn, u16 *pc)
 	return wqe;
 }
=20
+static inline struct mlx5e_tx_wqe *
+mlx5e_post_nop_fence(struct mlx5_wq_cyc *wq, u32 sqn, u16 *pc)
+{
+	u16                         pi   =3D mlx5_wq_cyc_ctr2ix(wq, *pc);
+	struct mlx5e_tx_wqe        *wqe  =3D mlx5_wq_cyc_get_wqe(wq, pi);
+	struct mlx5_wqe_ctrl_seg   *cseg =3D &wqe->ctrl;
+
+	memset(cseg, 0, sizeof(*cseg));
+
+	cseg->opmod_idx_opcode =3D cpu_to_be32((*pc << 8) | MLX5_OPCODE_NOP);
+	cseg->qpn_ds           =3D cpu_to_be32((sqn << 8) | 0x01);
+	cseg->fm_ce_se         =3D MLX5_FENCE_MODE_INITIATOR_SMALL;
+
+	(*pc)++;
+
+	return wqe;
+}
+
 static inline void
 mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq, struct mlx5_wq_cyc *wq,
 			u16 pi, u16 nnops)
--=20
2.21.0

