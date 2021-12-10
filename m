Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829D8470B2C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhLJUAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:31 -0500
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:17409
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243533AbhLJUAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:00:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+7KPfolRG62C69aFBesIR2ye+IUYeQXjKOode/wB7Q3+tnoywQeJjPAIjVIBggRS/8STwY+7goarzcPUgXFgDIQ/OkrjGoCS3ZLtn4k0Ki8gougj1rwj3h5Kyc7vsOsv/fdQH/Bei+34CUs7OoyXZaXZYPKN0HX0LFhQDBa+oGH1F6sGacOwmXq9HIuMBY1ymyAgzcK5sdUA1N1e3CjEoia+wZK3g4miuwuGVfuHkK5MthOLMitMsnvU/5LZmcwQC9pqm2ppv3zyKmnwQoa4v9lSCYvRXRxYuqrAUAtC99GhEsJYqdG0QRCpRDyqjt+BQiZDMgVlxFCZJKrZdKE8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dFiGDMGs5F5cassm7niXUFHzYDlU8RiOfoHPNyOdac=;
 b=J237X0IcvtWi8oRKVN8VKoBhjBsMtzi2qpXmAqDRTejQ/0z5QgQL1L3KVkeFDIleBNwx1FZKlUEzhxX2kPhC0Ek8xLjCAZsxRi+qkK1wH7HCB2MsTwLbYYIYW4m8e5NGLcvL5PdBXUmoFpUVFhCv2EIPBjraiDjmlgq6D4coY/tjvmzw2tj/DLGw5L7KMwiV2zShmDU+N9KwjQ0pCM/Kp1qn6k/UbyhNyHoyySldfImvRV3S/Vbh8IbZv7wlT0vDR9YzWMWNMWRHukIw2Eb9clrVket8HsQGPHqxUTcGJ1axaRxeHC67HhRzXSu6iRMMmlIvdNjNMCQkCxi0AD26oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dFiGDMGs5F5cassm7niXUFHzYDlU8RiOfoHPNyOdac=;
 b=F11R/rY/ttwusmj4U595t0bdNNQQ48qQ/qBoouA7ZWx1uluxJAdtlTXeW7o2Op7X8DXXv6C+ckKNqq9r55lrH1klzk8zA5Yju446Pf8EmE91WCqWlbUaIAgCmRkyhs1YuODNgKuCyVHb/hskOmqvV3vmHFIgDPqR93kgKTxCcME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8887.eurprd04.prod.outlook.com (2603:10a6:10:2e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 19:56:47 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%6]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 19:56:47 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC net-next 1/4] net: napi threaded: remove unnecessary locking
