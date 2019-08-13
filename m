Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D5E8C0BF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfHMShW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:22 -0400
Received: from correo.us.es ([193.147.175.20]:58770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbfHMShV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD85AB632A
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0C3D1150CE
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4F7C1150CB; Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4A27DA72F;
        Tue, 13 Aug 2019 20:37:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 689D94265A2F;
        Tue, 13 Aug 2019 20:37:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/17] netfilter: conntrack: use shared sysctl constants
Date:   Tue, 13 Aug 2019 20:36:46 +0200
Message-Id: <20190813183701.4002-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

Use shared sysctl variables for zero and one constants, as in commit
eec4844fae7c ("proc/sysctl: add shared variables for range check")

Fixes: 8f14c99c7eda ("netfilter: conntrack: limit sysctl setting for boolean options")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 34 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e0d392cb3075..d97f4ea47cf3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -511,8 +511,6 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min __read_mostly;
 static int log_invalid_proto_max __read_mostly = 255;
-static int zero;
-static int one = 1;
 
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
@@ -629,8 +627,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
@@ -654,8 +652,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
@@ -663,8 +661,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
@@ -673,8 +671,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
@@ -684,8 +682,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
@@ -759,16 +757,16 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
@@ -904,8 +902,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
-- 
2.11.0


