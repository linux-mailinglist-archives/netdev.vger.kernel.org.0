Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A6F41EBFB
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353925AbhJALeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:34:50 -0400
Received: from mail-bn8nam12on2134.outbound.protection.outlook.com ([40.107.237.134]:33569
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230345AbhJALeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:34:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxmjidlDwOBzHYtwcaU42VQ1nPUFMn/L3ECFWgb95jcumxKRoOAha4feIWaXWo3jk02Fc6qbxrRmSZPdPdIISJVZ1e/rokJ1L/kHn43fEsvmQWp0v8C0PyIYcQHnOv0ErLaVbOgxrtsMBRL4hwCjRaKBD17bmKoD5IGxTxLz0kb6gEGXtiHXtqSr4WzkJfNzxM7giAjQU1JFaKlW4mbWhgINOKIr12LyorNaTJkFMne3L+gMTu1ODQwRgjQGc3izorx3d7qS6vSW2nYrZIjJCnYmafAVGL6+0wHFVJ0A8JVBsrdzuajinC7ajMM/K7YBBzBaKi6laND29RYAkdsDTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+0CAGSW5JdevVu6egawN7H/0IM9fH5wTZjHfU2v/U0=;
 b=Uv9mjeLk7PrM93HkL0GAjCZTGI+AqQhLyGhAKIL+lfHIOblN6ZDHmTifVAHdegPs/N2x6SYw9/9BUgrmJR1NCKQIOheGXiK5hfrEhlnkDBIrGltIpnCwnGGKild2KdM+2ILvuTjYXcBfxHHQNHU7Il8kCc8+PB3v4LpyDP68C66HPyFMy16G56eOejVIAyMM01Qi01SUj6TJjTu8zq+Iv5YCW6Sy20MOOukjcjhGtbPYScpZaQnnQRC49aLVaQS0Lwc5SkEHhiFAVn8mT6p75MRZccTjeKPvtRmqdHT3x9LRYPEYxTV7J7ZG7VChHJt3WbkL+ds/K9S2i6Gw+BOBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+0CAGSW5JdevVu6egawN7H/0IM9fH5wTZjHfU2v/U0=;
 b=qgpEbbww8JLjODUm7kNpNsKgBZl5gUkC8kHRhvP2KIqLZrfjdmyrWXRjUXT0uXuoB51c0cXDj59v2Gfi9TjnrEtzKDUIVTLDBxYik1milvduvYQLT+VbYVpCCK9IO8RGlZZwzMIh1k1x2s2KMuAUS8ZuriIF8jd3JhHK04M6XAY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY3PR13MB4804.namprd13.prod.outlook.com (2603:10b6:a03:355::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7; Fri, 1 Oct
 2021 11:33:02 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e%8]) with mapi id 15.20.4587.007; Fri, 1 Oct 2021
 11:33:02 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v2 0/5] allow user to offload tc action to net device
