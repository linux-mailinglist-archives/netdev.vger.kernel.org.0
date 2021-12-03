Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640A746773E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbhLCM20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:26 -0500
Received: from mail-dm6nam11on2121.outbound.protection.outlook.com ([40.107.223.121]:18528
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233378AbhLCM2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbJ6NX7YJGmT4h1A3dqV7DE0x7Zx/ycUzYTbHzi0dPKlEDfknMDTryyHHYeFLnjEGN/rgxeoxBvJ9X2uf0BgAUT5FEYg3RXf5Z4QU4eBcYmqMZoN/UU9V1/TtOvjWbcI97cbxv94/NIXyUWCwBKjOe1M//x9yjpCZfctndQJ6fkDdxCwwR73mNF6ukBgE6RgcSbW9z5CkU3Hgywhihsi5Wxg8zA7CFkE6JbjYeoH2pP1N5wG3xymLIIigP9IwqWmcyB7CYq3XEZ4T1PyiuL86bRfgDSitau/MLVRdsz6JY/HXqOU4O/zh+eyIKSBHWzkv4sl45KpK9shZXd5IbcwUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6AxN6VGXr39MVsDJqIY3IJLWL45u4kZ7wPHFGkgA7Y=;
 b=KUjhBKykpnts6B80eKc5F7tUWM+Wj8cze4RLnkN18QGHygno0JMbhjBlwmO0sCeNYJJ7C+O17IZh9/MS+YwcSTblOrsdMwY4L7Fyz0vILlLv+b1Uup6BlxS4PfTDycZMxiXk+1TPa83vBwZBCtFb4PNZt8sW55H59CNEmxcd8w8gcmyGxv63Fwry9zRyCGOwM0A3vQ64nRBPVWsdseJVrmAtEmMHRpTIQ8zL+FXinbfYv4JS1L0FAIcrVYyCgCXCjossAdCUNWUnS/UUKjSa8tfWX6BE63KyiNkj8QwzafQgbEzHSGLgRdft0veFk5aDXlHokY5sgHuC79EEfjDUfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6AxN6VGXr39MVsDJqIY3IJLWL45u4kZ7wPHFGkgA7Y=;
 b=sbzgQuaYHVIddr3egyRXGftbYd0JLiCein2xbHlbw2iGVWL66xKtpMa0SXCe+4thzKh2/i1fRJCB6lLhClkyWRIL92Q+q+BKDnDQN1f5QzOGMUw8BIftd/jTTApdRWwbf2FkHOiWVTBnJvgHppWl7pQYSa94rWcgiKiazDjKLIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:24:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:24:59 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 00/12] allow user to offload tc action to net device
