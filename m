Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777758DDBE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfHNTJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:09:11 -0400
Received: from mail-eopbgr800097.outbound.protection.outlook.com ([40.107.80.97]:42124
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728773AbfHNTJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 15:09:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3Fj+47DXZylj5JOndRlMkYI8eDD4VpjLa+JAlmXweltG3bJYSPeFvoySvkZkWbzBqnoVCd2/ZfyYBRoEej01KLARYyJdfDQIk0pfZA/smdPGIRkQig+n1PAPsIenSObxr2YTMoyTasLIpKnjp+rVCijCZ4tPC/V35QKDALr+NsOwOdhPSKJrG7FURkdgoVuIikTgovzBdK/imE+op9TbiXuMC3JY7YGnaO0XQBezVKX8o5ibyF9hRQYHHOgei7Bu4VVTSTUol3qGouNGbh72C0NGeaXUAEmfhuighsdvP2G9UWyagIefEbF0EW+2nMtCDJ4ju7iVCEEhFmcRKUehA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIa6AVMMMVDQB7f7BYW8S8TwpcoEYl2Jr3XwFTqhKtg=;
 b=JkqyuFaAwntKB1FV/SuwZQSemYar4XzioBlgnExajU5dmsaIMEt20yK1UzC9RJnG9CynqesZtYhqQGDx+/2AD5j3Ng0XX7MkEsG4ncT6VZ4pF8EewrAJuA34qpKHmwkjkbIx1QZQp4erNH4nRfjDh1Yf4b7TJKADi3mOahogsXNB5Ixd2syTYnxe86gnQL/qCKTKpBat8h5J2fA4wWvyJ/tptNAVhDZXYzSDH6I+R1CThMWiPG59nqO13k7UuT9H2b270izDnYZhxCF49KyMbsM/5jb7Zgb4hzgmieMOTBNC7aU3HBtcGB1QBvup8gI0/knJZDBiC5ZgF4qbTCQ5bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIa6AVMMMVDQB7f7BYW8S8TwpcoEYl2Jr3XwFTqhKtg=;
 b=QWiGPS9kC67fiU5e8YeoaC2+EjSA+yA2r0p+TZsQg6i2+WkksqMemWXEFPxejDOG22CWpRBl/4xTVq8gklWCAqH6SV6ubmBi+Z5UUkLBP0CfQWTtSdTsepqeWE+2iuGhSaADdyzQ/RA/0BxQ6f6ejcxkqUfdvMkgDBGocKwY9gk=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1338.namprd21.prod.outlook.com (20.179.53.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.6; Wed, 14 Aug 2019 19:08:59 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 14 Aug 2019
 19:08:59 +0000
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
Subject: [PATCH net-next, 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Topic: [PATCH net-next, 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Index: AQHVUtO5D95UnjtwdkO5T9mGzsXQjw==
Date:   Wed, 14 Aug 2019 19:08:58 +0000
Message-ID: <1565809632-39138-5-git-send-email-haiyangz@microsoft.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:104:1::33) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c6f61e7-53ab-4fde-aab7-08d720eadc5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1338;
x-ms-traffictypediagnostic: DM6PR21MB1338:|DM6PR21MB1338:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1338885DDC27408FB24B974CACAD0@DM6PR21MB1338.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(6486002)(110136005)(6392003)(54906003)(4326008)(10090500001)(26005)(14454004)(256004)(2906002)(53936002)(6116002)(66066001)(6436002)(3846002)(6512007)(7416002)(66476007)(66446008)(76176011)(66556008)(2201001)(30864003)(64756008)(66946007)(8936002)(22452003)(71200400001)(14444005)(7736002)(71190400001)(50226002)(102836004)(5660300002)(81166006)(4720700003)(446003)(316002)(478600001)(305945005)(7846003)(186003)(99286004)(2501003)(36756003)(81156014)(8676002)(25786009)(476003)(11346002)(52116002)(6506007)(2616005)(486006)(10290500003)(386003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1338;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ovOGiALjG4vtxnpeL2VyoD3/F/yItpLgwrwABIZBzhjrX3AvsipupUlRYlejj7B/GnMQLhuPtDYsdFowJ4AaAySAS51P5dr5AXSAlwBO4U8bIul9sL5TFqosLcQUc/TtksOLFNEFqdpetsYfVlIw34G4kWhvUd9f7WqqEj5l8iorky4SlSXJCpM5DpdR0HCk4PIQGmiRubfFbV7j+tWgI4y3oRNx/K2IxVQaiLsVldz+556GOG7XK7F/VdwLxftKowtsARcfagiR+HYyg948eeGJlE0Mx4/EljVeCBvRXeYa51dnYfF4mGnwQ7JWWutC7aAxtTAei0PzOkF3AY2waWwwLc0b52MdBLkeEplD4bS/M2hbZyA2zzw86Qxdpr8msQ4vFuia+buyjqT964P+WBMiNmk2569ihagPxuZwnKQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6f61e7-53ab-4fde-aab7-08d720eadc5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 19:08:58.9115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rx9s86XWYXdYxo5V1DF2uJAivK+p9U1vbaYwX71N9DK90pEeJcKL8oFPnkGgEr9eoe6XeJYnTMS53pn7fYcWzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

HV VHCA is a layer which provides PF to VF communication channel based on
HyperV PCI config channel. It implements Mellanox's Inter VHCA control
communication protocol. The protocol contains control block in order to
pass messages between the PF and VF drivers, and data blocks in order to
pass actual data.

The infrastructure is agent based. Each agent will be responsible of
contiguous buffer blocks in the VHCA config space. This infrastructure will
bind agents to their blocks, and those agents can only access read/write
the buffer blocks assigned to them. Each agent will provide three
callbacks (control, invalidate, cleanup). Control will be invoked when
block-0 is invalidated with a command that concerns this agent. Invalidate
callback will be invoked if one of the blocks assigned to this agent was
invalidated. Cleanup will be invoked before the agent is being freed in
order to clean all of its open resources or deferred works.

Block-0 serves as the control block. All execution commands from the PF
will be written by the PF over this block. VF will ack on those by
writing on block-0 as well. Its format is described by struct
mlx5_hv_vhca_control_block layout.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  | 247 +++++++++++++++++=
++++
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  | 102 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +
 include/linux/mlx5/driver.h                        |   2 +
 5 files changed, 359 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index a8950b1..e0a1056 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -45,7 +45,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch=
_offloads.o eswitch_offlo
 mlx5_core-$(CONFIG_MLX5_MPFS)      +=3D lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          +=3D lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) +=3D lib/clock.o
-mlx5_core-$(CONFIG_PCI_HYPERV_MINI)     +=3D lib/hv.o
+mlx5_core-$(CONFIG_PCI_HYPERV_MINI)+=3D lib/hv.o lib/hv_vhca.o
=20
 #
 # Ipoib netdev
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/driver=
s/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
new file mode 100644
index 0000000..b2eebdf
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2018 Mellanox Technologies
+
+#include <linux/hyperv.h>
+#include "mlx5_core.h"
+#include "lib/hv.h"
+#include "lib/hv_vhca.h"
+
+struct mlx5_hv_vhca {
+	struct mlx5_core_dev       *dev;
+	struct workqueue_struct    *work_queue;
+	struct mlx5_hv_vhca_agent  *agents[MLX5_HV_VHCA_AGENT_MAX];
+	struct mutex                agents_lock; /* Protect agents array */
+};
+
+struct mlx5_hv_vhca_work {
+	struct work_struct     invalidate_work;
+	struct mlx5_hv_vhca   *hv_vhca;
+	u64                    block_mask;
+};
+
+struct mlx5_hv_vhca_data_block {
+	u16     sequence;
+	u16     offset;
+	u8      reserved[4];
+	u64     data[15];
+};
+
+struct mlx5_hv_vhca_agent {
+	enum mlx5_hv_vhca_agent_type	 type;
+	struct mlx5_hv_vhca		*hv_vhca;
+	void				*priv;
+	int                              seq;
+	void (*control)(struct mlx5_hv_vhca_agent *agent,
+			struct mlx5_hv_vhca_control_block *block);
+	void (*invalidate)(struct mlx5_hv_vhca_agent *agent,
+			   u64 block_mask);
+	void (*cleanup)(struct mlx5_hv_vhca_agent *agent);
+};
+
+struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_hv_vhca *hv_vhca =3D NULL;
+
+	hv_vhca =3D kzalloc(sizeof(*hv_vhca), GFP_KERNEL);
+	if (!hv_vhca)
+		return ERR_PTR(-ENOMEM);
+
+	hv_vhca->work_queue =3D create_singlethread_workqueue("mlx5_hv_vhca");
+	if (!hv_vhca->work_queue) {
+		kfree(hv_vhca);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	hv_vhca->dev =3D dev;
+	mutex_init(&hv_vhca->agents_lock);
+
+	return hv_vhca;
+}
+
+void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
+{
+	if (IS_ERR_OR_NULL(hv_vhca))
+		return;
+
+	flush_workqueue(hv_vhca->work_queue);
+	destroy_workqueue(hv_vhca->work_queue);
+	kfree(hv_vhca);
+}
+
+static void mlx5_hv_vhca_invalidate_work(struct work_struct *work)
+{
+	struct mlx5_hv_vhca_work *hwork;
+	struct mlx5_hv_vhca *hv_vhca;
+	int i;
+
+	hwork =3D container_of(work, struct mlx5_hv_vhca_work, invalidate_work);
+	hv_vhca =3D hwork->hv_vhca;
+
+	mutex_lock(&hv_vhca->agents_lock);
+	for (i =3D 0; i < MLX5_HV_VHCA_AGENT_MAX; i++) {
+		struct mlx5_hv_vhca_agent *agent =3D hv_vhca->agents[i];
+
+		if (!agent || !agent->invalidate)
+			continue;
+
+		if (!(BIT(agent->type) & hwork->block_mask))
+			continue;
+
+		agent->invalidate(agent, hwork->block_mask);
+	}
+	mutex_unlock(&hv_vhca->agents_lock);
+
+	kfree(hwork);
+}
+
+void mlx5_hv_vhca_invalidate(void *context, u64 block_mask)
+{
+	struct mlx5_hv_vhca *hv_vhca =3D (struct mlx5_hv_vhca *)context;
+	struct mlx5_hv_vhca_work *work;
+
+	work =3D kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return;
+
+	INIT_WORK(&work->invalidate_work, mlx5_hv_vhca_invalidate_work);
+	work->hv_vhca    =3D hv_vhca;
+	work->block_mask =3D block_mask;
+
+	queue_work(hv_vhca->work_queue, &work->invalidate_work);
+}
+
+int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
+{
+	if (IS_ERR_OR_NULL(hv_vhca))
+		return IS_ERR_OR_NULL(hv_vhca);
+
+	return mlx5_hv_register_invalidate(hv_vhca->dev, hv_vhca,
+					   mlx5_hv_vhca_invalidate);
+}
+
+void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
+{
+	int i;
+
+	if (IS_ERR_OR_NULL(hv_vhca))
+		return;
+
+	mutex_lock(&hv_vhca->agents_lock);
+	for (i =3D 0; i < MLX5_HV_VHCA_AGENT_MAX; i++)
+		WARN_ON(hv_vhca->agents[i]);
+
+	mutex_unlock(&hv_vhca->agents_lock);
+
+	mlx5_hv_unregister_invalidate(hv_vhca->dev);
+}
+
+struct mlx5_hv_vhca_agent *
+mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
+			  enum mlx5_hv_vhca_agent_type type,
+			  void (*control)(struct mlx5_hv_vhca_agent*,
+					  struct mlx5_hv_vhca_control_block *block),
+			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
+					     u64 block_mask),
+			  void (*cleaup)(struct mlx5_hv_vhca_agent *agent),
+			  void *priv)
+{
+	struct mlx5_hv_vhca_agent *agent;
+
+	if (IS_ERR_OR_NULL(hv_vhca))
+		return ERR_PTR(-ENOMEM);
+
+	if (hv_vhca->agents[type])
+		return ERR_PTR(-EINVAL);
+
+	agent =3D kzalloc(sizeof(*agent), GFP_KERNEL);
+	if (!agent)
+		return ERR_PTR(-ENOMEM);
+
+	agent->type      =3D type;
+	agent->hv_vhca   =3D hv_vhca;
+	agent->priv      =3D priv;
+	agent->control   =3D control;
+	agent->invalidate =3D invalidate;
+	agent->cleanup   =3D cleaup;
+
+	mutex_lock(&hv_vhca->agents_lock);
+	hv_vhca->agents[type] =3D agent;
+	mutex_unlock(&hv_vhca->agents_lock);
+
+	return agent;
+}
+
+void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent)
+{
+	struct mlx5_hv_vhca *hv_vhca =3D agent->hv_vhca;
+
+	mutex_lock(&hv_vhca->agents_lock);
+
+	if (WARN_ON(agent !=3D hv_vhca->agents[agent->type])) {
+		mutex_unlock(&hv_vhca->agents_lock);
+		return;
+	}
+
+	hv_vhca->agents[agent->type] =3D NULL;
+	mutex_unlock(&hv_vhca->agents_lock);
+
+	if (agent->cleanup)
+		agent->cleanup(agent);
+
+	kfree(agent);
+}
+
+static int mlx5_hv_vhca_data_block_prepare(struct mlx5_hv_vhca_agent *agen=
t,
+					   struct mlx5_hv_vhca_data_block *data_block,
+					   void *src, int len, int *offset)
+{
+	int bytes =3D min_t(int, (int)sizeof(data_block->data), len);
+
+	data_block->sequence =3D agent->seq;
+	data_block->offset   =3D (*offset)++;
+	memcpy(data_block->data, src, bytes);
+
+	return bytes;
+}
+
+static void mlx5_hv_vhca_agent_seq_update(struct mlx5_hv_vhca_agent *agent=
)
+{
+	agent->seq++;
+}
+
+int mlx5_hv_vhca_agent_write(struct mlx5_hv_vhca_agent *agent,
+			     void *buf, int len)
+{
+	int offset =3D agent->type * HV_CONFIG_BLOCK_SIZE_MAX;
+	int block_offset =3D 0;
+	int total =3D 0;
+	int err;
+
+	while (len) {
+		struct mlx5_hv_vhca_data_block data_block =3D {0};
+		int bytes;
+
+		bytes =3D mlx5_hv_vhca_data_block_prepare(agent, &data_block,
+							buf + total,
+							len, &block_offset);
+		if (!bytes)
+			return -ENOMEM;
+
+		err =3D mlx5_hv_write_config(agent->hv_vhca->dev, &data_block,
+					   sizeof(data_block), offset);
+		if (err)
+			return err;
+
+		total +=3D bytes;
+		len   -=3D bytes;
+	}
+
+	mlx5_hv_vhca_agent_seq_update(agent);
+
+	return 0;
+}
+
+void *mlx5_hv_vhca_agent_priv(struct mlx5_hv_vhca_agent *agent)
+{
+	return agent->priv;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/driver=
s/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
new file mode 100644
index 0000000..fa7ee85
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __LIB_HV_VHCA_H__
+#define __LIB_HV_VHCA_H__
+
+#include "en.h"
+#include "lib/hv.h"
+
+struct mlx5_hv_vhca_agent;
+struct mlx5_hv_vhca;
+struct mlx5_hv_vhca_control_block;
+
+enum mlx5_hv_vhca_agent_type {
+	MLX5_HV_VHCA_AGENT_MAX =3D 32,
+};
+
+#if IS_ENABLED(CONFIG_PCI_HYPERV_MINI)
+
+struct mlx5_hv_vhca_control_block {
+	u32     capabilities;
+	u32     control;
+	u16     command;
+	u16     command_ack;
+	u16     version;
+	u16     rings;
+	u32     reserved1[28];
+};
+
+struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev);
+void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca);
+int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca);
+void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca);
+void mlx5_hv_vhca_invalidate(void *context, u64 block_mask);
+
+struct mlx5_hv_vhca_agent *
+mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
+			  enum mlx5_hv_vhca_agent_type type,
+			  void (*control)(struct mlx5_hv_vhca_agent*,
+					  struct mlx5_hv_vhca_control_block *block),
+			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
+					     u64 block_mask),
+			  void (*cleanup)(struct mlx5_hv_vhca_agent *agent),
+			  void *context);
+
+void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent);
+int mlx5_hv_vhca_agent_write(struct mlx5_hv_vhca_agent *agent,
+			     void *buf, int len);
+void *mlx5_hv_vhca_agent_priv(struct mlx5_hv_vhca_agent *agent);
+
+#else
+
+static inline struct mlx5_hv_vhca *
+mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
+{
+	return NULL;
+}
+
+static inline void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
+{
+}
+
+static inline int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
+{
+	return 0;
+}
+
+static inline void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
+{
+}
+
+static inline void mlx5_hv_vhca_invalidate(void *context,
+					   u64 block_mask)
+{
+}
+
+static inline struct mlx5_hv_vhca_agent *
+mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
+			  enum mlx5_hv_vhca_agent_type type,
+			  void (*control)(struct mlx5_hv_vhca_agent*,
+					  struct mlx5_hv_vhca_control_block *block),
+			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
+					     u64 block_mask),
+			  void (*cleanup)(struct mlx5_hv_vhca_agent *agent),
+			  void *context)
+{
+	return NULL;
+}
+
+static inline void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *a=
gent)
+{
+}
+
+static inline int
+mlx5_hv_vhca_write_agent(struct mlx5_hv_vhca_agent *agent,
+			 void *buf, int len)
+{
+	return 0;
+}
+#endif
+
+#endif /* __LIB_HV_VHCA_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 4cc90eb..50ee38b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -69,6 +69,7 @@
 #include "lib/pci_vsc.h"
 #include "diag/fw_tracer.h"
 #include "ecpf.h"
