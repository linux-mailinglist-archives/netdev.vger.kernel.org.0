Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EFC443F72
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhKCJeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:34:50 -0400
Received: from mail-eopbgr60104.outbound.protection.outlook.com ([40.107.6.104]:45186
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231958AbhKCJeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 05:34:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9ZwB644Vr7BviHAqnFw1wXBdWGR/GiNLABANSG182Y001UJ+G7iCoVhluGFFotiiELx6uuHdyQdls5LUwqGEiYllgKvUOwTJnA3pVYmw+3k2AYMdvaLqhCGIbfkfcSwHcmDT67m+WyrvfneswOxD13nfXG7oiW257jkzAsPP5LNPDfHyx6+32/euRQ/uztn9u96bQOK1LzWHboLz5IuI8KfGKAR45cIlFQepDXLqTyZ2vLgi6v8r5I88eYWQkh9ZjuFI3MYhsfIDBr9monlVVS0+vH3PIwzVEwXbWb57mBueoJVKZ1ZHL5dryukB6E++fKCCp5l4NzS3VB70v1wPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIiJQnqS/ggm1at6dZ+0R+8eOTsjL7Jx5G23LYlNBiM=;
 b=W/XRVeogN4gQ8gaOQ8FuMJT5Z+WQbs0F2ZO/SEVQnSbtHyjQq0rTUQ0reRKsXInMbFkAHLmNcW4SMB/jovoAd8dNm2BAUEMFD7JD/QfKTmFdkcxY1TPV/fYqMo/H6bUqPn+kPGblk/w3+NhLp7W+R/GKY3JW0m0RACmPztDkFdRfiwQ6eaqyQq9JY0HOADW5+RQEckOHdCPcxxGITGlroD+aggVNmyk/O6rfwHDq29dbeBfAqqDkyfM7sEnz/TEQsY9eVp3BNKnbI4dx4r9T3K5XVxnVPC1Lp5IMsE5YTHWNHFAAupcCcctwJUpyoDkzlt/ZcFLrrRI/mJusl4nPcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIiJQnqS/ggm1at6dZ+0R+8eOTsjL7Jx5G23LYlNBiM=;
 b=h9bsXqtQs1Y5vhlSNRJbolZUztjGEoBbyLde4nM6gP+WbOzpdc7Is6zXIKf8b+weVbv/RsRTVCfgbLJO8hBTX43gTImESoUQjuRORqHCkg5VKQsPc3zHcdDP31WijByCSFLHY/3FXZnvLUFwwx2p1tPDEDX9MUJAOhML5OMpZ5I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0861.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 09:32:03 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%5]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 09:32:03 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 RESEND] netfilter: fix conntrack flows stuck issue on cleanup.
