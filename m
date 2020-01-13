Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91D139397
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgAMOVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:21:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38489 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:21:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so9829933wmc.3
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 06:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3eCz4kvPv/dfpt5ZMQ011A9RJiMdn0V8izFi/FJ/kI=;
        b=CkndM0IJSueA92GZa6fQPwqRXG314FkyUd5J2mOGaWlTpY8cjQKTxzxjepjY14zGxM
         9eh79duykHG4qOQJtarLGqjaaio6q+m8O+SOorQfUI6e/u7/0awdAzHxCYdXFQeU6Jp8
         ZT641O3o9rdM9rGX2rM8gI1L9mshQGvwS6IEa+33ZWBj6UksfQDH4PdongFX6FKzvWZr
         r4aMk1RGZofWV0JsAc0YOVtlgNFt0HVrEI4Lxeeh9UgINWcD1bPDSYjV9nAL0v9bPJ0T
         OiNJmYFqU0ZhkdPKlvuen0M+UfzFZHEfV71ZZdX7Sc8YXSJIgCj/5H79yJPWVJ5SpHLR
         a6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3eCz4kvPv/dfpt5ZMQ011A9RJiMdn0V8izFi/FJ/kI=;
        b=jeGiJHkIegpcloLJHNOjIfixkSeIAAUZyIwaESaFbiJ5f/veJhuywwMnaJ7nIxb77E
         K+nbX0gtD+gwT1FjYrvoO/gnSJ2KyEM7Sw5Hx5PB6e6oOfFsreBYElJogKjllSITLxZU
         WJnAks/iyX+6TnDsivN8wVMXPjXXbHT8L9lp8/r4ZokJ75vXRX19AdShTEPf11P4mliy
         0D7rJwE1CPzq9vJG/D/KqV+oPGsImnNKTYTXAITELsy13TTZitrh0ZmgTKrddOd8jrNV
         5g1WL9G8c6cLljZM/IBBXfQBe5o960eTlIrawil8ZLUiMguOXOM2odvgnm9SWeN90AmR
         fEyQ==
X-Gm-Message-State: APjAAAWGHtLKjsAMXx/ncBAuwl46tbs4mYHwqpuGkrhex1ZmdsKQT4ez
        upFMgwli2pgkye7krZftTzYl2biRKUU=
X-Google-Smtp-Source: APXvYqzT6p6tDVgQG2Jy6B7p13pzKXiKzlhTserPdc2ed/nfbVYESyZG1xbIrBUP4Sioi9e+LHdf0Q==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr21876383wmk.42.1578925280165;
        Mon, 13 Jan 2020 06:21:20 -0800 (PST)
Received: from localhost.localdomain (ip-213-220-234-169.net.upcbroadband.cz. [213.220.234.169])
        by smtp.gmail.com with ESMTPSA id g9sm15243476wro.67.2020.01.13.06.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 06:21:19 -0800 (PST)
From:   Petr Machata <pmachata@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <pmachata@gmail.com>, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH iproute2-next 2/2] tc: Add support for ETS Qdisc
Date:   Mon, 13 Jan 2020 15:16:29 +0100
Message-Id: <44f61038a960172fecdfc67999b2ab12581e75c3.1578924154.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1578924154.git.petrm@mellanox.com>
References: <cover.1578924154.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new module to generate and parse options specific to the ETS Qdisc.

Example output:

    bands 8 strict 3 priomap 0 1 2 3 4 5 6 7
qdisc ets 1: root refcnt 2 offloaded bands 8 strict 3 quanta 1514 1514 1514 1514 1514 priomap 0 1 2 3 4 5 6 7 7 7 7 7 7 7 7 7
[
  {
    "kind": "ets",
    "handle": "1:",
    "root": true,
    "refcnt": 2,
    "offloaded": true,
    "options": {
      "bands": 8,
      "strict": 3,
      "quanta": [1514, 1514, 1514, 1514, 1514],
      "priomap": [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7]
    }
  }
]

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 man/man8/tc-ets.8 | 192 ++++++++++++++++++++++++++
 man/man8/tc.8     |   7 +
 tc/Makefile       |   1 +
 tc/q_ets.c        | 342 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 542 insertions(+)
 create mode 100644 man/man8/tc-ets.8
 create mode 100644 tc/q_ets.c

