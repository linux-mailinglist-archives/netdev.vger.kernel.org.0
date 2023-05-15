Return-Path: <netdev+bounces-2714-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7057032F0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A134D2813E3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB01EC8E3;
	Mon, 15 May 2023 16:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E67FBF6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:30:25 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0627186
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHo8sFjAV0PWpfMZ9ODKeT6Gv11xhzvfbJoA+I7kkyVfPqa0nFZ16QyRaGqnJCwzfky+QFrzrVfdP7bsP3PnvppOE8QriRd9JqXGtOCDNH/4YxQHoyUVCB4JAOe2d1DH/kIiJbbi1okUcJiKqKXmW0dqd6ORwq8QkbplCWhBXoEJEhRVtnpyBgadDf8CxRD3fgk5GjR8iM4w4ya/reD6sygAIvpe0lzpo5tTfNqnGwTBW/+3MMQQGFlEj+01t2kGpz/2s2+JHOvXYIiKN3O8ZirlCCTM8Bcg9ngKX5VcqpCzRPa/DyX6NX2aXIReUcMvL7xEp4szfFUaNlhN3Wa1NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIIXN/uO0jiIR7LkbfRT6JHVfViG60dyErNAeBfiD3U=;
 b=Nrrc5gdV9GazNR3xQSW64nPUFfQnctyw66PyOFhqJo2iwUazufT53diLLg/+0HrvrLMjHfY7fEVoVwO3e46O1xsDhfU0bpbv3cCAEaCfU1gobUD/OzlM3nFQNBODZyVwhg0JVom3gALWyKKOjlVg2cQmUwulMSBbDVV0P+AIwnImXMh6uuQhgHfsmUwfb0LyVMP4g9pBdU+0yObUKWczqv/C7GF28KfkYwuCswlD3M8DmqPfkmSfv1avUWZqpD+I+UTBh3TY5tYCQAYX99rfxcN90ghlBdgehmRPvtzB6hOTQ7r9VzTRTLZvKOwkPg84eqM7T0hzfMd+z83pHbCF7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIIXN/uO0jiIR7LkbfRT6JHVfViG60dyErNAeBfiD3U=;
 b=RWBe+iPmTPgKgskgBNpc9lAmjq7WQnOhEjuFTYtwrxOfAdnypKVdWeIk4ERyHXPGAom8AvDKT51RT0QAgQqk8jh/bwjM0p7GzuBgi3ZjLKrfz3FWpuMAu3hlwnhIHZN9gcDMJWt0Q/aqmavCF8X7lxt04OMKjt3VeLB/0T6/yBUj5+tTqA+tV4XzCYERG06Yjk0gDibRiUFMpw/Cj54feSZN+WMEVrxkBfYVt0QmUmAEUAjuTfHhp2Wjr1AkTiaAWmCYrwJJpgKFq0uemvVyD13QnJLcPBby8OFlPV1l/ChAVMiRQq+F2Hq9b66Cdbuv9UQjOJ/wj/AYrJ07Bdl0Xw==
