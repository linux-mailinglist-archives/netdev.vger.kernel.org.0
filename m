Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F27B14306
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfEEXdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:25 -0400
Received: from mail.us.es ([193.147.175.20]:34080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbfEEXdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2065F11ED83
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D3E9DA703
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02C14DA706; Mon,  6 May 2019 01:33:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDDF0DA703;
        Mon,  6 May 2019 01:33:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B4F604265A31;
        Mon,  6 May 2019 01:33:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/12] netfilter: use macros to create module aliases.
Date:   Mon,  6 May 2019 01:32:58 +0200
Message-Id: <20190505233305.13650-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>

Each NAT helper creates a module alias which follows a pattern.
Use macros for consistency.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 4 ++++
 net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            | 2 +-
 net/netfilter/nf_nat_amanda.c               | 2 +-
 net/netfilter/nf_nat_ftp.c                  | 2 +-
 net/netfilter/nf_nat_irc.c                  | 2 +-
 net/netfilter/nf_nat_sip.c                  | 2 +-
 net/netfilter/nf_nat_tftp.c                 | 2 +-
 8 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index ec52a8dc32fd..28bd4569aa64 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,6 +15,10 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
+#define NF_NAT_HELPER_NAME(name)	"ip_nat_" name
+#define MODULE_ALIAS_NF_NAT_HELPER(name) \
+	MODULE_ALIAS(NF_NAT_HELPER_NAME(name))
+
 struct module;
 
 enum nf_ct_helper_flags {
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 4e6b53ab6c33..7875c98072eb 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -631,4 +631,4 @@ module_exit(fini);
 MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");
 MODULE_DESCRIPTION("H.323 NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_h323");
+MODULE_ALIAS_NF_NAT_HELPER("h323");
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 68b4d450391b..e17b4ee7604c 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -37,7 +37,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
-MODULE_ALIAS("ip_nat_pptp");
+MODULE_ALIAS_NF_NAT_HELPER("pptp");
 
 static void pptp_nat_expected(struct nf_conn *ct,
 			      struct nf_conntrack_expect *exp)
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index e4d61a7a5258..6b729a897c5f 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -22,7 +22,7 @@
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_amanda");
+MODULE_ALIAS_NF_NAT_HELPER("amanda");
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 5063cbf1689c..0e93b1f19432 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -24,7 +24,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp NAT helper");
-MODULE_ALIAS("ip_nat_ftp");
+MODULE_ALIAS_NF_NAT_HELPER("ftp");
 
 /* FIXME: Time out? --RR */
 
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 3aa35a43100d..6c06e997395f 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -26,7 +26,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_irc");
+MODULE_ALIAS_NF_NAT_HELPER("irc");
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aa1be643d7a0..f1f007d9484c 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -27,7 +27,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
-MODULE_ALIAS("ip_nat_sip");
+MODULE_ALIAS_NF_NAT_HELPER("sip");
 
 
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 7f67e1d5310d..dd3a835c111d 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -16,7 +16,7 @@
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_tftp");
+MODULE_ALIAS_NF_NAT_HELPER("tftp");
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
-- 
2.11.0

