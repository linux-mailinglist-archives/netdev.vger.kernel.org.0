Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AE19041F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgCXEHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:07:21 -0400
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:1860
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbgCXEHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:07:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWLOB2XxtLz4xJ2fVUnaq0QQzOnWO5ndTvaezZKPjcEcgGdGy1UzVLIzZKKXsMAg0eeB9/w00wkAp30uqe3vnTM7Gppv7PBuPWGmtstVmGAaMq0HUS8vY2sbJtZzECv1lf2UnftM4rYhNwhehw8r0H8y3/SFBA5mRS9uimLsMu8ikfm5JMn0HqeQIHJZI8+S7oOAOKmomu/Ii7tctubS9jflsvhsFyze7aKoCte94TqOFrSvtWhBVjVc1j3INoYDGpsyd8UbQlQBQwpjCLj3bYS909Aehh98YTa0IJWMjXQAbVwFFRZuQAQ45PXJSImoyG4KzWKo5Szuq058MSkQGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bhk/iUg1GZpfmp5OcMflWaISwtoM413PVZnU49oRTg=;
 b=Xpkui/z9XRiZha1TWr0AXfzMClpJKj4iw7zCXnlWwmRR/pH8c7Q+u+XlYvJ2kAlxorp6g7EPYVRsi1vjsaNXPfo6XXO/cOHKyVIrW+g9mQiUNLFSGwnOJluG8qoLVPafEGrOxMM0eLYsFg1Vt4LtmF81TC61LnF4WOnmzcPgU34DDVFNrZkmC3ZUrNo7RyH848utRYIyM5Pg2UmVim+ia/rJ8CJMof59BVRvmJMUs59Xa2aV+2OrwJJICpHUocKEfBOMN0dJoSPQ5hS/uJpwQ61omQ6lOizpK3gINhlJXx6EZ9exiNBrZyEMyCWAqSTNMjHh5fMYpD0FSOrEl8Kjcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bhk/iUg1GZpfmp5OcMflWaISwtoM413PVZnU49oRTg=;
 b=gV7k5pTTvWUrRgBQk8KVyUmYWeYlTUTXQPWRhrHaTLWNP2ke06LuVmtn+zsXWTUEClYBUjU/6Hl9cgFNyP/lbPZAil3+oCAvfNV8WLaC7VQJ3asrqIbda4fVSPMhwiN41kU9VrTg0S7s3BmzahgZ1lNqaHajreZ5L4GjbYnlSvw=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6413.eurprd04.prod.outlook.com (20.179.232.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 04:07:16 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:07:16 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v1,net-next  0/5] Introduce a flow gate control action and apply IEEE
Date:   Tue, 24 Mar 2020 11:47:38 +0800
Message-Id: <20200324034745.30979-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-11-Po.Liu@nxp.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 04:07:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9bc359b8-00a5-406e-8069-08d7cfa8d681
X-MS-TrafficTypeDiagnostic: VE1PR04MB6413:|VE1PR04MB6413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6413C8AA60CEC3ED5CBAA98292F10@VE1PR04MB6413.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(16526019)(26005)(86362001)(69590400007)(1076003)(478600001)(52116002)(6506007)(186003)(4326008)(7416002)(6512007)(6486002)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(66556008)(6666004)(956004)(66476007)(5660300002)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6413;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whkaPui6VE5KqyxKIIpA2bHgKcrwmBaopwxe+m/AqiV0y15YepnPaMepF1vp8GqRdNWk+85aqeJ/GUsD6eDNJu0L4YDy+QvKe0NFm8dvrdoizd7Vm76biLg1f2BtoqFyjBQOGmJzp1KjEDG80PNjHENGBZwIySQ1kMVrskvkYmD8pVVf0dBwBUDNyJhqzDAHS0WwRLQjPsDFUCMgDrMpXKgAmEWlBFT+xuadyiZhRw4qKvcnqDpGlzOCtieECcCXqQfhsgAdwWdgX5RRj0TYePMXerS1pfC+n8TaOmW5d0sB+z62iu+i+jvw9gemkgjdBUbu5gA8msvEVeIpTrSS4kC6nxj1Zxnf2p9585wfy4P32YrAZf+WCABhZTO7/FFn/+blEoEj5W7Uygwov02Gmc9Mm8mR9pYUbaYQYtimKng34RJ/vOe11M46Jy1fBV9Gpe8gJti5PRSMMlfs2Fbxgp4XOJovpcAZF55rQnJSA2iWEAGjQMxudbOMagFB6+XX
X-MS-Exchange-AntiSpam-MessageData: m53AivwPJKqzTpjKHRuOuZVFtcAYCHkPxPM9IUqbzgKup1p4m1NE95EKZREVBQM0i7CblNxHrER7c4bvfIaK7dtKGIc8CvZSqz5Cq4cmHNJsVggyHuP1hx0m6aYRBJjEnIkZPxNtOmspmEPFH6UQLA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc359b8-00a5-406e-8069-08d7cfa8d681
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 04:07:16.4216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TK4mjiaZtPmnER9tZ5izHPBul6a+pHzUEI0L3a2KffvFKsV7zRJA7s9SQm7Cpj8p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from RFC:
0000: Reduce to 5 patches and remove the 4 max frame size offload and
flow metering in the policing offload action, Only keep gate action
offloading implementation.
0001: No changes.
0002: 
 - fix kfree lead ack by Jakub Kicinski and Cong Wang
 - License fix from Jakub Kicinski and Stephen Hemminger
 - Update example in commit acked by Vinicius Costa Gomes
 - Fix the rcu protect in tcf_gate_act() acked by Vinicius

