Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B004198ABB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 07:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbfHVFGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 01:06:05 -0400
Received: from mail-eopbgr810109.outbound.protection.outlook.com ([40.107.81.109]:28619
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731265AbfHVFGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 01:06:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnuMUoYlDV32/MToHA3YPMKWuO8VVkJcigetk3TbEArsj983EsQ5qhssfh35mBsqyI3R+5/fu2XQqJ5fGiTN50/jDwLG16tG1rI3/lZ+xoFJCl0UXPWuVbw7Kz4ONDp8tVFa/PYMLntIkwmSqmMVQQbfJpx1wD/lAqj3ChkuafKVRc28dIVeyDJgkIAjNa7PdgglllNWOl1dpUjog4YG3TJ/Btq9cjq6oWpPiDBEW+Nsb+D85vD4h+yv1KplD9ryGzIsPIPTJe998+MMDTIMDs7MJinLoYPktqrifTI/1WNzSkHA/O8bcQNRYUglYrJg609cR2JhG1sms+Dl1XqS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0HVgZLcz4H2uUhaSYwmdiAfey8AfB4Y1QFMPHTHRE4=;
 b=Cdxum2ivjcoMOQtvRtTPcGpSy0+xTUu9GCXcPNYybxaQ7UYAqUBPdsTz8IG8WzX/dh9iUeUyD6LZYaZq51jNnWJTVpjyGCXgaiY4nnWUvZEFN89IcSbf2ONdvg0gu/lyrxEeEtOLMLNURmorwVUyoD4woLrNr/aiMIdEDUfxOzIwxveSRG0KjBG85KhYs20GMXCw7uIqfjLgS+j4uipxsqRpyiSMGwgk3CYFxif+E97VC6DKuX1GVjiY87ooz9elbyePCHOsMHFI4hSTusqEG91PDVXQFPrb7iXyejPoyI140Gv4CexJTGMefdayQQX14th6V+TMVTeiEHVnUJ+alA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0HVgZLcz4H2uUhaSYwmdiAfey8AfB4Y1QFMPHTHRE4=;
 b=RtKiG9KNlR791moOCykteyzqW8a9MscJwMn9xKeQHgFAydt6VKRzM3xVQhTGwJ7duw9EgpzcUMM25qEdLHS5V3JvpeSBGCYNxAq7vR39dtGXmIaD5HqGdt7m07efHfvK8Kn9JGfrz3G/FoPj/LuMhUo6XC0u+G+VH8JSXTbSmnY=
Received: from MN2PR21MB1248.namprd21.prod.outlook.com (20.179.20.225) by
 MN2PR21MB1279.namprd21.prod.outlook.com (20.179.21.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.4; Thu, 22 Aug 2019 05:05:51 +0000
Received: from MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e]) by MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e%3]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 05:05:51 +0000
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
Subject: [PATCH net-next,v4, 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Topic: [PATCH net-next,v4, 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Index: AQHVWKdE9IMeMzawTEODKtd9TuiDDA==
Date:   Thu, 22 Aug 2019 05:05:51 +0000
Message-ID: <1566450236-36757-5-git-send-email-haiyangz@microsoft.com>
References: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0039.namprd14.prod.outlook.com
 (2603:10b6:300:12b::25) To MN2PR21MB1248.namprd21.prod.outlook.com
 (2603:10b6:208:3b::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e523aea-3b8e-495e-b83b-08d726be6754
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR21MB1279;
x-ms-traffictypediagnostic: MN2PR21MB1279:|MN2PR21MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB127940FCA24F3D152D5E78D7ACA50@MN2PR21MB1279.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(71200400001)(71190400001)(186003)(446003)(66066001)(2616005)(4326008)(36756003)(6392003)(6436002)(256004)(53936002)(7846003)(7416002)(6512007)(26005)(6486002)(14444005)(11346002)(316002)(2906002)(2201001)(110136005)(22452003)(54906003)(10090500001)(476003)(30864003)(25786009)(386003)(7736002)(64756008)(81156014)(66946007)(66446008)(8936002)(10290500003)(478600001)(66476007)(2501003)(102836004)(4720700003)(6116002)(3846002)(6506007)(305945005)(5660300002)(486006)(99286004)(66556008)(81166006)(14454004)(50226002)(8676002)(52116002)(76176011)(142933001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1279;H:MN2PR21MB1248.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ljB1ZoykO6GZ5FKQLPYiF3GVpbVu65q/vkK2p+zZfvOUbH1/XypTQY0m0iOdh6XfX0m7tQ/Idd6jIiHeq4D0v7GAURPX653D3TpkW4B5ebZYqICGuHDgvkewuO52VvWiylO1gMCE53+Hk9oR9z5v5Z5YsUDWncyDTSHw8Xppqa5p7cVOsHJPAkvi2Z2FxNRnML9FGkWSgrBZgndm4eSW+drDCBKvayPhG2HBhdEFl/H8q6YmBsWS60MvMypwNjTELTOP5kOMC6cFkBQxVmVVzt0Hl2o+QRAteSrytgGuzt52vt7+YH7QD9qu48sU1lgXStXJEgo82EEmirhL8kvLI8ly0TZwEIIRjcporpH13G5Vm36vjnD70UdYWxKjioOhSwmXv0ZPmbdJiHH25+cJtwMFc6Eu990HlnfYxHXQF3U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e523aea-3b8e-495e-b83b-08d726be6754
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 05:05:51.6750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DhQN+Z56XYNMXGHTcdHAFIzRJX+9WyIkx/NjFFzC8c67Pg+bWSnmJ/SUFEy1HzbPJc92kK/qiT/5Qg6Jayd8bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1279
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
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  | 253 +++++++++++++++++=
++++
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  | 102 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +
 include/linux/mlx5/driver.h                        |   2 +
 5 files changed, 365 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index fd32a5b..8d443fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -45,7 +45,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   +=3D eswitch.o eswitch=
_offloads.o eswitch_offlo
 mlx5_core-$(CONFIG_MLX5_MPFS)      +=3D lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          +=3D lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) +=3D lib/clock.o
-mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) +=3D lib/hv.o
+mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) +=3D lib/hv.o lib/hv_vhca.o
=20
 #
 # Ipoib netdev
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/driver=
s/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
new file mode 100644
index 0000000..84d1d75
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -0,0 +1,253 @@
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
+	u16                              seq;
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
+	if (type >=3D MLX5_HV_VHCA_AGENT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&hv_vhca->agents_lock);
+	if (hv_vhca->agents[type]) {
+		mutex_unlock(&hv_vhca->agents_lock);
+		return ERR_PTR(-EINVAL);
+	}
+	mutex_unlock(&hv_vhca->agents_lock);
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
index 0000000..cdf1303
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
+#if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
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
index 0b70b1d..61388ca 100644
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
@@ -870,6 +871,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	}
=20
 	dev->tracer =3D mlx5_fw_tracer_create(dev);
