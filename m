Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761CE5984E5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245388AbiHRNzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245421AbiHRNy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:26 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2082.outbound.protection.outlook.com [40.107.105.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74373AB15
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ed+vi+WpOfNGZ8o4Mv4vCFlUMQ/bwQQ7RUPekkeMkFRJ5MQEG3RHm3MDsn4f/8H8hIo5erF8T1yl17V6sTBdR+NOCNIGAYUU1RVJyY4hcgAp0GJC7x2hVCCVl9zeHlgv4z04nFm6md7BMRWoYCIB9x5f+zDsO8Ct9PKO3K8s/uGfCVvxvAhR7j8MmwANAVdrNCo1l0hWnPZV8MTIhhwK/IAG93DFk/EVds/T2varSkJANemEYncMDkFXXubMo1XGWzD00mrJYIUzM3QMZPJFINvn8Nyy8AFnacjnKXV3d1tKSPixIZhKUeX3o+agVNF5I5VJy2ZG5omvIuMaibnD/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtpHWYY4zwN8tCG6P4OKII19/VjGtKrU5pB2k/lOaZk=;
 b=Vow/nbuUaaOEISRZwbI0GVpWmfcidlVpiLo4tsnG0ahj0+q9wSqApb1TxkfBJIZVDs8H06mnvtK4w30U1d8sdCtJomZ9cHSrIvoArGbToZALk54QpWs4OV9JgVhnx4pbustquYVctETpHxz0vHxlUTevKEnpu4296P2CEo71hUlnVbPSCUjZmKgPvzTL83MDaxETIbJudSsrdiRVZLzE1+9U//O4R3vrnytUCfmUyJxmowHUk9bqe1qft7XlTzgfs5QviaFc8SkqXUfnH2aAB3keFzd7j/nAwh8z0ihHL0VQ40zMSqC9tDl8I5d1a470vvk6OBvYmvWa1lsMPtRz6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtpHWYY4zwN8tCG6P4OKII19/VjGtKrU5pB2k/lOaZk=;
 b=FNJFe2i8kCrqgBzK7TVsr1+D7+ZwfWi8/KrubKuvPdQzy5rgD6Gn1CHJDxEudrCzkRv9TaRcMhe1I5OkDnpKsgspzFySwWQNVD8PVEMVmrTWf9c8bpLXSwIfQ7TEQhNi5dxFLnKy3+6mX52pZQ0Lkrc9bbOL85GhV6O3k19iYEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 5/9] net: dsa: only bring down user ports assigned to a given DSA master