diff --git a/man/man8/tc-ets.8 b/man/man8/tc-ets.8
new file mode 100644
index 00000000..d3e68167
--- /dev/null
+++ b/man/man8/tc-ets.8
@@ -0,0 +1,192 @@
+.TH TC 8 "December 2019" "iproute2" "Linux"
+.SH NAME
+ETS \- Enhanced Transmission Selection scheduler
+.SH SYNOPSIS
+.B tc qdisc ... ets [ bands
+number
+.B ] [ strict
+number
+.B ] [ quanta
+bytes bytes bytes...
+.B ] [ priomap
+band band band...
+.B ]
+
+.B tc class ... ets [ quantum
+bytes
+.B ]
+
+.SH DESCRIPTION
+
+The Enhanced Transmission Selection scheduler is a classful queuing
+discipline that merges functionality of PRIO and DRR qdiscs in one
+scheduler. ETS makes it easy to configure a set of strict and
+bandwidth-sharing bands to implement the transmission selection described
+in 802.1Qaz.
+
+On creation with 'tc qdisc add', a fixed number of bands is created. Each
+band is a class, although it is not possible to directly add and remove
+bands with 'tc class' commands. The number of bands to be created must
+instead be specified on the command line as the qdisc is added.
+
+The minor number of classid to use when referring to a band is the band
+number increased by one. Thus band 0 will have classid of major:1, band 1
+that of major:2, etc.
+
+ETS bands are of two types: some number may be in strict mode, the
+remaining ones are in bandwidth-sharing mode.
+
+.SH ALGORITHM
+When dequeuing, strict bands are tried first, if there are any. Band 0 is
+tried first. If it did not deliver a packet, band 1 is tried next, and so
+on until one of the bands delivers a packet, or the strict bands are
+exhausted.
+
+If no packet has been dequeued from any of the strict bands, if there are
+any bandwidth-sharing bands, the dequeuing proceeds according to the DRR
+algorithm. Each bandwidth-sharing band is assigned a deficit counter,
+initialized to quantum assigned by a
+.B quanta
+element. ETS maintains an (internal) ''active'' list of bandwidth-sharing
+bands whose qdiscs are non-empty. This list is used for dequeuing. A packet
+is dequeued from the band at the head of the list if the packet size is
+smaller or equal to the deficit counter. If the counter is too small, it is
+increased by
+.B quantum
+and the scheduler moves on to the next band in the active list.
+
+Only qdiscs that own their queue should be added below the
+bandwidth-sharing bands. Attaching to them non-work-conserving qdiscs like
+TBF does not make sense \-\- other qdiscs in the active list will be
+skipped until the dequeue operation succeeds. This limitation does not
+exist with the strict bands.
+
+.SH CLASSIFICATION
+The ETS qdisc allows three ways to decide which band to enqueue a packet
+to:
+
+- Packet priority can be directly set to a class handle, in which case that
+  is the queue where the packet will be put. For example, band number 2 of
+  a qdisc with handle of 11: will have classid 11:3. To mark a packet for
+  queuing to this band, the packet priority should be set to 0x110003.
+
+- A tc filter attached to the qdisc can put the packet to a band by using
+  the \fBflowid\fR keyword.
+
+- As a last resort, the ETS qdisc consults its priomap (see below), which
+  maps packets to bands based on packet priority.
+
+.SH PARAMETERS
+.TP
+strict
+The number of bands that should be created in strict mode. If not given,
+this value is 0.
+
+.TP
+quanta
+Each bandwidth-sharing band needs to know its quantum, which is the amount
+of bytes a band is allowed to dequeue before the scheduler moves to the
+next bandwidth-sharing band. The
+.B quanta
+argument lists quanta for the individual bandwidth-sharing bands.
+The minimum value of each quantum is 1. If
+.B quanta
+is not given, the default is no bandwidth-sharing bands, but note that when
+specifying a large number of
+.B bands,
+the extra ones are in bandwidth-sharing mode by default.
+
+.TP
+bands
+Number of bands given explicitly. This value has to be at least large
+enough to cover the strict bands specified through the
+.B strict
+keyword and bandwidth-sharing bands specified in
+.B quanta.
+If a larger value is given, any extra bands are in bandwidth-sharing mode,
+and their quanta are deduced from the interface MTU. If no value is given,
+as many bands are created as necessary to cover all bands implied by the
+.B strict
+and
+.B quanta
+keywords.
+
+.TP
+priomap
+The priomap maps the priority of a packet to a band. The argument is a list
+of numbers. The first number indicates which band the packets with priority
+0 should be put to, the second is for priority 1, and so on.
+
+There can be up to 16 numbers in the list. If there are fewer, the default
+band that traffic with one of the unmentioned priorities goes to is the
+last one.
+
+.SH EXAMPLE & USAGE
+
+.P
+Add a qdisc with 8 bandwidth-sharing bands, using the interface MTU as
+their quanta. Since all quanta are the same, this will lead to equal
+distribution of bandwidth between the bands, each will get about 12.5% of
+the link. The low 8 priorities go to individual bands in a reverse 1:1
+fashion (such that the highest priority goes to the first band).
+
+.P
+# tc qdisc add dev eth0 root handle 1: ets bands 8 priomap 7 6 5 4 3 2 1 0
+.br
+# tc qdisc show dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514 1514 1514 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7
+
+.P
+Tweak the first band of the above qdisc to give it a quantum of 2650, which
+will give it about 20% of the link (and about 11.5% to the remaining
+bands):
+
+.P
+# tc class change dev eth0 classid 1:1 ets quantum 2650
+.br
+# tc qdisc show dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 quanta 2650 1514 1514 1514 1514 1514 1514 1514 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7
+
+.P
+Create a purely strict Qdisc with reverse 1:1 mapping between priorities
+and bands:
+
+.P
+# tc qdisc add dev eth0 root handle 1: ets strict 8 priomap 7 6 5 4 3 2 1 0
+.br
+# tc qdisc sh dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7
+
+.P
+Add a Qdisc with 6 bands, 3 strict and 3 ETS with 35%-30%-25% weights:
+.P
+# tc qdisc add dev eth0 root handle 1: ets strict 3 quanta 3500 3000 2500 priomap 0 1 1 1 2 3 4 5
+.br
+# tc qdisc sh dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 3500 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5
+
+.P
+Create a Qdisc such that traffic with priorities 2, 3 and 4 are strictly
+prioritized over other traffic, and the rest goes into bandwidth-sharing
+classes with equal weights:
+.P
+# tc qdisc add dev eth0 root handle 1: ets bands 8 strict 3 priomap 3 4 0 1 2 5 6 7
+.br
+# tc qdisc sh dev eth0
+.br
+qdisc ets 1: root refcnt 2 bands 8 strict 3 quanta 1514 1514 1514 1514 1514 priomap 3 4 0 1 2 5 6 7 7 7 7 7 7 7 7 7
+
+.SH SEE ALSO
+.BR tc (8),
+.BR tc-prio (8),
+.BR tc-drr (8)
+
+.SH AUTHOR
+Parts of both this manual page and the code itself are taken from PRIO and
+DRR qdiscs.
+.br
+ETS qdisc itself was written by Petr Machata.
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index d25aadda..39976ad7 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -394,6 +394,12 @@ DSMARK
 Classify packets based on TOS field, change TOS field of packets based on
 classification.
 .TP
