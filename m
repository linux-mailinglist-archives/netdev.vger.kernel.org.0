Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7454BF6F7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiBVLI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiBVLIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:08:10 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B608B563A;
        Tue, 22 Feb 2022 03:07:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffg+QqDACmsRqHrZHuuIHUaND76G1leIOIK/a877tDM7HD6ERuwNDy7eR1a2p0mXz502S2EjdHswinW6Pw35Z0Hdpu96FT+2RQMnA1VN/YfaKeI1UBRQ5Zoy+yyisTVTsROE0Pn/AJK5DsKGzGiR4pJWbN6OmGSlhL8WGnF+beJX5UqKQXJH48txHYBP2LNFF0HOzbc1WaB2Vva5b8xijvoPVfesDa9VmhREyllDckkHcW88ekjbAUUvhShU55fWuJHhuqwBT73F4Yy8kmhI36QiHfwg9QEU7coucZl5XgWDHV8VJ+w7zZ5w03jphN9u4tRIBdljPRpVMOOwZgzoNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t83gCaByttGbPJlkwwou89R9Parmk3kUqbAzxiWBtHE=;
 b=iDuh6Bodl2xbExeDHJGRVv97cmwoZ0P3cGrZfP/cNwPV8uDEt7/RtlMJJ2MbZvogIjpJWOEpwldp6czrWsHnTx6FkUgfkef6Nt7r2F91UDjsKeh3usy31HJ5HOWQSXJ5LrCI8IZERJ5msRE6ZOnA5e9Di/OdO1LzvEQEUDqSXC5fYGuH0vHAGkmMlrzWW5IJgbEhXDvOLfehsoM09xYY3ii3PHY26LMYf8triMpBvdb0yUAKvdHpmqXxjec83puEUK4kSt56vUKmPt9xIvXQgomibAyNCflR6mznakJteA0VtLywaUGrCZnqkLuK49OZxqzMaQ8kFAdWPCP2FyyHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t83gCaByttGbPJlkwwou89R9Parmk3kUqbAzxiWBtHE=;
 b=sPA4MReDAdzMqbN6XNbYB31xmxvrFyctZdd7SPw5jahZ5hnqDB27GakWmTiw26qFSsuJQ6Tj/e/b36owK3iOmL783Q1KtlDUBkrrD6rljw+/svXSOOs8V7AdBr1JzsLTU9oLTAHbRU8s/Qa1ABZqeT9LCsPY0UX+Lxsi0/j6HrW9unbrFaqQ1seZfWrH9YPbxiR5qn4lEPU+59VLuE8q2IlbSos1F31AW0D6f9Z+FCLvfJeEB/lqcjtQD/u7eDzudCSFNM6BqHbtUpgWh0cximefUs10kdGD+ynhTwx0zs/ZubOtadFOv8f+Nk4LV6xul4hOX1tf6aLcyTWlgpHxjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21)
 by DM6PR12MB5552.namprd12.prod.outlook.com (2603:10b6:5:1bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 11:07:43 +0000
Received: from MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a]) by MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a%11]) with mapi id 15.20.4995.027; Tue, 22 Feb
 2022 11:07:43 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 3/4] devlink: Add new cpu_affinity generic device param
