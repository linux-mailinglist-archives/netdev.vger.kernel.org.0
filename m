Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A28F94E3D
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 21:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbfHSTbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 15:31:03 -0400
Received: from mail-eopbgr700099.outbound.protection.outlook.com ([40.107.70.99]:43875
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbfHSTbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 15:31:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfYdr1TKoxQAsJv/obSKH/L7/siAXyRmhmI47lp3GnSFQMx6djyB/GF0CIAGq1twdNY0v6p42YIWI6JpFQIihBH8/HzyfykoRGqWsiSNo5EJyXGBeq9b5JGyFyDp1zOyJTwY9qKbif83Y2Zv2NAkDBaR7tXm6ZOLBV7VRL2kK1ftJj1EaTMeRJM4f8azcLtWq2A1cJBmHjgQwHsbefI8eMEqUM5aQTYHFCoZO35lhcrYgCBRm9WtbbxXvbQpJ8bvTL8eov41W7md0OGdpfa7D38GkHGWWo5ftiP/aC6Zc4uEZCXS+g8w5FLWQ9hP318D6eUhhY9SiGsYZOANSviX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RbVlAL361i/nMEbRXveV/wGUyTbgTNWiMbsooCxWo8=;
 b=PstD0/mSI2zY+gACSwBIcBA4aQJh9RkSwK4XgBJyQgQAf4u+gNN/ovBuB98oHGDiopighvW4Cknct52OYuv8fTQm0VzfP6PYcVj0d8Zd4qU2nhjRDISJjA+EerbJrtnQGW5WuXjEuHTTSiFL872pYx5Rz+HbFPAV2C71uRcZYErwgbplVgmmoj+2ByB9c8gHxmmdI6Czq7Ww6HUCY4HjWHHXYovGAqE3ewzDgwW+ZKKZ7w4LWFrJaxVlUPVHXF4q0o3GLXafnENuMQRr/NKTDwoVWOFqxsbCf7+OOdTLcEv9gL3WnKtwyAN35eGq7NLaUr/zKMMcgrxGzwqUrL3cdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RbVlAL361i/nMEbRXveV/wGUyTbgTNWiMbsooCxWo8=;
 b=ZqbE49OtXQtp0rWzThADRbKBHf37zrQL+hQWqJMP7I1I7kK1CiljKunieCiop+nkT3l4W7xaIbl0AYfozVgDw/6mbZ2EYVAldQAWNG7IGIlh4elTceFMOWpWGZ9UEGRf32m8oyAB2ygtSNQ8WSt8M6mu6eoifh167BBBcrVilTg=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1145.namprd21.prod.outlook.com (20.179.50.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.11; Mon, 19 Aug 2019 19:30:56 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::ddd:8e5b:2930:6726%9]) with mapi id 15.20.2178.006; Mon, 19 Aug 2019
 19:30:56 +0000
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
Subject: [PATCH net-next,v2 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next,v2 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVVsSfAYm8jNOnGUKSC0fr93j2yA==
Date:   Mon, 19 Aug 2019 19:30:56 +0000
Message-ID: <1566242976-108801-6-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 7c872f1e-a449-4348-3256-08d724dbc1e2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1145;
x-ms-traffictypediagnostic: DM6PR21MB1145:|DM6PR21MB1145:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB114503D97F50F81FC6037600ACA80@DM6PR21MB1145.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(52116002)(99286004)(110136005)(14444005)(76176011)(2201001)(386003)(186003)(6506007)(476003)(71190400001)(10090500001)(11346002)(22452003)(6116002)(7846003)(6512007)(6392003)(71200400001)(256004)(53936002)(81156014)(8676002)(81166006)(6436002)(4326008)(102836004)(305945005)(4720700003)(26005)(7416002)(7736002)(36756003)(6486002)(486006)(66066001)(3846002)(54906003)(66446008)(66946007)(66556008)(25786009)(14454004)(2501003)(50226002)(8936002)(64756008)(2906002)(5660300002)(2616005)(66476007)(478600001)(10290500003)(316002)(446003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1145;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W62PsuI0LG0mEMzfkhid7+kSOxrToa/akb6YOfC3twUdlGKvIWhpuXnIP6zHQsU7LMHPEqlcE62+4a3ZoMxaKoqeyPEAmyLNdgrXzcun7GFEQB/R/d0weWRPHxJEQ8btt2UKXfz98yvvWXDCUzflyH+hcjTpcIjWJ6H3PlPN5YRIsZf/cW9LWVBUUE+GciWuJ8yltqSoaDPjcMBtrUjjIRv6pFfO7TjV0vRO+eAugVkq+F9qNTSdUOKEoX4LSJs3GmuthOpea9j3ffNrNiXHpglKhwE6bypSerxYhFXOQMTZ5hYwigViHPTpaa5oj/dEZfGIFKQrrxl5dTDQm+cIJ3/z9VIY/Pniv8NoJjTKsnZ4OcTtLKJlvvQlTzLruvOT/4+9oMhjos+wkYt5jVWNk1x5hUaJ64tptdZeK77pWSY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c872f1e-a449-4348-3256-08d724dbc1e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 19:30:56.6318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iDJtAa3gcXQJn4CWkjl1TKWKtvi7vjXttxdJOKEt7F8QWdWbiR+mK3LKsSPQ8rhKHftN5YTolmAlsvDbOJ+DTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1145
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

