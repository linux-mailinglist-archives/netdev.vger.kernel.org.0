Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2F751FBB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfFYAOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:14:33 -0400
Received: from mail.us.es ([193.147.175.20]:38006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbfFYAMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5934AC04A7
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49162DA709
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3EA73DA705; Tue, 25 Jun 2019 02:12:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24A8ADA703;
        Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EEC9C4265A2F;
        Tue, 25 Jun 2019 02:12:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/26] netfilter: synproxy: add common uapi for SYNPROXY infrastructure
Date:   Tue, 25 Jun 2019 02:12:21 +0200
Message-Id: <20190625001233.22057-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

This new UAPI file is going to be used by the xt and nft common SYNPROXY
infrastructure. It is needed to avoid duplicated code.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_SYNPROXY.h | 19 +++++++++++++++++++
 include/uapi/linux/netfilter/xt_SYNPROXY.h | 18 +++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/nf_SYNPROXY.h

diff --git a/include/uapi/linux/netfilter/nf_SYNPROXY.h b/include/uapi/linux/netfilter/nf_SYNPROXY.h
new file mode 100644
index 000000000000..068d1b3a6f06
--- /dev/null
+++ b/include/uapi/linux/netfilter/nf_SYNPROXY.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_SYNPROXY_H
+#define _NF_SYNPROXY_H
+
+#include <linux/types.h>
+
+#define NF_SYNPROXY_OPT_MSS		0x01
+#define NF_SYNPROXY_OPT_WSCALE		0x02
+#define NF_SYNPROXY_OPT_SACK_PERM	0x04
+#define NF_SYNPROXY_OPT_TIMESTAMP	0x08
+#define NF_SYNPROXY_OPT_ECN		0x10
+
+struct nf_synproxy_info {
+	__u8	options;
+	__u8	wscale;
+	__u16	mss;
+};
+
+#endif /* _NF_SYNPROXY_H */
diff --git a/include/uapi/linux/netfilter/xt_SYNPROXY.h b/include/uapi/linux/netfilter/xt_SYNPROXY.h
index ea5eba15d4c1..4d5611d647df 100644
--- a/include/uapi/linux/netfilter/xt_SYNPROXY.h
+++ b/include/uapi/linux/netfilter/xt_SYNPROXY.h
@@ -2,18 +2,14 @@
 #ifndef _XT_SYNPROXY_H
 #define _XT_SYNPROXY_H
 
-#include <linux/types.h>
+#include <linux/netfilter/nf_SYNPROXY.h>
 
-#define XT_SYNPROXY_OPT_MSS		0x01
-#define XT_SYNPROXY_OPT_WSCALE		0x02
-#define XT_SYNPROXY_OPT_SACK_PERM	0x04
-#define XT_SYNPROXY_OPT_TIMESTAMP	0x08
-#define XT_SYNPROXY_OPT_ECN		0x10
+#define XT_SYNPROXY_OPT_MSS		NF_SYNPROXY_OPT_MSS
+#define XT_SYNPROXY_OPT_WSCALE		NF_SYNPROXY_OPT_WSCALE
+#define XT_SYNPROXY_OPT_SACK_PERM	NF_SYNPROXY_OPT_SACK_PERM
+#define XT_SYNPROXY_OPT_TIMESTAMP	NF_SYNPROXY_OPT_TIMESTAMP
+#define XT_SYNPROXY_OPT_ECN		NF_SYNPROXY_OPT_ECN
 
-struct xt_synproxy_info {
-	__u8	options;
-	__u8	wscale;
-	__u16	mss;
-};
+#define xt_synproxy_info		nf_synproxy_info
 
 #endif /* _XT_SYNPROXY_H */
-- 
2.11.0

