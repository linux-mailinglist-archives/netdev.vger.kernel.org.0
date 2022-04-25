Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3260850D7D8
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbiDYDue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240678AbiDYDuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:50:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9E1EEFA
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSXTg7hOQchgGlvn7Zo+/Bjef8OftwyocC7QWvARo17psUg7OShFXGeTHM1O6V7qlaIsdrE9eO3n0lTIZ49CI9X/zzX5tg4aTb7SqY+clf5jyFspFF6uh3VPlVRUqqI/chc1GZD0uff74B4pzf8L7+gZt581H2WtVKiSA9jSFKIbIXuDjqz2tIsmzAnkYaGsQLB72pnaqVD5ShSnYwphwz3cauNPQcvR/whTCsIRmAVJel3Z/ypL6wG/kQ9N1K/sf1hvSwsmnNDrRc/ZU0JvDnqQ64AYW4w38Ais4EadxlQe1xgbAqgcKRof7HstG/HGdA5mMjLYytNXM/VhY2HAPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PgpZqjs48kyiRR2izfok/sjVHTSzdMTHfx4KMAzZE8A=;
 b=NGT7q8eRzYsBtXvRYFyqOB6ZaZENpJpTYGkLfEzRj+h4PiYwu4EfkSD15nb/xKRvSl2TSCsDpexb5EqzyS+XWeRGVpCPhfJyOBdxVfQowtKnlbLwQEKgKpMJ1CydTYrLzuU0g0eiYlHiBLIgrWY9NzPjELPwW2V+zujtIDUebyd+US8kTKsb5XsbRUVyxVvpxPnbtbEZvhn1atBBxwyph3m2CrnHm0aMYs7j5IbhC6dSLbiX/BY5q5/qEwgVtWg2ohXCua70jeQhGnR3GHEub7PtNuZF2bhK0LsSm6gq7pdhuPQXDCF+7LQXKRK3T/kcwF7vIAOEebjzd/v1EOOt3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgpZqjs48kyiRR2izfok/sjVHTSzdMTHfx4KMAzZE8A=;
 b=Zw2ZhcLCwHR+SdEacSLGqIYf8v4esCvlzD3aUsQNwEGl6nZNynHQLscBNB9bBkEfDt6f1ooa8332SXDszUXShr2Gjue+gep7TGXXJTqiDarwexEXcNU3lPoRUB7m2jFptiuMqxqPqCvl2TgSAfThDYbzOZSTcjeOKn+6eoY7vsitBNOG+02FYTcey8QZSVjmCE5/LqUiRRx4+Fef8JnD6auWNCqHJp1d8RjPGH9lKeWdBq9pvb/nGbqCAGjuIb5l6DGvetdHOBj7larL/dhyVy7365o9iOwHxwohc9tN7sewoVD7ZFJtTsCnQW2OzAOycU7ORZyiW0xHHf5+z75Rnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MW3PR12MB4521.namprd12.prod.outlook.com (2603:10b6:303:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 03:46:26 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:46:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/11] mlxsw: core_linecards: Expose device FW version over device info
