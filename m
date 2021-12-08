Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A518846D581
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbhLHOVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:31 -0500
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:3361
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235021AbhLHOV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpb6WDc5IjJHtYvD6xFg44QBMCSWec5sKYZEgrXvSjskgIu/lPyKJIYXsiuGosIUxXlsuRzQ8z781FglzaB+IJWddm2FknMTAyeavzfqGAJcqP0xNUd4sqs0d9LmmgHwZa42WHVmlj82Iz4EfVjnmHulygGBDVysGlkawJ50kp6Z8Mrx0T0hz89QJUxLvzPznriZCJopDYPSVGeqWja7tDPB1ET8MbNl6ptGtwDuPBLlGTmXU89IyzMz4aARqJAllslAraBg0N5vZpZ7uoof3ny+kFHGkrj6WFTxyAaQgenU+rY3HW22/khh860EyjAKk4UvMuVHGolghAjKj9rxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iEl/4HDtiYV0Ofdwq8FmKI1rl2DrBhANDwfWtGGXgA=;
 b=QGcuvHzSn2a4kmqZqx66iX2CU8QaMdrXzxmi6cAAJ5p7AnSJ3y4cBiFG5Rf/DjtQgHlz0QrucUGtQnTDiBmhe2W1bd2+gD3tCLDdo+y0fcMelxMrIFgFiDvgGyLG9L1P2pYrWfK5DZHMwMlRF65DuW6nKXL7uePb5kKa3pgN6nNqD/oaSH1GooJJmw68AtI9tsngXWkDVL2XXq4ZUFRF7hJKiwrcrBtmGmvyfCFf9XLv311AAO/FKxCdweBq4Qz8KgQPAlaxs4K7NL1zmAJa0dYguLQ9h2q5aN2tN+ffu02nz5Bx0uNBGXqcmo3tDaxum3FhELt2KcYeegpHI/HDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iEl/4HDtiYV0Ofdwq8FmKI1rl2DrBhANDwfWtGGXgA=;
 b=i6b8ccuQZMBvvRoau3p85lIQFbCjXgeGs0PhZtl4SQ81X9kDi3AfhQywFYHfE180Qr8LS38KT8DeBiBa+frcaQCi2mEenjxz1TViPxsV75z8Hr65GC03C1q93dfSbCfGmmmPk7Si4pxrkszwjfl8ZpVocSJLGM+8x1kfQVoRfAFIPutvJf5wB5ogsWief8pGtDmztr0uMYtIDsIR7d6/V2zr+aDbgajVC6Rxmn+9EyJjkBy+PvAJv1sDPv9UPe8tqPCUbJQe3uu7+zzg86g5n7CZn6XS+87J70HAdQJ0VwBXS1hk+hpHHk5pdsaLNndL4b6U8vl05f/Niqo676pRcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM6PR12MB5568.namprd12.prod.outlook.com (2603:10b6:5:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 14:17:51 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:51 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v3 4/7] devlink: Add new "event_eq_size" generic device param
