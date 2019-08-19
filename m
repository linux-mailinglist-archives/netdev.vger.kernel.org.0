Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F7894E38
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfHSTbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:31:01 -0400
Received: from mail-eopbgr700099.outbound.protection.outlook.com ([40.107.70.99]:43875
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728375AbfHSTbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:31:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ma9xqXDweJHa0uRLvSZQlf5mgxaiW9xlGNnx/DMnMnmMWelKE6HvDhTS31RHO1XCjAZ0uVdCJKZZJcqrBiPAo7Pnup1Jyf432vyxWDzcFa2Z9eJxshMD9qeZKP+sbHgjMvZpL/Q8tzxXuitAc/DD4xm/IKn5PfhEK/v8bMwsvo5ML3zx0wMlDnC2zXXncg7cqtANUbFuUQ5Bic6hsrs+WyZvoG4pkdRkwcl3bj9v0BNN1xICEF8/zZVVsNMFVT+wbzpvQ/j/KEbqjmGnBtmJb0YIEZUCo5TPPnnZmD2Zawo64jAmZoENow32uYh7Ix+ojhOY3diVFk4TDOh23mmiQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmGD0tq4KN+t0PgEAVl/gPHCC3zNB9QvKcPDfp2AUE4=;
 b=miidvfgARhcBmmfTX2p1q7bjRsucZUd4wmvrzM/PPVBImZ1PVJ/gGrBftgZN7+feFG9egkzXCdna8J2Myyj2nT6mmdmJffTHmf52BA0FxQuZmQo6qAsu8c4lVFRQx7PJGGlXhzAm2RsZm1qJyt2zOxSWo8ss/JHBDmsX3e48wHWV+eFQ6QReZWCu0mRpZULJvA8ZX/pODKcGyyRdknqLFGXAZAyla2g0HcCGFSnM9GqyTnMBDDnLxKoKv6SCj4l23K95PJwov5OVK5rcxMpc884NcQvm9mFc3P61ETQCZGZ042tfiGpLGTOpuyqtrSjghNgWb96SBlpZISH8wMf5DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmGD0tq4KN+t0PgEAVl/gPHCC3zNB9QvKcPDfp2AUE4=;
 b=oL7BoB2QvqE4CK3lPVdriyi9u6d9G5h7ywEbJE7jAgaUR4/BVecwvhrGS1T8rmB4RGDr6IiTFz2oV6surVESLzr1a8Gl2YvPicIlxDC7zN92AQaCLF4RdzUSvRD0S8VmZLfms8/bc59KA9C1/+tWIHPlGfgfRaEPE1ElHkGi60U=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:55 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:55 +0000
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
Subject: [PATCH net-next,v2 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Topic: [PATCH net-next,v2 4/6] net/mlx5: Add HV VHCA infrastructure
Thread-Index: AQHVVsSeu1IBpNya5ki9rP3gc45FLQ==
Date:   Mon, 19 Aug 2019 19:30:54 +0000
Message-ID: <1566242976-108801-5-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 991f1d98-f6d9-45a8-eefb-08d724dbc0ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB114586BF536F7BB53A302D30ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(14444005)(76176011)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(11346002)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(30864003)(10290500003)(316002)(446003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hZaXXCN/YefIOOSj9B7n2Qrb7iT03LwrKcrQ2Y+SE2WyvObCht8TT8xEQsEJDjXuEhohv1vNF9EP/yC4nXxhRRsbguulznJchHVlHwISDAhlZV/BtXiyZYDoLmBj1KuJ2OFnQrNBeOdnHOpG4pFdgSg5BKX6377n6VLRCCxpeZTYbQpt0O/S1yLqduGVjsuEEAG6UxzvD1oEkQuR5mWzmAjSim7dp6lGbbvpFBOnv7bNpog7E1LKWA+Z6oyIvyesNdy/Ft0SQ9Kh0iySqScKWvK6/S3UmavU+hS1tnMVgG973nD1oRv/jRIZUKec5rxpq8I68iRNvOPex1BdrmZD2oejAkVXzOE3x3CD8XkErl9j4wPAuge4n9GjH6a3Q4XPEe3LqPbX6nHfGFq8DENYkW1ZJmEBAmEEEEXAw4pwyjM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991f1d98-f6d9-45a8-eefb-08d724dbc0ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:54.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: szznsk9aTuWgBwp+/t8EBt1jpADh7dHeTlHoS447qR9d5R1Q7Jjjw1+g/Mi4JdFF7t2N5FqR67Y4Oj5sJ9uljQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
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
index 247295b..fc59a40 100644
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
index 80437d4..4b74315 100644
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
@@ -868,6 +869,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	}
=20
 	dev->tracer =3D mlx5_fw_tracer_create(dev);
+	dev->hv_vhca =3D mlx5_hv_vhca_create(dev);
=20
 	return 0;
=20
@@ -897,6 +899,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
=20
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
 	mlx5_fpga_cleanup(dev);
 	mlx5_eswitch_cleanup(dev->priv.eswitch);
@@ -1063,6 +1066,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_fw_tracer;
 	}
=20
+	mlx5_hv_vhca_init(dev->hv_vhca);
+
 	err =3D mlx5_fpga_device_start(dev);
 	if (err) {
 		mlx5_core_err(dev, "fpga device start failed %d\n", err);
@@ -1118,6 +1123,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
+	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 err_fw_tracer:
 	mlx5_eq_table_destroy(dev);
@@ -1138,6 +1144,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
+	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
 	mlx5_irq_table_destroy(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 467de34..0e00cbc 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -638,6 +638,7 @@ struct mlx5_clock {
 struct mlx5_fw_tracer;
 struct mlx5_vxlan;
 struct mlx5_geneve;
+struct mlx5_hv_vhca;
=20
 struct mlx5_core_dev {
 	struct device *device;
@@ -685,6 +686,7 @@ struct mlx5_core_dev {
 	struct mlx5_ib_clock_info  *clock_info;
 	struct mlx5_fw_tracer   *tracer;
 	u32                      vsc_addr;
+	struct mlx5_hv_vhca	*hv_vhca;
 };
=20
 struct mlx5_db {
--=20
1.8.3.1