Date:   Mon, 25 Apr 2022 06:44:30 +0300
Message-Id: <20220425034431.3161260-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0006.eurprd02.prod.outlook.com
 (2603:10a6:803:14::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dcde429-01e5-44e8-4a02-08da266e2c94
X-MS-TrafficTypeDiagnostic: MW3PR12MB4521:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB45214773DDA2E6FEDD398FB5B2F89@MW3PR12MB4521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86fMN/I7Hz5ArT8M12QTpnGhbgcV/cQvKf4sEyZpp3lgQ+ZBXcm83CHnOkTt4rX9Kr8iOp8xe9s116x1s8kTuMJoIIs1j+nU62pYA64poT0j6EWPvjCQevl+wewn/6I5ETOCQYog0qvfPJvZ7geQlh10jGd5KxM/i/df5I08T/P74a9u0Aj1hiN9dpS/OPbhCqToYBOZSjamdZJYvkxgPgUZ+7rkX0L3CCp5kvvZkj9ExdZJYiORuagbt/ynDZKgFNpCR64TBvpyahnEBDDZInrH4XQVaUULJpp3jtPxm5iVI3xjUFKgJAx4B8D8/CcLz3yD6NGfb2UKfhzsMG9vk6zg2qikHJE1iLGoeT66ETdJDxjydScHQodG6Ov4OrRo4T3euRjJsXihdk2SpQz2wReA0sPinGr5eoUbY8kGr4obdm8Lt0bGpx1UCTdn7jIIMrL8ugheUNCNzQ/RLHZXRjEggwFH3oBJBL7a+Zi8gi3Iy5sMlILBInuwJgTHtz+kD85ABSzLaH9BAVb6FIX17ZRxzptdDcvH59+7ORObqMqZafR+HYiOCQnF18IQsB7u+Cn1nV603XxCwkuGZhvrHHZHaCM4lILV1o9BFBp40z6HuDmz4s3w7U8fFcHuPdH6xLDg2lAHJ2TAwiN5yDSSZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(4326008)(66556008)(6666004)(2616005)(66946007)(6512007)(5660300002)(107886003)(8936002)(86362001)(2906002)(1076003)(38100700002)(508600001)(6486002)(316002)(66476007)(8676002)(83380400001)(6916009)(186003)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KWETZxjXv4z8hF+qnWYbIWa7zZyLPKTtESTAzKrK3/oGxf+Fw27Z2x8C/Ah5?=
 =?us-ascii?Q?dAPpuxW4gavViRegRtw4hl9+8/2IHifxsIxSEJl+DU7v20HyzbpRHWLWw5Nb?=
 =?us-ascii?Q?8vNZvwyu71/3/gxLd+7mqoxYcEJaKR3BVZ8Y4LdUjutlZ3Be+SOJIr8Lo8dM?=
 =?us-ascii?Q?vIS7PRTufU+n1WZd5xNtHwdLbwUgv/Er3A2XWA7ALu7GxKuuoofbjOl/qV/G?=
 =?us-ascii?Q?zcL1Pxmgrc4EyKwjEdV2wEdQfrjMCeavqVKukNfNm4Udl7qAGLoalo4Z2DHt?=
 =?us-ascii?Q?z26Ru6ePVUaqoc+aNBK16BOdY1DEaV/kw6sJt1Z5jASmyuJqTTaJAg7XmVU7?=
 =?us-ascii?Q?1TDKWiVT+rRSGAe0ApqVWh8SFhVzFZoF5UdaoUZKEiftedZfuOBbkkg99PPv?=
 =?us-ascii?Q?t5rKYCVpaBnKjGl2LWMJ0Jkp1XII7Pqk5Q3w8uf1mZ5dq+uUrepzDdFZ+0dP?=
 =?us-ascii?Q?IXEkeA6nTxDENY3+eX04EeNMvQqt6JsvhVwqDWsxlI0NH8SJ+qd3zRU/Dvlf?=
 =?us-ascii?Q?UKwSIMKh2B+HAJ3zt5Kym2gu59yg3DtfDqEdOwT9XepvJLG6GIExBFzU0cfO?=
 =?us-ascii?Q?7QjNOvYMfwp3bAICHJicxmWJLG/389Riw6pmsbsfYAQEy7KE0n/ly316JNRV?=
 =?us-ascii?Q?zxIkMStGFHzybx8FuE5YXseeSSS1T1evw1zqfnFJoQRXv54t+KwQV5gwtXwN?=
 =?us-ascii?Q?2hPLGO9An/n/zZk0F5r6QUtisScrOZLeZNt1vAiPb7nX+4Zgxsl1pk2dgnzV?=
 =?us-ascii?Q?Z+GgLjEAvQbJqAGblg7cmLt/RsNevzCtyEjoB54bWkH39NU7PwTnLJQTJQ/l?=
 =?us-ascii?Q?3Fm5qUzXowyWNQUe+OkP3TNEZv1S47Z+L5qN+aDUYor8xv8u2rW3gGlYnmSg?=
 =?us-ascii?Q?LY53/nTFN4MzKqtzirosoN4dH4umCJkv0Zsg4aYTSL136KhUKxBPz2k8AP95?=
 =?us-ascii?Q?wEm3+EIa+yhozRNlzs6AGK1BOZUf+/nouCus5+zn/eXagN7bZio4f0193Dgq?=
 =?us-ascii?Q?Vl6b8yCu2mcTE6aj/PwohgUodA2x6L1rtoPZUBROgW0Nh89IWkJzYARNpPYu?=
 =?us-ascii?Q?Ac69IeDqU2NqYBIkyEDMOFtspN5U+skaBYOzZFvpzITAbtvRRyzSAmXw8JWJ?=
 =?us-ascii?Q?j1xrF6fvCrHETU7XKZ04BW0JmOZQqIBqRz5dLmDpAozPKY/DIOc+TosX27r9?=
 =?us-ascii?Q?RUWAnfo0WU/gGEpThMMRQdjmS3NlYCyVKQsuuvXjxRuQnZOhXmodPYWacG4e?=
 =?us-ascii?Q?Ptx6LiaVFhhwtxmTLAqeKzR/UiOzMIHmaAUuKwupTkOW9RRp8WlVtkFsFSv3?=
 =?us-ascii?Q?3wOwVO4k8n4AhMFdxQjhZMMR+E2kr7KAd+BNyjZ93LiAuQ4ZjoZ4xLqRnwoZ?=
 =?us-ascii?Q?gRCdoOMrA9UufebHcVNcY/tmmky+6TcWIG+wy1uP1CX3eE4Bi3GYuJw/mN1V?=
 =?us-ascii?Q?ds+o7oKscqYXQpFQhpmerUH2CSdcekF4zN1F8hJdOhh8PfpvuIGL2S0zqrbc?=
 =?us-ascii?Q?ZzZ49V7CM9HbuvvKN03mYzh8LFvp6sbd0ugaXH97BqOX2hiTQ/WyWy5SUkfM?=
 =?us-ascii?Q?WAaUNwDnd+/8X6H0XpnpnVD3W2J/uIkXifjTaJakAIlwoknI/lYVwGEsJeEs?=
 =?us-ascii?Q?IlQQU4O+Utl+gp9OMcfc5F/4kXniez/LqySO91YP6RXZ2VYC8hgbuj5WU34v?=
 =?us-ascii?Q?tb2vx8E7k/odChIuzrWu5vfl7I9z4VKXpSRpoXUU3mSAc6HPkMSB41XYPEN+?=
 =?us-ascii?Q?vQ8atggzMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcde429-01e5-44e8-4a02-08da266e2c94
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:46:26.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rLKTlsmilwjyxl0wCRgSHrAKUja7B9adf1FEdfvIxvm5wBmdeB+Jn0j3Hm95/Sf4rHlWUaN+ayakXN69LtG7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4521
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Extend MDDQ to obtain FW version of line card device and implement
device_info_get() op to fill up the info with that.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/devlink/mlxsw.rst    |  15 +++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 108 +++++++++++++++++-
 2 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index da1fbb265a11..0af345680510 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -76,6 +76,21 @@ The ``mlxsw`` driver reports the following versions for line cards
      - running
      - Version of line card INI loaded
 
+Line card device info versions
+==============================
+
+The ``mlxsw`` driver reports the following versions for line card devices
+
+.. list-table:: devlink line card device info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw.version``
+     - running
+     - Three digit firmware version
+
 Driver-specific Traps
 =====================
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 42fe93ac629d..2abd31a62776 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -87,13 +87,31 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
+struct mlxsw_linecard_device_info {
+	u16 fw_major;
+	u16 fw_minor;
+	u16 fw_sub_minor;
+};
+
 struct mlxsw_linecard_device {
 	struct list_head list;
 	u8 index;
 	struct mlxsw_linecard *linecard;
 	struct devlink_linecard_device *devlink_device;
+	struct mlxsw_linecard_device_info info;
 };
 
+static struct mlxsw_linecard_device *
+mlxsw_linecard_device_lookup(struct mlxsw_linecard *linecard, u8 index)
+{
+	struct mlxsw_linecard_device *device;
+
+	list_for_each_entry(device, &linecard->device_list, list)
+		if (device->index == index)
+			return device;
+	return NULL;
+}
+
 static int mlxsw_linecard_device_attach(struct mlxsw_core *mlxsw_core,
 					struct mlxsw_linecard *linecard,
 					u8 device_index, bool flash_owner)
@@ -108,7 +126,7 @@ static int mlxsw_linecard_device_attach(struct mlxsw_core *mlxsw_core,
 	device->linecard = linecard;
 
 	device->devlink_device = devlink_linecard_device_create(linecard->devlink_linecard,
-								device_index, NULL);
+								device_index, device);
 	if (IS_ERR(device->devlink_device)) {
 		err = PTR_ERR(device->devlink_device);
 		goto err_devlink_linecard_device_attach;
@@ -177,6 +195,77 @@ static int mlxsw_linecard_devices_attach(struct mlxsw_linecard *linecard)
 	return err;
 }
 
+static void mlxsw_linecard_device_update(struct mlxsw_linecard *linecard,
+					 u8 device_index,
+					 struct mlxsw_linecard_device_info *info)
+{
+	struct mlxsw_linecard_device *device;
+
+	device = mlxsw_linecard_device_lookup(linecard, device_index);
+	if (!device)
+		return;
+	device->info = *info;
+}
+
+static int mlxsw_linecard_devices_update(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	u8 msg_seq = 0;
+
+	do {
+		struct mlxsw_linecard_device_info info;
+		char mddq_pl[MLXSW_REG_MDDQ_LEN];
+		bool data_valid;
+		u8 device_index;
+		int err;
+
+		mlxsw_reg_mddq_device_info_pack(mddq_pl, linecard->slot_index,
+						msg_seq);
+		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
+		if (err)
+			return err;
+		mlxsw_reg_mddq_device_info_unpack(mddq_pl, &msg_seq,
+						  &data_valid, NULL,
+						  &device_index,
+						  &info.fw_major,
+						  &info.fw_minor,
+						  &info.fw_sub_minor);
+		if (!data_valid)
+			break;
+		mlxsw_linecard_device_update(linecard, device_index, &info);
+	} while (msg_seq);
+
+	return 0;
+}
+
+static int
+mlxsw_linecard_device_info_get(struct devlink_linecard_device *devlink_linecard_device,
+			       void *priv, struct devlink_info_req *req,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_linecard_device *device = priv;
+	struct mlxsw_linecard_device_info *info;
+	struct mlxsw_linecard *linecard;
+	char buf[32];
+
+	linecard = device->linecard;
+	mutex_lock(&linecard->lock);
+	if (!linecard->active) {
+		mutex_unlock(&linecard->lock);
+		return 0;
+	}
+
+	info = &device->info;
+
+	sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
+		info->fw_sub_minor);
+	mutex_unlock(&linecard->lock);
+
+	return devlink_info_version_running_put(req,
+						DEVLINK_INFO_VERSION_GENERIC_FW,
+						buf);
+}
+
 static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
 {
 	linecard->provisioned = false;
@@ -390,11 +479,18 @@ static int mlxsw_linecard_ready_clear(struct mlxsw_linecard *linecard)
 	return 0;
 }
 