+	dev->hv_vhca =3D mlx5_hv_vhca_create(dev);
=20
 	return 0;
=20
@@ -900,6 +902,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
=20
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
@@ -1067,6 +1070,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_fw_tracer;
 	}
=20
+	mlx5_hv_vhca_init(dev->hv_vhca);
+
 	err =3D mlx5_fpga_device_start(dev);
 	if (err) {
 		mlx5_core_err(dev, "fpga device start failed %d\n", err);
@@ -1122,6 +1127,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
+	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 err_fw_tracer:
 	mlx5_eq_table_destroy(dev);
@@ -1142,6 +1148,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
+	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
 	mlx5_irq_table_destroy(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index df23f17..13b4cf2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -659,6 +659,7 @@ struct mlx5_clock {
 struct mlx5_fw_tracer;
 struct mlx5_vxlan;
 struct mlx5_geneve;
+struct mlx5_hv_vhca;
=20
 struct mlx5_core_dev {
 	struct device *device;
@@ -706,6 +707,7 @@ struct mlx5_core_dev {
 	struct mlx5_ib_clock_info  *clock_info;
 	struct mlx5_fw_tracer   *tracer;
 	u32                      vsc_addr;
+	struct mlx5_hv_vhca	*hv_vhca;
 };
=20
 struct mlx5_db {
--=20
1.8.3.1

