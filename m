Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573CE394ED
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbfFGS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:56:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35373 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732315AbfFGS4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:56:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so1164868plo.2
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dh0v8NlMU4slcGoO8w6KC0w7gjiaiNp9Ew5oQIG65tw=;
        b=rEf7xZveRqzql7Sr4ZYdMBx5Cc6OCj6srDfgOWYvzkrvdMPqxUi8vG5nwsB1TL9ad+
         ri4q5Eqd8aAgOPCKlySBcz3+vMHBlDSXpOUsS/gS4mygxBS0ZpXMF+GVE/QJ3uvZnkUB
         cTyN3p95SONI9cuh6IgE8JJb1YUgctEM5P8wF/PyjOGJnvTr5QP52X5ApmpNo0upkuv8
         KdXyQtZq1rA8ulYvNgIPq/MTmDY1Gx+B1l7NBJrfsryEebK4R+SEBA8fakZt7dcpChC6
         KApXP2gyA9ggMZ3vX4wPnDWf19JQSPvVKLo+36NEyBPDYRQ0I2um8l4sv5pigo7k1/hj
         cvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dh0v8NlMU4slcGoO8w6KC0w7gjiaiNp9Ew5oQIG65tw=;
        b=E86rTQ8NNAsyshln5wFrC5YrOoji+SnSWg3ywTGGRI81rkDjPR5UWPatu24q8V0qbY
         E0sq7to1v6bAv7khDquZtl6yFYziliqMemBHZRkYTGi1G0WFZK6NGFU5H4/TObi1/zBV
         3BRNhZaijOENm63+cAc3qxwDa3BlRuaGMR3CQ8ScBh+CSuzuwxoUHB5kCrz/xunPa7n3
         /nHRNkW8R0d31zDoMlcVjbW+O3DiyOMZLjFWYaBt64beoD3LU+ZYqGykTDoxDNqgYTQU
         RMxwbXudXGqDl/5/FldW6VtdRY/ab5Lw4Kz9WmiVwbNgNjxL6m8Hm9oUgbI5TPFu6PSb
         RrnQ==
X-Gm-Message-State: APjAAAX9CsRU2qr5VywJRHQ+A0vBBz5rSgK+TtQRMwGD3Q7cf3OkKDJf
        KkOhfZ6G1oaYRFpTJRJoPk2uvg==
X-Google-Smtp-Source: APXvYqzl1FEC6MmJrUUbOLYAG4TNevSltqYsAmaCuEOFMtnhDUQvWKv95vKV624FAkHTgLbJwkKatA==
X-Received: by 2002:a17:902:8bc1:: with SMTP id r1mr56317333plo.163.1559933760609;
        Fri, 07 Jun 2019 11:56:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id i25sm3181933pfr.73.2019.06.07.11.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:55:59 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC v2 PATCH 4/5] seg6: Add sysctl limits for segment routing header
Date:   Fri,  7 Jun 2019 11:55:07 -0700
Message-Id: <1559933708-13947-5-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are analoguous to the sysctls that were defined for IPv6
Destination and Hop-by-Hop Options.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h         | 31 ++++++++++++++++++-------------
 include/net/netns/ipv6.h   |  2 ++
 net/ipv6/af_inet6.c        |  2 ++
 net/ipv6/sysctl_net_ipv6.c | 16 ++++++++++++++++
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 0d34f6e..0633e50 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -52,45 +52,50 @@
 #define IPV6_DEFAULT_HOPLIMIT   64
 #define IPV6_DEFAULT_MCASTHOPS	1
 
