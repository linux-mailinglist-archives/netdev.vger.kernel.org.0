Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DA31BB4DA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD1Dzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:55:53 -0400
Received: from mail-db8eur05on2082.outbound.protection.outlook.com ([40.107.20.82]:6065
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgD1Dzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 23:55:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrEs7ch5qKEddKD/N5DOtwC23mCPs4yzE29OqL0GB0KahrL5FQ2TSXg4rRDJLudPV5X33D2oVKvx3+LW1ZXMoWv1ssPBoFdKtIhH204GyOXCYbRmd5WdaOYzyaxJfsXmyDPtsPSqKh07NzJpCnxhl19Q90YS9rRorufrsbj71zlkyr7fyO9vtvjg3XIgA74yqyn57kmhNrt9GU8ewl2PB3Gz5Qu85cAVYhyeqrps/4Ip0iYbmbYhS3q5PZnge5GxvCnryQjjizQVnyksrvdbF/Gf9QVwPVnbL3xZvxsULOFyxy79dsaZxdd5exzjPYx0vz6LTDAeB69bj7bjGCdK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6zaZVtM5j9AOPLftOoCK0OKTuwKmfHKxUgEqcmbsdU=;
 b=OEPWP75XWaFidC5sR+Eyi3LuRguCDnLVlNX1JD5mjdKqKDCFJTLqcIfjBXXUzSbk+6BX57KaILajsaHAoaKZG97k9jCWcCLfzeyN+Q10aqzaOmYw/nGhuVoHyvka+UJ9azgMPc7cTbfn45RWigIjmBdGNKZPuAU+oNL+778X1vEpPCE2swRqd8yZFPA7kSQZ35QuIZE9lhFKjtm7NN5KZMmZSevf3Za6pN0NG8pdsl85LU22hiPM4ACIlsklyHKpdVdMY86mBFcBMZOhuZ+kbCg5cYCkeIZproKc5DDbB7xyyPMz8i/MJWlESDjatVUuB2XI5VPOYl56rQcE0AnFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6zaZVtM5j9AOPLftOoCK0OKTuwKmfHKxUgEqcmbsdU=;
 b=ahn3nx4WqVMPKmOeLdLZQO0T/fvrVdnffilfudXLlGxQfnFcE7T2DVjJX71OyQexG4fT1+l8vBrmRZMcfcimaSLlkGF8zmnirVsfT0QAtHZE8WWruWmAc2cU+bT0W7qHb5Ef9YRVDCn1Mk00YCF52ES1RCXVEveQKpKGZSK2xx8=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6445.eurprd04.prod.outlook.com (2603:10a6:803:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 03:55:47 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 03:55:47 +0000
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
Subject: [v4,net-next  1/4] net: qos: introduce a gate control flow action
Date:   Tue, 28 Apr 2020 11:34:50 +0800
Message-Id: <20200428033453.28100-2-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428033453.28100-1-Po.Liu@nxp.com>
References: <20200422024852.23224-5-Po.Liu@nxp.com>
 <20200428033453.28100-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR04CA0198.apcprd04.prod.outlook.com (2603:1096:4:14::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 03:55:39 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c8055f9-50ae-44f8-997c-08d7eb28085d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6445:|VE1PR04MB6445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6445CF42A727D15B427DC76292AC0@VE1PR04MB6445.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(6666004)(52116002)(478600001)(69590400007)(16526019)(1076003)(6506007)(81156014)(6486002)(8936002)(8676002)(316002)(5660300002)(186003)(86362001)(956004)(30864003)(2906002)(6512007)(66946007)(2616005)(66556008)(66476007)(7416002)(4326008)(36756003)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YlWkLuU0G/PkPE/nPdyUOkJhmEtOv2jf0gVTglJFKM+owPgQWMDMLU4Tvr2Qhq6rQCUjecVDygeKaeAAjoC5voLyPpN+jt2mqq93NQAcSF1tS17ehScV8MFKLaZ5+AalonxS3MJoH/H8P0wDxy4qnsyeXUp9QYiofQzDu5eOTA4aFu00o/05infUlLs+8hgV0+YGCoscKi44Osg1wRRPEP7SFPpHuX/LB10OJOYBkUo9a4QjaV3M4Q/0Plh1KVWnIg4qOCXy5zcT3tFwbQpiti/UPUBPpZQfX7iPzn0zRtGSLj2lcel2FR2OJDukNPUC6ksLg0zX8ir9tiwPvg+HQdRYGch0jQEZqrwaAKi9hXYmWSOfA9gNgYDMm0qhXz2QZsozF5TQ30E4jMsVXRbqqDku+znpnls0k/TVy9eXRt441YPAe/xK5yHebDoucgWTsbb+it/SpB4KT80IhnNMYp8hIm74Mt3EhwZ0nxWIP8nhqqX4ovMxbR1iNHMY0S4s
X-MS-Exchange-AntiSpam-MessageData: 2Sq5KK8FzJBSVp0NoMVexjM0LUWMOXNivYU7O4mzmN+nNUlyywQDrL0hEmnH54qbIUm5o6/hbqeKz4+ArKEtYYReyNrvXqltV1oxUi0As7x6PNYDoXWfdxRNrq+xlL4IJvAXuWiHKdBn2Wj+RKJnxSJBoBbfy/jNXoHpyUlhQKZCSKTYCWBhc2cjY4ajYG4DM4aiY0v+Lu9mJPLgi8WgFAaauf/+myp+vCZNucFGWRTIvMclwYWL3pXgUOhvXLDAMkaim3IDd1wIH5A+pMvmsEjSIvq9pa19dwijTVhHukfRg4I8rHqBN4HS+TMxtafBNLWyJv8ybPJM1T5Sa0Hn87SkDkjMobLwKpCbC/YVHwrAymYYgXfaNojOFwwAY6GM6hjsM/QApd/b8WKcGh5KrHvkzoRQc6ZFp/pEkEaRGNtEEtNxr7+TfKRkydiP5RczCGS0YO/bAh19yeiZlUVSZCEZ1sAAe+LQbZ3lTqpSv3R8T4lAf7UoFUE96Z535zWI1nxQB3hQDDcksFwNfcVhu+fA+lFhJxu/nOxMwYMe7iZt+4H9SsfvFcoLVWmcNLqMuAxHp08GNfQq5e+xGWjo33TPM250w2Rft3TWWqQBk0vrpDL4OO2guk/ELRTJOUNEzuqYeJq4X2jYvO0g39uIqhdde9y0amMSif6a8M9ou5gSl7XFo6RW/0rRpJCLmslLU9/Ql74bYCc6rMkoE9rjvYUVzWqy+WkVIlXpiDTXTquZbaPWD1Afp26Xk9ebPg303SPHrm/8udEWGmtWS+Xire8bkbyE7YnZjvfzmfEhxhk=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8055f9-50ae-44f8-997c-08d7eb28085d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 03:55:47.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tH7U7RjKUSosTGiciF6/F0A/h2grXaYbebsR3crRSI04zfHB0DT7WTtx0barQ60a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a ingress frame gate control flow action.
Tc gate action does the work like this:
Assume there is a gate allow specified ingress frames can be passed at
specific time slot, and be dropped at specific time slot. Tc filter
chooses the ingress frames, and tc gate action would specify what slot
does these frames can be passed to device and what time slot would be
dropped.
Tc gate action would provide an entry list to tell how much time gate
keep open and how much time gate keep state close. Gate action also
assign a start time to tell when the entry list start. Then driver would
repeat the gate entry list cyclically.
For the software simulation, gate action requires the user assign a time
clock type.

Below is the setting example in user space. Tc filter a stream source ip
address is 192.168.0.20 and gate action own two time slots. One is last
200ms gate open let frame pass another is last 100ms gate close let
frames dropped. When the ingress frames have reach total frames over
8000000 bytes, the excessive frames will be dropped in that 200000000ns
time slot.

> tc qdisc add dev eth0 ingress

> tc filter add dev eth0 parent ffff: protocol ip \
	   flower src_ip 192.168.0.20 \
	   action gate index 2 clockid CLOCK_TAI \
	   sched-entry open 200000000 -1 8000000 \
	   sched-entry close 100000000 -1 -1

> tc chain del dev eth0 ingress chain 0

"sched-entry" follow the name taprio style. Gate state is
"open"/"close". Follow with period nanosecond. Then next item is internal
priority value means which ingress queue should put. "-1" means
wildcard. The last value optional specifies the maximum number of
MSDU octets that are permitted to pass the gate during the specified
time interval.
Base-time is not set will be 0 as default, as result start time would
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
	   sched-entry close 200000000 -1 -1 \
	   clockid CLOCK_TAI

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/tc_act/tc_gate.h        |  47 ++
 include/uapi/linux/pkt_cls.h        |   1 +
 include/uapi/linux/tc_act/tc_gate.h |  47 ++
 net/sched/Kconfig                   |  12 +
 net/sched/Makefile                  |   1 +
 net/sched/act_gate.c                | 638 ++++++++++++++++++++++++++++
 6 files changed, 746 insertions(+)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
new file mode 100644
index 000000000000..330ad8b02495
--- /dev/null
+++ b/include/net/tc_act/tc_gate.h
@@ -0,0 +1,47 @@
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
+
+struct tcf_gate {
+	struct tc_action	common;
+	struct tcf_gate_params	param;
+	u8			current_gate_status;
+	ktime_t			current_close_time;
+	u32			current_entry_octets;
+	s32			current_max_octets;
+	struct tcfg_gate_entry	*next_entry;
+	struct hrtimer		hitimer;
+	enum tk_offsets		tk_offset;
+};
+
+#define to_gate(a) ((struct tcf_gate *)a)
+
+#endif
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 9f06d29cab70..fc672b232437 100644
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
index bfbefb7bff9d..2f20073f4f84 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -981,6 +981,18 @@ config NET_ACT_CT
 	  To compile this code as a module, choose M here: the
 	  module will be called act_ct.
 
+config NET_ACT_GATE
+	tristate "Frame gate entry list control tc action"
+	depends on NET_CLS_ACT
+	help
+	  Say Y here to allow to control the ingress flow to be passed at
+	  specific time slot and be dropped at other specific time slot by
+	  the gate entry list.
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
index 000000000000..916f6fe56692
--- /dev/null
+++ b/net/sched/act_gate.c
@@ -0,0 +1,638 @@
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
+static ktime_t gate_get_time(struct tcf_gate *gact)
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
+static int gate_get_start_time(struct tcf_gate *gact, ktime_t *start)
+{
+	struct tcf_gate_params *param = &gact->param;
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
+	if (!cycle)
+		return -EFAULT;
+
+	n = div64_u64(ktime_sub_ns(now, base), cycle);
+	*start = ktime_add_ns(base, (n + 1) * cycle);
+	return 0;
+}
+
+static void gate_start_timer(struct tcf_gate *gact, ktime_t start)
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
+	struct tcf_gate *gact = container_of(timer, struct tcf_gate,
+					     hitimer);
+	struct tcf_gate_params *p = &gact->param;
+	struct tcfg_gate_entry *next;
+	ktime_t close_time, now;
+
+	spin_lock(&gact->tcf_lock);
+
+	next = gact->next_entry;
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
+	gact->next_entry = next;
+
+	hrtimer_set_expires(&gact->hitimer, close_time);
+
+	spin_unlock(&gact->tcf_lock);
+
+	return HRTIMER_RESTART;
+}
+
+static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *a,
+			struct tcf_result *res)
+{
+	struct tcf_gate *gact = to_gate(a);
+
+	spin_lock_bh(&gact->tcf_lock);
+
+	tcf_lastuse_update(&gact->tcf_tm);
+	bstats_update(&gact->tcf_bstats, skb);
+
+	if (unlikely(gact->current_gate_status & GATE_ACT_PENDING)) {
+		spin_unlock_bh(&gact->tcf_lock);
+		return gact->tcf_action;
+	}
+
+	if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
+		goto drop;
+
+	if (gact->current_max_octets >= 0) {
+		gact->current_entry_octets += qdisc_pkt_len(skb);
+		if (gact->current_entry_octets > gact->current_max_octets) {
+			gact->tcf_qstats.overlimits++;
+			goto drop;
+		}
+	}
+
+	spin_unlock_bh(&gact->tcf_lock);
+
+	return gact->tcf_action;
+drop:
+	gact->tcf_qstats.drops++;
+	spin_unlock_bh(&gact->tcf_lock);
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
+static void release_entry_list(struct list_head *entries)
+{
+	struct tcfg_gate_entry *entry, *e;
+
+	list_for_each_entry_safe(entry, e, entries, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
+
+static int parse_gate_list(struct nlattr *list_attr,
+			   struct tcf_gate_params *sched,
+			   struct netlink_ext_ack *extack)
+{
+	struct tcfg_gate_entry *entry;
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
+	release_entry_list(&sched->entries);
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
+	struct tcf_gate_params *p;
+	s32 clockid = CLOCK_TAI;
+	struct tcf_gate *gact;
+	struct tc_gate *parm;
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
+
+	parm = nla_data(tb[TCA_GATE_PARMS]);
+	index = parm->index;
+
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+
+	if (err && bind)
+		return 0;
+
+	if (!err) {
+		ret = tcf_idr_create(tn, index, est, a,
+				     &act_gate_ops, bind, false, 0);
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
+	gact = to_gate(*a);
+
+	spin_lock_bh(&gact->tcf_lock);
+	p = &gact->param;
+
+	if (tb[TCA_GATE_CYCLE_TIME]) {
+		p->tcfg_cycletime = nla_get_u64(tb[TCA_GATE_CYCLE_TIME]);
+		if (!p->tcfg_cycletime_ext)
+			goto chain_put;
+	}
+
+	INIT_LIST_HEAD(&p->entries);
+	if (tb[TCA_GATE_ENTRY_LIST]) {
+		err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
+		if (err < 0)
+			goto chain_put;
+	}
+
+	if (!p->tcfg_cycletime) {
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
+	hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS);
+	gact->hitimer.function = gate_timer_func;
+
+	err = gate_get_start_time(gact, &start);
+	if (err < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Internal error: failed get start time");
+		release_entry_list(&p->entries);
+		goto chain_put;
+	}
+
+	gact->current_close_time = start;
+	gact->current_gate_status = GATE_ACT_GATE_OPEN | GATE_ACT_PENDING;
+
+	gact->next_entry = list_first_entry(&p->entries,
+					    struct tcfg_gate_entry, list);
+
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+
+	gate_start_timer(gact, start);
+
+	spin_unlock_bh(&gact->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	if (ret == ACT_P_CREATED)
+		tcf_idr_insert(tn, *a);
+	return ret;
+
+chain_put:
+	spin_unlock_bh(&gact->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static void tcf_gate_cleanup(struct tc_action *a)
+{
+	struct tcf_gate *gact = to_gate(a);
+	struct tcf_gate_params *p;
+
+	spin_lock_bh(&gact->tcf_lock);
+
+	hrtimer_cancel(&gact->hitimer);
+
+	p = &gact->param;
+	release_entry_list(&p->entries);
+
+	spin_unlock_bh(&gact->tcf_lock);
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
+	struct tcf_gate *gact = to_gate(a);
+	struct tc_gate opt = {
+		.index    = gact->tcf_index,
+		.refcnt   = refcount_read(&gact->tcf_refcnt) - ref,
+		.bindcnt  = atomic_read(&gact->tcf_bindcnt) - bind,
+	};
+	struct tcfg_gate_entry *entry;
+	struct tcf_gate_params *p;
+	struct nlattr *entry_list;
+	struct tcf_t t;
+
+	spin_lock_bh(&gact->tcf_lock);
+	opt.action = gact->tcf_action;
+
+	p = &gact->param;
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
+	tcf_tm_dump(&t, &gact->tcf_tm);
+	if (nla_put_64bit(skb, TCA_GATE_TM, sizeof(t), &t, TCA_GATE_PAD))
+		goto nla_put_failure;
+	spin_unlock_bh(&gact->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&gact->tcf_lock);
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
+static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u32 packets,
+				  u64 lastuse, bool hw)
+{
+	struct tcf_gate *gact = to_gate(a);
+	struct tcf_t *tm = &gact->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, false, hw);
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
+	.size		=	sizeof(struct tcf_gate),
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

