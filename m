Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C057597F31
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbiHRH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbiHRH2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:28:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB0FAEDA0;
        Thu, 18 Aug 2022 00:28:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b++Y2DqlGJ0cfV6sQZjr29sOMd3z4r28kOfB+G/7/2HMsB4SgdAVub/wgfr9RPQ9jkyQzlk34DtfQHdOHk0UPaZ3+jpvA06hO00HBvNYdUuskHTQfjUvelPN4BYwnVxQoafR5U9STlWwoiht+9BNTJc3dSUSSHyMotJmkd9fmxoC9TDeN4yrgvkkLzcdnO/ibAt2p5n5Y2oZjD8YiXmgDB0hSPhfejOPYW0wciED+6/GMx7kI6jE7U4zpDSw0W7Owc9hm1Xrgo5bXSDXxupxHV9usUbFmUJOhoprKad6mmo5DEqD+cWz0Jl3PjENoQitt1vY+3AQI1V3L4ydC6q3dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0rmwsjmORkhItedNxlJxkeNV42MeXFQHuPEcCCupSk=;
 b=L5LCBKdu65HnTAMje4yxk0L2QkO6UCP4z3WvRZjgfUnFW2DMxHQZ94RoTwFtWLjPKZ6WtIhvczZT2cnVzUWBybTBbfrkmTOfw9p6BeXIwH93Dyp+9KOJe3PYbGc2CSq/WFOV26SYG/uyrI249g6W2VAV+KObKS1xMmIHeeCBxsyUIIe5mH+JfMFa3qIvasmt6xsJx/Vqb0IOAo6RpJeJXiIJt7rdR17heKgreN1olK5AM3BtOcwRCzyMmMpOe2kA4WyxcGDkuROgsY0l6Y0QNhqg9gjcZGU6Lnp4jPM0uM6ByXYgDSCqe7N//P/tiv3X/oNWhF9wafdFvsQa7lQAhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0rmwsjmORkhItedNxlJxkeNV42MeXFQHuPEcCCupSk=;
 b=M+JPZ4JmHYPHoLROB8aHvT2hDF+85Pq1t0wWG9gb7mEy1UkA6gJ6PaXR9JmNw2KpEHCujx6flTk0sGHJq9RrUWP7NwreynzV7rwPA1kdEFPISepAstAiMDcbDis4aJh+fFEBxpawsfH93RhR9QrI9+HiV3Gd2U3U8kF83/PdT7gwT2yNJlXjCI1jn6tt9Ih2iM09Za0b23bvaqv+cKTOPc2YquzEjpEHTrkzV0jsQACIfoxK58haktPrawq0njkbB/pt0HfenxO45RAfycXTI8z19hiKS2/HM+5fr9JqDZzRXjXSMRTy+pxenRxozAJLr1/0Y/BzfWzOUcmLa/a9Vg==
Received: from MW4PR03CA0134.namprd03.prod.outlook.com (2603:10b6:303:8c::19)
 by MN2PR12MB3647.namprd12.prod.outlook.com (2603:10b6:208:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 07:28:02 +0000
Received: from CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::ef) by MW4PR03CA0134.outlook.office365.com
 (2603:10b6:303:8c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.19 via Frontend
 Transport; Thu, 18 Aug 2022 07:28:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT069.mail.protection.outlook.com (10.13.174.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Thu, 18 Aug 2022 07:28:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 18 Aug
 2022 07:28:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 18 Aug
 2022 00:27:59 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Thu, 18 Aug 2022 00:27:57 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 1/1] netfilter: flowtable: Fix use after free after freeing flow table
Date:   Thu, 18 Aug 2022 10:27:54 +0300
Message-ID: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90ed2250-a28b-4504-1f65-08da80eb2e7c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3647:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVfz+/iwzCri36Vk4s8JJ5vnnVoOFivoaMH//UyQsd8nMmrAIN2Qv7GrpzMrgTDyalQalY0hzJMgI4QGZvLL/i3h18yYHht/ei0FmdCR9LPp/1wRRq/vt8JnR3JQLfjpSjW6DtkA9tkgdPxr6COXK0zHziq7+CrPu5LLulHWoGPZPTwRbKWFh5fBLpQacAF06jBwntT8YCFOBJo3zzlj0ygewiTVsF+XNj8aL9T9MhpArX6Bt2UrXI9GjrIWFqspu0L5y4bw/AjiQ9WVhFROHj1pKf+lDvrdcA/H/8Mmc1DoMLsmSBHRW630zQAVVjpcLCtul93wS7BeaAHxbhe6cInprRh77GVNfXsakE0+kQMJP4CYI7S7omaWFzhlDkUL2XEcW0wD8LPFvhcdnAVXlrDZj3MmFO1QlG9zVD3fBVne8NOisVDabH5ONqnOQFO1nv160kRL29UCa2Lxpp0wVzGzHIMsnyfCDXleD/h/+1EhBmf1iQ2HjWJZIGlExCJCocVlVn0KnAf9voUQlCorQhRBLAOPyQKuXl7ZFFpmM/8NTGfcEOhDNcLTvSQGLEnYmH8r7GLIOM/GjxlGwxKADdcgZw57ac8DfbJzqMgLHIa7v+koV4+TDCNh/gby2VsOyAwHk4vvpPOHjRV2pRR1JULuRguxcSDTTXfpUWPQg97P7P3a09UIi0jnO6xNrfdkWzbMUi5tPV3SXQJG7Alv28FKye4mxEMaZB3iIFBoHsftkNkzI7MlfKI3M3bllWBGO5w15Xo/QsFsnD2HRspwICyi7qJ3bX4rhuA3rxB5biQ8I12TV7BGmDFW508wQa/z
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(40470700004)(46966006)(2906002)(41300700001)(8936002)(5660300002)(40460700003)(82310400005)(81166007)(26005)(356005)(40480700001)(86362001)(426003)(186003)(336012)(6666004)(36860700001)(83380400001)(478600001)(2616005)(82740400003)(6636002)(4326008)(8676002)(47076005)(70206006)(36756003)(316002)(70586007)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 07:28:01.0809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ed2250-a28b-4504-1f65-08da80eb2e7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3647
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To clear the flow table on flow table free, the following sequence
normally happens in order:
  1) gc_step work is stopped to disable any further stats/del requests.
  2) All flow table entries are set to teardown state.
  3) Run gc_step which will queue HW del work for each flow table entry.
  4) Waiting for the above del work to finish (flush).
  5) Run gc_step again, deleting all entries from the flow table.
  6) Flow table is freed.

