Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273211B3569
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDVDJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:09:10 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:62989
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbgDVDJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 23:09:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAVk5ZDEQo+xTVQRzArxzNU/xWhPvBI9UcXwCVo6g1OMCYhJYj3l8k/tnxlEvkoKXQAbdeCY71ykZEzP4YmpmRBMpO44OK13033qiLbWptb9rVCrGOZ4TZ1YDiuPtyawrjhy0IBZLT/+0J2DG7NWq22XL9hWg0lv1mNkdfja0YieTzu8x8daNzwmxFw4Nc3gstU/BAXpoiO9llQLp+jo5BhpVVDlpYieb651xiaxLKDPq+ZZqs0TGXB0VEgd80+qrlOtQ3UZCGWlNbmi4oa8i/NdVuVx1JgtChf9arnu1nAmedjE3pqqm2/tqYYkRdGjV8mhDE+x23gZE1zpaSV8BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0NFy09eIMaoLAcO9jcuwleoZ4NNmPtrVAfbHhJxm7o=;
 b=TOZAAdPwgmG6PliPt8idQ+1hHNNObOUWLSwq6t29wNfYUJ6VjwAdxhyyM83zfiA+RbazjoU+gflELUfxzm59RGwjRl+cYAAJMDFMTWLk/4euG+IU4VVSuOX5+Pkjq+Yv7wRYaC5xI5ivrzUH1hbftPnNR22PidlgIlLwQzqlRRHna4Kawhc2+b3w7uVJpXYCEDpNxNPdYSuUcsUYAF/VoZadS8Ut/Tu8UgSJlr/+EFLqLDglu66H0X3PYC/VtpTmTNAx8LIBQ5E/FfmfInY35Oho5oMfAkauoGwkRsqiepMNMvHu6kfkrIKk/HhrMzXsMglc/yTbWkVP7rHaGr826A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0NFy09eIMaoLAcO9jcuwleoZ4NNmPtrVAfbHhJxm7o=;
 b=ZjjVKAbmPIPKCxxsET6OzAhe3SD31ubJUSCgo1E8LbVoGkB4jQEoRdaMGAyjcgZBSXebvXSETZgW4m/b+w5kyj3oXesk1pXcwAFxuQTVTBHgDlSWWBQXrebFreZzhfsLEdtrJ2wvM+N4UwjuAsOeLxJnzDzp4vlCb/Gxrhz5i/0=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6430.eurprd04.prod.outlook.com (2603:10a6:803:11b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Wed, 22 Apr
 2020 03:09:04 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 03:09:04 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v3,net-next  0/4] Introduce a flow gate control action and apply IEEE
Date:   Wed, 22 Apr 2020 10:48:48 +0800
Message-Id: <20200422024852.23224-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200418011211.31725-5-Po.Liu@nxp.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 03:08:56 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b08a0d48-1339-4b4d-b5ec-08d7e66a8310
X-MS-TrafficTypeDiagnostic: VE1PR04MB6430:|VE1PR04MB6430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6430E311588889BFEBB781C392D20@VE1PR04MB6430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(6486002)(7416002)(26005)(2616005)(6506007)(8676002)(316002)(4326008)(2906002)(6512007)(478600001)(52116002)(6666004)(5660300002)(66476007)(66946007)(66556008)(81156014)(1076003)(86362001)(36756003)(8936002)(69590400007)(956004)(186003)(16526019);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kqbbspnLXbC1SqA2nOoMGfXI4nHG7j1lZKFbyYdFBR41I80RlG/RAZEONNnhriaEGv7Ta6txMq4J+zdepjhosiAv4puVxSuKvdOgPk4HyufW7nYUlruozyK0W56akY9IpeqAh/9z+yZzq32CuYGcqJDWRHLDYA/OuGAn7hMJUSlNo5UH6gEKVHtWU5f91kR8ypr8rQ7kUDIp3y7WOzwWPIZXd0b498ACx54twIS9HTMa7FWOjPT74wXGjJi2WW8h31XRUENpVymdWkIjDeJXhufwb1Pn4ww1LpQWYGXO1oJXhTbdpPhYkrIt4B+D5jaOrczgZEPoICfKhQ9IUQXul/uyTYG05KH+peNfpVsqi2ucWKbt1yHQwWTRj+25fLyybUO7PTdUp+s8CRhSlXnJeX5xPoh6o15A7RSRlz8sZsQt9B92lhT0ugBskD105J5TX1LFc3OmbtiOuWWTem9JbMh+PcJY6wmmYCXHMMH8jzWwdHA7D1vchb3R5YYUtLU
X-MS-Exchange-AntiSpam-MessageData: G7/mp8HDK4iMJ2/hKj2vRtFM0iPHE4aj+XQY0lo98rhIJSGu7xcZKbal5jjS9fbA6S5lOW716vvsLuAhsv9boqYanUn4HAeauiK1SGhgCWksUcmUihQUmIBKhO+NT5vSm7T4ZQq+xaDNcs/nUOcgPw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08a0d48-1339-4b4d-b5ec-08d7e66a8310
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 03:09:04.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1FVlhzqaV61bWU5eB1TEKeQA97Y9hIfmvRwiNkrXDbr5l3YxXc7doYRpQoZCLuf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6430
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from V2:
0001: No changes.
0002: No changes.
0003: No changes.
0004: Fix the vlan id filter parameter and add reject src mac
FF-FF-FF-FF-FF-FF filter in driver.

