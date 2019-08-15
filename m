Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816BE8F506
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733168AbfHOTq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:29 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:51424
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729779AbfHOTq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:46:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikPfZfLIDUEC4Kcwy7v2zigY4TAdDiQ7N5PghaKY72N67+bsPu1lpYDGKsTCsTOLNJtE0YDeHQDBxuOaVxh28TsL1bX6WT8aIQTVvQEDHzkFJ3UwH0kKhao2LL/O/lY7upDmvTpDEBMevtZ0I1S00sriNedtLq5NCMqACbvB2Os+5fR7j1EhJBw9O5M2nXLTzuhRZo0Q/EMlGnMUXH45Y1jsYv5jf61EtiO9V7XUvdfHe6A+U6C5vDd/hrVxz7Xo2wwabsn9y5+hv9ENUjzdHvkRGMrBJZPDujyheSxCE3neEI/B2kgOUg23g2PDg1M6LDP56DaQaLXrVHkxBmzQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDyEgUKyvrx8sdtnnrqJD8uiwHNukYUrjhxxfNlAfkM=;
 b=lnuwC37BuQ65C6l6EVecdWzRGarnb8n4WZRhoYKN4HY1QUNYBZGCB73D1rp83dh5gbV9w90wmnkZkJcB9U++JdTfthNKpZui+hhdgO0hJREmTBnpvZoJd1XNNSsXCCYUNYikZ6HDfTEho0GwQwMpR2yux4jMSLSB71KRUufoHL1TASznhZ6kJ8XcH3BNVgUIVfcEr0Y8xVJZy9C9/dMWbTDhEOtBNvASMWaHJGz8ySU5rn6aqyMP9pzuhMPBs4yxMePRr/PL2UE8zfpHgKQwbDHU/EdIrNyDbZ3QJKaZVOKh5lH/AfI3wwtXNc0rTRj70iV9capdVtFNDe0e/rI7+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDyEgUKyvrx8sdtnnrqJD8uiwHNukYUrjhxxfNlAfkM=;
 b=G7vIMYyRgd50lJrVAATEb3jDIVbz/6pzSnPxDDh6Q1Vkv5K7wkg1sxjHzVFdnaYkHHZBvTx2S1P4vgo+eWaOjpxmXSQAdi3PzJ4wftMstRQglVnMHx+CzSWWrYvOvj4OAaj9ZKwKS/qAlw9dLKER+hZGXAHxZQqTFjXOMm2LwMA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2693.eurprd05.prod.outlook.com (10.172.226.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Thu, 15 Aug 2019 19:46:17 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:46:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Add support for VNIC_ENV internal rq
 counter
Thread-Topic: [PATCH mlx5-next 3/5] net/mlx5: Add support for VNIC_ENV
 internal rq counter
Thread-Index: AQHVU6IXPC8L13wJmEq6DAsJL/7KVQ==
Date:   Thu, 15 Aug 2019 19:46:11 +0000
Message-ID: <20190815194543.14369-4-saeedm@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4096c19e-7d90-453f-3b01-08d721b939a7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2693;
x-ms-traffictypediagnostic: DB6PR0501MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2693E135488FD46C661C9700BEAC0@DB6PR0501MB2693.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(199004)(189003)(478600001)(64756008)(6506007)(186003)(102836004)(476003)(66556008)(26005)(14454004)(66446008)(86362001)(2906002)(25786009)(66476007)(66946007)(3846002)(4326008)(6486002)(6116002)(6636002)(76176011)(386003)(450100002)(53936002)(66066001)(107886003)(5660300002)(1076003)(71190400001)(8676002)(71200400001)(256004)(486006)(54906003)(6666004)(81156014)(8936002)(6512007)(99286004)(36756003)(305945005)(50226002)(52116002)(316002)(6436002)(110136005)(11346002)(446003)(7736002)(2616005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2693;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eNV867H7Lz4hHsxypuoPAqSudFEwhiOGL7sLVNW+YEVNApEhUkNHyXFlPNVPiJagndZH+sqPn9pLjw2K21uAq9UioCYF+AzHffYzlzmJHphuHgyC7aSA+TzsQDQgsfGaHjYly4G/YZylperxIFAJwnSnaVkkdRsBPkhqvPLhGm1Kr6zu9WxoefIyLS74LC3DjDagggZo4KovMngDA8JER9R9Nab2koDvSt1tuU9J9LzxkApQh8I1UVVDUyUMKakkUT7ak1ufl3bASYXWRYIaRV/N74fUQtLUhF9OCNmpdl+CbMBjV+FYXpCNcUN8ZeyxEuzv2PqRqETdJbmEt5VrxWz1fxbM/WGf2GjXoZ5JK0OAyWor/Mn+EFrxyKRrudKuvpc806B47BxbN7svD58pv98FmDBNpioXW6zZiQtp/7w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4096c19e-7d90-453f-3b01-08d721b939a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:46:11.9800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i1451xr5Jwjw/d/uPsJoXtPzFltl1gVQsgto8JJMGhb80jgsqZxVmITxMDTg17j8EUrJrIm4chyHfm+WJd3Vcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2693
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Add mlx5 interface support for reading internal rq out of buffer counter
as part of QUERY_VNIC_ENV command. The command is used by the driver to
query vnic diagnostic statistics from FW.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ab6ae723aae6..c788f895b350 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1116,7 +1116,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         cache_line_128byte[0x1];
 	u8         reserved_at_165[0x4];
 	u8         rts2rts_qp_counters_set_id[0x1];
-	u8         reserved_at_16a[0x5];
+	u8         reserved_at_16a[0x2];
+	u8         vnic_env_int_rq_oob[0x1];
+	u8         reserved_at_16d[0x2];
 	u8         qcam_reg[0x1];
 	u8         gid_table_size[0x10];
=20
@@ -2772,7 +2774,11 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
=20
 	u8         transmit_discard_vport_down[0x40];
=20
-	u8         reserved_at_140[0xec0];
+	u8         reserved_at_140[0xa0];
+
+	u8         internal_rq_out_of_buffer[0x20];
+
+	u8         reserved_at_200[0xe00];
 };
=20
 struct mlx5_ifc_traffic_counter_bits {
--=20
2.21.0

