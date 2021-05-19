Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F8E388D94
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353345AbhESMKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:10:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32973 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232781AbhESMKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:10:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D05F05C014B;
        Wed, 19 May 2021 08:09:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 19 May 2021 08:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=sGHfVfpuCS7+3zdRaN2d3hVwIV4+RNWDx7HzoUsD+nM=; b=fqenuCbU
        D4ljlMnQGSSoVd51EK1bqMtU2eocZlc11kA5jiL43jyDcktDe7BiMlMsUgmm2UBG
        G1MkYn3vFrgDpEJhjX6NoN/iiTs/QVsxguJnPFzcr5BHZb/Sfx4Om6MXx5RSYN8c
        D6/D8ugNnnZbdjhIHa5DVQfOjoexWrl4Bf0tclj0DbefsEkCIWCtGX8QUonyfqhJ
        L8NM1EGENupKAzEzY20fbAc7pNtkU7q0Wq0AqMngPJ3301xa/UU82cjbwPbiB4Qb
        zozIiFoc5ijtPtODBiYwcUdtPt8x/KcQRGPaVqRYRe/QCgqq/BSObG5mnl1jTSHA
        LHYlMIBWTFNb4A==
X-ME-Sender: <xms:-_-kYEmm-E0JY8oBToSyr58ls5YpNkOwrLvI2hSDlP46oMAljf6lEg>
    <xme:-_-kYD1_hnnyvTBAxKSgiGkvKufPxMne5_naT7jYoOQ8E4jpIQAeX54YkXgvkaAm9
    8UwzP5CTcwtTfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-_-kYCpTMb4-poiaJLC2X6wLU8oVjLwQmPQuXnCFbgBY90Jf26Y6DA>
    <xmx:-_-kYAmRU6cCYFj05UDbiKHYWtw5sAoXPUQTVnUDUmybMGrfN-WNVw>
    <xmx:-_-kYC2bchEwbI_8cZaH7fxtvLO7So9SKzPVZbH_IV63hhkpu76qKw>
    <xmx:-_-kYFR6NbTpEA4-h75Vkw8AzZDM8LOJSqt2vZPotvORO_s_t3y0CA>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/7] net: Add notifications when multipath hash field change
Date:   Wed, 19 May 2021 15:08:18 +0300
Message-Id: <20210519120824.302191-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In-kernel notifications are already sent when the multipath hash policy
itself changes, but not when the multipath hash fields change.

Add these notifications, so that interested listeners (e.g., switch ASIC
drivers) could perform the necessary configuration.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/ipv4/sysctl_net_ipv4.c | 18 +++++++++++++++++-
 net/ipv6/sysctl_net_ipv6.c | 18 +++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ffb38ea06841..4fa77f182dcb 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -465,6 +465,22 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 
 	return ret;
 }
+
+static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
+					  void *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	struct net *net;
+	int ret;
+
+	net = container_of(table->data, struct net,
+			   ipv4.sysctl_fib_multipath_hash_fields);
+	ret = proc_douintvec_minmax(table, write, buffer, lenp, ppos);
+	if (write && ret == 0)
+		call_netevent_notifiers(NETEVENT_IPV4_MPATH_HASH_UPDATE, net);
+
+	return ret;
+}
 #endif
 
 static struct ctl_table ipv4_table[] = {
@@ -1061,7 +1077,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_fields,
 		.maxlen		= sizeof(u32),
 		.mode		= 0644,
-		.proc_handler	= proc_douintvec_minmax,
+		.proc_handler	= proc_fib_multipath_hash_fields,
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &fib_multipath_hash_fields_all_mask,
 	},
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 160bea5db973..d7cf26f730d7 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -44,6 +44,22 @@ static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int
+proc_rt6_multipath_hash_fields(struct ctl_table *table, int write, void *buffer,
+			       size_t *lenp, loff_t *ppos)
+{
+	struct net *net;
+	int ret;
+
+	net = container_of(table->data, struct net,
+			   ipv6.sysctl.multipath_hash_fields);
+	ret = proc_douintvec_minmax(table, write, buffer, lenp, ppos);
+	if (write && ret == 0)
+		call_netevent_notifiers(NETEVENT_IPV6_MPATH_HASH_UPDATE, net);
+
+	return ret;
+}
+
 static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "bindv6only",
@@ -160,7 +176,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.data		= &init_net.ipv6.sysctl.multipath_hash_fields,
 		.maxlen		= sizeof(u32),
 		.mode		= 0644,
-		.proc_handler	= proc_douintvec_minmax,
+		.proc_handler	= proc_rt6_multipath_hash_fields,
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &rt6_multipath_hash_fields_all_mask,
 	},
-- 
2.31.1

