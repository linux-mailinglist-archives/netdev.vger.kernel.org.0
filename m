Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62A898D15
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfHVILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:11:12 -0400
Received: from mail-eopbgr40101.outbound.protection.outlook.com ([40.107.4.101]:58734
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbfHVILL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 04:11:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH5/CLp6WAIyqFlPE+h/9uFLcSoRP5U5c36ZDtChx4+8xxTp6iDvoQB6iHqE/kTaT9nyJ7xrzomxsIsS5gdQHvIhqqRSiUecbeeyNY9pPdrQnAqROsJlIH2Mec5u1hDIpnKzVgt9+izrGLA136NVa30BeKRAVNWNJK0TBT21VMyfMoGM9QRJ8C2sgOSfjLksUbSd1BUo/5QIAgsFcQ80oDPPf7H0CqBd6XW8/U+oD6CGJPKi4a8MD6Qd9cHmLZ2DHOsIGGFyxwEwZVVJW/EBXGMHHHidpn8FpGVs2nUytugsjh2CZAByWgfwxpIjpGW3legfsTuz4NDmMN8lP83v1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl42irHcFdX2LXQr2Btjr2+Q2YwgSeF99KziBEm9hhs=;
 b=b+xcq0Ek5GjpOqfIWjop54BMpEhNjm5vtQIFuPUs29RKtL8sldqZo7UnIARWLET7iOyviff1fp7YZMk9uFkHcAOKJes8LrFZ4JF1nZHOoZEhN+spP90Qx/ZmPlhfrUDtKPPv6IroQKl1rsDyuzklBaAEX7QInlfuEo9OmYWCpGLVyBOV/XtqT3fdGEOvvmLvgLQIbdrv98uiWVaxdypkC7vrC7Tz1PVfmp6S2MFL9CQCoRb9HqPrFB0qt+KCjZytvotXuGGqN6McviHQcXkaxBV+8+O8BQXD+9bdU3ppfcwIo2OFl4W1zTU8VFOuXBV4/BTu7BOQktyE4VejR5lXAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zl42irHcFdX2LXQr2Btjr2+Q2YwgSeF99KziBEm9hhs=;
 b=Ub6/gD74lS6dcLODuk8zDacIPPbPzaOWelsxWV1+LVxENm1f89yF4NDtp1bXBQ2w1GJkxzPpmrvxY7RlQqyDhBNbTx8lCISZL5vhwlyAOjaUuZYi+uWyiMpJU5Ak/44ZRZ2BVo+h2xOtm2lV57AGKfQ6vwVGDMflHJm1NkDk4XY=
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com (20.178.19.14) by
 AM0PR07MB5650.eurprd07.prod.outlook.com (20.178.113.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.9; Thu, 22 Aug 2019 08:10:48 +0000
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd]) by AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd%4]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 08:10:48 +0000
From:   "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>,
        Bob Briscoe <research@bobbriscoe.net>,
        Henrik Steen <henrist@henrist.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next v5] sched: Add dualpi2 qdisc
Thread-Topic: [PATCH net-next v5] sched: Add dualpi2 qdisc
Thread-Index: AQHVWMEa7eVJSJLM00ebRS7myTVOWw==
Date:   Thu, 22 Aug 2019 08:10:48 +0000
Message-ID: <20190822080045.27609-1-olivier.tilmans@nokia-bell-labs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0022.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::35) To AM0PR07MB4819.eurprd07.prod.outlook.com
 (2603:10a6:208:f3::14)
