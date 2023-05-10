Return-Path: <netdev+bounces-1574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF736FE5D8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7733B1C20CC8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF4021CE7;
	Wed, 10 May 2023 20:56:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690E621CDD
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:56:00 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8338A59
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:55:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHlhMQ3eS92f75AklYZmuzNsSINh2fd3IJNQwaElUO6DK9XPoH7lawlEp9b4/PSgxfLFNJfTt6NyC2W1xUies4eR0BbzVUFbowi7vMl9fYpCmPM0+sivYeWCZJKfRp05m3ZnusKPdR9dk6tkjkJZ0id4WBJPeGCO/mlRCmKuM/cZBOHOPnS3Dc4yjxfH6T+K9aStVESfBgC3+5MedpL+/5hHxQjzQNFvHosPezc/neVf5f0FfeQ5g3hlnLZs5/QIvHqaEZ6w8GJBbwKPJOsKjcUoJZr7+DxOpP+oeQ8b/OUeF/cqzM/rZR9roXASYGeuMtoohfsGjr97LkczPrvS4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acKEieB9rr2FA5/uL58/J5qkeP9f28cm0qPAuAMxmEY=;
 b=ImRavTNhkRY/IzqToBW+34m85Xm3rfQvUyXyPONPyJN8YjzpyoeIXLa6BV0LC3uKsF8ml3dGT/kwojeGs4OqPEUguoj9X3nLcd7KPQkQM3Q0h6z4HMkcQkNi/Uq2ZETeNCKyVai8FgSVaag1ESC0EaO3I29rI0QiBLutCkX9s7nTjpo1jn5st9u9NR9NO3kKZAaA0Tpq0a9hNPEXQpVgm4N+4PrN/NhJkeqJ9Ecs/Ef5bEMiw9PdMOFq9nYB753B0Q8bvOwE/slRY/nJUIpts3ItBSicGWSBMbBuZBdyO+qdQEH1HiPq3mMlnfZsmjQVW+aMvOYhFwubgA4y/8Unww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acKEieB9rr2FA5/uL58/J5qkeP9f28cm0qPAuAMxmEY=;
 b=tz7ULc4kgOmIiz1g/YRX/c0q9YhcTfqm8XqBTzSCMug68mMcHWe8mTP09+7yIwVbd7pDNm9uR1oZNdF4TLYnGlDKwtSZPgoADcxyslukKQhxBEI/hWnx97ZXmiNcjVPGBSuqzI8GMV73Wkmmyb9YP0eM0tlvRzE1UtWdeoC8Cq9FGsHGF3+sGIITVaUHTylU+yNmB1SY5Le6YeHZnMZ/XltG8r63X+ZS4dJcpc4+QrdlqCSeq08mk/btjnnWpECPNAbBMz76MQCvgBWSpkn6sv+SAqSy6mXZ9PZtYixAnSeo7dzufmlGoXx/LTScKqdpbsac9cdNGabexblZnYuZsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:50 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:50 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 2/9] docs: ptp.rst: Add information about NVIDIA Mellanox devices
