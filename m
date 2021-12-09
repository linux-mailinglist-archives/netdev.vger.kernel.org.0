Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB59E46E659
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhLIKNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:42 -0500
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:2973
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233411AbhLIKNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PesFbvErJE62Z55kQ/MnGlir2fZG9+bYoiZ3HVj0/ASM/BKuE9zzmAwIciJMyXxTlJMeyGV8Twe4Are9sxx4m2fd7qQDbHMfX6AMo2e4iWVhNCwvH4s3wGGv1YMXqY5NR0SXLyQzvK7g6gCrooBRbcpUNd3ZVGnFwDHzegb4ulXmaeuZ+syZrYBXn++CQ3mmWadgOn/s1jt3dy8bCkZ7dwttC28AlHDlmrnXMt8sNmMJTQz6yaPe3VUuF9inUVxYshKh8YcvmNGs/5JangL/3V8gP4KUyo+aPPISuO0sLeLzPwPe5I1oG8HahmlwsiSIUb/GDKh4nfCWpq8El5Db6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0V32gMh5k4hgcyDR1IeLLzIaLRympZJveubgaOjqY0=;
 b=avUq+VIP/Xdu9gVO4iV+Tezt4sAduUVywi6ARfl7X4pqH4VCqg6Q/OuWc0Z5skMrL6KsWgWcyERaheSCylV7JsLlbszTP3fGK8SBSpQlkLI5164bE8RTHpfNIgQdXhGTB6inCm8fV7OGykYE9W/1dKguUtqOYSRc2Y4zxyrizGUwUYK6S7xCgl3UCYnp2Ow4QG2czQZjJyuIS7YxaqcwekK+UzvbpInVnZD/RTWuT/mlWn2zLxHocAWNuyndsD6Jemv99GvsByLlhLyNOiC3Vcy4FiClthUuWFsl2LtoH10l3DzF1uEZSh8id5L20yS6UuhlXBgZ4wq8ZOYP9VvNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0V32gMh5k4hgcyDR1IeLLzIaLRympZJveubgaOjqY0=;
 b=oQJfAglq39swDlhSBoB8F+pkpoHSH/FGboSajCVUG2+YWa8RjQr+s8C3owTOgT9R0rz7liIHcPapJiVgfesJNk5J3OJ93jom39Kc//1ts3DBKfCs4JTzBoyMfS9bURuXudLz2UQlHP6NCgtFfsSplXD7KZ9/a4NGNvczD60z6y3N55teu3DvNFnehhfWkN9BcIVVExHuwq5gZwtxN6BXxUhQ5jKfZa+rEREdua9jXKa9YelIlAQswteYaEGbGe0vDCObE2QOqli30Xj+W3mV0iSDQA41/+KgA3CNvaGvfvHXymhgdikIiGYinRwd8YYtgrYbXM9TjWtYcKGw6w4M2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:10:02 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:10:02 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v4 4/7] devlink: Add new "event_eq_size" generic device param
