Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995171A733B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 08:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405680AbgDNGAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 02:00:51 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:43842
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729075AbgDNGAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 02:00:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgt25y4txcJT1I1wmFFO3q2IzWRrbkXmlwXMU3AXX/R3rBLeD+lUH4oJIdD6ZAMgiXWwxzdJNk1kajGrBZi9MsDPA8vXan5zhNP3+xbysHtWJwViLHp64RVRYzI8aZVV5Nm7i+MQDUAVYTjF6LxBAqC3Z9zjbC0sxYH1EBfYuqtJsEx2P4GQlAxytfrNv2qqK1RKke50gxklfz9eHcnQhGJpiPbP30qfYI9Q6rpbEK8Pd7W1XJVlFeKm/jxX4vVfJRcuiazzYephBM+K8rZb7M3mER1z188Mc/aT0NBK2SwNgYYBFUwlpzcigsR/+Mvkooz9QpAJnj1CDuryY39NcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Rhxgc0BxLZC52gzZI2TMDf2pWwDEOx0U/EoHQx5HI=;
 b=HxscVAUl77a8yuISuiZf0e9Y6Rnkr0Xr9MymcaTq8M/cnu8ZBwjcaqEhKitmxMJNTQHz1q46m6+7xpOJ7os45A8bw+2YXMfZd48pdRq4xASTFRzA3dZ3pP30XpzfdpUIOeraVmOQeDf+PAKBr3+c2hG8aBtvDfr63ANL/isW1CfwxPnH14iJ4zU9AgwyPfVLVI9tsYxFDZl7Nvu+wYwIVaDJYxP7a5iWwtnXn7v4H9e7jyNZr+3zL2Ii8ZLRrMOcziqqeOAgzWe71zRIYUMpztKFiByK4yPOtHDBe/YnzIxT5pbYYnYL6xQ49hGPQLUT8+PJWNOJ6q/N1RCD0c1f3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Rhxgc0BxLZC52gzZI2TMDf2pWwDEOx0U/EoHQx5HI=;
 b=iQdFUpNp+JeGDe8nI3UzV7q1FN6KgBqSumijlRGB0imL8lYA3kSqWBiizY4SV0rU7O6TesQlB9WEurUDlZkDl4ScrES0JKlFXUdNHTCgXoBP4C6MWockCA1jEtKRWqF96ZZM2YW8wN81fVhLCGFlhytyVM9hciE3MTDopyD6HJg=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6749.eurprd04.prod.outlook.com (2603:10a6:803:129::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 06:00:45 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 06:00:45 +0000
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
Date:   Tue, 14 Apr 2020 13:40:23 +0800
Message-Id: <20200414054027.4280-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-8-Po.Liu@nxp.com>
References: <20200324034745.30979-8-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0173.apcprd06.prod.outlook.com
 (2603:1096:1:1e::27) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0173.apcprd06.prod.outlook.com (2603:1096:1:1e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 14 Apr 2020 06:00:37 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6ea9008-cd69-4c46-f50c-08d7e0392bf1
X-MS-TrafficTypeDiagnostic: VE1PR04MB6749:|VE1PR04MB6749:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6749287EAB54C1888D26097B92DA0@VE1PR04MB6749.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(52116002)(2906002)(6506007)(956004)(81156014)(498600001)(69590400007)(6512007)(2616005)(6666004)(5660300002)(8676002)(8936002)(186003)(6486002)(36756003)(66476007)(16526019)(66946007)(7416002)(1076003)(26005)(66556008)(86362001)(4326008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+P1ebgGi3I4Q1Yby1dIhOKzaIyGoBeYssK3ON/o9EqiDZyDwEGWqk2cQ0MUT9cmZF/NneqiC24wYsZY1GHemXtMc+yf3vhaMeui9H4ENp2tZF1lcIvaYuLJpLDy8WNIB9s5ruAp/UedFI6uIW3UgfQ1KXO2ktzDJ9iIeg1FT3y4LF1WmSDocYizDgKp/dhiGlniufF4GHWdmP9IIKbT+QvyamX8WuhDfzbdnK56qYcJqn6xu9jOWK8T6nTD1WSQ2heFLSYwimmPqRGxATBYT+dGZIPFAJr1k0DyH7k7EjTFQf3TD1xhvyV9FEzmJiawuXH1w2wMBfEY8Uv06ncXmyAqHjBRWPqYLdH8ot/9XX8QL5I+AyaV5+sfdOUlSPU4Us3Pi0tGWBW7q4pd46KtymO4DSGC/U7MOxnLxKwngeey89Mzc9hY6xaMn+uneNf4PuX2p2910UkjrCT1xJxqZdjmJo5+E9D3jtUH1e2aM1MJ1ppoEXL2xeASZYDkZE2U
X-MS-Exchange-AntiSpam-MessageData: HF20Hl6hGdWBCu9l3dkCVOycni5PTuGEE4y1+r21UkALtD2iPetN7UAWOgl/FXxxphn5Wq78d4CT7DH8JTNyfadxr3ndm5H8b1i9//aK1ha88qQ4cG+FnfZ+6dH6mIRsjmMez6LKHgdTIMiAvs2WHg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ea9008-cd69-4c46-f50c-08d7e0392bf1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 06:00:45.5307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRcjoS/aN422e05+Zu+9/E1sy77e1+wYkDbUx3gsqw5BPB6gMWVVFSYzgQn2ReJW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6749
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

