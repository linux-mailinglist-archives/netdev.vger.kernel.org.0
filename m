Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5827D3E92F2
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhHKNqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:46:47 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:23137
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230487AbhHKNqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:46:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO/OObI2dDpAcP52dSSwcEK+hIG3o+xa/AGX0ZwRiC5P80W847gtT9x8DBWxe9suUVGiHuV/kKmcWcE1WCCMChg4RreCFVyzszqmNfHFKBzzsW2ZtYA2YnSMO7SHnLdepo7kQzpjtx/ZpRcw2p3hWCYRL4gXF2ks9MLUseGP0dGy1YAimprq/LHk61NgKhHw465xjTpkttjTCj/XmVOlpESODAfdeVDosn+rawcBRFBwvEXAijZlcwv3WQfI+NKmCHGxCE6jxExqWcOcSbd6UYbVtU+dqz33Y/L41I+RQ87CaEbJi7XeU3nT4aW6mnzyeOVhZ1HOpktgYZOGk7RPHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cibd+JRmR6RKj/nbwKz/6cwo07mmeGz5n5K1LC1qjF8=;
 b=EjRLDP7Ng+GvzjmFs6hUBaPjzUzTmFEtytT8S8LZPYkFciWnfbarVM2mBh4kKVNkVw6y9Zb093KI5EAwMiKLTO+K9+6r3lOfgwzqS0lpaV4ObUbum4OZ7S1YNKegSFRWnz1R4gFa/aOtCQdcvxdPAi/gS7ukoSH5/+YpIieNM6UOGJ96j4d9RsQZv7zfnW0kqJ9smh2hHobhFoeHgOuMSy6x1bBaKXPc9+mxTM3FvJtu5LZEiyC+WF0zqXkjzxBbEQQ4cV++oXkdJeirp2+OsgC1/9WNq6SSCJSbbKM/6kJpMTFEqD1ss0m2fcEDe5kO5JwamrNyGJAFrNlPBq6yew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cibd+JRmR6RKj/nbwKz/6cwo07mmeGz5n5K1LC1qjF8=;
 b=LNsvmS6+BNu2dwe9tu8m785nqlECDW7ny3cGb2+YApBlny1TinJwYzYthCK4z/2OAyrWki+2+Xjth6LutYfq05tqaYp28FV/GYFc37FB16heQL9SrBHe3l0qJEc0EHlTiEbLxvshJsEO7pNHb06rszr8UQZ5D0TDoyDzzdiNZXY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Wed, 11 Aug
 2021 13:46:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 13:46:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] Improvements to the DSA tag_8021q cross-chip notifiers