Date:   Fri, 10 Dec 2021 20:35:53 +0100
Message-Id: <20211210193556.1349090-2-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
References: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR02CA0153.eurprd02.prod.outlook.com (2603:10a6:20b:28d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 19:56:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2f7dc36-2d0b-4470-a75c-08d9bc1732ae
X-MS-TrafficTypeDiagnostic: DU2PR04MB8887:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB888727A311046CACE938F9AFD2719@DU2PR04MB8887.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAp/NsxA81xwkEicc+O5W9CE2NAKA3V/OHk2W3lhPdT0u15bqUfa0F1pHsrd2CaaMkqHTJWT51LoPYGIEW+l1n/uBw54GdB+n8u3N64lUb38TngdxupxacDo5C+Au4xPim/H/9/EWDPrS6V+ocCiZAUdf1btfJzcFwfwmhpdt3ozmnR+nN2swgSvvb47C16p4x/yVZSMBVhwSVxD9ob9FGrTDp1roJFTP0FAL7ajUNsRftYK7E7Rhr9JoU8LD533N9bCqlYrZXRhzzU9V63zcZ5BdMp4ETsVyKGCqX/7YAQKPMEhX5X9f66AWD/6noiJjpDNrAA/ZHuRGHGOLorp7gfHMpksGs8tEOfpHm/SNMy1qXF6iHSjC44A5AXaJxezyrq6mdezWJjgFg/gA9S62N/wOBNSbArkPmUaaQYyZv5t/wuIS5uwl5S1NFylzxRm+1aJ1GNRn+V/eun/e7JMy8FnD68X8F/hIcvIXegMgM6ff5XCc25Ta4YlFc68NmltwTsgxOBu35+zwQWPqsbnKlcw1ikt5XFo6L3p03PW1no/OuDHUj0SALzSpkmJyxaqM9sWeXw2x4gelArttRJUBkp/QDS737XhjFe+3iHIAkE2Rms3maDHGs4q5q7+QKlr0iC9HtTWF/C39w+C55EsKDlLZRnDRHtlPqs9f5vR0n6kfduZRpSJjwLgV3rRkKCGE1RbwgU2AZKP1koNVLJL8fuGj8avOfAaBwjDfuLYDes=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(44832011)(316002)(186003)(6512007)(110136005)(921005)(38100700002)(1076003)(6506007)(8676002)(5660300002)(8936002)(6666004)(66476007)(52116002)(83380400001)(66556008)(66946007)(86362001)(508600001)(6486002)(26005)(2906002)(2616005)(7416002)(38350700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sNV0XALJmNfIH9IAQCIptmY/CSw2GPfJWZpwc9I8uYeJed9JZknYuzwEOVUv?=
 =?us-ascii?Q?erLGqmLRQb843BghHatZGX69LJaZCt98P8itiSn/FNDy5wmio+Z9HoL1tTaC?=
 =?us-ascii?Q?HsbNVpnqtruxG961fuw+dAYTQ3LZeCDF/06uYcP5CC1opKyi+7SQ6KM0Bt9b?=
 =?us-ascii?Q?QP++nWbSfXrttfoFUIPfjEkgKXdIJdsKIi21T1AjDIhejYOsOmM3UPmg1URi?=
 =?us-ascii?Q?pBYlWdO4RdWc2HnSsALiBmyuEtXDPc605S2ErO5A5KaiO5T3MVp4hcHaYK11?=
 =?us-ascii?Q?K60jKIH6lkKQmh+47nis7nL8T4uQVFaC0Z3jl8Pd7MaYHiktifOLFpZtg1mL?=
 =?us-ascii?Q?1Vbrus6ZLYDIAJGUvc2wmwiI/WAPqpSyLU9fWjCd7VN1FyVOcpQ4w8aHGhYy?=
 =?us-ascii?Q?K5LfWEtoB9CaHfVhSVgZhWdDBK/WBxrhV9cwDb8HfHNDJD/yIz1VtzNApDN1?=
 =?us-ascii?Q?vUc3VioOU5gVGdIfZ9ltYBsXSEAVdRxuTnIxhPa5hSCjHIuh5KYpFCS+BZx2?=
 =?us-ascii?Q?6HUv463+xAliwQsMSPmon5NwPZ0/b9XSQ6Kl2D0A7efkHELIXHYcNZgyzE98?=
 =?us-ascii?Q?+OV77gcsiazPk1narI0pW/rHeU4A/xoaCaLtw47Py53L6YwbZAoSP6LoJWUA?=
 =?us-ascii?Q?7WKTkJcj6aHwVY/f/TLS5YsOUhFnbxI89BDE8VH7rB17KvyHlj96ojrG3yXC?=
 =?us-ascii?Q?OL8WwipJ0/pYqb25o8xF4LsIpZm1/tLbJL03ALrdiei5uodxoyFdEJg9ZwBe?=
 =?us-ascii?Q?wXWuF0zBQsRRiH6RImw5LjT6YJTNXmve5g3PjbNMpCjEq2MNisN8VRhzWOo5?=
 =?us-ascii?Q?D61c41auu3qLjp3Eu/anrJF7IWD4hFUg+rJFjfhQqG26+vc4HCdAnuxhFWyn?=
 =?us-ascii?Q?SZIj4OF/2x8aoCgxcujU6HZRgmn/TA3b9ovZxXaoclLGnIRZntTn2M0MYNwm?=
 =?us-ascii?Q?pTPi6DRPpUzEtJr758FER1dTF6nA77u8ifIgJDu6eh3dvLD2sD6Ayp4xxxuJ?=
 =?us-ascii?Q?XsVu6pjKfTgvELcYUSybklu2w9w01pX5WF/ZBmMlnJzYJc23NCa+kUaxU+Mz?=
 =?us-ascii?Q?XnuB6ZeJU71qmnXyP0V4IYd1icdgA/fyGA9D4W6eiyxEhiabpw08mn7iMzea?=
 =?us-ascii?Q?YM7PE1Uq5VrutsgkRRZeyrJ0NgwSpWxcNesrFItgerLwu1C5bYMUEOJ+3H27?=
 =?us-ascii?Q?+S71h+Pu6SlEzNGXXqbSXmj5/5Xc/ZryRdcupHDlxz7ivCsaYE02OKyP7+NA?=
 =?us-ascii?Q?OkajqcMKksJrfxlw/M0qSQ5ifxmlTbdkeSvfEyudMuMHZzq++8v9ILCjPSGT?=
 =?us-ascii?Q?k+yKw0OSTYhvRAo2+9wb9Zr3EfYjcdGXy5N0dt0nUWRHeJgRdRstdx1OH9mX?=
 =?us-ascii?Q?X7R1LIr/PjxoxMUnmhDZj9dt3vGxxSEmC9GJ9eBEYVAvZYniHBuS96GXORXm?=
 =?us-ascii?Q?vT2kY8UL4U1QhpWj5uK9ILApk4HVbpFiYUwph8MzVvW1ZVbilHHx+2rEW/XQ?=
 =?us-ascii?Q?h8Gp5u6D3k0LxWrIpq8NC6Wqbrh6bY7oAVDqnpB00R6xlsC9TCyxveUlIqLY?=
 =?us-ascii?Q?1Y98WlVWWi2LKjPfhvboPnw0ROg11e3s+T8k74TF4f4ZWZBhHvQDaXcGNRY+?=
 =?us-ascii?Q?EoiS4FMxQDvN8Z1vHzxifF8=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f7dc36-2d0b-4470-a75c-08d9bc1732ae
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 19:56:47.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1jjZLscxr2XVFyiNPwLo9sjNC8g44bIF+upmpcopvpfEBwPtF0HXzafee7f6k3qcY4TSQJrA6UBpfGodCRI9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

NAPI polling is normally protected by local_bh_disable()/local_bh_enable()
calls, to avoid that code from being executed concurrently due to the
softirq design. When NAPI instances are assigned their own dedicated kernel
thread however, that concurrent code execution can no longer happen.

Removing the lock helps lower latencies when handling real-time traffic
(whose processing could still be delayed because of on-going processing of
best-effort traffic), and should also have a positive effect on overall
performance.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 15ac064b5562..e35d90e70c75 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7131,13 +7131,11 @@ static int napi_threaded_poll(void *data)
 		for (;;) {
 			bool repoll = false;
 
-			local_bh_disable();
 
 			have = netpoll_poll_lock(napi);
 			__napi_poll(napi, &repoll);
 			netpoll_poll_unlock(have);
 
-			local_bh_enable();
 
 			if (!repoll)
 				break;
-- 
2.25.1

