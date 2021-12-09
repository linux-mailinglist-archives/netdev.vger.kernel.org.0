Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD746E65C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhLIKNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:49 -0500
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:2973
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233438AbhLIKNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZi3n+GdRBMOne3MgIYA7MqMklqEjHzDw++0g2EVxSaq2y1ODwz8/QveMIawkXmXwLqxMKY52eT2Y+njX3N4xmye2LWhuX5rju7nkZQDA8fV2fHQNYtR7YQY3nV7Fok7XVZEFgMM97Tb+qNa13qTtQEZxijy+kALs0Bpn7LzuFt/mRd195RKjAb30+0O/G//OelcvL0gXkSAPZ1d6eAzGJ/R0YfB+9LqeQQ3IwpZY2+EwnyZn1vv5K0b+L7IapvrICNjUvnB/hNDVG2WwvURqvHvZf1s3zzsPLc7iXCiUwmM510dYe86thZWzcMZjz0RCHobr7NuDGzfiD6X6gt/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3rQPdzukWcOqII/j6oOO9RMUwFQTX7Nj4xP/3itdzM=;
 b=CTB7/OweM45DsgtX8GHYIE3SwcJMKZFhvZnvznbF81Ag4uzo1d46/iw14syK6lajNebqeQtIAoLdjFWGPODbTwbQBu687XZnhPPCBGu9lhcd0Or402/3HB1le0iAwKb3qdoqTiC7El5pXDjn/sr83CU7+TbzMSfiQWx0IuizjWteEPmEPmexjaj84eH8DQUsqZolx5SWEL78WfcizK7Ad6jzyVWnMnkOLT2DXSGcbtX3TORHWCC8mprlY1MM4wyeE98zCSrPgOobj7ywgZYHEiQt88j1K+9glTYsvXhmRZHTXZiXYXdesIyBa7GLVVlEcx8JPZSkLKlqqIrMau957g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3rQPdzukWcOqII/j6oOO9RMUwFQTX7Nj4xP/3itdzM=;
 b=UrE3hl8Dcg9jsSX7kdDgrsyEVgmbBkUlVpRDNlRZ8KC5RntsydhnjBLLIFelc91+1l9i7yXLeDr7P8DEjVaY3k4gO0IruQOO2WJgzgmCYZDxaYSDZlQjw7W3Gfe8z4EcpkH3TRNW098yIb8R7tmlPpoCYTtX4NFJ9oFOM1IHSwfUKhUxsVvnyYMMIN5QK2APe7QC0vYV467psxl3bZS4OmBspUXLyuh9aps57rECuz3VIPojYLAYD2TX+tN22Z0/3aNmMhRTCp5pLbneHe5pcrRuDKi1/+BMATp/sl9BtQUr4C5pGeek5DMNALBmoZ+5Z/OpDvcwSmnAI/xxTLXVaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:10:06 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:10:06 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v4 6/7] devlink: Clarifies max_macs generic devlink param
