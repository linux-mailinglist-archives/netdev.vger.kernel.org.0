Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42A190425
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgCXEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:08:28 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:30567
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbgCXEI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:08:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAqjK5WE1JRki4R+agoUI7IfxgvHtR2v9SJPQ7E35EY8AEVp0GDlgsIB4CnI90eDf7Wj/vO9p8vmzjs/AZC+2N5LqDSuS/spPHSDwld9xY29TKXkgXXWzfrtPYDyDeeisftuTEY4CrspO9ck6Gj0Pd3hF0CZTIZ00HWD3eqFe8HLpWsRm7PuA5TKyGwEqEKgoyiKbDttp9Whml159p+OEceB05ddGmxGQ95op6BxPtvNZXEC+y/XwoWvTgK3SDivkJeJMg3gBbP5iFnjGv9kuPyWytZCEyEMLHKKUSHn8ZdEAMmLk87prIsCGmOqO48QZEjc4kFsGegi1WAmXe0djA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhhNrfnlNrJsKoUCOml4SThGzFqJnU0c5XoOcvU5e4o=;
 b=NrbcHcej978AVh4cvrHaEaZ4DWx0hbdUVDWCdmThp3PAGnjtZTemXWupr8JxzsbGGBRNshnXhTf7S+S1Y3K53Ic+htVH8CUUcjMPuhdVE+FrzUtzSXpXpm4Pmy/XqdhNVbkCD+Ji6/3j/7JP/d+XrTHHCuil6HkQ5WFEX23VMxBIzBKwavZKAtO4DUHhUzVdlRS5GA+oUGWf298sAi0amI9OMjvIMXT9RtP2oEFph+DWcvYYhlOMpZq19VvRPjPT7x4wtB1weQJlRIW/8de00zpOoml82TLoBpjJ38dAz1rONmvYwhetbuGNnk0dEFEjr8UaLlmCQFa+UrE2jhzViQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhhNrfnlNrJsKoUCOml4SThGzFqJnU0c5XoOcvU5e4o=;
 b=j8JCbAJxPJNCKQoMxzUrv3bA/FAqahVr35CqJXbUjlQFw5fAy+qoOSF2edpsbV/OCiCgUM3okZszKx6cHkf+GxySXfmwN+Qdo1hgS8wqbDcMuBUhm7FHi1LhQSRK1QaLlNdJgdQovawTC8WJMJnpsvSFzDZzbqdYOQ22iPo6/Ow=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6413.eurprd04.prod.outlook.com (20.179.232.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 04:07:35 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:07:35 +0000
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
Subject: [v1,net-next  2/5] net: qos: introduce a gate control flow action
Date:   Tue, 24 Mar 2020 11:47:40 +0800
Message-Id: <20200324034745.30979-3-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-1-Po.Liu@nxp.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 04:07:26 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2254b2b-cd96-43c7-9b56-08d7cfa8e212
X-MS-TrafficTypeDiagnostic: VE1PR04MB6413:|VE1PR04MB6413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6413D782C8A03BF2A4F76A0E92F10@VE1PR04MB6413.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(16526019)(30864003)(26005)(86362001)(69590400007)(1076003)(478600001)(52116002)(6506007)(186003)(4326008)(7416002)(6512007)(6486002)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(66556008)(6666004)(956004)(66476007)(5660300002)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6413;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cE07VgphFyuWRv70CA8zVYzg/WUEcpb1GauxfSwVlCBB9+T+D6m/94pk4KRpBQcWP3mZG4sIXjD1BVsQUobWD6hX2y3C8X0Vx8/tDpRNWD1kzXO/0WrfZXZGSk1QPFkozq9Ihq5dovicjuzl61ZhJm/RpW7hth7U5Wq3OW7izd7wz8lXoSKdSJB7DhcL5RpoT8+JSkyA/06XtItMjtC9oaNyY9rTbJqadSPl68P7aUKxFfULqjuMOg2qQpF7mQMIO9EMLVlqOkxfJAJGddhKPAodFdpAo3+qhjEo/zaRNPYqFEe0P5Jfo8Uo33knjG96c/z2Yc+LRBLXsoERA3nIf0rCTPiyaapgyPiEtAwXbqYOXBzLE/5YK47n8+xdRTVpl9yqGUe3RJPsTBPwdrHyg6Pot+OHrQkGBhaJHR9WkQ5CE1xK0tNcQ6yQ8KNp2/2kS0iHjj3O7kZHC9uUYpcjnayhzhgkUkKBqCN/wjGow/bFrHXA/fHw8DDTw5Ica1Cf
X-MS-Exchange-AntiSpam-MessageData: UFsf3vfQr5wcWItgERQvR6qEcJjxilqlqWOP3HScX+oZJwSzEa7VuFtpEGiDyOZdRnX91PSmEdwrVhxFMrie6WrtLD5/e2PyNkTiesBVZpM5v6iCNjEhf77AgrtFMqB/h8KQWj2cv3qLkgmo6rZfSQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2254b2b-cd96-43c7-9b56-08d7cfa8e212
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 04:07:35.7706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmhN38c56lid9cuV0Sl9Y7abtNtKf4OeVREWI15aHcImLj86nOAX04r1Qz2Uy1OR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a ingress frame gate control flow action. tc create a gate
action would provide a gate list to control when open/close state. when
the gate open state, the flow could pass but not when gate state is
close. The driver would repeat the gate list cyclically. User also could
assign a time point to start the gate list by the basetime parameter. if
the basetime has passed current time, start time would calculate by the
cycletime of the gate list.
The action gate behavior try to keep according to the IEEE 802.1Qci spec.
For the software simulation, require the user input the clock type.

Below is the setting example in user space. Tc filter a stream source ip
address is 192.168.0.20 and gate action own two time slots. One is last
200ms gate open let frame pass another is last 100ms gate close let
frames dropped. When the passed total frames over 8000000 bytes, it will
dropped in one 200000000ns time slot.

> tc qdisc add dev eth0 ingress

> tc filter add dev eth0 parent ffff: protocol ip \
	   flower src_ip 192.168.0.20 \
	   action gate index 2 clockid CLOCK_TAI \
	   sched-entry OPEN 200000000 -1 8000000 \
	   sched-entry CLOSE 100000000 -1 -1

> tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. gate state is
"OPEN"/"CLOSE". Follow the period nanosecond. Then next item is internal
priority value means which ingress queue should put. "-1" means
wildcard. The last value optional specifies the maximum number of
MSDU octets that are permitted to pass the gate during the specified
time interval.
Base-time is not set will be as 0 as default, as result start time would
be ((N + 1) * cycletime) which is the minimal of future time.

Below example shows filtering a stream with destination mac address is
10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The gate
action would run with one close time slot which means always keep close.
The time cycle is total 200000000ns. The base-time would calculate by:

 1357000000000 + (N + 1) * cycletime

When the total value is the future time, it will be the start time.
The cycletime here would be 200000000ns for this case.

> tc filter add dev eth0 parent ffff:  protocol ip \
	   flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
	   action gate index 12 base-time 1357000000000 \
	   sched-entry CLOSE 200000000 -1 -1 \
	   clockid CLOCK_TAI

NOTE: This software simulator version not separate the admin/operation
state machine. Update setting would overwrite stop the previos setting
and waiting new cycle start.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
Changes from RFC:
 - fix kfree lead ack by Jakub Kicinski and Cong Wang
 - License fix from Jakub Kicinski and Stephen Hemminger
 - Update example in commit acked by Vinicius Costa Gomes
 - Fix the rcu protect in tcf_gate_act() acked by Vinicius


 include/net/tc_act/tc_gate.h        |  54 +++
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 ++
 net/sched/Kconfig                   |  15 +
 net/sched/Makefile                  |   1 +
 net/sched/act_gate.c                | 647 ++++++++++++++++++++++++++++
 6 files changed, 765 insertions(+)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
new file mode 100644
index 000000000000..b0ace55b2aaa
--- /dev/null
+++ b/include/net/tc_act/tc_gate.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright 2020 NXP */
+
+#ifndef __NET_TC_GATE_H
+#define __NET_TC_GATE_H
+
+#include <net/act_api.h>
+#include <linux/tc_act/tc_gate.h>
+
+struct tcfg_gate_entry {
+	int			index;
+	u8			gate_state;
+	u32			interval;
+	s32			ipv;
+	s32			maxoctets;
+	struct list_head	list;
+};
+
+struct tcf_gate_params {
+	s32			tcfg_priority;
+	u64			tcfg_basetime;
+	u64			tcfg_cycletime;
+	u64			tcfg_cycletime_ext;
+	u32			tcfg_flags;
+	s32			tcfg_clockid;
+	size_t			num_entries;
+	struct list_head	entries;
+};
+
+#define GATE_ACT_GATE_OPEN	BIT(0)
+#define GATE_ACT_PENDING	BIT(1)
+struct gate_action {
+	struct tcf_gate_params param;
+	spinlock_t entry_lock;
+	u8 current_gate_status;
+	ktime_t current_close_time;
+	u32 current_entry_octets;
+	s32 current_max_octets;
+	struct tcfg_gate_entry __rcu *next_entry;
+	struct hrtimer hitimer;
+	enum tk_offsets tk_offset;
+	struct rcu_head rcu;
+};
+
+struct tcf_gate {
+	struct tc_action		common;
+	struct gate_action __rcu	*actg;
+};
+#define to_gate(a) ((struct tcf_gate *)a)
+
+#define get_gate_param(act) ((struct tcf_gate_params *)act)
+#define get_gate_action(p) ((struct gate_action *)p)
+
+#endif
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 81cc1a869588..aaa8fb214b28 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -134,6 +134,7 @@ enum tca_id {
 	TCA_ID_CTINFO,
 	TCA_ID_MPLS,
 	TCA_ID_CT,
+	TCA_ID_GATE,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_gate.h b/include/uapi/linux/tc_act/tc_gate.h
new file mode 100644
index 000000000000..f214b3a6d44f
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_gate.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* Copyright 2020 NXP */
+
+#ifndef __LINUX_TC_GATE_H
+#define __LINUX_TC_GATE_H
+
+#include <linux/pkt_cls.h>
+
+struct tc_gate {
+	tc_gen;
+};
+
+enum {
+	TCA_GATE_ENTRY_UNSPEC,
+	TCA_GATE_ENTRY_INDEX,
+	TCA_GATE_ENTRY_GATE,
+	TCA_GATE_ENTRY_INTERVAL,
+	TCA_GATE_ENTRY_IPV,
+	TCA_GATE_ENTRY_MAX_OCTETS,
+	__TCA_GATE_ENTRY_MAX,
+};
+#define TCA_GATE_ENTRY_MAX (__TCA_GATE_ENTRY_MAX - 1)
+
+enum {
+	TCA_GATE_ONE_ENTRY_UNSPEC,
+	TCA_GATE_ONE_ENTRY,
+	__TCA_GATE_ONE_ENTRY_MAX,
+};
+#define TCA_GATE_ONE_ENTRY_MAX (__TCA_GATE_ONE_ENTRY_MAX - 1)
+
+enum {
+	TCA_GATE_UNSPEC,
+	TCA_GATE_TM,
+	TCA_GATE_PARMS,
+	TCA_GATE_PAD,
+	TCA_GATE_PRIORITY,
+	TCA_GATE_ENTRY_LIST,
+	TCA_GATE_BASE_TIME,
+	TCA_GATE_CYCLE_TIME,
+	TCA_GATE_CYCLE_TIME_EXT,
+	TCA_GATE_FLAGS,
+	TCA_GATE_CLOCKID,
+	__TCA_GATE_MAX,
+};
+#define TCA_GATE_MAX (__TCA_GATE_MAX - 1)
+
+#endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index bfbefb7bff9d..320471a0a21d 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -981,6 +981,21 @@ config NET_ACT_CT
 	  To compile this code as a module, choose M here: the
 	  module will be called act_ct.
 
+config NET_ACT_GATE
+	tristate "Frame gate list control tc action"
+	depends on NET_CLS_ACT
+	help
+	  Say Y here to allow the control the ingress flow by the gate list
+	  control. The frame policing by the time gate list control open/close
+	  cycle time. The manipulation will simulate the IEEE 802.1Qci stream
+	  gate control behavior. The action could be offload by the tc flower
+	  to hardware driver which the hardware own the capability of IEEE
+	  802.1Qci.
+
+	  If unsure, say N.
+	  To compile this code as a module, choose M here: the
+	  module will be called act_gate.
+
 config NET_IFE_SKBMARK
 	tristate "Support to encoding decoding skb mark on IFE action"
 	depends on NET_ACT_IFE
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 31c367a6cd09..66bbf9a98f9e 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_NET_IFE_SKBPRIO)	+= act_meta_skbprio.o
 obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+= act_meta_skbtcindex.o
 obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+= act_tunnel_key.o
 obj-$(CONFIG_NET_ACT_CT)	+= act_ct.o
+obj-$(CONFIG_NET_ACT_GATE)	+= act_gate.o
 obj-$(CONFIG_NET_SCH_FIFO)	+= sch_fifo.o
 obj-$(CONFIG_NET_SCH_CBQ)	+= sch_cbq.o
 obj-$(CONFIG_NET_SCH_HTB)	+= sch_htb.o
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
new file mode 100644
index 000000000000..a70dadc4213b
--- /dev/null
+++ b/net/sched/act_gate.c
@@ -0,0 +1,647 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright 2020 NXP */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <linux/rtnetlink.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <net/act_api.h>
+#include <net/netlink.h>
+#include <net/pkt_cls.h>
+#include <net/tc_act/tc_gate.h>
+
+static unsigned int gate_net_id;
+static struct tc_action_ops act_gate_ops;
+
+static ktime_t gate_get_time(struct gate_action *gact)
+{
+	ktime_t mono = ktime_get();
+
+	switch (gact->tk_offset) {
+	case TK_OFFS_MAX:
+		return mono;
+	default:
+		return ktime_mono_to_any(mono, gact->tk_offset);
+	}
+
+	return KTIME_MAX;
+}
+
+static int gate_get_start_time(struct gate_action *gact, ktime_t *start)
+{
+	struct tcf_gate_params *param = get_gate_param(gact);
+	ktime_t now, base, cycle;
+	u64 n;
+
+	base = ns_to_ktime(param->tcfg_basetime);
+	now = gate_get_time(gact);
+
+	if (ktime_after(base, now)) {
+		*start = base;
+		return 0;
+	}
+
+	cycle = param->tcfg_cycletime;
+
+	/* cycle time should not be zero */
+	if (WARN_ON(!cycle))
+		return -EFAULT;
+
+	n = div64_u64(ktime_sub_ns(now, base), cycle);
+	*start = ktime_add_ns(base, (n + 1) * cycle);
+	return 0;
+}
+
+static void gate_start_timer(struct gate_action *gact, ktime_t start)
+{
+	ktime_t expires;
+
+	expires = hrtimer_get_expires(&gact->hitimer);
+	if (expires == 0)
+		expires = KTIME_MAX;
+
+	start = min_t(ktime_t, start, expires);
+
+	hrtimer_start(&gact->hitimer, start, HRTIMER_MODE_ABS);
+}
+
+static enum hrtimer_restart gate_timer_func(struct hrtimer *timer)
+{
+	struct gate_action *gact = container_of(timer, struct gate_action,
+						hitimer);
+	struct tcf_gate_params *p = get_gate_param(gact);
+	struct tcfg_gate_entry *next;
+	ktime_t close_time, now;
+
+	spin_lock(&gact->entry_lock);
+
+	next = rcu_dereference_protected(gact->next_entry,
+					 lockdep_is_held(&gact->entry_lock));
+
+	/* cycle start, clear pending bit, clear total octets */
+	gact->current_gate_status = next->gate_state ? GATE_ACT_GATE_OPEN : 0;
+	gact->current_entry_octets = 0;
+	gact->current_max_octets = next->maxoctets;
+
+	gact->current_close_time = ktime_add_ns(gact->current_close_time,
+						next->interval);
+
+	close_time = gact->current_close_time;
+
+	if (list_is_last(&next->list, &p->entries))
+		next = list_first_entry(&p->entries,
+					struct tcfg_gate_entry, list);
+	else
+		next = list_next_entry(next, list);
+
+	now = gate_get_time(gact);
+
+	if (ktime_after(now, close_time)) {
+		ktime_t cycle, base;
+		u64 n;
+
+		cycle = p->tcfg_cycletime;
+		base = ns_to_ktime(p->tcfg_basetime);
+		n = div64_u64(ktime_sub_ns(now, base), cycle);
+		close_time = ktime_add_ns(base, (n + 1) * cycle);
+	}
+
+	rcu_assign_pointer(gact->next_entry, next);
+	spin_unlock(&gact->entry_lock);
+
+	hrtimer_set_expires(&gact->hitimer, close_time);
+
+	return HRTIMER_RESTART;
+}
+
+static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *a,
+			struct tcf_result *res)
+{
+	struct tcf_gate *g = to_gate(a);
+	struct gate_action *gact;
+	int action;
+
+	tcf_lastuse_update(&g->tcf_tm);
+	bstats_cpu_update(this_cpu_ptr(g->common.cpu_bstats), skb);
+
+	action = READ_ONCE(g->tcf_action);
+	rcu_read_lock();
+	gact = rcu_dereference_bh(g->actg);
+	if (unlikely(gact->current_gate_status & GATE_ACT_PENDING)) {
+		rcu_read_unlock();
+		return action;
+	}
+
+	if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
+		goto drop;
+
+	if (gact->current_max_octets >= 0) {
+		gact->current_entry_octets += qdisc_pkt_len(skb);
+		if (gact->current_entry_octets > gact->current_max_octets) {
+			qstats_overlimit_inc(this_cpu_ptr(g->common.cpu_qstats));
+			goto drop;
+		}
+	}
+	rcu_read_unlock();
+
+	return action;
+drop:
+	rcu_read_unlock();
+	qstats_drop_inc(this_cpu_ptr(g->common.cpu_qstats));
+	return TC_ACT_SHOT;
+}
+
+static const struct nla_policy entry_policy[TCA_GATE_ENTRY_MAX + 1] = {
+	[TCA_GATE_ENTRY_INDEX]		= { .type = NLA_U32 },
+	[TCA_GATE_ENTRY_GATE]		= { .type = NLA_FLAG },
+	[TCA_GATE_ENTRY_INTERVAL]	= { .type = NLA_U32 },
+	[TCA_GATE_ENTRY_IPV]		= { .type = NLA_S32 },
+	[TCA_GATE_ENTRY_MAX_OCTETS]	= { .type = NLA_S32 },
+};
+
+static const struct nla_policy gate_policy[TCA_GATE_MAX + 1] = {
+	[TCA_GATE_PARMS]		= { .len = sizeof(struct tc_gate),
+					    .type = NLA_EXACT_LEN },
+	[TCA_GATE_PRIORITY]		= { .type = NLA_S32 },
+	[TCA_GATE_ENTRY_LIST]		= { .type = NLA_NESTED },
+	[TCA_GATE_BASE_TIME]		= { .type = NLA_U64 },
+	[TCA_GATE_CYCLE_TIME]		= { .type = NLA_U64 },
+	[TCA_GATE_CYCLE_TIME_EXT]	= { .type = NLA_U64 },
+	[TCA_GATE_FLAGS]		= { .type = NLA_U32 },
+	[TCA_GATE_CLOCKID]		= { .type = NLA_S32 },
+};
+
+static int fill_gate_entry(struct nlattr **tb, struct tcfg_gate_entry *entry,
+			   struct netlink_ext_ack *extack)
+{
+	u32 interval = 0;
+
+	entry->gate_state = nla_get_flag(tb[TCA_GATE_ENTRY_GATE]);
+
+	if (tb[TCA_GATE_ENTRY_INTERVAL])
+		interval = nla_get_u32(tb[TCA_GATE_ENTRY_INTERVAL]);
+
+	if (interval == 0) {
+		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
+		return -EINVAL;
+	}
+
+	entry->interval = interval;
+
+	if (tb[TCA_GATE_ENTRY_IPV])
+		entry->ipv = nla_get_s32(tb[TCA_GATE_ENTRY_IPV]);
+	else
+		entry->ipv = -1;
+
+	if (tb[TCA_GATE_ENTRY_MAX_OCTETS])
+		entry->maxoctets = nla_get_s32(tb[TCA_GATE_ENTRY_MAX_OCTETS]);
+	else
+		entry->maxoctets = -1;
+
+	return 0;
+}
+
+static int parse_gate_entry(struct nlattr *n, struct  tcfg_gate_entry *entry,
+			    int index, struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_GATE_ENTRY_MAX + 1] = { };
+	int err;
+
+	err = nla_parse_nested(tb, TCA_GATE_ENTRY_MAX, n, entry_policy, extack);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
+		return -EINVAL;
+	}
+
+	entry->index = index;
+
+	return fill_gate_entry(tb, entry, extack);
+}
+
+static int parse_gate_list(struct nlattr *list_attr,
+			   struct tcf_gate_params *sched,
+			   struct netlink_ext_ack *extack)
+{
+	struct tcfg_gate_entry *entry, *e;
+	struct nlattr *n;
+	int err, rem;
+	int i = 0;
+
+	if (!list_attr)
+		return -EINVAL;
+
+	nla_for_each_nested(n, list_attr, rem) {
+		if (nla_type(n) != TCA_GATE_ONE_ENTRY) {
+			NL_SET_ERR_MSG(extack, "Attribute isn't type 'entry'");
+			continue;
+		}
+
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry) {
+			NL_SET_ERR_MSG(extack, "Not enough memory for entry");
+			err = -ENOMEM;
+			goto release_list;
+		}
+
+		err = parse_gate_entry(n, entry, i, extack);
+		if (err < 0) {
+			kfree(entry);
+			goto release_list;
+		}
+
+		list_add_tail(&entry->list, &sched->entries);
+		i++;
+	}
+
+	sched->num_entries = i;
+
+	return i;
+
+release_list:
+	list_for_each_entry_safe(entry, e, &sched->entries, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+
+	return err;
+}
+
+static int tcf_gate_init(struct net *net, struct nlattr *nla,
+			 struct nlattr *est, struct tc_action **a,
+			 int ovr, int bind, bool rtnl_held,
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, gate_net_id);
+	enum tk_offsets tk_offset = TK_OFFS_TAI;
+	struct nlattr *tb[TCA_GATE_MAX + 1];
+	struct tcf_chain *goto_ch = NULL;
+	struct tcfg_gate_entry *next;
+	struct tcf_gate_params *p;
+	struct gate_action *gact;
+	s32 clockid = CLOCK_TAI;
+	struct tc_gate *parm;
+	struct tcf_gate *g;
+	int ret = 0, err;
+	u64 basetime = 0;
+	u32 gflags = 0;
+	s32 prio = -1;
+	ktime_t start;
+	u32 index;
+
+	if (!nla)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, TCA_GATE_MAX, nla, gate_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_GATE_PARMS])
+		return -EINVAL;
+	parm = nla_data(tb[TCA_GATE_PARMS]);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+
+	if (err && bind)
+		return 0;
+
+	if (!err) {
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_gate_ops, bind, flags);
+		if (ret) {
+			tcf_idr_cleanup(tn, index);
+			return ret;
+		}
+
+		ret = ACT_P_CREATED;
+	} else if (!ovr) {
+		tcf_idr_release(*a, bind);
+		return -EEXIST;
+	}
+
+	if (tb[TCA_GATE_PRIORITY])
+		prio = nla_get_s32(tb[TCA_GATE_PRIORITY]);
+
+	if (tb[TCA_GATE_BASE_TIME])
+		basetime = nla_get_u64(tb[TCA_GATE_BASE_TIME]);
+
+	if (tb[TCA_GATE_FLAGS])
+		gflags = nla_get_u32(tb[TCA_GATE_FLAGS]);
+
+	if (tb[TCA_GATE_CLOCKID]) {
+		clockid = nla_get_s32(tb[TCA_GATE_CLOCKID]);
+		switch (clockid) {
+		case CLOCK_REALTIME:
+			tk_offset = TK_OFFS_REAL;
+			break;
+		case CLOCK_MONOTONIC:
+			tk_offset = TK_OFFS_MAX;
+			break;
+		case CLOCK_BOOTTIME:
+			tk_offset = TK_OFFS_BOOT;
+			break;
+		case CLOCK_TAI:
+			tk_offset = TK_OFFS_TAI;
+			break;
+		default:
+			NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
+			goto release_idr;
+		}
+	}
+
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	g = to_gate(*a);
+
+	gact = kzalloc(sizeof(*gact), GFP_KERNEL);
+	if (!gact) {
+		err = -ENOMEM;
+		goto put_chain;
+	}
+
+	p = get_gate_param(gact);
+
+	INIT_LIST_HEAD(&p->entries);
+	if (tb[TCA_GATE_ENTRY_LIST]) {
+		err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
+		if (err < 0)
+			goto release_mem;
+	}
+
+	if (tb[TCA_GATE_CYCLE_TIME]) {
+		p->tcfg_cycletime = nla_get_u64(tb[TCA_GATE_CYCLE_TIME]);
+	} else {
+		struct tcfg_gate_entry *entry;
+		ktime_t cycle = 0;
+
+		list_for_each_entry(entry, &p->entries, list)
+			cycle = ktime_add_ns(cycle, entry->interval);
+		p->tcfg_cycletime = cycle;
+	}
+
+	if (tb[TCA_GATE_CYCLE_TIME_EXT])
+		p->tcfg_cycletime_ext =
+			nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
+
+	p->tcfg_priority = prio;
+	p->tcfg_basetime = basetime;
+	p->tcfg_clockid = clockid;
+	p->tcfg_flags = gflags;
+
+	gact->tk_offset = tk_offset;
+	spin_lock_init(&gact->entry_lock);
+	hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS);
+	gact->hitimer.function = gate_timer_func;
+
+	err = gate_get_start_time(gact, &start);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Internal error: failed get start time");
+		goto release_mem;
+	}
+
+	gact->current_close_time = start;
+	gact->current_gate_status = GATE_ACT_GATE_OPEN | GATE_ACT_PENDING;
+
+	next = list_first_entry(&p->entries, struct tcfg_gate_entry, list);
+	rcu_assign_pointer(gact->next_entry, next);
+
+	gate_start_timer(gact, start);
+
+	spin_lock_bh(&g->tcf_lock);
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	gact = rcu_replace_pointer(g->actg, gact,
+				   lockdep_is_held(&g->tcf_lock));
+	spin_unlock_bh(&g->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+	if (gact)
+		kfree_rcu(gact, rcu);
+
+	if (ret == ACT_P_CREATED)
+		tcf_idr_insert(tn, *a);
+	return ret;
+
+release_mem:
+	kfree(gact);
+put_chain:
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static void tcf_gate_cleanup(struct tc_action *a)
+{
+	struct tcf_gate *g = to_gate(a);
+	struct tcfg_gate_entry *entry, *n;
+	struct tcf_gate_params *p;
+	struct gate_action *gact;
+
+	spin_lock_bh(&g->tcf_lock);
+	gact = rcu_dereference_protected(g->actg,
+					 lockdep_is_held(&g->tcf_lock));
+	hrtimer_cancel(&gact->hitimer);
+
+	p = get_gate_param(gact);
+	list_for_each_entry_safe(entry, n, &p->entries, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	spin_unlock_bh(&g->tcf_lock);
+
+	kfree_rcu(gact, rcu);
+}
+
+static int dumping_entry(struct sk_buff *skb,
+			 struct tcfg_gate_entry *entry)
+{
+	struct nlattr *item;
+
+	item = nla_nest_start_noflag(skb, TCA_GATE_ONE_ENTRY);
+	if (!item)
+		return -ENOSPC;
+
+	if (nla_put_u32(skb, TCA_GATE_ENTRY_INDEX, entry->index))
+		goto nla_put_failure;
+
+	if (entry->gate_state && nla_put_flag(skb, TCA_GATE_ENTRY_GATE))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_GATE_ENTRY_INTERVAL, entry->interval))
+		goto nla_put_failure;
+
+	if (nla_put_s32(skb, TCA_GATE_ENTRY_MAX_OCTETS, entry->maxoctets))
+		goto nla_put_failure;
+
+	if (nla_put_s32(skb, TCA_GATE_ENTRY_IPV, entry->ipv))
+		goto nla_put_failure;
+
+	return nla_nest_end(skb, item);
+
+nla_put_failure:
+	nla_nest_cancel(skb, item);
+	return -1;
+}
+
+static int tcf_gate_dump(struct sk_buff *skb, struct tc_action *a,
+			 int bind, int ref)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tcf_gate *g = to_gate(a);
+	struct tc_gate opt = {
+		.index    = g->tcf_index,
+		.refcnt   = refcount_read(&g->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&g->tcf_bindcnt) - bind,
+	};
+	struct tcfg_gate_entry *entry;
+	struct gate_action *gact;
+	struct tcf_gate_params *p;
+	struct nlattr *entry_list;
+	struct tcf_t t;
+
+	spin_lock_bh(&g->tcf_lock);
+	opt.action = g->tcf_action;
+	gact = rcu_dereference_protected(g->actg,
+					 lockdep_is_held(&g->tcf_lock));
+
+	p = get_gate_param(gact);
+
+	if (nla_put(skb, TCA_GATE_PARMS, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(skb, TCA_GATE_BASE_TIME,
+			      p->tcfg_basetime, TCA_GATE_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(skb, TCA_GATE_CYCLE_TIME,
+			      p->tcfg_cycletime, TCA_GATE_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(skb, TCA_GATE_CYCLE_TIME_EXT,
+			      p->tcfg_cycletime_ext, TCA_GATE_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_s32(skb, TCA_GATE_CLOCKID, p->tcfg_clockid))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_GATE_FLAGS, p->tcfg_flags))
+		goto nla_put_failure;
+
+	if (nla_put_s32(skb, TCA_GATE_PRIORITY, p->tcfg_priority))
+		goto nla_put_failure;
+
+	entry_list = nla_nest_start_noflag(skb, TCA_GATE_ENTRY_LIST);
+	if (!entry_list)
+		goto nla_put_failure;
+
+	list_for_each_entry(entry, &p->entries, list) {
+		if (dumping_entry(skb, entry) < 0)
+			goto nla_put_failure;
+	}
+
+	nla_nest_end(skb, entry_list);
+
+	tcf_tm_dump(&t, &g->tcf_tm);
+	if (nla_put_64bit(skb, TCA_GATE_TM, sizeof(t), &t, TCA_GATE_PAD))
+		goto nla_put_failure;
+	spin_unlock_bh(&g->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&g->tcf_lock);
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int tcf_gate_walker(struct net *net, struct sk_buff *skb,
+			   struct netlink_callback *cb, int type,
+			   const struct tc_action_ops *ops,
+			   struct netlink_ext_ack *extack)
+{
+	struct tc_action_net *tn = net_generic(net, gate_net_id);
+
+	return tcf_generic_walker(tn, skb, cb, type, ops, extack);
+}
+
+static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u64 packets,
+				  u64 lastuse, u64 dropped, bool hw)
+{
+	struct tcf_gate *g = to_gate(a);
+	struct tcf_t *tm = &g->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, dropped, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
+static int tcf_gate_search(struct net *net, struct tc_action **a, u32 index)
+{
+	struct tc_action_net *tn = net_generic(net, gate_net_id);
+
+	return tcf_idr_search(tn, a, index);
+}
+
+static size_t tcf_gate_get_fill_size(const struct tc_action *act)
+{
+	return nla_total_size(sizeof(struct tc_gate));
+}
+
+static struct tc_action_ops act_gate_ops = {
+	.kind		=	"gate",
+	.id		=	TCA_ID_GATE,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_gate_act,
+	.dump		=	tcf_gate_dump,
+	.init		=	tcf_gate_init,
+	.cleanup	=	tcf_gate_cleanup,
+	.walk		=	tcf_gate_walker,
+	.stats_update	=	tcf_gate_stats_update,
+	.get_fill_size	=	tcf_gate_get_fill_size,
+	.lookup		=	tcf_gate_search,
+	.size		=	sizeof(struct gate_action),
+};
+
+static __net_init int gate_init_net(struct net *net)
+{
+	struct tc_action_net *tn = net_generic(net, gate_net_id);
+
+	return tc_action_net_init(net, tn, &act_gate_ops);
+}
+
+static void __net_exit gate_exit_net(struct list_head *net_list)
+{
+	tc_action_net_exit(net_list, gate_net_id);
+}
+
+static struct pernet_operations gate_net_ops = {
+	.init = gate_init_net,
+	.exit_batch = gate_exit_net,
+	.id   = &gate_net_id,
+	.size = sizeof(struct tc_action_net),
+};
+
+static int __init gate_init_module(void)
+{
+	return tcf_register_action(&act_gate_ops, &gate_net_ops);
+}
+
+static void __exit gate_cleanup_module(void)
+{
+	tcf_unregister_action(&act_gate_ops, &gate_net_ops);
+}
+
+module_init(gate_init_module);
+module_exit(gate_cleanup_module);
+MODULE_LICENSE("GPL v2");
-- 
2.17.1