Changes from V1:
0000: Update description make it more clear
0001: Removed 'add update dropped stats' patch, will provide pull
request as standalone patches.
0001: Update commit description make it more clear ack by Jiri Pirko.
0002: No changes
0003: Fix some code style ack by Jiri Pirko.
0004: Fix enetc_psfp_enable/disable parameter type ack by test robot

iprout2 command patches:
  Not attach with these serial patches, will provide separate pull
request after kernel accept these patches.

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

--------------------------------------------------------------------
These patches add stream gate action policing in IEEE802.1Qci (Per-Stream
Filtering and Policing) software support and hardware offload support in
tc flower, and implement the stream identify, stream filtering and
stream gate filtering action in the NXP ENETC ethernet driver.
Per-Stream Filtering and Policing (PSFP) specifies flow policing and
filtering for ingress flows, and has three main parts:
 1. The stream filter instance table consists of an ordered list of
stream filters that determine the filtering and policing actions that
are to be applied to frames received on a specific stream. The main
elements are stream gate id, flow metering id and maximum SDU size.
 2. The stream gate function setup a gate list to control ingress traffic
class open/close state. When the gate is running at open state, the flow
could pass but dropped when gate state is running to close. User setup a
bastime to tell gate when start running the entry list, then the hardware
would periodiclly. There is no compare qdisc action support.
 3. Flow metering is two rates two buckets and three-color marker to
policing the frames. Flow metering instance are as specified in the
algorithm in MEF10.3. The most likely qdisc action is policing action.

The first patch introduces an ingress frame flow control gate action,
for the point 2. The tc gate action maintains the open/close state gate
list, allowing flows to pass when the gate is open. Each gate action
may policing one or more qdisc filters. When the start time arrived, The
driver would repeat the gate list periodiclly. User can assign a passed
time, the driver would calculate a new future time by the cycletime of
the gate list.

The 0002 patch introduces the gate flow hardware offloading.

The 0003 patch adds support control the on/off for the tc flower
offloading by ethtool.

The 0004 patch implement the stream identify and stream filtering and
stream gate filtering action in the NXP ENETC ethernet driver. Tc filter
command provide filtering keys with MAC address and VLAN id. These keys
would be set to stream identify instance entry. Stream gate instance
entry would refer the gate action parameters. Stream filter instance
entry would refer the stream gate index and assign a stream handle value
matches to the stream identify instance.

Po Liu (4):
  net: qos: introduce a gate control flow action
  net: schedule: add action gate offloading
  net: enetc: add hw tc hw offload features for PSPF capability
  net: enetc: add tc flower psfp offload driver

 drivers/net/ethernet/freescale/enetc/enetc.c  |   34 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   86 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  159 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |    6 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 1082 +++++++++++++++++
 include/net/flow_offload.h                    |   10 +
 include/net/tc_act/tc_gate.h                  |  169 +++
 include/uapi/linux/pkt_cls.h                  |    1 +
 include/uapi/linux/tc_act/tc_gate.h           |   47 +
 net/sched/Kconfig                             |   13 +
 net/sched/Makefile                            |    1 +
 net/sched/act_gate.c                          |  647 ++++++++++
 net/sched/cls_api.c                           |   33 +
 13 files changed, 2287 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

-- 
2.17.1

