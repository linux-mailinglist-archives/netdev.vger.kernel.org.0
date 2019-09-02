Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48B2A4FB3
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfIBHX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:29 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:26190
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729524AbfIBHX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eu+wIjJPk2dHH1kyQheZOB7UEJCCXD58qeznCh4PTBSPbwOWbNl+lFeZnuO3Zq1WQLc3prrRBNx/xH8kAWfr1hUE76sAkKC3/DSMuqX3liy4Avr3cdFap1piLK3fvIBXAvoDYK2NELW1f5VO0jQsE2QpNEI/vCH3EB6A19q5lZtPbaAp6le6Qn+6zymt4Bdaz65JK2nt8LKiKrHRh8jvAjDxZ+X7Y5jLa9k+W+kKaZGxWkgB3lNU/nrYbn3g2EBa7rNRzAqBlVzEMutWOwMhdV2aAiZKpZXEqWdSAEASGmRbOd9Pdvw8nIxcBbx8QRqZwWNuLRznUSs3ps3bhZub/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkfn/suaKlnXow2yNd/mPoky5qh1RmCXS0f2lgOkwrw=;
 b=lQROV9p4VFU5cHsUnLJRWIIvkVFW8saUBR5yyaE5PUHqxo8YxuN/ZtQcYBLdjKd3VsVvhxAzvO1lMZNX25bXec74FjczlgFXjx0kgkd3QPXAID2Iwv0uLsiYGodU7oXcAa2laNTQ/8vQLRDyTLKMw9LJ8kskGDq+7wwRa3OyyaEwjhjDybtz96F5hHPhzX9dv2TK5DWOVsB8mnMd2aNKVLBUkrY/ioQiDKDMOcAF9tNl63b9gJR3jZkQ7QOo80YVzQwqYyUzSA3qZFUUe5YQZKKf4L3B84ruY/EVwunza3o0BfUSlI/oebQicTlgWZkDeHIP2xLlLa8/rDE/IaFmag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkfn/suaKlnXow2yNd/mPoky5qh1RmCXS0f2lgOkwrw=;
 b=JHt+nL0xqvtrtS6teehFc9SZZwMUEpQhyUlMSTLLjm7Uk/cjSDHjyawOSwtPMt6iFxXbhMBM0JVrYcSGoa1YpoXzXhGvmz+trT+Xcu+nMU52tKeBTgfKByQardxTATEe522+WseKoLBDveRXNlX5ix2NaRHgeyOih4RDv0kyj+I=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:23:07 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/18] net/mlx5: DR, Expose steering domain functionality
Thread-Topic: [net-next 07/18] net/mlx5: DR, Expose steering domain
 functionality
Thread-Index: AQHVYV9DdTfttfQIkkC8o1HlDEz/ZQ==
Date:   Mon, 2 Sep 2019 07:23:06 +0000
Message-ID: <20190902072213.7683-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: ce21c5ef-1c62-4c3c-c9ca-08d72f766648
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2259EFB1483D16B492B03BC5BEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:334;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(30864003)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OVax51UKCyPMBnFJuqVlvpuHB1rqSxHIeqDDapI7E3gTmKwxC5DR81OlNHaHGEz4hiRViwhtqfvTefiNOIE550MRkXNQi9cOi8b7Rmzs5aJHRTnxiDYnZOzjdG8/3sfSKMk3fSa3DFa5VWryY2EMB4g+FfmumVFPITctVZ2eHczSx6fWBeAPKuhsJGcDtUU+BY+knSR6iCD2hJq4Dbr38lG1U/ZpPs6Oqc3ZUtN3oPwuC9ed5RIML1AVOdwRWP1p7HDSUrXsAECUwNu/vfbtOlH03+DNEOAs9GtvKso8bVErrYTpRC6HfFrY77DTETT73GBrq5avXIJL42NqEfqKYLKtfEE0z48emSe9ObkF0LbSu2sAX3P2dP+1i3inuKufcLhOPRdcYuKnaH9mepHja7vJPPkm5Lgg/YbVcuIBd9U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce21c5ef-1c62-4c3c-c9ca-08d72f766648
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:06.8495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NJLiD6N+pUUIwwvutsD7JNBO7NsMLsLzBzRvg3wMhLZUL/SXdnLnnf/YyLTynaTFbpkt9VVmOv0/03xX9CJVYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Domain is the frame for all of the dr (direct rule) objects.
There are different domain types which also affect the object under that
domain. Each domain can hold multiple tables which can hold multiple
matchers and so on, this means that all of the dr (direct rule) objects
exist under a specific domain. The domain object also holds the
resources needed for other objects such as memory management and
communication with the device.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c   | 395 ++++++++++++++++++
 1 file changed, 395 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dom=