x-mailer: git-send-email 2.23.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=olivier.tilmans@nokia-bell-labs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [131.228.32.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9c4cf72-ddf9-44cf-e617-08d726d83d3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR07MB5650;
x-ms-traffictypediagnostic: AM0PR07MB5650:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR07MB56504A55F81E4656EBAED916E0A50@AM0PR07MB5650.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(199004)(189003)(54534003)(66946007)(66574012)(7736002)(8936002)(81156014)(8676002)(53936002)(6306002)(52116002)(59246006)(25786009)(966005)(4326008)(478600001)(486006)(81166006)(109986005)(5660300002)(14454004)(14444005)(256004)(30864003)(7416002)(2906002)(386003)(6486002)(66446008)(66476007)(64756008)(66556008)(6512007)(102836004)(3846002)(6116002)(50226002)(71200400001)(36756003)(54906003)(99286004)(305945005)(1671002)(66066001)(1076003)(186003)(53946003)(86362001)(26005)(2616005)(71190400001)(316002)(6436002)(476003)(6506007)(569006);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR07MB5650;H:AM0PR07MB4819.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: nokia-bell-labs.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lZV+fmQKlCs7baGls4+JSy8ACjtF85v43k6heTl/11qfzSO8EgwHlHdsH1MLG8q13DsT7nfNbyq+ZxCWrlaAbpE1yeisrzAj/JuBeh6TzPMq1THd+R8KoVKCKidRyOFiNGFhBEgFV+2DCRw42NN9Z1D27JY4VhPxPbGdsBxrU7JsP5rlXoZjWVBHRUkAu2f5wNbNpok+rEIIFlrFdxOGj4KSJy3RcsWOKNpzG/Ca0YpfD/qt0gD31jcHGMsNnuJxBPRM8kwDjo4wQd+c/VCZ6SK7nF5a6vq4GzGdCaC//qwAGIvgmv74eQ4jV5tEGcKBYaspWkpxVhLrDLdBdDC+9bysfoPcv8hqNoLwHPSWQgqIiPDnhMHt2/4FKgP33rwgijn6m6C/N3PHxPPI7IY5ZKfRf0pxybCGJtSjBYKBfvw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c4cf72-ddf9-44cf-e617-08d726d83d3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:10:48.1375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IOm4dzjSKCZZZVwysk9rn6RIoVj5SxIqIvjr6z9bnVfrrLY5cHbu1Sl5AFasgR/NIX+sHccwp8Lu6EV+styMn0uTuZu90fTcvRuh+LzYxSKrk/U/9egxTcD+IDIKjX8+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5650
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olga Albisser <olga@albisser.org>

DualPI2 provides L4S-type low latency & loss to traffic that uses a
scalable congestion controller (e.g. TCP-Prague, DCTCP) without
degrading the performance of 'classic' traffic (e.g. Reno,
Cubic etc.). It is intended to be the reference implementation of the
IETF's DualQ Coupled AQM.

The qdisc provides two queues called low latency and classic. It
classifies packets based on the ECN field in the IP headers. By
default it directs non-ECN and ECT(0) into the classic queue and
ECT(1) and CE into the low latency queue, as per the IETF spec.

Each queue runs its own AQM:
* The classic AQM is called PI2, which is similar to the PIE AQM but
   more responsive and simpler. Classic traffic requires a decent
   target queue (default 15ms for Internet deployment) to fully
   utilize the link and to avoid high drop rates.
* The low latency AQM is, by default, a very shallow ECN marking
   threshold (1ms) similar to that used for DCTCP.

The DualQ isolates the low queuing delay of the Low Latency queue
from the larger delay of the 'Classic' queue. However, from a
bandwidth perspective, flows in either queue will share out the link
capacity as if there was just a single queue. This bandwidth pooling
effect is achieved by coupling together the drop and ECN-marking
probabilities of the two AQMs.

The PI2 AQM has two main parameters in addition to its target delay.
All the defaults are suitable for any Internet setting, but it can
be reconfigured for a Data Centre setting. The integral gain factor
alpha is used to slowly correct any persistent standing queue error
from the target delay, while the proportional gain factor beta is
used to quickly compensate for queue changes (growth or shrinkage).
Either alpha and beta are given as a parameter, or they can be
calculated by tc from alternative typical and maximum RTT parameters.

Internally, the output of a linear Proportional Integral (PI)
controller is used for both queues. This output is squared to
calculate the drop or ECN-marking probability of the classic queue.
This counterbalances the square-root rate equation of Reno/Cubic,
which is the trick that balances flow rates across the queues. For
the ECN-marking probability of the low latency queue, the output of
the base AQM is multiplied by a coupling factor. This determines the
balance between the flow rates in each queue. The default setting
makes the flow rates roughly equal, which should be generally
applicable.

If DUALPI2 AQM has detected overload (due to excessive non-responsive
traffic in either queue), it will switch to signaling congestion
solely using drop, irrespective of the ECN field. Alternatively, it
can be configured to limit the drop probability and let the queue
grow and eventually overflow (like tail-drop).

Additional details can be found in the draft:
https://www.ietf.org/id/draft-ietf-tsvwg-aqm-dualq-coupled

Signed-off-by: Olga Albisser <olga@albisser.org>
Signed-off-by: Koen De Schepper <koen.de_schepper@nokia-bell-labs.com>
Signed-off-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Signed-off-by: Bob Briscoe <research@bobbriscoe.net>
Signed-off-by: Henrik Steen <henrist@henrist.net>
---

Notes:
    Changelog:
    * v4 -> v5
      - Fix do_div() usage in calculate_probability() to preserve sign
    * v3 -> v4
      - Replaced license boiletplate with SPDX identifier
      - Fix missing pskb_may_pull() calls when accessing ECN bits
      - Move timestamp computation at enqueue to happen after drop check
      - Use NMI-safe time keeping function, i.e., ktime_get_ns()
      - Switched from deprecated PSCHED_NS2TICKS/... to raw nanoseconds clo=
cks
      - Validate netlink parameters properly (ranges, error reporting)
      - Expanded the statistics tracked/reported to better reflect the beha=
vior of
        both queues
      - Simplified the qdisc structure:
        o Reworked classification logic to only depend on an ECN mask
        o Renamed most parameters to better reflect their usage
        o Removed unused/experimental features (e.g., TS-FIFO)
        o Restructured the skb->cb
        o Extracted helper functions
      - Fix compilation issues for ARM
      - Updated defaults parameter values to latest IETF ID
      - Fix the step AQM being applied on empty queues, causing excess mark=
ing on
        slower links
    * v2 -> v3
      - Fix compilation issues
      - Replaced the classic queue starvation protection from time-shifted =
FIFO
        to WRR, as it gives better results (e.g., prevents leaking burst in=
 the C
        queue to the L queue)
    * v1 -> v2
      - Store enqueue timestamp in skb->cb to avoid conflict with EDT

 include/uapi/linux/pkt_sched.h |  33 ++
 net/sched/Kconfig              |  22 +-
 net/sched/Makefile             |   1 +
 net/sched/sch_dualpi2.c        | 746 +++++++++++++++++++++++++++++++++
 4 files changed, 801 insertions(+), 1 deletion(-)
 create mode 100644 net/sched/sch_dualpi2.c

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.=
h
index 18f185299f47..e2ad4a8d2059 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1180,4 +1180,37 @@ enum {
=20
 #define TCA_TAPRIO_ATTR_MAX (__TCA_TAPRIO_ATTR_MAX - 1)
=20
+/* DUALPI2 */
+enum {
+	TCA_DUALPI2_UNSPEC,
+	TCA_DUALPI2_LIMIT,		/* Packets */
+	TCA_DUALPI2_TARGET,		/* us */
+	TCA_DUALPI2_TUPDATE,		/* us */
+	TCA_DUALPI2_ALPHA,		/* Hz scaled up by 256 */
+	TCA_DUALPI2_BETA,		/* HZ scaled up by 256 */
+	TCA_DUALPI2_STEP_THRESH,	/* Packets or us */
+	TCA_DUALPI2_STEP_PACKETS,	/* Whether STEP_THRESH is in packets */
+	TCA_DUALPI2_COUPLING,		/* Coupling factor between queues */
+	TCA_DUALPI2_DROP_OVERLOAD,	/* Whether to drop on overload */
+	TCA_DUALPI2_DROP_EARLY,		/* Whether to drop on enqueue */
+	TCA_DUALPI2_C_PROTECTION,	/* Percentage */
+	TCA_DUALPI2_ECN_MASK,		/* L4S queue classification mask */
+	TCA_DUALPI2_PAD,
+	__TCA_DUALPI2_MAX
+};
+
+#define TCA_DUALPI2_MAX   (__TCA_DUALPI2_MAX - 1)
+
+struct tc_dualpi2_xstats {
+	__u32 prob;		/* current probability */
+	__u32 delay_c;		/* current delay in C queue */
+	__u32 delay_l;		/* current delay in L queue */
+	__s32 credit;		/* current c_protection credit */
+	__u32 packets_in_c;	/* number of packets enqueued in C queue */
+	__u32 packets_in_l;	/* number of packets enqueued in L queue */
+	__u32 maxq;		/* maximum queue size */
+	__u32 ecn_mark;		/* packets marked with ecn*/
+	__u32 step_marks;	/* ECN marks due to the step AQM */
+};
+
 #endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index afd2ba157a13..f9340c18c3a2 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -409,6 +409,26 @@ config NET_SCH_PLUG
 	  To compile this code as a module, choose M here: the
 	  module will be called sch_plug.
=20
+config NET_SCH_DUALPI2
+	tristate "Dual Queue Proportional Integral Controller Improved with a Squ=
are (DUALPI2) scheduler"
+	help
+	  Say Y here if you want to use the DualPI2 AQM.
+	  This is a combination of the DUALQ Coupled-AQM with a PI2 base-AQM.
+	  The PI2 AQM is in turn both an extension and a simplification of the
+	  PIE AQM. PI2 makes quite some PIE heuristics unnecessary, while being
+	  able to control scalable congestion controls like DCTCP and
+	  TCP-Prague. With PI2, both Reno/Cubic can be used in parallel with
+	  DCTCP, maintaining window fairness. DUALQ provides latency separation
+	  between low latency DCTCP flows and Reno/Cubic flows that need a
+	  bigger queue.
+	  For more information, please see
+	  https://www.ietf.org/id/draft-ietf-tsvwg-aqm-dualq-coupled
+
+	  To compile this code as a module, choose M here: the module
+	  will be called sch_dualpi2.
+
+	  If unsure, say N.
+
 menuconfig NET_SCH_DEFAULT
 	bool "Allow override default queue discipline"
 	---help---
@@ -418,7 +438,7 @@ menuconfig NET_SCH_DEFAULT
 	  of pfifo_fast will be used. Many distributions already set
 	  the default value via /proc/sys/net/core/default_qdisc.
=20
-	  If unsure, say N.
+
=20
 if NET_SCH_DEFAULT
=20
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 415d1e1f237e..8e3bd4459eb4 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_NET_SCH_PIE)	+=3D sch_pie.o
 obj-$(CONFIG_NET_SCH_CBS)	+=3D sch_cbs.o
 obj-$(CONFIG_NET_SCH_ETF)	+=3D sch_etf.o
 obj-$(CONFIG_NET_SCH_TAPRIO)	+=3D sch_taprio.o
+obj-$(CONFIG_NET_SCH_DUALPI2)   +=3D sch_dualpi2.o
=20
 obj-$(CONFIG_NET_CLS_U32)	+=3D cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+=3D cls_route.o
diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
new file mode 100644
index 000000000000..c6c851499d35
--- /dev/null
+++ b/net/sched/sch_dualpi2.c
@@ -0,0 +1,746 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2019 Nokia.
+ *
+ * Author: Koen De Schepper <koen.de_schepper@nokia-bell-labs.com>
+ * Author: Olga Albisser <olga@albisser.org>
+ * Author: Henrik Steen <henrist@henrist.net>
+ * Author: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
+ *
+ * DualPI Improved with a Square (dualpi2):
+ *   Supports scalable congestion controls (e.g., DCTCP)
+ *   Supports coupled dual-queue with PI2
+ *   Supports L4S ECN identifier
+ *
+ * References:
+ *   draft-ietf-tsvwg-aqm-dualq-coupled:
+ *     http://tools.ietf.org/html/draft-ietf-tsvwg-aqm-dualq-coupled-08
+ *   De Schepper, Koen, et al. "PI 2: A linearized AQM for both classic an=
d
+ *   scalable TCP."  in proc. ACM CoNEXT'16, 2016.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <net/pkt_sched.h>
+#include <net/inet_ecn.h>
+#include <linux/string.h>
+
+/* 32b enable to support flows with windows up to ~8.6 * 1e9 packets
+ * i.e., twice the maximal snd_cwnd.
+ * MAX_PROB must be consistent with the RNG in dualpi2_roll().
+ */
+#define MAX_PROB ((u32)(~((u32)0)))
+/* alpha/beta values exchanged over netlink are in units of 256ns */
+#define ALPHA_BETA_SHIFT 8
+/* Scaled values of alpha/beta must fit in 32b to avoid overflow in later
+ * computations. Consequently (see and dualpi2_scale_alpha_beta()), their
+ * netlink-provided values can use at most 31b, i.e. be at most most (2^23=
)-1
+ * (~4MHz) as those are given in 1/256th. This enable to tune alpha/beta t=
o
+ * control flows whose maximal RTTs can be in usec up to few secs.
+ */
+#define ALPHA_BETA_MAX ((2 << 31) - 1)
+/* Internal alpha/beta are in units of 64ns.
+ * This enables to use all alpha/beta values in the allowed range without =
loss
+ * of precision due to rounding when scaling them internally, e.g.,
+ * scale_alpha_beta(1) will not round down to 0.
+ */
+#define ALPHA_BETA_GRANULARITY 6
+#define ALPHA_BETA_SCALING (ALPHA_BETA_SHIFT - ALPHA_BETA_GRANULARITY)
+/* We express the weights (wc, wl) in %, i.e., wc + wl =3D 100 */
+#define MAX_WC 100
+
+struct dualpi2_sched_data {
+	struct Qdisc *l_queue;	/* The L4S LL queue */
+	struct Qdisc *sch;	/* The classic queue (owner of this struct) */
+
+	struct { /* PI2 parameters */
+		u64	target;	/* Target delay in nanoseconds */
+		u32	tupdate;/* timer frequency (in jiffies) */
+		u32	prob;	/* Base PI2 probability */
+		u32	alpha;	/* Gain factor for the integral rate response */
+		u32	beta;	/* Gain factor for the proportional response */
+		struct timer_list timer; /* prob update timer */
+	} pi2;
+
+	struct { /* Step AQM (L4S queue only) parameters */
+		u32 thresh;	/* Step threshold */
+		bool in_packets;/* Whether the step is in packets or time */
+	} step;
+
+	struct { /* Classic queue starvation protection */
+		s32	credit; /* Credit (sign indicates which queue) */
+		s32	init;	/* Reset value of the credit */
+		u8	wc;	/* C queue weight (between 0 and MAX_WC) */
+		u8	wl;	/* L queue weight (MAX_WC - wc) */
+	} c_protection;
+
+	/* General dualQ parameters */
+	u8	coupling_factor;/* Coupling factor (k) between both queues */
+	u8	ecn_mask;	/* Mask to match L4S packets */
+	bool	drop_early;	/* Drop at enqueue instead of dequeue if true */
+	bool	drop_overload;	/* Drop (1) on overload, or overflow (0) */
+
+	/* Statistics */
+	u64	qdelay_c;	/* Classic Q delay */
+	u64	qdelay_l;	/* L4S Q delay */
+	u32	packets_in_c;	/* Number of packets enqueued in C queue */
+	u32	packets_in_l;	/* Number of packets enqueued in L queue */
+	u32	maxq;		/* maximum queue size */
+	u32	ecn_mark;	/* packets marked with ECN */
+	u32	step_marks;	/* ECN marks due to the step AQM */
+
+	struct { /* Deferred drop statistics */
+		u32 cnt;	/* Packets dropped */
+		u32 len;	/* Bytes dropped */
+	} deferred_drops;
+};
+
+struct dualpi2_skb_cb {
+	u64 ts;		/* Timestamp at enqueue */
+	u8 apply_step:1,/* Can we apply the step threshold */
+	   l4s:1,	/* Packet has been classified as L4S */
+	   ect:2;	/* Packet ECT codepoint */
+};
+
+static inline struct dualpi2_skb_cb *dualpi2_skb_cb(struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct dualpi2_skb_cb));
+	return (struct dualpi2_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
+static inline u64 skb_sojourn_time(struct sk_buff *skb, u64 reference)
+{
+	return reference - dualpi2_skb_cb(skb)->ts;
+}
+
+static inline u64 qdelay_in_ns(struct Qdisc *q, u64 now)
+{
+	struct sk_buff *skb =3D qdisc_peek_head(q);
+
+	return skb ? skb_sojourn_time(skb, now) : 0;
+}
+
+static inline u32 dualpi2_scale_alpha_beta(u32 param)
+{
+	u64 tmp  =3D ((u64)param * MAX_PROB >> ALPHA_BETA_SCALING);
+	do_div(tmp, NSEC_PER_SEC);
+	return tmp;
+}
+
+static inline u32 dualpi2_unscale_alpha_beta(u32 param)
+{
+	u64 tmp =3D ((u64)param * NSEC_PER_SEC << ALPHA_BETA_SCALING);
+	do_div(tmp, MAX_PROB);
+	return tmp;
+}
+
+static inline bool skb_is_l4s(struct sk_buff *skb)
+{
+	return dualpi2_skb_cb(skb)->l4s !=3D 0;
+}
+
+static inline void dualpi2_mark(struct dualpi2_sched_data *q,
+				struct sk_buff *skb)
+{
+	if (INET_ECN_set_ce(skb))
+		q->ecn_mark++;
+}
+
+static inline void dualpi2_reset_c_protection(struct dualpi2_sched_data *q=
)
+{
+	q->c_protection.credit =3D q->c_protection.init;
+}
+
+static inline void dualpi2_calculate_c_protection(struct Qdisc *sch,
+						  struct dualpi2_sched_data *q,
+						  u32 wc)
+{
+	q->c_protection.wc =3D wc;
+	q->c_protection.wl =3D MAX_WC - wc;
+	/* Start with L queue if wl > wc */
+	q->c_protection.init =3D (s32)psched_mtu(qdisc_dev(sch)) *
+		((int)q->c_protection.wc - (int)q->c_protection.wl);
+	dualpi2_reset_c_protection(q);
+}
+
+static inline bool dualpi2_roll(u32 prob)
+{
+	return prandom_u32() <=3D prob;
+}
+
+static inline bool dualpi2_squared_roll(struct dualpi2_sched_data *q)
+{
+	return dualpi2_roll(q->pi2.prob) && dualpi2_roll(q->pi2.prob);
+}
+
+static inline bool dualpi2_is_overloaded(u64 prob)
+{
+	return prob > MAX_PROB;
+}
+
+static bool must_drop(struct Qdisc *sch, struct dualpi2_sched_data *q,
+		      struct sk_buff *skb)
+{
+	u64 local_l_prob;
+
+	/* Never drop if we have fewer than 2 mtu-sized packets;
+	 * similar to min_th in RED.
+	 */
+	if (sch->qstats.backlog < 2 * psched_mtu(qdisc_dev(sch)))
+		return false;
+
+	local_l_prob =3D (u64)q->pi2.prob * q->coupling_factor;
+
+	if (skb_is_l4s(skb)) {
+		if (dualpi2_is_overloaded(local_l_prob)) {
+			/* On overload, preserve delay by doing a classic drop
+			 * in the L queue. Otherwise, let both queues grow until
+			 * we reach the limit and cannot enqueue anymore
+			 * (sacrifice delay to avoid drops).
+			 */
+			if (q->drop_overload && dualpi2_squared_roll(q))
+				goto drop;
+			else
+				goto mark;
+			/* Scalable marking has a  (prob * k) probability */
+		} else if (dualpi2_roll(local_l_prob)) {
+			goto mark;
+		}
+		/* Apply classic marking with a (prob * prob) probability.
+		 * Force drops for ECN-capable traffic on overload.
+		 */
+	} else if (dualpi2_squared_roll(q)) {
+		if (dualpi2_skb_cb(skb)->ect &&
+		    !dualpi2_is_overloaded(local_l_prob))
+			goto mark;
+		else
+			goto drop;
+	}
+	return false;
+
+mark:
+	dualpi2_mark(q, skb);
+	return false;
+
+drop:
+	return true;
+}
+
+static void dualpi2_skb_classify(struct dualpi2_sched_data *q,
+				 struct sk_buff *skb)
+{
+	struct dualpi2_skb_cb *cb =3D dualpi2_skb_cb(skb);
+	int wlen =3D skb_network_offset(skb);
+
+	switch (tc_skb_protocol(skb)) {
+	case htons(ETH_P_IP):
+		wlen +=3D sizeof(struct iphdr);
+		if (!pskb_may_pull(skb, wlen) ||
+		    skb_try_make_writable(skb, wlen))
+			goto not_ecn;
+
+		cb->ect =3D ipv4_get_dsfield(ip_hdr(skb)) & INET_ECN_MASK;
+		break;
+	case htons(ETH_P_IPV6):
+		wlen +=3D sizeof(struct ipv6hdr);
+		if (!pskb_may_pull(skb, wlen) ||
+		    skb_try_make_writable(skb, wlen))
+			goto not_ecn;
+
+		cb->ect =3D ipv6_get_dsfield(ipv6_hdr(skb)) & INET_ECN_MASK;
+		break;
+	default:
+		goto not_ecn;
+	}
+	cb->l4s =3D (cb->ect & q->ecn_mask) !=3D 0;
+	return;
+
+not_ecn:
+	/* Not ECN capable or not non pullable/writable packets can only be
+	 * dropped hence go the the classic queue.
+	 */
+	cb->ect =3D INET_ECN_NOT_ECT;
+	cb->l4s =3D 0;
+}
+
+static int dualpi2_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+				 struct sk_buff **to_free)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+	int err;
+
+	if (unlikely(qdisc_qlen(sch) >=3D sch->limit)) {
+		qdisc_qstats_overlimit(sch);
+		err =3D NET_XMIT_DROP;
+		goto drop;
+	}
+
+	dualpi2_skb_classify(q, skb);
+
+	/* drop early if configured */
+	if (q->drop_early && must_drop(sch, q, skb)) {
+		err =3D NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
+		goto drop;
+	}
+
+	dualpi2_skb_cb(skb)->ts =3D ktime_get_ns();
+
+	if (qdisc_qlen(sch) > q->maxq)
+		q->maxq =3D qdisc_qlen(sch);
+
+	if (skb_is_l4s(skb)) {
+		/* Only apply the step if a queue is building up */
+		dualpi2_skb_cb(skb)->apply_step =3D qdisc_qlen(q->l_queue) > 1;
+		/* Keep the overall qdisc stats consistent */
+		++sch->q.qlen;
+		qdisc_qstats_backlog_inc(sch, skb);
+		++q->packets_in_l;
+		return qdisc_enqueue_tail(skb, q->l_queue);
+	}
+	++q->packets_in_c;
+	return qdisc_enqueue_tail(skb, sch);
+
+drop:
+	qdisc_drop(skb, sch, to_free);
+	return err;
+}
+
+static struct sk_buff *dualpi2_qdisc_dequeue(struct Qdisc *sch)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+	struct sk_buff *skb;
+	int qlen_c, credit_change;
+
+pick_packet:
+	/* L queue packets are also accounted for in qdisc_qlen(sch)! */
+	qlen_c =3D qdisc_qlen(sch) - qdisc_qlen(q->l_queue);
+	skb =3D NULL;
+	/* We can drop after qdisc_dequeue_head() calls.
+	 * Manage statistics by hand to keep them consistent if that happens.
+	 */
+	if (qdisc_qlen(q->l_queue) > 0 &&
+	    (qlen_c <=3D 0 || q->c_protection.credit <=3D 0)) {
+		/* Dequeue and increase the credit by wc if qlen_c !=3D 0 */
+		skb =3D __qdisc_dequeue_head(&q->l_queue->q);
+		credit_change =3D qlen_c ?
+			q->c_protection.wc * qdisc_pkt_len(skb) : 0;
+		/* The global backlog will be updated later. */
+		qdisc_qstats_backlog_dec(q->l_queue, skb);
+		/* Propagate the dequeue to the global stats. */
+		--sch->q.qlen;
+	} else if (qlen_c > 0) {
+		/* Dequeue and decrease the credit by wl if qlen_l !=3D 0 */
+		skb =3D __qdisc_dequeue_head(&sch->q);
+		credit_change =3D qdisc_qlen(q->l_queue) ?
+			(s32)(-1) * q->c_protection.wl * qdisc_pkt_len(skb) : 0;
+	} else {
+		dualpi2_reset_c_protection(q);
+		goto exit;
+	}
+	qdisc_qstats_backlog_dec(sch, skb);
+
+	/* Drop on dequeue? */
+	if (!q->drop_early && must_drop(sch, q, skb)) {
+		++q->deferred_drops.cnt;
+		q->deferred_drops.len +=3D qdisc_pkt_len(skb);
+		consume_skb(skb);
+		qdisc_qstats_drop(sch);
+		/* try next packet */
+		goto pick_packet;
+	}
+
+	/* Apply the Step AQM to packets coming out of the L queue. */
+	if (skb_is_l4s(skb)) {
+		u64 qdelay =3D 0;
+
+		if (q->step.in_packets)
+			qdelay =3D qdisc_qlen(q->l_queue);
+		else
+			qdelay =3D skb_sojourn_time(skb, ktime_get_ns());
+		/* Apply the step */
+		if (likely(dualpi2_skb_cb(skb)->apply_step) &&
+		    qdelay > q->step.thresh) {
+			dualpi2_mark(q, skb);
+			++q->step_marks;
+		}
+		qdisc_bstats_update(q->l_queue, skb);
+	}
+
+	q->c_protection.credit +=3D credit_change;
+	qdisc_bstats_update(sch, skb);
+
+exit:
+	/* We cannot call qdisc_tree_reduce_backlog() if our qlen is 0,
+	 * or HTB crashes.
+	 */
+	if (q->deferred_drops.cnt && qdisc_qlen(sch)) {
+		qdisc_tree_reduce_backlog(sch, q->deferred_drops.cnt,
+					  q->deferred_drops.len);
+		q->deferred_drops.cnt =3D 0;
+		q->deferred_drops.len =3D 0;
+	}
+	return skb;
+}
+
+static s64 __scale_delta(u64 diff)
+{
+	do_div(diff, (1 << (ALPHA_BETA_GRANULARITY + 1)) - 1);
+	return diff;
+}
+
+static u32 calculate_probability(struct Qdisc *sch)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+	u64 qdelay, qdelay_old, now;
+	u32 new_prob;
+	s64 delta;
+
+	qdelay_old =3D max_t(u64, q->qdelay_c, q->qdelay_l);
+	now =3D ktime_get_ns();
+	q->qdelay_l =3D qdelay_in_ns(q->l_queue, now);
+	q->qdelay_c =3D qdelay_in_ns(sch, now);
+	qdelay =3D max_t(u64, q->qdelay_c, q->qdelay_l);
+	/* Alpha and beta take at most 32b, i.e, the delay difference would
+	 * overflow for queueing delay differences > ~4.2sec.
+	 */
+	delta =3D ((s64)qdelay - q->pi2.target) * q->pi2.alpha;
+	delta +=3D ((s64)qdelay - qdelay_old) * q->pi2.beta;
+	/* Prevent overflow */
+	if (delta > 0) {
+		new_prob =3D __scale_delta(delta) + q->pi2.prob;
+		if (new_prob < q->pi2.prob)
+			new_prob =3D MAX_PROB;
+	} else {
+		new_prob =3D q->pi2.prob - __scale_delta(delta * -1);
+		/* Prevent underflow */
+		if (new_prob > q->pi2.prob)
+			new_prob =3D 0;
+	}
+	/* If we do not drop on overload, ensure we cap the L4S probability to
+	 * 100% to keep window fairness when overflowing.
+	 */
+	if (!q->drop_overload)
+		return min_t(u32, new_prob, MAX_PROB / q->coupling_factor);
+	return new_prob;
+}
+
+static void dualpi2_timer(struct timer_list *timer)
+{
+	struct dualpi2_sched_data *q =3D from_timer(q, timer, pi2.timer);
+	struct Qdisc *sch =3D q->sch;
+	spinlock_t *root_lock; /* Lock to access the head of both queues. */
+
+	root_lock =3D qdisc_lock(qdisc_root_sleeping(sch));
+	spin_lock(root_lock);
+
+	q->pi2.prob =3D calculate_probability(sch);
+	mod_timer(&q->pi2.timer, jiffies + q->pi2.tupdate);
+
+	spin_unlock(root_lock);
+}
+
+static const struct nla_policy dualpi2_policy[TCA_DUALPI2_MAX + 1] =3D {
+	[TCA_DUALPI2_LIMIT] =3D {.type =3D NLA_U32},
+	[TCA_DUALPI2_TARGET] =3D {.type =3D NLA_U32},
+	[TCA_DUALPI2_TUPDATE] =3D {.type =3D NLA_U32},
+	[TCA_DUALPI2_ALPHA] =3D {.type =3D NLA_U32},
+	[TCA_DUALPI2_BETA] =3D {.type =3D NLA_U32},
+	[TCA_DUALPI2_STEP_THRESH] =3D {.type =3D NLA_U32},
+	[TCA_DUALPI2_STEP_PACKETS] =3D {.type =3D NLA_U8},
+	[TCA_DUALPI2_COUPLING] =3D {.type =3D NLA_U8},
+	[TCA_DUALPI2_DROP_OVERLOAD] =3D {.type =3D NLA_U8},
+	[TCA_DUALPI2_DROP_EARLY] =3D {.type =3D NLA_U8},
+	[TCA_DUALPI2_C_PROTECTION] =3D {.type =3D NLA_U8},
+	[TCA_DUALPI2_ECN_MASK] =3D {.type =3D NLA_U8},
+};
+
+static int dualpi2_change(struct Qdisc *sch, struct nlattr *opt,
+			  struct netlink_ext_ack *extack)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+	struct nlattr *tb[TCA_DUALPI2_MAX + 1];
+	unsigned int old_qlen, dropped =3D 0;
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+	err =3D nla_parse_nested_deprecated(tb, TCA_DUALPI2_MAX, opt,
+					  dualpi2_policy, extack);
+	if (err < 0)
+		return err;
+
+	sch_tree_lock(sch);
+
+	if (tb[TCA_DUALPI2_LIMIT]) {
+		u32 limit =3D nla_get_u32(tb[TCA_DUALPI2_LIMIT]);
+
+		if (!limit) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_DUALPI2_LIMIT],
+					    "limit must be greater than 0 !");
+			return -EINVAL;
+		}
+		sch->limit =3D limit;
+	}
+
+	if (tb[TCA_DUALPI2_TARGET])
+		q->pi2.target =3D (u64)nla_get_u32(tb[TCA_DUALPI2_TARGET]) *
+			NSEC_PER_USEC;
+
+	if (tb[TCA_DUALPI2_TUPDATE]) {
+		u64 tupdate =3D
+			usecs_to_jiffies(nla_get_u32(tb[TCA_DUALPI2_TUPDATE]));
+
+		if (!tupdate) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_DUALPI2_TUPDATE],
+					    "tupdate cannot be 0 jiffies!");
+			return -EINVAL;
+		}
+		q->pi2.tupdate =3D tupdate;
+	}
+
+	if (tb[TCA_DUALPI2_ALPHA]) {
+		u32 alpha =3D nla_get_u32(tb[TCA_DUALPI2_ALPHA]);
+
+		if (alpha > ALPHA_BETA_MAX) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_DUALPI2_ALPHA],
+					    "alpha is too large!");
+			return -EINVAL;
+		}
+		q->pi2.alpha =3D dualpi2_scale_alpha_beta(alpha);
+	}
+
+	if (tb[TCA_DUALPI2_BETA]) {
+		u32 beta =3D nla_get_u32(tb[TCA_DUALPI2_BETA]);
+
+		if (beta > ALPHA_BETA_MAX) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_DUALPI2_BETA],
+					    "beta is too large!");
+			return -EINVAL;
+		}
+		q->pi2.beta =3D dualpi2_scale_alpha_beta(beta);
+	}
+
+	if (tb[TCA_DUALPI2_STEP_THRESH])
+		q->step.thresh =3D nla_get_u32(tb[TCA_DUALPI2_STEP_THRESH]) *
+			NSEC_PER_USEC;
+
+	if (tb[TCA_DUALPI2_COUPLING]) {
+		u8 coupling =3D nla_get_u8(tb[TCA_DUALPI2_COUPLING]);
+
+		if (!coupling) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[TCA_DUALPI2_COUPLING],
+					    "Must use a non-zero coupling!");
+			return -EINVAL;
+		}
+		q->coupling_factor =3D coupling;
+	}
+
+	if (tb[TCA_DUALPI2_STEP_PACKETS])
+		q->step.in_packets =3D nla_get_u8(tb[TCA_DUALPI2_STEP_PACKETS]);
+
+	if (tb[TCA_DUALPI2_DROP_OVERLOAD])
+		q->drop_overload =3D nla_get_u8(tb[TCA_DUALPI2_DROP_OVERLOAD]);
+
+	if (tb[TCA_DUALPI2_DROP_EARLY])
+		q->drop_early =3D nla_get_u8(tb[TCA_DUALPI2_DROP_EARLY]);
+
+	if (tb[TCA_DUALPI2_C_PROTECTION]) {
+		u8 wc =3D nla_get_u8(tb[TCA_DUALPI2_C_PROTECTION]);
+
+		if (wc > MAX_WC) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_DUALPI2_C_PROTECTION],
+					    "c_protection must be <=3D 100!");
+			return -EINVAL;
+		}
+		dualpi2_calculate_c_protection(sch, q, wc);
+	}
+
+	if (tb[TCA_DUALPI2_ECN_MASK])
+		q->ecn_mask =3D nla_get_u8(tb[TCA_DUALPI2_ECN_MASK]);
+
+	/* Drop excess packets if new limit is lower */
+	old_qlen =3D qdisc_qlen(sch);
+	while (qdisc_qlen(sch) > sch->limit) {
+		struct sk_buff *skb =3D __qdisc_dequeue_head(&sch->q);
+
+		dropped +=3D qdisc_pkt_len(skb);
+		qdisc_qstats_backlog_dec(sch, skb);
+		rtnl_qdisc_drop(skb, sch);
+	}
+	qdisc_tree_reduce_backlog(sch, old_qlen - qdisc_qlen(sch), dropped);
+
+	sch_tree_unlock(sch);
+	return 0;
+}
+
+static void dualpi2_reset_default(struct dualpi2_sched_data *q)
+{
+	q->sch->limit =3D 10000; /* Holds 125ms at 1G */
+
+	q->pi2.target =3D 15 * NSEC_PER_MSEC;
+	q->pi2.tupdate =3D usecs_to_jiffies(16 * USEC_PER_MSEC);
+	q->pi2.alpha =3D dualpi2_scale_alpha_beta(41); /* ~0.16 Hz in 1/256th */
+	q->pi2.beta =3D dualpi2_scale_alpha_beta(819); /* ~3.2 Hz in 1/256th */
+	/* These values give a 10dB stability margin with max_rtt=3D100ms */
+
+	q->step.thresh =3D 1 * NSEC_PER_MSEC; /* 1ms */
+	q->step.in_packets =3D false; /* Step in time not packets */
+
+	dualpi2_calculate_c_protection(q->sch, q, 10); /* Defaults to wc =3D 10 *=
/
+
+	q->ecn_mask =3D INET_ECN_ECT_1; /* l4s-id */
+	q->coupling_factor =3D 2; /* window fairness for equal RTTs */
+	q->drop_overload =3D true; /* Preserve latency by dropping on overload */
+	q->drop_early =3D false; /* PI2 drop on dequeue */
+}
+
+static int dualpi2_init(struct Qdisc *sch, struct nlattr *opt,
+			struct netlink_ext_ack *extack)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+
+	q->l_queue =3D qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+				       TC_H_MAKE(sch->handle, 1), extack);
+	if (!q->l_queue)
+		return -ENOMEM;
+
+	q->sch =3D sch;
+	dualpi2_reset_default(q);
+	timer_setup(&q->pi2.timer, dualpi2_timer, 0);
+
+	if (opt) {
+		int err =3D dualpi2_change(sch, opt, extack);
+
+		if (err)
+			return err;
+	}
+
+	mod_timer(&q->pi2.timer, (jiffies + HZ) >> 1);
+	return 0;
+}
+
+static int dualpi2_dump(struct Qdisc *sch, struct sk_buff *skb)
+{
+	struct nlattr *opts =3D nla_nest_start_noflag(skb, TCA_OPTIONS);
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+	u64 step_thresh =3D q->step.thresh;
+	u64 target_usec =3D q->pi2.target;
+
+	if (!opts)
+		goto nla_put_failure;
+
+	do_div(target_usec, NSEC_PER_USEC);
+	if (!q->step.in_packets)
+		do_div(step_thresh, NSEC_PER_USEC);
+
+	if (nla_put_u32(skb, TCA_DUALPI2_LIMIT, sch->limit) ||
+	    nla_put_u32(skb, TCA_DUALPI2_TARGET, target_usec) ||
+	    nla_put_u32(skb, TCA_DUALPI2_TUPDATE,
+			jiffies_to_usecs(q->pi2.tupdate)) ||
+	    nla_put_u32(skb, TCA_DUALPI2_ALPHA,
+			dualpi2_unscale_alpha_beta(q->pi2.alpha)) ||
+	    nla_put_u32(skb, TCA_DUALPI2_BETA,
+			dualpi2_unscale_alpha_beta(q->pi2.beta)) ||
+	    nla_put_u32(skb, TCA_DUALPI2_STEP_THRESH, step_thresh) ||
+	    nla_put_u8(skb, TCA_DUALPI2_COUPLING, q->coupling_factor) ||
+	    nla_put_u8(skb, TCA_DUALPI2_DROP_OVERLOAD, q->drop_overload) ||
+	    nla_put_u8(skb, TCA_DUALPI2_STEP_PACKETS, q->step.in_packets) ||
+	    nla_put_u8(skb, TCA_DUALPI2_DROP_EARLY, q->drop_early) ||
+	    nla_put_u8(skb, TCA_DUALPI2_C_PROTECTION, q->c_protection.wc) ||
+	    nla_put_u8(skb, TCA_DUALPI2_ECN_MASK, q->ecn_mask))
+		goto nla_put_failure;
+
+	return nla_nest_end(skb, opts);
+
+nla_put_failure:
+	nla_nest_cancel(skb, opts);
+	return -1;
+}
+
+static int dualpi2_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+	u64 qdelay_c_usec =3D q->qdelay_c;
+	u64 qdelay_l_usec =3D q->qdelay_l;
+	struct tc_dualpi2_xstats st =3D {
+		.prob		=3D q->pi2.prob,
+		.packets_in_c	=3D q->packets_in_c,
+		.packets_in_l	=3D q->packets_in_l,
+		.maxq		=3D q->maxq,
+		.ecn_mark	=3D q->ecn_mark,
+		.credit		=3D q->c_protection.credit,
+		.step_marks	=3D q->step_marks,
+	};
+
+	do_div(qdelay_c_usec, NSEC_PER_USEC);
+	do_div(qdelay_l_usec, NSEC_PER_USEC);
+	st.delay_c =3D qdelay_c_usec;
+	st.delay_l =3D qdelay_l_usec;
+	return gnet_stats_copy_app(d, &st, sizeof(st));
+}
+
+static void dualpi2_reset(struct Qdisc *sch)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+
+	qdisc_reset_queue(sch);
+	qdisc_reset_queue(q->l_queue);
+	q->qdelay_c =3D 0;
+	q->qdelay_l =3D 0;
+	q->pi2.prob =3D 0;
+	q->packets_in_c =3D 0;
+	q->packets_in_l =3D 0;
+	q->maxq =3D 0;
+	q->ecn_mark =3D 0;
+	q->step_marks =3D 0;
+	dualpi2_reset_c_protection(q);
+}
+
+static void dualpi2_destroy(struct Qdisc *sch)
+{
+	struct dualpi2_sched_data *q =3D qdisc_priv(sch);
+
+	q->pi2.tupdate =3D 0;
+	del_timer_sync(&q->pi2.timer);
+	if (q->l_queue)
+		qdisc_put(q->l_queue);
+}
+
+static struct Qdisc_ops dualpi2_qdisc_ops __read_mostly =3D {
+	.id =3D "dualpi2",
+	.priv_size	=3D sizeof(struct dualpi2_sched_data),
+	.enqueue	=3D dualpi2_qdisc_enqueue,
+	.dequeue	=3D dualpi2_qdisc_dequeue,
+	.peek		=3D qdisc_peek_dequeued,
+	.init		=3D dualpi2_init,
+	.destroy	=3D dualpi2_destroy,
+	.reset		=3D dualpi2_reset,
+	.change		=3D dualpi2_change,
+	.dump		=3D dualpi2_dump,
+	.dump_stats	=3D dualpi2_dump_stats,
+	.owner		=3D THIS_MODULE,
+};
+
+static int __init dualpi2_module_init(void)
+{
+	return register_qdisc(&dualpi2_qdisc_ops);
+}
+
+static void __exit dualpi2_module_exit(void)
+{
+	unregister_qdisc(&dualpi2_qdisc_ops);
+}
+
+module_init(dualpi2_module_init);
+module_exit(dualpi2_module_exit);
+
+MODULE_DESCRIPTION("Dual Queue with Proportional Integral controller Impro=
ved with a Square (dualpi2) scheduler");
+MODULE_AUTHOR("Koen De Schepper");
+MODULE_AUTHOR("Olga Albisser");
+MODULE_AUTHOR("Henrik Steen");
+MODULE_AUTHOR("Olivier Tilmans");
+MODULE_LICENSE("GPL");
--=20
2.23.0