0003: No changes
0004: No changes
0005:
 Acked by Vinicius Costa Gomes
 - Use refcount kernel lib
 - Update stream gate check code position
 - Update reduce ref names more clear

iprout2 command patches:
0000: Update license expression and add gate id
0001: Add tc action gate man page

This patch set is trying to intruduce a way to add tc flower offload
for the enetc IEEE 802.1Qci (PSFP) function. There are four main feature
parts in PSFP to implement the flow policing and filtering for ingress
flow with IEEE 802.1Qci features. They are stream identify(this is defined
in the P802.1cb exactly but needed by 802.1Qci), stream filtering, stream
gate and flow metering.

The stream gate function is the important part in the features. But
there is no compare actions in the qdisc filter part. The second patch
introduce a ingress frame gate control flow action. tc create a gate
action would provide a gate list to control class open/close state. when
the gate open state, the flow could pass but not when gate state is
close. The driver would repeat the gate list periodic. User also could
assign a time point to start the gate list by the basetime parameter. if
the basetime has passed current time, start time would calculate by the
cycletime of the gate list. And it is introduce a software simulator
gate control method.

The first patch is fix a flow offload can't provide dropped frame count
number issue. This would be used for getting the hardware offload dropped
frame.

The third patch is to adding the gate flow offloading.

The fourth patch is to add tc offload command in enetc. This is to
control the on/off for the tc flower offloading.

Now the enetc driver would got the gate control list and filter mac
address etc. So enetc would collected the parameters and create the
stream identify entry and stream gate control entry. Then driver would
create a stream filter entry by these inputs. Driver would maintain the
flow chain list. The fifth patch implement the stream gate and stream
filter and stream identify functions in driver by the tc flower actions
and tc filter parameters.

The iproute2 test patch need to upload to:

git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Po Liu (5):
  net: qos offload add flow status with dropped count
  net: qos: introduce a gate control flow action
  net: schedule: add action gate offloading
  net: enetc: add hw tc hw offload features for PSPF capability
  net: enetc: add tc flower psfp offload driver

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |    2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |    2 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   34 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   86 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  159 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |    6 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 1074 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    4 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |    2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     |    2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |    2 +-
 .../ethernet/netronome/nfp/flower/qos_conf.c  |    2 +-
 include/net/act_api.h                         |   11 +-
 include/net/flow_offload.h                    |   15 +-
 include/net/pkt_cls.h                         |    5 +-
 include/net/tc_act/tc_gate.h                  |  169 +++
 include/uapi/linux/pkt_cls.h                  |    1 +
 include/uapi/linux/tc_act/tc_gate.h           |   47 +
 net/sched/Kconfig                             |   15 +
 net/sched/Makefile                            |    1 +
 net/sched/act_api.c                           |   12 +-
 net/sched/act_ct.c                            |    6 +-
 net/sched/act_gact.c                          |    7 +-
 net/sched/act_gate.c                          |  647 ++++++++++
 net/sched/act_mirred.c                        |    6 +-
 net/sched/act_police.c                        |    6 +-
 net/sched/act_vlan.c                          |    6 +-
 net/sched/cls_api.c                           |   33 +
 net/sched/cls_flower.c                        |    3 +-
 net/sched/cls_matchall.c                      |    3 +-
 31 files changed, 2329 insertions(+), 41 deletions(-)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

-- 
2.17.1

