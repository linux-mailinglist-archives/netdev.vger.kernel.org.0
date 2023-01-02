Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9AC65AD8C
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 07:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjABG4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 01:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjABG4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 01:56:30 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C3C1087
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 22:56:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRg27ORqfgel5tesQaDZu4LVls0bszIbmYp0j99kOdzgakH88kplr9TB8SCRZbHWQ3mwpQuNZZZcg4bLd3UQAFRaYWAdjZxXkh4MkZlI84YANs3B1Jgtkga0A8tjA/3OJz19fJ8/NL1kirTGpLtYxwSN25lVqoRycb+dNwDOudAAGRje7MbiCNdt4MReuxju2yfcsxqH8RzsEmuFp30MD2lsOwO4JFvfIIoa4fHhv0D1EXlmh0pAZiES4OWqfqP9DNtmua3E8XfnO+TiMq1sCVfOtfOxgjcl9Kdcldhzde7emyw6h9+9QS8TUlysir0BADKGJ7tMxNSYSBKBtEPPAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs8AV4X7fU+etaET6Ug8S+JZRssqEmpmJ2iX2BBrOIE=;
 b=ROuxwtNwROJvPTXmC8rhJ7W3nLMgm0Tobg4TtOdRdlmlr5qKbKTuUn/NK2R7e6pTtxrlmbIxgZLx5zC4GHIU6fTcCCT8qbMzOeujJGuyuJ2+Uh0UVvX7lHJWaxB8gN+Qwxcdo7jkHi7E33S5gTvEDBclOfPs4N/xXUrja33n4khJVqj0f12XfHGRk5GYHG2Iz3BRieSeNhP+p1Aq4MJxcxxgn2RyflMakGh9RFCDJCBXuEktoosmGCedpFktV+m5Xq6UjdkHHCOlVW/DR7HuT5euJWsovrYVqPrB26LwmnwnRzlHmPP2GFMeZWPK5/GbQm1nzBjt6Mn+LaKspU5gKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs8AV4X7fU+etaET6Ug8S+JZRssqEmpmJ2iX2BBrOIE=;
 b=ZynNcpcb7tcQ+qm77ydyJara8+BRoEQbxD7z8n5fypexcyoTG/TDmBS7vlXosrShdYw9LB0TGzVTC3xsbt467vvdcQHX9RVagtBovVfEuOT1K33cPxp6hqYwKajURVSWx2ejM9ZAcWkQ9325NafOW9Q1Hr0oBgce0LFoxnoXV6ak40pKChj3SZMTg+rWaorwKplE5lNSq/5Jbx5lLWOzVbK4PwMm6DmICuvD0EM/3rxAnUuzjC3cI1kkEA0uFapCkqZgD1dqblU8K2ydw86HHwQJQGgdNg+Fi2KHBgbCDvJdPEb3sCPkQ34KD5NDQrkN2iwYKO5b1ZB6b1xWHiZIMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6278.namprd12.prod.outlook.com (2603:10b6:8:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 06:56:26 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5944.019; Mon, 2 Jan 2023
 06:56:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] vxlan: Fix memory leaks in error path
