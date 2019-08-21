Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2620996E44
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfHUAXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:23:52 -0400
Received: from mail-eopbgr680114.outbound.protection.outlook.com ([40.107.68.114]:56135
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbfHUAXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:23:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+HlrFytrUZBctdgqJmrgkv5xNmpEnW+lBTzIJuBNU/nzPC3eHk0VWGw2aBzKs3KeA8jYUnLYURngBy/jKhmmvOYN7jSWHD70Z6AYPRBns4e/dBl4w32BTt+z1MK5aPZQ9Wwddjt1uamN3YRoH2m4dPt6qFYNlBC8Jx/x+At0K8lZzbH6FtljZUWC5M+s9XzZcslwqkDITpDh2q3gzdqZO3xMq2+sLt5gb7er0Eip+dMgpU0UeaIR12d0VYGpiqbxkjc5KnixJ7q/pO+1l/0So2XWu46c90CivKRRYcfgRryhkiayWC23J21ynGGrZ+jKNkORPMcUMQJFwM5BWqSkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrTeVtIfqKLr/QNHMpMnBZ29NF9U6t8j5qPvzR09P60=;
 b=ZMCCamXzbZM7/HbBfEIUhCgDziR7JNo10z2qvFOlIxRrev9j1LjT+VhcHsOOQ8UVY5fxNTBPrCGUKOJrLc+2C7krfFV2ki8fRHlU+OZfjp1LXmtFUdEqKaSQjM/qgAZHj00T6v+MGPzqsOZK8nwc3zxWi1Zt/eP9b5AIM2EcjJ0eZXj3Ipp3KaGYevIzZWZiloqNx9A4WCxAA1Uu2Bvqu7vW3ngVauTo/m01ibWVlkk1clK+/6S7fEp8FvR5l8WUlSibtPgEgJ0tPuNAaF1xXKGdy3gWp6l22+ORGrliPzOfI1ihFH4XtEvJnhkDWLrA5oUfBfyjEIjWDgi6OJKkQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrTeVtIfqKLr/QNHMpMnBZ29NF9U6t8j5qPvzR09P60=;
 b=j1zwvUIf6WbeqTIViC8anSBZ/CXQceS9hoMhWxVpHHPEnoVFq89cwHOugky8oGsVDrza+00fkMxPPtTGu83A1sskvAlxfD73ZLfmG8khOixuFesYhChBnvm46LS5hWPeZD+FZzNwggMBBqa6+eV/3dv9u2jPJfLweW1WEfb7vvE=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1450.namprd21.prod.outlook.com (10.255.109.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Wed, 21 Aug 2019 00:23:41 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 21 Aug 2019
 00:23:41 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next,v3, 6/6] net/mlx5e: Add mlx5e HV VHCA stats agent
Thread-Topic: [PATCH net-next,v3, 6/6] net/mlx5e: Add mlx5e HV VHCA stats
 agent
Thread-Index: AQHVV7av9jr7MS48YkejvVIIdNN5EA==
Date:   Wed, 21 Aug 2019 00:23:41 +0000
Message-ID: <1566346948-69497-7-git-send-email-haiyangz@microsoft.com>
References: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:301:60::23) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be0adb0-564b-44c7-3b05-08d725cdd174
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1450;
x-ms-traffictypediagnostic: DM6PR21MB1450:|DM6PR21MB1450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB14504F2E1C8ADD3AFBBF6FFBACAA0@DM6PR21MB1450.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(26005)(2906002)(71190400001)(71200400001)(6512007)(50226002)(186003)(36756003)(54906003)(8676002)(110136005)(6436002)(6392003)(7846003)(8936002)(99286004)(446003)(6506007)(81166006)(81156014)(2201001)(386003)(6486002)(76176011)(7416002)(66066001)(5660300002)(52116002)(102836004)(11346002)(316002)(53936002)(6116002)(3846002)(22452003)(478600001)(4326008)(14444005)(256004)(66946007)(66476007)(66556008)(64756008)(66446008)(2616005)(476003)(486006)(305945005)(25786009)(10090500001)(4720700003)(14454004)(10290500003)(2501003)(7736002)(42413003)(32563001)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1450;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: INTJ2w6CjS5vTmz6fxk5O9TrHIMiLtHxnLDJ0hO7hMf1Lr+ttwTILtj3GVnbDDcH9MvNseqi4x5cJAj4auwrONMMLPnt08kkWTKvbK0E/xIVVDwXgq2VivOEGKD6MYiWMu4riFSt0zhMLzdSjmaNsIAC68IbLU8L3mhdL/W+v9WbMjuvSqMC56sz0jRztn1dCFPwggqNWmk57gti00lEx89WMOlExJpsccIIktxG4/EQ+FhZDpmjNGzRbKBhDJ95R9xnSAVXzacvoUvt/KLll2dZMdg8+UavFpQkTiOYGroEiM/9aeZ49k1tDupTq4JX0E4lkMm5wC6/Y2hd9Td+Fb+FT7eq/JiH+0pJkrYn+cBb7ZVnYswsVHF3hT1+3yTpdWCiJ4f6e0iSqDnonl02lZ1nijl830z5dcx5Kf3kBP4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be0adb0-564b-44c7-3b05-08d725cdd174
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 00:23:41.0422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dF3nuxBd6IbRwyOGOhB7ZvAUQI34O1UrcecT474NI8Ut3B+xmUag9WoDJ/bVF5K+ml+PWjSOMiEgwySxtbWGQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