+ETS
+The ETS qdisc is a queuing discipline that merges functionality of PRIO and DRR
+qdiscs in one scheduler. ETS makes it easy to configure a set of strict and
+bandwidth-sharing bands to implement the transmission selection described in
+802.1Qaz.
+.TP
 HFSC
 Hierarchical Fair Service Curve guarantees precise bandwidth and delay allocation for leaf classes and allocates excess bandwidth fairly. Unlike HTB, it makes use of packet dropping to achieve low delays which interactive sessions benefit from.
 .TP
@@ -844,6 +850,7 @@ was written by Alexey N. Kuznetsov and added in Linux 2.2.
 .BR tc-codel (8),
 .BR tc-drr (8),
 .BR tc-ematch (8),
+.BR tc-ets (8),
 .BR tc-flow (8),
 .BR tc-flower (8),
 .BR tc-fq (8),
diff --git a/tc/Makefile b/tc/Makefile
index 14171a28..bea5550f 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -79,6 +79,7 @@ TCMODULES += q_cbs.o
 TCMODULES += q_etf.o
 TCMODULES += q_taprio.o
 TCMODULES += q_plug.o
+TCMODULES += q_ets.o
 
 TCSO :=
 ifeq ($(TC_CONFIG_ATM),y)
diff --git a/tc/q_ets.c b/tc/q_ets.c
new file mode 100644
index 00000000..e7903d50
--- /dev/null
+++ b/tc/q_ets.c
@@ -0,0 +1,342 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+/*
+ * Enhanced Transmission Selection - 802.1Qaz-based Qdisc
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+
+#include "utils.h"
+#include "tc_util.h"
+
+static void explain(void)
+{
+	fprintf(stderr, "Usage: ... ets [bands NUMBER] [strict NUMBER] [quanta Q1 Q2...] [priomap P1 P2...]\n");
+}
+
+static void cexplain(void)
+{
+	fprintf(stderr, "Usage: ... ets [quantum Q1]\n");
+}
+
+static unsigned int parse_quantum(const char *arg)
+{
+	unsigned int quantum;
+
+	if (get_unsigned(&quantum, arg, 10)) {
+		fprintf(stderr, "Illegal \"quanta\" element\n");
+		return 0;
+	}
+	if (!quantum)
+		fprintf(stderr, "\"quanta\" must be > 0\n");
+	return quantum;
+}
+
+static int parse_nbands(const char *arg, __u8 *pnbands, const char *what)
+{
+	unsigned int tmp;
+
+	if (get_unsigned(&tmp, arg, 10)) {
+		fprintf(stderr, "Illegal \"%s\"\n", what);
+		return -1;
+	}
+	if (tmp > TCQ_ETS_MAX_BANDS) {
+		fprintf(stderr, "The number of \"%s\" must be <= %d\n",
+			what, TCQ_ETS_MAX_BANDS);
+		return -1;
+	}
+
+	*pnbands = tmp;
+	return 0;
+}
+
+static int ets_parse_opt(struct qdisc_util *qu, int argc, char **argv,
+			 struct nlmsghdr *n, const char *dev)
+{
+	__u8 nbands = 0;
+	__u8 nstrict = 0;
+	bool quanta_mode = false;
+	unsigned int nquanta = 0;
+	__u32 quanta[TCQ_ETS_MAX_BANDS];
+	bool priomap_mode = false;
+	unsigned int nprio = 0;
+	__u8 priomap[TC_PRIO_MAX + 1];
+	unsigned int tmp;
+	struct rtattr *tail, *nest;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "bands") == 0) {
+			if (nbands) {
+				fprintf(stderr, "Duplicate \"bands\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			if (parse_nbands(*argv, &nbands, "bands"))
+				return -1;
+			priomap_mode = quanta_mode = false;
+		} else if (strcmp(*argv, "strict") == 0) {
+			if (nstrict) {
+				fprintf(stderr, "Duplicate \"strict\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			if (parse_nbands(*argv, &nstrict, "strict"))
+				return -1;
+			priomap_mode = quanta_mode = false;
+		} else if (strcmp(*argv, "quanta") == 0) {
+			if (nquanta) {
+				fprintf(stderr, "Duplicate \"quanta\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			priomap_mode = false;
+			quanta_mode = true;
+			goto parse_quantum;
+		} else if (strcmp(*argv, "priomap") == 0) {
+			if (nprio) {
+				fprintf(stderr, "Duplicate \"priomap\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			priomap_mode = true;
+			quanta_mode = false;
+			goto parse_priomap;
+		} else if (strcmp(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else if (quanta_mode) {
+			unsigned int quantum;
+
+parse_quantum:
+			quantum = parse_quantum(*argv);
+			if (!quantum)
+				return -1;
+			quanta[nquanta++] = quantum;
+		} else if (priomap_mode) {
+			unsigned int band;
+
+parse_priomap:
+			if (get_unsigned(&band, *argv, 10)) {
+				fprintf(stderr, "Illegal \"priomap\" element\n");
+				return -1;
+			}
+			if (nprio > TC_PRIO_MAX) {
+				fprintf(stderr, "\"priomap\" index cannot be higher than %u\n", TC_PRIO_MAX);
+				return -1;
+			}
+			priomap[nprio++] = band;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	if (!nbands)
+		nbands = nquanta + nstrict;
+	if (!nbands) {
+		fprintf(stderr, "One of \"bands\", \"quanta\" or \"strict\" needs to be specified\n");
+		explain();
+		return -1;
+	}
+	if (nbands < 1) {
+		fprintf(stderr, "The number of \"bands\" must be >= 1\n");
+		explain();
+		return -1;
+	}
+	if (nstrict + nquanta > nbands) {
+		fprintf(stderr, "Not enough total bands to cover all the strict bands and quanta\n");
+		explain();
+		return -1;
+	}
+	for (tmp = 0; tmp < nprio; tmp++) {
+		if (priomap[tmp] >= nbands) {
+			fprintf(stderr, "\"priomap\" element is out of bounds\n");
+			return -1;
+		}
+	}
+
+	tail = addattr_nest(n, 1024, TCA_OPTIONS | NLA_F_NESTED);
+	addattr_l(n, 1024, TCA_ETS_NBANDS, &nbands, sizeof(nbands));
+	if (nstrict)
+		addattr_l(n, 1024, TCA_ETS_NSTRICT, &nstrict, sizeof(nstrict));
+	if (nquanta) {
+		nest = addattr_nest(n, 1024, TCA_ETS_QUANTA | NLA_F_NESTED);
+		for (tmp = 0; tmp < nquanta; tmp++)
+			addattr_l(n, 1024, TCA_ETS_QUANTA_BAND,
+				  &quanta[tmp], sizeof(quanta[0]));
+		addattr_nest_end(n, nest);
+	}
+	if (nprio) {
+		nest = addattr_nest(n, 1024, TCA_ETS_PRIOMAP | NLA_F_NESTED);
+		for (tmp = 0; tmp < nprio; tmp++)
+			addattr_l(n, 1024, TCA_ETS_PRIOMAP_BAND,
+				  &priomap[tmp], sizeof(priomap[0]));
+		addattr_nest_end(n, nest);
+	}
+	addattr_nest_end(n, tail);
+
+	return 0;
+}
+
+static int ets_parse_copt(struct qdisc_util *qu, int argc, char **argv,
+			  struct nlmsghdr *n, const char *dev)
+{
+	unsigned int quantum = 0;
+	struct rtattr *tail;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "quantum") == 0) {
+			if (quantum) {
+				fprintf(stderr, "Duplicate \"quantum\"\n");
+				return -1;
+			}
+			NEXT_ARG();
+			quantum = parse_quantum(*argv);
+			if (!quantum)
+				return -1;
+		} else if (strcmp(*argv, "help") == 0) {
+			cexplain();
+			return -1;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			cexplain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	tail = addattr_nest(n, 1024, TCA_OPTIONS | NLA_F_NESTED);
+	if (quantum)
+		addattr_l(n, 1024, TCA_ETS_QUANTA_BAND, &quantum,
+			  sizeof(quantum));
+	addattr_nest_end(n, tail);
+
+	return 0;
+}
+
+static int ets_print_opt_quanta(struct rtattr *opt)
+{
+	int len = RTA_PAYLOAD(opt);
+	unsigned int offset;
+
+	open_json_array(PRINT_ANY, "quanta");
+	for (offset = 0; offset < len; ) {
+		struct rtattr *tb[TCA_ETS_MAX + 1] = {NULL};
+		struct rtattr *attr;
+		__u32 quantum;
+
+		attr = RTA_DATA(opt) + offset;
+		parse_rtattr(tb, TCA_ETS_MAX, attr, len - offset);
+		offset += RTA_LENGTH(RTA_PAYLOAD(attr));
+
+		if (!tb[TCA_ETS_QUANTA_BAND]) {
+			fprintf(stderr, "No ETS band quantum\n");
+			return -1;
+		}
+
+		quantum = rta_getattr_u32(tb[TCA_ETS_QUANTA_BAND]);
+		print_uint(PRINT_ANY, NULL, " %u", quantum);
+
+	}
+	close_json_array(PRINT_ANY, " ");
+
+	return 0;
+}
+
+static int ets_print_opt_priomap(struct rtattr *opt)
+{
+	int len = RTA_PAYLOAD(opt);
+	unsigned int offset;
+
+	open_json_array(PRINT_ANY, "priomap");
+	for (offset = 0; offset < len; ) {
+		struct rtattr *tb[TCA_ETS_MAX + 1] = {NULL};
+		struct rtattr *attr;
+		__u8 band;
+
+		attr = RTA_DATA(opt) + offset;
+		parse_rtattr(tb, TCA_ETS_MAX, attr, len - offset);
+		offset += RTA_LENGTH(RTA_PAYLOAD(attr)) + 3 /* padding */;
+
+		if (!tb[TCA_ETS_PRIOMAP_BAND]) {
+			fprintf(stderr, "No ETS priomap band\n");
+			return -1;
+		}
+
+		band = rta_getattr_u8(tb[TCA_ETS_PRIOMAP_BAND]);
+		print_uint(PRINT_ANY, NULL, " %u", band);
+
+	}
+	close_json_array(PRINT_ANY, " ");
+
+	return 0;
+}
+
+static int ets_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
+{
+	struct rtattr *tb[TCA_ETS_MAX + 1];
+	__u8 nbands;
+	__u8 nstrict;
+	int err;
+
+	if (opt == NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_ETS_MAX, opt);
+
+	if (!tb[TCA_ETS_NBANDS] || !tb[TCA_ETS_PRIOMAP]) {
+		fprintf(stderr, "Incomplete ETS options\n");
+		return -1;
+	}
+
+	nbands = rta_getattr_u8(tb[TCA_ETS_NBANDS]);
+	print_uint(PRINT_ANY, "bands", "bands %u ", nbands);
+
+	if (tb[TCA_ETS_NSTRICT]) {
+		nstrict = rta_getattr_u8(tb[TCA_ETS_NSTRICT]);
+		print_uint(PRINT_ANY, "strict", "strict %u ", nstrict);
+	}
+
+	if (tb[TCA_ETS_QUANTA]) {
+		err = ets_print_opt_quanta(tb[TCA_ETS_QUANTA]);
+		if (err)
+			return err;
+	}
+
+	return ets_print_opt_priomap(tb[TCA_ETS_PRIOMAP]);
+}
+
+static int ets_print_copt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
+{
+	struct rtattr *tb[TCA_ETS_MAX + 1];
+	__u32 quantum;
+
+	if (opt == NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_ETS_MAX, opt);
+
+	if (tb[TCA_ETS_QUANTA_BAND]) {
+		quantum = rta_getattr_u32(tb[TCA_ETS_QUANTA_BAND]);
+		print_uint(PRINT_ANY, "quantum", "quantum %u ", quantum);
+	}
+
+	return 0;
+}
+
+struct qdisc_util ets_qdisc_util = {
+	.id		= "ets",
+	.parse_qopt	= ets_parse_opt,
+	.parse_copt	= ets_parse_copt,
+	.print_qopt	= ets_print_opt,
+	.print_copt	= ets_print_copt,
+};
-- 
2.20.1

