Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D01242800B
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhJJI1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 04:27:42 -0400
Received: from mail-eopbgr70108.outbound.protection.outlook.com ([40.107.7.108]:39016
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhJJI1k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 04:27:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1lbPCInxBzBnf5w5MwTjUIa3EZtjGRvOLXjE/Mc7vazF6Hpj8Qt2/g5JN76c+TJAoMLyniUf55I46das9A7Va0pSSm8NIS6jUr3SBA/bRS1NDVj3u/YnNBI3qM2BrORTjIq+ZX7LpjS/9rEa+WhjA+j2vdgq8AHtcwme64Ry3uh201tJPfTHK1Antxvr08p5zyqh3R1INDTVPnTHfIRRUx5hmbg9pOdz9XAj4WEwOM9TY+2wxRh678WBiSLzHqhVZxhHnePr+xhnJndXArf0UBaPhNBRz7RSQuYC4Y1FfFKJILrmhNJebz9/GEDYx1S4r4cMa+k1W3haT2+uIACNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3h3zCRqGc4724EeP1+BsJP17wg35L0NDuQh+bv0hEOk=;
 b=OaWSR7f64JKiH3JyEbskW7dw8/tmasBJ75AnIyyOCKjLhCBu/O0YtuRPoJTmsmiuR51NQCNfDuCtlhaxEtmxFvRMBSSYL0hhBUyJmMO67PMutR2hWlesQnlAPpvJwuqgXiejFnGJuen5gIuHyMj+XDLesbu2n+6Nzl5jO/ohy8615Z5BJYlDA3//76YUti0NiokQK2jBrjga5PETVMKClzgE1EI8laIJrpK5zWsLyVIFMzi7iHKRJNMhG/SZ+AFVavgUyB0XcOXs9tL5VeL8KOBilvTEeXQ0wf2MQ+nRA6c+Wtk/JigAaBLZlaOiU3vFD2V+74kSQXnh7sN1GVsOEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3h3zCRqGc4724EeP1+BsJP17wg35L0NDuQh+bv0hEOk=;
 b=HXZyTWHdgXP0BlZRays+eTiiOMTD3kjmkO83XbKgYGGpsJjefeaU15APzwkWx0MgkI118sgGrQYa74QKTJ5NVVnNBT6OebOVygsSJclfCKTfgB8htNGr3Ftztx2DI1SGCFoz8DMAZn/6kXLAIbLz82uUpM/xc2R5QI+uGIEy6UA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0222.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Sun, 10 Oct
 2021 08:25:38 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::4c5:a11b:e5c6:2f36%4]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 08:25:38 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] netfilter: fix conntrack flows stuck issue on cleanup.