Date:   Wed, 11 Aug 2021 16:46:04 +0300
Message-Id: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Wed, 11 Aug 2021 13:46:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd5523b3-b27b-4353-24e8-08d95cce64a2
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942534FD9EF590BEFC3E0EEE0F89@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pIR3m0rEeK4ScyLtG1aUqluJUlmKC7+6VlX6Io+rN884PWB0j9PnfZFwWxd2kTxV2U2HNklIEBiIWdafm3RwRU9VFrTbLql/elhJc9ZYreNtMl8lFalTxYQsSPnJQkVF6pKKmZSYkxBTZMEW+hLBMJeD6/+AbNU6qZnefOoaH+Kb5xmq4zgtOwKjcxYVaD6RiWBsaGtyjNwaQsMBYtf/07gZvXnvRgvoI+nY3FtYHuOO6xd+aOMoPSRF/5ZBV3cla3BYryNGiTymnl7M9r8XD6T3BoIu8hccSc3IQ7iPb+KhDZu+p/LAT1US1c8hoRWf14Y+7Ecnkz3gkqD2j4gkj69nM/ZiajERZ2MZhhpwoR30ibG95K5UC7gyVQEgYFjh9C666oVQ6pbXkIxahXxVvP6K8uGbQQKXsjoavwkVqE/Tg+9XkUIbexznced/zSqKnaYSpSuTDfSWB5bkRAMUuAupb2b5CSYGRszqOr08S27JMrQ8VNaGpikJNUZ/ynG+azwONWij9ApK62VeP+RAd67TuxdYkGjbcW9yNT12Tob0+jhf+rCRuw8Ph7PSsbPwHxEkHvntQvIKDyujzunjl/XX0k2fzFfo6Kue88ZQ4J8h25jcU+qoDueAclvWywu5HvsDez9e9kfVQzeelIFzDBbHZIPOZXSqToy504Y+8ere0MrXyLinDirpGIntJGY1IBUPK2vgaPdtYfDuSsfeUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(8936002)(478600001)(54906003)(6486002)(316002)(110136005)(6506007)(186003)(26005)(1076003)(2616005)(4744005)(956004)(8676002)(66556008)(66476007)(83380400001)(66946007)(4326008)(6666004)(2906002)(52116002)(36756003)(44832011)(86362001)(38350700002)(38100700002)(6512007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uk3P8BwhwfNdKD+B+mpivZ8ZsDZxnNUhQJos1ERtQIOXcHbgfEzLyEXhlnbt?=
 =?us-ascii?Q?InPrpd5V4J4x1+fraw91h3nQee+YjM8zcotB/wdgrnrVo4OAg3lpE6/RPF0Q?=
 =?us-ascii?Q?LqixrLWLhJeE+Be3QeuaYl4MI+R+5jBwtQ8DUw2E6z7uUQLk36SOxLqbOmk4?=
 =?us-ascii?Q?sceCh+Lqogj4O8Nd5hY0kspRoMBkwzaTjygqSsIvThg0lB85nzz+lrbc8UsR?=
 =?us-ascii?Q?qE1hMNEbF4H2ef3lqDOqlyWysfPUUf64GVV5S+1/0CRHY6alzo0nNMYzmEU2?=
 =?us-ascii?Q?dOk49WfeITp/V7rUPlmwMAJydlouTmCxOvPMUeAlzSIWHF+spvzBVWGyaSww?=
 =?us-ascii?Q?rVDLshX8PkeR//o9KxE6UhkkXxeNiaijt9Ln0fa7pGRI8yiqV9zdsGyst5Jg?=
 =?us-ascii?Q?11L9R9y6D1zE7dSPzjN4Z1K1AqHW15V+hMwAC3I0Puin/EcAfosXCNJSM+gy?=
 =?us-ascii?Q?R+xVcpLKROUo/mZXxue6tbh9rrM0iFIvMxKkbHAIbfE7i6TEFwBo3GjeVGKY?=
 =?us-ascii?Q?SnJe3+II1U/cX2LSzPbPmDXC9Uv2KpsKJN21cxVXVTQP2lReqK/pxhZv/+/H?=
 =?us-ascii?Q?pu3Z2NkffRCGhVm42vCVlM9beRpraslSj8Zk/PzGZCs5romsn704B0mJLOt8?=
 =?us-ascii?Q?N+v3hAoy7hrox66NSxDDFlAm3NaxsGASTIfrhcjrLygdgyd6lcQbJeSp1Dyx?=
 =?us-ascii?Q?YjHfDoFsg8peaAwDv4hoUTbjqGwFuwhwGEZBMvpqX4xkf4TI/AaWE41iRP6d?=
 =?us-ascii?Q?i6Z7ET/cI7ky8XvV8/NyLChvbEGOjrINSJ4vbtHF1zD1GsS8SEnW2A/Q8Z2F?=
 =?us-ascii?Q?fzAKqHdVCyRVf5dkDz42+MAOCsQWujVAd4UW3Oah69i43GrDfx6URv9TiZsX?=
 =?us-ascii?Q?clu5HPDvh41c/doymwdFpe+ydU67Wo7eZEtmTYum0GPJeOw+ckKTfTB2nu80?=
 =?us-ascii?Q?zmQ1jpeHCUVrewhrVemTSdk/bih2qFmlPGSrAZmbPpCyRSTyHgv+qwZjOBhe?=
 =?us-ascii?Q?QiXFOUiAe2SOOKb8bAw4VTgk9k80e2gqpSFxunyfv9o8ThxQR9fXRjrLSw5w?=
 =?us-ascii?Q?RqQEv3t9Mhy6f8NVsk/SE5c7cg1acO68CwL3NET0eiDMZUL/HOBCb78zf2K0?=
 =?us-ascii?Q?4cVkq7ATMiOKo+5wlCmH2rK9CHbE0ZvtpwUkm+kC1B7FoDKmIjZ5o1VxA5xQ?=
 =?us-ascii?Q?EXWjeqdrD1gR2zZaDM4dftosAxjdXl1aZWYrjek+nGjmrBpu765NGCk23mnM?=
 =?us-ascii?Q?UZydZSa1Lf0lQnH8Cpe067RghdfpmOjCgSZbkJcKf+IJFtDqjU76bA1afQJR?=
 =?us-ascii?Q?a8hPmkNDHjsguL7Seajq14nF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5523b3-b27b-4353-24e8-08d95cce64a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 13:46:17.2461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIUPhqUAUwigqSTtXIKAcGxxwLpz6/YG2aP7S/4e9buLeyUzmzPaKwliuvYgZJQZ1muy3X1RbForcHiqy3Cr9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves cross-chip notifier error messages and addresses a
benign error message seen during reboot on a system with disjoint DSA
trees.

Vladimir Oltean (2):
  net: dsa: print more information when a cross-chip notifier fails
  net: dsa: tag_8021q: don't broadcast during setup/teardown

 net/dsa/dsa2.c      |  3 +++
 net/dsa/dsa_priv.h  |  4 ++--
 net/dsa/port.c      | 32 ++++++++++++++++++++++----------
 net/dsa/tag_8021q.c | 21 +++++++++++----------
 4 files changed, 38 insertions(+), 22 deletions(-)

-- 
2.25.1

