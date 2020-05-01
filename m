Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ADD1C0B89
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgEABOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:14:16 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:18085
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbgEABOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 21:14:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1oiDtTeTYxtVXnDzwhmKH6+fDVWEdXYwDCNYTrJbUlv0d/pKppH7JPLu606PfPEy6hOKnuF+he9Z2emV4DbBui3WaYWhy6bNyXPFD+xkmSa3pUkSCIWM6sPxc7IGazfJb8cFz/m1dIlnJb48gEWh5BTchO5xGDvWNTxqyzRlr3wK0yGPgC5jh36vuVWikonDj53HWAgIUnmvU8TtzTBo+wjxN9Qfe/ADxtR9t4JYoqzQZ9QyYXWwxm/OH05dBTZsG+VhhWjqR0aUuXd0HNLTlaPRoVCS6VAyrwLCwQb0E/uFLf7CtaMAffoiRF4F3seNL2v3fD5j5n1HnY+fyEWEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPh1YX7kUFTg/8oyMuR+gJoqW4MK/ymQtEwEMVCpm4g=;
 b=Y+RlAqAU5X1SDlnwFLemcq9/UTSikeGQbDl4rZW16RXZj6bQi++SC5V6w6//BTcPRfxSd6WudoJZLtE9XDDn0bW7Asg9rLNBsVMep3g9HX5anQCuSBCapaQ4sLnFfOKuD5kyoy9Vp7YVxPw67FUB3We63/xVrcrwx/I4nuKMEGypTBli0XaA5MUUIsviORImU4nLigrMEDfSMXk5HWiC+0lp+WkNPFKhoetMx1rauMlRxwtb1/nGiKlAtkxd3g7RcPdffHzfbOzb3mSMRwekJwxNVTUI3cm2Y+1wRX5FPGdKMqXDLKV5rSXXdmKgN5qTHCVm0BQVv7lrXe/8/6+NNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPh1YX7kUFTg/8oyMuR+gJoqW4MK/ymQtEwEMVCpm4g=;
 b=JSqLQ+VjiZH2uGpwOX1csBgTJxSyMAIpi9hLIk72mFFfAzPBJLR7gLcMKhoW1/j5A05GeiC0g+0S6sQBc3YDnv6g4ITBtDoptch2alQ8nkuS28GjvBH72z1iNcPKQU0Y4AnHDy08gct1TXG6tmyBxVN4PzCOb/Jvcd7CukgLJ18=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6734.eurprd04.prod.outlook.com (2603:10a6:803:121::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Fri, 1 May
 2020 01:14:09 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Fri, 1 May 2020
 01:14:09 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v5,net-next  0/4] Introduce a flow gate control action and apply IEEE