Date:   Sun, 10 Oct 2021 11:25:20 +0300
Message-Id: <1633854320-12326-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0501CA0023.eurprd05.prod.outlook.com
 (2603:10a6:3:1a::33) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by HE1PR0501CA0023.eurprd05.prod.outlook.com (2603:10a6:3:1a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4587.18 via Frontend Transport; Sun, 10 Oct 2021 08:25:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e937bcde-8c5f-4c78-62d0-08d98bc789f3
X-MS-TrafficTypeDiagnostic: VI1P190MB0222:
X-Microsoft-Antispam-PRVS: <VI1P190MB0222D882993DDB288E7C38938FB49@VI1P190MB0222.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4J0giYAhztSZe6p8lU/donUq+OHYqxVYsqnDZ+pZMqwvQrNFaBTkDAIkk1H4Nc9CpMSMCg+13j1hgZ4Npw+jzwQnxdLY+WffF/DcRjrrJpX4B+tLFkS7ry266qY2qp74G5c9TWNxR1HuKJQbc9QmyFg9DVQjbKF1lltHNSaG6UOjRX5zSRWNNJFNO8b+hxsWAl59L/pLZXuK+iQB/guw92vxDqhkKpLfQRdmbEcXHeNO8WT1L+cIlrNY/49KW40shM2Kxxtriowh5ddScRaP5VjzR1aRRArAmIsGZ+9+ijYE5HneHtz3p7OEkMzIjTZxb7YiZ72L6KrsV8trc+G6gmVU3X8MVSNsV5fGfspQzjJmRjDYSfwqfL1Xdm6MmOS6FeN1q3MX/S+5NqLIdNQ9H1ToB3m00m6+2/hqOyqFbLXq1aN5AlYzVAPyATFptuo2ZtrpGAnWqMklbaApud93UDEK9FYcdq+1yK1e7ym9XGv3t95Ss0yvHcCBVhq3gfUdjFD5qB9ugHCK9OikqJhFZl6PlyMQt1kBz+2VkFOWhH22F4MCft/ojY03Zvv1vO0jdwzFg9cG+UhlLX2Yldtvsh7LMMYmNuofCTd5x5ACeLbmGZeeQLNxsFWrcOYUj8Eq4lVr8gyutDXqnNmcSxqgNo5vbs0R96/pod/UUp9DnKTF8c4aqdJVeJNf+e2RPsnDOdLyHeudBovvMpjHgVwdJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(39830400003)(376002)(396003)(346002)(316002)(4326008)(8936002)(54906003)(8676002)(6512007)(52116002)(2906002)(5660300002)(6506007)(6916009)(66946007)(7416002)(6486002)(66556008)(66476007)(186003)(36756003)(2616005)(956004)(83380400001)(26005)(86362001)(38100700002)(38350700002)(44832011)(6666004)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xTjLnltjmOC3NANmtoL92LoaAU/3rHnS2L7pidcxvb90HJkf7AAWmBo3yTrU?=
 =?us-ascii?Q?12f+TftZStgAczc2jEtwBNMUzfggGmLvZQJuFVyDzGacTZqPsIUoVQ/nyiWI?=
 =?us-ascii?Q?M3C0KDfGSiqXBEtacY6Ct3CHTBJSmT3jX4kTuR6CtDQt0BSlZB9vqFXxEJWa?=
 =?us-ascii?Q?hfj8Kv7C8Eerdl2x3sogoupe5K5ysLFQkBQxsKLHQedyPHFrsoArX/P2ltW/?=
 =?us-ascii?Q?AMMkgmSzGOe4nLwhMuVKyUMpBCBXJdvBtBCqYca76zxdHPVBmdxBZoYWYHDI?=
 =?us-ascii?Q?Ef9rdjFPgY5mGviT0OS/ShVUH7d/an0FCkL35i2Hkq1PvBJEhSjsvOfVOieR?=
 =?us-ascii?Q?GUx5wUrnQue6V9kzo/PqIo336uIvQp1ATgbMUMxu+GjF0stmxukm3+jrN9VA?=
 =?us-ascii?Q?SMnJXL5vSUXLMC0B3k2pAf6+AvXqA3/B64pREO2ssh2d15nB+81WVQiDqOJJ?=
 =?us-ascii?Q?7hxn5lSYB5urOahIGsLKy2IL+zHD76MYI+oLtX6ksxpX4402ib2LzvhW++hh?=
 =?us-ascii?Q?vYSzk3CBtc0IfwR2XP5DsJ+ayZkeoT/FxkBFqkOcJFfZCmizFMxTWJFvdQHN?=
 =?us-ascii?Q?ycAjaCV/z2mGQ1HECR2q2GLqmQ/Q9T6V2Vcj9OjrwcDCF1nnKw2sSRrbFu6D?=
 =?us-ascii?Q?3+iz5saq+VwddeqTULYVMIrYnKajwMZduX3WMNknaah6qdZo7ooJebUDNwOl?=
 =?us-ascii?Q?eWXH1WraQLoS7kAe9LhFodPUWMpdvjxln0ZzI3dkMTyH2Fu88Vhuy4Le8QK6?=
 =?us-ascii?Q?+WWd7Iy4F45huptVd0rTI5+ziQRXW/z2wu2wkBI576xjg/8sfyln6ARScHY3?=
 =?us-ascii?Q?lbakpHaECCbU/QSIddG5SHCz/cp9lNrEGPZ7KkEVWAA08VZGqjqFlPjlbNG/?=
 =?us-ascii?Q?XkZ030TAcqR6jwM2sPhN+DYl7KXCjijwH2FpwP6K2OtnUHTqh42GCFpm5g1O?=
 =?us-ascii?Q?38M1e9p/D/NGAO/Gzs8gzeQl0FL6+uJ4WGmkM45f9oE4vDvo3IUv02CxOIgP?=
 =?us-ascii?Q?kD074KR4BAbKxOxbUYrkUrnDv8XFePhULFbqTPIwuMIuHRNImUMGFf6BXMi2?=
 =?us-ascii?Q?Wv018Eq7b4nDqgtL0aLQ1itcxaLLvarr+Fw3BssivWl6/n07/aGNh9y9Y1Tu?=
 =?us-ascii?Q?AYnRvNcP/I1lE+zSMcVn20aUyVSoAgghhyU6bnljhcvy7/NlDipFaXrGmdtP?=
 =?us-ascii?Q?C9mTNVWvBEJfWUuOjtPc28y73FVwPV3U04KYcPIcGnDmyPGw29FjNJSJv/pk?=
 =?us-ascii?Q?DUF77RsgvRgNRZ5hiPs5XV6CfRO15EBAUvDBi7g0QjBluL+aVTlrq/wKM10p?=
 =?us-ascii?Q?1A2b9sxIQRtIm+J/VK/qJaLs?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e937bcde-8c5f-4c78-62d0-08d98bc789f3
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2021 08:25:38.0769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KL662lKGpD8fFALknLFJzrEG0e8IAHcJ5wekIjsbqNz/FBQvcrf9Z+uj5ey1aptpSQ3PlvEIVywBTzSTieWixKRiLqOXaT8TDy5fMC1QPbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

On busy system with big number (few thousands) of HW offloaded flows, it
is possible to hit the situation, where some of the conntack flows are
stuck in conntrack table (as offloaded) and cannot be removed by user.

This behaviour happens if user has configured conntack using tc sub-system,
offloaded those flows for HW and then deleted tc configuration from Linux
system by deleting the tc qdiscs.

When qdiscs are removed, the nf_flow_table_free() is called to do the
cleanup of HW offloaded flows in conntrack table.

...
process_one_work
  tcf_ct_flow_table_cleanup_work()
    nf_flow_table_free()

The nf_flow_table_free() does the following things:

  1. cancels gc workqueue
  2. marks all flows as teardown
  3. executes nf_flow_offload_gc_step() once for each flow to
     trigger correct teardown flow procedure (e.g., allocate
     work to delete the HW flow and marks the flow as "dying").
  4. waits for all scheduled flow offload works to be finished.
  5. executes nf_flow_offload_gc_step() once for each flow to
     trigger the deleting of flows.

Root cause:

In step 3, nf_flow_offload_gc_step() expects to move flow to "dying"
state by using nf_flow_offload_del() and deletes the flow in next
nf_flow_offload_gc_step() iteration. But, if flow is in "pending" state
for some reason (e.g., reading HW stats), it will not be moved to
"dying" state as expected by nf_flow_offload_gc_step() and will not
be marked as "dead" for delition.

In step 5, nf_flow_offload_gc_step() assumes that all flows marked
as "dead" and will be deleted by this call, but this is not true since
the state was not set diring previous nf_flow_offload_gc_step()
call.

It issue causes some of the flows to get stuck in connection tracking
system or not release properly.

To fix this problem, add nf_flow_table_offload_flush() call between 2 & 3
step, to make sure no other flow offload works will be in "pending" state
during step 3.

Fixes: 0f34f30a1be8 ("netfilter: flowtable: Fix missing flush hardware on table free")

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

V1->V2:
    * fix typo in the subject 'stack -> stuck'
    * improve comment in the code
    * add fixes tag

 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1e50908b1b7e..57634bdf90d8 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -638,6 +638,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
+	/* wait for all 'pending' flows to be finished */
+	nf_flow_table_offload_flush(flow_table);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-- 
2.7.4