Date:   Tue, 22 Feb 2022 12:58:11 +0200
Message-Id: <20220222105812.18668-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220222105812.18668-1-shayd@nvidia.com>
References: <20220222105812.18668-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0201CA0002.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::12) To MWHPR12MB1310.namprd12.prod.outlook.com
 (2603:10b6:300:a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1db2b02-12c7-49f4-c72b-08d9f5f38c2a
X-MS-TrafficTypeDiagnostic: DM6PR12MB5552:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55522B90BB36420951094A33CF3B9@DM6PR12MB5552.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYyEIh2Fu5rskCG8YY4Jwrw2hexkqPtCzvoJvd0Bu8WYuZMjyvXmrb/cD1+CemHJt1O+CRk4oE/f5jJv1z4iBshppZ8C8XL2LNU6XbkYvng9JpcXqui6+jB1uJLGUvXyORcO0Vhsf4HwbHUs6eAu9YiZw2kbNvzvvtvdnV643FCXLOmzm8trGHzOIrpHFevrjME5YKKc8ngO+IzxWWk+vhFcTvZ82u66bfGHzXc9x4BQCf/cnmtj+vTob6WqFBnzeglM7eKgcl2ki9j56aHC8XT/+cFpeIDvRSExr0ld8vXcf8b0P7yox8S/lgNO7o0nSjQtz1hvXMT+QQT7+5b6qf1OnlN0aAC1cn4efY/+X1so0QEEZLAGyM5ZOOy0b6MTKJFc8Ud03s8/nfGy1TBlCY9sONTj0rPm3uQEbPkIX3H1Lrw6ZQLPynENTRzcmJKE71TUAlAZBiUm/wG5/MjHMMZVzz4RlGmL3Go3U/jRPFSkoIWHhth4E9XW09mx+siuXFK2oo9JKLq9A+eJSdCcF+SJZOPYIRxdIr2dAcbOJ2ySudyRsEy5H7sQhF2EHleW8m1vuOvymrl5UyfyHw0rmTFc126RHVt6JwSacEUDIUENuL3ColhcpWDQo53cIt+Vdeaxc+1F5esH1dPeYjf9VQjiWOBijRjexm/Pp5Kmj7OzXLFc5H7u0kMVSO7cPvlCB/Cws+kXokxFBOOyj4IL90aqdMmSGHCxSZE21GVv9VI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(36756003)(508600001)(5660300002)(6486002)(86362001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(1076003)(2616005)(107886003)(83380400001)(186003)(6666004)(6512007)(6506007)(52116002)(2906002)(110136005)(26005)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yveZrskN/+0RUoMk5xuCYWXnd+au2inFixjW9muoGYZQ3qKycB+VQ8mnnWGV?=
 =?us-ascii?Q?tw9neWD3l7JcRSbng/efAlxY7g/ud440CX2iiYV0+0ZsyFvq4JWyln+x8cwz?=
 =?us-ascii?Q?FqFBAykph996hmPzg7Kfqje5sAhCayLPg/NJJIXQknr1gH3s+UsFWYAqRI5+?=
 =?us-ascii?Q?/OHpctyZueQn91JnoCTBmi3GNhWDzgPFTkhz5C8+9IQME7s02SimpwfJ4zhp?=
 =?us-ascii?Q?po+t1leglzTRfxuyWJTkns8QKFzcIelW11T5GxGqhhSjHJvxHWgTXOHlNq1V?=
 =?us-ascii?Q?NmC4E4ORvECCewOhNx6WzNqSYBrxiciZG0GgzTN2oLVYbqKN5DcEbBl4J0fa?=
 =?us-ascii?Q?jzE+wCuvfn9YgaiG9170ZQfNQJJFCWNfywZ1BnGklVhPTrMC4HHSyNulTvaY?=
 =?us-ascii?Q?EKsScHP2cOZkao2yoQU4Ey/aJoAflfBEfc3mgxI8IDs/onSAdoTCnSDPx7dM?=
 =?us-ascii?Q?LPo1k2RSAoTF31XBSVhigelhRdmo9CnHGd7rkRFMPZlBUdn5oP50t77NUC8P?=
 =?us-ascii?Q?NokmV1QjdvQRMHtP8I5/rB/eSne5AzwiKZCspe1kum/7KPOURJYlecW31j1q?=
 =?us-ascii?Q?ywBTJWn5pNCY8ulL/v4CKgYUf3IJP+0nE21P9NssPVfbgv8Tz9QrJH0+ekZx?=
 =?us-ascii?Q?lRSjYe/SiL8jcXDFy19zZu4nZLjQgy4YneS2awi2zxKY5odoGmkXHZdcdnJX?=
 =?us-ascii?Q?HJHQN7YMkAybuNhZpoS0Tns+h+BFDCK/I89Vl1qgAcADgPCftrG1MFJebkaO?=
 =?us-ascii?Q?1TVU3sEBLGjQaQDW9cgIFJ3W3pEqGkEee8F78vZ2d4dgIbKxAnf5croLeI7Q?=
 =?us-ascii?Q?T7msxOlzgWsP3LWf733L1cKAJ5RGoQ5tSfMBGrIPHw3W07Jb6rW9ErHNMFvn?=
 =?us-ascii?Q?Vk+d+yQflQZeNAiLxjJALAnDcj6rf34XOUy2UtYxH14WW+1yVpR6UYN5xPl3?=
 =?us-ascii?Q?Wsq8C2K/jZMjbPPw147rPMk4c0LVxfPlexjxdEyeEodFLYsuAW+8/j/BcZNl?=
 =?us-ascii?Q?MGWYqvpX+o4PaF6+gAJ/1EZCV7S7rZ6Ds+EBPRhMenxDB2oHdtIHoSUKC5b/?=
 =?us-ascii?Q?bXkz8OGjfD2Ykgawe/ZZeMiUK7jUwexLvykuUivUUQAudejRK2ktzxaf/xTW?=
 =?us-ascii?Q?s+Zw3LUow2R3W+yfFMcGzRkdBL8Ng8csHsLmmx3whkEXKtVet4I4W5jo+6sI?=
 =?us-ascii?Q?vQwE5t+DPOACZDEOo3W+TEStvRXEtpcV5mDVJcT7XVeHdS6RtNCQhu9csoGV?=
 =?us-ascii?Q?IrFkLZ+5n8d7Pl5Ux1ha7+qcwZ5IPuuS0wQXT+gwL8U0WJwLYyQjlntKv9su?=
 =?us-ascii?Q?Ub6Aw8zNQQ4Gz0WWGlqCvLpeqSciRVTf2O5XWkqCiVKSJGfFkJ6v2U0apvi2?=
 =?us-ascii?Q?G+BWYc8LL7Tvo69liGHH7y3dLmvzBwB2SdcAcJe9xccPlG5+ychMjWq9yYkj?=
 =?us-ascii?Q?JNDEtzgSillmthTfTFTAO5mEcpyEwC/IhjdmYvuZoQFAvdLsZOxVDBATAuBm?=
 =?us-ascii?Q?EtVhWfp3SUR/WryVxFjPfPxiF3oCQrDPdlKtptiuJJ/oSnHxHgDSBf7HoUB3?=
 =?us-ascii?Q?b/cGMdQ6zsWajwHTk9WPn0R2/rNbL4jmCQqkvwxsN1YIP7MfKR0ChDuSEGln?=
 =?us-ascii?Q?Kp3etB32nQAolLTWcNiz2DA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1db2b02-12c7-49f4-c72b-08d9f5f38c2a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:07:42.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQnutLVm59t42NhKh4s0c9So2UUJIoNU37BxKuO9dCaiBmr8fUKX3DQ1IkIYzxSxQ25Y8xBvjiME+uqpQhQFcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5552
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to configure device affinity.

A user who wishes to customize the affinity of the device can do it
using below example.

$ devlink dev param set auxiliary/mlx5_core.sf.4 name cpu_affinity \
              value [cpu_bitmask] cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance will use the customize affinity.

Signed-off-by: Shay Drory <shayd@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 5 +++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4e01dc32bc08..2f9f5baf4373 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -137,3 +137,8 @@ own name.
    * - ``event_eq_size``
      - u32
      - Control the size of asynchronous control events EQ.
+   * - ``cpu_affinity``
+     - Bitfield
+     - control the cpu affinity of the device. user is able to change cpu
+       affinity also via procfs interface (/proc/irq/\*/smp_affinity). This will
+       overwrite the devlink setting.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f411482f716d..595a4d54a2bd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -466,6 +466,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_CPU_AFFINITY,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -524,6 +525,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_CPU_AFFINITY_NAME "cpu_affinity"
+#define DEVLINK_PARAM_GENERIC_CPU_AFFINITY_TYPE DEVLINK_PARAM_TYPE_BITFIELD
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3d7e27abc487..d2dfd9a88eb1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4477,6 +4477,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_CPU_AFFINITY,
+		.name = DEVLINK_PARAM_GENERIC_CPU_AFFINITY_NAME,
+		.type = DEVLINK_PARAM_GENERIC_CPU_AFFINITY_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.21.3

