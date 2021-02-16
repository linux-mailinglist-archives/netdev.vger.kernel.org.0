Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D331D0B0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhBPTIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhBPTI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:08:27 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E806C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 11:07:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EE6P50UNX32ecpaaLlFNPqXGtvXt0s1KjoHlJd3LggK0gU8qiGd/1BiywAENB3jR8eziZA8tYf2OMHw1y8+qQlH9EPvFXftaHrGSATrfMne8y2b07u2TqkG4AffkFXD3exHIt9SjwI46qa2Hip37Ox3+74JKD8KB7/ClKqcSLjm7mqG4HTsRNZXktG6MRcPl71XWpBfP4hGCLpvkJHUWKoV5BbhdmUF8WF/4S0EWnLwx6W48uZp+rJv6wx4FOTNv01qz83ISw+D+DYypQ/TSNGCVSpyLLkFsS/YhWFO+lQTNuSmggt+mZF0UjwqibYvPcpwSvU4pyMOeqBd5x1oYDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqmzIL/DTiJukm6FIa/TyiCg+LtcycmND4ss9+qusio=;
 b=IvqI9whdUbfOUfKnW352sPxvH7tWSUkcGdevREP+OmuxnXnm8LDdSND+t/Z6H1m2fAOKoiGcjJwKBXrocnTz6NhsXTDgyHE9TsW5PhujProWhGPCnrA4uCXkHCQxAxlOv1gW1tsYG++AkWO5Z/sij59bs7wKWePhh6g3nppQf9deks7OwmdJg/mHmrzU9hzp5TAIiQ1/pcviuw/LivEBZJiWnLRUEryBKAS/tG00Z8//qlSE0r04Fy3rw/+AIW9hMqnzTE3OV4UUO5ckjkqTHv4RAEVhaOlF6TTMxVFx2adzKSj5+/bUf27y7pX9V6UHnLHYksIoH1QErusowaCX2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqmzIL/DTiJukm6FIa/TyiCg+LtcycmND4ss9+qusio=;
 b=k6bLZndJ06o/XJ7Ksng1FtyMFegovyEc/ZAd9ctGF06qpnzYHBjimgivoGsIWte9NX1Zxv/oZ8f0saHi3JSr9cmudrvetB0lYb3+9zCw625MbWvzaCOBsQJ1s7v5X5s3BoNvvgBQrRUPuHdb9d8zIykqvgX4SZqczFMruJ3eGFc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 16 Feb
 2021 19:07:39 +0000
Received: from BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2]) by BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2%6]) with mapi id 15.20.3846.031; Tue, 16 Feb 2021
 19:07:39 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [net,v2, 0/4] Bug fixes to amd-xgbe driver
