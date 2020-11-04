Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14DA2A6537
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgKDNby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:54 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50013 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730011AbgKDNbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 518FA5C0056;
        Wed,  4 Nov 2020 08:31:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=hO0EcjHEitP1/og8n8Jch81iiMOR33laBnCDpX+ehvQ=; b=luH6G/Mf
        9XiJ6yM7B4aZrVs73raZWuxQtu0us1P5znhp7D+NOlIsHkPHZYiAxnSSNdK9VY5x
        BrOqBe6ne0jFP7HMJjnkw3Kp4hlUsbgPwDuT5CaqaJbJKEHtDFDeVnqGMOa+xU1z
        Su6yxYGdivY8HNM7aVPcaVfxSEuVpl8xeqktKj+gm7ysuHy5J1avrO4EXE5v+hHe
        AP/mmhfYgY9KSm8UUI6rCURMlVl+OmmA4AD71IkesqlBYRJH5P4zij4ZdD4V9Ogb
        SvtUIsjIGCM4dqFtYHdFiW18+DFQb2tAP0Xrn5Rfg0fpw16D0T7aZcqvRxJ5/BU9
        3qjYun/ma+7frg==
X-ME-Sender: <xms:Rq2iX19oL3QO1loyBqR5qMQVpd_GoLM84w04QHeTjlUrspJ0SUWJNg>
    <xme:Rq2iX5vmfvHCa1XxCxvu1XerIAjiiVtgGXek4my9lxJQcHpKp9kAO7q9ctSWXLBIy
    ha60MnueJ1mYV0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Rq2iXzDKe84eyQ4KuoxFzQXI4nvojTx0w8Hn-etjedlDHSPwRurgfg>
    <xmx:Rq2iX5eif2uVUhctTcScceuCJ9l9mVb87ETnnOYq9oWUCvCBVQiIlg>
    <xmx:Rq2iX6Oo44L2q3z8aqx-0zntDS4CPpjlFIVwuWqP2pYECclC8zU0_A>
    <xmx:Rq2iX3qf9KQcjZiSxkA8_eOEhqyCVUbmD6xeA1e4j-JGPqa39Mp16w>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0D6D3064610;
        Wed,  4 Nov 2020 08:31:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/18] nexthop: Emit a notification when a nexthop is added
Date:   Wed,  4 Nov 2020 15:30:29 +0200
Message-Id: <20201104133040.1125369-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Emit a notification in the nexthop notification chain when a new nexthop
is added (not replaced). The nexthop can either be a new group or a
single nexthop.

The notification is sent after the nexthop is inserted into the
red-black tree, as listeners might need to callback into the nexthop
code with the nexthop ID in order to mark the nexthop as offloaded.

A 'REPLACE' notification is emitted instead of 'ADD' as the distinction
between the two is not important for in-kernel listeners. In case the
listener is not familiar with the encoded nexthop ID, it can simply
treat it as a new one. This is also consistent with the route offload
API.

Changes since RFC:
* Reword commit message

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h | 3 ++-
 net/ipv4/nexthop.c    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index aa7ac12c35e2..9c85199b826e 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -105,7 +105,8 @@ struct nexthop {
 };
 
 enum nexthop_event_type {
-	NEXTHOP_EVENT_DEL
+	NEXTHOP_EVENT_DEL,
+	NEXTHOP_EVENT_REPLACE,
 };
 
 struct nh_notifier_single_info {
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d1a1600aee18..4e9d0395f959 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1278,7 +1278,11 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
-	rc = 0;
+
+	rc = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack);
+	if (rc)
+		rb_erase(&new_nh->rb_node, &net->nexthop.rb_root);
+
 out:
 	if (!rc) {
 		nh_base_seq_inc(net);
-- 
2.26.2

