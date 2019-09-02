Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A277A4FB4
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfIBHXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:31 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:57541
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729529AbfIBHX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AA3xZrsItlqyDtBPfPEowSzE39lXaPfWpUsNhVo7LmIbRUh+lgeFqDEcf8dCNE5tJMgBQDc0KzTTN9GPc7vVR9Y+Yh9HagNHkCrhgvI0c0n5IjRlccisqSM00qbOC0aRpRi1Etu+xHg6UKCMKNhfydUK3rXCOTYe2opv0ws1M9xfjOckoBhB0FSAU1210YLGN5cvZjfYMh2PQjEl2lAatKhTboQcZTCXlSSDEfkPf7xeMx5cdykSoJpcd9ul/F650L6XHhFx5Dkibcs8G+VrCdslJH9tm5CqMeHCJ3euukhMyB7sgYggq2EkN1p+ddID6EUeWbwVIA4oNlUj93iFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBdoHsGKqEAIOcRsI7OXDnuZq1MX0wqIXz8lEb1Q+Ek=;
 b=hWeztZGsYw2fzOpeh2mpGr5sj9AVIFOzTgHDFZYuQ6cqLNCcSzfkN6ynIyc3osN3Pdx6h45FEE8ghjSKDRBYEtzuFSjV9ON4qK+nx05+Qot5rjVVP7Om8CDXXVwasalqb3vmyAVzT8ou5xCl1/ir19vU814KOHPXVHm0iUiJRatap8UCDEf6Y3H3VspXow6gwQpxp7BOJrUvqAKMZN0v+1QUAMgXXZzsWvv006bSlCZP44vVZPa15dapsQkuGCEtHmSyfImYlZxlhG4aGOYh/THH5ZJtEQrzhodEnyUd7pPyz66PMtJ7ZynPWos0rrGVdNVEIYj78JV0rAvFPuLkdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBdoHsGKqEAIOcRsI7OXDnuZq1MX0wqIXz8lEb1Q+Ek=;
 b=pG2ttHjua/w3TSmk+xFmy2LbYvTQL3n0svi3kKSr8owfEwt2kZF84T8NP9PsH2zbm04xwSb1cemHCVAHnW5ClldSx5SYa2unGpJItS+VXJQsRV0lVcFkx80eUhPU3XpftudnH6l1Eh1aUybHypmeA9DD51DxNEOI3a0uFGStoWo=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:09 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/18] net/mlx5: DR, Expose steering table functionality
Thread-Topic: [net-next 08/18] net/mlx5: DR, Expose steering table
 functionality
Thread-Index: AQHVYV9FkHqA6MRwykiutfMoxER+aw==
Date:   Mon, 2 Sep 2019 07:23:08 +0000
Message-ID: <20190902072213.7683-9-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c1bb4911-6e94-495c-6b33-08d72f766797
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22593B1DD69160075D5D518BBEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:252;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dwBNRqZTIYa8fAfahfSZsudqDrqLXlkoOkaqAgZBfTEMYJoKMTqD1FJeN0kB7HUBHXu/HtwLi6XsvPApP5vHk7uKgT/82qCVk8nyxzrCUEabDwBweef8YJ/XkFaTtG94HySaRCaH/ILvzkiD50nMInITxZRGVyfz1gaL13Bkjbp9O+us5EoUbE5e9q/V3eds+IKqRsb48I+WBoYU6/edBRkd08S2Iw4KwijhHp/fjnrJ4P3zDopSUaZWOmixcA+2emq2yQNKPS+JcZujLxqfZ/EfDqyBP0IYi/k/cUMgYaQ2AJTxqqmD8nP3Mrnc8O9bcbL6D8qs9aKrzEsVhDyoakh0lOMjwkOEu2Hjldi0ILuT5EhPP15p4zLvI4eX+zgXOKRKb0nsBtid9DD5y4FFAts6eKeX1iV+p04BS0Jmw3o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bb4911-6e94-495c-6b33-08d72f766797
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:08.9476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8sxlTwY7AJkW2O3Vwewvar6YZNskyEPuWaSarcgfW+y0slDa/laEW1u3gwx/mWXW1dFWPNZHCy1KT0ZtRP4aAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Tables are objects which are used for storing matchers, each table
belongs to a domain and defined by the domain type. When a packet
reaches the table it is being processed by each of its matchers until a
successful match. Tables can hold multiple matchers ordered by matcher
priority. Each table has a level.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_table.c    | 294 ++++++++++++++++++
 1 file changed, 294 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_tab=
