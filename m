Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3138260E62
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgIHJMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:09 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45637 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728893AbgIHJLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 831673C6;
        Tue,  8 Sep 2020 05:11:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=6sDvyV6nHM2e+43BZ0OKQE+nuM4eHY//eaxzRdo1xIo=; b=FampHECY
        +jWair606A38BT1qqLWr9El+glrcf++W1ukgeELHUi8X4IDxBq5nlhQjccFcMw/B
        60xTU+A93nKOkOJlCizrr6Uqd+oM1qPxO+sIHtqC1DjhIbG9+5EZxco72RaDzU1I
        EoRs6H5ylOCjaxfk6iUcdNYpcZSH0OCldjmRzpN9m60skkXiRBufZ0Gmo4tNRl7G
        A3EcSXKoNGrL/dX+vPKcVXzjAajNlHGDWzUH8YBk7YbQdXuFrs8LspkFGNlnvpI5
        3S/XfP1xRegLlXPR2RT8TeNN9IOlXnxTmN0fgQv7Ox7tfKGYG2O6avxVD0k94Uq4
        8eZPWfeCyFwe4w==
X-ME-Sender: <xms:1EpXX2M45BBO5TVZV3jq44jqLxMO6v18MZsrspfLvMY4EUvwqr6YdA>
    <xme:1EpXX08QD1k_9vdeSyhp_bKjtRQxv3jEPDSOqE7ELMCV3VeaWe81Jw1ANrHZ4mwAk
    f-A6YUpoiBns1E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1EpXX9RDRfbkjFGtxMyXHhFZ-grTZ9DVnszP6xhhjdR2nYB0IVgB7g>
    <xmx:1EpXX2vFwbpvFEjtqmnXzD32Q-ev8TLnkeRkW8APXN0FazJVOWoiSw>
    <xmx:1EpXX-f0xqD1eov_jushwYBnxfOjFsbI5V0d_fXKxoXZM64a7g8d5Q>
    <xmx:1EpXX-7azhgJ6srFgngp1ndAs2qoqO3M-QaeAxJ64zPQOYRZDq0Dbg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF4CA3064680;
        Tue,  8 Sep 2020 05:11:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 15/22] nexthop: Emit a notification when a nexthop group is reduced
Date:   Tue,  8 Sep 2020 12:10:30 +0300
Message-Id: <20200908091037.2709823-16-idosch@idosch.org>
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

When a single nexthop is deleted, the configuration of all the groups
using the nexthop is effectively modified. In this case, emit a
notification in the nexthop notification chain for each modified group
so that listeners would not need to keep track of which nexthops are
member in which groups.

In the rare cases where the notification fails, emit an error to the
kernel log.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0edc3e73d416..33f611bbce1f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -893,7 +893,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	struct nexthop *nhp = nhge->nh_parent;
 	struct nexthop *nh = nhge->nh;
 	struct nh_group *nhg, *newg;
-	int i, j;
+	int i, j, err;
 
 	WARN_ON(!nh);
 
@@ -941,6 +941,10 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	list_del(&nhge->nh_list);
 	nexthop_put(nhge->nh);
 
+	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, NULL);
+	if (err)
+		pr_err("Failed to replace nexthop group after nexthop deletion\n");
+
 	if (nlinfo)
 		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
 }
-- 
2.26.2

