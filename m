Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9581B485375
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbiAENVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:21:55 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:53697
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234458AbiAENVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:21:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IARux4NMqnVSxQvuf3JDI+TKAZ0JPdcUluYXlsN7r7TsMT8za9Jdnj7qybBz4NPiwXPvpwG5gEcctyodAvGdbE7rMHGMhkh0n9YSFpu5/Nrl9E1ON43T512R/kHJ+dZl37YdoKXbQIpI/CnrSOBZg0GHGUHTQfAUZLfdsrSD0KEFMBzqMg/mb4UGyTX9ziSwS+UPaL2ph7y5onK59OiBvqO764YTGE7Aa92caDXDYVuyQKUc59EJkO5k24d6CeGwjt/nVjSWUXzDsF0HzspC78bgX0X72dxhI8XvlnYTeBf2CeOJdDgB3JjVxiMFaKZ7vcqiHZseSDToD5o3SeBW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMQVvg7BJAjLQLesE9L85H9GcQjklA1CDgGQjN35Z18=;
 b=j5E6zCsesH2YKcWaoIZC2crX0HFocLz5xuYPqrVLI/1Ez15iBXfPmnWDQzUGJyL8M/WkJPemh/2lcM0LUW9kBWqg4ihHXRbvwrMvj4VtVdFuiPjZDMRqWbUHCtbLl/Z5zkZ8/eiFZAymzMsZ5l9vKo2jZp225kWGdx6BEoq2awVZQEFqF5loOS/p/aaDRTCzI+7XXHfys+6L7mDFTbu0P3Q3T1teWmkmCQCyZXRRBp5f36/53ycrDoNeUuLn5vOwMutGqnU3uL20gBHlss2I7sboWf/L4THtDLkJ2RODGUu6NdaO7wRgGeExl9x4aOJh4v/pHWkXKVoNuORHQbQ+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMQVvg7BJAjLQLesE9L85H9GcQjklA1CDgGQjN35Z18=;
 b=RF8EupWgP5n4KMF/GJLr3Xk59qvnu0H7ednnSfAtJZ5GDd4S4a/i9wnS0oxm9FegRs6NDmzCmk8x1LEqe/PySe7rWxCXiuJjJqXndOVyEC6JO1fOlOwunH84SN+zsU7Yl6V80M/wpf0sh05aqsg+FXCm3b9Q2DkFOmapGsqnpwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:21:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:21:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Date:   Wed,  5 Jan 2022 15:21:34 +0200
