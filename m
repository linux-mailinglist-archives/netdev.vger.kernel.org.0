Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF8846E655
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhLIKNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:35 -0500
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:64193
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233309AbhLIKNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw+jn5A05Q+MbjtPmHPVEk4lzuLHBZLCLGAiazPIvoPiHFR6etmL8+XoiAalgvgX21MO0mlOiTWcSKPAmTtzNrdMtEoZ2DKOHfsUqAKqVWVLEZfGAIid4TrpUozP+vGIWrc4A/i/+L72cMmYle/1uJpI+KlMZdh8ONOXCzVRxDAna7j+U2KhJwLXAOc1RzR8Zd9/BgGSSkvTLwG6Axzh9Jg88tdvW3koEgV3OQtHCNCsJp9qIAo/QbnCDRC3rDNhsMA9MbamIvjCdJjwrgciSQ1QQmJoTwMNf6ckbAvDHFUs+UvgGM4XnVgKj7jWlR/Lf5O0kibFnS+CYTRcEo2RhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfLRM5MdjIvJYbsA2o1YUXIGui7mM+kVozGeuUV29+w=;
 b=GH+3wj/hy59sdokCtDbB2rFyOflklR+4qII3qpTlWNsV6Z4BNC8gH/NDvdoZD6PGaThoenpU0I/nF2b1Z78BTiP6Y7vUjcO2SlKj8BCuuPZzdHhCiW8A6DeRlRYKtwleXCzYXrFvh4HD4Q3JDVh5fDbJ0wz+1o5/miX7KnqA9wk3OEblKk/vNP1SJI6sZVBayEVR79pfkKV+Ladj4rJ3bs+17N8YgqMqB1Mf+iTBgmQDBGLS8D1rJmwJx8hUsoA0mysL8B/YpvVlcrO8/AOlKdHuprUBhsC1WMQ+nIPgLP59uM8Wt+jxQ+zkBOEQwniCQShDofsNPbuwvRgAu2+VGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfLRM5MdjIvJYbsA2o1YUXIGui7mM+kVozGeuUV29+w=;
 b=MvDFRlUUT6tye/MYgU7IH65j3QtWHubwU5p2jQ4B1HnQlKWo9XJ8GHDBCMP1xb2/Az4orpyonnIfuFYdokrdb7MD+nQKNMFYiuWYBDWjhss3ODlWP/dPM8c6J3LaIAJX4BMuyV0S8IfwzHpm3cJv0oHeUrXBntM2Fh/ntR4PnLQ17bn6tmb+03OD2gbMtBdQ9q3i3xXlFWHElaLGCiReS2MdnP9IjzakYzmLFl8nzAmZQyo2Vi8GZm4DM4wVXvPz89YsZhu6/HxDmON/jEZguWjfSdQqMOccfZU/YfM4XAE6S8VSegdcF7tvCajX1cbpX4cc05o3OO8lehcxHqWDXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:09:57 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:09:57 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v4 2/7] devlink: Add new "io_eq_size" generic device param
