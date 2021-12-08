Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2246D57C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhLHOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:21 -0500
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:36577
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234948AbhLHOVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlHecI+K68/ZO+nAMG9awYibI+jP5/YGqiBYVEV8ds4glYYBzm2mnhSsQsI2Xz7V5hEIprgmEWUI2bSB96cowyNsDuODdyC4qkGcMndi39QdYfNKw1F4o9X8ZfGUdtXgqlxb++frTwjo0oqQjFnkk/h/NgVzwXXMII6ktCQISD12vjn8dxkK013bLWkBloR/3MEE+KcCoJRFc946hVYcQjxAQJGc7W4VEoPGrF/OdbIweYzMRS9NpK4fDv3cUYCGCG+3N8pNLp/3A8f0u7tfYvmULOr1K4TLQasECWRUcRrYmc62/1OAjhgUIHHDjfIsFuDwIPGmAZO6RW42As/Stg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4+owX/Kc51f2qGuomXT+bTD7rCJeOcYuODtOJgND6c=;
 b=UTjUvN3aD5EjPqmrut8dL57LgfgpkVmvTaND1XIiZ67GSc63scTtY2bcZ7OEUOWcYw8FlrvnB9JN0aXG6wJrcBHvhG/ePwXG9kIMQTZ9U5TiPufI7K0Mai/q/7VTWIwPrT5XQwhglyJFVBxVNQ2JN8SOqPQxNlYOev2dfvNxtfGpdDg02nB8TNWrhgP+B56/zUcehnwHoFfbm0SLSK3NVKwF8+/UVrE+ulnMlQm5ih1HEkxsfKzi4yggpmkpFhr7UUd1t+NFmZ4go35TY0XjcE54OZg1vT+y/jm6JfneiskzU2wcoWnP6AGGvoK2jRVB2mmrU/SDXdx1OsltX+XGmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4+owX/Kc51f2qGuomXT+bTD7rCJeOcYuODtOJgND6c=;
 b=ahuGm1G2uWaaz1qIlgx7raggw3bMgLWonoX5hMbgueSKlBhaSCMpLo5CozzpHcE199mLjPJyDEyZWK2NAPs4rTORaHfG1YjokmwhkYPP0EcP+0nnHMTp4M80etWfV5drv/Qh7Q98mC3P1Wc8FkjeuCKJeX+6ydfiaQi2hmGnQQRdsxW9mhFtM6j+xppL1MWbsHgRhvfdzqDyj+Gcg7tSaE0OZPfuxyB2p2gBHLnBUzn0T7YoBBmw9xd96fLsSFQZh4r5gh6SvbP0Ns7Rv8NKZh2Yh+zP8tSbNkagOmw9fPLCSbzE+Y5aeMY2EM2sYttilvnEHkdpWUgC4pC8/cS1OQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5117.namprd12.prod.outlook.com (2603:10b6:5:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 14:17:47 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:47 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v3 2/7] devlink: Add new "io_eq_size" generic device param