-/* Limits on Hop-by-Hop and Destination options.
+/* Limits on Hop-by-Hop, Destination, and Segment Routing TLV options.
  *
  * Per RFC8200 there is no limit on the maximum number or lengths of options in
  * Hop-by-Hop or Destination options other then the packet must fit in an MTU.
- * We allow configurable limits in order to mitigate potential denial of
- * service attacks.
+ * Similarly, TLVs in a segment routing header lack a specific limit. We allow
+ * configurable limits in order to mitigate potential denial of service attacks.
  *
  * There are three limits that may be set:
  *   - Limit the number of options in a Hop-by-Hop or Destination options
- *     extension header
+ *     extension header, or the number of TLVs in a Segment Routing Header.
  *   - Limit the byte length of a Hop-by-Hop or Destination options extension
- *     header
- *   - Disallow unknown options
+ *     header, or the length of TLV block in a Segment Routing Header.
+ *   - Disallow unknown options.
  *
  * The limits are expressed in corresponding sysctls:
  *
  * ipv6.sysctl.max_dst_opts_cnt
  * ipv6.sysctl.max_hbh_opts_cnt
+ * ipv6.sysctl.max_srh_opts_cnt
  * ipv6.sysctl.max_dst_opts_len
  * ipv6.sysctl.max_hbh_opts_len
+ * ipv6.sysctl.max_srh_opts_len
  *
  * max_*_opts_cnt is the number of TLVs that are allowed for Destination
- * options or Hop-by-Hop options. If the number is less than zero then unknown
- * TLVs are disallowed and the number of known options that are allowed is the
- * absolute value. Setting the value to INT_MAX indicates no limit.
+ * Options or Hop-by-Hop Options, or the number of TLVs in Segment Routing
+ * TLVs. If the number is less than zero then unknown TLVs are disallowed and
+ * the number of known options that are allowed is the absolute value. Setting
+ * the value to INT_MAX indicates no limit.
  *
- * max_*_opts_len is the length limit in bytes of a Destination or
- * Hop-by-Hop options extension header. Setting the value to INT_MAX
- * indicates no length limit.
+ * max_*_opts_len is the length limit in bytes of a Destination or Hop-by-Hop,
+ * options extension header, or the length of the TLV block in a Segment
+ * Routing Header. Setting the value to INT_MAX indicates no length limit.
  *
  * If a limit is exceeded when processing an extension header the packet is
- * silently discarded.
+ * discarded and an appropriate ICMP error is sent.
  */
 
 /* Default limits for Hop-by-Hop and Destination options */
 #define IP6_DEFAULT_MAX_DST_OPTS_CNT	 8
 #define IP6_DEFAULT_MAX_HBH_OPTS_CNT	 8
+#define IP6_DEFAULT_MAX_SRH_OPTS_CNT	 8
 #define IP6_DEFAULT_MAX_DST_OPTS_LEN	 INT_MAX /* No limit */
 #define IP6_DEFAULT_MAX_HBH_OPTS_LEN	 INT_MAX /* No limit */
+#define IP6_DEFAULT_MAX_SRH_OPTS_LEN	 INT_MAX /* No limit */
 
 /*
  *	Addr type
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 022a0fd..2cb53b3 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -47,8 +47,10 @@ struct netns_sysctl_ipv6 {
 	int flowlabel_reflect;
 	int max_dst_opts_cnt;
 	int max_hbh_opts_cnt;
+	int max_srh_opts_cnt;
 	int max_dst_opts_len;
 	int max_hbh_opts_len;
+	int max_srh_opts_len;
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
 };
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index ceab2fe2..d8dc360 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -862,8 +862,10 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.flowlabel_state_ranges = 0;
 	net->ipv6.sysctl.max_dst_opts_cnt = IP6_DEFAULT_MAX_DST_OPTS_CNT;
 	net->ipv6.sysctl.max_hbh_opts_cnt = IP6_DEFAULT_MAX_HBH_OPTS_CNT;
+	net->ipv6.sysctl.max_srh_opts_cnt = IP6_DEFAULT_MAX_SRH_OPTS_CNT;
 	net->ipv6.sysctl.max_dst_opts_len = IP6_DEFAULT_MAX_DST_OPTS_LEN;
 	net->ipv6.sysctl.max_hbh_opts_len = IP6_DEFAULT_MAX_HBH_OPTS_LEN;
+	net->ipv6.sysctl.max_srh_opts_len = IP6_DEFAULT_MAX_SRH_OPTS_LEN;
 	atomic_set(&net->ipv6.fib6_sernum, 1);
 
 	err = ipv6_init_mibs(net);
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 6d86fac..5fee576 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -162,6 +162,20 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "max_srh_opts_number",
+		.data		= &init_net.ipv6.sysctl.max_srh_opts_cnt,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{
+		.procname	= "max_srh_tlvs_length",
+		.data		= &init_net.ipv6.sysctl.max_srh_opts_len,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{ }
 };
 
@@ -228,6 +242,8 @@ static int __net_init ipv6_sysctl_net_init(struct net *net)
 	ipv6_table[13].data = &net->ipv6.sysctl.max_hbh_opts_len;
 	ipv6_table[14].data = &net->ipv6.sysctl.multipath_hash_policy,
 	ipv6_table[15].data = &net->ipv6.sysctl.seg6_flowlabel;
+	ipv6_table[16].data = &net->ipv6.sysctl.max_srh_opts_cnt;
+	ipv6_table[17].data = &net->ipv6.sysctl.max_srh_opts_len;
 
 	ipv6_route_table = ipv6_route_sysctl_init(net);
 	if (!ipv6_route_table)
-- 
2.7.4