Date:   Thu,  9 Dec 2021 12:09:24 +0200
Message-Id: <20211209100929.28115-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:09:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 412cdcca-8be2-41ad-204b-08d9bafc0dbb
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53117CE5D05E7E10DC56BDCACF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jh5oRg2i8KZ7eQpZm2GhIW3kfZ3oRD71H4SW16BZ13y5LTg4SiyjyQPH58tPAb6+otDmZ2DuPXDtbncIjhjbCTgylsiyMX6+/dgQLSjF+xiCrNPEnzmxJmhLac3UqdgL2QGrmT1sDB3grKWgkSlV2v2VqRp0ZJAk02+6vkJfSjHl6sogrRh981+DhjOW8i4YCZ09z/OzcCrvfx+/6izv4zYME4B/arcm6k4HMgvyarmF7lBDVH8+vyn4NIo/wSv/Mp5rAtOzDkpH1okvuUoC6QPEcyhnxrPWiQu3dSGwryKCIucMs23QAtpjWHooa5qWn6PBplPgphmaK/prxnHlcY63i7ETIThOKh/v9Uw3M0hIFaFZK0bDV0kbnbTd76bVcqp+fXlhNJJOCAHhq5I2bWNpV1MmhuDa0RHajjLx9bL1kl2nmCIFGz9pWYD4cTYBuHRPxTbb5OSkFBa0woBfkn1p8NBJh1SfUzyGR8YhDtNvncXGxEN+q5q0cZObGquq7G2es7rWhsBxx5ulO4knjiY/FfRbWAHXUi5IhTebs9Jf7zKCbeEnB65baDpPqRRUP3fFN1wljHg6/1FtvXbgklcl+YsCKs0ma9LP+4PY5+fIRu1U20WcOnq1b6RgLqYM6ADdqrFAJe2eiaFF7McDmeYlD0TumS/HhFq8YUB13neFzaFwaB45DSacOFGtGJNw9UeUnYtZEPEjw4buQASJfKhGU132oxf0OZCfgC9ucy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(54906003)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rC4qUpuZFyhXFn9Pw3B1B+aCiivcbatFzmY8G3olJDEmJkywDwLthsYJCxX8?=
 =?us-ascii?Q?sCrdglwCbTmOEVU3SJeLAcHmat2BBYICMSf5AHMIYVBe6yX0jAi0j1Bz4TA4?=
 =?us-ascii?Q?NBJiD0ci7ukGGdXHFCFkC83tJCNyKesLGlx9nhTFZPSLauRd7ZsE3vlRE+Br?=
 =?us-ascii?Q?Z6VaUYqi0YOwl1e67RrskcAof6J7eqixhsgUfCrdnY6M3naZzUS6FPtVUgYr?=
 =?us-ascii?Q?RiLrKHKPhAqAzkSfYrY9Jl3R+NTvIbQ0iEkr3cExo39pzmN8RNTnlTlwbRbn?=
 =?us-ascii?Q?f4onnv++8TrHKoVyt86x8j0cNFqJTqwNT4w0PMZZpQ5TSvfVFrFLfK8BM3D/?=
 =?us-ascii?Q?NIscmnfDRMCYXoZKkS4sa2zgtKbToREi89Hz+eF1F5daHNlN4uxBx5wt6eLc?=
 =?us-ascii?Q?xCDy8sRBF5WwRFt59BJEd8oO2G1GOBwMWtU0yLu3nwD4Vski8zmYR1Lb2EWF?=
 =?us-ascii?Q?AcOEk3papjT2crbA/MzVh2xjdaYIZDQczLJbrp/Kz9emDkRykmpFPx3EU9sG?=
 =?us-ascii?Q?PE3mBs3uOeQzVXX+G/EvzznWBZNdoU3gRKlqT1fof3u3V21DHzhPci41Ayuw?=
 =?us-ascii?Q?Q+3aX3rkgEV8FpzJQh5beamXQoDeDYNRmyjnbsr5Grv+j9S4L1XeE3CRq8WX?=
 =?us-ascii?Q?+3Y3ings3fzhZVBHVmQv28qaTDzK+NCrv3IDjSA8gK8OSlf9vI6F0ewAI59W?=
 =?us-ascii?Q?KwtcsxJlZTGQHRMC5zTHUuD08jzhX95sBDn3JL9/sV2kqW21t40pLnMkLC+i?=
 =?us-ascii?Q?wOXNQXX4ZuKKsnmncFCs3kYxBGC1lQEiKLiDlakQZDD7MHeqLtDdvA/OoV1J?=
 =?us-ascii?Q?owkB1Lk32T5Q2AEC/jS/KI3QzYGLQ9zd/Kw7LSnkgHpz3yNDS/8RE7EqdMTE?=
 =?us-ascii?Q?ENM5EDP/BmlUwKyGOgOGBP1bEpgie2rEVLcJI/mZ3iEqHFUQfkNQAMqRFQZv?=
 =?us-ascii?Q?tafcELqkgOsh8woYIR/LkYeEsWDjf+Xfm9CKzJ9iNQyeT1JTW3BcXB1uO+QN?=
 =?us-ascii?Q?rICKMHseQAwPimIoWyxNxALvEtfCqIJKg3BWcmpgVpRfQulvFH6tiaZEWEJr?=
 =?us-ascii?Q?H9teVpiAQadtl+MHvzFmQkAUHTY2qtA3BuCg9hFWrQXqfDrNj69mlY+to1nJ?=
 =?us-ascii?Q?NEyHkxIq9mc2Omcw2bp3KaLOZ8sSfny5MIenncv1es0r8wpriVROSzzlcedG?=
 =?us-ascii?Q?Fjuk9Hx8r1WKtlGtz5ROPFHmVIXiImudoWXSdtjplm/DxC7CTjTUFeHGPFDP?=
 =?us-ascii?Q?o0cjKWG5MH7FpePZbSsQHfp6LTT2WnWWm7IfwcFYnkaJGFb7qDhmF/ThwPGa?=
 =?us-ascii?Q?8buVOX0ZnkGkPS9anDZ9OX1xmtPShMp/jjOqh0ZHePbywKofJLwAeeZ/1Bqu?=
 =?us-ascii?Q?9AJ9Ss4BS7x1+sSMtSULmNj9lvFMpi2GtXGQiWf9CCqb3RfPv4/VcZyiF5fg?=
 =?us-ascii?Q?a3nDozkOO6zP6p9LLnIkEpwoG0CndtQer+kBfTZ7cqDdKO4JRWvZiDMRdQQG?=
 =?us-ascii?Q?1ZZZ1uPSai/SS8m6jnP1X10Bb0ztnft4MlegGYVr06tb808lkAFIIZEg+waS?=
 =?us-ascii?Q?Hkv2UvMnbMe0srcgttBlA0aQlLcI4J3ORYGvgg3iU4LhHrpWMOFn76o/WbGH?=
 =?us-ascii?Q?kTVXKJL52LyPJwDPu0xWNRc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412cdcca-8be2-41ad-204b-08d9bafc0dbb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:09:57.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VytJVOTjHE0elYocKfthCURk0Bti+UJCNocnBsUKdgYzd9rluc+if0KUz85YsJAZjkvkg4EBFxAWBKWugsMwuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
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
index b7dfe693a332..547c0b430c9e 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -129,3 +129,6 @@ own name.
        will NACK any attempt of other host to reset the device. This parameter
        is useful for setups where a device is shared by different hosts, such
        as multi-host setup.
+   * - ``io_eq_size``
+     - u32
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