Date:   Fri,  3 Dec 2021 13:24:32 +0100
Message-Id: <20211203122444.11756-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:24:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0d2f73b-c40b-49dd-22da-08d9b657ec2a
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5423BA2355DD1097CDB3EE9DE86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGRavL5V6k33Np6f6FtspMY9zYUZlfAQ+NF6/ytYapTv/iMZGJCAdgxcftlnBszB4ZO4II2/w9Xceq4fvPwU1qLJsqzoDLLWctX4xRxVBTfwB0xuKT7sQ0n4jlPrUpVmfaOK1VwnK6p41baEd54fiJ9v+p4DAjWkeAnJHtNUu2P3LRivygWlndYc6Hram6MGLWxTF3RRo2Y4ooDT0wBSouIRgAxUuWDK4wE/KFgBAanWj0ThgH4wdWC3kwi0msVLyCu3dQEJ3jfsoaHJzRMfh1qQwqjD863j9yNma8aCM5cf7/8C7X3wPFp3rnGo9HYUuFgkUeOFJfeCutO6+xgxh+s5ZFvcudfVJ9hXpoKijh7c+bu8BjR4PzIq2Yo0RL5KQJt7Q/pnhjP89EHfGWUlUNOz6pjgsqNHxMKQGaSLKRNVnfw43pk67Lr7OObMmN7ePvWkgnuYJvEs2sjNj2ljT9pPWYn8FQAg4jWKM5y0rCH+SonUiOo6NSE6ofrDA4LSkls/D6mymWnqYOczxl1ofNON21fL3QUrjy8HhM/wr+i0oe1aWpBUjsTUg3ypPSZ/PQxO+fPuHfR/zO7fWLiBM7IJxYP1Dmi+kNbYRz00cQsxBBhheOijC6eJPZOezOEhG9zgmth/mQSamsjtFa3zdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39830400003)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R6BTRZ6F9gqEXSwCSSDL1BNxu5VQ/8ke4/NGe5qWKbToJv2CtjJgRZ5wQOAc?=
 =?us-ascii?Q?DFwCk+NGE3uV5ScWI6K9jFFalB7NNyQGJw1s4mRQeGpLRQrO41Ec4uFO08nC?=
 =?us-ascii?Q?x85aPaEk3i6/jSlV8Onav2rTbfpcBmhnZSun92pS2K91vKMz7sAFDJoB2j72?=
 =?us-ascii?Q?ESa32OYyT0OK9VkdtzbpgDNI9LgEYY62UmGtWfVuZdGrr5c5LY21aqlwwqNw?=
 =?us-ascii?Q?wdhfyXSTdQwqjJSxvtbFpUQVybuX/IG+DTIsn7vQxjCH609qEQ62+TuM2oyz?=
 =?us-ascii?Q?5rZo0HudjhXrX7AW9lGgqQtFRB33HA2s22CFkeOnm+JcD18P6zHGQtMsgQht?=
 =?us-ascii?Q?0p9YroohR6TtQ7vue2va/QLTLcTF4u+RQoElGWxyqK3enH+O3pHMmYIuPjFH?=
 =?us-ascii?Q?+O3Vk4XALWBQCu/V2nmswfIZMJQ2mVi01p8ePDM2D1N3pgG/6x7Aw6MpfVRf?=
 =?us-ascii?Q?m88euzrUXApBO43oz+pHP9wBS5aBFsxNKFQbv9Qe/PH6B5CxIhBHzYq20b2a?=
 =?us-ascii?Q?86DYjV96uqzG+su0L7kgUvWcvFtkrAE2NQoYk4sVRxqgvfJ8fjcZocvaoWls?=
 =?us-ascii?Q?UNuaAK1cCciEO1EjUJHKjR63lOWJle1kMKcigyA08jihD3wTq8YYAvGo50Rs?=
 =?us-ascii?Q?1OsaC39IMESFs8L2H86o4nZwMOnUiq5SZMANDNrnFD4RA2yfS3WcacOUUQbz?=
 =?us-ascii?Q?qWzSeuniq4XY3zF7rTya1Q2ZdMdHiYe/Pza6UVneQYe47o4vm184dIFGucv3?=
 =?us-ascii?Q?nbhTBsu3BjoLkLYJ3vvIM/Uka+8mTjTutSBkbQED4WSF3fv0CSX2SsDJ74ge?=
 =?us-ascii?Q?oyZyuthg9OR8Df54em3fX27+5UZHpMDKLkQUXgpZHCJSdklNbIehCtYOPHJz?=
 =?us-ascii?Q?95HueElWVP3o/TenNkFZwg3AGDBQLL0M70WWCwhgbd34bylOUp+mFdbJuo3z?=
 =?us-ascii?Q?FQbX45hs9lkG2BCgb3BM32iYXFJ49TuEqu+x+gl1nGKOAjFOPUCSTeuZb9FJ?=
 =?us-ascii?Q?HDzfxgpz/tTd0oCaRkGfyIW/sV9KzRDSeJXQr/y7XSjhZJ9cUDtXPXOIv2TQ?=
 =?us-ascii?Q?FHJ0B3TJ9wVtBh7J9cBd86pbcE/kYekqDVuGKEtaP7qEl7bwl3k2W3/Kz9iZ?=
 =?us-ascii?Q?NBAow6M7QPxGKrO4BJhQ2/p3ohjk6oPyhPfhx2CVr4WA5x6knoLIIZobJ20J?=
 =?us-ascii?Q?bTX1KXtv0fcreNRxQa5CaCy/NIAPV0ljCd2hjRcasTX1yP3XAKTgoP1xc08M?=
 =?us-ascii?Q?axceznxUtZYWiyLGdTO9EZGk6nK0drukcZ//EdGLXJ8F4Kj21yS5pDERhwIx?=
 =?us-ascii?Q?r1amUoQ+A9M7/nlZcY52vBoah+TXDk1DLdyT6pLqKfKmwthQQrw01LIwQ5P0?=
 =?us-ascii?Q?Mgt+6X5MiClvaI7zmq+QqC0eaYR3Ltvnmf5IVRrhQ41Q9ct2qj2shyjWYmiT?=
 =?us-ascii?Q?BSVGE2f5QIHT5G/zI3XoFwuBej0OZgS1lEVtbASUyqcVWPgb+BV43JaffupT?=
 =?us-ascii?Q?+gcd1eypFtopgTEdpsVl5sjFUoRQt+fZwEn6CdiBBas8jELhbvXCMpO0+eM1?=
 =?us-ascii?Q?oad1SGtNAUfuKM5Kk0LDoNY/BXLLNybKbDyAeSmx8KyE0TZg4uUbSH1UJPuQ?=
 =?us-ascii?Q?KFomfEaqinV/Av/Da2mAPZq979At9hrPOQgkjUjVL9ByyTjlZUN3T2TZrqAw?=
 =?us-ascii?Q?O56pzyxqrcloMdfyB4S6SYwLI2StGpWyPGi4sFtPfP+X/MFDFbkjbX3wb+di?=
 =?us-ascii?Q?u9X+ZmdLtA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d2f73b-c40b-49dd-22da-08d9b657ec2a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:24:59.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GipvnmlyMCZJuhT1vJYflvfE2qO31FM4QWaFK/DSi6lFBPPogjsR9SedeVqV5eRwuCiqwlqGzLm7nyuWrdWFulBao186o2TS9+YlGnb4v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
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

 # tc qdisc del dev $DEV ingress && sleep 1 || true
 # tc actions delete action police index 200 || true

 # tc qdisc add dev $DEV ingress
 # tc qdisc show dev $DEV ingress

 # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
 # tc -s -d actions list action police
 total acts 1

         action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify 
         overhead 0b linklayer ethernet
         ref 1 bind 0  installed 142 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc filter add dev $DEV protocol ip parent ffff: \
         flower skip_sw ip_proto tcp action police index 200
 # tc -s -d filter show dev $DEV protocol ip parent ffff:
 filter pref 49152 flower chain 0
 filter pref 49152 flower chain 0 handle 0x1
   eth_type ipv4
   ip_proto tcp
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
         reclassify overhead 0b linklayer ethernet
         ref 2 bind 1  installed 300 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc filter add dev $DEV protocol ipv6 parent ffff: \
         flower skip_sw ip_proto tcp action police index 200
 # tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
   filter pref 49151 flower chain 0
   filter pref 49151 flower chain 0 handle 0x1
   eth_type ipv6
   ip_proto tcp
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
         reclassify overhead 0b linklayer ethernet
         ref 3 bind 2  installed 761 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc -s -d actions list action police
 total acts 1

          action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
          ref 3 bind 2  installed 917 sec used 0 sec
          Action statistics:
          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