+#include "lib/hv_vhca.h"
=20
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX ser=
ies) core driver");
@@ -872,6 +873,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	}
=20
 	dev->tracer =3D mlx5_fw_tracer_create(dev);
+	dev->hv_vhca =3D mlx5_hv_vhca_create(dev);
=20
 	return 0;
=20
@@ -902,6 +904,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
=20
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
@@ -1068,6 +1071,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_fw_tracer;
 	}
=20
+	mlx5_hv_vhca_init(dev->hv_vhca);
+
 	err =3D mlx5_fpga_device_start(dev);
 	if (err) {
 		mlx5_core_err(dev, "fpga device start failed %d\n", err);
@@ -1123,6 +1128,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
+	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 err_fw_tracer:
 	mlx5_eq_table_destroy(dev);
@@ -1143,6 +1149,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
+	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
 	mlx5_irq_table_destroy(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2b84ee9..97bb98c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -646,6 +646,7 @@ struct mlx5_clock {
 struct mlx5_fw_tracer;
 struct mlx5_vxlan;
 struct mlx5_geneve;
+struct mlx5_hv_vhca;
=20
 struct mlx5_core_dev {
 	struct device *device;
@@ -693,6 +694,7 @@ struct mlx5_core_dev {
 	struct mlx5_ib_clock_info  *clock_info;
 	struct mlx5_fw_tracer   *tracer;
 	u32                      vsc_addr;
+	struct mlx5_hv_vhca	*hv_vhca;
 };
=20
 struct mlx5_db {
--=20
1.8.3.1