Date:   Wed, 17 Feb 2021 00:37:06 +0530
Message-Id: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::16) To BL0PR12MB2484.namprd12.prod.outlook.com
 (2603:10b6:207:4e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 16 Feb 2021 19:07:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aad0fe45-b540-4d00-2d81-08d8d2ae20d4
X-MS-TrafficTypeDiagnostic: MN2PR12MB4334:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB43345B10729B14697C92F7B19A879@MN2PR12MB4334.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aeWNTpQ09CMo9/YT4fj7TXCRa0jN63I8cfFByXVFp5QiD4I8PhVx+CZR2CJADQaoLJh0yEhWda+5zXoArCXgkdkTQ8Ih8NHlK7C9iYWYCe3/U1GvosAiVOYRVCb5luWQPeiJnuXF2zcszZTQISa/shd7St33AG6s7A8PAc+PCdl7yMCbJgnL/u7FcQkv5vjwhR43mGIanOCfgmiiftwQsYDrm9i323Bw/rT7Q3mqcMO3DefQ/MIUqk7XSTpqwLlORC1y2Th0djBNs80H2IoITbjNRWXYcAmVWOOfnMnV3oKFDSmpk9LuezRNbYRg+f32vDkPn3anzWrm3mKs//aTg6RMz1ydmBWsr7xaUFNg4iHaBlxyoXIGEsu/3a1Ajs9fO96UMVN96JsocTeWQqz0oRZixj3XWKmDnuvC8RWKegRwyOuw4rE6Sl2Ur6B6XANXCrFGGYxuWrcBwZWL9wqhG8uHr5kecJCAwfyBA7bpfi+2+6TCDTFmG7S82iq796jK9VcG/nO/nAevNQkisIaF/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2484.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(8936002)(36756003)(7696005)(52116002)(956004)(2616005)(1076003)(4744005)(86362001)(316002)(2906002)(26005)(66946007)(5660300002)(16526019)(66556008)(66476007)(110136005)(186003)(83380400001)(8676002)(6666004)(6486002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5jmgsSJ4OkvhjuxNX8LdEXiSwPu5S/F17qvqHPxjQxRz+7wIjcKZ4DBUOAIk?=
 =?us-ascii?Q?p35U61Bh8GuvUj9ZMjvuBRfocdGMrz+KQ0dQwn20bty7P1J80u47zqd9luMv?=
 =?us-ascii?Q?rn0RlGSrsg6239JG1m9MY8K2q3uCREwkAuwFAHGj+ReMiUnzG+NSNL9SqGtJ?=
 =?us-ascii?Q?NJIU72OlE43AtXqi0e0Yyid5J30qw4QTH57TtHitji3GwdirbfuiQML5dXeg?=
 =?us-ascii?Q?A9ci4OY3W+s0EU8J9CM1sr4vfmKS4E2Du4tuiNIimbuepRsu229jYp8/TeSw?=
 =?us-ascii?Q?4wgpNEO0RTisdpxiGlAhQSKHMoIL+1Dewcw/UGk70UfRhKhe7yQKJwCLMxt/?=
 =?us-ascii?Q?te2K9wN7Pg2CKv6Ss1bfJpLFV72W4EybCa8sN1gL0jzq2eozyYnnFLkTsaaM?=
 =?us-ascii?Q?l6TNUd1RVtHYtgcxdx0GmYHYDOTthfBKc8QhgslvB/RvgOX837Ji8WspITjI?=
 =?us-ascii?Q?OA7egIGdjJP/Vd72b2iwqG9RXoW1xr3qvMspCL9ujtqru3J+O6qxPRPI/w3L?=
 =?us-ascii?Q?BvIUNY7p8hV0QMyTcN+IjKSo+/LiAQYJoXcxhISIOAMfQ8/OJ4w+JZR7UVdY?=
 =?us-ascii?Q?5l16yygjAMrUKf726vlRa58g/Z8SO0PnKxcaMUPtosdwTTlWH6aPpJDVDFv2?=
 =?us-ascii?Q?eZrAvNH0Tg0ZfWLAvamVCHIduNqznV73GH6ANr6yaB/gjhoRgXRJVk1qaLc7?=
 =?us-ascii?Q?IVy3O9lMHxt9Cs7+jRDWHJhpB9pM0cU8UTIGO/VjVNqsy86gRaHDxvKr8VGV?=
 =?us-ascii?Q?k4wsCh1Hpp+YVXYgAA8WgAEZiA0TIpYqOEKUJfDv0lefSn/MhJi8cfPOHKPS?=
 =?us-ascii?Q?FV2wjDT1hrWP6BNfgQif63+u/3WQ0cHg7d9IujSuZN5IVmiQ4k4MXefI/emV?=
 =?us-ascii?Q?xRQLIWVNUHKY2LuwsZqm4acExBBTibSiY8JwIPd/c+jr6kjO76VaqN8W8xTR?=
 =?us-ascii?Q?pNVtiqgJlN5SH6+82ko1g2Z9lvVxfbB6dlfa0mJDD4P4qvncMXVZRonX9NbH?=
 =?us-ascii?Q?eYN25eFXt7eOlrjsFtQg2qx8UgGZiweN4AGsIKu2ZTGnqU2I/i0/L5F4ympU?=
 =?us-ascii?Q?y+UmUO4rxJjTrfu+3AyPRfLV6Nnd/cXnlAvsjkETmMlZs7K95N5fZMdi2NEK?=
 =?us-ascii?Q?mm9IidDqiTKR662dRELEEEkauBhixJDXrgH2zylSJjc1h1Hd1frJGLntHDsn?=
 =?us-ascii?Q?UNzNUXfDI7jhHRN9V2n//LomDFNgkoVXieEnSnQxthu5wuyCum1p/xOV34VE?=
 =?us-ascii?Q?ATPAyUJNoKZ6zmybgmYreSjLIhUO2WRRz0BGVzpZJZuTmmKssjtrwmt8PxK7?=
 =?us-ascii?Q?9oZvsqcsp1FTQWCynOkqXQL7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad0fe45-b540-4d00-2d81-08d8d2ae20d4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2484.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 19:07:39.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOM2SkDwor1uJKbJDAmdSqzg58DzkLDCzQUMamk3fB4qD34oJyJHtcANMooJqgx/0Z6rDniXPt1+YvIhlqSBjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

General fixes on amd-xgbe driver are addressed in this series, mostly
on the mailbox communication failures and improving the link stability
of the amd-xgbe device.

Shyam Sundar S K (4):
  net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
  net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
  net: amd-xgbe: Reset link when the link never comes back
  net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 14 ++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c    |  1 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 39 ++++++++++++++++++++-
 4 files changed, 54 insertions(+), 3 deletions(-)

-- 
2.25.1

