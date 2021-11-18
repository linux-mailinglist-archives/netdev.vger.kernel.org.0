Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501D3455C4E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhKRNLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:21 -0500
Received: from mail-dm6nam12on2106.outbound.protection.outlook.com ([40.107.243.106]:52384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229472AbhKRNLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhX/jRogbQiACbSC4YpEa1R9xv1AHdFcgfzHjyBNlZ0edWZW0GzgN3mopBpK1oHMdjHdlRFjwT17Vgl46o8WSqzw7cEARN9LdvuyQiQGX7H34X0bxIdFKyRrt/SOqv+rA/3xanN4hIdJkVRPWgI2cOO6qJeU1PqMeQ5JJKMyxa73LuS/4tfVxyByJ4hMQVXZHTgPf6Zb846MwhSqQEoPOlplSqdCLQUPV4EXPqoK70VgZ/9mo3gyRPF7kSimddAlERn+YIRaqJV5HHuZ50/i47SSbnoWP7x5mJYHgO7taHA9UPbcFl6B8iKyHxL3JW65hX+wD4V0SRY3lSbepoO+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btSsQAF+fcRDo5G4+4vrcb/Fj3kGbM3lrImsfV21bh8=;
 b=hpLsAtM5DJg0CRZWfolijTjsJuAif5dqzVxYQ3pVMeIOsRDb9V6jQqb7fzCoCnEm12RWbgfls19t7As6UCmcQXsIZ6rp1NnF4iKh060CdEJw8VgtS9yi7Lp6I37zcx9M6qpVGWoaRGT9jt+hA3oYBoS6eTx/F4ux/GwwR0h/YWuARIY1jgPfvtG7ZV5tkKelK9VY+GYjgkT6VClvbs8pxkGxnKXdeqUqSoZ+slCchrh/Z0dM132H1ZT8W8jNhjFg9yeogKV4vWaMJbA01ci1xwIjwh0QBXpQXO5m8PPS7DSArVDZ+SRFgXmrtoYeFM2dGWaW+SVuOegZ6ylmYq4tKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btSsQAF+fcRDo5G4+4vrcb/Fj3kGbM3lrImsfV21bh8=;
 b=qa4Wg6Mp5ULKuyc0FktdMyHGKxsfmVzDBSiCA/qUwTsCjQlm4JV9wCoPi36NYUcVJ8iekkPHnRPClmMrS4OUOsQ8Gc7FVeXDXG8FgLEG1s4G3kjzduBwTYhQGn9ErCNWxcnnNJwEZEoNLazyo2fM56QSSAZNAAKUdMI8AqbD968=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:17 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 net-next 0/10] allow user to offload tc action to net device
