Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BBC9A2D5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405157AbfHVW0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:26:42 -0400
Received: from mail-eopbgr800130.outbound.protection.outlook.com ([40.107.80.130]:26625
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405117AbfHVW0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 18:26:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clgt3I0+I4v0bPOHGrREk3rQ5S75R74NO+UWHA1Ww7JhqCWKkcLPAZ8vBb6Ms4sM6rNTFwMS/Uz9Li/7bvGiuhHTeKV9ocDkhsbQ2b3LHiR0uWUmdiv8PrH5824VVQCzkogDPlprmE3DpniGpe7W57U8747mdPAnBN6ZoLGVHsgF/WvlK6Sf+arh0VvrOCUIB62myyZ9QRM1mbWuhiIFhEB60Pwwrzg+5an8iDy4ESYODtml0WG7BBkzVSmjIWf8v5MiZfSN0zO2m666B5UhsT774hySV3vYXelnZh/hs19peRDlCGl+z9nrj41CTwFn9AjvAk4RIfeWqnLPkENs6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0HVgZLcz4H2uUhaSYwmdiAfey8AfB4Y1QFMPHTHRE4=;
 b=X0sd8zGmlKdLhxa6/nhRq5U1++9kvGa6rFQlNavSTAxpQXJM0gCqUQi1dNqtUfiWby1XnGt9JnDORJKOKFAbPV+izI/xq94JP2oLZcOXJAiSolccw6cIN7wT2gSsjI0zIiHDCPKjlcleH5E3K4iMDFxmfLo58olI2YlGGN6+uborziolVB3aKhjsl9CA4X55dvasKMVrLBTQMe7j/eLTLcCxf20KahYPR+DkbKs01HfxL3OY0CfpOalCxFtKcbBo0h5X6FMjJXt0CP0xdkPQHf3F3znN9VkNdV/CDi9cKhxTOMcJbN+8NbvFu3YP4juoimmaOzibCNGQJIdp3nAITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0HVgZLcz4H2uUhaSYwmdiAfey8AfB4Y1QFMPHTHRE4=;
 b=PoP2YnNXk482xQGxy6eQsgUyBu3aNozB0xuCFbMO6Y24DLWDKCrkYB8stpKhtWULW75uA41rWhtH8RpFZKMdkrQHqEtSidvL53OwDPNULGpaozTZFa8qnCiBc9UcsqaENMxXiXKAN+5z3eeKQTubnX8RF1DHnmSg+RSuipxUYkE=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1449.namprd21.prod.outlook.com (20.180.23.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Thu, 22 Aug 2019 22:26:37 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%7]) with mapi id 15.20.2220.009; Thu, 22 Aug 2019
 22:26:37 +0000
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
Subject: [PATCH net-next,v5, 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Topic: [PATCH net-next,v5, 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Index: AQHVWTiphZGCKllPI0WRFKaknzgl7A==
Date:   Thu, 22 Aug 2019 22:26:37 +0000
Message-ID: <1566512708-13785-5-git-send-email-haiyangz@microsoft.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0092.namprd19.prod.outlook.com
 (2603:10b6:320:1f::30) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15fa532f-9adf-4db5-91c0-08d7274fcbbc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1449;
x-ms-traffictypediagnostic: DM6PR21MB1449:|DM6PR21MB1449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1449DBE68232DA1C0602A284ACA50@DM6PR21MB1449.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(186003)(71200400001)(2201001)(52116002)(305945005)(8676002)(5660300002)(102836004)(81156014)(6436002)(30864003)(6506007)(36756003)(386003)(7846003)(99286004)(8936002)(10090500001)(53936002)(81166006)(2501003)(76176011)(66066001)(478600001)(4720700003)(6486002)(7736002)(26005)(2906002)(25786009)(11346002)(446003)(2616005)(256004)(14454004)(10290500003)(486006)(54906003)(110136005)(14444005)(3846002)(6116002)(6392003)(66446008)(64756008)(66556008)(66476007)(66946007)(50226002)(7416002)(71190400001)(316002)(4326008)(22452003)(6512007)(476003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1449;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BApkMhvItwXFov1tiV4CGCBlmkUxqjzVb05UINaEhUp8bBdf/2nl1zNPX9HuZl4yMNkVarE4fVDVvbXNF2DsFMvuKtajks+2PArK8WDOyFGBJu1UatMu+nmy71rph3yZ4PbAeExKs1V4PNcw12LIZFblBkpiH2mw6yDH4Oe3ZVQBknQDPHVoVYl6Fcu0XozmWeGAl1B3HSJAlDhjrcJZ/7bsBYhiyz+W1KK6M2fXwG40I6Kc9lkbe2oz0an7lXsWyF9k3eKZFu2t4wUW84freYi04cBFdnH1bOqLlh1U/AimPtprsj6q0dYtGcwvy1i7SB7t2gIsXjF827NPBEqwaWc8uEvDbEPobZeF6vWyb2/vbkAiYGRZadDrswhqFJnZJUYFEDREcgSH1oBXjIjoBzwnEncAiPviGGjaXaL2Q2I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fa532f-9adf-4db5-91c0-08d7274fcbbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 22:26:37.1826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CDAaJiTCVGsBP2JBfcNDoCtVxZVnlc4wJZdn0SN+15HkeRh/GLuo4TZA8DezxMXCLUg3M611tJ4eYh53O842mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1449
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

