Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9432719042B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgCXEIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:08:38 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:62438
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbgCXEIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:08:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swhh+88qJC/lCRtrq5C/5xJnG9AcgztGTdVrRpx85A6TKxh3Pnw8uDze4obx2WJuGYG4ayjUwDvf/+37rIarw6Yx/tTt5qeVVNqTmA+ZuvU8aUNhA0fdHXKlKkFz5u3SGtHUcoZ7P88qvQzX4DYEQGyF8gtjU9M5pTRtoESCXxTXPlLkm+aGc7q0ZKZy+jw1U0Wac10Fmf99o4vb6Pc0uBCkJWpgmbEVuVMwzEVex2RUKen2KJ9ZvpitEkvjoo5MpyVGANSGWQa5UXa4gxyc8fyKq3TO5Fda+QhDBQAQu6VwefdeUQa/8Slhmz6ekUDxKREtG/jHKe5VCC+wW1YI0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OB2jrLxK07WHT7s/QvWZCX6FWCoMgvmKhdClx/UXgkQ=;
 b=AibO5LlJlWkbzNfI+huiiNgEUcAhIVYqTGocYwV04b0Nc6//vRAgFPKiHk1XnWWa6aRfvpDLT51bwfmxfVSBSIWUl1c8oR2TagMXSHajiIBC6Wdci4sfSvff/G4gZgwjyQN1Iaq9ZUXgiWX1N4WQHEuL8bYE63H+36L1ZpasMSll2HmUOKTJruAf+hYuQV90FSn/o695xuCVa2cYVGRwlUPOHC/h0mRMx+NUyI5oRRvpNebdVlviH454OfGh3fq/S+nyghNXrPb9KFL3f4l9JCYNDLeiKqoR30/ubMo48Pf/0FJv6NxiEOMMz7ptTT3q5C1b53RPt6pzhJ0FMFve1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OB2jrLxK07WHT7s/QvWZCX6FWCoMgvmKhdClx/UXgkQ=;
 b=aYBebCtoTR3Wemzpqr7hX+UuYrUgjs760nprqNyRxAkIO4JZ7LMtDcXa2FP0CyTmyfDsUf+uCjRqSywx6l9Hk3JByadY8NkFZ0bpEMMWCYcCesFmAaivC3i1heSvz17b6+LM6R9ZD+vq9hVK8zL/NoUIaxGriH0TdcvdIipNLTI=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6413.eurprd04.prod.outlook.com (20.179.232.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 04:08:13 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:08:13 +0000
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
Subject: [v1,iproute2  1/2] iproute2:tc:action: add a gate control action
Date:   Tue, 24 Mar 2020 11:47:44 +0800
Message-Id: <20200324034745.30979-7-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324034745.30979-1-Po.Liu@nxp.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0204.apcprd06.prod.outlook.com (2603:1096:4:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 04:08:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e53fce08-d12e-4cf9-818b-08d7cfa8f88f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6413:|VE1PR04MB6413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB641391990079294C9EA55F5392F10@VE1PR04MB6413.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(16526019)(30864003)(26005)(86362001)(69590400007)(1076003)(478600001)(52116002)(6506007)(186003)(4326008)(7416002)(6512007)(6486002)(8936002)(81166006)(8676002)(81156014)(2906002)(316002)(66556008)(6666004)(956004)(66476007)(5660300002)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6413;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOR8kQ9tvJ60Oez9h6hpoYmP4lxGq4tdWXqcIM4qD3RVca0Qdkgwok8TKtUW4Vc0qm4b/zuqQpE7GlHShs2FyaiMY1QkdLXzZCjHHiZwQ2311nc8zK3647VzFhPb/kEmv2BhjHy8iCxpjpMI8BKfdFqU5hErV4HCBOUtcIM6Sf8q/tOi6F4JxcI+tyqoiV8FflmF55c2uqwXIUzHhqRLKQsgp2k9IsOz3Cvha1xejU81v4QR03aUtMX/zVDYbqEXZ3zzeuXO/WoxuZ8tRvgPqkJO4DZe0/nmlE5QZ++iyQDyyqvZhGB0Zf9hGoyHFS08jvzueV+pt/Js9EXisyl1ZFgfjr/D4g+6xkKfRnfxLE5SJUvMiDPVqJma8fsQ09dJ0NbRq9tlH6oZ2AncajqHdpcSe8Jink1PJEmcptxw/2B4W5ypWS8NaJyhh7QHTsHPArUU1VKHu/o8QcV4NW0fQE+amaEBkf6ZHb6Jfum45nsGU8gNV8fWrwREjc1yTdSI
X-MS-Exchange-AntiSpam-MessageData: aMpdMZrvlG23DqVGe4N7H49zbtqVG+lkso+FRrYPHRHCmDQw4CBjIVZiYTo5VVLxwKimmWz2Y/jO9k+ZQicOF1PJGhFLPF0/v2k8+76e3tOXlKA7X1mm6QMHh5gjpVspD6a9Znd68cRPd8CsdAXJHA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53fce08-d12e-4cf9-818b-08d7cfa8f88f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 04:08:13.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bI32QCOACgd3f2x9uZVjVyaBQyuQ2qUD9sg0Oex6IWhkUpXQhEA/FPCPkt6q1QhX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6413
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

Below is the setting example in user space. Tc filter a stream source ip
address is 192.168.0.20 and gate action own two time slots. One is last
200ms gate open let frame pass another is last 100ms gate close let
frames dropped.

 > tc qdisc add dev eth0 ingress
 > tc filter add dev eth0 parent ffff: protocol ip \
            flower src_ip 192.168.0.20 \
            action gate index 2 clockid CLOCK_TAI \
            sched-entry OPEN 200000000 -1 -1 \
            sched-entry CLOSE 100000000 -1 -1

 > tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. gate state is
"OPEN"/"CLOSE". Follow the period nanosecond. Then next -1 is internal
priority value means which ingress queue should put. "-1" means
wildcard. The last value optional specifies the maximum number of
MSDU octets that are permitted to pass the gate during the specified
time interval.

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

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 +++
 tc/Makefile                         |   1 +
 tc/m_gate.c                         | 483 ++++++++++++++++++++++++++++
 4 files changed, 532 insertions(+)
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 tc/m_gate.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a6aa466..7a047a9 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -106,6 +106,7 @@ enum tca_id {
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
 	TCA_ID_CTINFO,
 	TCA_ID_MPLS,
+	TCA_ID_GATE,
 	TCA_ID_CT,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
diff --git a/include/uapi/linux/tc_act/tc_gate.h b/include/uapi/linux/tc_act/tc_gate.h
new file mode 100644
index 0000000..f214b3a
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
index 0000000..326ceb8
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
+		a = addattr_nest(n, 1024, TCA_GATE_ONE_ENTRY | NLA_F_NESTED);
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
+	struct tc_gate parm = {.action = TC_ACT_PIPE};
+	struct list_head gate_entries;
+	__s32 clockid = CLOCKID_INVALID;
+	struct rtattr *tail, *nle;
+	char **argv = *argv_p;
+	int argc = *argc_p;
+	__u64 base_time = 0;
+	__u64 cycle_time = 0;
+	__u64 cycle_time_ext = 0;
+	__u32 flags = 0;
+	int prio = -1;
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
+	tail = addattr_nest(n, MAX_MSG, tca_id | NLA_F_NESTED);
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