But if a flow table entry already has pending HW stats or HW add work
step 3 will not queue HW del work (it will be skipped), step 4 will wait
for the pending add/stats to finish, and step 5 will queue HW del work
which might execute after freeing of the flow table.

To fix the above, add another flush (before step 2 above) to wait for
any pending add/stats work to finish, so next steps will work as expected
(schedule HW del, wait for it, then delete the flow from the flow table).

Stack trace:
[47773.882335] BUG: KASAN: use-after-free in down_read+0x99/0x460
[47773.883634] Write of size 8 at addr ffff888103b45aa8 by task kworker/u20:6/543704
[47773.885634] CPU: 3 PID: 543704 Comm: kworker/u20:6 Not tainted 5.12.0-rc7+ #2
[47773.886745] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
[47773.888438] Workqueue: nf_ft_offload_del flow_offload_work_handler [nf_flow_table]
[47773.889727] Call Trace:
[47773.890214]  dump_stack+0xbb/0x107
[47773.890818]  print_address_description.constprop.0+0x18/0x140
[47773.892990]  kasan_report.cold+0x7c/0xd8
[47773.894459]  kasan_check_range+0x145/0x1a0
[47773.895174]  down_read+0x99/0x460
[47773.899706]  nf_flow_offload_tuple+0x24f/0x3c0 [nf_flow_table]
[47773.907137]  flow_offload_work_handler+0x72d/0xbe0 [nf_flow_table]
[47773.913372]  process_one_work+0x8ac/0x14e0
[47773.921325]
[47773.921325] Allocated by task 592159:
[47773.922031]  kasan_save_stack+0x1b/0x40
[47773.922730]  __kasan_kmalloc+0x7a/0x90
[47773.923411]  tcf_ct_flow_table_get+0x3cb/0x1230 [act_ct]
[47773.924363]  tcf_ct_init+0x71c/0x1156 [act_ct]
[47773.925207]  tcf_action_init_1+0x45b/0x700
[47773.925987]  tcf_action_init+0x453/0x6b0
[47773.926692]  tcf_exts_validate+0x3d0/0x600
[47773.927419]  fl_change+0x757/0x4a51 [cls_flower]
[47773.928227]  tc_new_tfilter+0x89a/0x2070
[47773.936652]
[47773.936652] Freed by task 543704:
[47773.937303]  kasan_save_stack+0x1b/0x40
[47773.938039]  kasan_set_track+0x1c/0x30
[47773.938731]  kasan_set_free_info+0x20/0x30
[47773.939467]  __kasan_slab_free+0xe7/0x120
[47773.940194]  slab_free_freelist_hook+0x86/0x190
[47773.941038]  kfree+0xce/0x3a0
[47773.941644]  tcf_ct_flow_table_cleanup_work+0x1b/0x30 [act_ct]
[47773.942656]  process_one_work+0x8ac/0x14e0

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/netfilter/nf_flow_table_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f2def06d1070..19fd3b5f8a1b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -605,6 +605,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
+	nf_flow_table_offload_flush(flow_table);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	nf_flow_table_offload_flush(flow_table);
-- 
2.30.1

