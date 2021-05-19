Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FED388D9C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353376AbhESMLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:11:06 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54869 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353353AbhESMLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:11:03 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id E718D5C017C;
        Wed, 19 May 2021 08:09:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Wed, 19 May 2021 08:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/B2S5KusQsS5ldAGpqXkgxyobJDBYnXn7NRpMQ5mnDY=; b=PZxJEc8l
        6cuIXltuMH0lCZactaLd6ym6txPs2CBiuYTGkqOa7w3SJu7UThnAMVp3nWYGL10B
        FvalruzP74oOv1xtgJdjDPnKCMR+NJshzVHREIAnEnz6kYuwGFv3xFABtjxUAb3I
        KT5BONZHD1QbFCjNKMo7l2nFhq8zFlAmzPHt/UWPzRWz/PvwxhxoOh+KVHMjRibv
        J9JWJZnnHlqWbUCMdShb7tS4JWDkv84cnXYUz5SqKMASvnABIjJ1/5WCJGO1b2CJ
        maOLf4qBZYe5jMfBeFFiBj6oTzNe0tULgvjGgdkorJvfz2bplGQ2vUjlPPQp5J2j
        FPnnJCWK5Vp6/g==
X-ME-Sender: <xms:BwClYA4fydO4LvM4jfowuVJhtN3j08IeWCtgc5Dzs3CaqiLmKUVYCg>
    <xme:BwClYB7pZuvqqVfCOadD0w0zevSyXksW583vWCJM2qsWqu1TNeaSW1zKIqMhXueQB
    MZi3XKPFOH0YEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BwClYPeNSpOfrg66WAXjXt7Ls5fTNyXCDcRkVB_JFdvbYzyzfH2ReA>
    <xmx:BwClYFLI4QgB4HhjEw8XVq_PcNS1OuTxOlBo_eYiGjoQswzUh0ztow>
    <xmx:BwClYEK796X5MAuVv507fcblOoNzA19Zf-gZwpK0Y35M46YHwtW3Fg>
    <xmx:BwClYJFLqLLp8FGFWjCDK0n1JxVMC4nSPx7EB5j_nADFGL22BPWfjQ>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/7] mlxsw: spectrum_router: Add support for custom multipath hash policy
Date:   Wed, 19 May 2021 15:08:24 +0300
Message-Id: <20210519120824.302191-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When this policy is set, only enable the packet fields that were enabled
by user space for multipath hash computation.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index bacac94398dd..6decc5a43f98 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9647,12 +9647,53 @@ static void mlxsw_sp_mp4_hash_outer_addr(struct mlxsw_sp_mp_hash_config *config)
 	MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
 }
 
+static void
+mlxsw_sp_mp_hash_inner_custom(struct mlxsw_sp_mp_hash_config *config,
+			      u32 hash_fields)
+{
+	unsigned long *inner_headers = config->inner_headers;
+	unsigned long *inner_fields = config->inner_fields;
+
+	/* IPv4 Inner */
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV4_EN_NOT_TCP_NOT_UDP);
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV4_EN_TCP_UDP);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV4_SIP0, 4);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV4_DIP0, 4);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO)
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV4_PROTOCOL);
+	/* IPv6 inner */
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV6_EN_NOT_TCP_NOT_UDP);
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, IPV6_EN_TCP_UDP);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP) {
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_SIP0_7);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV6_SIP8, 8);
+	}
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP) {
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_DIP0_7);
+		MLXSW_SP_MP_HASH_FIELD_RANGE_SET(inner_fields, INNER_IPV6_DIP8, 8);
+	}
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO)
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_NEXT_HEADER);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL)
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_IPV6_FLOW_LABEL);
+	/* L4 inner */
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, TCP_UDP_EN_IPV4);
+	MLXSW_SP_MP_HASH_HEADER_SET(inner_headers, TCP_UDP_EN_IPV6);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT)
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_TCP_UDP_SPORT);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
+		MLXSW_SP_MP_HASH_FIELD_SET(inner_fields, INNER_TCP_UDP_DPORT);
+}
+
 static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_mp_hash_config *config)
 {
 	struct net *net = mlxsw_sp_net(mlxsw_sp);
 	unsigned long *headers = config->headers;
 	unsigned long *fields = config->fields;
+	u32 hash_fields;
 
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
 	case 0:
@@ -9671,6 +9712,25 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 		/* Inner */
 		mlxsw_sp_mp_hash_inner_l3(config);
 		break;
+	case 3:
+		hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+		/* Outer */
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, TCP_UDP_EN_IPV4);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+			MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_SIP0, 4);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+			MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV4_DIP0, 4);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV4_PROTOCOL);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
+		/* Inner */
+		mlxsw_sp_mp_hash_inner_custom(config, hash_fields);
+		break;
 	}
 }
 
@@ -9690,6 +9750,7 @@ static void mlxsw_sp_mp6_hash_outer_addr(struct mlxsw_sp_mp_hash_config *config)
 static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_mp_hash_config *config)
 {
+	u32 hash_fields = ip6_multipath_hash_fields(mlxsw_sp_net(mlxsw_sp));
 	unsigned long *headers = config->headers;
 	unsigned long *fields = config->fields;
 
@@ -9714,6 +9775,30 @@ static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 		/* Inner */
 		mlxsw_sp_mp_hash_inner_l3(config);
 		break;
+	case 3:
+		/* Outer */
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_NOT_TCP_NOT_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV6_EN_TCP_UDP);
+		MLXSW_SP_MP_HASH_HEADER_SET(headers, TCP_UDP_EN_IPV6);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP) {
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_SIP0_7);
+			MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_SIP8, 8);
+		}
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP) {
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_DIP0_7);
+			MLXSW_SP_MP_HASH_FIELD_RANGE_SET(fields, IPV6_DIP8, 8);
+		}
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_NEXT_HEADER);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_FLOWLABEL)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_FLOW_LABEL);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_SPORT);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+			MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
+		/* Inner */
+		mlxsw_sp_mp_hash_inner_custom(config, hash_fields);
+		break;
 	}
 }
 
-- 
2.31.1

