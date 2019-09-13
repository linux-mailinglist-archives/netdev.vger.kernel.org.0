Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A8B1C52
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388230AbfIMLbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:55 -0400
Received: from correo.us.es ([193.147.175.20]:42628 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388066AbfIMLbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 79FE84FFE02
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A4FBA7E25
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 68D07A7E22; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA168A7E9C;
        Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8C4A64265A5A;
        Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/27] netfilter: remove nf_conntrack_icmpv6.h header.
Date:   Fri, 13 Sep 2019 13:30:50 +0200
Message-Id: <20190913113102.15776-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nf_conntrack_icmpv6.h contains two object macros which duplicate macros
in linux/icmpv6.h.  The latter definitions are also visible wherever it
is included, so remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h | 21 ---------------------
 include/net/netfilter/nf_conntrack.h             |  1 -
 net/netfilter/nf_conntrack_proto_icmpv6.c        |  1 -
 3 files changed, 23 deletions(-)
 delete mode 100644 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h

diff --git a/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h b/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
deleted file mode 100644
index c86895bc5eb6..000000000000
--- a/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * ICMPv6 tracking.
- *
- * 21 Apl 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- separated from nf_conntrack_icmp.h
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_icmp.h
- */
-
-#ifndef _NF_CONNTRACK_ICMPV6_H
-#define _NF_CONNTRACK_ICMPV6_H
-
-#ifndef ICMPV6_NI_QUERY
-#define ICMPV6_NI_QUERY 139
-#endif
-#ifndef ICMPV6_NI_REPLY
-#define ICMPV6_NI_REPLY 140
-#endif
-
-#endif /* _NF_CONNTRACK_ICMPV6_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2cc304efe7f9..22275f42f0bb 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -23,7 +23,6 @@
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
-#include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
 #include <net/netfilter/nf_conntrack_tuple.h>
 
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 7e317e6698ba..6f9144e1f1c1 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -22,7 +22,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
-#include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 #include <net/netfilter/nf_log.h>
 
 static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
-- 
2.11.0