Date:   Thu, 18 Aug 2022 16:52:52 +0300
Message-Id: <20220818135256.2763602-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61bad28d-ee1d-4a8e-aaf5-08da81210036
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWkVLiPqBYN38/qyP7ZdXlTnFnATIxixqjySrybSVO09sYznBJDCQj1ZmBhL9l51OyuR0wic40iRXfEjJzxeg7wwar8UbkI4BxCKNh7LHNXxz0Z+8U9+KaPPNq3aYqxUl1Yp+BJDj+ybcpMxNTRzxUl79mIke72F9+tskvadc/0HbWcDqbx6Q69jLWmH6nJO6bjdm83Idfrik42Bm1LILRcWt/3BhHviwl7uKWe6Lh4MEsIyfZR26Mv0Rp+NsJRX0LEvkM0eWQP/L4G47Op1VhhTZLez6YKo/c00W7qxyFBhxWv1sTM3CowXJJpQpByJc0fXPrHFNX0DJoI7ZIn1396AjgmOFieiHnxvfGUulWcEV19uq77fntDvm4RbHSLid97v4Fdun7rU20m4xTxy5Q1DPEzX/VdTvf7POnEOybd7qmIWMn62J1iy6+l8wRCIXLd2/bzg76Jpi8drHDiSKOboflj2hEqaPTF3lcCMmZ/qerpy5ChQA4AKnc8zXQMcQIcMb2gJSiKIj+S9pklcZRDItDh7kfydnmdziUj8+lq2dRaGF0f3Gcdq8UDERue9Orv3ylknOERIhN7QMVNal4JvF2rMuEFzeCvLUgcbhO5WPlfTvJvmgBS5L3dZugdLMsb8v5L2RxIoKJ1nCOKGcmLX5MqXYpxMNCmgQdRk+ecgLndlu7B3AoHXw65OZ4BHwq69qnBiqUr0kF3O9c9laBjg+EvVVw8j/5thrEqkOcJsWJn1Kgd6fVH4CT/nZsEea1CdnUitSCLluKVoePnerg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(4744005)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PjmbugmQeAEBqKYn0y7nJz/1K3np/210ZkJab2PpmMgMgNPuYLYG6QTYeuJF?=
 =?us-ascii?Q?k85KD8UQUkWDT8my5RJbXU36LQsjEsDwPu8styTZFJ2CQLWcP5Tz4l0/QGpb?=
 =?us-ascii?Q?L+G5koLkdUT2eNmt4/PfZ4M3PLGvI4x6kmFDzzOW9zVokY4GKnCCljuYpyaI?=
 =?us-ascii?Q?j0qYfCwZDCi14cD4+OVLU/FNqT6sol9P4YcNMjcZnhaKkkWlNlMQxaj0Uq9/?=
 =?us-ascii?Q?Vh8TuhUXNrez3uLlDcKVTVeYO6kadg1RDTa1awVkt1U8HMcp60jZGszM05PV?=
 =?us-ascii?Q?AO6y1tT1uSTa8qT1m6oG+g6yb3gHShzkhBXhLFS9lAXT64KtTR6Ptf6RhmrM?=
 =?us-ascii?Q?s9PjcV237s3EIckWMYGmap7Ntn/clWSSPtAvuSK4UqCfrdMEqitrFP4zU4VC?=
 =?us-ascii?Q?7iKD9Q6LpBBdSWYnvbHa3TsBjNbRQlc/vpjoaZEMm31i4F/pRXzIxg+JRKlz?=
 =?us-ascii?Q?Sum5mciZm1eDfmXqqIaoJIF6bVAsTtUw5g/p5TDXLm84fpe4hNPmrT397de5?=
 =?us-ascii?Q?lrgBBIhG8vbY8TLjE7mCsPRMkWtC9Y9OlFK4TkEnCwiTMbeyvdoDhX2h5q0S?=
 =?us-ascii?Q?xUGXqyoda+NyyFp6gyLnOJsXBNKgK0OWKB5ICbgVZhaXoLOotKUq1PidQZeH?=
 =?us-ascii?Q?vT+5fheL2q3RezJASJdKi9BjAaKiXr+22ibSWXJt2vtk12e8WVDzX3ZFexLJ?=
 =?us-ascii?Q?yE9YevXrjEmkUy91XBtmjiQPTyR9CcSWjLcZIem8h3QjjIRrETdRUaao0n0P?=
 =?us-ascii?Q?gg5wiH9sQC+JpGoVtKNwWvVJ9TnRKIumyY99qSX0UizpZzDIkwN4EyUutxAq?=
 =?us-ascii?Q?DvEuJsY4bTJLZHx+GIepJ46qB5STXCFlp9EYnBNQBWN40/FulXamKeGepeUF?=
 =?us-ascii?Q?F48iDM1ernEHRe232BTRet4VOJqDLTZukfXjVh4DTzvi/eBxXqLKNlByGxDp?=
 =?us-ascii?Q?QRnZR/idrjlEee1cxgU91DSYOy2GF0L8w78SFA2QsKJBDcnuEPyqYEfCXIlW?=
 =?us-ascii?Q?RsqBeq8ahsLGP5zbJd0uIABF5YuHoGWW0Aw5qaIc0JxYQTBKe4Kblq1ks96B?=
 =?us-ascii?Q?tj4qbnA7r2eC4tu7jdjrTUU13jIOoQOHD9UQJ4qE63In5O/2lnm+TjcC04dN?=
 =?us-ascii?Q?cFmnQm6A1bSsHUOBdEcTb9uZ42/m50c7U8DXmMcL5npTPOUW5MGdEOC4+0CG?=
 =?us-ascii?Q?vauqg3xJuNpPaBWcOh57Qz5c6733Tm0KU/znx3YeaPMRZkB9e5O5uV4di+vK?=
 =?us-ascii?Q?PvKpPJ4r0F5IqndRD18oS9RivxItfAKKLOihE3KkFFVtDNiycUN14gsuf4fp?=
 =?us-ascii?Q?cmWUEK5OhtwG3WovIc1UxCz51EXamWxLBU4GuEN+xCwRuIemSl+H7RxEe4Cq?=
 =?us-ascii?Q?mUc3Pzw9+PNpNY6ln13FwNOgRjA9IsbL6k+cE8lVMIZWrVrHGvcH5LofsY88?=
 =?us-ascii?Q?XkFkz7fNKwlMU4VU4Pze6vfvSmM964EPxVMGiYNjfNuqBQaN90lJI0Hk10J9?=
 =?us-ascii?Q?xbBhsqZWh9LF/O1Hjp//Nqw5MHcpxlmfbTmnmD2xLAunXh3/i3JDh6mPKEpd?=
 =?us-ascii?Q?Dnmsquxh1zfS67udWolZJ9tssF5sw3jnH2htfcAnC6b7I0ue+o8icaHJGQZ1?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bad28d-ee1d-4a8e-aaf5-08da81210036
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:16.5864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+3B+Jpa1q3QlIfhg3+2H0p6jxNLZjsYRjL/AwaB8VaaAs3sCilqLaD2pnr8YYAqHpns0OwukKbckunHFSQhMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an adaptation of commit c0a8a9c27493 ("net: dsa: automatically
bring user ports down when master goes down") for multiple DSA masters.
When a DSA master goes down, only the user ports under its control
should go down too, the others can still send/receive traffic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5b2e8f90ee2c..c548b969b083 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2873,6 +2873,9 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 			if (!dsa_port_is_user(dp))
 				continue;
 
+			if (dp->cpu_dp != cpu_dp)
+				continue;
+
 			list_add(&dp->slave->close_list, &close_list);
 		}
 
-- 
2.34.1

