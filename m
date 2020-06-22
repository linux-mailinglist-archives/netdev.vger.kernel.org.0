Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF960203D87
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgFVRKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:10:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730028AbgFVRKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:10:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MH0pFS186495;
        Mon, 22 Jun 2020 13:10:36 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tyrxafp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 13:10:36 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MGjaCJ004076;
        Mon, 22 Jun 2020 17:10:35 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 31sa38nggc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 17:10:35 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MHAXMV52036034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:10:33 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2FA36A054;
        Mon, 22 Jun 2020 17:10:33 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F9B16A04F;
        Mon, 22 Jun 2020 17:10:32 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.23.249])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 17:10:32 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: [PATCH v1 4/4] netfilter: Add a .pre_exit hook in all ip6table_foo.c.
Date:   Mon, 22 Jun 2020 10:10:14 -0700
Message-Id: <20200622171014.975-5-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200622171014.975-1-dwilder@us.ibm.com>
References: <20200622171014.975-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0
 cotscore=-2147483648 suspectscore=1 mlxlogscore=865 clxscore=1015
 priorityscore=1501 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using new helpers ip6t_unregister_table_pre_exit() and
ip6t_unregister_table_exit().

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 net/ipv6/netfilter/ip6table_filter.c   | 10 +++++++++-
 net/ipv6/netfilter/ip6table_mangle.c   | 10 +++++++++-
 net/ipv6/netfilter/ip6table_nat.c      | 10 ++++++++--
 net/ipv6/netfilter/ip6table_raw.c      | 10 +++++++++-
 net/ipv6/netfilter/ip6table_security.c | 10 +++++++++-
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 32667f5..88337b5 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -73,16 +73,24 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit ip6table_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_filter)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_filter,
+					       filter_ops);
+}
+
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_filter)
 		return;
-	ip6t_unregister_table(net, net->ipv6.ip6table_filter, filter_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_filter);
 	net->ipv6.ip6table_filter = NULL;
 }
 
 static struct pernet_operations ip6table_filter_net_ops = {
 	.init = ip6table_filter_net_init,
+	.pre_exit = ip6table_filter_net_pre_exit,
 	.exit = ip6table_filter_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 070afb9..1a27486 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -93,16 +93,24 @@ static int __net_init ip6table_mangle_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_mangle_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_mangle)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_mangle,
+					       mangle_ops);
+}
+
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_mangle)
 		return;
 
-	ip6t_unregister_table(net, net->ipv6.ip6table_mangle, mangle_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_mangle);
 	net->ipv6.ip6table_mangle = NULL;
 }
 
 static struct pernet_operations ip6table_mangle_net_ops = {
+	.pre_exit = ip6table_mangle_net_pre_exit,
 	.exit = ip6table_mangle_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 0f48759..0a23265 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -114,16 +114,22 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_nat_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_nat)
+		ip6t_nat_unregister_lookups(net);
+}
+
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_nat)
 		return;
-	ip6t_nat_unregister_lookups(net);
-	ip6t_unregister_table(net, net->ipv6.ip6table_nat, NULL);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_nat);
 	net->ipv6.ip6table_nat = NULL;
 }
 
 static struct pernet_operations ip6table_nat_net_ops = {
+	.pre_exit = ip6table_nat_net_pre_exit,
 	.exit	= ip6table_nat_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index a22100b..8f9e742 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -66,15 +66,23 @@ static int __net_init ip6table_raw_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_raw_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_raw)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_raw,
+					       rawtable_ops);
+}
+
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_raw)
 		return;
-	ip6t_unregister_table(net, net->ipv6.ip6table_raw, rawtable_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_raw);
 	net->ipv6.ip6table_raw = NULL;
 }
 
 static struct pernet_operations ip6table_raw_net_ops = {
+	.pre_exit = ip6table_raw_net_pre_exit,
 	.exit = ip6table_raw_net_exit,
 };
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index a74335f..5e8c48f 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -61,15 +61,23 @@ static int __net_init ip6table_security_table_init(struct net *net)
 	return ret;
 }
 
+static void __net_exit ip6table_security_net_pre_exit(struct net *net)
+{
+	if (net->ipv6.ip6table_security)
+		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_security,
+					       sectbl_ops);
+}
+
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
 	if (!net->ipv6.ip6table_security)
 		return;
-	ip6t_unregister_table(net, net->ipv6.ip6table_security, sectbl_ops);
+	ip6t_unregister_table_exit(net, net->ipv6.ip6table_security);
 	net->ipv6.ip6table_security = NULL;
 }
 
 static struct pernet_operations ip6table_security_net_ops = {
+	.pre_exit = ip6table_security_net_pre_exit,
 	.exit = ip6table_security_net_exit,
 };
 
-- 
1.8.3.1

