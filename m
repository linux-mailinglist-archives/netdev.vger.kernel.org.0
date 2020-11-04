Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA1E2A653B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgKDNcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:03 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58949 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730107AbgKDNb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 41D895C00E9;
        Wed,  4 Nov 2020 08:31:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=yH4Arn46IrHYs20vygPRKOHzYDG5jI0yFctPfvXCG80=; b=IkiIed8O
        FvgegX2AbYhXAbKOrEm1bxE7nYElPULotjgVlgfqb9qCiy8kBsgD7vfg8E0M9d9s
        XaXt0TBLbtmC18tavc4vZOOjWI47kzD523RYKpwkfaNvfyHUfP/AXx6QLVeLnp/b
        /wUUCm5lxoCYYNkeyWwPEYKMgoYtA2oq42B+vnjY17LEvyT5ZdToxixsvk6aQemv
        8V/Qn2MJAU+EdA4wBOFyKyZhwvzfnjoUPKUtx5+oe3sKl4H6KtivzNifgRxTIKxQ
        42Bi+yRKg7k3bwg4zH30WEGiWLg/lVaLgg9+ZuvQEkLerxNMk67SrK4lLaYmvFYs
        dWUkzFwDvi6xcQ==
X-ME-Sender: <xms:TK2iX1CjDseenm1TprCvQN5DCB5ELzLEZ3UGia09tZhIWFSSmIDMLg>
    <xme:TK2iXziFqx1qc8obn5Gi7OUCBb_uXpLgliL7kfbriXMjD8Tna8Mq1FCJfizfLCDS4
    f4A6lIM2LF--IU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TK2iXwlhuBL_LJbkh68Pq4Efa1JxM8sbpi2_jllqySXRbBTlT5t-dg>
    <xmx:TK2iX_zS3iYh5fn7cnz7O-Vpklpzq-U8NbJNei0nws2FfafQNOkZtg>
    <xmx:TK2iX6QBAgMeJEDRoEZZ3qONryh9icdGhheLqkpp51HaVMFGXZIbow>
    <xmx:TK2iX4eLtmQTRZNww8CtRsXag3Cw0dIIAmmSlDG9VmntP5UqwiLJmw>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6E183064610;
        Wed,  4 Nov 2020 08:31:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/18] nexthop: Emit a notification when a nexthop group is reduced
Date:   Wed,  4 Nov 2020 15:30:33 +0200
Message-Id: <20201104133040.1125369-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When a single nexthop is deleted, the configuration of all the groups
using the nexthop is effectively modified. In this case, emit a
notification in the nexthop notification chain for each modified group
so that listeners would not need to keep track of which nexthops are
member in which groups.

In the rare cases where the notification fails, emit an error to the
kernel log. This is done by allocating extack on the stack and printing
the error logged by the listener that rejected the notification.

Changes since RFC:
* Allocate extack on the stack

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0e8e753956f1..d5a2c28bea49 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -892,9 +892,10 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 {
 	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
+	struct netlink_ext_ack extack;
 	struct nexthop *nh = nhge->nh;
 	struct nh_group *nhg, *newg;
-	int i, j;
+	int i, j, err;
 
 	WARN_ON(!nh);
 
@@ -942,6 +943,10 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	list_del(&nhge->nh_list);
 	nexthop_put(nhge->nh);
 
+	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, &extack);
+	if (err)
+		pr_err("%s\n", extack._msg);
+
 	if (nlinfo)
 		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
 }
-- 
2.26.2

