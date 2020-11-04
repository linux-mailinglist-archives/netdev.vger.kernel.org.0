Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88352A6534
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgKDNbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:43 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54707 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729768AbgKDNbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5636C5C0046;
        Wed,  4 Nov 2020 08:31:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lArjdDd/nGjEALp9a7vhndik7+Qb4T7cFCEFR1nLPCk=; b=m23Qmy1J
        HdAdq5fR/WduvSMzG/+cbVM3/ngws/hf30TzHAuamLpolbW7u5QgB+8kAvCmrkN4
        sVBDhk0FugNCRJiyMsqAelk0wRI4Q64/6CP+LCVR4MuoU3JDqbn4dEO1krShDWkw
        eVATzNjiWsJI+eJ/vkp+1jowDNVloi9m6VXu/QIR/mClSNzaFEJL1N0Km+bohPxC
        lMnEW8QUtr2XqMDHchmkzMK+JUBNjz3DfwppNAOVVbKkSaN+TpggYR07ZvICL9LN
        HDcoP4s7VBoOY4f7RtM4gWRaHo1PWYDe5x0mJrXNgFsOzWKHJbeAsuoWNWTt3s1K
        LJ7FNznAZrLF2A==
X-ME-Sender: <xms:Pa2iXysyFjsCeHsd8VK_gQ2WU7hDwHc5jUMUDUGaoq-e2FhEWbam8Q>
    <xme:Pa2iX3caIOsMlik8Wpol5TBP_8VbMwKwmvZMzam2MdMi9HVIbD2QPInZieTwuuvtP
    Z97XAhlpw20qTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Pa2iX9yGhoM4W2I3MsRXZSUpBn7Ra3aGjQKR8xluOSNulHqyjEJBuw>
    <xmx:Pa2iX9N_JD2Em8m1CauINUPiNM0wXhc9cxVwWmcXAdwz6klU3VgsPg>
    <xmx:Pa2iXy_DKeBGyE0M5F-M8WL9TMH8-ogGaVxkrbfc4-LMWXACH7pPiA>
    <xmx:Pa2iX5ZMEt_Tz2xO4Lie3cCZok1Z15tssnhrlTIk4uWPdEak3E7DAg>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9C4A3064610;
        Wed,  4 Nov 2020 08:31:39 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/18] nexthop: Add nexthop notification data structures
Date:   Wed,  4 Nov 2020 15:30:23 +0200
Message-Id: <20201104133040.1125369-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add data structures that will be used for nexthop replace and delete
notifications in the previously introduced nexthop notification chain.

New data structures are added instead of passing the existing nexthop
code structures directly for several reasons.

First, the existing structures encode a lot of bookkeeping information
which is irrelevant for listeners of the notification chain.

Second, the existing structures can be changed without worrying about
introducing regressions in listeners since they are not accessed
directly by them.

Third, listeners of the notification chain do not need to each parse the
relatively complex nexthop code structures. They are passing the
required information in a simplified way.

Note that a single 'has_encap' bit is added instead of the actual
encapsulation information since current listeners do not support such
nexthops.

Changes since RFC:
* s/is_encap/has_encap/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 2fd76a9b6dc8..4a17b040b502 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -108,6 +108,41 @@ enum nexthop_event_type {
 	NEXTHOP_EVENT_DEL
 };
 
+struct nh_notifier_single_info {
+	struct net_device *dev;
+	u8 gw_family;
+	union {
+		__be32 ipv4;
+		struct in6_addr ipv6;
+	};
+	u8 is_reject:1,
+	   is_fdb:1,
+	   has_encap:1;
+};
+
+struct nh_notifier_grp_entry_info {
+	u8 weight;
+	u32 id;
+	struct nh_notifier_single_info nh;
+};
+
+struct nh_notifier_grp_info {
+	u16 num_nh;
+	bool is_fdb;
+	struct nh_notifier_grp_entry_info nh_entries[];
+};
+
+struct nh_notifier_info {
+	struct net *net;
+	struct netlink_ext_ack *extack;
+	u32 id;
+	bool is_grp;
+	union {
+		struct nh_notifier_single_info *nh;
+		struct nh_notifier_grp_info *nh_grp;
+	};
+};
+
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 
-- 
2.26.2