Date:   Wed,  3 Nov 2021 11:31:36 +0200
Message-Id: <1635931896-27539-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::11) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4669.4 via Frontend Transport; Wed, 3 Nov 2021 09:32:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57b6bc04-efa9-47a8-835f-08d99eaccb40
X-MS-TrafficTypeDiagnostic: VE1P190MB0861:
X-Microsoft-Antispam-PRVS: <VE1P190MB08616E0E978236DDE18A80A28F8C9@VE1P190MB0861.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UffpunvAXbLF4IrADqeuUdc2lh26dJSjhDlXP62iEjd5B5sa8W1xanSoCvnuwNZgo6sEzmbnAUtud+jTpERmkrPIUUhnD2MeENu02x7MLiTUuBYsKM8dzoTX69x3Meb+76MTM32ZQP7B2WEeJA89Ks6jIVzlB6sYrAt0RHc7vjnpwPHzoyWFcnlldmW/D5ENhg0I1WHhasfc63gsT/eenJcfI5QbL//aTHdK10sUrf7XI+mdOFc9O4zGxJFHt5UrL0SskrGDLCsaYp4e2PBYNhEsCCf67gPxJNuVFezaejJER1UuJ7OIqauzb/SK2T4H0o5b4SoaaZr1bL/pAEg6uxrBmJtnhR0y6MD3zXK4hQlhkaD8bq8uBa7EwFeoy/ALxv1+iHe0eskAIwNNFYbREr8sDHEiY/sidv6GIujF1mLSyiAqAyesnqcB/FOypzZgCfU9rVUq6Z0TBUvB/6/RS8XNbZeCzCrPCUJ4kfkgMWHh+mW9Ikjp+Q+MU/jgXZjXADaGTogJ/ZFMWmdOQGfP4IkXxc+D2CfuIBC4+8v/t+bJafqMRvtdRBzzaBBpU2/GcAgYmW1h5fOnp+bRQXBVvn3EtAKrc9omrxPLeSjuDduOJrqIDDN9W3N1/Lmtd+zMZyU/Ldvh8k4evRJU05K7QhXew80FVFZxS8pAy/yTP7vZ4rhWFVRt7Wpa+zG/55wM/00+lxbL7+ERKsdy0Y8m9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(39830400003)(366004)(6512007)(8936002)(38350700002)(38100700002)(508600001)(7416002)(956004)(2616005)(316002)(26005)(4326008)(83380400001)(5660300002)(52116002)(54906003)(8676002)(44832011)(36756003)(66476007)(66556008)(6486002)(6666004)(6506007)(86362001)(66946007)(186003)(2906002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NeqNhA4jb2AuyqQutj1q8xttJDFEyJNOJ+ZcDWIfNFh490S/TWaas26CJ3Hp?=
 =?us-ascii?Q?QA93ZjbUXghU9GONb1bySKV9+HihTQD/X3UffxkwZ06EBxLIwgmDH00kltcn?=
 =?us-ascii?Q?r4HkyZEqxY+Dw3hxbhiy0gFPIXKdBy8rICnWqdFy0LP03qpyzFDsHuydscq3?=
 =?us-ascii?Q?MsiUTf8J1kT6rCLX+i9g93DXyfPCCK6YFRNP8FtXBRXkpzxZwoRV2ODrsBH6?=
 =?us-ascii?Q?j3qmrVUgAKpfOq3IPk/Ck+C2CsB0HoRB1xr9+D0d04w2Oqp1Vn6SxrgbaN5t?=
 =?us-ascii?Q?aGLe/h9C0mj8bfsMulMeF9avC0SQk03PV4EA34IXwToIpl3kE64ijdclKIGF?=
 =?us-ascii?Q?Z/qLr6J93Bm9xkx++A8rFI9pTZJbXZ+LXUhDGLaDQX1f2MdwM0wBQFhK+V//?=
 =?us-ascii?Q?LOfIlBymzpjFXSvR6MgKVallf2gKx93cA2E9ljxXos4b1durQtVGQnrxkQTq?=
 =?us-ascii?Q?0SNbYIiUP0ayrZZKksUqOIB+PHg8Js7X6xZMOKorp3FHUARFaQrbzQRgFEvP?=
 =?us-ascii?Q?GWp959WvyiQIRxkiP0nd7F1i3TW6ijFovZNK1Xd+cZdgGVgII2Ua3AzWmpGf?=
 =?us-ascii?Q?BsmprGYI5n8LO6Haxwy59BgLoC6W3LqCvCqJuuyH+EuPuFCWhmFRWhiHPyDW?=
 =?us-ascii?Q?QsT0AwiUtCCdGpJT/vl4KomrOvI0TXKaVfnO3Bb+DmsYmgrYw2EzRRhs8naE?=
 =?us-ascii?Q?259oBamHDYvX19iAspwfgbAJ8bOhWR8TZdFdVu78O0Lr1wiJzaqwUzX2joDj?=
 =?us-ascii?Q?3HCI00zVSxZcMaevWJOWMprRLJGEnnZ2YPiJXYxrXGaO6p5jtI2HYNNsWarP?=
 =?us-ascii?Q?JH1l4rLEgeSqp0E3hP3sk11p9VaDzy94GlVIHi41BbcFtq/YAnskHJfIgNHK?=
 =?us-ascii?Q?lcHj1L0kaM3S3WCedpZi0E/K9DGmeANChnqlNATnDyKU08EFIYsdE2b3kVak?=
 =?us-ascii?Q?uvU7C5PJhLUJf3++dEWOuFRnEvzCG6zzTMnZeZKMOkVqk1+KKkPLXPT4vjhI?=
 =?us-ascii?Q?nlbFtxjtwMEaVpqYvO9duq/uOKCluo0JVZiN75w0WnbVJoUs4q4k9hoR1wO0?=
 =?us-ascii?Q?79PdNWsByZu0op58fwaLLojQFallr+ZHNSdFvxVOSNNOhV3Id+n/zcj485P4?=
 =?us-ascii?Q?hlfTKyhSkYiNhZVnoKzf2FvebDQ9sJ+XdIUb3Xn/IUcsaz8RiQ1AX5HO2SeC?=
 =?us-ascii?Q?2Qlcm+1GBu3p/ZKaI5txWY0YnOZaBnj/6j6BwLkRCxT04RvzsoLOLHhzhPVl?=
 =?us-ascii?Q?8o0j6xQvM42Y2O4dCC2o6zs0qa39laqk0hgVzPN3hlbBrw3s5a4slJIln0aM?=
 =?us-ascii?Q?JPUlOfroSviL0q9stEdzY6nPSreBQvLIUJkYUJNnfp1R1XygDFziqHn/zbN8?=
 =?us-ascii?Q?hGE3sIdFKz9DJvOleZhjknPYpHrdtf7gQ+I/gDiT5EBHwgphpz66rhkMYoWk?=
 =?us-ascii?Q?J30gnDq9YS32vhZacSbZLOZKoxPaSuR3KYd7R32TPtnhCFBmjKCqCN0dwtNv?=
 =?us-ascii?Q?uWJERerAZPjxfSYgVt/qfEXTu1z3ejfIYQqSWmtX75dYu9z9M1lobWtEkXP8?=
 =?us-ascii?Q?v0wWOQIaKBGDTKA5hoIagCyasTZcVOrF5vFwKHqcyy9/qE1DTPGI91HcZyL9?=
 =?us-ascii?Q?QJMowS090X8H8OZ3rQK29XrwojC5GE7cZE8Ltz8IlnynEW6Cv+ZpEF981fnf?=
 =?us-ascii?Q?G1A6vg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b6bc04-efa9-47a8-835f-08d99eaccb40
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 09:32:03.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ktmor4PNXceS5aOwfnC4Zx5fQL1/ARVGexNa6IgUA8CGzxEqIYFDUjBiwyFUAu9NcZhjbu9TH+37NP5PBgUkEeWHNqf9kHJ9TEDORGulRRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0861
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
 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 87a7388b6c89..17593f49413b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -637,6 +637,8 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
+	/* wait for all 'pending' flows to be finished */
+	nf_flow_table_offload_flush(flow_table);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-- 
2.7.4

