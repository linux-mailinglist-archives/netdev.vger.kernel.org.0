Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161E55957ED
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiHPKTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiHPKSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:18:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87465F61
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:23:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAHU3Q/FfDF3Xvi8zhAyAgzH7sN6aYJBdTUhVlrsRlYO2aqke+k5pJfmviqIbQrEb3xOSAkcpqf02ffNYRpf5c7nybM/Fq5FI/lY4tQwjOOpVd+etZqvQtgydBeFNSvAm82wjlijCSHGCdbqldk95cRvwCm3CTegmWGsdnFB6XFmkPZG1b58E823yrRcpAEEsB99JpDvpYoYwixzp0/013HFDOlbV/kTr689AayrwQoFslDUSnTMm7uawGXodw2dwdqFMfkbDxgf+RahKCswXNJJQ+3uff461VgAZy7qfO5wu03p2ZjGPtBBhtFRZWFs3HVadxi7ZNd9eCYhQN9f+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmcaIrpwM+CJrSVbz0Co1UjTAZaAwnJBWPMQOLxDtqM=;
 b=VM9/Ih1mxpT0IdCBvDRCgk359ra/ZHoJ2lyCD0mcbuCg28K8WXgQLjGIiof/BbQXJV6REvpkd5iuvg7nvKyrYPKsgQ3ld/Sq54a4PWC+TK+eib9ZrmpXTJOOHK771V1906ftDRsB120rhhsMLDOzZreVlNJVwxHuoSpFIsNhJGChu2XzJZsTV4cjJLQKUR0SQOVf5yV9ypsMMfqagAh7uqDcRKg05nE3ktdv1sNYlEUPdSqeqFWBF4C61uuxUjCH7C0zQoBK5cZLf85h1I3cyWCkN0TkRCAyiZQT8K4clCqheDvFSAS9qSFRjiBV+h9nht0/kADDiMjuzyvPbFKclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmcaIrpwM+CJrSVbz0Co1UjTAZaAwnJBWPMQOLxDtqM=;
 b=VJvYSdjafdk+U7lLq+nYfYjL42Q7PHGPMoI85XnikXwUyeGpITD2eaZuTBG85VHazM1SKvXiCEpBKM6Wm/ohu8rapmbL1L6K+YWNsuMBH6LnRf1bko3urdTUuqczgJNSyFAzqjDw3PgZGig3u4LywL1DYIfnINxf5joRk5FGY1CGh9qXvHWQqOCnvUmEUoYJDB6R6wpewRvNxYd4rlgv+Npbwmwz6VvTw9rB9QcwmYawwm4dNJ3jwhsnHyfnVs+fUkJ71kuWr4dAv+7WEjnE03GzJpXvQmbwdEDBbOzup6Zc65bYMS9mtYP9FPAiyn4VeIrExzMAOBZVyRKLN6Gbwg==
Received: from BN8PR04CA0034.namprd04.prod.outlook.com (2603:10b6:408:70::47)
 by BY5PR12MB4308.namprd12.prod.outlook.com (2603:10b6:a03:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 16 Aug
 2022 09:23:45 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::bd) by BN8PR04CA0034.outlook.office365.com
 (2603:10b6:408:70::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Tue, 16 Aug 2022 09:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Tue, 16 Aug 2022 09:23:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 16 Aug
 2022 09:23:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 02:23:43 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Tue, 16 Aug 2022 02:23:40 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next 0/3] net: flow_offload: add support for per action hw stats
