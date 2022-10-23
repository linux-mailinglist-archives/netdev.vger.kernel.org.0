Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580EA60950C
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJWRRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJWRR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:17:29 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C03D5B710;
        Sun, 23 Oct 2022 10:17:28 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z24so75165ljn.4;
        Sun, 23 Oct 2022 10:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jYyIMbJso6jJB2RiGcHZvZOyCs4ou0B3R3oCqDLm7rE=;
        b=CZvtGR0W/Pw6pZm3dlwnotlIk5lvCjLfXTrWAIPW/O5oe0OdbD32iDzA/a69FZ/ryz
         FtfNsjP/ngnNYwKCS/M4X1JpSFvqVfnF66HI8/owL6JJB9xlNIbmhi7oQxHtktWAzmAY
         EhzkV2wnzQKWy3iTP2ENgD4fmOuUbHGLqbfw5BCuOZafu33Q0rjErimvx8jalHH187EI
         qvUCUq0Qvj62yoRnTZOATIoz5RGjgd25D7KEUDaM9/jdAddIVnMF/s6SrHajA+Dy/RkG
         j9Fgm9okzXGhRsItjJzMBlpc2+2uBBQ4gSVR5wThN35xvrnoGD08SCCmtZeUtLXTkqXA
         cJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jYyIMbJso6jJB2RiGcHZvZOyCs4ou0B3R3oCqDLm7rE=;
        b=YdH20TxRPS0uamm/9em4kB+GX738hCLwB/kkCqbjMGnemD3x5sHNO7mLhTGqNHTXmF
         vD9DdM4hJL6OaqHXtztmOqctQvHVhSYLtagIkKflXqaapnC/CPqWysjDGUkOgpVMC6ue
         nnzCKMdRMjekLF5YSCQvelDR0tJvzs+uU2fv9uowSrn/W+io4VWmWVHgYg+Jh6SWe3Af
         RBeZGQHlfFCGBzMuSHSX/QVoDlVkUXYWFPBo3aLSbtog4tG8ubB7GtFEgAker3N8qxd1
         +YGSGLgpd01ZgvOxZ1zXD0h5KQyHwZNswDalonhefS4NoSOTVxQwSZqf6kbu1cFPPUqL
         6FvA==
X-Gm-Message-State: ACrzQf0suvWu7Jy5v+fOqSuq96W3+spCSytFyPFudUSMOZ0EyruPwHTx
        BSZzzRqM7qu1zSDIHEsGGHQ=
X-Google-Smtp-Source: AMsMyM71qpqHAKBESCsgtbqB0echO6ZUSOpiCCuZi5nGsKe/8HY5OQoeeIGSbdh11laACPSKb4USHw==
X-Received: by 2002:a2e:83c6:0:b0:26c:3550:bc14 with SMTP id s6-20020a2e83c6000000b0026c3550bc14mr10323785ljh.43.1666545446297;
        Sun, 23 Oct 2022 10:17:26 -0700 (PDT)
Received: from Michaels-MBP.home (188-177-109-202-dynamic.dk.customer.tdc.net. [188.177.109.202])
        by smtp.gmail.com with ESMTPSA id s13-20020a056512314d00b00494a11c5f52sm1309886lfi.256.2022.10.23.10.17.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 23 Oct 2022 10:17:25 -0700 (PDT)
From:   Michael Lilja <michael.lilja@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     michael.lilja@gmail.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] Periodically flow expire from flow offload tables
Date:   Sun, 23 Oct 2022 19:16:58 +0200
Message-Id: <20221023171658.69761-1-michael.lilja@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a flow is added to a flow table for offload SW/HW-offload
the user has no means of controlling the flow once it has
been offloaded. If a number of firewall rules has been made using
time schedules then these rules doesn't apply for the already
offloaded flows. Adding new firewall rules also doesn't affect
already offloaded flows.

