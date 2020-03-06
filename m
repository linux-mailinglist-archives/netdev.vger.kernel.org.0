Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7336A17BDFE
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgCFNQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:16:33 -0500
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:32801
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgCFNQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:16:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xmgb0msVz1UCGybV/qyGSXkDS/Xoac80IaKwpkFgPeUdsZu9XmskUAM+c62MOtfsskoktoK+PMiYLWkx7xZpWa9j+Jvdv7uVt+UOB9yZeVx8W366IAGe8tg7LoCGxRYx7PCmBTrMWQQ+f70IO4Wvvcn+sS+4+GBNFbYeYRVSym1pXrECa/azD0xv753FxHEVz5hPYRPXAmhMfw/iVcWH4zzC9CyswP0N9XVG+vQ2HR/FtZwQE+Z577hNjvz6JL+/vbp08Sjfhho1Z9rDi3Di9TqIieUwHmumC4TofY/kDakwpWrL6dL1UySgM2qm5h6dJMudPhiIJGrlBEyLomwyHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tye50a4APb/IX0D8+LaDRxuSbQPBpu4H2naP8ljFLZQ=;
 b=d4KU1XPRh3GOUNvqz64dtXTjPNYQ8dZ5o5w7OIh8t5YyffRn+5HyCkA+M/ebNRiKBBXucHFAHudVxq1PtOicclb/q6F8wV4MLvyJtcEIiQE1tfwiQ17QGBVp3mAUnRN6OjmUVwa2LJirl0DHNEZyzxAl+qGFLBx/kV6UxmYlERTwnYIZmuR4tcAy+UPTDo0YdKPz0nGKFlTySyUQSCwIfX1RHk4iLc4bdhPW0ng3R7hFDkRo2vTek32bmcBxneetINEHm4t3gSt/LXm7yGsZwzZkA/CiKBqq0lCe/JGrc4362E3M8xNSoMO2nsfznQQ6s6RXEz7ViDSXCtkzzcbYVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tye50a4APb/IX0D8+LaDRxuSbQPBpu4H2naP8ljFLZQ=;
 b=pFEdvTZbKi51Hag3iH3/BlRLlbU614HULuKKMDxd/FsXiRALRXdfyaIIwzT+KzSUahmIX6mfllLMCrndmNmApZRvkaoAvCpEDd7KUD0SQ/xxXQhG9dsPxaPl8EJwjSY/jmuBVuW8qwY59RcuATr2/ZJgOaAGIE8veKcA13MxnDI=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6527.eurprd04.prod.outlook.com (20.179.233.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Fri, 6 Mar 2020 13:16:12 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:16:12 +0000
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
Subject: [RFC, iproute2-next] iproute2:tc:action: add a gate control action
Date:   Fri,  6 Mar 2020 20:56:08 +0800
Message-Id: <20200306125608.11717-11-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:16:02 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f8865a7-a56d-4650-f63d-08d7c1d08a5b
X-MS-TrafficTypeDiagnostic: VE1PR04MB6527:|VE1PR04MB6527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB652733B96947725C6CE8E76E92E30@VE1PR04MB6527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(189003)(199004)(16526019)(186003)(26005)(66476007)(6512007)(4326008)(36756003)(66556008)(7416002)(86362001)(478600001)(1076003)(81156014)(8936002)(6506007)(316002)(30864003)(81166006)(956004)(5660300002)(8676002)(66946007)(2906002)(2616005)(6486002)(69590400007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6527;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jRnePQtFJzyURkj98VH7hP7Ozw8QC0qrOI4SrYWXCUttZ3LroLQNLZ5rafsJYEP0hzIVcsa/3mb6Att/DFwtiH5oqO120uBf0KbZbMU7RwDbGdsBcNggoWeiGBoJH7QBkn8FxJ8MHhWXu0nuAoA6U4+wdcQRiXMn+zJUbB62ryBxUP8IFkBKrY+xi5T9XQHW+JIdLjC72QOa8qmlSqoFsebhYCGrr4Vw1FruYMgzzNAJYPjuWSXoNiPyioozFmV4E0ZQQNSnAI6M8hUaS2qj/3RjFg72CAlx1670X9q1y30VXPsA3zKjRSE4gdgfFrZLeSHoZ0NNkCOkFNYD6EFU93BKlAGdysOYm3eP+mOGlgOQXzWNI3AXVQbcu6LRfIFeSDN+UIsuFw1owLiI6HN4lckvUPoy6J/TVkvKmwLwpqrM8uWY+XBK/rhOhdijKOjXUsGLMjcK6UfGYXFGdGkvrQIFGlyfH6SDOmyIIJg7ASDQRKsP0bkq2VYPLOLk1uhV
X-MS-Exchange-AntiSpam-MessageData: v3iknhnS9Da50P0uZqbQeAxLO5R9qKlxJzWkxrohWAzdtK6J4Gq87s//OhPPoqAGf9c9YrDOydMzp7ppM6uRzDLNh4wkLbcYR8+aHgY3BM+HfefGerZaoQ0eUapxkMq3qA6OqfJkGcrmRS1MP4X/+g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f8865a7-a56d-4650-f63d-08d7c1d08a5b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:16:11.8673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z353dk7Gmi6053mjCPoAy/Jvigm9hq/nXmhoIT4e/iz1/Di4a4GfwieFFX+YSywC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a ingress frame gate control flow action. tc create a gate
action would provide a gate list to control when open/close state. when
the gate open state, the flow could pass but not when gate state is
close. The driver would repeat the gate list cyclely. User also could
assign a time point to start the gate list by the basetime parameter. if
the basetime has passed current time, start time would calculate by the
cycletime of the gate list.
The behavior try to keep according to the IEEE 802.1Qci spec. For the
software emulation, require the user input the clock type.

Below is the setting software simulator example in user space:

> tc qdisc add dev eth0 ingress

> tc filter add dev eth0 parent ffff: protocol ip \
           flower skip_hw src_ip 192.168.0.20 \
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

The command also support tc flower offload with device driver support:

> tc filter add dev eth0 parent ffff: protocol ip chain 14 \
	flower skip_sw dst_mac 10:00:80:00:00:00 \
	action gate index 12 sched-entry close 200000000 -1 -1

The iproute2 test patch need to upload to:

git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/uapi/linux/tc_act/tc_gate.h |  47 +++
 tc/Makefile                         |   1 +
 tc/m_gate.c                         | 483 ++++++++++++++++++++++++++++
 3 files changed, 531 insertions(+)
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 tc/m_gate.c

diff --git a/include/uapi/linux/tc_act/tc_gate.h b/include/uapi/linux/tc_act/tc_gate.h
new file mode 100644
index 0000000..e1b3a7f
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
diff --git a/tc/Makefile b/tc/Makefile
index a468a52..9365f3c 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -54,6 +54,7 @@ TCMODULES += m_bpf.o
 TCMODULES += m_tunnel_key.o
 TCMODULES += m_sample.o
 TCMODULES += m_ct.o
+TCMODULES += m_gate.o
 TCMODULES += p_ip.o
 TCMODULES += p_ip6.o
 TCMODULES += p_icmp.o
diff --git a/tc/m_gate.c b/tc/m_gate.c
new file mode 100644
index 0000000..50b65b7
--- /dev/null
+++ b/tc/m_gate.c
@@ -0,0 +1,483 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2020 NXP */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <linux/if_ether.h>
+#include "utils.h"
+#include "rt_names.h"
+#include "tc_util.h"
+#include "list.h"
+#include <linux/tc_act/tc_gate.h>
+
+struct gate_entry {
+	struct list_head list;
+	uint8_t	gate_state;
+	uint32_t interval;
+	int32_t ipv;
+	int32_t maxoctets;
+};
+
+#define CLOCKID_INVALID (-1)
+static const struct clockid_table {
+	const char *name;
+	clockid_t clockid;
+} clockt_map[] = {
+	{ "REALTIME", CLOCK_REALTIME },
+	{ "TAI", CLOCK_TAI },
+	{ "BOOTTIME", CLOCK_BOOTTIME },
+	{ "MONOTONIC", CLOCK_MONOTONIC },
+	{ NULL }
+};
+
+static void explain(void)
+{
+	fprintf(stderr,
+		"Usage: gate [ priority PRIO-SPEC ] [ base-time BASE-TIME ]\n"
+		"       [ cycle-time CYCLE-TIME ]\n"
+		"       [ cycle-time-ext CYCLE-TIME-EXT ]\n"
+		"       [ clockid CLOCKID ] [flags FLAGS]\n"
+		"       [ sched-entry GATE0 INTERVAL INTERNAL-PRIO-VALUE MAX-OCTETS ]\n"
+		"       [ sched-entry GATE1 INTERVAL INTERNAL-PRIO-VALUE MAX-OCTETS ]\n"
+		"       ......\n"
+		"       [ sched-entry GATEn INTERVAL INTERNAL-PRIO-VALUE MAX-OCTETS ]\n"
+		"       [ CONTROL ]\n"
+		"       GATEn := open | close |\n"
+		"       INTERVAL : nanoseconds period of gate slot\n"
+		"       INTERNAL-PRIO-VALUE : internal priority decide which\n"
+		"                             rx queue going to\n"
+		"                             -1 means wildcard\n"
+		"       MAX-OCTETS : maximum number of MSDU octets that are"
+		"                    permitted to pas the gate during the\n"
+		"                    specified TimeInterval"
+		"       CONTROL := pipe | drop | continue | pass |\n"
+		"                  goto chain <CHAIN_INDEX>\n");
+}
+
+static void usage(void)
+{
+	explain();
+	exit(-1);
+}
+
+static void explain_entry_format(void)
+{
+	fprintf(stderr, "Usage: sched-entry <open | close> <interval> <interval ipv> <octets max bytes>\n");
+}
+
+static int parse_gate(struct action_util *a, int *argc_p, char ***argv_p,
+		      int tca_id, struct nlmsghdr *n);
+static int print_gate(struct action_util *au, FILE *f, struct rtattr *arg);
+
+struct action_util gate_action_util = {
+	.id = "gate",
+	.parse_aopt = parse_gate,
+	.print_aopt = print_gate,
+};
+
+static int get_clockid(__s32 *val, const char *arg)
+{
+	const struct clockid_table *c;
+
+	if (strcasestr(arg, "CLOCK_") != NULL)
+		arg += sizeof("CLOCK_") - 1;
+
+	for (c = clockt_map; c->name; c++) {
+		if (strcasecmp(c->name, arg) == 0) {
+			*val = c->clockid;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static const char *get_clock_name(clockid_t clockid)
+{
+	const struct clockid_table *c;
+
+	for (c = clockt_map; c->name; c++) {
+		if (clockid == c->clockid)
+			return c->name;
+	}
+
+	return "invalid";
+}
+
+static int get_gate_state(__u8 *val, const char *arg)
+{
+	if (!strcasecmp("OPEN", arg)) {
+		*val = 1;
+		return 0;
+	}
+
+	if (!strcasecmp("CLOSE", arg)) {
+		*val = 0;
+		return 0;
+	}
+
+	return -1;
+}
+
+static struct gate_entry *create_gate_entry(uint8_t gate_state,
+					    uint32_t interval,
+					    int32_t ipv,
+					    int32_t maxoctets)
+{
+	struct gate_entry *e;
+
+	e = calloc(1, sizeof(*e));
+	if (!e)
+		return NULL;
+
+	e->gate_state = gate_state;
+	e->interval = interval;
+	e->ipv = ipv;
+	e->maxoctets = maxoctets;
+
+	return e;
+}
+
+static int add_gate_list(struct list_head *gate_entries, struct nlmsghdr *n)
+{
+	struct gate_entry *e;
+
+	list_for_each_entry(e, gate_entries, list) {
+		struct rtattr *a;
+
+		a = addattr_nest(n, 1024, TCA_GATE_ONE_ENTRY);
+
+		if (e->gate_state)
+			addattr(n, MAX_MSG, TCA_GATE_ENTRY_GATE);
+
+		addattr_l(n, MAX_MSG, TCA_GATE_ENTRY_INTERVAL,
+			  &e->interval, sizeof(e->interval));
+		addattr_l(n, MAX_MSG, TCA_GATE_ENTRY_IPV,
+			  &e->ipv, sizeof(e->ipv));
+		addattr_l(n, MAX_MSG, TCA_GATE_ENTRY_MAX_OCTETS,
+			  &e->maxoctets, sizeof(e->maxoctets));
+
+		addattr_nest_end(n, a);
+	}
+
+	return 0;
+}
+
+static void free_entries(struct list_head *gate_entries)
+{
+	struct gate_entry *e, *n;
+
+	list_for_each_entry_safe(e, n, gate_entries, list) {
+		list_del(&e->list);
+		free(e);
+	}
+}
+
+static int parse_gate(struct action_util *a, int *argc_p, char ***argv_p,
+		      int tca_id, struct nlmsghdr *n)
+{
+	__s32 clockid = CLOCKID_INVALID;
+	int argc = *argc_p;
+	char **argv = *argv_p;
+	struct rtattr *tail, *nle;
+	struct tc_gate parm = {.action = TC_ACT_PIPE};
+	struct list_head gate_entries;
+	int prio = -1;
+	__u64 base_time = 0;
+	__u64 cycle_time = 0;
+	__u64 cycle_time_ext = 0;
+	__u32 flags = 0;
+	int entry_num = 0;
+	int err;
+
+	if (matches(*argv, "gate") != 0)
+		return -1;
+
+	NEXT_ARG();
+	if (argc <= 0)
+		return -1;
+
+	INIT_LIST_HEAD(&gate_entries);
+
+	while (argc > 0) {
+		if (matches(*argv, "index") == 0) {
+			NEXT_ARG();
+			if (get_u32(&parm.index, *argv, 10))
+				invarg("index", *argv);
+		} else if (matches(*argv, "priority") == 0) {
+			NEXT_ARG();
+			if (get_s32(&prio, *argv, 0))
+				invarg("priority", *argv);
+		} else if (matches(*argv, "base-time") == 0) {
+			NEXT_ARG();
+			if (get_u64(&base_time, *argv, 10))
+				invarg("base-time", *argv);
+		} else if (matches(*argv, "cycle-time") == 0) {
+			NEXT_ARG();
+			if (get_u64(&cycle_time, *argv, 10))
+				invarg("cycle-time", *argv);
+		} else if (matches(*argv, "cycle-time-ext") == 0) {
+			NEXT_ARG();
+			if (get_u64(&cycle_time_ext, *argv, 10))
+				invarg("cycle-time-ext", *argv);
+		} else if (matches(*argv, "clockid") == 0) {
+			NEXT_ARG();
+			if (get_clockid(&clockid, *argv))
+				invarg("clockid", *argv);
+		} else if (matches(*argv, "flags") == 0) {
+			NEXT_ARG();
+			if (get_u32(&flags, *argv, 0))
+				invarg("flags", *argv);
+		} else if (matches(*argv, "sched-entry") == 0) {
+			struct gate_entry *e;
+			uint8_t gate_state = 0;
+			uint32_t interval = 0;
+			int32_t ipv = -1;
+			int32_t maxoctets = -1;
+
+			NEXT_ARG();
+
+			if (get_gate_state(&gate_state, *argv)) {
+				explain_entry_format();
+				invarg("gate", *argv);
+			}
+
+			NEXT_ARG();
+
+			if (get_u32(&interval, *argv, 0)) {
+				explain_entry_format();
+				invarg("interval", *argv);
+			}
+
+			NEXT_ARG();
+			if (get_s32(&ipv, *argv, 0)) {
+				explain_entry_format();
+				invarg("interval ipv", *argv);
+			}
+
+			NEXT_ARG();
+			if (get_s32(&maxoctets, *argv, 0)) {
+				explain_entry_format();
+				invarg("max octets", *argv);
+			}
+
+			e = create_gate_entry(gate_state, interval,
+					      ipv, maxoctets);
+			if (!e) {
+				fprintf(stderr, "gate: not enough memory\n");
+				exit(-1);
+			}
+
+			list_add_tail(&e->list, &gate_entries);
+			entry_num++;
+
+		} else if (matches(*argv, "reclassify") == 0 ||
+			   matches(*argv, "drop") == 0 ||
+			   matches(*argv, "shot") == 0 ||
+			   matches(*argv, "continue") == 0 ||
+			   matches(*argv, "pass") == 0 ||
+			   matches(*argv, "ok") == 0 ||
+			   matches(*argv, "pipe") == 0 ||
+			   matches(*argv, "goto") == 0) {
+			if (parse_action_control(&argc, &argv,
+						 &parm.action, false))
+				return -1;
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			break;
+		}
+
+		argc--;
+		argv++;
+	}
+
+	parse_action_control_dflt(&argc, &argv, &parm.action,
+				  false, TC_ACT_PIPE);
+
+	if (!entry_num && !parm.index) {
+		fprintf(stderr, "gate: must add at least one entry\n");
+		exit(-1);
+	}
+
+	tail = addattr_nest(n, MAX_MSG, tca_id);
+	addattr_l(n, MAX_MSG, TCA_GATE_PARMS, &parm, sizeof(parm));
+
+	if (prio != -1)
+		addattr_l(n, MAX_MSG, TCA_GATE_PRIORITY, &prio, sizeof(prio));
+
+	if (flags)
+		addattr_l(n, MAX_MSG, TCA_GATE_FLAGS, &flags, sizeof(flags));
+
+	if (base_time)
+		addattr_l(n, MAX_MSG, TCA_GATE_BASE_TIME,
+			  &base_time, sizeof(base_time));
+
+	if (cycle_time)
+		addattr_l(n, MAX_MSG, TCA_GATE_CYCLE_TIME,
+			  &cycle_time, sizeof(cycle_time));
+
+	if (cycle_time_ext)
+		addattr_l(n, MAX_MSG, TCA_GATE_CYCLE_TIME_EXT,
+			  &cycle_time_ext, sizeof(cycle_time_ext));
+
+	if (clockid != CLOCKID_INVALID)
+		addattr_l(n, MAX_MSG, TCA_GATE_CLOCKID, &clockid, sizeof(clockid));
+
+	nle = addattr_nest(n, MAX_MSG, TCA_GATE_ENTRY_LIST | NLA_F_NESTED);
+	err = add_gate_list(&gate_entries, n);
+	if (err < 0) {
+		fprintf(stderr, "Could not add entries to netlink message\n");
+		free_entries(&gate_entries);
+		return -1;
+	}
+
+	addattr_nest_end(n, nle);
+	addattr_nest_end(n, tail);
+	free_entries(&gate_entries);
+	*argc_p = argc;
+	*argv_p = argv;
+
+	return 0;
+}
+
+static int print_gate_list(struct rtattr *list)
+{
+	struct rtattr *item;
+	int rem;
+
+	rem = RTA_PAYLOAD(list);
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+
+	for (item = RTA_DATA(list);
+	     RTA_OK(item, rem);
+	     item = RTA_NEXT(item, rem)) {
+		struct rtattr *tb[TCA_GATE_ENTRY_MAX + 1];
+		__u32 index = 0, interval = 0;
+		__u8 gate_state = 0;
+		__s32 ipv = -1, maxoctets = -1;
+
+		parse_rtattr_nested(tb, TCA_GATE_ENTRY_MAX, item);
+
+		if (tb[TCA_GATE_ENTRY_INDEX])
+			index = rta_getattr_u32(tb[TCA_GATE_ENTRY_INDEX]);
+
+		if (tb[TCA_GATE_ENTRY_GATE])
+			gate_state = 1;
+
+		if (tb[TCA_GATE_ENTRY_INTERVAL])
+			interval = rta_getattr_u32(tb[TCA_GATE_ENTRY_INTERVAL]);
+
+		if (tb[TCA_GATE_ENTRY_IPV])
+			ipv = rta_getattr_s32(tb[TCA_GATE_ENTRY_IPV]);
+
+		if (tb[TCA_GATE_ENTRY_MAX_OCTETS])
+			maxoctets = rta_getattr_s32(tb[TCA_GATE_ENTRY_MAX_OCTETS]);
+
+		print_uint(PRINT_ANY, "number", "\t number %4u", index);
+		print_string(PRINT_ANY, "gate state", "\tgate-state %-8s",
+			     gate_state ? "open" : "close");
+
+		print_uint(PRINT_ANY, "interval", "\tinterval %-16u", interval);
+
+		if (ipv != -1)
+			print_uint(PRINT_ANY, "ipv", "\tipv %-8u", ipv);
+		else
+			print_string(PRINT_FP, "ipv", "\tipv %s", "wildcard");
+
+		if (maxoctets != -1)
+			print_uint(PRINT_ANY, "max_octets", "\tmax-octets %-8u", maxoctets);
+		else
+			print_string(PRINT_FP, "max_octets", "\tmax-octets %s", "wildcard");
+
+		print_string(PRINT_FP, NULL, "%s", _SL_);
+	}
+
+	return 0;
+}
+
+static int print_gate(struct action_util *au, FILE *f, struct rtattr *arg)
+{
+	struct tc_gate *parm;
+	struct rtattr *tb[TCA_GATE_MAX + 1];
+	__s32 clockid = CLOCKID_INVALID;
+	__u64 base_time = 0;
+	__u64 cycle_time = 0;
+	__u64 cycle_time_ext = 0;
+	int prio = -1;
+
+	if (arg == NULL)
+		return -1;
+
+	parse_rtattr_nested(tb, TCA_GATE_MAX, arg);
+
+	if (!tb[TCA_GATE_PARMS]) {
+		fprintf(stderr, "Missing gate parameters\n");
+		return -1;
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+
+	parm = RTA_DATA(tb[TCA_GATE_PARMS]);
+
+	if (tb[TCA_GATE_PRIORITY])
+		prio = rta_getattr_s32(tb[TCA_GATE_PRIORITY]);
+
+	if (prio != -1)
+		print_int(PRINT_ANY, "priority", "\tpriority %-8d", prio);
+	else
+		print_string(PRINT_FP, "priority", "\tpriority %s", "wildcard");
+
+	if (tb[TCA_GATE_CLOCKID])
+		clockid = rta_getattr_s32(tb[TCA_GATE_CLOCKID]);
+	print_string(PRINT_ANY, "clockid", "\tclockid %s",
+		     get_clock_name(clockid));
+
+	if (tb[TCA_GATE_FLAGS]) {
+		__u32 flags;
+
+		flags = rta_getattr_u32(tb[TCA_GATE_FLAGS]);
+		print_0xhex(PRINT_ANY, "flags", "\tflags %#x", flags);
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+
+	if (tb[TCA_GATE_BASE_TIME])
+		base_time = rta_getattr_u64(tb[TCA_GATE_BASE_TIME]);
+
+	print_lluint(PRINT_ANY, "base_time", "\tbase-time %-22lld", base_time);
+
+	if (tb[TCA_GATE_CYCLE_TIME])
+		cycle_time = rta_getattr_u64(tb[TCA_GATE_CYCLE_TIME]);
+
+	print_lluint(PRINT_ANY, "cycle_time", "\tcycle-time %-16lld", cycle_time);
+
+	if (tb[TCA_GATE_CYCLE_TIME_EXT])
+		cycle_time = rta_getattr_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
+
+	print_lluint(PRINT_ANY, "cycle_time_ext", "\tcycle-time-ext %-16lld",
+		     cycle_time_ext);
+
+	if (tb[TCA_GATE_ENTRY_LIST])
+		print_gate_list(tb[TCA_GATE_ENTRY_LIST]);
+
+	print_action_control(f, "\t", parm->action, "");
+
+	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
+	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
+	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
+
+	if (show_stats) {
+		if (tb[TCA_GATE_TM]) {
+			struct tcf_t *tm = RTA_DATA(tb[TCA_GATE_TM]);
+
+			print_tm(f, tm);
+		}
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+
+	return 0;
+}
-- 
2.17.1