Date:   Thu, 18 Nov 2021 14:07:55 +0100
Message-Id: <20211118130805.23897-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a77e1249-e520-47c6-cdc4-08d9aa947c98
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB542266FBFCE8AB9FFCAE2154E89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JDaJEw2Rn4JKytn411vDPrBrMOAjdI+2dhTPnMHR0C08JSzjjgvpg16K4f27DFwD7518bEyFfojbhYEDQOanWWk91LG1LV6SH0gjQyuthkPceHwnoSpLyCuWPvqLMpOsyupggn992JcB8wz8gGanoy3sx84rCHO4OeoMaNHQeHha6EjSFN/Dw4R9MzewznJRGRpAsW/zfuAiv5t2BG3Vvmj79uPz5k89dhzgZ6PehCjjYAxQtq+BwS/VBmPeiTHk/2bf33h5iRyKFlPo1qkRpxTxjNrRziXADOyof0JVwjMUTA6nQyx3N30T/xDlm9vGra1zxYU6mGCcHR9uIXcpWyXmCkzNkot+KPYU5OhG78n4T06CDVLTf/PR0As4kecv/Tz2/7rSLJsE8ssaIlusC4m961Pfw6MLVd/sJlEzDljppxlwtbckkFJl8UhRqjxJLrl1sPDu5N8p0DE5iPEmGdpBwT3RnsbJI3MHqBmJeQ+2q/fimjqiFsEv5FA69I7LBNBgeHxAwEXyrkTbPE7Yo3WeWdF5gyb1YHDjfQceNp8XkZOwjkaJAhYV3q2q7+XjUDeAMF0AcavAI8DLd2CvHQpawLvyXoN/Z0zQRwqXXY5B8F/7EksPX05wmLDbHPnTZNl3hkDjqpHwx3TRwHM9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0GSVW0CKtODPwrPHhANbYUzEY8GWlQRj6aKVxK5oaGlyW1yRar6XwO7hpX0z?=
 =?us-ascii?Q?L1oBn0WHZExtbgEyCIryl3teXy2+FNEYImiQn2pGJnbMAS2AuSVWV2qFw9Hh?=
 =?us-ascii?Q?aljERSBaY08L+nriFL3VxgkTUDNZm0X4ddbdhHv2mogc7Szznr0vgxRZgRGK?=
 =?us-ascii?Q?mP3fDNYkUqZ5BN6CzcMDWYzfRK5OM+3SUA97JsvqhdPf+nr0lbSj9hBFPPCA?=
 =?us-ascii?Q?QATwaZL19qS5/QzofPZzVIQimUVEz4Mx1zdP7DHUKpxd31R1KA0CKSnd72UR?=
 =?us-ascii?Q?viafOYoHk5+Q8DhZsLGMvImb03uI6Y6z57RTpvcfIcl9CNwFwnQJwfW+QVwR?=
 =?us-ascii?Q?HgkJ9eVk3sstn8814vaANPBD7ooFzG+z52JZIkuDyRAAynNHju558QwlNOVE?=
 =?us-ascii?Q?d2a95tV7Dvs8mhTpfnaq3dYaaI2MxDfmfo+RXOMGk3f/+msGcXroL9Kd6ckl?=
 =?us-ascii?Q?Y1aYZxqPtJdIH2Ph3y0mjo1aWVhojFOPkJCrrEt5I4dSGAUCEszuR5/wHEOM?=
 =?us-ascii?Q?LYs3PSs/5UcTusro579hM8As/IDZ4mfKOKwg4Ub91cvCRseBdx13+8N7U0IZ?=
 =?us-ascii?Q?+4ldDVUzLp8iFd/WbmcpNi84Tasanyaeh5Mxs1Ss5gns1sg2RtsSa85J//DC?=
 =?us-ascii?Q?/bJloC+nDtYEBfxWeLwOZsylvLGLRVUfnoajpO9nlKoudxZG0F+f5KkH1doi?=
 =?us-ascii?Q?ctG9nZ5rhhWGfjctZS3MI8taGONRi58JvNkE87bCrsqN7aBTO2l18gh1Atcl?=
 =?us-ascii?Q?DAaRbMnsd/cYORDzLLhXnTLcm2xBQRiiAwMZiyeSut+XuEfgaBZWvfVZNKmi?=
 =?us-ascii?Q?sTPGWG96sc819XDXGubVHuNb87qeOEFOUivL+jocsl2NcmoJ53JpCcpWJzle?=
 =?us-ascii?Q?a4bsmWy2PsT/rBaooj4Ucra1qBdfkz3B++miASs4kMc7fZ40TXz+esSSnkQ6?=
 =?us-ascii?Q?v0Nb2VyQ8ltmk6/PDpwiMk9hT6n89u5rn5t5mxHp5lrhlEK4lr9ksm7UMc7p?=
 =?us-ascii?Q?H8I/7SEZKWfvqjURVEZTuPCcyGV2Z0CKnvdrv1eV3vDvMSgqAUMORvOXVyXh?=
 =?us-ascii?Q?gLUYfCsp2XAgggHI0BMUlXU1TpIRdCcCzJBBG9+qYcPzOlzP5xJBaOKaz7RJ?=
 =?us-ascii?Q?/qAUEGx+tQe/P4X+raYXsDMIZsMkspm6QPUwlMsxOHNX+OysovJJYzjnXW75?=
 =?us-ascii?Q?hZs/BEqphi0ZqBlOBROqPLi/p5OfqbsqoUS85SxlJXl8QuzqlEA0IwOPYbTH?=
 =?us-ascii?Q?8jDjm/sBCmRCwTZln6iVE+Iyzw+ezWAk5P9VwbmUUTOqxEgBQpd5J1rUCK9O?=
 =?us-ascii?Q?GC1qepvuHj9x4SbWFkDiTAQzG2uG8KwY5yOHtR9kuQ1eOJU+vX6h++G8hzsx?=
 =?us-ascii?Q?axqitnKj/sMtcBHhn9rL/R4neK0GIKh7IAdCDy9Q9+n0fW6l20GH+lemFSiv?=
 =?us-ascii?Q?fv3LShlE62ynsk9P0HNnuEt4dZf5HJDsspKclf+RgZkGW03DKLZ9OnauHkgO?=
 =?us-ascii?Q?fFNKqHYCZP0qODFrsr7DL0kochy1gQ+grZeYG87qyHiDlame6U0xsSPRv2wI?=
 =?us-ascii?Q?cxalLqgmqvXbeqwaNpDeZllTyzLpSthwn0YcWjtM0TNCxglmzJl90g4zOHWD?=
 =?us-ascii?Q?dwUicTn6XFE9tmcBbH7ZwSbzvtWxMwH2E0cwRvy6srzc09Lk/nTvaKuBqny6?=
 =?us-ascii?Q?lU2goo/Tx4jIMdRLjpoOHMl4JDp3QyWyc0PGKHMpEMXFWjy6ZONSeR1wg4xw?=
 =?us-ascii?Q?mX6bZhUdIHRGURkldgRGKKwjAJD1c40=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77e1249-e520-47c6-cdc4-08d9aa947c98
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:17.4992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OrOAn0H0iw/xCbYY8fOipHEQ52Le1dqj/jhNoczf7n8MAlTm+zQuwunH8fMrVJ3P8UbEK0SsBBeer8Ir5xeagLJR8cl5eRgD5kL1lCRYks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
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

  tc qdisc add dev $DEV ingress
  tc qdisc show dev $DEV ingress

  tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
  tc -s -d actions list action police

  tc filter add dev $DEV protocol ip parent ffff: \
    flower skip_sw ip_proto tcp action police index 200
  tc -s -d filter show dev $DEV protocol ip parent ffff:
  tc filter add dev $DEV protocol ipv6 parent ffff: \
    flower skip_sw ip_proto tcp action police index 200
  tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
  tc -s -d actions list action police