Date:   Wed,  8 Dec 2021 16:17:17 +0200
Message-Id: <20211208141722.13646-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f95fac76-55e6-4028-2d1c-08d9ba558216
X-MS-TrafficTypeDiagnostic: DM4PR12MB5117:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5117129C2DF5BE079957DCCACF6F9@DM4PR12MB5117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYDeVFzCc8MY81IxHPvoaxyB/WnI2T7E4GrDN8L1notn3Xg6Fl96gNTvqmh7yUaFF/oXV/eJlQ9c8rqn9WZDwugaOrq6bB9NWdbWe7pEKG9EkJ7YjEhH7vGmU7jCNA6LSEcUwkFiGyxmRdT9hQB1Hn44qZBkoC8aozmr7OJ0E0SUFvyQbnOyXe4GbTMhibdpkqEQT+hBlDIDJXkSlWCLorZ4RLP49onMFYBw1mEsZH/vJ6z8FqmRgrQay8aiiYCxMwLWWFSsSZCtWKAELm4LxJo84yRHwrlSOWfYDV2t0xF/hFaNHRDZprsamONnF78qB1kbJpo/3j5aWNdZ58fB313oKyqK3mQyUxnOvytRjGcH6tJt5IpfXYQN3jhioTvf0IA5pOzpCWGTnI2BlxtWQBx60rdYQqZ62zTf7rF0Rs9IG4wRH9Fo4uTJsE9VvYJHoTTf2fnfd7NpSMnGBIi18i0w60cVa8yj9+yG35/W/k2ZhvMV4jlmvDsPrYAZv8gTcHQ60aoFw124C5Dt7TSU8Jq0m+o4/M1NeFdgiuHT8MUO+//4sRxdPn5WzwH+YLa1QXbXZZgVsqc+1LTjLwQR081OQITJ9wRDLy/UIH83CGYNjwzGHuLFe08s82mQMrb8V2kXBaDC5RRFInDFBgn7gFdbc7qUW5bFA2fGo1HvYpywE0V7Z1E4SbbiljrwVIcNgIe9FpJUBu7Cb2823Cy0t0IOCVNeRIDu2Dv3Ia1CDk4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(316002)(83380400001)(52116002)(4326008)(107886003)(86362001)(54906003)(6486002)(110136005)(6506007)(26005)(66946007)(66476007)(66556008)(6666004)(186003)(36756003)(8676002)(6512007)(8936002)(508600001)(1076003)(2906002)(2616005)(956004)(38100700002)(38350700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/5E1EhE5rHu2zdvf8OwH0rzQPK9cFGIY3KSwLpKmWTejw48i1OzCacil0kLL?=
 =?us-ascii?Q?xjML/n4n2Wj99RhyleaEdvcmEf4l2/qqNFZu55GMnHg9OHp1NSLuZxPhYaCz?=
 =?us-ascii?Q?IRO1+GQhqVplny8IRVKTRtiHqpczr7r58UpL010e3Z85TPECJoffONkUHPhp?=
 =?us-ascii?Q?tXPk+SI+hOXDiAR8ScufDyGCI+fBHi52ef+lItHNFxZI0F56MdW2o7mfdSHT?=
 =?us-ascii?Q?4/keprOIkZh4sKx/MeOZkYkd6JWgRWenvHFo2m6g1l3Je9dvzdkiQSZ2t5WH?=
 =?us-ascii?Q?4TulRfxpFAiwvUHOvxi3kZKD2gBIeUpGsVZZZhxVmVK7zmdEwqiq/L1bftq+?=
 =?us-ascii?Q?kN/A9J0PkvqW/AGIh74Uxg9GLiZiX7yezQXI2+fnwy2nLt90TGfvHyB4us0m?=
 =?us-ascii?Q?iysQ4NEn67SU6yuEgQkvLpx2XWsKquUEy0FCnrmgFUcMeKSXq8Ti6vr4byNH?=
 =?us-ascii?Q?9TKxqMevbdwhuOx7ea4NXUs7w6JW/2s5IDpGdHRDW4r3s5IxZ0KJu6nonfdf?=
 =?us-ascii?Q?CCEL4uzPyu6v5MlWoyIAVGpyNXGyurrp5cplWPMCKfkmpNAuGWl9DGGodHw4?=
 =?us-ascii?Q?MYsCp9/zZKJhRNtmvAvgnJGlmGhXjBI5iJ49cQqyAmptx5+FSu3Ee3C3YtWm?=
 =?us-ascii?Q?17LlVJ8fnHwjAJPEohpyWp9xWmCGiba2/nedV2o4BSif0Jj54Nlq56/COf4z?=
 =?us-ascii?Q?5o+BJWZh3sX5gzM6S1IngXWrE2tIie1hPdgi+rCVnHiYG7esTEYjQs8uKES5?=
 =?us-ascii?Q?0mTYXhdbkzoFwX77UcIXHXA/Yp6BAlW5GDV9YImBIVtG+xSfkaGEs11+Ausx?=
 =?us-ascii?Q?EPLmxdGPYFZGhTq+rle+7TUzGHkjsDGqCHoEdnWfat2dCz7IzjGRp/9mubKy?=
 =?us-ascii?Q?5WU2N7Ki64ece8mPWwKIIYMrqVskgW/YUBpsGuCH610n7sZnq5FWtwRBXbt0?=
 =?us-ascii?Q?R+HDhq9rByqqtjizOwASov5OAdR2SqfirsUleRQ5CiBN/vBQ78cNrly07G3r?=
 =?us-ascii?Q?TwFTRjtyKPGJUQRxFdZ9WqKiopFuCWROFm4A321V5yDvAuMan3cU+D5TBtWB?=
 =?us-ascii?Q?Lzgq2lRlYE1V73/1oNDIpc/pRQNwSzG0TzKt/BLFAPCPrA44RcYvCWyeShUb?=
 =?us-ascii?Q?YhZ2yIJ+wrVuj46fRTqOOe15y0yWPy8+LTDwnWnOEUQxKXQyJoiburoXSTf8?=
 =?us-ascii?Q?ADZMdDUHyRvKb/NibBZwRpOk0Eu+LN8j4wiKAacSehKkofsLz6RXoruN//IU?=
 =?us-ascii?Q?pZoAh0t4GeAwdlhJUuBZPmU5fMKZBA+WJXohGcOgnvj54z3e1TQjgrUUCcYE?=
 =?us-ascii?Q?oRXspC/hNSzEQ48KQORFFLZgBb/6D3xtr7YwGP1nFfHWrsOczOs0pkAiWB/R?=
 =?us-ascii?Q?ruiWuIBQi3J6fhQEkgjHHDg6U1TWEMcc043nU611S9BwmJ3jLXxG26jlENJv?=
 =?us-ascii?Q?9EE0LyxyC8WfV8aFNMVmdtIRniy3QRckkeiuckScXnlHyy7uyQujwF15/FEo?=
 =?us-ascii?Q?0gyTri5bEoJGnh7fJnp10eizjZbd1HcNBp2OEl9SmlT2hGGoU0cPY5e5DEji?=
 =?us-ascii?Q?1B1W26vvBo7xEpHH+d0Ody2e8yq5kOJ477pSkSmhBoHIaNhNFdw/NhwJqhhl?=
 =?us-ascii?Q?gk4l7mbwRVyjvd7zN12orF4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95fac76-55e6-4028-2d1c-08d9ba558216
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:46.9672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnQomFMaWNuJS1FQD15lF0y7yguC4sEoYupelqBfsq+gDGqoPFVrlNw3r1BprdQhjF+B1Xz4yColU8mDE77/xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to determine the size of the
I/O completion EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink dev param set pci/0000:06:00.0 \
              name io_eq_size value 64 cmode driverinit
$ devlink dev reload pci/0000:06:00.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index b7dfe693a332..cd9342305a13 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -129,3 +129,6 @@ own name.
        will NACK any attempt of other host to reset the device. This parameter
        is useful for setups where a device is shared by different hosts, such
        as multi-host setup.
+   * - ``io_eq_size``
+     - u16
+     - Control the size of I/O completion EQs.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3276a29f2b81..b5f4acd0e0cd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -459,6 +459,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
+	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -511,6 +512,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME "enable_iwarp"
 #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db3b52110cf2..0d4e63d11585 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4466,6 +4466,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.21.3