ain.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
new file mode 100644
index 000000000000..3b9cf0bccf4d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -0,0 +1,395 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include <linux/mlx5/eswitch.h>
+#include "dr_types.h"
+
+static int dr_domain_init_cache(struct mlx5dr_domain *dmn)
+{
+	/* Per vport cached FW FT for checksum recalculation, this
+	 * recalculation is needed due to a HW bug.
+	 */
+	dmn->cache.recalc_cs_ft =3D kcalloc(dmn->info.caps.num_vports,
+					  sizeof(dmn->cache.recalc_cs_ft[0]),
+					  GFP_KERNEL);
+	if (!dmn->cache.recalc_cs_ft)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void dr_domain_uninit_cache(struct mlx5dr_domain *dmn)
+{
+	int i;
+
+	for (i =3D 0; i < dmn->info.caps.num_vports; i++) {
+		if (!dmn->cache.recalc_cs_ft[i])
+			continue;
+
+		mlx5dr_fw_destroy_recalc_cs_ft(dmn, dmn->cache.recalc_cs_ft[i]);
+	}
+
+	kfree(dmn->cache.recalc_cs_ft);
+}
+
+int mlx5dr_domain_cache_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
+					      u32 vport_num,
+					      u64 *rx_icm_addr)
+{
+	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
+
+	recalc_cs_ft =3D dmn->cache.recalc_cs_ft[vport_num];
+	if (!recalc_cs_ft) {
+		/* Table not in cache, need to allocate a new one */
+		recalc_cs_ft =3D mlx5dr_fw_create_recalc_cs_ft(dmn, vport_num);
+		if (!recalc_cs_ft)
+			return -EINVAL;
+
+		dmn->cache.recalc_cs_ft[vport_num] =3D recalc_cs_ft;
+	}
+
+	*rx_icm_addr =3D recalc_cs_ft->rx_icm_addr;
+
+	return 0;
+}
+
+static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
+{
+	int ret;
+
+	ret =3D mlx5_core_alloc_pd(dmn->mdev, &dmn->pdn);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Couldn't allocate PD\n");
+		return ret;
+	}
+
+	dmn->uar =3D mlx5_get_uars_page(dmn->mdev);
+	if (!dmn->uar) {
+		mlx5dr_err(dmn, "Couldn't allocate UAR\n");
+		goto clean_pd;
+	}
+
+	dmn->ste_icm_pool =3D mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_STE);
+	if (!dmn->ste_icm_pool) {
+		mlx5dr_err(dmn, "Couldn't get icm memory for %s\n",
+			   dev_name(dmn->mdev->device));
+		goto clean_uar;
+	}
+
+	dmn->action_icm_pool =3D mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_A=
CTION);
+	if (!dmn->action_icm_pool) {
+		mlx5dr_err(dmn, "Couldn't get action icm memory for %s\n",
+			   dev_name(dmn->mdev->device));
+		goto free_ste_icm_pool;
+	}
+
+	ret =3D mlx5dr_send_ring_alloc(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Couldn't create send-ring for %s\n",
+			   dev_name(dmn->mdev->device));
+		goto free_action_icm_pool;
+	}
+
+	return 0;
+
+free_action_icm_pool:
+	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
+free_ste_icm_pool:
+	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+clean_uar:
+	mlx5_put_uars_page(dmn->mdev, dmn->uar);
+clean_pd:
+	mlx5_core_dealloc_pd(dmn->mdev, dmn->pdn);
+
+	return ret;
+}
+
+static void dr_domain_uninit_resources(struct mlx5dr_domain *dmn)
+{
+	mlx5dr_send_ring_free(dmn, dmn->send_ring);
+	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
+	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+	mlx5_put_uars_page(dmn->mdev, dmn->uar);
+	mlx5_core_dealloc_pd(dmn->mdev, dmn->pdn);
+}
+
+static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
+				 bool other_vport,
+				 u16 vport_number)
+{
+	struct mlx5dr_cmd_vport_cap *vport_caps;
+	int ret;
+
+	vport_caps =3D &dmn->info.caps.vports_caps[vport_number];
+
+	ret =3D mlx5dr_cmd_query_esw_vport_context(dmn->mdev,
+						 other_vport,
+						 vport_number,
+						 &vport_caps->icm_address_rx,
+						 &vport_caps->icm_address_tx);
+	if (ret)
+		return ret;
+
+	ret =3D mlx5dr_cmd_query_gvmi(dmn->mdev,
+				    other_vport,
+				    vport_number,
+				    &vport_caps->vport_gvmi);
+	if (ret)
+		return ret;
+
+	vport_caps->num =3D vport_number;
+	vport_caps->vhca_gvmi =3D dmn->info.caps.gvmi;
+
+	return 0;
+}
+
+static int dr_domain_query_vports(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_esw_caps *esw_caps =3D &dmn->info.caps.esw_caps;
+	struct mlx5dr_cmd_vport_cap *wire_vport;
+	int vport;
+	int ret;
+
+	/* Query vports (except wire vport) */
+	for (vport =3D 0; vport < dmn->info.caps.num_esw_ports - 1; vport++) {
+		ret =3D dr_domain_query_vport(dmn, !!vport, vport);
+		if (ret)
+			return ret;
+	}
+
+	/* Last vport is the wire port */
+	wire_vport =3D &dmn->info.caps.vports_caps[vport];
+	wire_vport->num =3D WIRE_PORT;
+	wire_vport->icm_address_rx =3D esw_caps->uplink_icm_address_rx;
+	wire_vport->icm_address_tx =3D esw_caps->uplink_icm_address_tx;
+	wire_vport->vport_gvmi =3D 0;
+	wire_vport->vhca_gvmi =3D dmn->info.caps.gvmi;
+
+	return 0;
+}
+
+static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
+				    struct mlx5dr_domain *dmn)
+{
+	int ret;
+
+	if (!dmn->info.caps.eswitch_manager)
+		return -EOPNOTSUPP;
+
+	ret =3D mlx5dr_cmd_query_esw_caps(mdev, &dmn->info.caps.esw_caps);
+	if (ret)
+		return ret;
+
+	dmn->info.caps.fdb_sw_owner =3D dmn->info.caps.esw_caps.sw_owner;
+	dmn->info.caps.esw_rx_drop_address =3D dmn->info.caps.esw_caps.drop_icm_a=
ddress_rx;
+	dmn->info.caps.esw_tx_drop_address =3D dmn->info.caps.esw_caps.drop_icm_a=
ddress_tx;
+
+	dmn->info.caps.vports_caps =3D kcalloc(dmn->info.caps.num_esw_ports,
+					     sizeof(dmn->info.caps.vports_caps[0]),
+					     GFP_KERNEL);
+	if (!dmn->info.caps.vports_caps)
+		return -ENOMEM;
+
+	ret =3D dr_domain_query_vports(dmn);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Failed to query vports caps\n");
+		goto free_vports_caps;
+	}
+
+	dmn->info.caps.num_vports =3D dmn->info.caps.num_esw_ports - 1;
+
+	return 0;
+
+free_vports_caps:
+	kfree(dmn->info.caps.vports_caps);
+	dmn->info.caps.vports_caps =3D NULL;
+	return ret;
+}
+
+static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
+			       struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_cmd_vport_cap *vport_cap;
+	int ret;
+
+	if (MLX5_CAP_GEN(mdev, port_type) !=3D MLX5_CAP_PORT_TYPE_ETH) {
+		mlx5dr_dbg(dmn, "Failed to allocate domain, bad link type\n");
+		return -EOPNOTSUPP;
+	}
+
+	dmn->info.caps.num_esw_ports =3D mlx5_eswitch_get_total_vports(mdev);
+
+	ret =3D mlx5dr_cmd_query_device(mdev, &dmn->info.caps);
+	if (ret)
+		return ret;
+
+	ret =3D dr_domain_query_fdb_caps(mdev, dmn);
+	if (ret)
+		return ret;
+
+	switch (dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		if (!dmn->info.caps.rx_sw_owner)
+			return -ENOTSUPP;
+
+		dmn->info.supp_sw_steering =3D true;
+		dmn->info.rx.ste_type =3D MLX5DR_STE_TYPE_RX;
+		dmn->info.rx.default_icm_addr =3D dmn->info.caps.nic_rx_drop_address;
+		dmn->info.rx.drop_icm_addr =3D dmn->info.caps.nic_rx_drop_address;
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		if (!dmn->info.caps.tx_sw_owner)
+			return -ENOTSUPP;
+
+		dmn->info.supp_sw_steering =3D true;
+		dmn->info.tx.ste_type =3D MLX5DR_STE_TYPE_TX;
+		dmn->info.tx.default_icm_addr =3D dmn->info.caps.nic_tx_allow_address;
+		dmn->info.tx.drop_icm_addr =3D dmn->info.caps.nic_tx_drop_address;
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		if (!dmn->info.caps.eswitch_manager)
+			return -ENOTSUPP;
+
+		if (!dmn->info.caps.fdb_sw_owner)
+			return -ENOTSUPP;
+
+		dmn->info.rx.ste_type =3D MLX5DR_STE_TYPE_RX;
+		dmn->info.tx.ste_type =3D MLX5DR_STE_TYPE_TX;
+		vport_cap =3D mlx5dr_get_vport_cap(&dmn->info.caps, 0);
+		if (!vport_cap) {
+			mlx5dr_dbg(dmn, "Failed to get esw manager vport\n");
+			return -ENOENT;
+		}
+
+		dmn->info.supp_sw_steering =3D true;
+		dmn->info.tx.default_icm_addr =3D vport_cap->icm_address_tx;
+		dmn->info.rx.default_icm_addr =3D vport_cap->icm_address_rx;
+		dmn->info.rx.drop_icm_addr =3D dmn->info.caps.esw_rx_drop_address;
+		dmn->info.tx.drop_icm_addr =3D dmn->info.caps.esw_tx_drop_address;
+		break;
+	default:
+		mlx5dr_dbg(dmn, "Invalid domain\n");
+		ret =3D -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static void dr_domain_caps_uninit(struct mlx5dr_domain *dmn)
+{
+	kfree(dmn->info.caps.vports_caps);
+}
+
+struct mlx5dr_domain *
+mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type t=
ype)
+{
+	struct mlx5dr_domain *dmn;
+	int ret;
+
+	if (type > MLX5DR_DOMAIN_TYPE_FDB)
+		return NULL;
+
+	dmn =3D kzalloc(sizeof(*dmn), GFP_KERNEL);
+	if (!dmn)
+		return NULL;
+
+	dmn->mdev =3D mdev;
+	dmn->type =3D type;
+	refcount_set(&dmn->refcount, 1);
+	mutex_init(&dmn->mutex);
+
+	if (dr_domain_caps_init(mdev, dmn)) {
+		mlx5dr_dbg(dmn, "Failed init domain, no caps\n");
+		goto free_domain;
+	}
+
+	dmn->info.max_log_action_icm_sz =3D DR_CHUNK_SIZE_4K;
+	dmn->info.max_log_sw_icm_sz =3D min_t(u32, DR_CHUNK_SIZE_1024K,
+					    dmn->info.caps.log_icm_size);
+
+	if (!dmn->info.supp_sw_steering) {
+		mlx5dr_err(dmn, "SW steering not supported for %s\n",
+			   dev_name(mdev->device));
+		goto uninit_caps;
+	}
+
+	/* Allocate resources */
+	ret =3D dr_domain_init_resources(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed init domain resources for %s\n",
+			   dev_name(mdev->device));
+		goto uninit_caps;
+	}
+
+	ret =3D dr_domain_init_cache(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed initialize domain cache\n");
+		goto uninit_resourses;
+	}
+
+	/* Init CRC table for htbl CRC calculation */
+	mlx5dr_crc32_init_table();
+
+	return dmn;
+
+uninit_resourses:
+	dr_domain_uninit_resources(dmn);
+uninit_caps:
+	dr_domain_caps_uninit(dmn);
+free_domain:
+	kfree(dmn);
+	return NULL;
+}
+
+/* Assure synchronization of the device steering tables with updates made =
by SW
+ * insertion.
+ */
+int mlx5dr_domain_sync(struct mlx5dr_domain *dmn, u32 flags)
+{
+	int ret =3D 0;
+
+	if (flags & MLX5DR_DOMAIN_SYNC_FLAGS_SW) {
+		mutex_lock(&dmn->mutex);
+		ret =3D mlx5dr_send_ring_force_drain(dmn);
+		mutex_unlock(&dmn->mutex);
+		if (ret)
+			return ret;
+	}
+
+	if (flags & MLX5DR_DOMAIN_SYNC_FLAGS_HW)
+		ret =3D mlx5dr_cmd_sync_steering(dmn->mdev);
+
+	return ret;
+}
+
+int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
+{
+	if (refcount_read(&dmn->refcount) > 1)
+		return -EBUSY;
+
+	/* make sure resources are not used by the hardware */
+	mlx5dr_cmd_sync_steering(dmn->mdev);
+	dr_domain_uninit_cache(dmn);
+	dr_domain_uninit_resources(dmn);
+	dr_domain_caps_uninit(dmn);
+	mutex_destroy(&dmn->mutex);
+	kfree(dmn);
+	return 0;
+}
+
+void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
+			    struct mlx5dr_domain *peer_dmn)
+{
+	mutex_lock(&dmn->mutex);
+
+	if (dmn->peer_dmn)
+		refcount_dec(&dmn->peer_dmn->refcount);
+
+	dmn->peer_dmn =3D peer_dmn;
+
+	if (dmn->peer_dmn)
+		refcount_inc(&dmn->peer_dmn->refcount);
+
+	mutex_unlock(&dmn->mutex);
+}
--=20
2.21.0