Output for the tc action verbose dump:

  action order 0: police index 200 rate 100Mbit burst 10000Kb mtu 2Kb action drop overhead 0 linklayer unspec ref 3 bind 2 installed 52 sec used 0 sec firstused 30 sec
  Action statistics:
  Sent 136094386 bytes 91110 pkt (dropped 0, overlimits 0 requeues 0)
  Sent software 0 bytes 0 pkt
  Sent hardware 136094386 bytes 91110 pkt
  backlog 0b 0p requeues 0
  skip_sw in_hw in_hw_count 1
  used_hw_stats delayed

Tc cli cleanup commands

  tc qdisc del dev $DEV ingress && sleep 1
  tc actions delete action police index 200

Changes compared to v3 patches:
* Made changes according to the public review comments.
* Validate flags inside tcf_action_init() instead of creating new
  tcf_exts_validate_actions() function.
* Exactly match when validating flags of actions and filters.
* Add index to flow_action_entry for driver to identify actions.

Baowen Zheng (10):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: add index to flow_action_entry structure
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
  flow_offload: add process to update action stats from hardware
  net: sched: save full flags for tc action
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions
  selftests: tc-testing: add action offload selftest for action and
    filter

 drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  34 +-
 include/net/flow_offload.h                    |  20 +-
 include/net/pkt_cls.h                         |  56 ++-
 include/net/tc_act/tc_gate.h                  |   5 -
 include/uapi/linux/pkt_cls.h                  |   9 +-
 net/core/flow_offload.c                       |  47 +-
 net/sched/act_api.c                           | 451 +++++++++++++++++-
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
 net/sched/cls_api.c                           |  52 +-
 net/sched/cls_flower.c                        |   9 +-
 net/sched/cls_matchall.c                      |   9 +-
 net/sched/cls_u32.c                           |  12 +-
 .../tc-testing/tc-tests/actions/police.json   |  24 +
 .../tc-testing/tc-tests/filters/matchall.json |  24 +
 34 files changed, 719 insertions(+), 80 deletions(-)

-- 
2.20.1

