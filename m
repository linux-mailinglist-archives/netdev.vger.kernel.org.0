Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86959B56D
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiHUQVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiHUQVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:21:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EAF1EEC5
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:21:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUy0m7feVET6QBDCKXsEQAITot6fK3/deOYCwaosXmK37bu6Ze+xcCRtu1ergiHDLETJjTi6cJRbnkwD/Ac/bxRJg9w4vr6gAahGhvzNV3b8tYcZKhGks9taVuuxtFBKypcvjhEQIrCi3MzDtlOraM9WsbiQQz5eCc3dcDCKQgI8z6L9WvRg2I3UQSXu/auQe3FnfBbtdfB3bo/WJw1yv75eBtbM+QHrx3r6ayv/VwRylypc9pXTE1mrI4KiXqQSBnW7FuGL05tB1/kaXHatkvLRV1rvUD1fvggEAfKQyq9vAbx3EVLgeFe0r53y5ofmQRA+tLzudBIgGX9ved1Xow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mi9mYRN8edor7VO4WxPy4T35/NIYHxFJAU96rdke504=;
 b=iw87wZNs4lxR7aDS/HqHsD6pYftSMf++xIwyVVuOychi9zL3DmBVQM1LexPgJ9C0ar01SOFhq37xeLxxZqcSPQom3jJVYeCkZFUtIo2J2pFNWKPJ4XtSz4u+EX3HS0CAP0SqC33s7BuRWR7HA1shgR6JIFrlJU/EhPLNc29OfWpwczfIclCbAICClMKV+Z2pBFaVH9u84fZ7hL4wTIhNKGIcQjpcgHqQSgmd4I12sevFTiIrWHqr+qvnIJS3H3NWtSxy23DHnTahtBzPcz6GTVgUBgosAXP99r3TBW2tQyoWd+wEsMNO2aYDFy45CQmDd1Xo4DpfVFPxBXvmUCt6bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mi9mYRN8edor7VO4WxPy4T35/NIYHxFJAU96rdke504=;
 b=csCJXPI6KjA2ZliBrx/IE9yBVc70b1sGvERzdfOW5cGtwfLvqX+JN80NM3Ocs2uptybNw+nGUf8Ov8IVSbIB5ar7kX1INP6F2lSCz27c6L4VImC50A1I67C0Gw/AK+6j2mDZTPY0tQG5N9Mkt1kZboddSaPKjI2xmNQ0fGRqiD891TC0MwvfaKI/iqyK966OLXZZfZCeJk+aRthScvzLgqt5UBCHaTkzmWjJ2+9Nf90TSnTZamYNXbdT385LsfNib5UXsKGW2MxZ8V6xFgiX1lbgyLs0iN/cOZC/W6hIxHH52u6MUY8nejqWbpWAzcC/m5elokWRFgEGqWqWmUwsfw==
