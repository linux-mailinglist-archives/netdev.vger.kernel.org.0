Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DE71C2A70
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 08:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgECGyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 02:54:00 -0400
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:50502
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727085AbgECGx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 02:53:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqhBBxUm0AAZJvCcepjHNrpEI3eR57v6byv0pGiNPsvX/946hB1GxkdieO92C2nnooUnOi4CcO1yBhMR2EgNlB+f0r0QFZlCrCSJtAlkr8TYvss2rkL/XkOXOjHQwoJejHkCn14jp1TPjSr2zQy8VH0o/NeS+XwNja3jSzthkOglmGaAVgZB6+dZbz6lpN0LA6nSsG5yRDSavKaY+cPbRh8CRI+0e36TJzrIcBkJ2SS7HuGgnea19C65HuwAwpyrrp0EMofKUpSWICZlJvtkoO14SdGbmVYEpljty5p9H2vWkhQk5RQZ/g/aacBIMBibnUods35r6Ss+hkFkvUWRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BacXHbOCsy+spYjPHMSpQfzL1G0VEYI1gtmxCUhQQlQ=;
 b=M0az/FNErKRM0eqGTMdwzzi1OJwRJN2bQtdUC/qgaMILMzV99vN9285vtsIxbWaHWR7XeWUzS+mEkAcgqB8vObwPlteRA9ncAxQrTLfeLFO0ihb17Wda2DWyZFTPmi81Ji5GcE7QKp8lkT7LhyVzAXCWXLeI9mqfCQNtChTzdudl47d1zWDNxLdEFuaJ91V/Hm7lIz0R0HniPAUr7fejI7hz7KK4Be9+RgvkBOCcCAox0esxiqmywf2mPonBsAfj9fdrGeJAjAKa6zwQF9MnEAKLi+8LV5wsPAAoVQVZAnbzUK5LQxCCCSH90yPPRqxcFXrgJKpKtBu7B9jiXvBpMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BacXHbOCsy+spYjPHMSpQfzL1G0VEYI1gtmxCUhQQlQ=;
 b=lRS/1eJaDWqfv8pQIzuLiMyqfrxwygAqpYt9L0+VtZUNzACiP1lgbPFieRKfL8tepiicrH743iuragsQhXIGQ0ZesilZANAoNMd9t37/kFJiBN431rvWjspEetiEDXGOQydoozF1lJaz/pHnwzuAaUbtaQpML2KHwX31IDLaQdc=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sun, 3 May
 2020 06:53:49 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 06:53:49 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     stephen@networkplumber.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, Po Liu <Po.Liu@nxp.com>
