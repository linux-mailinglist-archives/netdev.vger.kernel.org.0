Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E95A21BF6C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGJV4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:56:46 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbgGJV4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:56:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+/i1+sWpw3kRdC1rOQJZaRP4DGAzEl1JjV2YVRxtD2/mM1mXiDs4qvlm1x/LWFP0D+001iLzn1jU90Zn3sLL488P4W8LbhUUmcijSDp+MnnhHQqYcHkcuqUxSyrpiuqX2T7ynYbwgsEzm3J158xGUmdGx1noyQg6YZg1qhMQM2HRhXRb+8InDdmDUIWVtA2LIB3xwLgsbQ+5m4DrOaVoaDQ6yKifz4NJkxzYNETzy9eVqmYb8A5X3pCcc89qICxe0X+iBv1M+c8SzXtVttRRMgQjTNSz6ogzwNR3XB0RtKc/kCDgKcQRZiY0SV3Rq6txsefpwZzsqIigHqYDE2O9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/ZaM5DJr2ulrL3xybKgMs8xQtxGT5IHvHD5kdWesxc=;
 b=DVWh412SKzwc4S9lJltEh9Kb1991bJv6mv7lcAueUW4y1ziU9NBjdU17N677bM+Ag4o2dE6zX5ZM4KU1vrzXATx+qIixD3PNw7NOLK6YhLCXrMta/SWYZd2EblwcnVzt5qZ4wEpr5WscQKR3TCOXbAKILBVIEClg9UhEIV0uWpqJ75h3gz6oKL/81XMME3nIx2qG9Ueqm1ASx2JkFqYc9W1meBfmiZibpP5VaYM+ExzTCdRe7iEmK3+12TomnoqlZcwuXPlzmWFf+OjL4OnVtojyDchxbMxHk7iUBSWVso6KYSp2L236hDDCW6/Y2vINwru+3EJoEwG5myaMHB13Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/ZaM5DJr2ulrL3xybKgMs8xQtxGT5IHvHD5kdWesxc=;
 b=e8u3OKVr9tS+lcqTKPNkowLtvzvjdaQZBrhffHyfh2sv5B9fzd2HnxbNtx2HiXMV9uIHHZP2zZE/oj88X31CTem6HaJWtpo7SByU0Atqo01gxHrnHDq5+3kNUTPdRn3RX4IxvhtSVHnP7Uk+r2sT4mvZUPFFHSz4U02ATH85mKI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:39 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:39 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/13] mlxsw: Add support for buffer drops mirroring
Date:   Sat, 11 Jul 2020 00:55:02 +0300
Message-Id: <cover.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:37 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e38d85f-0022-46b1-b4c1-08d8251c1fb1
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354CC3F5268E11334F21432DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uq9YuLhptK2mdyFU4QfWtl0kY/CWmeAONhA5B02gb2lGH4TFMSgh3HG6oxxpL/pvGJit+AHqaWD8rACfuQeMyx3dePLx4spfsrvw5O99j2ZlYlNMmXzXWJKM2wd0UG6U4ij90KGmk5S37eUrBwDDCCa0GMf1Wpz28z7OBePyB+TFK5vyk6KjnYfyKBbc5Ynxz7vHL+R6jdg3xJrIA9b/Bu7NLBmQRe5cKFt/1bjpiGZML1TkKJIKLeKwnLkYC58WCQL0HJGpBRGhM6rA5Ldqszhm3MBocNmklR0149rhQ6j4IUF3GHT7PyReS9qVX/E/SgcYNlnOGgYPlPt97Jn6vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3cwsf5PkNCLOL2V5ILzlrAUW9k0V8oHk7Mjkqkf3jJWY1OcXAKtiGsVRzni/2pPNQxZRgesd4K6/j65jkl1dM9ZbqRx99g2PhI8VavP5BsIw2RbWm2rehqIj3ETXP5y77hhRidNsJ3sHJs6D4Lek1Zt22WmyAFpw2T3ysf4gxsO3V3Ge0emwM4r4iRFmP0787o6SAKPKbW1DHFwW+FXoUDbRYLzPDwgh7GzgXBXSlmPPYU97kqSYqvCFRan7r/2zWH+Jjbqe9e0WHoSIR9vk8J44cDh5YIN///rEq/9tzuyljvA6xbbPQiQcVn5jgZCgIzn4QAoiFpq1VQI1MgiygfftH74Oabxzey3ob3bFgq79HfOinnghuI4RmfLfV7LYxhp5tDVV/A67WoQ9c+d7vL1MJxiWzLQML3Lm49v910UoASkPGYuKbChEC5saqBn90oPYhj6VpJfxg8rE9U0eN2nuTFVEJ1ftgTDh8Lr6n8kTu6X/C6VPltJ4cUZYa86X
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e38d85f-0022-46b1-b4c1-08d8251c1fb1
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:39.7275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsQ013J1BhjwlHSSAewvPoovC1y69ob5gtseoGNVcGUI8BySWi0Hx3UNTMsREbasLRmtB5z9t8iYd2GWB1w+ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set offloads the recently introduced qevent infrastructure in TC and
allows mlxsw to support mirroring of packets that were dropped due to
buffer related reasons (e.g., early drops) during forwarding.