Received: from DM6PR01CA0028.prod.exchangelabs.com (2603:10b6:5:296::33) by
 SA0PR12MB4541.namprd12.prod.outlook.com (2603:10b6:806:9e::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Mon, 15 May 2023 16:30:22 +0000
Received: from DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::73) by DM6PR01CA0028.outlook.office365.com
 (2603:10b6:5:296::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Mon, 15 May 2023 16:30:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT114.mail.protection.outlook.com (10.13.172.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.14 via Frontend Transport; Mon, 15 May 2023 16:30:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 15 May 2023
 09:30:10 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 15 May 2023 09:30:07 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <jiri@resnulli.us>, <simon.horman@corigine.com>,
	<m.szyprowski@samsung.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] devlink: Fix crash with CONFIG_NET_NS=n
Date: Mon, 15 May 2023 19:29:25 +0300
Message-ID: <20230515162925.1144416-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT114:EE_|SA0PR12MB4541:EE_
X-MS-Office365-Filtering-Correlation-Id: 779d7cb7-39c8-4f39-1738-08db5561addf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aH6SyrT9syxYUYLTiOdBwV2moa2LMSv4zCD7rufpPVlczp1eOVRiFdIeuyBuRuBSMEEUnBC2NaooBCqv/CkcxCY9uBl92XGJ72UK9F8VM3166QJN+nvVT7MQbazuDhdFMTz7Ei7LRVSQkzu02pc/tWESYh4rroCegKqoD79X3kyDFkifY39e+NSGZ5xknUigObKiB+TmaWX1kfVgZgViQJlwL/9jOvhdt5rmEvK9dKgIiWf10AnCkBIU3nQprKAGQMMGtPs5LOwWqxt90vvJ2LOKNL0/X70oHtolHPkOGgwAQ8dZEoh+00sYvhSppc+C5GKD5si2CLnQxd8vIFfYGh7XuF6MHxBKqSsi+Bs9RugXVy/26CexqxpgMneBES6VBRLCLfNV4N8/8owFuoUMPR3WkvtKEgj+0Ji3x1lDSNiWEs4IFfJT1Kqxl0jMTUNPd5harnP8vHnE19USKPI3J+U850mhQMCRB276pFUwgoqSq5JGO5tFuykThdiGezOUZse4vyGmST390ssAkmL3OMaW5+6aCYEUUAUqja5va311EVh7GSvWHa9GHRoT1igmsRQ8ITczQYgcC3bvNYLrHz+8kDLDQJ5/m6+XYflYOsfWlntPNQoIp0pJ7P6BZRqRcNAwzTVhrIKl/y4ivEaOIVhmOgz+guUFD/cp+tfVAHctkvGTn8JVOwSfXfG1qumR51TrhC3tuB+cq6nAnyS9UVTUw1vaI3gjRX5rfq1/8Qv5cZ9g16Lu3H/uPP15Cn0opR3UMFNjLAwAD0rwM2aLKoeWeV9hpojoos8goApOxcA=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199021)(36840700001)(46966006)(40470700004)(83380400001)(1076003)(26005)(2906002)(47076005)(36756003)(186003)(82310400005)(2616005)(16526019)(40460700003)(107886003)(966005)(426003)(86362001)(336012)(36860700001)(5660300002)(8936002)(8676002)(6666004)(6916009)(82740400003)(356005)(4326008)(70586007)(478600001)(41300700001)(40480700001)(7636003)(54906003)(70206006)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 16:30:21.8762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 779d7cb7-39c8-4f39-1738-08db5561addf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4541
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

'__net_initdata' becomes a no-op with CONFIG_NET_NS=y, but when this
option is disabled it becomes '__initdata', which means the data can be
freed after the initialization phase. This annotation is obviously
incorrect for the devlink net device notifier block which is still
registered after the initialization phase [1].

Fix this crash by removing the '__net_initdata' annotation.

[1]
general protection fault, probably for non-canonical address 0xcccccccccccccccc: 0000 [#1] PREEMPT SMP
CPU: 3 PID: 117 Comm: (udev-worker) Not tainted 6.4.0-rc1-custom-gdf0acdc59b09 #64
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
RIP: 0010:notifier_call_chain+0x58/0xc0
[...]
Call Trace:
 <TASK>
 dev_set_mac_address+0x85/0x120
 dev_set_mac_address_user+0x30/0x50
 do_setlink+0x219/0x1270
 rtnl_setlink+0xf7/0x1a0
 rtnetlink_rcv_msg+0x142/0x390
 netlink_rcv_skb+0x58/0x100
 netlink_unicast+0x188/0x270
 netlink_sendmsg+0x214/0x470
 __sys_sendto+0x12f/0x1a0
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x38/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: e93c9378e33f ("devlink: change per-devlink netdev notifier to static one")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/netdev/600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/devlink/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 0e58eee44bdb..c23ebabadc52 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -294,7 +294,7 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
 	.pre_exit = devlink_pernet_pre_exit,
 };
 
-static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
+static struct notifier_block devlink_port_netdevice_nb = {
 	.notifier_call = devlink_port_netdevice_event,
 };
 
-- 
2.40.1