le.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
new file mode 100644
index 000000000000..e178d8d3dbc9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
+				 struct mlx5dr_action *action)
+{
+	struct mlx5dr_matcher *last_matcher =3D NULL;
+	struct mlx5dr_htbl_connect_info info;
+	struct mlx5dr_ste_htbl *last_htbl;
+	int ret;
+
+	if (action && action->action_type !=3D DR_ACTION_TYP_FT)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&tbl->dmn->mutex);
+
+	if (!list_empty(&tbl->matcher_list))
+		last_matcher =3D list_last_entry(&tbl->matcher_list,
+					       struct mlx5dr_matcher,
+					       matcher_list);
+
+	if (tbl->dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX ||
+	    tbl->dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB) {
+		if (last_matcher)
+			last_htbl =3D last_matcher->rx.e_anchor;
+		else
+			last_htbl =3D tbl->rx.s_anchor;
+
+		tbl->rx.default_icm_addr =3D action ?
+			action->dest_tbl.tbl->rx.s_anchor->chunk->icm_addr :
+			tbl->rx.nic_dmn->default_icm_addr;
+
+		info.type =3D CONNECT_MISS;
+		info.miss_icm_addr =3D tbl->rx.default_icm_addr;
+
+		ret =3D mlx5dr_ste_htbl_init_and_postsend(tbl->dmn,
+							tbl->rx.nic_dmn,
+							last_htbl,
+							&info, true);
+		if (ret) {
+			mlx5dr_dbg(tbl->dmn, "Failed to set RX miss action, ret %d\n", ret);
+			goto out;
+		}
+	}
+
+	if (tbl->dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_TX ||
+	    tbl->dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB) {
+		if (last_matcher)
+			last_htbl =3D last_matcher->tx.e_anchor;
+		else
+			last_htbl =3D tbl->tx.s_anchor;
+
+		tbl->tx.default_icm_addr =3D action ?
+			action->dest_tbl.tbl->tx.s_anchor->chunk->icm_addr :
+			tbl->tx.nic_dmn->default_icm_addr;
+
+		info.type =3D CONNECT_MISS;
+		info.miss_icm_addr =3D tbl->tx.default_icm_addr;
+
+		ret =3D mlx5dr_ste_htbl_init_and_postsend(tbl->dmn,
+							tbl->tx.nic_dmn,
+							last_htbl, &info, true);
+		if (ret) {
+			mlx5dr_dbg(tbl->dmn, "Failed to set TX miss action, ret %d\n", ret);
+			goto out;
+		}
+	}
+
+	/* Release old action */
+	if (tbl->miss_action)
+		refcount_dec(&tbl->miss_action->refcount);
+
+	/* Set new miss action */
+	tbl->miss_action =3D action;
+	if (tbl->miss_action)
+		refcount_inc(&action->refcount);
+
+out:
+	mutex_unlock(&tbl->dmn->mutex);
+	return ret;
+}
+
+static void dr_table_uninit_nic(struct mlx5dr_table_rx_tx *nic_tbl)
+{
+	mlx5dr_htbl_put(nic_tbl->s_anchor);
+}
+
+static void dr_table_uninit_fdb(struct mlx5dr_table *tbl)
+{
+	dr_table_uninit_nic(&tbl->rx);
+	dr_table_uninit_nic(&tbl->tx);
+}
+
+static void dr_table_uninit(struct mlx5dr_table *tbl)
+{
+	mutex_lock(&tbl->dmn->mutex);
+
+	switch (tbl->dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		dr_table_uninit_nic(&tbl->rx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		dr_table_uninit_nic(&tbl->tx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		dr_table_uninit_fdb(tbl);
+		break;
+	default:
+		WARN_ON(true);
+		break;
+	}
+
+	mutex_unlock(&tbl->dmn->mutex);
+}
+
+static int dr_table_init_nic(struct mlx5dr_domain *dmn,
+			     struct mlx5dr_table_rx_tx *nic_tbl)
+{
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_tbl->nic_dmn;
+	struct mlx5dr_htbl_connect_info info;
+	int ret;
+
+	nic_tbl->default_icm_addr =3D nic_dmn->default_icm_addr;
+
+	nic_tbl->s_anchor =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
+						  DR_CHUNK_SIZE_1,
+						  MLX5DR_STE_LU_TYPE_DONT_CARE,
+						  0);
+	if (!nic_tbl->s_anchor)
+		return -ENOMEM;
+
+	info.type =3D CONNECT_MISS;
+	info.miss_icm_addr =3D nic_dmn->default_icm_addr;
+	ret =3D mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn,
+						nic_tbl->s_anchor,
+						&info, true);
+	if (ret)
+		goto free_s_anchor;
+
+	mlx5dr_htbl_get(nic_tbl->s_anchor);
+
+	return 0;
+
+free_s_anchor:
+	mlx5dr_ste_htbl_free(nic_tbl->s_anchor);
+	return ret;
+}
+
+static int dr_table_init_fdb(struct mlx5dr_table *tbl)
+{
+	int ret;
+
+	ret =3D dr_table_init_nic(tbl->dmn, &tbl->rx);
+	if (ret)
+		return ret;
+
+	ret =3D dr_table_init_nic(tbl->dmn, &tbl->tx);
+	if (ret)
+		goto destroy_rx;
+
+	return 0;
+
+destroy_rx:
+	dr_table_uninit_nic(&tbl->rx);
+	return ret;
+}
+
+static int dr_table_init(struct mlx5dr_table *tbl)
+{
+	int ret =3D 0;
+
+	INIT_LIST_HEAD(&tbl->matcher_list);
+
+	mutex_lock(&tbl->dmn->mutex);
+
+	switch (tbl->dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		tbl->table_type =3D MLX5_FLOW_TABLE_TYPE_NIC_RX;
+		tbl->rx.nic_dmn =3D &tbl->dmn->info.rx;
+		ret =3D dr_table_init_nic(tbl->dmn, &tbl->rx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		tbl->table_type =3D MLX5_FLOW_TABLE_TYPE_NIC_TX;
+		tbl->tx.nic_dmn =3D &tbl->dmn->info.tx;
+		ret =3D dr_table_init_nic(tbl->dmn, &tbl->tx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		tbl->table_type =3D MLX5_FLOW_TABLE_TYPE_FDB;
+		tbl->rx.nic_dmn =3D &tbl->dmn->info.rx;
+		tbl->tx.nic_dmn =3D &tbl->dmn->info.tx;
+		ret =3D dr_table_init_fdb(tbl);
+		break;
+	default:
+		WARN_ON(true);
+		break;
+	}
+
+	mutex_unlock(&tbl->dmn->mutex);
+
+	return ret;
+}
+
+static int dr_table_destroy_sw_owned_tbl(struct mlx5dr_table *tbl)
+{
+	return mlx5dr_cmd_destroy_flow_table(tbl->dmn->mdev,
+					     tbl->table_id,
+					     tbl->table_type);
+}
+
+static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
+{
+	u64 icm_addr_rx =3D 0;
+	u64 icm_addr_tx =3D 0;
+	int ret;
+
+	if (tbl->rx.s_anchor)
+		icm_addr_rx =3D tbl->rx.s_anchor->chunk->icm_addr;
+
+	if (tbl->tx.s_anchor)
+		icm_addr_tx =3D tbl->tx.s_anchor->chunk->icm_addr;
+
+	ret =3D mlx5dr_cmd_create_flow_table(tbl->dmn->mdev,
+					   tbl->table_type,
+					   icm_addr_rx,
+					   icm_addr_tx,
+					   tbl->dmn->info.caps.max_ft_level - 1,
+					   true, false, NULL,
+					   &tbl->table_id);
+
+	return ret;
+}
+
+struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 le=
vel)
+{
+	struct mlx5dr_table *tbl;
+	int ret;
+
+	refcount_inc(&dmn->refcount);
+
+	tbl =3D kzalloc(sizeof(*tbl), GFP_KERNEL);
+	if (!tbl)
+		goto dec_ref;
+
+	tbl->dmn =3D dmn;
+	tbl->level =3D level;
+	refcount_set(&tbl->refcount, 1);
+
+	ret =3D dr_table_init(tbl);
+	if (ret)
+		goto free_tbl;
+
+	ret =3D dr_table_create_sw_owned_tbl(tbl);
+	if (ret)
+		goto uninit_tbl;
+
+	return tbl;
+
+uninit_tbl:
+	dr_table_uninit(tbl);
+free_tbl:
+	kfree(tbl);
+dec_ref:
+	refcount_dec(&dmn->refcount);
+	return NULL;
+}
+
+int mlx5dr_table_destroy(struct mlx5dr_table *tbl)
+{
+	int ret;
+
+	if (refcount_read(&tbl->refcount) > 1)
+		return -EBUSY;
+
+	ret =3D dr_table_destroy_sw_owned_tbl(tbl);
+	if (ret)
+		return ret;
+
+	dr_table_uninit(tbl);
+
+	if (tbl->miss_action)
+		refcount_dec(&tbl->miss_action->refcount);
+
+	refcount_dec(&tbl->dmn->refcount);
+	kfree(tbl);
+
+	return ret;
+}
+
+u32 mlx5dr_table_get_id(struct mlx5dr_table *tbl)
+{
+	return tbl->table_id;
+}
--=20
2.21.0