Subject: [v3,iproute2 1/2] iproute2:tc:action: add a gate control action
Date:   Sun,  3 May 2020 14:32:50 +0800
Message-Id: <20200503063251.10915-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501005318.21334-5-Po.Liu@nxp.com>
References: <20200501005318.21334-5-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0121.apcprd03.prod.outlook.com
 (2603:1096:4:91::25) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR03CA0121.apcprd03.prod.outlook.com (2603:1096:4:91::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Sun, 3 May 2020 06:53:42 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d963797-1246-47bd-8ffc-08d7ef2ebb83
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:|VE1PR04MB6640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB664038383F0C72BADADB0D9B92A90@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C37J1P/Sah7aapuzcjbKckFPrm2aGXEyGb70nGx7oKDjMiTnUf2Nkx6EK3f8FH6djwFFkacbyHljEwurEh177mo7R6slwNQMKM0TMo6fRQn/mVD34+7Ma0x0gepG3+LEUVYmPtd4ZWlTuP5aOazbie12Sp0Ln+fCQrQSgxyYFw0qBW868LIgEnBp8FJ2BX7SBbuNMCi4Hd/Qssznq1vG9clSoA3fggKeOxeco+nhG1MXfwEoCtx7p4Wz0dlmVsbgDynhuGpFECS4QplyJs5SyduyyD1/NxJwJ4aq9y6I0VejexKiENdeOzdo78442purhNhtxY82BtN/y2TB2IsidkkHu4KiME1Z96XWV9UTP9xPYpN/X5jjctL96Mw1sb1uNi5badlPgXGPB9ib+UuluDseTCF5SajueDPg/1r5p7PlTEdSbU3mn4FvmPLiUqNSqDT5lcWiGF/DaIHIbdxgLQPbR9s/B2WRs/QB0Wl23TvVu6iRclzUZ2cdiRf8r+7N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(66476007)(66556008)(66946007)(52116002)(8676002)(316002)(6486002)(478600001)(69590400007)(16526019)(36756003)(186003)(8936002)(26005)(6506007)(6666004)(5660300002)(7416002)(30864003)(6512007)(956004)(2616005)(1076003)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zYH8D2VCUQbEFId2mRcLseS/IFxu6Ee41EyMzez+3F1E0BgBwD/+1+EDP9Ji0qf5vhO0fN+zRsf/AhcemFGdhUCOF0crlALzsoINgQkPvHuicWzpfS5ozI1lKbnhlQeq4fsNgjOKrY+NMLzEamdpEI5O+joveFqHbI2C9G1UD4/Fy+offeukQ3hHN9BvGs9I/OJqsS1ixfFldrSUO2qU8ed5uOgeWgLAe7WlyUuipBtemNOqIT+epyYy0gNmxlAXKFmZbhXCpsMu8nlMYDVCUNzGhw/KGTlCR7NvWNu4c00S70cT+/3G+prswBtJIVdBc0qHyksFqFB2kM8Pc1AwpPjhsukxwfboh+RN+NRYGjDI8UNP9X7vsQUb19bqk0psDlkQRNNWV6XAchfNIt8+QmexpyO3mvib5vS/G22cS90jJlOKeXYSez6B7FCXtxZSmeju49H8bvaH9PH2n1wPnSfnnOqiqvrheYQ6a83P3az7a9KOcnD31CukbcjW9agIhcCBxQe1ZLeeZuH5eEIS4gSZyRLzpNjl+Y8g3w/G1BdMHpdWgpuhUMH5mo3tjan3FeCJzU5MMQoVwLkvIGckzLFxXF/Tb2EKwkkuS9zEHzZeDvmtFwM9TjejarHk2SB3qY7KlyLMy2UNloxIZy6hciEigYHoqhZDrfDXKVQtafABGumMDpttdHpzc2QbX+SmGjwv0ndH2IdEwWAiGaiKw2yWWhanjnlsCCGWKVjjr23g5Eu875o/Galwi0IOnOPlWgLvwDKTf4BrTRWRL/7wS6e02pMK+yKlRgWdRGVtWDU=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d963797-1246-47bd-8ffc-08d7ef2ebb83
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 06:53:49.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfBxodrLuBMtWnua2etM7jpJUPdY5v/FXZbUlhHNUe3MGZ9IgRl0Nw0SDZOt/Y33
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a ingress frame gate control flow action.
Tc gate action does the work like this:
Assume there is a gate allow specified ingress frames can pass at
specific time slot, and also drop at specific time slot. Tc filter
chooses the ingress frames, and tc gate action would specify what slot
does these frames can be passed to device and what time slot would be
dropped.
Tc gate action would provide an entry list to tell how much time gate
keep open and how much time gate keep state close. Gate action also
assign a start time to tell when the entry list start. Then driver would
repeat the gate entry list cyclically.
For the software simulation, gate action require the user assign a time
clock type.

Below is the setting example in user space. Tc filter a stream source ip
address is 192.168.0.20 and gate action own two time slots. One is last
200ms gate open let frame pass another is last 100ms gate close let
frames dropped.

 # tc qdisc add dev eth0 ingress
 # tc filter add dev eth0 parent ffff: protocol ip \

            flower src_ip 192.168.0.20 \
            action gate index 2 clockid CLOCK_TAI \
            sched-entry open 200000000 -1 -1 \
            sched-entry close 100000000

 # tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. Gate state is
"open"/"close". Follow the period nanosecond. Then next -1 is internal
priority value means which ingress queue should put to. "-1" means
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

 #tc filter add dev eth0 parent ffff:  protocol ip \
           flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
           action gate index 12 base-time 1357000000000 \
           sched-entry CLOSE 200000000 \
           clockid CLOCK_TAI

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
These patches continue request for support iprout2 tc command input gate
action since kernel patch applied (a51c328df310 net: qos: introduce a
gate control flow action).
Continue the version 3.
Changes from v2:
Fix flexible input for a time slot - sched-entry suggested by Vladimir
Oltean and Vinicius Gomes:
- ipv and maxoctets in a sched-entry can be ignore input default to be
wildcard(values are -1).

 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 +++
 tc/Makefile                         |   1 +
 tc/m_gate.c                         | 533 ++++++++++++++++++++++++++++
 4 files changed, 582 insertions(+)
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 tc/m_gate.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 9f06d29c..fc672b23 100644
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
index 00000000..f214b3a6
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
index e31cbc12..79c9c1dd 100644
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
index 00000000..8e0211f5
--- /dev/null
+++ b/tc/m_gate.c
@@ -0,0 +1,533 @@
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
+		"       [ sched-entry GATE0 INTERVAL [ INTERNAL-PRIO-VALUE MAX-OCTETS ] ]\n"
+		"       [ sched-entry GATE1 INTERVAL [ INTERNAL-PRIO-VALUE MAX-OCTETS ] ]\n"
+		"       ......\n"
+		"       [ sched-entry GATEn INTERVAL [ INTERNAL-PRIO-VALUE MAX-OCTETS ] ]\n"
+		"       [ CONTROL ]\n"
+		"       GATEn := open | close\n"
+		"       INTERVAL : nanoseconds period of gate slot\n"
+		"       INTERNAL-PRIO-VALUE : internal priority decide which\n"
+		"                             rx queue number direct to.\n"
+		"                             default to be -1 which means wildcard.\n"
+		"       MAX-OCTETS : maximum number of MSDU octets that are\n"
+		"                    permitted to pas the gate during the\n"
+		"                    specified TimeInterval.\n"
+		"                    default to be -1 which means wildcard.\n"
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
+	fprintf(stderr, "Usage: sched-entry <open | close> <interval> [ <interval ipv> <octets max bytes> ]\n");
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
+	int entry_num = 0;
+	char *invalidarg;
+	__u32 flags = 0;
+	int prio = -1;
+
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
+			if (get_u32(&parm.index, *argv, 10)) {
+				invalidarg = "index";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "priority") == 0) {
+			NEXT_ARG();
+			if (get_s32(&prio, *argv, 0)) {
+				invalidarg = "priority";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "base-time") == 0) {
+			NEXT_ARG();
+			if (get_u64(&base_time, *argv, 10)) {
+				invalidarg = "base-time";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "cycle-time") == 0) {
+			NEXT_ARG();
+			if (get_u64(&cycle_time, *argv, 10)) {
+				invalidarg = "cycle-time";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "cycle-time-ext") == 0) {
+			NEXT_ARG();
+			if (get_u64(&cycle_time_ext, *argv, 10)) {
+				invalidarg = "cycle-time-ext";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "clockid") == 0) {
+			NEXT_ARG();
+			if (get_clockid(&clockid, *argv)) {
+				invalidarg = "clockid";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "flags") == 0) {
+			NEXT_ARG();
+			if (get_u32(&flags, *argv, 0)) {
+				invalidarg = "flags";
+				goto err_arg;
+			}
+		} else if (matches(*argv, "sched-entry") == 0) {
+			struct gate_entry *e;
+			uint8_t gate_state = 0;
+			uint32_t interval = 0;
+			int32_t ipv = -1;
+			int32_t maxoctets = -1;
+			uint8_t backarg = 0;
+
+			NEXT_ARG();
+
+			if (get_gate_state(&gate_state, *argv)) {
+				explain_entry_format();
+				invalidarg = "sched-entry";
+				goto err_arg;
+			}
+
+			NEXT_ARG();
+
+			if (get_u32(&interval, *argv, 0)) {
+				explain_entry_format();
+				invalidarg = "sched-entry";
+				goto err_arg;
+			}
+
+			if (!NEXT_ARG_OK())
+				goto create_entry;
+
+			NEXT_ARG();
+
+			if (get_s32(&ipv, *argv, 0)) {
+				backarg++;
+				goto create_entry;
+			}
+
+			if (!gate_state)
+				ipv = -1;
+
+			if (!NEXT_ARG_OK())
+				goto create_entry;
+
+			NEXT_ARG();
+
+			if (get_s32(&maxoctets, *argv, 0))
+				backarg++;
+
+			if (!gate_state)
+				maxoctets = -1;
+
+create_entry:
+			e = create_gate_entry(gate_state, interval,
+					      ipv, maxoctets);
+			if (!e) {
+				fprintf(stderr, "gate: not enough memory\n");
+				free_entries(&gate_entries);
+				exit(-1);
+			}
+
+			list_add_tail(&e->list, &gate_entries);
+			entry_num++;
+
+			while (backarg) {
+				PREV_ARG();
+				backarg--;
+			}
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
+						 &parm.action, false)) {
+				free_entries(&gate_entries);
+				return -1;
+			}
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
+		addattr_l(n, MAX_MSG, TCA_GATE_CLOCKID,
+			  &clockid, sizeof(clockid));
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
+err_arg:
+	invarg(invalidarg, *argv);
+	free_entries(&gate_entries);
+
+	exit(-1);
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
+			print_uint(PRINT_ANY, "max_octets",
+				   "\tmax-octets %-8u", maxoctets);
+		else
+			print_string(PRINT_FP, "max_octets",
+				     "\tmax-octets %s", "wildcard");
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
+	print_lluint(PRINT_ANY, "cycle_time",
+		     "\tcycle-time %-16lld", cycle_time);
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