HV VHCA stats agent is responsible on running a preiodic rx/tx
packets/bytes stats update. Currently the supported format is version
MLX5_HV_VHCA_STATS_VERSION. Block ID 1 is dedicated for statistics data
transfer from the VF to the PF.

The reporter fetch the statistics data from all opened channels, fill it
in a buffer and send it to mlx5_hv_vhca_write_agent.

As the stats layer should include some metadata per block (sequence and
offset), the HV VHCA layer shall modify the buffer before actually send it
over block 1.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  13 ++
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 162 +++++++++++++++++=
++++
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h |  25 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |   1 +
 6 files changed, 205 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stat=
s.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stat=
s.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index fc59a40..a889a38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -36,6 +36,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) +=3D en_dcbnl.o en/p=
ort_buffer.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)     +=3D en_rep.o en_tc.o en/tc_tun.o lib=
/port_tun.o lag_mp.o \
 					lib/geneve.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
 					en/tc_tun_geneve.o
+mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) +=3D en/hv_vhca_stats.o
=20
 #
 # Core extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 8fc5107..4a8008b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -54,6 +54,7 @@
 #include "mlx5_core.h"
 #include "en_stats.h"
 #include "en/fs.h"
+#include "lib/hv_vhca.h"
=20
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
@@ -777,6 +778,15 @@ struct mlx5e_modify_sq_param {
 	int rl_index;
 };
