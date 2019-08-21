Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F181196E3D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfHUAXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:23:46 -0400
Received: from mail-eopbgr680114.outbound.protection.outlook.com ([40.107.68.114]:56135
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfHUAXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 20:23:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eu6gq7NMkPJIMkj6aaT0AcxUUT3KImHZ3eLQ4iaw4DrxOApMLry+w5wEJeoopnNi8qD6omcQL+SOdfyWmSVA2F6veUqfPoBUruZJYPO54LFFjgknfTyqrMxPYzxT8uyGOF5k0O8hWuGdHpTbByg6L83IbU5chXYdOqvByRRQIVOIGHd4H8ukMSjup+ou861m4OyoyO5wn+zafoXLPWdBcJXwPVgNZHCC6ZSwvj6fDbWfkhjl0wYiqfNkvSwRWBC8a4K61L7prnPDryEG9dGKiKBwJD6i+ozdjHQqExLIZt+MVhZTHVOm0nDm3zvjXhn+0mC98KGyDzayGjZOTMbojg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RbVlAL361i/nMEbRXveV/wGUyTbgTNWiMbsooCxWo8=;
 b=dYpYJYMmdLu5Hf9Dp58C2+XSUU9YVY/nYdtlIPH9bdFvGUpaVL7nNyrkYKE1AmZpRkijMuo8jNIhYtTEWxKcBEuIr6EyWYRn2b8j3HDe9mczCg53jcr3VnEoAQiO3zxT+wx1FE415/PKcvaNoKGKD+KjMgRDhj/V6a+qq4pdc+wXss4ws4dsIzWtXm/Y6aoZhpPIPji8oMTrzuv8VR4RT9+mZECADwE/1n7bO55J7sA4GAgtp0kxdO4j6XFhrmSL3MKPDAxapqF+lYuggD1MbvuSTimeaYPG1YR6xzreZYRNIZSUfOjVZTVsLfjy906APXPoYcrZCAPV1WQyXXSV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RbVlAL361i/nMEbRXveV/wGUyTbgTNWiMbsooCxWo8=;
 b=GSdvuZDqIMtknjaCDCVA/i1lBns93wKwrgZ/kPS1+qAVhRR/sgyzGUfAhGWpVkwr4ibHqQmr+vzi/QPNsJOPe61HDRF5X5y0CvQffcy+a2SJDtN7aoVHKK6Z6K++Ui15ClAJiTTtFNRSiIWXqaBwV9htBAxHO4kn49autMRGzf8=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1450.namprd21.prod.outlook.com (10.255.109.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Wed, 21 Aug 2019 00:23:39 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 21 Aug 2019
 00:23:39 +0000
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
Subject: [PATCH net-next,v3, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next,v3, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVV7atFasknLLY0k+BDC/j9FrRvA==
Date:   Wed, 21 Aug 2019 00:23:38 +0000
Message-ID: <1566346948-69497-6-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 516493b4-65af-484d-f319-08d725cdd025
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1450;
x-ms-traffictypediagnostic: DM6PR21MB1450:|DM6PR21MB1450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB145048BA956EDCA2354B3FFEACAA0@DM6PR21MB1450.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(26005)(2906002)(71190400001)(71200400001)(6512007)(50226002)(186003)(36756003)(54906003)(8676002)(110136005)(6436002)(6392003)(7846003)(8936002)(99286004)(446003)(6506007)(81166006)(81156014)(2201001)(386003)(6486002)(76176011)(7416002)(66066001)(5660300002)(52116002)(102836004)(11346002)(316002)(53936002)(6116002)(3846002)(22452003)(478600001)(4326008)(14444005)(256004)(66946007)(66476007)(66556008)(64756008)(66446008)(2616005)(476003)(486006)(305945005)(25786009)(10090500001)(4720700003)(14454004)(10290500003)(2501003)(7736002)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1450;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vWlAHo84Kt5MBhKxcKo9GLrjKDMbVaoSbIwbVZqvyMztREBeyIGf0l984evJZNZjkO25B2TkydbWKRbuuMOIUGQqy6Rwc1QVPnLLG/iJoNO1SCgBilD0TVni/jJkWcIIu5Xj6oz5vK6PCYdacIkdumrChgAhNW4fO+tGn0l1HoASs0r1wX6h2SlobAwCY6y6QQj2Umcn8KRsPP88Fd5nuYNgFLpf7394K/tj2kAxigOasiZr2+O3MYjtIG03JxFSzzhR5IMzmKPgL2BvPCA5M8WhIf6Y2Hf4aCF3w+01auXu1LjroIU332sVGoj9JLkWKi6mV4Nj3ihoftxIGV7Q5ykRm4FtozmcC9/s/oNsV3bEY1ixqU25lCUxxmfqSkVp21BS8YgtMVGtGYs8WO1wkpvWuCAKUy2xqyk6Sq2Ev5U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516493b4-65af-484d-f319-08d725cdd025
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 00:23:38.8584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tsM5fjboW2Td+eOVLXZ1FV0pepGS1PiBI+nBMumqeBoBijVBrVd94uWDZWN8iqBEv2Y2ig2TXTinh0KwcY0ggQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Control agent is responsible over of the control block (ID 0). It should
update the PF via this block about every capability change. In addition,
upon block 0 invalidate, it should activate all other supported agents
with data requests from the PF.

Upon agent create/destroy, the invalidate callback of the control agent
is being called in order to update the PF driver about this change.

The control agent is an integral part of HV VHCA and will be created
and destroy as part of the HV VHCA init/cleanup flow.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  | 122 +++++++++++++++++=
+++-
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |   1 +
 2 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/driver=
s/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
index 84d1d75..4047629 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -109,22 +109,131 @@ void mlx5_hv_vhca_invalidate(void *context, u64 bloc=
k_mask)
 	queue_work(hv_vhca->work_queue, &work->invalidate_work);
 }
=20
+#define AGENT_MASK(type) (type ? BIT(type - 1) : 0 /* control */)
+
+static void mlx5_hv_vhca_agents_control(struct mlx5_hv_vhca *hv_vhca,
+					struct mlx5_hv_vhca_control_block *block)
+{
+	int i;
+
+	for (i =3D 0; i < MLX5_HV_VHCA_AGENT_MAX; i++) {
+		struct mlx5_hv_vhca_agent *agent =3D hv_vhca->agents[i];
+
+		if (!agent || !agent->control)
+			continue;
+
+		if (!(AGENT_MASK(agent->type) & block->control))
+			continue;
+
+		agent->control(agent, block);
+	}
+}
+
+static void mlx5_hv_vhca_capabilities(struct mlx5_hv_vhca *hv_vhca,
+				      u32 *capabilities)
+{
+	int i;
+
+	for (i =3D 0; i < MLX5_HV_VHCA_AGENT_MAX; i++) {
+		struct mlx5_hv_vhca_agent *agent =3D hv_vhca->agents[i];
+
+		if (agent)
+			*capabilities |=3D AGENT_MASK(agent->type);
+	}
+}
+
+static void
+mlx5_hv_vhca_control_agent_invalidate(struct mlx5_hv_vhca_agent *agent,
+				      u64 block_mask)
+{
+	struct mlx5_hv_vhca *hv_vhca =3D agent->hv_vhca;
+	struct mlx5_core_dev *dev =3D hv_vhca->dev;
+	struct mlx5_hv_vhca_control_block *block;
+	u32 capabilities =3D 0;
+	int err;
+
+	block =3D kzalloc(sizeof(*block), GFP_KERNEL);
+	if (!block)
+		return;
+
+	err =3D mlx5_hv_read_config(dev, block, sizeof(*block), 0);
+	if (err)
+		goto free_block;
+
+	mlx5_hv_vhca_capabilities(hv_vhca, &capabilities);
+
+	/* In case no capabilities, send empty block in return */
+	if (!capabilities) {
+		memset(block, 0, sizeof(*block));
+		goto write;
+	}
+
+	if (block->capabilities !=3D capabilities)
+		block->capabilities =3D capabilities;
+
+	if (block->control & ~capabilities)
+		goto free_block;
+
+	mlx5_hv_vhca_agents_control(hv_vhca, block);
+	block->command_ack =3D block->command;
+
+write:
+	mlx5_hv_write_config(dev, block, sizeof(*block), 0);
+
+free_block:
+	kfree(block);
+}
+
+static struct mlx5_hv_vhca_agent *
+mlx5_hv_vhca_control_agent_create(struct mlx5_hv_vhca *hv_vhca)
+{
+	return mlx5_hv_vhca_agent_create(hv_vhca, MLX5_HV_VHCA_AGENT_CONTROL,
+					 NULL,
+					 mlx5_hv_vhca_control_agent_invalidate,
+					 NULL, NULL);
+}
+
+static void mlx5_hv_vhca_control_agent_destroy(struct mlx5_hv_vhca_agent *=
agent)
+{
+	mlx5_hv_vhca_agent_destroy(agent);
+}
+
 int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
 {
+	struct mlx5_hv_vhca_agent *agent;
+	int err;
+
 	if (IS_ERR_OR_NULL(hv_vhca))
 		return IS_ERR_OR_NULL(hv_vhca);
=20
-	return mlx5_hv_register_invalidate(hv_vhca->dev, hv_vhca,
-					   mlx5_hv_vhca_invalidate);
+	err =3D mlx5_hv_register_invalidate(hv_vhca->dev, hv_vhca,
+					  mlx5_hv_vhca_invalidate);
+	if (err)
+		return err;
+
+	agent =3D mlx5_hv_vhca_control_agent_create(hv_vhca);
+	if (IS_ERR_OR_NULL(agent)) {
+		mlx5_hv_unregister_invalidate(hv_vhca->dev);
+		return IS_ERR_OR_NULL(agent);
+	}
+
+	hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] =3D agent;
+
+	return 0;
 }
=20
 void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
 {
+	struct mlx5_hv_vhca_agent *agent;
 	int i;
=20
 	if (IS_ERR_OR_NULL(hv_vhca))
 		return;
=20
+	agent =3D hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL];
+	if (agent)
+		mlx5_hv_vhca_control_agent_destroy(agent);
+
 	mutex_lock(&hv_vhca->agents_lock);
 	for (i =3D 0; i < MLX5_HV_VHCA_AGENT_MAX; i++)
 		WARN_ON(hv_vhca->agents[i]);
@@ -134,6 +243,11 @@ void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca=
)
 	mlx5_hv_unregister_invalidate(hv_vhca->dev);
 }