-static void mlxsw_linecard_active_set(struct mlxsw_linecard *linecard)
+static int mlxsw_linecard_active_set(struct mlxsw_linecard *linecard)
 {
+	int err;
+
+	err = mlxsw_linecard_devices_update(linecard);
+	if (err)
+		return err;
+
 	mlxsw_linecard_active_ops_call(linecard);
 	linecard->active = true;
 	devlink_linecard_activate(linecard->devlink_linecard);
+	return 0;
 }
 
 static void mlxsw_linecard_active_clear(struct mlxsw_linecard *linecard)
@@ -443,8 +539,11 @@ static int mlxsw_linecard_status_process(struct mlxsw_linecards *linecards,
 			goto out;
 	}
 
-	if (active && linecard->active != active)
-		mlxsw_linecard_active_set(linecard);
+	if (active && linecard->active != active) {
+		err = mlxsw_linecard_active_set(linecard);
+		if (err)
+			goto out;
+	}
 
 	if (!active && linecard->active != active)
 		mlxsw_linecard_active_clear(linecard);
@@ -872,6 +971,7 @@ static const struct devlink_linecard_ops mlxsw_linecard_ops = {
 	.types_count = mlxsw_linecard_types_count,
 	.types_get = mlxsw_linecard_types_get,
 	.info_get = mlxsw_linecard_info_get,
+	.device_info_get = mlxsw_linecard_device_info_get,
 };
 
 struct mlxsw_linecard_status_event {
-- 
2.33.1

