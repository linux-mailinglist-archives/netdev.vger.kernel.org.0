Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4AA743A
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfICUFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:38 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:24054
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726946AbfICUFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvVnmcmmPfzD/nF7+WBn2XUkwvxfpZ4EqSBEybVnhGIYB3mOXBLNGqA5INY21hU9sKXZ5HCg9kVGTMJpgbzYC96hSUkGAonhtmvrSl7bZl7V0Tyx5xdaWXrIiK5nHYGAaHumAGWBS82WhLLcEh8bqgi+b2NnjwqHHGMQ2DCEOT8X0gCxi9G/20SBAHXqR9CU3U3k3iVbdnoRzE1yXL4UcYL9sh/I5t+yRDt0a+Tu9HqEcr+Qvmsx59xCeOwgg3JgG2fPYlrhqmEqtDCsvU1exBhu/TEu+la2ovGQ2i5ZAJO5+YFRE0fstk7X2D3r1Bj4VWzbCzan99i5rHregm6s7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Oz44D93du4nOr8PwKE+PMKNIgFknNvJKq9s8ssLCSE=;
 b=OWv88b6a2c2tgrLA0P+1DA6bC80oWY+nPYSkg4f5PQkyGRUYaOcP2PchHpBqK6LjhvKMaJlVe+8U8kOXjK/E/TLfaXZV0S7FR+ONO0NVqyuJ5PBwFUiu5QZmK7da+LCFtlAaOzf5tjg1oB2xoILfbFxlzPB8GP0S4DLQhWWBJE4iLJ+bcsP//O6rDkCXZD+HPHCW+0YhurLXhgnFmFB4lKzbxgxAsqAvfZtZ9llkOjhsVCmDertPposPP7ZF93Q9+hdFy7NhsG/b1EjrRX8ljAPB8ZODaxW/8zisobn3lMAgG+SCbCx+4kbgrPd1KlehkBx5DTFZZK6mlRoswVpbQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Oz44D93du4nOr8PwKE+PMKNIgFknNvJKq9s8ssLCSE=;
 b=Vc5oQHltaxAJMzOGQ9SzRtrZewkzunc0UOshbNgCfw20mrn/BD4Xd85ETPnOkARTiQPLQL/+J8+gtP7NU3rhsRQrY/0Yr/39rYWWLpPdEJ9v84r3cucLubz9ANVSPsCKkiPdsE/jXsyvG7dU+H18OQXQ/xp+U4BUvmBAjagYPv8=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:04:56 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:04:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 14/18] net/mlx5: DR, Add CONFIG_MLX5_SW_STEERING for
 software steering support
Thread-Topic: [net-next V2 14/18] net/mlx5: DR, Add CONFIG_MLX5_SW_STEERING
 for software steering support
Thread-Index: AQHVYpLbS9WzEUftrU6lY7YQJbj84A==
Date:   Tue, 3 Sep 2019 20:04:56 +0000
Message-ID: <20190903200409.14406-15-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e60fe4dc-f647-414f-469c-08d730a9fe0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2706A29050D12A93048EFA43BEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9I/Mbqrd+l5WQXxW6icIo05qbSkYM8Dvn/srETb7t3M+RwNZPbDpzN0kCxyxglcWIOxZpRMhM8xGznbxYKnnlu+fBoqX3YLNNrcr5eZgldcpJhwziZ6TcQtMluYEohEJvkvflbk59KE3/eP8sIoLTD+ri4+HZyVxpRQTvAilvbqQSzLWHgnert6A1T4z77t4PLMqK9ARREFF/t1WksdhX1VCYQFb9X4VUlhazLvu73z+17Z0074Ab0JyfamgFf2LG2p42rnjy+3F309zgLSkyps6Qct6RoGKCQ+CjquEulXDxzbehcwJ7qO1IXZJgCfGOyWM4VilOZE7THR/TRxd5QXKpTfS22uDNtMZRBvlFAFBsT6/9Aci6hLKm5kAvJ29rRq1Wq382bjmhEEAQPqtYCzNACkD7zv5AP+c56Y9N2I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e60fe4dc-f647-414f-469c-08d730a9fe0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:04:56.7951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mVop1SwmP4srKmBOOD6p/P0YCKyNCLVxDcYA3KamwC9QcD4J1SlKrQv6LO4zuVegQA2WOGrM7aGpmsC1G5eg1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Add new mlx5 Kconfig flag to allow selecting software steering
support and compile all the steering files only if the flag is
selected.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig           | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile          | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/steering/Makefile | 2 ++
 3 files changed, 16 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/Makefi=
le

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index 37fef8cd25e3..0d8dd885b7d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -154,3 +154,10 @@ config MLX5_EN_TLS
 	Build support for TLS cryptography-offload accelaration in the NIC.
 	Note: Support for hardware with this capability needs to be selected
 	for this option to become available.
+
+config MLX5_SW_STEERING
+	bool "Mellanox Technologies software-managed steering"
+	depends on MLX5_CORE_EN && MLX5_ESWITCH
+	default y
+	help
+	Build support for software-managed steering in the NIC.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index e9163875efd6..716558476eda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -67,3 +67,10 @@ mlx5_core-$(CONFIG_MLX5_EN_IPSEC) +=3D en_accel/ipsec.o =
en_accel/ipsec_rxtx.o \
=20
 mlx5_core-$(CONFIG_MLX5_EN_TLS) +=3D en_accel/tls.o en_accel/tls_rxtx.o en=
_accel/tls_stats.o \
 				   en_accel/ktls.o en_accel/ktls_tx.o
+
+mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_domain.o steering/dr=
_table.o \
+					steering/dr_matcher.o steering/dr_rule.o \
+					steering/dr_icm_pool.o steering/dr_crc32.o \
+					steering/dr_ste.o steering/dr_send.o \
+					steering/dr_cmd.o steering/dr_fw.o \
+					steering/dr_action.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/Makefile b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/Makefile
new file mode 100644
index 000000000000..c78512eed8d7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+subdir-ccflags-y +=3D -I$(src)/..
--=20
2.21.0