Received: from MW4PR03CA0111.namprd03.prod.outlook.com (2603:10b6:303:b7::26)
 by DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 16:21:13 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::39) by MW4PR03CA0111.outlook.office365.com
 (2603:10b6:303:b7::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16 via Frontend
 Transport; Sun, 21 Aug 2022 16:21:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Sun, 21 Aug 2022 16:21:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:40 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:36 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: core: Add registration APIs for system event handler
Date:   Sun, 21 Aug 2022 18:20:12 +0200
Message-ID: <743d4f8a4f87655340821ccec5698f8d1240f956.1661093502.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 274e1130-b09a-4be9-f496-08da83912aa4
X-MS-TrafficTypeDiagnostic: DM4PR12MB5054:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 10QgK4MQhfn+/fLep383+xljayZbVddObOZ7c0o+RnIn6u86hc1zDLJFlkn/ucaTTamUPaldl5bALWp0UgknN8clzSwlnH0slTlGxlRWXMsnmhMuEFekE1cP5ATgSL2cz0r+E/CJ3La9lnbnPczJ5p8998ouKkVUFaYT2560D51lhxGkizVy/N71NlauWwOrspRoHz/WSD8LuZKiFMMIYz6wq09sVesein1UFXf+ywl/I3M2jKNegt4E9Ed4s3eTXytqEHb+royvxrY91qicgj9rV6OSnMLR1XWhVWvqZ1NS62gp9cjSm39NkZQM51O8aiHrftv6xK45DYQP+SB9LkSuar8kG1s7rY1JzxLeP7S56BvFHjs2knbxX5vuTp3z1oP6+CbXF38ARQAffUAVdji03d78r14Ycey6jsknXfgl+SHZYMyliYJ3YCjFLI1ibtbzuD0+3FqJGSbGm21s2C7CrMXnQniX2fnVAruwW55GLnqDzBrsWXAqeQK1sAuwPgGTbGwJLX5sQUWXTxwqOpjh6ijDMUcD0liKtuVyALlhkHfmVQnlauSrnwpaE/gVrb228GiTLXETmNapT/L0mOXCqdQCQiverI3tBvjfYEWwN8P66eTQsWR64r+zpxSx9A7bKUFvGTmQ8W6gn6flQe6AgbA448AofMEN7/zSNjlTke/LH+15l52eRPsdadvOIuov8cIO5rwZSrTymA5DjFE0gB8wq53zainlZjANkLagZc4RYU7qKpfjfBZfS5vylnoKN56E0D7Gq4nRmEoBE8+FvrqbcSIgbtCGvuVhRaV3NHVFB93pB/P2E1SRZYcY
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966006)(36840700001)(40470700004)(70206006)(356005)(70586007)(4326008)(8676002)(86362001)(54906003)(110136005)(36756003)(81166007)(36860700001)(82740400003)(186003)(336012)(16526019)(26005)(47076005)(426003)(6666004)(107886003)(41300700001)(478600001)(40460700003)(40480700001)(8936002)(316002)(82310400005)(83380400001)(2906002)(2616005)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:21:13.4046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 274e1130-b09a-4be9-f496-08da83912aa4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
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

The purpose of system event handler is to handle system interrupts.
Such interrupts are raised to CPU from system programmable logic
devices, upon specific system wide changes, like line card activation
and deactivation.

The purpose is to create an alternative to trap mechanism, which
delivers these events to driver over PCI bus, but not available for
the driver working over I2C bus.

Mechanism is system dependent and applicable only for the systems
equipped with programmable devices with custom logic.

