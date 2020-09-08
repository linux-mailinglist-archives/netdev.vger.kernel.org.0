Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28337260E61
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgIHJMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:06 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49383 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729031AbgIHJLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 04DABF4B;
        Tue,  8 Sep 2020 05:11:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=UNICPCzNoF6gDHAjNSu8ofVG7nAgXFsrlfz4sICA6X0=; b=hOyXbRLd
        pZ7mJ/7xSH9SldYyLzggI34bGctwqPmXyKSXdGaESIE1LGwpNCKi4VeT8j9FG75J
        h3nsBz/72tZZwcPQ/bCbKGM+zt+d3oKnolfWlhXzJJ8SWSTFfPT4AZEz13qqhPhH
        Mst4Wzn9tEpCfP2q0ZKDgA3VTReh2MtxIQFB3KdHZTUTLOauzPynqH2GTSwYJe+n
        pM6zvcrOZwfU1s8oGTYVupqt0DFWlcx6FnPfoTiMD6vACkbUinlYKEIZ6YKVAulJ
        XHjEy8cFUQoBcbsTYpMNTLWsUi7ZydonHDrbjvzaQjc1sL/ZFzyXXDwYjcfXxq1W
        vZjeWFgWylwgEw==
X-ME-Sender: <xms:xkpXX8GKNCGaqQNpzBRPivbX8sFrHGvzDJfW72t4CuV9iNAdZ1JWCA>
    <xme:xkpXX1WW6uegYCgWhRW0ztvbN9mlhnjHcJWtWScLstnzfz3nDaVS6b6uHKbLiaJoI
    BB9CXy7kPScjAo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xkpXX2K4rsWVV_nmSEC-zWj7YpOsvhUJZ1aQ1IK0u2dSb0bG4kZ8qg>
    <xmx:xkpXX-H5R2BGoibbDVEy_UXIT_4v5kgjV7HXr_5r-ngVDwtq_E5vZg>
    <xmx:xkpXXyVP1V4vx-7rsIlxT_FjpyCUPGDo_lZgzkMx2_V5udzkLKQmLQ>
    <xmx:xkpXXxRiCG-jFI4SHi3I0a18O_VuCdCoVeqVPBLzkK3VjSA0-P0p_Q>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D4373064685;
        Tue,  8 Sep 2020 05:11:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 06/22] nexthop: Pass extack to nexthop notifier
Date:   Tue,  8 Sep 2020 12:10:21 +0300
Message-Id: <20200908091037.2709823-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The next patch will add extack to the notification info. This allows
listeners to veto notifications and communicate the reason to user space.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8c0f17c6863c..dafcb9f17250 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -38,7 +38,8 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 
 static int call_nexthop_notifiers(struct net *net,
 				  enum nexthop_event_type event_type,
-				  struct nexthop *nh)
+				  struct nexthop *nh,
+				  struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -907,7 +908,7 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   struct nl_info *nlinfo)
 {
-	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh, NULL);
 
 	/* remove from the tree */
 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
-- 
2.26.2

