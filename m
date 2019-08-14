Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12468DDBB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfHNTJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:09:22 -0400
Received: from mail-eopbgr800097.outbound.protection.outlook.com ([40.107.80.97]:42124
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729325AbfHNTJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 15:09:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3uWwKfxWjhEREKFz9NCHKkuebrx6d0t4nbROMZfiS85mEYZ1AFfy8kFiGhcuzbSzVw7Cek0iXw2Igm+ipSVFYP3yLTFTx+zRIL5ivn+cwpaXlvoyvt6sFOW8V5ms2Xm7H+bOu7l/vGq/W42uEcIwZfvu1m3gYsTApcOA8rQrOxsKqFmGUDJYIvSkbnAWhggUtPyTfI8NDi5o8R83lehjDTJwv+pt9QjoK9wsndTdTOslNwZ+TYnnSDNnsfVCUYf+iMv8bfUjQdxOsG9NTZbTcCwkDyTv/hLGYzdJy4FVQo7nZkkkLxIK/TA3Qvnqy52/XXMsPjk6HNCeGScoSppig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT5NnZqNWPBLOpM6y5c7DYONJ5Br5gDZmhU9KxooNZs=;
 b=BBCu+nyYHTigTbMiOlsZLeXGiaCyJQs0Jrx62OAwQfTpwUeYOeSGLEMq9t+ypBF6IRyBks/j3b3jyOARvuoXzYDPoKzpZAlgouC7nZWlcKHJCoGGwDBXbDHt9k5D/7E4IXMSAK6tfyLR2l/vXMTIHNmMtMr55wIdjGBBlpUwcuhDn3YNd4z78zZ/nSdC+8cX6Q9M2B3W6scsecTcPj1KVBX8uKT01MPXtBkZZTHAZC2EhP5/5grKMkIzEHDgGAFIGZWT2HEds+BDfkluPYBCX9uDcQPW/1NFa8zw0ihpqb3QCt1HKR3yicXt243TpOzPSl4Dc60cYZomdwGgve4JUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT5NnZqNWPBLOpM6y5c7DYONJ5Br5gDZmhU9KxooNZs=;
 b=TPSRIZ6QvG3h/gihMKeYyMsioR9hbpojERtLATIM77AMQSKScf1cQTMQ3l+kB0Q8d7duNLDzX58g2xmEEiGTJG/eYyBjdCm0ute1+b0RK+MO0+NNPKgLZ/XlMc5v6CvMVeoP+6ErJHOls8BcItiavTYl+ITlBes8RndWS8/Vqbw=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1338.namprd21.prod.outlook.com (20.179.53.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.6; Wed, 14 Aug 2019 19:09:00 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Wed, 14 Aug 2019
 19:09:00 +0000
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
Subject: [PATCH net-next, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVUtO6nGTdc/OThEuJSB7tWtrilA==
Date:   Wed, 14 Aug 2019 19:09:00 +0000
Message-ID: <1565809632-39138-6-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: fa20594b-c59f-439b-d138-08d720eadd63
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1338;
x-ms-traffictypediagnostic: DM6PR21MB1338:|DM6PR21MB1338:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1338B6EA1B38F66617F5D5E2ACAD0@DM6PR21MB1338.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(6486002)(110136005)(6392003)(54906003)(4326008)(10090500001)(26005)(14454004)(256004)(2906002)(53936002)(6116002)(66066001)(6436002)(3846002)(6512007)(7416002)(66476007)(66446008)(76176011)(66556008)(2201001)(64756008)(66946007)(8936002)(22452003)(71200400001)(14444005)(7736002)(71190400001)(50226002)(102836004)(5660300002)(81166006)(4720700003)(446003)(316002)(478600001)(305945005)(7846003)(186003)(99286004)(2501003)(36756003)(81156014)(8676002)(25786009)(476003)(11346002)(52116002)(6506007)(2616005)(486006)(10290500003)(386003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1338;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aNP0qDjNewDAS4WCNPjOwX8Bsit78qzpKAOiK5D3d+tSa+iljWu4Z0CGoj8KIsPg5J4U2hKutTdanFsD1bINzAnM5qbl0QEK6rOy/KSL25DK9hALj8klWBtMSVXof2m+HWf54eDgjTdnNCJqnlEUBq2FPfZ/oF9ieEyZYaL1QR276FM9bWZLU+hLN6ZYU+xshlaASeUqlG87AmWowWA1KZ55ViqekWZOm2H0CPG4QMeiBO63pAQC21OZhyd5dChI+51E5EI0FE1ExFwg6jdtXnoyM9bMp4CamVgAAv4tMzkqiD8nc0dLHWNUhL1I8X9W35Rv4vbpI2KwzouKThstXRfKuyCi/GJKY95ljsaUeWi6ROoFpRucAk4QOFNY/5ruVb+E0PlILgmOQtZMJ67AY+Um5/JXHWRY7xUBSiw8R8M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa20594b-c59f-439b-d138-08d720eadd63
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 19:09:00.6196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tpPVX4ZACdzpdD2zA1v0I9Zm82aw3RPJs+uewOGUatx173c09CWas7teQcRts//yfECVeELSA89hgdeQ5ZvYzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
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
index b2eebdf..3c7fffa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -110,22 +110,131 @@ void mlx5_hv_vhca_invalidate(void *context, u64 bloc=
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
+	if (!IS_ERR_OR_NULL(agent))
+		mlx5_hv_vhca_control_agent_destroy(agent);
+
 	mutex_lock(&hv_vhca->agents_lock);
 	for (i =3D 0; i < MLX5_HV_VHCA_AGENT_MAX; i++)
 		WARN_ON(hv_vhca->agents[i]);
@@ -135,6 +244,11 @@ void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca=
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
@@ -168,6 +282,8 @@ struct mlx5_hv_vhca_agent *
 	hv_vhca->agents[type] =3D agent;
 	mutex_unlock(&hv_vhca->agents_lock);
=20
+	mlx5_hv_vhca_agents_update(hv_vhca);
+
 	return agent;
 }
=20
@@ -189,6 +305,8 @@ void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_age=
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
index fa7ee85..6f4bfb1 100644
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