Date: Wed, 10 May 2023 13:52:59 -0700
Message-Id: <20230510205306.136766-3-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:217::33) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 65606cd7-2445-42ef-3a46-08db5198a83d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PUaZPdJy11mirm3h7Qj6/Nn+wiwSXs7SWvdI2flvpTqg7KxkEyAftGoN6DvddANpitXhXxx5FR8Xc9AY6wBGE1LCxF8u1Ey3mv/W5TPr11OP5torUDSNdvlsKDx3dHnuZ0il30wworWUmdCkCytJiqw4eeK+Emm1quyoRqWI+DGaxbBoubvSG7eKX5BoQ7VIB2oQDU20tJbH8Af/CK1db6fpMrmJY+AMLW92hZq9360Wlkx92X1C5GV7MishPRhv+sPaSQjp8yI0JaVBSjfv0QVrflTOj0e6Yf55xjdDI/49LNaPf+NgBIC7eChhcmpRXU5xVFCs9ut8D56uisMcHo+A60S2vXtqEfT9UggaN7EpgRHqyTlHPZixTCv2q5C2pr8x/zZuFY81V1gX9VAdN4b8d6q6LusvH9APORrNGPcE6/8q9HuqbujU1fO2Xwmg0AwES1AC9IyXrqRrWeQXySS07ECbW1AlKLi5A1eYm0vlVrAEP0YcEndq6PUCNhdU0fEXPtrI/reTAlP+8U/y+IMeM+wVP0QRm+YO1ibZimyQB/CYs5Ew2+oV9CKKtRiR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M5+sEgg3/3UpWXPlprmdQij0z1PL/QjuWdjVm654hvgUFvdiFGrgpCYVJlHV?=
 =?us-ascii?Q?CHML7drk8kgRlM7AHbezfnhIONF6Pz6rPNoiUaTLKxbwSecwT1zyw8D68DSe?=
 =?us-ascii?Q?iHoSyvjkHruew3FDs5Q3Uoqi3U0ba4BLVCIF9PPZdMwJ6LtEwVAq8ewLSs3l?=
 =?us-ascii?Q?AwH3ZREFwsPlvfY3M8Rj1Dk7KfH73rzS/QrCf7c8rD+s81+lS3rfEayzpzdm?=
 =?us-ascii?Q?K+T5G1XpgEztazZLKRFiw/UHGPFGfnW0xN4KSRQ785iMKFtK6e3TkbDEcos+?=
 =?us-ascii?Q?6QzJ+68YVeYWCg8JUA6ODNjudhIT/cLmka2D5WfnN2xsUL//JRqd89UVOABT?=
 =?us-ascii?Q?yjLOQ3ziTc0fgRNkdJDHNtpw8UIyUUhlGitdKdIYVdaOnCjg8TSx19XEoJ0e?=
 =?us-ascii?Q?MYKKiV4fNcjKuFBFD25t5AdPUib4krOvgNhsuOJG+lH9EIJFbqyvbmsbzsEK?=
 =?us-ascii?Q?G0iuXOV4VJP7UFBxi8Ktle3MTXd0AUN38uI/dk+yqcZY3GxCruTIvIqUjeZO?=
 =?us-ascii?Q?B2J63qwBYWooLpfaENJN9IDiUjl+DGPVGdhRq7POrJ2FnYFHDrBQJPTbLqus?=
 =?us-ascii?Q?g6n5DJybUHCtfOOb4EpILFrn2AcoRT26AZlU4dMqnx3RDOBVKY+04E4elQM6?=
 =?us-ascii?Q?vTb7VIKiaMuGLjTDFI2OYZ0D26pI7a/qEjH4b/5k0pxR8lW3j7lJ7gTuQmBd?=
 =?us-ascii?Q?/FPaJPrbu2ifTEi4GUTe8vMTzEhAdFZtoxy/n8kci1jS6hWfysgHXfu1gOpa?=
 =?us-ascii?Q?8/TXx7Bdx6AA13klZnfMrfJkgJp3iDhg58MyjzIy6p7IcblZ3A2oOqPKBZXq?=
 =?us-ascii?Q?FgzQD8PwbIRvuXtKeJAlVXbBwSY/NrQm+18RJTFQNIhHnkXfVrcMdWhEdUnU?=
 =?us-ascii?Q?LmK9Lmln2utH1xdx9RUpaxVgc2ZLEpHv3W3H1TgsUfdYowPX+4nheGLupaNx?=
 =?us-ascii?Q?D1/Hutbt2aVhJGq70G9myH1K2qPUTSrQekZZ+hgTxqkLyCGEihN+12TdJep2?=
 =?us-ascii?Q?Zq1RrtmPQEniRC6qYhgIU85O8AEoreV8cio6pqcyyJrKGvEEo34P8Togc6JB?=
 =?us-ascii?Q?EPV9xxRXVhP5wQmhD5DEy6A1MiZy4bYuXxC/m/RRDvRtcmzhI7ZRQW7R95/d?=
 =?us-ascii?Q?QLBdGrrDIo4BgdrPTDJB9bJKEU8NU6H97+ioU6L3H/gDEZtiUtBekeC7iJ4T?=
 =?us-ascii?Q?cAFw7BYvSc5fUUKRymd2tJCAWSmPNWsi8XQI698ID3aSXpbtBLR8cJibZAOC?=
 =?us-ascii?Q?nN8XbX9b/Zo38AFprW8fv2pH2RKgvj9XT1zEcKkxokEX1wWvTSUNfk95HW65?=
 =?us-ascii?Q?60RxA0mvx1Ay2EKcNAKkWADML/3lQG5Lbi4gPF4TW3NTgPhDAj8mso3RY5og?=
 =?us-ascii?Q?Qr1HHUnJRBhZAUalGoqnxE2RRhb8x6Xvc9Npr89YDRV50ERC9A2iSATNPsVp?=
 =?us-ascii?Q?UhyLRfCCcp28DprL/syY9E8QUOtaeFUk9h1UzYKyf/Bl6TXOJlvYwd0r8Bzu?=
 =?us-ascii?Q?JWeUNQjgK3SCObUGmedHORLWyRJzLFL1m1zKxdn9zKxpQqApe0ACTe+P63XC?=
 =?us-ascii?Q?2SJrfLjPR6uqO4gBqKnllY9HVFjS34Dsxy6OGkvCriYgCYSVDnnO+OkQmc0e?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65606cd7-2445-42ef-3a46-08db5198a83d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:50.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6/f+fHdS1vqeN/jQOAeprMD0godw/pobGGnTHKnLRR6SsGIhLGy6bG7qPJ0MK2bTjHv4gsEzM4CyzZL8LPdWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mlx5_core driver has implemented ptp clock driver functionality but
lacked documentation about the PTP devices. This patch adds information
about the Mellanox device family.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 Documentation/driver-api/ptp.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index c6ef41cf6130..6eab5253b800 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -123,3 +123,16 @@ Supported hardware
           - LPF settings (bandwidth, phase limiting, automatic holdover, physical layer assist (per ITU-T G.8273.2))
           - Programmable output PTP clocks, any frequency up to 1GHz (to other PHY/MAC time stampers, refclk to ASSPs/SoCs/FPGAs)
           - Lock to GNSS input, automatic switching between GNSS and user-space PHC control (optional)
+
+   * NVIDIA Mellanox
+
+     - GPIO
+          - Certain variants of ConnectX-6 Dx and later products support one
+            GPIO which can time stamp external triggers and one GPIO to produce
+            periodic signals.
+          - Certain variants of ConnectX-5 and older products support one GPIO,
+            configured to either time stamp external triggers or produce
+            periodic signals.
+     - PHC instances
+          - All ConnectX devices have a free-running counter
+          - ConnectX-6 Dx and later devices have a UTC format counter
-- 
2.38.4


