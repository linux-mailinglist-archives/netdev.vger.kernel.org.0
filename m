Return-Path: <netdev+bounces-3669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63750708408
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44AAF1C210EC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330471E528;
	Thu, 18 May 2023 14:40:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1393223C65;
	Thu, 18 May 2023 14:40:54 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2060.outbound.protection.outlook.com [40.107.20.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967BB109;
	Thu, 18 May 2023 07:40:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVR10fYUwbZrDGjxms9ohtqgJH+52tAceuajIPYofV4BV0fPO8uUw4bEUEgolsfYbXo8JLnWp7ASQGMEnmgXc57757lbyCqPfEZHaMNV0q0Vd48o413kcfaHrO51xutSYnZlvlhvYNrnyRhdeNI1dqB2gcVx5cDPznSHKMl1b+LEXvMhmw5LsdYIfodEL8Uydx+HbIQJcFTFrje/q86DbTBjDtpUBTG9I15RJLV4fUhBZ022Kd8y5r1gZtLNeC8ZRbv+pov/+HF+bkvIuqEBwdrNigUvZQr760A44fWIlrzZ+MpAmON2RIAOB4skE5XoaPbLJtjd2zhY4isB0tQofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36gg+9o/GTQNRHRdnkWrk5k7FxtfQLHBtEqIvtmkm94=;
 b=ENQvCmR/2/PBmppelEjKIsqslQkzLZmkKzH2SrorriqO9VyEBuhs06GEHxE2asK7mPQO3gH8FTvDZFDBSk/f4v/HCVDg1rfUsrhhMN/BEqAHpVoNvAn4LG0gCo1+cUP2EI7nQSdiPXi5tA5HyxPwG3nBySn57l7gZpW4LfYsAD4c7sZEIwz75dGo5SJvIrZLVQGIFqSeV8O88nMVVWeI3W6Sg5WDOfWkfggoanrQBYnRx5U76StGeqGOLZUncdGCgPGrT5dJ0pohur3/fCtMGqoPpiiBCQg2ZZqKoZs2V7NIfX7wWs0VYtvQKYR0dmKZ9PZCBaeMFk5hepBnXPEDzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36gg+9o/GTQNRHRdnkWrk5k7FxtfQLHBtEqIvtmkm94=;
 b=nE9s1ErUJizxK0HxIo4hjrVfamdokzZQxTCcXbWr3irXnXlFLVzHecuOtLOgVOai/VnrVEK1Fi6wVF31JioT0iYPzZEbmeioj16NpMBuWflkNKtXPdRr6mSsFQLQRrlOPu4u52JnUkUALOzSxQ+fvXDwQq2bU114qQD0P7bfYvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.18; Thu, 18 May
 2023 14:40:43 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6387.033; Thu, 18 May 2023
 14:40:43 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-imx@nxp.com
Subject: [PATCH net-next] net: fec: turn on XDP features
Date: Thu, 18 May 2023 22:32:36 +0800
Message-Id: <20230518143236.1638914-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0121.apcprd03.prod.outlook.com
 (2603:1096:4:91::25) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|GV1PR04MB9055:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ad4144-82ef-43fd-a8cb-08db57addb7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Xnc/ODfFJd+ipaEXlSyN0Sx5S1ZGD7NlBa39/ExN2X+xEMUpX924IA2JBzwgd7V8pWW8n/wbM+81pZo8x+weuweG3ChigVs3eJpSmW/S5jep7CRhgoOLxkyb1m6ZdnUU6Om19jBQPBzjwOOt/A/NtWHStv/VAztMS7O64DlnsLKtvV4oPvqPrM45HoKHKhGcHYe8+H2/4tfKAGn9LskLwIWBPUNUlYgS6dg2tltB0QOQbvpYRy6egNQq9SAHwYbWi7Gp1OxMyUwWzhGuABIYII4xZ9355kC/KMsCwQrxAwrkaakMfZjuO5Ka/6DuPWz1+QlYxtJ7ZlmNSMxRxLUz+F3Nev5AGp3rsp7JSF1aVjX3NgsjmZIwIJhPU3t3XvwynpbM2E3GZ5ZkCkYf7D8KmvZLMMur5t1l+sBTf8yEaF0CvniUCez8YV9AYoZBlPyba60chcOhfCH2hguFC573cVPqEUq4NQxHXBMR/Pu1/yaF5hgGr/wD2WYYGMYnuHkgTms7pJj8lSCBQvETDlGafHBr7yOpdQTZYc6jMJ515t8VTDeu5ZTmhE3vfPmW2geGkqyZUpGSmlHDRgP8uZcxijLK1t3F4z+oeLrBpKmK/9tHoJborEY1buqqlUOlPC+rsFaAtZ0H5mwuKR6WiKnBWQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(36756003)(86362001)(6666004)(316002)(4326008)(478600001)(52116002)(66946007)(66556008)(66476007)(8936002)(4744005)(5660300002)(7416002)(2906002)(38100700002)(8676002)(6486002)(41300700001)(921005)(38350700002)(2616005)(186003)(1076003)(26005)(9686003)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KW0wDiq0fR44JXu1ukZJxqo/Uuw+axPcAzWMhry3nruxYytF7gansAz4ENiG?=
 =?us-ascii?Q?2v7ibaxExbTmHt/IbZL30NVKYKrVemS+CQcCWUx7jIq3LJVzf+8MpEriDMFv?=
 =?us-ascii?Q?KtY3htIV1D3Dsj5RWYGcT8/e79clSz+Pt3+BtRRdIG7D1KHYRdR8Tz/k30Fr?=
 =?us-ascii?Q?zAzAv2wZPowiV2TwsX5Ulbn6dnMKie1LqR4eiwI/Zoe5eP7UxCfRvSIX+KYk?=
 =?us-ascii?Q?nCvoB5EOArhtIv3ppM6mNhG1qdDr2N0qWdnNN9e6TJLRjS3fT+7gm/hmO3fi?=
 =?us-ascii?Q?h3ISj3vN3m9/oQL0J4B0BrARhWmCTw+EOaCE5llhSMXw6tIChAYOs540N+Dx?=
 =?us-ascii?Q?r4vhWRPF9NFufqAvBM+qBthvQTdx3jeXOBY4cUtfp5vzwLUPidAGql3ZclGK?=
 =?us-ascii?Q?LGBrZpWwAZb3vP8zHh9uCk2/Y9wqUzCUrTDUQ/Nv1ncoW6A+SleKJcMkcF9I?=
 =?us-ascii?Q?dHCbxqW/FveXYe0KALjYTo6okkEx0PRkZzko3vtXkNfTBHP5/CSI8Pz4M1yC?=
 =?us-ascii?Q?f4Gd657RzJByQy+SOdiZKzPplnD1bWnud3IyoHY1jyCO3VEYo0jMyvTDNuTn?=
 =?us-ascii?Q?dQ/LHe9fLHTXzj+8K/4IfN6aKKbyPi5vYa8CJhHGc6Ak4ZqGvRBrstSffazA?=
 =?us-ascii?Q?fAoq9jz/06lnl6ZmIW6mMPhsR8pHn4RAlBjtkRyautN6dVV0ZSuRCdfpG9cT?=
 =?us-ascii?Q?X2Q9WOGWa2NSGASK+PpKv8MbglSJRJ0Tmf5pMNwOawUfJAyV6k/97nRvQ1sq?=
 =?us-ascii?Q?sRtPp6d0Ry0qjDqjQxrRPbd5Tva9kN3p+K5xDnvM+fV1UKJyTT320mOLt996?=
 =?us-ascii?Q?MK+rd2LM3fVmXqupOD9P92NcC/Lva4d5g1VPnbMhMky3zetfoVwCsqkLKRgR?=
 =?us-ascii?Q?LqhX9W7Bk/T3liMJLxxH5+A4IVw3d6ZNiUHs/IPe23dV+93UrsVY+rNwHfsf?=
 =?us-ascii?Q?kR77H3QkvQxS5cz/Wrjfw6+Zex6OqyiPoB6lkPBD0dfrmguXzeWC7hqlR3ul?=
 =?us-ascii?Q?9sh9WfphIBOOxxtnLZsfKz9KKPl1UvjvAUj0e6bczVhx2NPrSQ/tH4FABKGF?=
 =?us-ascii?Q?FnB6XWLn2kRIHqPI0+QyAa7RG9c1Q5JdcHEUR7l73AubN2/7s3WEZ0+gVFz6?=
 =?us-ascii?Q?EjhdlI5xqKUviwsJ8NVM52pfG3ifVyqY0UPstEEl6EmcrTDURz8t3ukFURXj?=
 =?us-ascii?Q?+ZnR/cQ+QhJ2m0uqSJkt3w/IUKKU08ZSQc7+GyEMdkgsCftfufjTtxxAiiNb?=
 =?us-ascii?Q?SbBtO07hR/Zoh2F6ezWFTkL3AXrXMzK86j5yQEFqguNZGWIg6kmRa3IgZ/nC?=
 =?us-ascii?Q?JS5rZAH/xZcGixMIO0x3F2/UbKHL54IT+wa4pkM6Bx5Nr0DgcMDVSdZ/dXgt?=
 =?us-ascii?Q?7pC4192Ty34usmFDUb7lCmZb80lUH/kgmQsktjPI2mwefxTA+iFbouybEWBv?=
 =?us-ascii?Q?vCX4ykFM+96fPsAyb/lfWK1vM2yw94QYFWYBlNYLhTNTkxOBvwdDgMsqR+qL?=
 =?us-ascii?Q?HOw/k8KX/456A+k5K4lorHxzRy+v+rmxd/Tm3AZYD2VmhUQvZKgrBv3gu47e?=
 =?us-ascii?Q?HnkNB0EvLA8kFZ6nYJFK2H7Oa1qZF6KhQX3CfPGo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ad4144-82ef-43fd-a8cb-08db57addb7a
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 14:40:43.0133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjylfEad/fOph/xgxWsW5SLHRbvti55xXQHBvUNzQS48sn2LxTJOeIu2PjFQ7r9ehlOLacbA5ZE5WlNKgJahwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9055
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

The XDP features are supported since the commit 66c0e13ad236
("drivers: net: turn on XDP features"). Currently, the fec
driver supports NETDEV_XDP_ACT_BASIC, NETDEV_XDP_ACT_REDIRECT
and NETDEV_XDP_ACT_NDO_XMIT. So turn on these XDP features
for fec driver.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index cd215ab20ff9..577affda6efa 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4030,6 +4030,8 @@ static int fec_enet_init(struct net_device *ndev)
 	}
 
 	ndev->hw_features = ndev->features;
+	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			     NETDEV_XDP_ACT_NDO_XMIT;
 
 	fec_restart(ndev);
 
-- 
2.25.1