Date:   Thu,  9 Dec 2021 12:09:26 +0200
Message-Id: <20211209100929.28115-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:10:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dac5f934-e2b4-477e-a7c1-08d9bafc1069
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB531134C18C685FF10A60F818CF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I4UgetTK7K1V6xj9f6sB0EYzxQhJHSocHNQrs+XnTGE2SCDwPYlaE7vQzJAktHyhxvZVUBeYEAgQpNEU20bzH0nJ8rtdwyQ3K1ZkakokH/ofxrUGpB9Hrt3NcAd+RhFtCA5F8qwMBWbsaev6UIN0BjqlrzfBHMuHTcbFmjSIusP7IB0wgwsRMWzBi+pO4xIWSlV+21p7HKOM5M91TWrea2pwT24U2r5OaHzBpsRdXNE6CmwZh7BkYK10xgp4sYdSt3g/LS0MFoJHcx0tq6ETqOv+VFXnt6GDPZTgDCoxYQothOg6ANEBual9E1yESDOp1gduapU+uqCyx9jXmPF4dww21s+iH8lBYPch0jGcPi5BaolhNmuafUxQ3DdcL+ocuo2WNj2mbJYu65XYKAiZT7RBQnKaykJVikYG7+Dutlkg7qBzGQA6d/429v/6tlaA/tip7Y41+1J9udYTgAzdTvBCdYQ+TPJqd2AjMVM+8BaPxmglSgwBSu8Oj/oKVcrORZdRgPIFj3fyLac/t7nAxRA8uo288SLoFg0xmn7sT5NC6HEJGRUWnhoHXBoEosP90n/2+ldBEZ6wvpGRrQMDfoMdLGTKoec3c7m6vTCK7FL5sC9S3tTEZP6P0huqdJ+s6RJvtthMionWG8stMCPDkRbfVvLt/jMcxNaBImsLmJ1MzASsKlcLVayCMUQl9pTd7LER4ysQcLcF2fjSnDcQlWDqlrmMiAbHWz8omFa7w3s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(54906003)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+8MUh6JkXDc0DmR9Say8O+NBqmxVSaqm8tW77Q6ufKCDvbxgW13CxGoCq0W3?=
 =?us-ascii?Q?whMbe2Z8FUjuLqchTtpPcNNmUx4VeTm8+e/5jfuf9eKG/M9HQql3x8m5FTXz?=
 =?us-ascii?Q?+dI9nl4m/laMK9Fsu3urq9UF6C5L7FxfxqAVnvCXdl+GQDt8Ap1/D6g8BY8r?=
 =?us-ascii?Q?yDI8gU6tfGZ54ibgbVQnphcyQguzTMGcaiR50Mlnaz5PDii8ERgoMkE1A5tT?=
 =?us-ascii?Q?J1rcFVx3pjXHb8wqaLymIes09OmKB9T0qVuzPO8MMuoP05/rFmJe+qyYGsEO?=
 =?us-ascii?Q?2YlPyCVKLfKODmwVnvaMzI3XcowzdgPXVr3i/6XAJrXWfNosDRfk62eyMOKw?=
 =?us-ascii?Q?VP2ot0PsnWrrrzUBXFJM6Nn5lUC6MoI/7l4jE3i4+SfoHCK14ABPF8t5rj+5?=
 =?us-ascii?Q?n7TnLzG1v8ywKhnM3kuU+Aldcafx/2rRc2t4hY4L8iY6OcEtf+XAcjlqcwQ9?=
 =?us-ascii?Q?l0/99pBCgY4GK3Ip4oUIiv8GjOdg3rlCLe0c3Y8L+eyoGARY75xiyIv0HK0E?=
 =?us-ascii?Q?Xi08Xgw2oj8iEvGL98Px3S5Io+j+mYSMrZoILA2QF+ovCaaLyi/da6ou0EED?=
 =?us-ascii?Q?bvZr1X/KrTdr0c/jksogpzZFzp2lNEJT32bVVe/kuI7JjaNTdAn4Rj20c6+H?=
 =?us-ascii?Q?ZPPoaKcX1c/qeICYjjHs6Lpba/l9PHY1K/JQpwaCfldwcWbLR3RZuolBxlZo?=
 =?us-ascii?Q?smpWhUHotr5NeVlPyZLJf9eYYuSB/By/KirqpPLRntsWF1LgH745Ef+MLNV4?=
 =?us-ascii?Q?K4/2Cy8tfUtvogTeXn/Fsgs+JPNHo1JD7WLEmCAxNvHAVLd783mottAF0Fqb?=
 =?us-ascii?Q?tG/c1Ayx4ZwLoZBLcKURaE3Jaz7Fb22YeR+9ZzB5ro2quVZb8mi7N+KGUyt9?=
 =?us-ascii?Q?cyP56yi8jlVlFdOzIpMzRTpo7GJf5euzagutPALAe3koXmdmPulFVC7S0xuM?=
 =?us-ascii?Q?r6HjBiyVACR05X9jpZ3/ZDrrJbFgOVLYnKdbb4ZyJjZBUwLRpQppw2O4AHPC?=
 =?us-ascii?Q?9qR6LRN7dj3t7gCaolwMArnAgpTDTOdSoksEAoAm74rdN1NcX6crzrWZkLsh?=
 =?us-ascii?Q?g548szYkx9TuZBpG8uYaSE9XbaxUBkBuoXdrmnkPW2C1eIE2RR00J2RGeexu?=
 =?us-ascii?Q?fMJeQJ7wA1J2KjHfLA+yUX7gPYg3lyYiOSGbZKy5W4aNQ3pByKxqOflb9R4F?=
 =?us-ascii?Q?UNMxX8mN5txWTfRzSomYl8AFGbHy646LHbuCX6BHH1Ui4DIua3y55bKTU+WO?=
 =?us-ascii?Q?yJgAn9jGg9zcU8UA6oktyXCriCXs9l2qlJ2C2qLh7AFPvBX2ZbpksbQs/KKd?=
 =?us-ascii?Q?kX5A5/JGw2gph0u9v2mvosZ1WE47tpl7grm3uNt4B2q9ChDdXu1gHNtNg67q?=
 =?us-ascii?Q?6QqTjs1Yy6P0nF4bDytNUkp/fPcrdA8cBEdnzhZeg0+4yuRT9c/zfZ/YslEN?=
 =?us-ascii?Q?7PU1Rx/nunyGTk5TMtb5B58ppGmzNLzDruaTcaqF2lnLUnXcvsZRtbcVizR3?=
 =?us-ascii?Q?ggLWLbbHLab3a9SAU7TNNdfMOPCZS5xYw3G7kNpli3dOoNlRZSiVf5Sf+piT?=
 =?us-ascii?Q?VWbhs18RRanJ6rEnvrVBOl2p1z/XS6xVbWzLll+qvjfuLNnr1Lzw5xfCI6P5?=
 =?us-ascii?Q?+0YOiCyP0j1z5lXWIFPXCGc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac5f934-e2b4-477e-a7c1-08d9bafc1069
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:10:02.1422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6U1mA8OCyusc5eHWlEurJe4j5LxEStSdXwE2WkhD8w2oSs7pqtHxwia8OMIM0ee7qqh9PkeXI7pb2LCgcYjFMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to determine the size of the
asynchronous control events EQ.

For example, to reduce event EQ size to 64, execute:
$ devlink dev param set pci/0000:06:00.0 \
              name event_eq_size value 64 cmode driverinit
$ devlink dev reload pci/0000:06:00.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 547c0b430c9e..da0b5e7f8eec 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -132,3 +132,6 @@ own name.
    * - ``io_eq_size``
      - u32
      - Control the size of I/O completion EQs.
+   * - ``event_eq_size``
+     - u32
+     - Control the size of asynchronous control events EQ.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index b5f4acd0e0cd..8d5349d2fb68 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -460,6 +460,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -515,6 +516,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
 #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0d4e63d11585..d9f3c994e704 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4471,6 +4471,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.21.3

