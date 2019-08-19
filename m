Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0E94E40
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfHSTbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:31:06 -0400
Received: from mail-eopbgr700099.outbound.protection.outlook.com ([40.107.70.99]:43875
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728673AbfHSTbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:31:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqXmpieaXQxbD5fm0sxBoPDuJb+D6ZEQkMwqVBqzHAI+/14zp1JNzYO4e4jKomufU6cYwCPfV73/epzQADtM0KI7V+HjSzpTNUnYjJ9mS7z7QyBJU759KahHShj6+RISL9EGh1bzOdIlZR7PIBl/sqji80KF4+7diAVs8xiB0ea8c/ZjVH3o9ojxSSv63VAX0hzUYGkGtuDHp12VqIl6bDZHrdgLJ8NfF50PnfeY3IJNd8A4KStFqkWciZF8hGhLvH83T78+ktFtz7wOf+RWUVFBJWGG/T0RItCyb+gAZJAca+mR8rCOvrJzBM7CxnDTahtWMOVq2G+WHnRr/Acupg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrTeVtIfqKLr/QNHMpMnBZ29NF9U6t8j5qPvzR09P60=;
 b=SNsMkMiFoF7Mc8XKp+p93igu1VnlMzUsPjHJmeCWgXTptghapRso/+vRL3gV+081Vno2uo8fvmBCMOJI7zE3qSEGG8vUbonHbkqhqGquXn6dp+0Oap8aj2Q7J7W3OgiPp/FBs95ZSVSyMsJMzNLOuwReBKsy7ULQAw3HNS2rzxzePoiM4W+2Y9DrdtjUFeiVQNNVSxQkn154EKuPcbpLa6gQ8YNz3fYosYZx48W7qOR1rkGL65QZWqvxS0EgoERNUwrSZ3eIr0kcQbbGTeARK2xHtOVMCLQlEt51iEeOtjDBWpMx8jb3mwVsKpMCzdZWBO+zFBTxtR5kKkp1eIIe0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrTeVtIfqKLr/QNHMpMnBZ29NF9U6t8j5qPvzR09P60=;
 b=SWE7zW2EK0ZccH2mSG4VZAvC84b+NQ5bs/o53QpaXPEIGtzyuSMd5w0LgnuAfNj+B08BRhBOLhbGO8Sdy45Tp/WhllF5GiWMlW4tBYYn7rA/iLAxBth4nlGFo/X70kycl64C9/gR0F6qJLnvQ9/+pIHzfSuRWuGtFlFFhMwy270=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:58 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:58 +0000
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
Subject: [PATCH net-next,v2 6/6] net/mlx5e: Add mlx5e HV VHCA stats agent
Thread-Topic: [PATCH net-next,v2 6/6] net/mlx5e: Add mlx5e HV VHCA stats agent
Thread-Index: AQHVVsSgS+u1VOnhzUW5sj1Ds4uNGA==
Date:   Mon, 19 Aug 2019 19:30:58 +0000
Message-ID: <1566242976-108801-7-git-send-email-haiyangz@microsoft.com>
References: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2dd8212-ba2e-46e5-e895-08d724dbc2fe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB114535414F3A13BD2DA049A4ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(14444005)(76176011)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(11346002)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(10290500003)(316002)(446003)(42413003)(921003)(32563001)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y6zFX1XvW9xexZY1mnEW5CMrHKqX53zfGKLkAPWgGSf9F5e2sUcBhFxFlrATL7Ci1dxSOssZMkbGEQaBDIIPo3IC0FPAVAloqdGlBVGwNxtPNqBSV+obfhm4u1PGhIbQs8rnDGiOvHmIP9W4vR7EZO2OTPAur+R+jVw4mZwVQkZDTu1FBkHwpPHo7BNkakUo8xrdXwf4cWqCHIRJrluX9XEG12QDdYSj4Na2RWjDyxh1NS7ocOb4bF/CB4AayI1lEsIk/H7h1LtcQRYNleA3N43ipp01y+G0y+2xJXRnih9V8ZQ/5xkE5ztEPqmpC+6APRpZq6wO5F7VHLwTk4FKx7qgdwgw8Hez2tvlMqYxeGOw9wWSRwsByyzYsEZ4/wnrgTT1ugWAhK9OoiS23e0iN1SuCnSvsyNJeTJEObQ8uN8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2dd8212-ba2e-46e5-e895-08d724dbc2fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:58.5047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lLvrKRne7TvewS0Mvrt2w+oTh0ZAF4tlH4kyUpxGSrcQ4qbstrhBede1en+nuexAguSZxUYW+ah3jCEcxTpOKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
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