Changes compared to v4 patches:
* Made changes of code style according to the public review comments.
* Add a fix for unsupported mpls action type in flow action setup stage.
* Add ops to tc_action_ops for flow action setup to facilitate
  adding a standalone action module.
* Add notification process when deleting action in reoffload process.

Baowen Zheng (12):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: add index to flow_action_entry structure
  flow_offload: return EOPNOTSUPP for the unsupported mpls action type
  flow_offload: add ops to tc_action_ops for flow action setup
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
  flow_offload: add process to update action stats from hardware
  net: sched: save full flags for tc action
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions
  selftests: tc-testing: add action offload selftest for action and
    filter

 drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
 drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  27 +-
 include/net/flow_offload.h                    |  20 +-
 include/net/pkt_cls.h                         |  27 +-
 include/net/tc_act/tc_gate.h                  |   5 -
 include/uapi/linux/pkt_cls.h                  |   9 +-
 net/core/flow_offload.c                       |  46 +-
 net/sched/act_api.c                           | 450 +++++++++++++++++-
 net/sched/act_bpf.c                           |   2 +-
 net/sched/act_connmark.c                      |   2 +-
 net/sched/act_csum.c                          |  19 +
 net/sched/act_ct.c                            |  21 +
 net/sched/act_ctinfo.c                        |   2 +-
 net/sched/act_gact.c                          |  38 ++
 net/sched/act_gate.c                          |  51 +-
 net/sched/act_ife.c                           |   2 +-
 net/sched/act_ipt.c                           |   2 +-
 net/sched/act_mirred.c                        |  50 ++
 net/sched/act_mpls.c                          |  54 ++-
 net/sched/act_nat.c                           |   2 +-
 net/sched/act_pedit.c                         |  36 +-
 net/sched/act_police.c                        |  27 +-
 net/sched/act_sample.c                        |  32 +-
 net/sched/act_simple.c                        |   2 +-
 net/sched/act_skbedit.c                       |  38 +-
 net/sched/act_skbmod.c                        |   2 +-
 net/sched/act_tunnel_key.c                    |  54 +++
 net/sched/act_vlan.c                          |  48 ++
 net/sched/cls_api.c                           | 263 ++--------
 net/sched/cls_flower.c                        |   9 +-
 net/sched/cls_matchall.c                      |   9 +-
 net/sched/cls_u32.c                           |  12 +-
 .../tc-testing/tc-tests/actions/police.json   |  24 +
 .../tc-testing/tc-tests/filters/matchall.json |  24 +
 42 files changed, 1144 insertions(+), 290 deletions(-)

-- 
2.20.1

