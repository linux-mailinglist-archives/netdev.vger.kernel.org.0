Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40729A4FC0
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfIBHYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:24:22 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61185
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729416AbfIBHYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:24:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esyuQ8zDc16Sirnc/kyQZrhT8y/astRA6PV54za3Gz8aiJlXSyiKuSu/eO5ZsBv/b7fw2rtW7puMG9qkTpiUEhH5SxxaBhPLoa4NDwna5eqVFfGqndHpFA0i0CD8bFjXcoIfyv/ABjGGJ0dJfnQcuX3jwATvGkkD7+JWDebtRLP8PgRcESyIS+LDBio4RfuadM/91GTq5lG/2HtuYlZa2E6QqxbgEcQ06v9qfVT4SXnhQ6FeoSTY7d+0qdlc2rD8AJ+9HdSiGn+49rHydyqeFx3UHMjDs9EDQIR1U3Q2Jhxa8pjxrzXvnLUtXtc+Pux/4Qb69YXYC9jZAYI7CugyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Oz44D93du4nOr8PwKE+PMKNIgFknNvJKq9s8ssLCSE=;
 b=f9d8mcUl3AAsOqD2bE20/q0v2zHCeGWvRUc0Nlfq2oaSAtIFx2UBsZpeL6BR6ELTgOS8XlI9AAaIzb3+6aV+sNV4K+/r4NJqIBd4zIosiQGka/knBxJQEyvrqoOeogPc2Qd15e0svmcssPO5Bpfkz1h2vd0EHny/V0uJ2bRZwi6PpUUl2bFUJ5tzBD7CKXwni2WeN96hCN+fIoHGvZjewkSx8fwMjeThe2cE1VNYtxLV4ug43AoHYT+yZstfVBM4iqM+zBzYS2/Ivr/+3vQzSai1W2lZHCpu8QbVn91cEYZpcsUI9XwNWpgRyLdI/WjIPEf5k0dlCh0s3NyJBB06yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Oz44D93du4nOr8PwKE+PMKNIgFknNvJKq9s8ssLCSE=;
 b=aEBoCVSlP3rIptuOOA5rZaXcRE0Yyq86x+KmHO00ZpMO+PwzL7N2F7mtu5yvv9+sYhUjC5+vv3SIuPNrz0KYWDI/tUtvC2gluuEAgpQjSMVm5wO0WOofUOpOzSj0LgZxFsCjqPpGqfofwuPVnP8TDGoBF5KDJR1eQCyLenWtHCk=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:22 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/18] net/mlx5: DR, Add CONFIG_MLX5_SW_STEERING for
 software steering support
Thread-Topic: [net-next 14/18] net/mlx5: DR, Add CONFIG_MLX5_SW_STEERING for
 software steering support
Thread-Index: AQHVYV9Nue0fIg1o2EONLSo44EGBXg==
Date:   Mon, 2 Sep 2019 07:23:22 +0000
Message-ID: <20190902072213.7683-15-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0767586-acd8-4000-bd9c-08d72f766f80
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22598F628E5792BAFAC43235BEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(102836004)(386003)(6506007)(2906002)(26005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QTtXc/drCEpz597aWB5H7prOQ35ljJO0C1GMwoR5b/v5XJ8dhsYy+3iitOZEhIk+FTtgdoO+HOnxi4YWthjOLB0gQcOzV77zUkXoYv61G3VAM0ArFqfluOqbK/kwhnMgrrtH9ZaQktka+8Haj22mpGYQ8Cgoy/mLDfAj6TOajBRDE0HpYWi+fvv96EmhyO+27cxb+1PYhxurDLdGtW+UFEwQhkkYjfyFXLTD7c19IrMZ9J1HNXpaBqBFWPnozgFpIwP+IsfI+7g969uFyZn0HE0obTITX9QGFg9z3mF5/VMeYbpF2/Sf7ifuXX1BQl2qeYZLIlHGIfoLfYs7hkdC4Lq+5d1S4bOagN8XnBwqnq7lx7gRV91edUkzNQYdZkNOqcPcIKslqwveplxOLvXu8tycKZdPCrAyP1Xx8xmcs+k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0767586-acd8-4000-bd9c-08d72f766f80
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:22.1538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fvz8MLfgvX3B8stktS1sktsqm4cKpjtIaf9fQy7PttRHidvW+f/yW9822e9XWhoyOnFISET+hEefxLafiGyaUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
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