This patch handle flow table retirement giving the user the option
to at least periodically get the flow back into control of the
firewall rules so already offloaded flows can be dropped or be
pushed back to flow offload tables.

The flow retirement is disabled by default and can be set in seconds
using sysctl -w net.netfilter.nf_flowtable_retire

Signed-off-by: Michael Lilja <michael.lilja@gmail.com>
---
 .../networking/nf_conntrack-sysctl.rst        |  7 ++++++
 include/net/netfilter/nf_flow_table.h         |  1 +
 include/net/netns/conntrack.h                 |  3 +++
 net/netfilter/nf_conntrack_standalone.c       | 17 ++++++++++++++
 net/netfilter/nf_flow_table_core.c            | 23 +++++++++++++++----
 5 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 1120d71f28d7..ab4071bc64c1 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -201,3 +201,10 @@ nf_flowtable_udp_timeout - INTEGER (seconds)
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
         Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+
+nf_flowtable_retire - INTEGER (seconds)
+	- 0 - disabled (default)
+	- not 0 - enabled and set the number of seconds a flow is offloaded
+
+	If this option is enabled offloaded flows retire periodically and return the
+	control of the flow to conntrack/netfilter.
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index cd982f4a0f50..f5643c24fb55 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -177,6 +177,7 @@ struct flow_offload {
 	unsigned long				flags;
 	u16					type;
 	u32					timeout;
+	u32					retire;
 	struct rcu_head				rcu_head;
 };
 
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e1290c159184..7567d5fa8220 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -110,5 +110,8 @@ struct netns_ct {
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	unsigned int		sysctl_flowtable_retire;
+#endif
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4ffe84c5a82c..92ed07b93846 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -620,6 +620,9 @@ enum nf_ct_sysctl_index {
 #ifdef CONFIG_LWTUNNEL
 	NF_SYSCTL_CT_LWTUNNEL,
 #endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	NF_SYSCTL_CT_FLOWTABLE_RETIRE,
+#endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -967,6 +970,15 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
 	},
+#endif
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	[NF_SYSCTL_CT_FLOWTABLE_RETIRE] = {
+		.procname	= "nf_flowtable_retire",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.data   = &init_net.ct.sysctl_flowtable_retire,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
 #endif
 	{}
 };
@@ -1111,6 +1123,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	nf_conntrack_standalone_init_dccp_sysctl(net, table);
 	nf_conntrack_standalone_init_gre_sysctl(net, table);
 
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+	/* Disable retire per default */
+	net->ct.sysctl_flowtable_retire = 0;
+#endif
+
 	/* Don't allow non-init_net ns to alter global sysctls */
 	if (!net_eq(&init_net, net)) {
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..0a449dec8565 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -285,6 +285,12 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	int err;
 
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
+	if (nf_ct_net(flow->ct)->ct.sysctl_flowtable_retire) {
+		flow->retire = nf_flowtable_time_stamp +
+			nf_ct_net(flow->ct)->ct.sysctl_flowtable_retire;
+	} else {
+		flow->retire = 0;
+	}
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
@@ -313,6 +319,11 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static inline bool nf_flow_has_retired(const struct flow_offload *flow)
+{
+	return flow->retire && nf_flow_timeout_delta(flow->retire) <= 0;
+}
+
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
@@ -327,7 +338,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
 
-	nf_flow_offload_add(flow_table, flow);
+	if (!nf_flow_has_retired(flow))
+		nf_flow_offload_add(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
@@ -339,6 +351,7 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 			       nf_flow_offload_rhash_params);
@@ -423,12 +436,14 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 	    nf_ct_is_dying(flow->ct))
 		flow_offload_teardown(flow);
 
-	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags) || nf_flow_has_retired(flow)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
-			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
+			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
 				nf_flow_offload_del(flow_table, flow);
-			else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
+			} else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags)) {
+				clear_bit(NF_FLOW_HW, &flow->flags);
 				flow_offload_del(flow_table, flow);
+			}
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
-- 
2.37.2

