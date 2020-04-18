Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564A81AE92F
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 03:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDRBcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 21:32:35 -0400
Received: from mail-am6eur05on2044.outbound.protection.outlook.com ([40.107.22.44]:6070
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgDRBcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 21:32:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meu/APw62yNZDbmAozCEwFoF14zeY2dGFTr4qz9PUn3SWZ0s1FllVhGqk0ZYWjIm37Mtlk+ID4yf/HOUzsaFPpfrT/rI++im9ScAeJkTJ43AfemEmgrAIN7+e1HmsXQImTzNw1+rwtd1o2Y/4/Ui3NDTdzdYEJQNI0VwDzaEAldM7+F7s6xDBmY6s9VyfQNtrMpN6mhrgqrFPSEzsiYUx5/C39w5V7sFqSwFPUCgfeJUnUY7cRzf9lRDzzPlbfbY06s2ObXFlo1n46+Rhw+dp2osfm4SStHHfTtIEMOdjPVWopmtnjSPxqkozDujVNTM0hw3UV9lX3qNbwZSYJ4X8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Rhxgc0BxLZC52gzZI2TMDf2pWwDEOx0U/EoHQx5HI=;
 b=awdbaESEv/xNcPNwH2T9IZHpFotklr9skN+5q9BG3hErZtRl5x9YiR8Zjp9H/KSts0MPNuqaLsSTjnUuDnlWEg+eA8XpAE6CP7Cj7DfxsTHWN0H1xTtPUSnXksvuq5aY3bYx4Z9Ht28Cija+yqTEHqBhy+SrkkJusFDzFJNfKITkQG5XQm6diLOd8wnjouc4hCA2sOD397XnkiyvfEnyRlf2uIeydBzBIWwDkg1eJwzSAutzRJgRlXW8VA7ueFTGP4j7NTou3aNcDnR1UTbBB3RWlkHjJNlmFfRnF4oGNPwQsGCxTSummNHTfAwm8Mae7aZ+wh7CZeB+QgGWswQ6oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Rhxgc0BxLZC52gzZI2TMDf2pWwDEOx0U/EoHQx5HI=;
 b=aMP4iXoVrJ3EfjlPCz2XyC/1XGAOzq8g/B8D6XnTete/aRj0ZhmiIA/75ourrh+jLO9sFNqrPe3491Y/bDDJGVrY6wGYqQqGR7ZsefO5ekJz5o0dX9ExVrpqi7xzP49oB+5LKiUAudxofrhBMItxtYGlF6yY4xitsU3v4Qh67dE=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Sat, 18 Apr
 2020 01:32:30 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 01:32:30 +0000
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
Subject: [v2,net-next  0/4] Introduce a flow gate control action and apply IEEE
Date:   Sat, 18 Apr 2020 09:12:07 +0800
Message-Id: <20200418011211.31725-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-8-Po.Liu@nxp.com>
References: <20200324034745.30979-8-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by BYAPR11CA0037.namprd11.prod.outlook.com (2603:10b6:a03:80::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Sat, 18 Apr 2020 01:32:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd056a5f-be21-4904-7389-08d7e3385bb1
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:|VE1PR04MB6640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66406A683D5C1AF7470A91BA92D60@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(186003)(1076003)(66556008)(4326008)(81156014)(66946007)(316002)(66476007)(8936002)(86362001)(16526019)(36756003)(8676002)(6506007)(26005)(6666004)(5660300002)(956004)(478600001)(2616005)(52116002)(6486002)(2906002)(69590400007)(7416002)(6512007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcmeaXCMWkCALrMuN48LIiRsN7A90aRqE+FB8aPSTxjTYXVAP6PiIMoBx7W+AhO85/DHAdj6XN4dSQ52O7y/hVQvIkvfwAxleo3yOf6f3HQERbo5qYa6EiKO9S/uiiXvU75z4EqIIlVBi+lqiv8Gv5gHoyb1rKdTJHdMgEDyre9JulY5cr7FD+Y+2QgmpI6iSKEz4iMuLVQ2vncIKXsIZkfdM/yxrlTvPNISX7gFvVV/NLtx23OkTSBBu+qE77DRliHiLNAb0eg3K4+U5epQMd5p3cTbiUQyIEEhE6+Cd6MIBknX2J0nBtn+qRYI2sWr0iXyjou7j0oe2wnK/mJ7Ju7rTQo8T20rrS0X5JUglFYv2F6OnMlcJ0VPv2tpA+m5xBht9hCZX/n18jiI7sBmvndJKMp1xexVjXpG26Kh5odEsc5R5GsSy95cBlyMX2CF140R9KDuM8iov+qSSpT0PuUh83YDG9ZTrENJhBKKdQexI7rwChB8ko5h0nstl87m
X-MS-Exchange-AntiSpam-MessageData: qykllI25tdYDugk0Uyg44tGstPqA7K+PM9m1EPf34K5ki1dnKCQHRBqBFD8kJD5XfrfdWOJ9K4ujtEb5EVXy+XpLM1pp0MEAyhQQfkjXyI78UYVfqnaZ5EK6P06MEaq9KgBORbpiPuscGkW+YbL4Wg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd056a5f-be21-4904-7389-08d7e3385bb1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2020 01:32:29.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4oBf6BHRAIsmXCNPp3bu1glT8RLqN2hWpNl5xHA25ThiNsjDyTzCSSunmHxJ5Vq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from V1:
0000: Update description make it more clear
0001: Removed 'add update dropped stats' patch, will provide pull
request as standalone patches.
0001: Update commit description make it more clear ack by Jiri Pirko.
0001: No changes
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
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 1070 +++++++++++++++++
 include/net/flow_offload.h                    |   10 +
 include/net/tc_act/tc_gate.h                  |  169 +++
 include/uapi/linux/pkt_cls.h                  |    1 +
 include/uapi/linux/tc_act/tc_gate.h           |   47 +
 net/sched/Kconfig                             |   13 +
 net/sched/Makefile                            |    1 +
 net/sched/act_gate.c                          |  647 ++++++++++
 net/sched/cls_api.c                           |   33 +
 13 files changed, 2275 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

-- 
2.17.1

