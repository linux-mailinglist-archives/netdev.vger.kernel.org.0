Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C396D17BDE9
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCFNO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:14:58 -0500
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:21314
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgCFNO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:14:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsWQTpCDRNmo36mOWyDP6yq0MDtal4U/zhtEjsbyrMhcOO82+o7uvBt1/HQ16eiro2qKQ/Dxy3PBb9rhIQsfB+eusZSa9hrdgjZb94UHriUKI9ABJstpTLBjF9jAVNSATBCqGmHhDm3uR0ISyk/Okbj1p0SQGOtH3/GuhCet1RWsg9KuLtNLyW1iheTaZ1381gZKCNs10hZqGjl+wEeQ5a2YYUgb7z31eey1xRVHH6lxFPQgi783UCcG4N2bZtno+f3iLdXp3mVLU7kIKhR+63zqBXit6GajWlpj/zNVI9K68AMS2BVi/zfAGSoXYhQ3WxcEe26FfifA2qgfMIA2jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRydocVkiwaR2uc7YUNjpuArpw0iXRyGDrhTdXOzOpU=;
 b=GdWvj2QlbWMEMlU8AxAndocHCKcpS4I2bqfAQCgr0f5YT5U1hlIIT+/w8kfiJfBAvl2mA3RyZ5OkWgKkPVbB0glXzRfY+0wUqGEq6QOK4x1fKHlAggzu5FlK4iXGJ06tJp7klKTo3cu/HqMtY27n325Dl3V0jtnfFOdhlT4slqfzpN9FXYFLyfREES59tHNmuyMHQzsnG8E+EY3xiDTq7umwzVmJdv78aKWLvfEhZntDqIrAvrWyKff6ccn31oDJtuhqYXrGV5RmOVARJwI6XJK+lxLAwA88BRndrxIM7zsUjWsoqt/3q1FUSlye7XBZYwY/Bb/ymtvy0QdiJs80xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRydocVkiwaR2uc7YUNjpuArpw0iXRyGDrhTdXOzOpU=;
 b=oy+xJvYAhQ6hSQfTiJ0XsJMzOQ7+uZ5c/GzCAZC/ACxdqiHNTK9hAR3nWFv+adO/jK8ZbfIFPXN1qqasVd6DUwftWYiiB/ZoevOXbWrxNT2l5zrfshd2zcVH8hoDLU22VOfk3dtyMv2gYRPBWMaQloNyE9VwzkwXFg/d9jUIMBI=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6718.eurprd04.prod.outlook.com (20.179.234.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Fri, 6 Mar 2020 13:14:50 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:14:50 +0000
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
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  2/9] net: qos: introduce a gate control flow action
Date:   Fri,  6 Mar 2020 20:56:00 +0800
Message-Id: <20200306125608.11717-3-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:14:40 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59d85aad-47e4-448e-bad9-08d7c1d05998
X-MS-TrafficTypeDiagnostic: VE1PR04MB6718:|VE1PR04MB6718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6718D3B5EB71576A0C84DB5292E30@VE1PR04MB6718.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(199004)(189003)(36756003)(5660300002)(66946007)(66476007)(66556008)(6666004)(478600001)(316002)(2616005)(86362001)(956004)(4326008)(26005)(6506007)(6486002)(6512007)(52116002)(16526019)(8936002)(186003)(69590400007)(81166006)(1076003)(81156014)(7416002)(30864003)(8676002)(2906002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6718;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: roIL54SqVlmm6aZi17FL9P6NUqeXuRLo6LQ17xBOupxsOascuRONv3UEDlHThYEK28VaOTgTPfEo3UzQumeKtPsikUGQylQ38fzSa1MK8xrRJN+h4e+WxRjXiX6+POFRpzWT21YK4wZMS6RZEvEBUsH9EOH5FVzSEGnknfVP/nare0aPisPiT9/FqSyDkL5SRxP6n6/7yHzc7tyKDg54rydtT4o7aBAkR1vhXMq/lhMlpsul2oImPELtZ8k+8cWx3B407BfBw+TZJug+qtcX7qjMhxwx6YwXqO/eF6oyovqMY6Tpp5aQLH7bW7D7XMzmS9Ompf3fZfmybBYPMcg+ufrX5dJ8t+3SK6O6kg+Xr6LEwctd4X8PhlIQMs0AO3WCn8QvpIU67TOfF3IXKiWb8ExLnfXY3Rl1f1G7/DqEq77u1wyWi3u7Q5wGz2esHI7aS7h0Nq0l6ZBh3N0lWnaVoXhOBDOcMe1Kbh8RLKUkkc+yw6UrRobaiAR5ZFZLsET1AsTb0yUqNKINE7zruCf1VA==
X-MS-Exchange-AntiSpam-MessageData: HK9lginrwaPX8gH6NY0pe6zkBsJ4pv4BKCdL663q00p4qYOdYgk2pErjl5yifMAkRJERnCU2bSGS7zCPJ0GHNaj1gensmZq7YizEXQbX2z7L2Fh9Mt4DWZ4sLy74FUpy+LR00b/nddlz8c00Q8V+sw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d85aad-47e4-448e-bad9-08d7c1d05998
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:14:50.5009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90g4KNiyKoun20Nvn3Zno3gEN3RqDzOIndDi5laHU0VzbIEpqulgBZv0VZzT/0iA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6718
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

Below is the setting example in user space:

> tc qdisc add dev eth0 ingress

> tc filter add dev eth0 parent ffff: protocol ip \
	   flower src_ip 192.168.0.20 \
	   action gate index 2 \
	   sched-entry OPEN 200000000 -1 -1 \
	   sched-entry CLOSE 100000000 -1 -1

> tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. gate state is
"OPEN"/"CLOSE". Follow the period nanosecond. Then next -1 is internal
priority value means which ingress queue should put. "-1" means
wildcard. The last value optional specifies the maximum number of
MSDU octets that are permitted to pass the gate during the specified
time interval.

NOTE: This software simulator version not separate the admin/operation
state machine. Update setting would overwrite stop the previos setting
and waiting new cycle start.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/tc_act/tc_gate.h        |  54 +++
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 ++
 net/sched/Kconfig                   |  15 +
 net/sched/Makefile                  |   1 +
 net/sched/act_gate.c                | 645 ++++++++++++++++++++++++++++
 6 files changed, 763 insertions(+)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
new file mode 100644
index 000000000000..932a2b91b944
--- /dev/null
+++ b/include/net/tc_act/tc_gate.h
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: (GPL-2.0+)
+/* Copyright 2020 NXP */
+
+#ifndef __NET_TC_gate_H
+#define __NET_TC_gate_H
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
index 449a63971451..d1f36a3f94d9 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -112,6 +112,7 @@ enum tca_id {
 	TCA_ID_CTINFO,
 	TCA_ID_MPLS,
 	TCA_ID_CT,
+	TCA_ID_GATE,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/include/uapi/linux/tc_act/tc_gate.h b/include/uapi/linux/tc_act/tc_gate.h
new file mode 100644
index 000000000000..e1b3a7f2ae7b
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_gate.h
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: (GPL-2.0+)
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
index 000000000000..c2c243ca028c
--- /dev/null
+++ b/net/sched/act_gate.c
@@ -0,0 +1,645 @@
+// SPDX-License-Identifier: (GPL-2.0+)
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
+	struct tcf_gate_params *p;
+	struct gate_action *gact;
+	int action;
+
+	tcf_lastuse_update(&g->tcf_tm);
+	tcf_action_update_bstats(&g->common, skb);
+
+	action = READ_ONCE(g->tcf_action);
+	gact = rcu_dereference_bh(g->actg);
+	p = get_gate_param(gact);
+
+	if (gact->current_gate_status & GATE_ACT_PENDING)
+		return action;
+
+	if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
+		goto drop;
+
+	spin_lock(&gact->entry_lock);
+	if (gact->current_max_octets >= 0) {
+		gact->current_entry_octets += qdisc_pkt_len(skb);
+		if (gact->current_entry_octets > gact->current_max_octets) {
+			tcf_action_inc_overlimit_qstats(&g->common);
+			spin_unlock(&gact->entry_lock);
+			goto drop;
+		}
+	}
+	spin_unlock(&gact->entry_lock);
+
+	return action;
+drop:
+	tcf_action_inc_drop_qstats(&g->common);
+
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
+	[TCA_GATE_PARMS]		= { .len = sizeof(struct tc_gate) },
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
+	if (tb[TCA_GATE_ENTRY_GATE])
+		entry->gate_state = 1;
+	else
+		entry->gate_state = 0;
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
+	err = nla_parse_nested_deprecated(tb, TCA_GATE_ENTRY_MAX, n,
+					  entry_policy, NULL);
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
+static int parse_gate_list(struct nlattr *list,
+			   struct tcf_gate_params *sched,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *n;
+	int err, rem;
+	int i = 0;
+
+	if (!list)
+		return -EINVAL;
+
+	nla_for_each_nested(n, list, rem) {
+		struct tcfg_gate_entry *entry;
+
+		if (nla_type(n) != TCA_GATE_ONE_ENTRY) {
+			NL_SET_ERR_MSG(extack, "Attribute isn't type 'entry'");
+			continue;
+		}
+
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry) {
+			NL_SET_ERR_MSG(extack, "Not enough memory for entry");
+			return -ENOMEM;
+		}
+
+		err = parse_gate_entry(n, entry, i, extack);
+		if (err < 0) {
+			kfree(entry);
+			return err;
+		}
+
+		list_add_tail(&entry->list, &sched->entries);
+		i++;
+	}
+
+	sched->num_entries = i;
+
+	return i;
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
+	err = nla_parse_nested_deprecated(tb, TCA_GATE_MAX,
+					  nla, gate_policy, NULL);
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
+	kfree_rcu(gact, rcu);
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