Date:   Fri,  1 Oct 2021 13:32:32 +0200
Message-Id: <20211001113237.14449-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 11:33:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b061876-227f-4a5f-75fb-08d984cf3a99
X-MS-TrafficTypeDiagnostic: BY3PR13MB4804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY3PR13MB48041D03A22FC6961C62CCA5E8AB9@BY3PR13MB4804.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LrCcCPBbdPSzdKZrbzNijobIBZyXFzyGjY4WHeU3KkdE6GQ7M/rKVCPElffAjew2I7ToJ3kRqgD02WJ7msARHPc8wxA8baMWzZkIBfqzkndlRPELYfiURML1YsQKXpc0dC7Il59ltIt1WIA1pFaYYkZ15qju69ZZEIXE1oSN35AeCe+kruahZNqp8xK/Mm/LE6yHsq7/9/Oe+gsMEkubqRm74vMM7AlncyII7f7738S5B9a6Sk1OcJgVCZKUhMQUrRp81lMydBUPz01ulhA7Ecba663ODjSIWolbg3a7MMDAnKHGOwcgDInu4qkHhYGT2EORqSuFIKy+6uQoo9pC/ddF2jbf1U/X1y1koq3ssKUFTtsxqy+bLFRygVIvlIzSZwj32Zif0CFr9E99MdQbwiueCAwKrgYUsObWS6pVxZOuXA756v7+pwYggTEFSJ6yQ+7v+TtMHKHkKXhQ1q9lI0OwVpQpP8+BWSNXuBYlcT7JtGWc88pZ5SeqAo9kg9yll+swM9oa3z7ZLsJ6M1Ex4bebNrR92bumut/kJQEzkijzKJkFMVXcOiiQlAkWhCPeqSo2wR6DCNnhdE7QNEGSBeSitKnZQTgZZL0jPlW5FDPiQrXm89DM4OktH/vbxQcsFMNQHo0Gzd2nKCeYlGbXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39830400003)(2616005)(66946007)(86362001)(36756003)(8676002)(508600001)(8936002)(6486002)(54906003)(1076003)(316002)(66476007)(2906002)(107886003)(66556008)(186003)(52116002)(6666004)(4326008)(6916009)(44832011)(5660300002)(6506007)(6512007)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?al93CyjlZ+G/a02iwdAj5f8bRybdOAUJH/kZ4aKd6DrK1ZleFaBKeVAJUABB?=
 =?us-ascii?Q?BlvXj3JRMQvcmC5eIb9nzV3rN/3nETzZfsYe0J487UFzuXgfeAr9YhmunPyW?=
 =?us-ascii?Q?TGenBRZge9HvtA8dr5haIxyQsTPkuzyN10GhqGDplwqa9YVeC31tBlDlerwZ?=
 =?us-ascii?Q?P89zhWry6aEfJhtv0XjXruxNob1WqtVsxelMmXaNc+dnU0aIeAGHrSFRtbxS?=
 =?us-ascii?Q?U+UjTfr+0bPb+hEpxTd32oyv0U4Q++AiXCOJQS7ZWuXFO/SnvBcFFPFPfDJr?=
 =?us-ascii?Q?LIcQIwVGg/SvqJ/f6Nq5yUq8pFg2h0MpiYqCMNhvbCVpjDpf/jgGnQtkVT1N?=
 =?us-ascii?Q?M46WrOfDJCqzl4Kkg/TSptAChBiO/gmwRCGWPhgFXSmXPsGS+b/aqivS/bez?=
 =?us-ascii?Q?FpIkVggQB1FF2Of5cBQDR/UvF28IL6ERPaNkmzYP+w/ccHwyHEnGGp1RJUIN?=
 =?us-ascii?Q?HHCuqbZnNSaESGanihBUjUQknCTgBzv+tyPK2v4s/tOdT4XfSWbPlp7ikyPR?=
 =?us-ascii?Q?QGVBxB8A78xyMZ2YpbsADuBZ/1pOH8wYH5yO6G+YCDImRxJgC/cna3mqaBaU?=
 =?us-ascii?Q?KoVBXYC+zRIFXnxu1PpvTXOsKX9PLp9SRxK2jTdNwEbBoZrqlr2MkNO9Zdl0?=
 =?us-ascii?Q?9aaiAxCFRmlnzEYxuMkwlIWqw16NbxBO72dD+xBk9xjAHt5/BKlL8cMiuQYI?=
 =?us-ascii?Q?K8QgUj7RrfaR5jI6LVADaa1lRYr7y0INVRbYcAQXLyl3VovziouzJzddUc01?=
 =?us-ascii?Q?OgIQp7deVoykVn6gB3k0mgJcv/AVY2K/kXi1Saubny/icOGXI8texkiMKDxN?=
 =?us-ascii?Q?7YhJ2pB+OsDlND2qxVuh2ILmXYneVX3etWaaepXaOUoKpFVK67+nwcgi6fP8?=
 =?us-ascii?Q?jobOoqoHhDeHpASI4MOWzLEWBn2jBGVKLuyRJZhi2gz/RO0PYZCridG0XycD?=
 =?us-ascii?Q?NYKzMpxwy5kuMtNVrToCNhg/KFRUun66ukG7ifDm+w9bwbdy4GUzOkLwEc6P?=
 =?us-ascii?Q?4UqU7nWOI0g3HNQStJn78oCLIE7CKD//pgvAaSUxRzndg8eOTszYdSl9V9rH?=
 =?us-ascii?Q?T7Vlaq8QPaIcS1Phq/846qztdcZT8Prlv1WUle9bHSlq5CZEJnoR6K0bI649?=
 =?us-ascii?Q?+2RwwMaDqpQCMBVwEkWFBWmV6mFSLTtpq0wkPI9cBFDMSy3++zX4567t6nqq?=
 =?us-ascii?Q?5uLHqtD7PcBLiVcT8vIjbv47xdofQBXhAaNhb9BXcSnJ7gYQLJWB/LF5z7Kn?=
 =?us-ascii?Q?TIjCbqu9geRirEm8SpgH9cHMkmIRRmdpDree1YO4G0502awGBSTX1T77Jqpk?=
 =?us-ascii?Q?gzAop0K+HWx4bfhXXb4hadjxdwk6SBUgpt+c36zh7dxIZ7m0VQ2zAXT3Irk5?=
 =?us-ascii?Q?krLg07bPUKo5dQgb0OTaXdvyHA3k?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b061876-227f-4a5f-75fb-08d984cf3a99
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:33:02.7779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1NUw1jPccdeCFOzYbgaMqIzaqZvrqGwtZb3TcU4zhAmhyKySpf29sMD/RZ3v8ddWNUS3QAMLJ3mh3I8ZHLj3QWx0t/dTgaH/8u4ng8XZbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4804
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baowen Zheng says:

Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
tc actions independent of flows.

