Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664A559B56E
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiHUQUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiHUQUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:20:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2041.outbound.protection.outlook.com [40.107.96.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7910B19C33
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:20:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXdNQIglhNJIg+i2fvAujjTXZGdx8LTfT89+/BDd9SXnpoH8EVuKv5dMi9uA233jFUlVAJSoVad4ayv9GfooIdiIvk/9xQddXU6B46dIDRzJAay2fhF06krD5qXdOuOx5UVj7eJOav0zemcmAQQPeTd1z6ew/LIiaRMDUUlJ7lXpZuakMknasRySXco8oqmopTziASVQI3QWAKKQWKzHYn9bNLU8YM2XrUG4NKvFnMrYtwUdEkXiMCUIgN1d8UXn3+qOyKyVOTCNIw0yRtO6islChgH4OXsu21NrwpjU0JoFpaNtKnenaZkvnGorkMx3X8gh+oYm+Snplt8374VTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQySn/Br6LM1BwDO0lMt8XPXBNViAB4e51HSjAkh0fk=;
 b=RjlRRg4oKPXRczK/AU51+OcXSS85qKRqQcHryuZiIgUJzCrDXDcohXmM4gBpRGZtVCMjWPjcJ1YwcMljigQKCyXGf0Tf1Ycpg0jJUqgQEULu5avHeiWWzl2lcAZWUMuLX+fhaXg0+UB5q0ff+yHgtFpR9u6Nkt2D7reH7ehwJwoYH/HKX2WJlMmd4p2sjMmso5KFLnmcw9BtAhj/JOB1jEDgvtaiWu96FGGFZuqh+Vq0h7XWeEmMks+W9p7UH1o+NnmsMw0LTy74baKZdDSoZsoHYZCQO4xDCQ6jkTvt8Rms8aogXaKZaAC3FWYuXopuVFBl2dw88MyOEjN7yLZ6SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQySn/Br6LM1BwDO0lMt8XPXBNViAB4e51HSjAkh0fk=;
 b=ZvRNQipj5jbnxmAu+Nl7OyKM2DXrs+MIb5Qvm2SeJVTtrKA/0VK0R55wEtMQs/I4FgE03tfCOwjfWkJBlw36OwdwIjIxZxXjPQvqHgEYv0QKFHfxZboxXmQ2C4WY3lLVwvi7ElIPHZnKtWWfS+rmMwnfKGtGtvlalp61GhXebLirbINyUQYvDClQ4UsdQL3MmbX/rgMg0E3Aw2MiTsIxmiw2JmF9OjP4BE209Zj4y3oARpiAc/5FKkl80a69oyfUMhC/Gm6ZIzXsFuMopOpndgPLmV5QYMrvnYcLFRTW89KeScsbnAyHeqKTCwSm5nVRMtyWTk86Er+QPBsZbBOUBw==
Received: from DM5PR07CA0103.namprd07.prod.outlook.com (2603:10b6:4:ae::32) by
 BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.19; Sun, 21 Aug 2022 16:20:45 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::e) by DM5PR07CA0103.outlook.office365.com
 (2603:10b6:4:ae::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Sun, 21 Aug 2022 16:20:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Sun, 21 Aug 2022 16:20:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:45 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:42 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: i2c: Add support for system interrupt handling
Date:   Sun, 21 Aug 2022 18:20:14 +0200
Message-ID: <96b0d90c1ed9fa5ca2b3ba5e3ba572155ad01b87.1661093502.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661093502.git.petrm@nvidia.com>
References: <cover.1661093502.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27a7aff6-c24c-4ca3-883b-08da83911a09
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glDTTDZlnnovqPbbvvrh1sSgir5bwCedyLGvBGLF2xZ4SNoaTaFFUms51WFxfPiKQB9/6NZ62ClSLjnHXKCT0uDIlZBUB9ZndxA27UqqHg14VO1WPm+rUk9c0Q1G9hoxERpoTobaEF7JOfT1Y+YdKA0yht2GQDivp10pf+WquEK/d/OFxdUcr8DBaTHmTwsjacwIYL6dXyu2gpREBqSegu1NlDSzfUqp2oFn+tHr2z9GraD6yS+Hu2tqHa8avmkfr4nFr5iY4U3gc6+j9tAH9YNJkaPjZ+bDCCbRlcR3P55I0YqhMIgaBwJdQFKi/8LHouyX4Z01EsvBEAEGaeyxY7pslb49SxMg7QyFIMfHTbQ/oq6ivxGEOZL5k/+xA5+CyoB8eWa5ghwtSPGC5+cHvSKbhnWPtTR9e1/zSb0clTV7qiHRiX7w+wlSub91d8SvgFndY3sT915FFLnz+kZYnyNuvj811AcMi8LacarnmikundCTwdWMYRrqmq8LuygYxCddr2GccuO2Eo6doR/pX47i9IuyfKyR5y+LRW6jaJFZF1ectzetGSjZnB3Om/WTpkXcau0LrxyL2F0iMqbX18yf3kUoYUCMswtnCSOd/WMEKsShbI7re9eflNY1hdDeIKxvVAgj4UrqZjWPBpdqsfJ7IAQv5t42Dl5f1/QR6son073qRaXpplFFlSqrLQkChzYqGr7mCWFLBl2X+txlKVGoUwBud5L7YSM3ch9P7vyScy29tprG/hLU0SlHN683zFOkRLaxjV3AIMNEZ6V1ll8jT3Y3RNWLpqocSs4Yl5ghriKyHFz0ZK2Vz3t4oaor
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(346002)(40470700004)(46966006)(36840700001)(36860700001)(40480700001)(356005)(86362001)(40460700003)(81166007)(82740400003)(82310400005)(8936002)(41300700001)(107886003)(6666004)(5660300002)(54906003)(110136005)(316002)(478600001)(4326008)(8676002)(70206006)(70586007)(2616005)(36756003)(186003)(83380400001)(16526019)(336012)(47076005)(426003)(26005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:20:45.5581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a7aff6-c24c-4ca3-883b-08da83911a09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Extend i2c bus driver with interrupt handler to support system specific
hotplug events, related to line card state change.

Provide system IRQ line for interrupt handler. IRQ line Id could be
provided through the platform data if available, or could be set to the
default value.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 87 ++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index ce843ea91464..716c73e4fd59 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -9,6 +9,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
+#include <linux/platform_data/mlxreg.h>
 #include <linux/slab.h>
 
 #include "cmd.h"
@@ -51,6 +52,15 @@
 #define MLXSW_I2C_TIMEOUT_MSECS		5000
 #define MLXSW_I2C_MAX_DATA_SIZE		256
 
+/* Driver can be initialized by kernel platform driver or from the user
+ * space. In the first case IRQ line number is passed through the platform
+ * data, otherwise default IRQ line is to be used. Default IRQ is relevant
+ * only for specific I2C slave address, allowing 3.4 MHz I2C path to the chip
+ * (special hardware feature for I2C acceleration).
+ */
+#define MLXSW_I2C_DEFAULT_IRQ		17
+#define MLXSW_FAST_I2C_SLAVE		0x37
+
 /**
  * struct mlxsw_i2c - device private data:
  * @cmd: command attributes;
@@ -63,6 +73,9 @@
  * @core: switch core pointer;
  * @bus_info: bus info block;
  * @block_size: maximum block size allowed to pass to under layer;
+ * @pdata: device platform data;
+ * @irq_work: interrupts work item;
+ * @irq: IRQ line number;
  */
 struct mlxsw_i2c {
 	struct {
@@ -76,6 +89,9 @@ struct mlxsw_i2c {
 	struct mlxsw_core *core;
 	struct mlxsw_bus_info bus_info;
 	u16 block_size;
+	struct mlxreg_core_hotplug_platform_data *pdata;
+	struct work_struct irq_work;
+	int irq;
 };
 
 #define MLXSW_I2C_READ_MSG(_client, _addr_buf, _buf, _len) {	\
@@ -546,6 +562,67 @@ static void mlxsw_i2c_fini(void *bus_priv)
 	mlxsw_i2c->core = NULL;
 }
 
+static void mlxsw_i2c_work_handler(struct work_struct *work)
+{
+	struct mlxsw_i2c *mlxsw_i2c;
+
+	mlxsw_i2c = container_of(work, struct mlxsw_i2c, irq_work);
+	mlxsw_core_irq_event_handlers_call(mlxsw_i2c->core);
+}
+
+static irqreturn_t mlxsw_i2c_irq_handler(int irq, void *dev)
+{
+	struct mlxsw_i2c *mlxsw_i2c = dev;
+
+	mlxsw_core_schedule_work(&mlxsw_i2c->irq_work);
+
+	/* Interrupt handler shares IRQ line with 'main' interrupt handler.
+	 * Return here IRQ_NONE, while main handler will return IRQ_HANDLED.
+	 */
+	return IRQ_NONE;
+}
+
+static int mlxsw_i2c_irq_init(struct mlxsw_i2c *mlxsw_i2c, u8 addr)
+{
+	int err;
+
+	/* Initialize interrupt handler if system hotplug driver is reachable,
+	 * otherwise interrupt line is not enabled and interrupts will not be
+	 * raised to CPU. Also request_irq() call will be not valid.
+	 */
+	if (!IS_REACHABLE(CONFIG_MLXREG_HOTPLUG))
+		return 0;
+
+	/* Set default interrupt line. */
+	if (mlxsw_i2c->pdata && mlxsw_i2c->pdata->irq)
+		mlxsw_i2c->irq = mlxsw_i2c->pdata->irq;
+	else if (addr == MLXSW_FAST_I2C_SLAVE)
+		mlxsw_i2c->irq = MLXSW_I2C_DEFAULT_IRQ;
+
+	if (!mlxsw_i2c->irq)
+		return 0;
+
+	INIT_WORK(&mlxsw_i2c->irq_work, mlxsw_i2c_work_handler);
+	err = request_irq(mlxsw_i2c->irq, mlxsw_i2c_irq_handler,
+			  IRQF_TRIGGER_FALLING | IRQF_SHARED, "mlxsw-i2c",
+			  mlxsw_i2c);
+	if (err) {
+		dev_err(mlxsw_i2c->bus_info.dev, "Failed to request irq: %d\n",
+			err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void mlxsw_i2c_irq_fini(struct mlxsw_i2c *mlxsw_i2c)
+{
+	if (!IS_REACHABLE(CONFIG_MLXREG_HOTPLUG) || !mlxsw_i2c->irq)
+		return;
+	cancel_work_sync(&mlxsw_i2c->irq_work);
+	free_irq(mlxsw_i2c->irq, mlxsw_i2c);
+}
+
 static const struct mlxsw_bus mlxsw_i2c_bus = {
 	.kind			= "i2c",
 	.init			= mlxsw_i2c_init,
@@ -638,17 +715,24 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	mlxsw_i2c->bus_info.dev = &client->dev;
 	mlxsw_i2c->bus_info.low_frequency = true;
 	mlxsw_i2c->dev = &client->dev;
+	mlxsw_i2c->pdata = client->dev.platform_data;
+
+	err = mlxsw_i2c_irq_init(mlxsw_i2c, client->addr);
+	if (err)
+		goto errout;
 
 	err = mlxsw_core_bus_device_register(&mlxsw_i2c->bus_info,
 					     &mlxsw_i2c_bus, mlxsw_i2c, false,
 					     NULL, NULL);
 	if (err) {
 		dev_err(&client->dev, "Fail to register core bus\n");
-		return err;
+		goto err_bus_device_register;
 	}
 
 	return 0;
 
+err_bus_device_register:
+	mlxsw_i2c_irq_fini(mlxsw_i2c);
 errout:
 	mutex_destroy(&mlxsw_i2c->cmd.lock);
 	i2c_set_clientdata(client, NULL);
@@ -661,6 +745,7 @@ static int mlxsw_i2c_remove(struct i2c_client *client)
 	struct mlxsw_i2c *mlxsw_i2c = i2c_get_clientdata(client);
 
 	mlxsw_core_bus_device_unregister(mlxsw_i2c->core, false);
+	mlxsw_i2c_irq_fini(mlxsw_i2c);
 	mutex_destroy(&mlxsw_i2c->cmd.lock);
 
 	return 0;
-- 
2.35.3