Date:   Thu,  9 Dec 2021 12:09:28 +0200
Message-Id: <20211209100929.28115-7-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:10:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70fb3309-057a-44b0-fa90-08d9bafc1303
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB531145B83B421DF64D670880CF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NdxSnJAgcXyK08W66IW9ugMVllvNJ9zmXqeeCAEkXn6vP62Ok12rS6/NjoUt4eGkKvewjbP7kv4XKLLKY9HqcfTBnkzO89GP1sT8Ddg4+m3xA1Z1fdetaXmy9UD0Pdf1vGHkrsj7myiFWj5ISrGEIQSUVqt/dFE+VGgMT1M71MKUZMlpEWzQhKcCm3Zpgv4GbTWPD+36/nPVgmHdOeYXKT6gPwz+TepJt64EP+PbkUEQYI0OSTypI7EQreARyw5F+oR+m9y9VgXLQ6bVdrkD+g27Ip3t/PSyuU0A3+c3HpMTUdQC/Wep645yRsNYqzi5gxXNLgMfd2Wzb2YS9YwHzUx532zb2TaM7UP1I4c9vVBiaDtwgV1z+iptEHUFhGbv/nIzCHzGW4yIDlcZ5XLbVhhRw0Qke6AF0VZPAda9U7b6nbBPxtbLyr91BzRhZidToCxs0P4O4X2TIaT8Zz9hHPiokluM8UiUr/VxwAkMJbOuImWZ5m1KIxeujjKC+7pRQ/VmstIQMZYDpG8XLVKnxk8ldF/2cAtToicpDpptUh2OTDBHfcpELzh3bB+oRAAXiiUxEk7V/7CvlCLNPXjAPNWcv1PtTqVrBUlNNfHQUCqEvbo9wrdsOgRMR9srAigyqTgtkkkRUpkMMfmbctfKxDztY+QAe1HamG4ZAlQBiKZLlxtoi9SuvW3p2wmOKoHDms/zcop0WeMRo4/TqdgnzlNyW5/Z4OZLxNtUkJxpbRk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZJSjgzWlrb5NOqufyN573/5uq64oRmiY5wX4jnmlxHoKfLgazRiFJXWtvbG?=
 =?us-ascii?Q?4wD3Dv5LY5R1J3owUc2Qjjp2XPcboayZXb3pr/AMVo/I2LAn1uNipIXr7nyL?=
 =?us-ascii?Q?xa7JWP8fe41XxuO6z0/ZM5pb09zTFQtVSzS9+lu2EO9nx9XP/nRT7Ysbd1HC?=
 =?us-ascii?Q?qZRPDUZLjbJDSip0ZcYST3emFYtjn628fYk0QbZtVedfqLL7+N9jJuMCyCNe?=
 =?us-ascii?Q?Wg+ctvCRG1vKIGDe//LXg26hOEYjsikpSRi6eFTuXT4mqWl/Nx7ns3rRClJB?=
 =?us-ascii?Q?2ANWpLfmeGMsmiErl5YnpJJSoBDuegMbuM9qmnDbLr3RfVDSOe5I6y0om8+r?=
 =?us-ascii?Q?aGFp2sg+cmi4Li/YGx6Zc6Fe8Sc5IHivt3+aCLXLAc9v04WDO2IfmS6ogfMr?=
 =?us-ascii?Q?+qPLOmcZmIBJC3tqtlrYYJXZdejQ2AglhlgoCiJupLnRhfSGiiCwqeqaFDfQ?=
 =?us-ascii?Q?8DcIZfLNj33/W+ZkYwrIJnmpRKvxNjvZqwb7PqGRE9S0A+kTnMDGe8XOooCD?=
 =?us-ascii?Q?KlMeKiAB3XEbJZBh7JDtaC0FRuZ0LIXTHjwd/2FCZG1SZ5Raf28MGRbxuECU?=
 =?us-ascii?Q?gbtBlXGqC8FFie5yx9mSnFKaenAaqtW2JKAqS+eYO5kzOIXx5tk/ABdCsUVk?=
 =?us-ascii?Q?fMWaNEMSvVZwPDIIroKszThjBniGIfbqeyodHgr3fp+FkMuk/LCnaWoH4qIB?=
 =?us-ascii?Q?p6LcmHT98FXWxW5Rln9gIPPvg1hqfhmXJZXUwYqqPO0dvKoybehRsNdwYFju?=
 =?us-ascii?Q?XSBvYGWNAaWu8c+o4eUgxi5Y2A9DJWYEigCHPmRdVGzJKK+wr01qK88sXI4o?=
 =?us-ascii?Q?34DsW5GuvMnBwSnTv0EF8mZ914xQNRY5p4kQ7Hl62Yy0rChjJtKC0ePAywJd?=
 =?us-ascii?Q?fMNpbEPv9xxmiwQ3NZCT7kwY7C7eaA2ZfbH1udLoIpgUmLNhbdq2tEihrzGy?=
 =?us-ascii?Q?C8jw6W9EKIx4aermFgBnrkkBGC0Sbg5hvwUHGuCn04mWTbQAq8QjyMFkGH2b?=
 =?us-ascii?Q?TbikG8OLR8jwQsnFI5dFTS6itK6aZ4Q/A7VdskHEpWnu+d2p2XhiGQvnobgc?=
 =?us-ascii?Q?BtPDtL6KywE3Tm+cSwWPlMMLA5h1EErR6F3OpvyydzJnDupIzJ/batN5wxaN?=
 =?us-ascii?Q?HREy5W6Z5oaFyB5hOfb6TJ3yMebxLJgs3IuElYBD0k4WeFqvkwiUykDVNqBc?=
 =?us-ascii?Q?sdfYcnR7M977NtMq9c5ny8QuTt4vqQ0WLtpRTbJG2kjfcCdQjws3R9FYjz13?=
 =?us-ascii?Q?TGf706cb/5mrj0XV7H4P76T6Y2cM24fyKWAhFxr0im3jRFi6o6hGUCWbetfx?=
 =?us-ascii?Q?7kvGj5fxMEgiLvc7nONY7h+EXlFpii35JbuWi3KWgfOFjXbn4DHpxPc4Cadp?=
 =?us-ascii?Q?3/xiZPnNXBYgzaoI6IQfM9ihXBSSbzB4d/BHGlu82+8DqNcdtTIfKH5eRBi6?=
 =?us-ascii?Q?gGt6O2i9OmBLZNPJWByLBWH/Xuha4jpGRtmUON+5gLpCFwKaJa6NKrR5PxWn?=
 =?us-ascii?Q?8tNaliOPSfWt0nxRBnUb7YagUHwyqRWxkQo4NuvQdghV/tmTx/Z/5vI5VWe7?=
 =?us-ascii?Q?GJuz3ATLelc8UmiTjKEIq4qQ8QSlQIsW0DUFqoQG3J1dYDlej417RMjLHTO2?=
 =?us-ascii?Q?jHJHBMw3eyigEyn2bwMWa9E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fb3309-057a-44b0-fa90-08d9bafc1303
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:10:06.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12/5k4ETGOp/M0JhaFlvMcHreLlJoEbbNQexax43Dg+K063ddDERzkrH6pcJT6NDWcbTQl1poBsMbtZGuczFxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The generic param max_macs documentation isn't clear.
Replace it with a more descriptive documentation

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index da0b5e7f8eec..4e01dc32bc08 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -118,8 +118,10 @@ own name.
        errors.
    * - ``max_macs``
      - u32
-     - Specifies the maximum number of MAC addresses per ethernet port of
-       this device.
+     - Typically macvlan, vlan net devices mac are also programmed in their
+       parent netdevice's Function rx filter. This parameter limit the
+       maximum number of unicast mac address filters to receive traffic from
+       per ethernet port of this device.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
-- 
2.21.3