The motivation for this work is to prepare for using TC police action
instances to provide hardware offload of OVS metering feature - which calls
for policers that may be used by multiple flows and whose lifecycle is
independent of any flows that use them.

This patch includes basic changes to offload drivers to return EOPNOTSUPP
if this feature is used - it is not yet supported by any driver.

Tc cli command to offload and quote an action:

tc qdisc del dev $DEV ingress && sleep 1 || true
tc actions delete action police index 99 || true

tc qdisc add dev $DEV ingress
tc qdisc show dev $DEV ingress

tc actions add action police index 99 rate 1mbit burst 100k skip_sw
tc actions list action police

tc filter add dev $DEV protocol ip parent ffff:
flower ip_proto tcp action police index 99
tc -s -d filter show dev $DEV protocol ip parent ffff:
tc filter add dev $DEV protocol ipv6 parent ffff:
flower skip_sw ip_proto tcp action police index 99
tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
tc actions list action police

tc qdisc del dev $DEV ingress && sleep 1
tc actions delete action police index 99
tc actions list action police

Changes compared to v1 patches:
* Add the skip_hw/skip_sw for user to specify if the action should be in
  hardware or software.
* Fix issue of sleeping function called from invalid context.
* Change the action offload/delete from batch to one by one.
* Add some parameters to the netlink message for user space to look up
  the offload status of the actions.
* Add reoffload process to update action hw_count when driver is inserted
  or removed.

Posting this revision of the patchset as an RFC as while we feel it is
ready for review we would like an opportunity to conduct further testing
before acceptance into upstream.


Baowen Zheng (5):
  flow_offload: fill flags to action structure
  flow_offload: allow user to offload tc action to net device
  flow_offload: add process to update action stats from hardware
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  18 +-
 include/net/flow_offload.h                    |  27 +
 include/net/pkt_cls.h                         |  90 +++-
 include/uapi/linux/pkt_cls.h                  |  12 +-
 net/core/flow_offload.c                       |  48 +-
 net/sched/act_api.c                           | 471 +++++++++++++++++-
 net/sched/act_bpf.c                           |   2 +-
 net/sched/act_connmark.c                      |   2 +-
 net/sched/act_ctinfo.c                        |   2 +-
 net/sched/act_gate.c                          |   2 +-
 net/sched/act_ife.c                           |   2 +-
 net/sched/act_ipt.c                           |   2 +-
 net/sched/act_mpls.c                          |   2 +-
 net/sched/act_nat.c                           |   2 +-
 net/sched/act_pedit.c                         |   2 +-
 net/sched/act_police.c                        |   2 +-
 net/sched/act_sample.c                        |   2 +-
 net/sched/act_simple.c                        |   2 +-
 net/sched/act_skbedit.c                       |   2 +-
 net/sched/act_skbmod.c                        |   2 +-
 net/sched/cls_api.c                           |  29 +-
 net/sched/cls_flower.c                        |   5 +
 net/sched/cls_matchall.c                      |   6 +
 net/sched/cls_u32.c                           |  11 +
 28 files changed, 709 insertions(+), 45 deletions(-)

-- 
2.20.1

