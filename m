Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC4898AC0
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 07:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbfHVFGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 01:06:20 -0400
Received: from mail-eopbgr810109.outbound.protection.outlook.com ([40.107.81.109]:28619
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731340AbfHVFGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 01:06:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtYVXxm9F/8hKOWCnWZ9Jb6RW+r5sMPGkVr6yeL6LzQYaBM56CqcYF9J4gDTdRSkxMuUXyAlzP23gWqsiUVLY0lMgJVPnO+4enj4aIv0GRq2SkJyoRPdg9LsEadNSbLt1nDxzf1RZHijHkzeuoPZkEU/9IMAzDkD93AKeA6+m7h2QD2emBl8F7oI8sTmRtIKDcMtxUn8fEAWxyBZxEYRxua9CycIt/dQvvFxaDwrp4pu/IdJmC5nkLRZaJ26qkmXYWKG1LlO4ZJtXwTpnooZygY83TEL3LfqShHSoWvTpOs7LdKHxmZL1920HHRuLyLsvJDMWy3uWlqQPPWStxl2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsMtAx6Hrphtl0vQqpAve2mvPzW2E6YA1QY4cXYvV6o=;
 b=BY4KkexD51kcs2wpsYyHIj2cCS7hv31Anz4ESVbxfA7MzmTjwfMoT26OlJsjp6l01LDTJmBE0TzB3hJHhkutyqXMM/EdAHYQ1yTQHKfYS8meZapORb29jiY75cVsB9X3lCcfLguH7fh3n7NzxUPe+ILioA0fsORQtJ6Vis5kfODqNzREHF4a9oCQ2UaHB5D2hNNmgAabbZozsEBOR84WV9nKtfzNP9uMPZcNxM4fwIZfDYMMdkb73pe2NPmqx/+fYH6bDcM7BnruiEHVpUFIZvPWRgwg2nrqIr6V/+KHEmAwbVXXbyMQ8J5lLVGbDO3dr1Mt6rVoADsdl0gIzLVHCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsMtAx6Hrphtl0vQqpAve2mvPzW2E6YA1QY4cXYvV6o=;
 b=MxGlUfVVURykT2YRjKgVvV9v3qJCq24QfQLj0S0/mNpDrlt6QfdNRvggDc5eua2hYFjXVc1djBps6EGfvhKoloE64GzcpY1/KN1wfmxkIpKYb8nmGSslua8RY9PSSk4xriKNRk51eX/58eRLFyf1t8UQ3D4ow0d1q4yuda8yoSU=
Received: from MN2PR21MB1248.namprd21.prod.outlook.com (20.179.20.225) by
 MN2PR21MB1279.namprd21.prod.outlook.com (20.179.21.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.4; Thu, 22 Aug 2019 05:05:56 +0000
Received: from MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e]) by MN2PR21MB1248.namprd21.prod.outlook.com
 ([fe80::147a:ea1f:326d:832e%3]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 05:05:56 +0000
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
Subject: [PATCH net-next,v4, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next,v4, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVWKdHoKK4wQPn+UiFd8cQCSAi9g==
Date:   Thu, 22 Aug 2019 05:05:56 +0000
Message-ID: <1566450236-36757-6-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 12ddebf6-6e1a-4d67-a87d-08d726be6a38
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR21MB1279;
x-ms-traffictypediagnostic: MN2PR21MB1279:|MN2PR21MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB12793E8C76724C098B8BB63BACA50@MN2PR21MB1279.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(71200400001)(71190400001)(186003)(446003)(66066001)(2616005)(4326008)(36756003)(6392003)(6436002)(256004)(53936002)(7846003)(7416002)(6512007)(26005)(6486002)(14444005)(11346002)(316002)(2906002)(2201001)(110136005)(22452003)(54906003)(10090500001)(476003)(25786009)(386003)(7736002)(64756008)(81156014)(66946007)(66446008)(8936002)(10290500003)(478600001)(66476007)(2501003)(102836004)(4720700003)(6116002)(3846002)(6506007)(305945005)(5660300002)(486006)(99286004)(66556008)(81166006)(14454004)(50226002)(8676002)(52116002)(76176011)(142933001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1279;H:MN2PR21MB1248.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RWYtcLajFVR+FfwU+qaLgOAM/j/FI3LBuZLAmtFLBEQv1z3OGa5veVBqV7jcVNDt4+tbHIoNOkEagOyBUgkZj+OefnPxw/LT6MQplU+nbcxnQOrFXfuPOQhqq9T25oN/y2MO1rUCYlnxH+9G18hZCjAUmZvzd12Z2jDCVv+1uIhK3CB02y4mmgXfEIvAkP8AQ2MnaztQXZwZfQQtcitQjXZrq3hdxTNgNNBl3UNqjduqpO+xmZzBTDJaK0N3Y4GH0EOoSt4J4WyVZganQuRva2W1NnvaizasE2ADtLgvJr9EZPNF2TAo1Rm1eNpkAhyf6Ug4W/FtQnGXQiEZvqQTEaaUOinGDgonW/MEOv9ImrgqG0+r1g+P4eBh/BQCrHnBXC+nbzsQ6x4t6mThJUiKERt7KBjNLAymE9euuYCq9F0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ddebf6-6e1a-4d67-a87d-08d726be6a38
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 05:05:56.6053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Dt65JueP6/mt5DbJ/PVzrimGY1P6hnb6/czhXMv98RHNa+uzVPNOa3MEFvnvOQjbFfBdGC9t7KkP3O5LtOcwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1279
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
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
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