=20
+static void mlx5_hv_vhca_agents_update(struct mlx5_hv_vhca *hv_vhca)
+{
+	mlx5_hv_vhca_invalidate(hv_vhca, BIT(MLX5_HV_VHCA_AGENT_CONTROL));
+}
+
 struct mlx5_hv_vhca_agent *
 mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 			  enum mlx5_hv_vhca_agent_type type,
@@ -174,6 +288,8 @@ struct mlx5_hv_vhca_agent *
 	hv_vhca->agents[type] =3D agent;
 	mutex_unlock(&hv_vhca->agents_lock);
=20
+	mlx5_hv_vhca_agents_update(hv_vhca);
+
 	return agent;
 }
=20
@@ -195,6 +311,8 @@ void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_age=
nt *agent)
 		agent->cleanup(agent);
=20
 	kfree(agent);
+
+	mlx5_hv_vhca_agents_update(hv_vhca);
 }
=20
 static int mlx5_hv_vhca_data_block_prepare(struct mlx5_hv_vhca_agent *agen=
t,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/driver=
s/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
index cdf1303..984e7ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
@@ -12,6 +12,7 @@
 struct mlx5_hv_vhca_control_block;
=20
 enum mlx5_hv_vhca_agent_type {
+	MLX5_HV_VHCA_AGENT_CONTROL =3D 0,
 	MLX5_HV_VHCA_AGENT_MAX =3D 32,
 };
=20
--=20
1.8.3.1