Up until now mlxsw only supported mirroring that was either triggered by
per-port triggers (i.e., via matchall) or by the policy engine (i.e.,
via flower). Packets that are dropped due to buffer related reasons are
mirrored using a third type of trigger, a global trigger.

Global triggers are bound once to a mirroring (SPAN) agent and enabled
on a per-{port, TC} basis. This allows users, for example, to request
that only packets that were early dropped on a specific netdev to be
mirrored.

Patch set overview:

Patch #1 extends flow_block_offload and indirect offload structure to pass
a scheduler instead of a netdevice. That is necessary, because binding type
and netdevice are not a unique identifier of the block anymore.

Patches #2-#3 add the required registers to support above mentioned
functionality.

Patches #4-#6 gradually add support for global mirroring triggers.

Patch #7 adds support for enablement of global mirroring triggers.

Patches #8-#11 are cleanups in the flow offload code and shuffle some
code around to make the qevent offload easier.

Patch #12 implements offload of RED early_drop qevent.

Patch #13 extends the RED selftest for offloaded datapath to cover
early_drop qevent.

v2:
- Patch #1:
    - In struct flow_block_indr, track both sch and dev.

Amit Cohen (2):
  mlxsw: reg: Add Monitoring Mirror Trigger Enable Register
  mlxsw: reg: Add Monitoring Port Analyzer Global Register

Ido Schimmel (4):
  mlxsw: spectrum_span: Move SPAN operations out of global file
  mlxsw: spectrum_span: Prepare for global mirroring triggers
  mlxsw: spectrum_span: Add support for global mirroring triggers
  mlxsw: spectrum_span: Add APIs to enable / disable global mirroring
    triggers

Petr Machata (7):
  net: sched: Pass qdisc reference in struct flow_block_offload
  mlxsw: spectrum_flow: Convert a goto to a return
  mlxsw: spectrum_flow: Drop an unused field
  mlxsw: spectrum_matchall: Publish matchall data structures
  mlxsw: spectrum_flow: Promote binder-type dispatch to spectrum.c
  mlxsw: spectrum_qdisc: Offload mirroring on RED qevent early_drop
  selftests: mlxsw: RED: Test offload of mirror on RED early_drop qevent

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   9 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 102 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  65 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  33 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |  18 +-
 .../mellanox/mlxsw/spectrum_matchall.c        |  23 -
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 472 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 397 ++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  16 +
 .../net/ethernet/netronome/nfp/flower/main.h  |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |   8 +-
 include/net/flow_offload.h                    |   9 +-
 net/core/flow_offload.c                       |  12 +-
 net/netfilter/nf_flow_table_offload.c         |   2 +-
 net/netfilter/nf_tables_offload.c             |   2 +-
 net/sched/cls_api.c                           |  16 +-
 .../drivers/net/mlxsw/sch_red_core.sh         | 106 +++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 +
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 +
 20 files changed, 1179 insertions(+), 142 deletions(-)

-- 
2.20.1