Date:   Mon,  2 Jan 2023 08:55:56 +0200
Message-Id: <20230102065556.3886530-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB6278:EE_
X-MS-Office365-Filtering-Correlation-Id: c1ee6a56-2f1f-400f-b2dd-08daec8e7725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iaaThLPIDwoXhI9gOmhMKDsmFfbE+17dd3vTH+BmbILsxJgnqgV0VVDY2/1R5a07d/nO0/vrSV7HYeGfhNRDrh8dN/id+eU8FuLGZFlhnI0mqE1wE/Myeea0LlVFT85eEOriRHHy69x7mDpFWcs2m4DQB0pyKQTP2NHBOCxspaAhM+Cyc8j50vH6rJEiK6Sd+N8J1dV0U0R+9zbn+aUkUhkaz1XAE77LR5lBE49krSL89EeNWnFXVo067dv5exj30W1WuAXkOaPLJRSC5xf9Ba/NSV75oRunD+ogBq++eHt524xhgn9Os7HtRcla2NDOc7zVtc3nIUMCMF4RMeA/ApCSXdHkYqciXaG1kS8EyeRo/4mz1G3UIRdf12mpc1+TbO1FH7jot/q7/+kx7TjWHq3TBrMJ6X9VbIHKVE+uqWay0cmAuChVM/O2OfV1yK0aP68wf6XePyf0P3J7LoYmoSpyTydAcirBzGdBfp29UfXg5MSuFOsrIV2KycWYctDjb8A3f1B166TE4r0G2VRUvfmQwm4qZuqovn9/cgHp48Cv/rzpccFKsQV4rtMsT5U1n5zoGN5BjUFRR+v2652QjQGEQWFkuyQU22UTI07uYODPNrItnb6/yijKkF+aQ14X0TBqytjCZx5AQTiDuj1P0WL6RT1Y1V2xG88JcbIaRrhjJdQ3wUmIRdyVO0+UTyes1Qikgaqupa4Qju8CaLgKCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(83380400001)(26005)(186003)(6512007)(2616005)(6666004)(6506007)(107886003)(1076003)(86362001)(36756003)(38100700002)(4326008)(41300700001)(8676002)(2906002)(5660300002)(8936002)(6486002)(66556008)(478600001)(66946007)(66476007)(316002)(6916009)(22166006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kRO8W7K7cYUpggHILCvhj5Y1YuSr0Z6E1w0fG6YNaC6XPL95NtidGaaQqVrF?=
 =?us-ascii?Q?mmOEyCBeHj/6saed6rtpxRnxi7i+SKkiX+/3AwjperuTQDhLOd2JJOrXtzUp?=
 =?us-ascii?Q?SME62OuOozXK55ot88XGRgYQg8aps7mcrxuRSliCyB+k7B7v9xKQjfm4T6ZU?=
 =?us-ascii?Q?UzPd+hf7IVaQYooUfSfD8su7Ih1SGI0oeykWLK28/uEh5lL8gO5J1VlNYuuT?=
 =?us-ascii?Q?GNbPq87DsxXAMvZCqnsVKbWwWywudLpx46j55uahsVfxqALni0o5Zk5jjrgv?=
 =?us-ascii?Q?oRQmoI23kWLxUAKlYO6pHUnBVA8SnGEGTzdMvnBS3veeySf8eSotAoHA99hq?=
 =?us-ascii?Q?f5bBAppIYNi37Y1JnIiM+4avKa2YyCrwgI3BYlDOERp2AOJzxTxJkzRIIJLj?=
 =?us-ascii?Q?MP4xflhJEilZgFI3RBBL8btJsPxit88Ate3zkA7UfMEzrkXu/ly45yYXOi0M?=
 =?us-ascii?Q?x5i655jATmVGU6hcyeVV1EvMixNsXvKMbpyVB0UG12EksCXAaLt2Gvsi0uVL?=
 =?us-ascii?Q?2v6RdZ2WQ8+ewRkK2EhwkyDMdhsd9fY+fSEuw3wsORLhWSKC4iokqzMG72LF?=
 =?us-ascii?Q?XFKHNkQNw+L1AgWdMzHT9YkViBQN9rTX8Nl1lYnRkJlhaQJk47WEQXGgrXeu?=
 =?us-ascii?Q?ZSmbqx6tK7iNNlZOXyPzmB1w4s5NTrpaTfV8e7uvhY7CchVWZ0ilkP9+eBoN?=
 =?us-ascii?Q?6nvtyekQ9xXkI7y9ycxaqXoQF2e+3e5YSKnFf6gNSfsrePbGYw/+Y03Ltofn?=
 =?us-ascii?Q?1KGnjGrhJtTSOvcjV9NcehJGZ/S9/FcOl7RAF6ZQUv1XqB2vBgz5zH0v8euQ?=
 =?us-ascii?Q?zeELRdSljQfUkNX9BdzNPBNVxgUfSt7QfP65rplauVgO338Ss8xfkyspYYI6?=
 =?us-ascii?Q?K/aYIZ2EIwig2a6sv82Jpq5i/z4ETC5Y+9s2ezlNddvsrdYmLowAe/Ypo3Xv?=
 =?us-ascii?Q?tb179oRxs3qnrvxVSEYj5tIzGYfKK3uFRB3UygXRmkfugfMEAkZPp5xkgTi9?=
 =?us-ascii?Q?BZradetxUD5xv0DZpSinW/c9K8snBm9hNZN9YOVRe5QJDRp/7F+ZxxCFunho?=
 =?us-ascii?Q?yPmVTwtO118VEL77UXH546gmv5ZSpBmNeGD5pC6G9k/LA1xi3qZ+BoPhhlRX?=
 =?us-ascii?Q?NRF+ab4KNZCPbAPA5rV2ALqQdWEMAme4dAH/KmIsa6y8CeNS4y35sZP/Wo4f?=
 =?us-ascii?Q?Imb5iJITtU6WSJti19QfmFuaQp+rMRKh6ZZLcyBNkweGeOOyLflm4todYO7n?=
 =?us-ascii?Q?U7QUe7mmdQL3tZk8SMnLmhpDiT1BsvbFTYnFKCQNDeH3KzARCfT0gAiACNu5?=
 =?us-ascii?Q?+drfGbSm9phoG1g32F4xEpXA2jf75HFt4cbsXgr7lAHZrKrgRFO2HAWKbmTk?=
 =?us-ascii?Q?RsJy+UzWXfxhAaGGHhrvd/ZtnGV6KF6lfSkmo9SvU5lzlgl+RzDCYId5KtHD?=
 =?us-ascii?Q?U1uNhUHBEkUkuunzQLmOwOGmpsaLKuAcY4oT71qwNezE9qg1hHiwRu13N+q9?=
 =?us-ascii?Q?LcgtDJHkXRW112x3pGY+VFJ72oaGpko8b06XJUEoQRbQp8OEKfo46jor8nZ1?=
 =?us-ascii?Q?lWVSifqyQoEfuDeT1/bdp8sKZSEoMd7Va7jVgvsA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ee6a56-2f1f-400f-b2dd-08daec8e7725
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 06:56:25.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ROSsqJajr5tZIReUtGx+zEZvwaCsVaeZMD5uACT9gYOet/+y/vk3I5imaZ8prOPzqJunOsuT5S/WtL4GZFpgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6278
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory allocated by vxlan_vnigroup_init() is not freed in the error
path, leading to memory leaks [1]. Fix by calling
vxlan_vnigroup_uninit() in the error path.

The leaks can be reproduced by annotating gro_cells_init() with
ALLOW_ERROR_INJECTION() and then running:

 # echo "100" > /sys/kernel/debug/fail_function/probability
 # echo "1" > /sys/kernel/debug/fail_function/times
 # echo "gro_cells_init" > /sys/kernel/debug/fail_function/inject
 # printf %#x -12 > /sys/kernel/debug/fail_function/gro_cells_init/retval
 # ip link add name vxlan0 type vxlan dstport 4789 external vnifilter
 RTNETLINK answers: Cannot allocate memory

[1]
unreferenced object 0xffff88810db84a00 (size 512):
  comm "ip", pid 330, jiffies 4295010045 (age 66.016s)
  hex dump (first 32 bytes):
    f8 d5 76 0e 81 88 ff ff 01 00 00 00 00 00 00 02  ..v.............
    03 00 04 00 48 00 00 00 00 00 00 01 04 00 01 00  ....H...........
  backtrace:
    [<ffffffff81a3097a>] kmalloc_trace+0x2a/0x60
    [<ffffffff82f049fc>] vxlan_vnigroup_init+0x4c/0x160
    [<ffffffff82ecd69e>] vxlan_init+0x1ae/0x280
    [<ffffffff836858ca>] register_netdevice+0x57a/0x16d0
    [<ffffffff82ef67b7>] __vxlan_dev_create+0x7c7/0xa50
    [<ffffffff82ef6ce6>] vxlan_newlink+0xd6/0x130
    [<ffffffff836d02ab>] __rtnl_newlink+0x112b/0x18a0
    [<ffffffff836d0a8c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff836c0ddf>] rtnetlink_rcv_msg+0x43f/0xd40
    [<ffffffff83908ce0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839066af>] netlink_unicast+0x53f/0x810
    [<ffffffff839072d8>] netlink_sendmsg+0x958/0xe70
    [<ffffffff835c319f>] ____sys_sendmsg+0x78f/0xa90
    [<ffffffff835cd6da>] ___sys_sendmsg+0x13a/0x1e0
    [<ffffffff835cd94c>] __sys_sendmsg+0x11c/0x1f0
    [<ffffffff8424da78>] do_syscall_64+0x38/0x80
unreferenced object 0xffff88810e76d5f8 (size 192):
  comm "ip", pid 330, jiffies 4295010045 (age 66.016s)
  hex dump (first 32 bytes):
    04 00 00 00 00 00 00 00 db e1 4f e7 00 00 00 00  ..........O.....
    08 d6 76 0e 81 88 ff ff 08 d6 76 0e 81 88 ff ff  ..v.......v.....
  backtrace:
    [<ffffffff81a3162e>] __kmalloc_node+0x4e/0x90
    [<ffffffff81a0e166>] kvmalloc_node+0xa6/0x1f0
    [<ffffffff8276e1a3>] bucket_table_alloc.isra.0+0x83/0x460
    [<ffffffff8276f18b>] rhashtable_init+0x43b/0x7c0
    [<ffffffff82f04a1c>] vxlan_vnigroup_init+0x6c/0x160
    [<ffffffff82ecd69e>] vxlan_init+0x1ae/0x280
    [<ffffffff836858ca>] register_netdevice+0x57a/0x16d0
    [<ffffffff82ef67b7>] __vxlan_dev_create+0x7c7/0xa50
    [<ffffffff82ef6ce6>] vxlan_newlink+0xd6/0x130
    [<ffffffff836d02ab>] __rtnl_newlink+0x112b/0x18a0
    [<ffffffff836d0a8c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff836c0ddf>] rtnetlink_rcv_msg+0x43f/0xd40
    [<ffffffff83908ce0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839066af>] netlink_unicast+0x53f/0x810
    [<ffffffff839072d8>] netlink_sendmsg+0x958/0xe70
    [<ffffffff835c319f>] ____sys_sendmsg+0x78f/0xa90

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 92224b36787a..b1b179effe2a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2917,16 +2917,23 @@ static int vxlan_init(struct net_device *dev)
 		vxlan_vnigroup_init(vxlan);
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!dev->tstats)
-		return -ENOMEM;
+	if (!dev->tstats) {
+		err = -ENOMEM;
+		goto err_vnigroup_uninit;
+	}
 
 	err = gro_cells_init(&vxlan->gro_cells, dev);
-	if (err) {
-		free_percpu(dev->tstats);
-		return err;
-	}
+	if (err)
+		goto err_free_percpu;
 
 	return 0;
+
+err_free_percpu:
+	free_percpu(dev->tstats);
+err_vnigroup_uninit:
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		vxlan_vnigroup_uninit(vxlan);
+	return err;
 }
 
 static void vxlan_fdb_delete_default(struct vxlan_dev *vxlan, __be32 vni)
-- 
2.37.3

