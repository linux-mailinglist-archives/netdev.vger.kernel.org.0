Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE8F4B2196
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348547AbiBKJVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:21:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiBKJVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:21:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D974A1034;
        Fri, 11 Feb 2022 01:21:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJmszvxl7c32Y7Cl0n/fFhyBIPWt+YmeoTKTMhUM/X3ykZIceADOHt3VGZqPMW9xoI7zd2SGWXZTRdM1orHz88ykvFIkyMmyEGcBKg1MSCoRWXAKA+AXetmWA9za/8katF91UR12M96uqZT2nF60sB6YQTMe8f+dJSMqsdyXcGub3O2m9QUhRBPmdt9h3e/N8uQilMz/d4nZY4BpvNPoPKGSe5PFu8wOjKtr5mVLF1aXeb0kusHiX5yuxU4bUeu58sloTFCRHr1zDF7t3UowYiCSh8Bqkc5W3AWK+jaZZPY3F31ameLJy+Q9HPRQKVomxIHrkZyTQIxwqXhQrcx8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5k8t1DLrIa7Lpc6/8FPOEDHil4UH20t5yO0nrHsCcio=;
 b=CuwUbO10A5pXMkY64SH2AsXV38pDQ6LMwv3CrA5U1k1UahLdcMVTYhtxRcI23LvzqioKrz7IJs7qGNy+0FFMBslkYKwyBxWVICHSN7a8OXV0m0+mdk2E7dVBGqqGJYdQ38DsVHKX/OkYB+z7IRYKjXT6HDgnaSVAOCnf+CX3bJAySRNK87pmQk/l3X72TFxHfShhRM1I4dSafw/fwqvvRGsrFlKKPwk33L5FPM8YDZw2McIT0972mYX0UMG6uG9M04L3FGbTf3AgKf0h584pQCR0RlrmcJ3lebEhfSfh5KTwDd5T8+wmovZwCzRi+xzeRfxB3cmpAOvBZ1IuewWfLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5k8t1DLrIa7Lpc6/8FPOEDHil4UH20t5yO0nrHsCcio=;
 b=ANh/PKtpZZ4pSvzzi9Wnf6vaQ1g0dQjEj7X/atsQqgKnOpXBu4myfvFV4mGE73qOIHUevwdJfajp+CbcA8YDkK2YyYXHacV6YSY09Cz1TqVgOvMVAzGGxcfB0NSwUt/pe40zYLlG9lvwJ7YNPiOYtBJ48u7Rqh/9PHqZVRCeZwtn7JgoyFSKm9b3Fa2SS+uPnVAFcScabPLWHD5/vJT1/uTDfMEX9fOA1yKn3f5tUxOlzFTG6gPPEZOYtozLaSTkv3RSzcmpNJA3v/6Ds1lVcTZan8ww1yKm6eMZvIvlzDqtwbel/tzMx0N0BYR/fmbdb2MIWKMLGvBOI7Z5/I6Xjg==
Received: from MW4PR03CA0013.namprd03.prod.outlook.com (2603:10b6:303:8f::18)
 by MN2PR12MB2989.namprd12.prod.outlook.com (2603:10b6:208:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14; Fri, 11 Feb
 2022 09:21:06 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::d8) by MW4PR03CA0013.outlook.office365.com
 (2603:10b6:303:8f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14 via Frontend
 Transport; Fri, 11 Feb 2022 09:21:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 09:21:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 09:21:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 01:21:00 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Fri, 11 Feb
 2022 01:20:58 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v2 3/4] devlink: Add new "enable_sfs_aux_devs" generic device param
Date:   Fri, 11 Feb 2022 11:20:20 +0200
Message-ID: <1644571221-237302-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
References: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63418489-9feb-4f8d-477e-08d9ed3fd4f6
X-MS-TrafficTypeDiagnostic: MN2PR12MB2989:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB298900DBE00A4A5A5D085058D4309@MN2PR12MB2989.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEJS62tcvAjHjG0xJNklSQW6A2Bzgdgd+L8n512IVLuRED1ctdFHhGDBVhI1qG+dUFkWCYEcInkBXb2ChIgrrU3xkC+hjSX3BUTldpS3roakBn93xRFrZ5kukYE1gZiGlRB+t+oFUb7Labhk8AM615gmJ9iJOhfyZjKWJz8YU21Ga4TspIVOTtTs4ASgotbsVJ7v3Q2ihgfcprz60hsb221ZXckCgI8tJJCHnqcwhfR9F2R0gY+BHb9eXF/7jIVvfd18FVjr6UtbFxWlECQ3gSJyReWzZha1wkMHgpM6kVpZFarK5yJolPN/zOgoA0qlaioVVd6ydC8ZwYlH8QRSFN+BNnjmkfhnR/IRxWc5ZL4BXCH3Zs3+5zml2TKzb8UgGJ4pAmUF3KB6p5Qcd49Hee9SwB/W9wa96XC/ujrFx4mi0IB4DeAHOXKgVq4GLfjlDNNa1giSdpzOKpXzgexXF6x6BcCfF+S8u1xsYEaIeayutg3AmWaaX2npn3ZIkoVjOTySiHxamQW+e21HU7va5uPtnDRXjKvuYo0NORTnznLB7u7+b/KbH6FLpFc9oXymyTimzhBvz4ewq3OzRxQZvpTV+rabLcc38ATTYYaq5FRsHu3zM/wWeuRbsGTY7Nc1RycdK9hdJa3hZos+zk4B1Ahojmtan4lQusMvKNV3IZozu5xCT6o75efLKxscXCRirT8sIKolvdeG8KmfVBaBDHIrwAoABGohEVCfnDK2kFQ=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(6636002)(316002)(7696005)(82310400004)(6666004)(70586007)(70206006)(54906003)(508600001)(110136005)(86362001)(47076005)(36860700001)(40460700003)(426003)(336012)(186003)(107886003)(26005)(81166007)(83380400001)(356005)(36756003)(8936002)(2906002)(2616005)(8676002)(4326008)(5660300002)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 09:21:06.0174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63418489-9feb-4f8d-477e-08d9ed3fd4f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2989
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

The new parameter can be used also in multi-host setup where ESW and PF
are on different hosts, for example:

Disable SF's children auxiliary device probing for the specified PF on
host:
$ devlink dev param set pci/0000:0b:00.0 \
              name enable_sfs_aux_devs value false cmode runtime

Create SF on ESW side:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11 \
               controller 1
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Enable ETH auxiliary device on SF on host:
$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_eth value true cmode driverinit

$ devlink dev reload auxiliary/mlx5_core.sf.1

At this point the user have SF devlink instance with auxiliary device
for the Ethernet functionality only.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2:
 - updated example to make clear SF port and device creation PF can be
   on different hosts.
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

