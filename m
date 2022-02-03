Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB224A8C2B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353668AbiBCTGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:06:30 -0500
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:52993
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353655AbiBCTGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 14:06:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJf2z+yeNuFR+k9TgadnobY0xdxT6nv0SB+Xsyv08VFPuK3HxtI2o8oGLvJ+sUQJTR+yf1ctvHBv0rVLaI6uWIKFpOq279DO5zkbA5Nvrxc1giz8/XT/Aan5AoTwEQYAem1KZrG9BPmsvSjQwspfcJot5umqqChSibSO8FVGo/bW0UbRTxEAyaShLT5sjhmLT8dEIUZfD4JkiabA+dNbYKVAqhh3F8NRM62fD/kAJhhjeapIVvixW60cD07zNGdAkWZn5Z4rv/Ak89lYqq3cVdlH6x1eo5L1q115tuwcxcWmWPg7L/85htdOb0HLxCeIRFgH7G1NqmJfJreZlsKNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jr2AvyhVaAASDgwi/uwdp/o8N6yOwinn6cQyl1GSvp4=;
 b=R+72oikf4XEXCWN6kqN+MmD5LlPOLFWLjPR8nwMkGWt990pmWEBLiqvASsLjhh7sM8bjTNL3DD8SE2UEH7WdGC1XHBIhVrNfoDk8FamTGlF9HabITe4ndgCtl848/N2cZo/kTgW6cmoRcRLsZgJh3sozeKdYqpfPBPTHn/FxOmicuOU7y49v70xL/IJQPpJwJpeShsTIxaXzQ89Lr6jQzqZRY2f6bxWqC2E3+MF7zMB+dLlckL/3C54cyIxAh4E44SP2J1+CcmGDbPOSWbgF8RTT+bQREDSIx2K3a9Z+W+uppLVsi2Cx4ioTRLo+SAC1J+Ct3x4wrwOE/QvbAdCqdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jr2AvyhVaAASDgwi/uwdp/o8N6yOwinn6cQyl1GSvp4=;
 b=Xix6U8yzO27lwNeWjnuGxkrDloUUkAeyPVAH6UhZKwJ5LByXNPrCNGsfipogz3rzyH9kPUyiHGBxpk/So+BrRS4jF93RdbIeBCUdQMc7naMa2zJu8Yu2Qim7Af0OoK3lbE4/NuZzQk99Cr9vjuKZVoSz9WzaqMYWDGUfb4FLd8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by VI1PR04MB5408.eurprd04.prod.outlook.com (2603:10a6:803:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 19:06:26 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 19:06:26 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed after scheduling NAPI
Date:   Thu,  3 Feb 2022 19:40:30 +0100
Message-Id: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0070.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::23) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b46b94be-dedb-4e01-0c28-08d9e74846a9
X-MS-TrafficTypeDiagnostic: VI1PR04MB5408:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5408146201BC26CCB10DAFEBD2289@VI1PR04MB5408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6a7fNcOHop+E14NH3l1XRCB4jYz3HMzqZeaxCR/KLsrFVZfHXuYc7DO0xAdQZGvPgt32wXxcTFl39EVI8n184AiqS/2MFHn589iK96tnVCn7IBRPQOuyNKDxfiUmO80m/6OYC8rev08O8FyGUlaE89lnRlgIEzr8yMET3qihVpbyRT7QcuG59QLN4J/GfpckwwF2UeVSUbwU4r9HiCLvz6dh41IP3vnwj86T+ym20oFvgJvB2m3BT9lu6o+nlrDg3r3Q442DvLwdpLhY9FbFRTJBFDf8SvjZtKld1LVhX04+aDzfhh0MLbx7xsQFXpcTE++0wUF1eZND5ZQgxYwLyPQtnLxZAAnAfPeYWEyGl+AbNZO8qq+aSdDNU/QqF0O2aEh1gFFxBGHO2v7F55sVeWSNJ0zVtX9y2ueofqNno27xEQD39gymmQ7doShoBkLKIpY3QFKMj69Ftl4aT609nosz8VKfLM/J/CX+3qO+/fzAJwe9h47DGLeOE4RyXvHQVUe7cVJpZRyXyac2lkkEH7/z1eFlyuHpp0V83nHjGNEVA00Lr3LDj31hgN+knkiRlVPrnUKl3PJn0wjHw+Zh7briIh5y1RfNY4zrATbs6P7Nsc3IR8oX2nlwrJlW/J7TxL+520lYd10lLiSmIeFpDnpceN9XmgzVyrpAhH8/HNm1C4uh1S80uJixnEBCH/wMNWQVPQIprKr6gwviPOtqn9yDc6YCQ85K4qQBpYs2SJY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(8936002)(44832011)(2906002)(316002)(7416002)(66946007)(66556008)(66476007)(921005)(8676002)(4326008)(5660300002)(6512007)(6506007)(38350700002)(1076003)(52116002)(186003)(26005)(83380400001)(2616005)(508600001)(6666004)(86362001)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mpFN5iJweVVD1eeBb5lKH1dQFTeWKSR1V7a6vXlS9Cc+B3i+6IolvOH4uJ1j?=
 =?us-ascii?Q?7fUNnk/mrv+QCLbRwbUZ99h0HnqcSRRj5R9fvcDb4A/8+FKO2ynOs/UHYpms?=
 =?us-ascii?Q?3M4t06cDiFOte66ieGbMr8OMyf/z0ssJFNCxlFxN0WVt1vrD+ahs/7ZZwRId?=
 =?us-ascii?Q?B2SNyzXgbVUyO88VwJin0/vPiOrf5eOwgvcG5BWVcWKwXXdOGjFYxOZeMlDH?=
 =?us-ascii?Q?jT3lWIYQ8ryJyu8gHGooYMpsGN7hXamWds9JiUDxMkrCBC4BUUAf+dWhAAdb?=
 =?us-ascii?Q?iNpT7Ntj6oTKmOM4eRpuT6lAplYQXtm7vrIujAe14hqGuoeixQhA3G4EpcGR?=
 =?us-ascii?Q?z7cUOqO6qLWgf90RHTwYdW9YXYbwooClOMAUY2a0f+kREZeedtQl2+xltZct?=
 =?us-ascii?Q?5cmUIDonQ83mmCcYYgfuV3GPOlmSfnZDmsjC1HITeDMG1oclCn7eHRSIsq7z?=
 =?us-ascii?Q?3Jgc9dWNihtiv4Uh40yv+HetX7GBR0fBeWRt1+vbDLldjcJtnLUer9nyn9Q1?=
 =?us-ascii?Q?P2QqqmTY4u0f0UcL9drE9Lzd/O9dvygrivj44C3dJffZhEZsQbvUCG+mRQLV?=
 =?us-ascii?Q?m528m0yWwPoEd1OFbs6Aa9Slc7l+v8RRAF3oRPFbGdD50dbu46MFQw9W2K0e?=
 =?us-ascii?Q?VlCn+Ojit4PlH6d0x4YsRxn9TvG8O6BJqNQwL5ozXJ7XnuZ/9HCiknmXtNdV?=
 =?us-ascii?Q?SSxJWInVJ7kn9YTGk7XpykJEytLl0Z7lkEga1gkNAbW1H1zAM5n5I1cSvzfV?=
 =?us-ascii?Q?eEvfBvbSfR8gUUJHsCp85Wcdtgx+U9gIO40wLzuryn35JdWD+Jz0nNiviysL?=
 =?us-ascii?Q?Of3QcP2GnLLJ6jaR3PI63h3XKjOthaHiBK6pjw4NEDRq6M2s8pgdMwvpHsnL?=
 =?us-ascii?Q?033QL5iQObWCoT1r+jIgXrgWCR50Z2u217uPvk07Izp0/+WJq5NPWqO5FUgD?=
 =?us-ascii?Q?pa8zxwpW3D516OZRUbBbusNj/khePyprxpFxws3NxdoBv7gBGN6Fm/NGz4Ex?=
 =?us-ascii?Q?VWVgnrn85X90WRf8ZCuUs6sSswTXe0Z8XKzlcq97a4gFZ6Z6ets6YzhMqOOF?=
 =?us-ascii?Q?j/Rx0BMtnnpe1PxJCKPKJL2OOG3Y9QedYh4IATKa6bWVejS5IzbURQ+DxSDw?=
 =?us-ascii?Q?i42sq1dHVPJpmYs63VpqbWhhzawgAc+LSgAIQo9oMq/qqUEE6+RgFTNQwMF1?=
 =?us-ascii?Q?3tJ+zw4NgpaAE772mfyczALh27+RmH3Ks93WVXbmeeSlog4lpasHUSZW2nu0?=
 =?us-ascii?Q?/tM/SiLAzef1XF77Z0jppuWFDONnaay0ETCTOds6OwOs87lnm1vHah2YBAid?=
 =?us-ascii?Q?1ckUTNcyMZHeaPraOWXqG/5uHVVUn/4oGI6dAYUKhs1eKzFfCdsY/cQp6sRT?=
 =?us-ascii?Q?NpXPlANigRu8paP7gZ4fseGffrh1xyj5VePoO04T4aWrQ3o0ST65pyPB/pFS?=
 =?us-ascii?Q?jASoD+qeQ4B+Rp6x1eEWOEdk+HkAs0C0boY4MNMBxwo7VnIyt8EQ78Fb96iB?=
 =?us-ascii?Q?LlrFYMYPigkEaGB55Xcygry1yfyekEpXK0r8LA4MvjkO5FbigR0St7X1m23d?=
 =?us-ascii?Q?StXA0TO0Az6QsWgpY9Rbz/L7Vc81dFPcKJZTZYXh6+mImSY3A/+WWpPh9aBC?=
 =?us-ascii?Q?9Eq/DyhkT6ma3Dk8CP1kGIw=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46b94be-dedb-4e01-0c28-08d9e74846a9
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 19:06:26.0187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67Q/F91NuDEEbBqHobOoOt8kwg1yZCLANa8z2Dp3tLdXECzgfazIw7t+SYZrfgCx5Ie89RwePCrSNlfqSnY9vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

If NAPI was not scheduled from interrupt or softirq,
__raise_softirq_irqoff would mark the softirq pending, but not
wake up ksoftirqd. With force threaded IRQs, this is
compensated by the fact that the interrupt handlers are
protected inside a local_bh_disable()/local_bh_enable()
section, and bh_enable will call do_softirq if needed. With
normal threaded IRQs however, this is no longer the case
(unless the interrupt handler itself calls local_bh_enable()),
whic results in a pending softirq not being handled, and the
following message being printed out from tick-sched.c:
"NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #%02x!!!\n"

Call raise_softirq_irqoff instead to make sure ksoftirqd is
woken up in such a case, ensuring __napi_schedule, etc behave
normally in more situations than just from an interrupt,
softirq or from within a bh_disable/bh_enable section.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f6..f93b3173454c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4239,7 +4239,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 	}
 
 	list_add_tail(&napi->poll_list, &sd->poll_list);
-	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
 
 #ifdef CONFIG_RPS
-- 
2.25.1