Date:   Tue, 16 Aug 2022 12:23:35 +0300
Message-ID: <20220816092338.12613-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 758d61d9-0253-4306-2cde-08da7f690464
X-MS-TrafficTypeDiagnostic: BY5PR12MB4308:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3N7vtwXM7WPyJkJ+Fm+TjosQsTXUmcOnCULcq+1LfgnzvDEJoJ6gkYY+Js0tsspmGvY/60OiRb+NuHXXjLNBZki7Ub0ySccAsbNVqD/YnFhKAiNM1674qhLO2SP6SOFtcSxAHJQAvUjzf3EQ5epxDpVFLT9kr+3ZVM7bZA6bzKFFr2LSDLhDGR5PO2bk/s5mc9G03X741MGQUH7Rgyf2cEN59Y5ZIhARHWYsuMAMpXpXqDOxfN/KRN7b9WGzpmR8QDbbDzcRRS1Y4menWo+avuJMJhCVSPrr7/1H7/rxJ9UVjGvFu0rT06JdevSGAJqv3bGsjnUeaW9lm7pyXsv8k1Bq6i0AzpHsYUY0sfOUztvpTVHnjzDm0NqahY3yWNCeJAPGS3Orrm6kP2hbTljXa2KqlFclodJ3bQJi3zgf6XW51CiQaDwtH+JsYrxkQLjiDIgbeh7cnJUdQqcM9h5S0FKjkNURBIPRGSTqalOzqhIefvVD5tMB4ct4CSF6PKLbopRq/o7ijw33s0y9SkZ4Z+mCFbOusLVeBoJmrKvP+BM0wBjXA9CKnlvKBmIvC+aSvm+FH73wutGZuRbyAex4qbuh/lHMMleIVk3LglXelq4m9OdZHh8VEG+GYBabOjmDQ8/YnD+e7r2HtOv6ZencYAqSY7YYmp51upNk2dkuWXXNX9J7IAQ+OXL6u2DuS55pa8KVnSVMxI6WbW4jJfwoaucLhtiv3Cbhne2XJuQFUA3U3fB3fmxns8XK3kwkDqRxTSMZaKIKclHRKOQPVal676FwhgAHkvlbw7AWwE9kWbVEy+I0jpB3WkwPROamvKuaZC5yw6lNE4yF5YQdsGAJsg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(40470700004)(36840700001)(46966006)(26005)(82310400005)(6666004)(86362001)(40480700001)(40460700003)(81166007)(356005)(478600001)(41300700001)(36860700001)(426003)(82740400003)(47076005)(70206006)(1076003)(336012)(107886003)(186003)(83380400001)(316002)(8936002)(5660300002)(4326008)(8676002)(2906002)(36756003)(6916009)(70586007)(2616005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 09:23:44.6595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 758d61d9-0253-4306-2cde-08da7f690464
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two mechanisms for populating hardware stats:
1. Using flow_offload api to query the flow's statistics.
   The api assumes that the same stats values apply to all
   the flow's actions.
   This assumption breaks when action drops or jumps over following
   actions.
2. Using hw_action api to query specific action stats via a driver
   callback method. This api assures the correct action stats for
   the offloaded action, however, it does not apply to the rest of the
   actions in the flow's actions array, as elaborated below.

The current hw_action api does not apply to the following use cases:
1. Actions that are implicitly created by filters (aka bind actions).
   In the following example only one counter will apply to the rule:
   tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action police rate 1mbit burst 100k conform-exceed drop/pipe \
        action mirred egress redirect dev $DEV2
  
2. Action preceding a hw action.
   In the following example the same flow stats will apply to the sample and
   mirred actions:
    tc action add police rate 1mbit burst 100k conform-exceed drop / pipe
    tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action sample rate 1 group 10 trunc 60 pipe \
        action police index 1 \
        action mirred egress redirect dev $DEV2
        
3. Meter action using jump control.
   In the following example the same flow stats will apply to both
   mirred actions:
    tc action add police rate 1mbit burst 100k conform-exceed jump 2 / pipe
    tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action police index 1 \
        action mirred egress redirect dev $DEV2
        action mirred egress redirect dev $DEV3

This series provides the platform to query per action stats for in_hw flows.

The first patch is a preparation patch

The second patch extends the flow_offload api to return stats array corresponding
to the flow's actions list.
The api populates all the actions' stats in a single callback invocation.
It also allows drivers to avoid per-action lookups by maintain pre-processed
array of the flow's action counters.

The third patch refreshes the hardware action stats from the userspace tc action utility.
It uses the existing hardware action api to query stats per action.
The api has lower performance, compared to the filter refresh stats, as it requires
a driver callback invocation per action, while requiring the driver to lookup the stats
for a specific action id.

Note that this series does not change the existing functionality, thus preserving
the current stats per flow design.

Mellanox driver implementation of the proposed api will follow the rfc discussion.

Oz Shlomo (2):
  net: flow_offload: add action stats api
  net/sched: act_api: update hw stats for tc action list

Roi Dayan (1):
  net: sched: Pass flow_stats instead of multiple stats args

 include/net/flow_offload.h |  6 ++++++
 include/net/pkt_cls.h      | 27 ++++++++++++++++-----------
 net/sched/act_api.c        | 15 +++++++++++----
 net/sched/cls_flower.c     |  9 +++------
 net/sched/cls_matchall.c   |  6 +-----
 5 files changed, 37 insertions(+), 26 deletions(-)

-- 
1.8.3.1