Date:   Fri,  1 May 2020 08:53:14 +0800
Message-Id: <20200501005318.21334-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428033453.28100-5-Po.Liu@nxp.com>
References: <20200428033453.28100-5-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR03CA0108.apcprd03.prod.outlook.com (2603:1096:4:7c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.16 via Frontend Transport; Fri, 1 May 2020 01:14:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28532921-f373-4423-2999-08d7ed6cf2f7
X-MS-TrafficTypeDiagnostic: VE1PR04MB6734:|VE1PR04MB6734:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB673468C95A4A96B9C3F3178A92AB0@VE1PR04MB6734.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wg/h7e32xJoapHcePDnl+L8XoVx9HZ80fCIjlNJzGqwVSfElhT48A8eK/xY9Xkoc9QLbcE+36TwSeaHSzrd4J0e9iOTJLxG1O6f1n+GK2/ykqPqQL4UnITq4ukmm0YWYBb+EwOcmUlKwdqQCRiR15T2z2Cvmn+eQVuo1a3c/w9trLtMlF6nCU09Kw4PUujGZMB4I4Mnbe//hNp2Q/Z2FCRLmj795yaGG/XxMCYqH0ovDRYjYvUIYjMOLLgnpyExvA0mG0lPHeTop6Lq5k46qhk2mQy1JENaFK7hxdXwe7gk6zctWXZIZPrLVfo+T78LbCkjIIPRvVZV68SVKaVmnL7nqUosD8MqKZFHUSW7Bn+pMngVnLLdq8zehHAJfB4nLJGgE0pUrBCjZoGbbDXWLqLoFoDDiNArA2U74D88Ajk9PtLL4W3ryq82LUNijQypw1DiqfN+Qe6C4HkFvWrIA7zwId9bO5G4zLKyGH46JVl/mTQTi3B+plfmBQpn4aJP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(16526019)(186003)(36756003)(478600001)(26005)(2906002)(4326008)(8936002)(6486002)(86362001)(52116002)(316002)(7416002)(6512007)(6506007)(69590400007)(1076003)(6666004)(66476007)(66556008)(2616005)(66946007)(956004)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RF5UzkYRu0degk6YRgeILrn1zaiKqOY4QUV1Pr82cOIHUMb6Brueu5UwxdE/u9cIoO63HiacnvsPNsS6iaLhbq9JBy7csMg90Lhh9FpYgUSro3Eoq7XBxmP99ydvGJlgMcjW+190bRqXmd8XR5lZlvGLH0GcgWGqEreFpMGXWngfwUn+R51xRun2un3OBJ5vwIWZQV97Wn1uJt65c3VUIAzKyIdbyF3slxeiOCu//N9e5O2zioRtxqiN6E9xv9Gc8eA/cuQI+hQfrYtCKFBuCLfypaALki4XjZ7dWs5Ww5ce+KH7iEfCEvOUCRnRdEGr6cZNSjQnVVQRorHzv4BDv/+JZlUEZfo0BAXgnpelthfEpJPpR6SkEmLIpdNUKXWeV7wYk69etvNHzzqtNFWRyOs/vtrQNY8U/ZriXL2ksp/FyYVRgGw7ioNe9ul7UWBF77MwobhKkG60VEAvLOysZiN54lE/fS2enwcxC50whqSLuANdNUXI5mm8+SNZYDVhPGhzQvoVCTo4uyLkqp2NimFOFPBp0pWWpJrEH++ZOB5NULWiTnmXaKR5g1kkohAwoTHsVn0nNbmwDhQfm4+jsriHqie2Xmnf+9n6Q/VVsMhdrqoHdbNXvESgRhReQrBxwzxiNDmsS0iGqDuhNMUlaGSvu5sER/dRbo/K6eb1UqCF4CAVnfrArYgofjX4TF1EGhWV1GVv4G84+/AuLymLylH5PnOM5NnH2bY2PiPOlPA6v56JIXLHKi7+903XOtCpBHh3TynV6KrDLn1xx/xPScc/LFAmFEZ9PFP6EyCWqXg=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28532921-f373-4423-2999-08d7ed6cf2f7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 01:14:09.0316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmgQKgMURw80J0ouFMtjKpVTI9RFJVOjPSHvp3bol3bXzMWvIzFczXO1Lv99DQH1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6734
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from V4:
----------------
0001:
Fix and modify according to Vlid Buslov suggestions:
- Change spin_lock_bh() to spin_lock() since tcf_gate_act() already in
software irq.
- Remove spin lock protect in the ops->cleanup function.
- Enable the CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_PROVE_LOCKING checking,
then fix as kzalloc flag type and lock deadlock.
- Change kzalloc() flag type from GFP_KERNEL to GFP_ATOMIC since
function in the spin_lock protect.
- Change hrtimer type from HRTIMER_MODE_ABS to HRTIMER_MODE_ABS_SOFT
to avoid deadlock.

0002:
Fix and modify according to Vlid Buslov suggestions:
- Remove all rcu_read_lock protection since no rcu parameters.
- Enable the CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_PROVE_LOCKING checking,
then check kzalloc sleeping flag.
- Change kzalloc to kcalloc for array memory alloc and change GFP_KERNEL
flag to GFP_ATOMIC since function holding spin_lock protect.

0003:
- No changes.

0004:
- Commit comments rephrase act by Claudiu Manoil.

Changes from V3:
----------------
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
----------------
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
-----------------
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
 include/net/tc_act/tc_gate.h                  |  146 +++
 include/uapi/linux/pkt_cls.h                  |    1 +
 include/uapi/linux/tc_act/tc_gate.h           |   47 +
 net/sched/Kconfig                             |   12 +
 net/sched/Makefile                            |    1 +
 net/sched/act_gate.c                          |  636 ++++++++++
 net/sched/cls_api.c                           |   33 +
 13 files changed, 2268 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

-- 
2.17.1