Add APIs for event handler registration and un-registration and API
which should be invoked from the registered callbacks when system
interrupt is raised to CPU.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 68 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  8 +++
 2 files changed, 76 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 75553eb2c7f2..450dcd9951bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -70,6 +70,8 @@ struct mlxsw_core {
 	struct workqueue_struct *emad_wq;
 	struct list_head rx_listener_list;
 	struct list_head event_listener_list;
+	struct list_head irq_event_handler_list;
+	struct mutex irq_event_handler_lock; /* Locks access to handlers list */
 	struct {
 		atomic64_t tid;
 		struct list_head trans_list;
@@ -2090,6 +2092,18 @@ static void mlxsw_core_health_fini(struct mlxsw_core *mlxsw_core)
 	devlink_health_reporter_destroy(mlxsw_core->health.fw_fatal);
 }
 
+static void mlxsw_core_irq_event_handler_init(struct mlxsw_core *mlxsw_core)
+{
+	INIT_LIST_HEAD(&mlxsw_core->irq_event_handler_list);
+	mutex_init(&mlxsw_core->irq_event_handler_lock);
+}
+
+static void mlxsw_core_irq_event_handler_fini(struct mlxsw_core *mlxsw_core)
+{
+	mutex_destroy(&mlxsw_core->irq_event_handler_lock);
+	WARN_ON(!list_empty(&mlxsw_core->irq_event_handler_list));
+}
+
 static int
 __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				 const struct mlxsw_bus *mlxsw_bus,
@@ -2125,6 +2139,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	mlxsw_core->bus = mlxsw_bus;
 	mlxsw_core->bus_priv = bus_priv;
 	mlxsw_core->bus_info = mlxsw_bus_info;
+	mlxsw_core_irq_event_handler_init(mlxsw_core);
 
 	err = mlxsw_bus->init(bus_priv, mlxsw_core, mlxsw_driver->profile,
 			      &mlxsw_core->res);
@@ -2233,6 +2248,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 err_register_resources:
 	mlxsw_bus->fini(bus_priv);
 err_bus_init:
+	mlxsw_core_irq_event_handler_fini(mlxsw_core);
 	if (!reload) {
 		devl_unlock(devlink);
 		devlink_free(devlink);
@@ -2302,6 +2318,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	if (!reload)
 		devl_resources_unregister(devlink);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
+	mlxsw_core_irq_event_handler_fini(mlxsw_core);
 	if (!reload) {
 		devl_unlock(devlink);
 		devlink_free(devlink);
@@ -2772,6 +2789,57 @@ int mlxsw_reg_trans_bulk_wait(struct list_head *bulk_list)
 }
 EXPORT_SYMBOL(mlxsw_reg_trans_bulk_wait);
 
+struct mlxsw_core_irq_event_handler_item {
+	struct list_head list;
+	void (*cb)(struct mlxsw_core *mlxsw_core);
+};
+
+int mlxsw_core_irq_event_handler_register(struct mlxsw_core *mlxsw_core,
+					  mlxsw_irq_event_cb_t cb)
+{
+	struct mlxsw_core_irq_event_handler_item *item;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+	item->cb = cb;
+	mutex_lock(&mlxsw_core->irq_event_handler_lock);
+	list_add_tail(&item->list, &mlxsw_core->irq_event_handler_list);
+	mutex_unlock(&mlxsw_core->irq_event_handler_lock);
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_core_irq_event_handler_register);
+
+void mlxsw_core_irq_event_handler_unregister(struct mlxsw_core *mlxsw_core,
+					     mlxsw_irq_event_cb_t cb)
+{
+	struct mlxsw_core_irq_event_handler_item *item, *tmp;
+
+	mutex_lock(&mlxsw_core->irq_event_handler_lock);
+	list_for_each_entry_safe(item, tmp,
+				 &mlxsw_core->irq_event_handler_list, list) {
+		if (item->cb == cb) {
+			list_del(&item->list);
+			kfree(item);
+		}
+	}
+	mutex_unlock(&mlxsw_core->irq_event_handler_lock);
+}
+EXPORT_SYMBOL(mlxsw_core_irq_event_handler_unregister);
+
+void mlxsw_core_irq_event_handlers_call(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_core_irq_event_handler_item *item;
+
+	mutex_lock(&mlxsw_core->irq_event_handler_lock);
+	list_for_each_entry(item, &mlxsw_core->irq_event_handler_list, list) {
+		if (item->cb)
+			item->cb(mlxsw_core);
+	}
+	mutex_unlock(&mlxsw_core->irq_event_handler_lock);
+}
+EXPORT_SYMBOL(mlxsw_core_irq_event_handlers_call);
+
 static int mlxsw_core_reg_access_cmd(struct mlxsw_core *mlxsw_core,
 				     const struct mlxsw_reg_info *reg,
 				     char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 02d9cc2ef0c8..c7c0b3cefd8d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -215,6 +215,14 @@ int mlxsw_reg_trans_write(struct mlxsw_core *mlxsw_core,
 			  mlxsw_reg_trans_cb_t *cb, unsigned long cb_priv);
 int mlxsw_reg_trans_bulk_wait(struct list_head *bulk_list);
 
+typedef void mlxsw_irq_event_cb_t(struct mlxsw_core *mlxsw_core);
+
+int mlxsw_core_irq_event_handler_register(struct mlxsw_core *mlxsw_core,
+					  mlxsw_irq_event_cb_t cb);
+void mlxsw_core_irq_event_handler_unregister(struct mlxsw_core *mlxsw_core,
+					     mlxsw_irq_event_cb_t cb);
+void mlxsw_core_irq_event_handlers_call(struct mlxsw_core *mlxsw_core);
+
 int mlxsw_reg_query(struct mlxsw_core *mlxsw_core,
 		    const struct mlxsw_reg_info *reg, char *payload);
 int mlxsw_reg_write(struct mlxsw_core *mlxsw_core,
-- 
2.35.3

