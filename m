Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3E1BB4D7
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgD1Dzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:55:44 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:6260
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgD1Dzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 23:55:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAH7ETlzapIYzDlgflr+fe7wiZ4yeAZMADdPYb5Y0gtTW5z5buTPpZPvjsd/iTdsbUX/ufoittO873w1cuocedkN/qaXqRNlur5fHbSTKPJu89Pul03UJjYZCKapvfN/5JSyJczrENMm0F33fY0yBUhTUu+18qj+Z38FRuNqwnhJM2Y4wA9qgPDLUhJBY2kWvqxjTlhtov4m5QPzjGn7rWefa8vBd5YCCsQt3gzOizj7ExqAeoii4hbme2dvoTjBPJAQkH5sKnZTg6SaACW7DnDpMIucVlf7jcaApNrdeQr7Sv5MxRfgNPxus5l81hGU2b6zeVdcJZHM9grjYiMCKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yP0G6A8Ws5IvFWzjYrQihxbaUBt2d9A8nlIKjvlRSs=;
 b=h2DeqTtklaQs4rutz/0g46Q4721d24s42hJ3QG9sGv4u0aoIHJ5gzX2mM5nhTPZn7QXZqaz0qAGvtJDcHoQM2Yi8OK+DmhD6Bu9PhuR4wnRsUzBH1ZpaBmiIWleOUsD/ctMln08TRLdpSxNbAK4sogOv3orfNtjAxnHE6IoKwbXnmS0reV3QUr0rGsbOQZ5+IPFKn/uXc/2ULmvAXbeKQ7jx63vKOX6h/Y/hpjJhhZ+zXC+61doyPHEOXD734bvF+2gUDSej4hKMULWTgbeaApbsREFuNWvv4QOnn5INsnSku9Tyx5kD5/FLzUk9KiE39VT3t7F0omJP2YjPL/ZnyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yP0G6A8Ws5IvFWzjYrQihxbaUBt2d9A8nlIKjvlRSs=;
 b=QMuGbDsLT7cryekp4iZQaWjeYPocl3T+tmMb7pSu6H0LDpiFQBR7BckUNtdq7mJwKQG3DauUckYgsLQzC8sERgnjBQJZqfrQ7GEWQ0kERyZgNIJQGAJjXvYuJZ4gzZDvidETxte+yT2vA0jDm5vXyk8GocAviMRR/6qpWq13RXk=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6445.eurprd04.prod.outlook.com (2603:10a6:803:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 03:55:39 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 03:55:39 +0000
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
Subject: [v4,net-next  0/4] Introduce a flow gate control action and apply IEEE
Date:   Tue, 28 Apr 2020 11:34:49 +0800
Message-Id: <20200428033453.28100-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422024852.23224-5-Po.Liu@nxp.com>
References: <20200422024852.23224-5-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR04CA0198.apcprd04.prod.outlook.com (2603:1096:4:14::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 03:55:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bb31a9e-a770-4fed-f4ed-08d7eb280296
X-MS-TrafficTypeDiagnostic: VE1PR04MB6445:|VE1PR04MB6445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB64455C2F672496ED54B5F7A192AC0@VE1PR04MB6445.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(6666004)(52116002)(478600001)(69590400007)(16526019)(1076003)(6506007)(81156014)(6486002)(8936002)(8676002)(316002)(5660300002)(186003)(86362001)(956004)(2906002)(6512007)(66946007)(2616005)(66556008)(66476007)(7416002)(4326008)(36756003)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9q2pHpg7tmxnjzsw1uCmIUmlpa9t37/22HA+oU2XSY3YJ7gSNzXWBCsOFjbMdgPeq2l85K0yIqKcmCVDlW21hw7qGH2ODgCJFLPtS/ZnjqjE06olHZZ7wAhj9XHRNbLrmHHgFNaexImmE9TMExV4SAX5WUvEGedvDTfe5f5uBiby+WlSHpbIHz8JwEPnow7J+LSmirMJ7G0JurGUIUhv1VtvW4n572j/U+pReAcWpuEg3F+3VnbxpX82EVh7RxYBmf0WCGACehqYElzYtIPyYEPnPbi7VGhh7+TUHAJ1HNWiuQ60gxHNaqW31q0af5JLPWUsqwHbZHAR/934LOsZG0C16+NDBbB6DzqOIKT9R4AeXGQdbRkT6bj/9bz9mPZXe+0/v3ORsHhoYZp3jPAig1VJ8VRq6DLWk5VYvVv9oBTQMY0ZvTVSjKpDw2cJSa+rdP1xsNEUc9U75pPq+ekgOzkfXdG61vQjISlW1Zv4U3ECTmctaNclAJCSlTXjlMM3
X-MS-Exchange-AntiSpam-MessageData: keiheE3k0IQ8ClH2XsYk80vvlgY7do3VAkXHgJsy/iszQP4AyhO/g1E12CH7pJ1dfdpR7wbgrHkc6LCT8iO6DLfmfyLxWmGN8SLZMumzWvJ3DqPvhwo4PsJng+3h9i1NYQDKpSqH5b/Wv6nOhEJrg447HS6ESQkhFso/7ms0S9Wgmxy+72+vLhJzi9G4yYEuOwQfZ/UlbcBvCQnxElry1U6N3q/m9gdkGMGwYiKJ10dvIxbKkUBl3Gu3t5lqApGXqU4Z+TOVOBhPrmpUF9vG+ZMjFdefDDSEfWvSIPQhjfXVfeKTzDJP3sqF03lvWC3Yh6BOCsY4znKFGZ+0KhXRChatpnQUwvrc9bdp/4jRsLrKXbVvdwMWxYKlLHonz6uszKZjewzHCxFSaTRvl8GWtfuDx6cejnTRxMkKnv1LnQjr6j/ltZU8scUvVxlRv+65jhMZz/dkZcjxA6hsBnewL8GsOfWsc+bXjPzFEouvX0hSp/oXTM02u/tT1HN5dQRj3HhCU6Z0QUG6is7azpboT54Y5YW1nS4gIadUJj4Ojy2XFOYspx+ZUKX9LEy+6QZmlTbkfSXHXgUJl0ZF3uo0cx1FLeY3RAnQSiMzRes4jdkeyijJXzztsdiXKngB9f13GguqvyK7JH/PkZ9iFtXI/PXqIkgxrT322M1kNZfNjeHTTs713NpmCL4Cw/d79jLJhADC5Zm+sOu5icUwSpkYi5KHq2oz9ZSdvA3guDH1m6UWYt8K8rHmzlC+0i2rnjiw5ZsfQO1iju217miAR/xLqJz0fmcXhhf3ln+MnlRTAKQ=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb31a9e-a770-4fed-f4ed-08d7eb280296
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 03:55:39.3408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/MdTpRAzALqLWd7QqItWlgEACBBXqEuahTPsTBwoeL2tDGk3lPDawNRZGqZ2Khk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from V3:

0001:

Fix and modify according to Vlid Buslov:
- Remove the struct gate_action and move the parameters to the
struct tcf_gate align with tc_action parameters. This would not need to
alloc rcu type memory with pointer.
- Remove the spin_lock type entry_lock which do not needed anymore, will
use the tcf_lock system provided.
- Provide lockep protect for the status parameters in the tcf_gate_act().
- Remove the cycletime 0 input warning, return error directly.

And:
- Remove Qci related description in the Kconfig for gate action.

0002:
- Fix rcu_read_lock protect range suggested by Vlid Buslov.

0003:
- No changes.

0004:
- Fix bug of gate maxoct wildcard condition not included.
- Fix the pass time basetime calculation report by Vladimir Otlean.

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
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 1098 +++++++++++++++++
 include/net/flow_offload.h                    |   10 +
 include/net/tc_act/tc_gate.h                  |  160 +++
 include/uapi/linux/pkt_cls.h                  |    1 +
 include/uapi/linux/tc_act/tc_gate.h           |   47 +
 net/sched/Kconfig                             |   12 +
 net/sched/Makefile                            |    1 +
 net/sched/act_gate.c                          |  637 ++++++++++
 net/sched/cls_api.c                           |   33 +
 13 files changed, 2283 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

-- 
2.17.1