Message-Id: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0150.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 436dca0c-7c97-43e2-8e0e-08d9d04e55f9
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB74081F7A558D233D9BFDB537E04B9@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1dRgyyZ3uYTrAvLQelG+iJ2vobxncCLYPp2O0O6/8LlgS9/PN+lcnHd9m5oX84yJw0m0wBDjERV8X3lTylAXRwc8WvML6AoYPe4w48moRy5G9QAkdaFRq4qEdlpYAHOWTeULIIDD48d1HeUhMssgwQ+YS0wYSt5NKh6Af7cpMMAxhGvIj/ofVSfJuoidzboNtDio/vPR32GzhNQfDCarrPDCIMva0FiO1FDoXInJ1fwC/T3s83C4kDcrpKf/rvWY/IMzHyvo54/YZLu82VWPnktCS8ZJISAPPateWPvb40obOeZQzfA1O803orUYg/bQ33TAcaZ1AYsenA2xvIWy1RuQSF+vfrNhwcWQU9E/aY8sM91WrTzuDkzeDMM6a74nDi18kYcZUPqZDRZgdyBSqVYSjRtkucfWS9lfNRDBRw/VrNYAIUbSc44GOQbFv1O1+2UazhyddRV6LJsdCjgy6ghxCeGI80EFsb9iv5pssrOLLCuyj0OC8bnuBpgncafVmAPvFm/JBiU6R9MwEB2jkN40YsJVGcTlZHcsNlTS1Mj01UYgv6VUz6bjPd4NIFZjbP5aBHPcHlbwbnKNBfyBTs0Fk0D7b5Y1Ynje8o9IXS91n1znALhYagbni5KEMqUw5cHe+Hfs2IfVk/mQS8iHP2fEKulLSIqZ77+g8Ng1ONHjX4yiV5Aqs4FRjHXw8EReEkprRaPVzLy7EF+LKGjjfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(8936002)(38100700002)(38350700002)(316002)(36756003)(2616005)(2906002)(6486002)(66556008)(66946007)(6916009)(5660300002)(44832011)(83380400001)(6512007)(508600001)(4744005)(86362001)(54906003)(4326008)(8676002)(1076003)(186003)(26005)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s4rg6kFqdOvfd5hvYo3MYw7YeR1GJpz8GoW4RlwNpR/AVrxRUuvljdK/dh1Z?=
 =?us-ascii?Q?n0N+bz9V8IHuPRbHWrcgZ6BiwdmNwTJu+fesmQ+aiLJkJG7xtO7R2CX8yh6X?=
 =?us-ascii?Q?FhfXUPNEvrakaJDS4nJmPdPJ1YPpGc0ziDkzvwU34BragWO/DaSBtFgTY1tD?=
 =?us-ascii?Q?maJ/nacSNWBM3zVTdw90zcPmtYqG5lGK0+QahbtT5ENVzkIbH5I9G4MaPj8b?=
 =?us-ascii?Q?XFhnqM6a03XfRcEdLwpPvEntHS5Oyhj3jM41D33CzVedbmtNT5n2qMr+1EyJ?=
 =?us-ascii?Q?JjMgRWBRvt/ZmaZ9cSXtWqhlF1i6csEpV7WaH9PhccTgpEtWL9NfAcJXiNi7?=
 =?us-ascii?Q?WweKumgusYYllZVEYl4JC3yaRd0ln7ThdSt5USKnTZDC0jkS4nBqoMHVMYXI?=
 =?us-ascii?Q?Rz8w6cgNlwWD9fzlYGW82OnqE3jsTAMklRlJZga/Vd9Eeate27TWdQISQ4Ru?=
 =?us-ascii?Q?FjCsWmxAKqglrH4g1H3aPCuPD7616ibzo4ntrqygnivtgi2Xq9eBBbp/XA2t?=
 =?us-ascii?Q?A8EjuzUTA+9XX+x0FJXToruVkhl9f6xg0hj5YBYYwAss7WX/irwUbvfvkDeu?=
 =?us-ascii?Q?GFkgmEJsjGTcP6QMXbgbFSb5DcY9dTpBCseVVqEgQn3eJNsIfnMIbo+KVbe1?=
 =?us-ascii?Q?GmSwB26wl4KRKW6HrO+q1EDaGid+v/JYJL6Sx1B1Erl1ewguW5mLNcNWQEW3?=
 =?us-ascii?Q?2CL5b+os4h/y1CojlnuQYw2csv8BUgNZjfjs9gMQG7R7hwf36MEZ3JbsmIm+?=
 =?us-ascii?Q?EKhjhSdMXFqrsI4BUigmo+ML0lF7y4wxGMBE8ZL0JNyEqkSwtJVfxu7/TYiY?=
 =?us-ascii?Q?j7p19kufLhrpNpNruYCsK1KEpZD/aMdVs/ciLk0q7aa1CUe4w2ddBYRGTYY3?=
 =?us-ascii?Q?FmKeaMNw29Ne6pqP3cD6KEki1QLp59byx36Y396JGNTHnCCOgEQgFx2pgNVr?=
 =?us-ascii?Q?p5sFxYpsVk65xlttWY+7B5jvhfNh0HcevPkd3pn3a8G792GZm1bgTqgzpqF4?=
 =?us-ascii?Q?u6SYWRRNstVGlTMSyVoouhi/A9GmXEDsUtkSupzBJKAPEOf+r0rzPTQZGL3f?=
 =?us-ascii?Q?mJjFeCFQhtJaE2eQ/UjhVRGEZtYZhowzrUOk+6mOTK1m3sRG7YlBXH8Scgqz?=
 =?us-ascii?Q?8b+DHowSJpyRouuz5TRgMExOkLyMXv+L9U87Kb/bIB0tYxrugbYo/pSJ9VNN?=
 =?us-ascii?Q?eFhhYR9hA039aYPP9J3cvxTIvYoS80TxpWNKlbV7vP6I8xBDoIbENDq8+5mR?=
 =?us-ascii?Q?JM3XIz7EX1IOwp8oFUyq0nb34TBejfnB4UWF+kHF1HsuJ23QifRF7BMb+G9x?=
 =?us-ascii?Q?Or7LaflEkyrEXdOTB8MP0linbaivsMAyqhiut9Mp2zaa0Yuvygow/yQh6oLp?=
 =?us-ascii?Q?lQLmLh9qyi3mlZ+0L4pOoP7fKzl/dQJOpVznUMLLj1ExZz53CksM15JK7SHW?=
 =?us-ascii?Q?8z6GItPVrjNPl7Y5B7iZHqot0A1Bknk+wMMr22+dSLu8vFGxiud3VYe0pxpM?=
 =?us-ascii?Q?lwKgFlH6S7dZZqAx4iUC03cga8fjLGLuZ4b9w9NFsTOiKVV2HM9eGNOfTOPl?=
 =?us-ascii?Q?gqOJWWGn7kFA6vD6WWKh+tfM4/P9YKjLp6+wbyL8Z480J0H7ygLTp7qcKzGZ?=
 =?us-ascii?Q?jTn5EEZphkuUnY/KjQe0pyo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436dca0c-7c97-43e2-8e0e-08d9d04e55f9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:21:51.9955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJ2gFtOcZWZ4/2Zb1G+6ysFRQC65hCb/plYaxxzaMnfWk2SkzWpktZeiJKx2CLVABXRk6p0X+W2TCv4SMnGD7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains changes that do the following:

- struct dsa_port reduced from 576 to 544 bytes, and first cache line a
  bit better organized
- struct dsa_switch from 160 to 136 bytes, and first cache line a bit
  better organized
- struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
  bit better organized

No changes compared to v1, just split into a separate patch set.

Vladimir Oltean (7):
  net: dsa: move dsa_port :: stp_state near dsa_port :: mac
  net: dsa: merge all bools of struct dsa_port into a single u8
  net: dsa: move dsa_port :: type near dsa_port :: index
  net: dsa: merge all bools of struct dsa_switch into a single u32
  net: dsa: make dsa_switch :: num_ports an unsigned int
  net: dsa: move dsa_switch_tree :: ports and lags to first cache line
  net: dsa: combine two holes in struct dsa_switch_tree

 include/net/dsa.h | 146 +++++++++++++++++++++++++---------------------
 net/dsa/dsa2.c    |   2 +-
 2 files changed, 81 insertions(+), 67 deletions(-)

-- 
2.25.1