=20
+#if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
+struct mlx5e_hv_vhca_stats_agent {
+	struct mlx5_hv_vhca_agent *agent;
+	struct delayed_work        work;
+	u16                        delay;
+	void                      *buf;
+};
+#endif
+
 struct mlx5e_xsk {
 	/* UMEMs are stored separately from channels, because we don't want to
 	 * lose them when channels are recreated. The kernel also stores UMEMs,
@@ -848,6 +858,9 @@ struct mlx5e_priv {
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
 	struct mlx5e_xsk           xsk;
+#if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
+	struct mlx5e_hv_vhca_stats_agent stats_agent;
+#endif
 };
=20
 struct mlx5e_profile {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
new file mode 100644
index 0000000..c37b4ac
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2018 Mellanox Technologies
+
+#include "en.h"
+#include "en/hv_vhca_stats.h"
+#include "lib/hv_vhca.h"
+#include "lib/hv.h"
+
+struct mlx5e_hv_vhca_per_ring_stats {
+	u64     rx_packets;
+	u64     rx_bytes;
+	u64     tx_packets;
+	u64     tx_bytes;
+};
+
+static void
+mlx5e_hv_vhca_fill_ring_stats(struct mlx5e_priv *priv, int ch,
+			      struct mlx5e_hv_vhca_per_ring_stats *data)
+{
+	struct mlx5e_channel_stats *stats;
+	int tc;
+
+	stats =3D &priv->channel_stats[ch];
+	data->rx_packets =3D stats->rq.packets;
+	data->rx_bytes   =3D stats->rq.bytes;
+
+	for (tc =3D 0; tc < priv->max_opened_tc; tc++) {
+		data->tx_packets +=3D stats->sq[tc].packets;
+		data->tx_bytes   +=3D stats->sq[tc].bytes;
+	}
+}
+
+static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, u64 *data,
+				     int buf_len)
+{
+	int ch, i =3D 0;
+
+	for (ch =3D 0; ch < priv->max_nch; ch++) {
+		u64 *buf =3D data + i;
+
+		if (WARN_ON_ONCE(buf +
+				 sizeof(struct mlx5e_hv_vhca_per_ring_stats) >
+				 data + buf_len))
+			return;
+
+		mlx5e_hv_vhca_fill_ring_stats(priv, ch,
+					      (struct mlx5e_hv_vhca_per_ring_stats *)buf);
+		i +=3D sizeof(struct mlx5e_hv_vhca_per_ring_stats) / sizeof(u64);
+	}
+}
+
+static int mlx5e_hv_vhca_stats_buf_size(struct mlx5e_priv *priv)
+{
+	return (sizeof(struct mlx5e_hv_vhca_per_ring_stats) *
+		priv->max_nch);
+}
+
+static void mlx5e_hv_vhca_stats_work(struct work_struct *work)
+{
+	struct mlx5e_hv_vhca_stats_agent *sagent;
+	struct mlx5_hv_vhca_agent *agent;
+	struct delayed_work *dwork;
+	struct mlx5e_priv *priv;
+	int buf_len, rc;
+	void *buf;
+
+	dwork =3D to_delayed_work(work);
+	sagent =3D container_of(dwork, struct mlx5e_hv_vhca_stats_agent, work);
+	priv =3D container_of(sagent, struct mlx5e_priv, stats_agent);
+	buf_len =3D mlx5e_hv_vhca_stats_buf_size(priv);
+	agent =3D sagent->agent;
+	buf =3D sagent->buf;
+
+	memset(buf, 0, buf_len);
+	mlx5e_hv_vhca_fill_stats(priv, buf, buf_len);
+
+	rc =3D mlx5_hv_vhca_agent_write(agent, buf, buf_len);
+	if (rc) {
+		mlx5_core_err(priv->mdev,
+			      "%s: Failed to write stats, err =3D %d\n",
+			      __func__, rc);
+		return;
+	}
+
+	if (sagent->delay)
+		queue_delayed_work(priv->wq, &sagent->work, sagent->delay);
+}
+
+enum {
+	MLX5_HV_VHCA_STATS_VERSION     =3D 1,
+	MLX5_HV_VHCA_STATS_UPDATE_ONCE =3D 0xFFFF,
+};
+
+static void mlx5e_hv_vhca_stats_control(struct mlx5_hv_vhca_agent *agent,
+					struct mlx5_hv_vhca_control_block *block)
+{
+	struct mlx5e_hv_vhca_stats_agent *sagent;
+	struct mlx5e_priv *priv;
+
+	priv =3D mlx5_hv_vhca_agent_priv(agent);
+	sagent =3D &priv->stats_agent;
+
+	block->version =3D MLX5_HV_VHCA_STATS_VERSION;
+	block->rings   =3D priv->max_nch;
+
+	if (!block->command) {
+		cancel_delayed_work_sync(&priv->stats_agent.work);
+		return;
+	}
+
+	sagent->delay =3D block->command =3D=3D MLX5_HV_VHCA_STATS_UPDATE_ONCE ? =
0 :
+			msecs_to_jiffies(block->command * 100);
+
+	queue_delayed_work(priv->wq, &sagent->work, sagent->delay);
+}
+
+static void mlx5e_hv_vhca_stats_cleanup(struct mlx5_hv_vhca_agent *agent)
+{
+	struct mlx5e_priv *priv =3D mlx5_hv_vhca_agent_priv(agent);
+
+	cancel_delayed_work_sync(&priv->stats_agent.work);
+}
+
+int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
+{
+	int buf_len =3D mlx5e_hv_vhca_stats_buf_size(priv);
+	struct mlx5_hv_vhca_agent *agent;
+
+	priv->stats_agent.buf =3D kvzalloc(buf_len, GFP_KERNEL);
+	if (!priv->stats_agent.buf)
+		return -ENOMEM;
+
+	agent =3D mlx5_hv_vhca_agent_create(priv->mdev->hv_vhca,
+					  MLX5_HV_VHCA_AGENT_STATS,
+					  mlx5e_hv_vhca_stats_control, NULL,
+					  mlx5e_hv_vhca_stats_cleanup,
+					  priv);
+
+	if (IS_ERR_OR_NULL(agent)) {
+		if (IS_ERR(agent))
+			netdev_warn(priv->netdev,
+				    "Failed to create hv vhca stats agent, err =3D %ld\n",
+				    PTR_ERR(agent));
+
+		kfree(priv->stats_agent.buf);
+		return IS_ERR_OR_NULL(agent);
+	}
+
+	priv->stats_agent.agent =3D agent;
+	INIT_DELAYED_WORK(&priv->stats_agent.work, mlx5e_hv_vhca_stats_work);
+
+	return 0;
+}
+
+void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv)
+{
+	if (IS_ERR_OR_NULL(priv->stats_agent.agent))
+		return;
+
+	mlx5_hv_vhca_agent_destroy(priv->stats_agent.agent);
+	kfree(priv->stats_agent.buf);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h b/d=
rivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h
new file mode 100644
index 0000000..664463f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_STATS_VHCA_H__
+#define __MLX5_EN_STATS_VHCA_H__
+#include "en.h"
+
+#if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
+
+int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv);
+void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv);
+
+#else
+
+static inline int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
+{
+	return 0;
+}
+
+static inline void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *priv)
+{
+}
+#endif
+
+#endif /* __MLX5_EN_STATS_VHCA_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 5721d3d..fac8455 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -64,6 +64,7 @@
 #include "en/xsk/setup.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
+#include "en/hv_vhca_stats.h"
=20
=20
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
@@ -5103,6 +5104,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	if (mlx5e_monitor_counter_supported(priv))
 		mlx5e_monitor_counter_init(priv);
=20
+	mlx5e_hv_vhca_stats_create(priv);
 	if (netdev->reg_state !=3D NETREG_REGISTERED)
 		return;
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -5135,6 +5137,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv=
)
=20
 	queue_work(priv->wq, &priv->set_rx_mode_work);
=20
+	mlx5e_hv_vhca_stats_destroy(priv);
 	if (mlx5e_monitor_counter_supported(priv))
 		mlx5e_monitor_counter_cleanup(priv);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/driver=
s/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
index 984e7ad..4bad6a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
@@ -13,6 +13,7 @@
=20
 enum mlx5_hv_vhca_agent_type {
 	MLX5_HV_VHCA_AGENT_CONTROL =3D 0,
+	MLX5_HV_VHCA_AGENT_STATS   =3D 1,
 	MLX5_HV_VHCA_AGENT_MAX =3D 32,
 };
=20
--=20
1.8.3.1