Date:   Wed,  8 Dec 2021 16:17:19 +0200
Message-Id: <20211208141722.13646-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f81253fa-b5de-4680-07b3-08d9ba5584fa
X-MS-TrafficTypeDiagnostic: DM6PR12MB5568:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB556848C54C9DA12F24FDE91ECF6F9@DM6PR12MB5568.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I4GjPzy14a/G/l0EN4QZnpCeUREiD7lRHE7CL3Evh5ClDVBFKu3NS0EzQpeP/6lchyGbrosBxJGHtmEdUxX43jA3q1nyOapEutA81Ts6ZFgp97e9qPavExrsWiOd0IU+f6qoZKn+wUN3WtqAB3ddAf/8ULSEh6D23gxBPvYQ0vOnGgw0Zk7aJjVKOfRGZ0SF6Stf4xZximgpQ5WqVj8v1kp1TvdPnS/lzMqlF7gAj/94dRIoAFBYn3gKLAK5fXTM3Lw1730tjcLz/kCwtHuIi4as78+mh0vGP3aEtFAlaXED7OUad5AS8umDJ6R9/AivWPzR6w2orc3rapUZ/8P+51Vela6WFWuVjjkM2J00bf3XWgJAgTPFxKQ/eVp1mLUP4tDOk8WmUuNa0Qlxa0X1XyGxvyAOOmwa6R2ZQu/W0iATCyIpsbctPAbLgw6v99fSj1WPlK+G+EBSFXTg139PqAmcmEmjSzcMSEuk3uCye+dVi/RsI3HsT6GP3IscNi//boaHWJZSYjGuR81UQJR0ARD5pE4ZMwyl6jRuZoIVVYCAP2R6uf1XGTX37RKpWVat76A66KJr/d+M5nEn7v67elVIBlfPBOEXl/PHU96hMKQ6sfKZNilf/0D+WBHQBpdBSB3RmaPGa+l78SJTpJ74TQ8HEecBn/sDhoImSuL4+1YEyLzK26j1aV1yG+UebDjLG/4RCu1kfmzGtxWuwxrmtiEEVMgwFzn8y9udqudSAwQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66476007)(66556008)(1076003)(26005)(6512007)(52116002)(6666004)(107886003)(66946007)(6486002)(508600001)(2906002)(5660300002)(4326008)(8936002)(6506007)(36756003)(54906003)(186003)(956004)(38350700002)(8676002)(110136005)(2616005)(83380400001)(38100700002)(316002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+UwAT/DgvvVPd/ZyKNO5kehfmfzzTrFbjrBmqpGGxTrfE9lyPcSiimTsSCfp?=
 =?us-ascii?Q?1xKAAj4LZ58C5jW/aOPg3cKAAlB6ZsWwO9Tp7xdvX+IUFrwS+RKNof6gK6EQ?=
 =?us-ascii?Q?6vrXrPaI15SnaiKV9U4dCal9rQN/+zEuJMArZxHAawLkbDBLsE7S5ONoo26I?=
 =?us-ascii?Q?eOqGoNLNgy+eU6W+00AWhRe6R7ZBOSlEQABOVMlkuHf6t0L4LT+6M8ltsjHA?=
 =?us-ascii?Q?9LPOiUglr2SUlgtDGiaU2jyHngeOZC1BDgZProdH7prVKbEBl2Q7xPMjdMhL?=
 =?us-ascii?Q?beFYB/kAZzQznQ3kQ2KMqDwKFpDmbD1zlKyc5I2Av3nZgYEYYrCnhpx4NcvG?=
 =?us-ascii?Q?Pb6Ixsocp9iouenx8tasZVZ24Hake/JeEZ6rpn5n/XhYw2uSc2dnk323G5Oj?=
 =?us-ascii?Q?RCB33G7il+0PPhNwxXuuSQ921T1nXUVhdkqJxSP9+FCd9NgRZdHf14sj2MFj?=
 =?us-ascii?Q?rROrZ7OZQ/zMFA2FKwsNyrcQEsPt1cEa16BdMLBWuDNGIZm3amr7sVpDRtY+?=
 =?us-ascii?Q?ep6eYIRNebhWjIOt6rWFp/wi+jWK2dekDwSNr25i7VN+LDmiNzEd+P0GSYmR?=
 =?us-ascii?Q?GytnRnb8COPQKIxEy8sywwSY8jss4xluODLx3Gj35J2DfWd8tttr1XX6BZbT?=
 =?us-ascii?Q?He3DDgCZRvAhTJwKJnljFEM4K9v3DSUgbvO3ZEzIXK6fz58syD+rFGKKm2k+?=
 =?us-ascii?Q?4mHg5shHbS/lZ1y1EiwumFTo+Hj4kamHWtiPJOzk6dCFT6fEy1RITwls6KlE?=
 =?us-ascii?Q?eQ9NV5MTXLoe1Sh3PlzTQaOUCVn6MmSJ7TvoDcf1yII08kt+TL0216Y5ruHF?=
 =?us-ascii?Q?ch6yW2zXIBSRSmjKvSlXBZbHVqvYupcVA19XMX5JJWSe+IR4EZd2mh9tHxhq?=
 =?us-ascii?Q?xEf4H0YiXZ1XRBr0jgtorjQouy/gfR1WkXlXHvrxBuLuafF7YDZluIHrVwAt?=
 =?us-ascii?Q?zKxZWMPLKFWGjNSjq0Uwst8RVn2/uidxlTObNCirM6bCFUz9sswvvb+vO7BQ?=
 =?us-ascii?Q?Hfb5TZ/I7co0L5hTSNByyjcA9cwIxDc7iLXzNXVhfkQ12eLVRMcN75QtQ3JL?=
 =?us-ascii?Q?wcWzVkrF4/747lHxzIGMAq1TmazL9OvDO0r78bC9zGlElXTYLFGXInG4j0/o?=
 =?us-ascii?Q?vmfUOJJKalNKGZM4eGFFs/sDgBSMykJTWVjkHWbEb0t8b4A8ozeosoBw4GFq?=
 =?us-ascii?Q?Nx6y3Y65JjDf40CGXFXWwliONK2I8jS8AwBaVdbwvuaiyUMyLytxmNcQ85Zd?=
 =?us-ascii?Q?uRkIGjx0PZKToodPKhl1jZKM5KLY+X9hPaQxpY5IB8QIOYV1rOA6q7MG1PuK?=
 =?us-ascii?Q?nAX02b+pBnTVM9eqRyHnCRC4SR7sToSQkT2vb+X+9fe/FVEIlPaFp8dpdMt9?=
 =?us-ascii?Q?3mW6qv3PlPFMz8SMuPFkLw0n31YoV4HTdkmC3ZfVn/nMCKx7cLwvxyN76zpF?=
 =?us-ascii?Q?H+Crn3vJxLzrQ26o5T4EPHwky8dhwhMaRqdufT44KHVUCDkLf4JovQ2+NWyF?=
 =?us-ascii?Q?bzbDY/DpkIR6WoWk2BNEaFG/B1Y+8bop5/rPVRGovZizLGOxtBLbxLbDPWwO?=
 =?us-ascii?Q?eZiaeKB+OCJ6wazRQ3EJXnMSvOx4pohFL63MezFf+gepvtCATtvwOqR/acux?=
 =?us-ascii?Q?NMAfj5qT/EjNRM7Pcn/fnPg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81253fa-b5de-4680-07b3-08d9ba5584fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:51.6656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JguPyqeVH0W4h8p0CtKeKL+zjVgimdc5kI4HxaDspndnmtYPRW/3Lg/ITjnY3abnlfBHsWy0c4uxGmnUzgpadA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5568
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
index cd9342305a13..0eddee6e66f3 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -132,3 +132,6 @@ own name.
    * - ``io_eq_size``
      - u16
      - Control the size of I/O completion EQs.
+   * - ``event_eq_size``
+     - u16
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

