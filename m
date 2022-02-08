Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CFD4ADF16
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352575AbiBHRPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352438AbiBHROy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:14:54 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A282C06157A;
        Tue,  8 Feb 2022 09:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVsjtcaNSJawxz4CDbxtXmYelPVIWhBY/NfIOIihesAKlgDtwkF8bdHvGylgDGZU8kLuysw9kwmoibg++2ncRlVkwxI9fOtwB4jF4C0GeCzlkLuY4boagiXWq288N10JTCVOA/KHDEsmTzfrXjZpcO5M7KyWrsWpYFz1HHenDwsbHXDSDW9RuTbSG1YlTch5tq20hxr6Ao6M4V9LmS+q6xuZrZ7X0W0U1/zJOiuzUTd5qaGQKXTjAaJthiIkyOuqwQsvPwDIjwN42+a5XPlhaUJvl1QllHjpBD532xHCpZg7siQA9d6oA0Ljt2rCsIJGOKX2tZ5OV6tbuV8fhpEsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZnBWnw/+W2toaRTdq0SbAo6b96Qb16r+UMAcTqnt6M=;
 b=hTf1woH874s6YYu4dpzq8WtwNsbFP4ffdTQxpdhhgDefVj1h83kopzA0PuE3yOf70LdN6nbIyMjFH5E1RW/Xk+iTgxhwYuEzXNre+c1NzD6T5y++RN6EaNYqa1L/A3d7JGSeVpdSsOVgCJ9puWJO4EcZDn/UBB37b/w6qT1rTs+OClH6lU2AIMQka3y+TIQVijzKRPDEryuwztyxxl1ww7oQwwd8Q/dGyzUxezXc0Xxk+DGc1vBYriATnrFhTtMgemUzu3v9jxhh7553Gi1LrH7EeyPcn42jNfR9brup809IZCLO0l9y4iBhfnUGnd6VuAjGzznOfm2jC1XdG7gL6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZnBWnw/+W2toaRTdq0SbAo6b96Qb16r+UMAcTqnt6M=;
 b=cZCpsAUMQomi0j0Sx9YBOGZAaJi5Uan10xjBCX6VRpiPMk8tEpXQ4/LF+s1jr2A2+C4j3f38+Qwa/NkoLML86wj0gJCp5SjUmJFmSCBQpHeMdVBuUN4zwGVuU82KD5iKMKQB8fRsO9MsoSRCY/iJgTdC84AuEAnAWjIbpBvK0N6pEd+a6DpC1RbrQwny3IQToj2Id0iWEzt2qLHX9zxCrKd8AUEfSFn5YOxVZ4rJ0jCanHl+Z6qP8fAZq9RWzphh5wi6+yD/ERx1HP20M9e9kbbOKaiXOkYd7jb6kZCpxCOF7Lv9CtU64dRbBEzEZJDG9kFvtCSdYXYwdSYZg6m4Kw==
Received: from MW4PR04CA0183.namprd04.prod.outlook.com (2603:10b6:303:86::8)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 17:14:52 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::b4) by MW4PR04CA0183.outlook.office365.com
 (2603:10b6:303:86::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14 via Frontend
 Transport; Tue, 8 Feb 2022 17:14:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 17:14:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 17:14:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 09:14:51 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 09:14:49 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 3/4] devlink: Add new "enable_sfs_aux_devs" generic device param
Date:   Tue, 8 Feb 2022 19:14:05 +0200
Message-ID: <1644340446-125084-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf6fc51-be9a-46d0-eb42-08d9eb268516
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB43525056C19430462B3C28FFD42D9@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eJd3sZZNwp+xU/0v7Jl9LgM+mrlTubEVP9tmpAxq/XyCCRa0ElI0MG6SBEHGWxR9/NVfKSJbeRmQgZkX+hPrnsnMGrUgpt+YatVjKbaL07s+ewUWRJ6CZT5eTWc0SYnm8lH5PHmozGtCIOHk4lGhOE86PbvKDFfWX4sKwJIDcpvrTsL2cp8f5jMFta63Cncu0eyLlkjv2vrddgzMWBmMNWzu2NoHmps0LwF9421SWUCQfW77IywIiXk0mDUnltiXS7LTCGOUVwDnj5mCSwrNH7Zu2/FOcaqY4SpixzSe4OTIc0BLaN9Gf2RYP3ZPA36Q5fQPC4GstSaRceM9gsMkNf9qlbMZGKK3znStGgy2Erg33H4ojBrwyPqejgL/VusC3LjPJSvFyVmhzGt/UPDFRvaWCWhHgNcUYxVCWGNsdqbBtXFBquoua2z+2I2rtACqydlZ+kxjcuYO//VLEcqXlqL+0jeCyfbUymSm/Vr/kyu7fvDIPQ5t7DhltnVmYnFXQForVeGI/aU9VaHZ3C8BX+MTHfybIvcAz9mpn/a5rlXzPZ8i0UiWznrWaHCjJqAvmb5vnSdO2o/AegboeZm1GrYlpTVgqdBajYR9SQE3TDIrpMX/hiSxvXoLlfILfq1GhK4fYcpc0/P1LVI59nGC87ODg1Gw+BqJoqa2OdPLmEVMjwzLPUWRPzHKcsJT3m6t1HwUYM8gVmesPWv3GkX74MsI6SotW/xz9jvv7eG3CCc=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8676002)(8936002)(336012)(186003)(82310400004)(47076005)(107886003)(83380400001)(426003)(26005)(6666004)(4326008)(110136005)(54906003)(70586007)(70206006)(36756003)(5660300002)(316002)(40460700003)(7696005)(81166007)(36860700001)(508600001)(356005)(2906002)(2616005)(86362001)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:14:52.2542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf6fc51-be9a-46d0-eb42-08d9eb268516
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Add new device generic parameter to enable/disable creation of
Sub-Functions auxiliary devices of a certain Physical-Function.

User who wants to use specific SFs auxiliary devices, can disable
the creation of all SF auxiliary devices upon SF creation.
After the SF is created, the user can enable only the requested
auxiliary devices.

for example:

$ devlink dev param set pci/0000:08:00.0 \
              name enable_sfs_aux_devs value false cmode driverinit

Create SF:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Enable ETH auxiliary device:
$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_eth value true cmode driverinit

$ devlink dev reload auxiliary/mlx5_core.sf.1

At this point the user have SF devlink instance with auxiliary device
for the Ethernet functionality only.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 5 +++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4e01dc32bc08..aa0edb915f88 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -137,3 +137,8 @@ own name.
    * - ``event_eq_size``
      - u32
      - Control the size of asynchronous control events EQ.
+   * - ``enable_sfs_aux_devs``
+     - Boolean
+     - When enabled, the device driver will instantiate all auxiliary devices of
+       SFs of the devlink device. When clear, the SFs of the devlink device will
+       not instantiate any auxiliary devices.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8d5349d2fb68..8013252790bf 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -461,6 +461,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_SFS_AUX_DEVS,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -519,6 +520,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_SFS_AUX_DEVS_NAME "enable_sfs_aux_devs"
+#define DEVLINK_PARAM_GENERIC_ENABLE_SFS_AUX_DEVS_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fcd9f6d85cf1..b5368024ac18 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4477,6 +4477,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_SFS_AUX_DEVS,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_SFS_AUX_DEVS_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_SFS_AUX_DEVS_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.26.3

