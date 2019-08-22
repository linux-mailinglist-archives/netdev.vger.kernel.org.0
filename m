Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F549A2D7
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405217AbfHVW0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:26:45 -0400
Received: from mail-eopbgr800130.outbound.protection.outlook.com ([40.107.80.130]:26625
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405131AbfHVW0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 18:26:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klbWiPpKyWDjeukXC8kzVdflKXoSr3d4/X0j+sVnPjyx5kJqPIY70dWt6apwpQxVliYkaR3Rw7bzXm3UWDHjmMPc3V885DNGElB37rykTvufwT/19kvouLGutF7m2sHE9Ad3C53SQ/iHth6WE0YxsMzsF15O7511vFupnZdxGyZN6zw76mBKGLpwG9FquUrhJNNsF7SZwS/pPDVA8othkXga9Pbkep4qY3hcwcZyXg/7y7R1I2oJhAZT359cZ7P+0Xp5iae8oPRcQhv/3AKEOmr1J24JN+OBXCdj/zPbl3gI7UZfeeln2cuKjKTLUiYgW5f0R7RhBtrQwVMEbYk0iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsMtAx6Hrphtl0vQqpAve2mvPzW2E6YA1QY4cXYvV6o=;
 b=JmSdZiTHoTK3/CiKh7JegD1/+NmCta4T4Pak/s1VqWuuP6ueij3TjEdu7FY9Zw6tBGDbeRC8AgOuf59Fjr5hRQqlfQrPM6z8U7xB5WvZ71U/yeL5I6jGm5dtKTuVTen6XklxptDTRm9CytbaFiICCb2ms0XDDReGVbPbZ41dtQhfeWK1DpM1lyDWy3WmA75/I36r5iOf6dRMZyjCk0/atWKvtj0tfUei19eSCxwzvMuGoTyDK/DWg7rKi3XrQuoGKedFXjI1H29H2ngxyDVIT7YPWJAIzOEVfL3XZM2oV8VRqPwENYRfzTWvTFRpPhTF/ZgfjNGpA0AwdiEouPc4AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsMtAx6Hrphtl0vQqpAve2mvPzW2E6YA1QY4cXYvV6o=;
 b=bw7dvJE5Qo+iVw6kI5TiccVbI1efL1lkd4SiEZxY3CdqJiIYmjhFtkgm75a6B9UAfydfvK7h3xU8F6ZyHDt2yiuKpTRmx5SINHasFaMYjvU6gBHSjZE3izQDhwuAeFbsdoqNCLkHb9u9dD4XurGI5hVj6CHAC4WOmR+Mhy+pB0U=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1449.namprd21.prod.outlook.com (20.180.23.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Thu, 22 Aug 2019 22:26:39 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%7]) with mapi id 15.20.2220.009; Thu, 22 Aug 2019
 22:26:39 +0000
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
Subject: [PATCH net-next,v5, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next,v5, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVWTiq+FQ+jMaa8UmVosW5tFQePQ==
Date:   Thu, 22 Aug 2019 22:26:39 +0000
Message-ID: <1566512708-13785-6-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 9f5013d6-fb03-4aca-5119-08d7274fcce0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1449;
x-ms-traffictypediagnostic: DM6PR21MB1449:|DM6PR21MB1449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB14490E21C0259E7D70D0534DACA50@DM6PR21MB1449.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(186003)(71200400001)(2201001)(52116002)(305945005)(8676002)(5660300002)(102836004)(81156014)(6436002)(6506007)(36756003)(386003)(7846003)(99286004)(8936002)(10090500001)(53936002)(81166006)(2501003)(76176011)(66066001)(478600001)(4720700003)(6486002)(7736002)(26005)(2906002)(25786009)(11346002)(446003)(2616005)(256004)(14454004)(10290500003)(486006)(54906003)(110136005)(14444005)(3846002)(6116002)(6392003)(66446008)(64756008)(66556008)(66476007)(66946007)(50226002)(7416002)(71190400001)(316002)(4326008)(22452003)(6512007)(476003)(921003)(142933001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1449;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cebrV/8Hbg4fVpUVJvNajj+JWbJLsLTwavYht2ADe/K8DblHdfpVN9yvCvhms71vm4Q8Ar2bLeBSD9/0oipSBvwNTxdTuIelZHRau4LXXCqsKeiVmnixRr+RKIjQ3BbWBg+6/I286IU3nlWfNXnRqpDQmgpb8WLHwZ9CuzDwbZz8KxKEg5dLhyXeqt4OarxRcpUFqx+a8QhezoBYLj4CP7muNgEC7X6sWzV8ylD7QB0jlgArDRM2MX7bWWwzCbSPZLKrscKRysWKXgTeAdALCXyDyWtmJjT5lmwLgzumfUe3+4OYNmC6Gn+jLNLH6xcmrj3IDlwfma8WLIcNEEeQhCYTRH1Yqwl6CcuS+2OcrzDqxiypeULsG3QhG4glBdTqhyAGANUEuuQlI3TffQRpN7dyypkhR+uBW8v9JJ5gTIs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5013d6-fb03-4aca-5119-08d7274fcce0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 22:26:39.0906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kjnALjh6ivJEPyJxSsA7ZrPZUIan12T146HsgJrveJpxwzp+RaBMpXAFFinbAFjoAf1nU9hU61Y2tLTzdZKcVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1449
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

