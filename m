Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39511470B2B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhLJUAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:30 -0500
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:17409
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229736AbhLJUAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:00:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwej3014kCV7W7MepJt0eL6qcNzEaQmw06nafIWJzN/9se/nFUSiCg5g68W93ayIUMC3dMv5yA8pnduhuqYl+xtBcaR3AwbuJ+7PPvz4zlMX4bJhGBtHM7TI8RCJqT6TZ+fC1GiDDj+qBvr+ycDDqA6/DWAlfuBDvCHt6elLVWRTZGZPw14hHHuy6UIu/khNZf1S6TFKEFaUXyEKgivlGoejJlibe+N/VBOuuZ+J0sK8GoXonRgT0nnlKQem5g7KTFcF8yRPJgpxSeFf9jmH9LEt0yIph23arsSK/Kuot+QsxBM6e4oRNdu+2rnqT/Q/mdJ81T9Aw/Q/Et1ugg+Y5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fq7y8sbL9EhXCSHB5x/7klkOz+eRU8pYvcWNHQPnaw0=;
 b=a6MdWH4XaUKD0kfXx/TW2uWvp9gft3+8b1DeckLAaIz1Xiox2sCeGdgFFKywbSvfszt7hBNxyE0oBwjek3VhOwdVZjX9/p18IYQynqP91O3Md4sNfKMaYRLpoyEfYgdB8E3T7ZU8SOgiZWGgyyG/12bWu8Ej8BBQkLgbshMQrYa61sbj3c3WULud/+tBO1sXnE77OkD1v+5HXEyHmd56XSfzmBgzbbMTYuuKdN577kAYVB0o4G5c1aC5oq39I0yjJSHImpAbEFmz7dGIxGZ8rWj+PLKLpdT0OY9q2M3vDjs9axJclT5Ww5MSfDyubMeKtBpKddbTt5B2J1+161i+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq7y8sbL9EhXCSHB5x/7klkOz+eRU8pYvcWNHQPnaw0=;
 b=EXutMTB6m3gWuNeBym9rG5p1KpZuLHI/SrmBy2M7cseI+P2FOE+NAxrPw1tRUGneu4mrx7v+95T0v5hfUzlUdwJ5Tpy+Cc+6ETAv2OP8zBp5zzhw5DOZ/tMjnrZ3zpjr0LOANXawiLUOrgONE3r/MStFM2eCnEMtrWqGB1cqlK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8887.eurprd04.prod.outlook.com (2603:10a6:10:2e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 19:56:46 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%6]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 19:56:46 +0000
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
Subject: [RFC net-next 0/4] net: Improving network scheduling latencies
Date:   Fri, 10 Dec 2021 20:35:52 +0100
Message-Id: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR02CA0153.eurprd02.prod.outlook.com (2603:10a6:20b:28d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 19:56:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47117cb0-876d-4341-5fc4-08d9bc1731f6
X-MS-TrafficTypeDiagnostic: DU2PR04MB8887:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8887BA1F559E3E05C401A4D9D2719@DU2PR04MB8887.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 321ptEZ2Aqq421P243BBcMgfc5ZQnI0BIKQObtfRKg2IEMLePMmoOolmyd3lglOKbwlapDEEmrqmSj99dDxJJSL7balGRLger+oJDecLwRzqxRTW8QId59B4cR4nMR9TnFqllx+f7wzUF35n6aChB94ttWOFOm+ZCrbgh9g/niTESxca+89iQVBO5yUcUvVBJNHPR7QyuIKX277yI7pCFobPbLr3zmzOFEHjXiVsmVUMkyVzk//xmULnhnnPl5tCmDumxJ9XGeCUpgQPbunKIT/IOmvHHqKXg934W3iEeTrl139anFUdrHzh7YdL9wTNh9MlSV41wEyXLtZ57lFrIJbcuWo27YPwRq/EXnVDXF/TAz7oJ12XF10tk1329ZoAAkjxWtNPIq+jbMbB+HcDN07y1bxTWOjI3irYWt6543wU2HMK+en8nQ5GcAolIhHGQCmWIzdL1ePXSxgdfnG9tYmIkNZyfxmt/Kablj2ZiWdAho9Kqo6oDiOyilFEvFXBLbk84yv+vKN08eHDY3E+jMxDNgEyAtie6JjuGD0rAjHMmQzRrX2kn3EGwCyjo2C43BIuSORTeA+aQuUhwYpSNuzRa27mEucnoLJk9IiMOrJZNguTxakOXJbca4NwlWkgAlA2hXimNaC9gcHjnJrtrWr0DMwlWnliWXoetDMpdknji0O1DZcZGFt+mywuAOCxEYBvO1A/UTjCeS8bSrsa+MjrqYMXEu5aVANz6WTPTWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(316002)(186003)(6512007)(110136005)(921005)(38100700002)(1076003)(6506007)(8676002)(5660300002)(8936002)(6666004)(66476007)(52116002)(83380400001)(66556008)(66946007)(86362001)(508600001)(6486002)(26005)(2906002)(2616005)(7416002)(38350700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHRQbnJsaVVjVU4vSFhQVG41VWlLZnh1amFLYTlXTHlsSmFOS2svSFlsRzky?=
 =?utf-8?B?SVVkNnZtUnEvVW9BVllkL2F6VXB3ZFN4WEN1MDRxdUx5bW0zRzZycTZLakRy?=
 =?utf-8?B?dTdxOEZKZXgvSkR6U0RxOVBkZHZJaTRodU9sREQvM0hZdFZzeDFEUy9HL0I1?=
 =?utf-8?B?SEg5c29mcm9NL09MallkYkZkOE9TenVmalhxSTh0d1FYV1poL1BxYVlvaGFa?=
 =?utf-8?B?R1U1Zk5URzZmKzBtZndIc2lCUmllS051TTRvU1IwRlVKYWtlaldOaXVQYmR1?=
 =?utf-8?B?MFFCRk8xVG5waWE1czdYbDV1SHdxTnJlbmJQNDhkV0hzL3M1Nm5nTnVaUU83?=
 =?utf-8?B?UUorWk5FZHJkU1RaKzdwK0sxNzVkNzBxeGtwcmFUb21TWk9kSGVpUEtXTUJG?=
 =?utf-8?B?SUxXUlNYY1Urclk4a0VBUERlbHkxY1VqVWVIQWtNdng1dlFMRElmU1JLQWs4?=
 =?utf-8?B?d0wwSWhGYjl1S3FGQkpxaGxoL2ZMRm5sMWttc2VKTUl0aUhJc3haZm1CaGJ3?=
 =?utf-8?B?ZDZObEh0Z0RsZW1WcGRCUVlsL0k0a01qQk1ZdGJ2NmdyWkkvazF5T09yTFUv?=
 =?utf-8?B?MTNLWWViNHdndzcyM2FhWURxOG9HaUtLNWV6aXVTRGNiVlk0RVNkdXdybEVK?=
 =?utf-8?B?aGkzWTFiRndYYS9XVzh0bDlBUERhNys4K0NSV01NbjNZQnlRUk1zcFV5aVVk?=
 =?utf-8?B?RlMwNUs1dEtEUHQvbVcvVVVhQTFDc3ZLT3dsd29hOHgwSGFYYVpla01EUVJP?=
 =?utf-8?B?ZCsxUUpyTmd2Z2Via2YyYTRVU3ZGL0pDS1ZQTmdxU1dIME5XeHppTjh4ZkRO?=
 =?utf-8?B?cS8zSk4xZGVJZVdaOVhWQXFIeWprazlRSUZJT1F0T0JSWTVTaGcxc2NSeUlw?=
 =?utf-8?B?N1k2bW55KzM0SGhGQStMdjFQb3VTOEU1SDlJRnAyYi90TVNQbjh0TjhQVXVK?=
 =?utf-8?B?MEJFNm5yeGxGSVl4dDVuOHI4VkFHRTJTTXBOVlV4dWNtRWdubGhPVXV0NG1p?=
 =?utf-8?B?WHJrbXJHYjVOMjRQaTJOckg1a3hFaVBqbkx5dDliZXZiZDgvR25WTVNmUVdp?=
 =?utf-8?B?cUdvbDlSb3Blb2xMRlFGQWg1bzlRSGZ1K1pFZ29GMm52MGsyRVNabWx2WlN1?=
 =?utf-8?B?T3NXcUpveENUNGZHT21TdkhNYkdla3lRWEFhSkNnSnNhR0FscGRkWnMzdmN0?=
 =?utf-8?B?VUx5NDNHQ0hZYWx5dUl3dVluZWIzTy8xZjFWYnlKN09La01aWTkyd1VPL3pU?=
 =?utf-8?B?U2VHL0F5eUI1ZmdyUkpXcVN0NmxWTVE5bU4rY0hqTUdvNTNjYlYrdzJsZjlQ?=
 =?utf-8?B?WFZKWDhWNmg5OXdTYVRVMWpnSWoza1NtTUQ5NFM4STRKd2ZOeGtiZXhIelN2?=
 =?utf-8?B?bGJkeWxoOGM5aWFjS0pUNEFmNnBCUCtJUFQ3K0hpMFRObDB0eThEbWFIRGg4?=
 =?utf-8?B?QWpjUi9hMjRlYWZhUmRHSW9RZGkvQWJUZHNYNDB6Wk0yeXRaN2V3cjFLbDdu?=
 =?utf-8?B?d2JyS1RVSlhhTEhmay9aS1lPWGh6NTgvaG9hTkhsbE9IUlloTlNlZUtYSVBV?=
 =?utf-8?B?QWQ1bktDUUg3bWlCN3g3SXdKcTJZUndNeWtyemxBT1JrTXdReVkvaXE5U2Vw?=
 =?utf-8?B?LzNpYkFZYjBEeXREUVpnQnNXdFlyUkhFR1JTSXV3QlpPZHd1U2I4Y2U5SDVM?=
 =?utf-8?B?Nzdrc0V2SlhFcHUxL3gzQ1NTNTdKNWVuZDh5VTZrZlBoUzgvRU1VVU5LbzJu?=
 =?utf-8?B?UFpTa0RxOE0xUmlTaEJHd0VCaWp5MFVUZ2llMkhuTTNyVEF4SE4wQktSSUdm?=
 =?utf-8?B?QmtvSG1yVGlaV3FUaHQ1R3R0VlNiNk5hbkRXMXU4TjdLemVJSXR5WVhWOXhE?=
 =?utf-8?B?dHgvc09IMzIwK1hVVnBTVzZxRU5wUmU1TG1ZYkJnMyt6cVBQNG5xeWE1cjhJ?=
 =?utf-8?B?Y3dFUVlmbUlNZ0wxRFVRUDZpV21LV05aN093MnJJR2lnaEc5eEVpeThxVCtw?=
 =?utf-8?B?UFJweEx1dm9yWVFNT0Q4ZU40VGFyUURBaWZ0bzJCMkNoMlJ5Z3ZjaWFiOEIz?=
 =?utf-8?B?czVjOXlwN25SU3R5RHNoYlhlcmZPQnJlcXNkYWYybWgrUWhHN2xzZDZwbFlE?=
 =?utf-8?B?Q3FMZ01wRCttNlZRQTRZbHVTOFkrUHdtN1hnNEpjbFJ6ZnNheDhDV3BKamEr?=
 =?utf-8?Q?kaIxe9qF4BIo59XqXvI2grw=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47117cb0-876d-4341-5fc4-08d9bc1731f6
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 19:56:45.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pu0bpZikGSRZqEGL9uPYoQE8rgCUMGkYv88IpFdiauHLY81c8LRBLBtDoc12kXvADRqq3VcgLz8fgcuafXWW/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am working on an application to showcase TSN use cases. That
application wakes up periodically, reads packet(s) from the network,
sends packet(s), then goes back to sleep. Endpoints are synchronized
through gPTP, and a 802.1Qbv schedule is in place to ensure packets are
sent at a fixed time. Right now, we achieve an overal period of 2ms,
which results in 500µs between the time the application is supposed to
wake up to the time the last packet is sent. We use an NXP kernel 5.10.x
with PREEMPT_RT patches.
I've been focusing lately on reducing the period, to see how close a
Linux-based system could get to a micro-controller with a "real-time"
OS. I've been able to achieve 500µs overall (125µs for the app itself)
by using AF_XDP sockets, but this also led to identifying several
sources of "scheduling" latencies, which I've tried to resolve with the
patches attached. The main culprit so far has been
local_bh_disable/local_bh_enable sections running in lower prio tasks,
requiring costly context switches along with priority inheritance. I've
removed the offending sections without significant problems so far, but
I'm not entirely clear though on the reason local_disable/enable were
used in those places: is it some simple oversight, an excess of caution,
or am I missing something more fundamental in the way those locks are
used?

Thanks,
Yannick

Yannick Vignon (4)
  net: stmmac: remove unnecessary locking around PTP clock reads
  net: stmmac: do not use __netif_tx_lock_bh when in NAPI threaded mode
  net: stmmac: move to threaded IRQ
  net: napi threaded: remove unnecessary locking

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 44
+++++++++++++++++++++++++-------------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  2 --
 net/core/dev.c                                    |  2 --
 3 files changed, 25 insertions(+), 23 deletions(-)


