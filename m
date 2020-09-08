Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93288260E70
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgIHJNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:06 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48827 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729062AbgIHJLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 87343386;
        Tue,  8 Sep 2020 05:11:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YNjs16PNMRJ98qr80C7fw+5YBwQu350eFRNnvBdUbws=; b=rbQeF5I8
        3dRNCcrkEnDpyDkbguMCuotR9SF+sJZjT3HQZdC89K0oK+0G33aqrd+4qBIH5pr7
        Je2oBLdE8qoHLbmDtLdvlwfbR1J9eEX72YpYo7kPTPH2YsMgnXvjnre7QW3uWQ3F
        DXYAJUP4yTUwGvGFQVwvNPaWragLP8S/8qnxE6+3s8SOOtZEZvb1HCCbdz6w/2sf
        h3WuXwk3Ob2rPg5h1DUFRAN/4xzeRMVxdN1nOGpMfbvkwZARq2FVjrvSCuOXzlXl
        zO+AZ1VB6TX66pLmbPIYWHdiNoBvHscs735BiU1dC6CcGGsCRY6ewYksU6i6YHvl
        COmPY5OMW3y6Aw==
X-ME-Sender: <xms:zkpXX8FjQcqMjIZpRHwmQcaqWJJUg2pws69UH-uZPGpBCwxqS1URKg>
    <xme:zkpXX1X7WHlank2QJUa1gI4XuHd7fFCkm2_2mamwrZXkJbZWpPlb68gzAm-is0OAI
    b3Zv1_prDhKosQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zkpXX2K5bfwVRcKv2KPNscMpdZe9MPDUx71pUOL2zfDpo-T1AhNS-w>
    <xmx:zkpXX-FmgTa46ENpLFtnrmtAnH13YH2DGIlA3zcsnhP3vxTMzxN9ZQ>
    <xmx:zkpXXyW4Nqlxw3pWGgAsW1s0tIpYLDBkbDCTvLGkGZdkx-CBupUVBw>
    <xmx:zkpXXxS3OQ-bGGFOkmG26MnRXCkgMQ1qb1tgqP0Y6POOVffvKdpyKg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBEF9306467E;
        Tue,  8 Sep 2020 05:11:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 11/22] nexthop: Emit a notification when a nexthop is added
Date:   Tue,  8 Sep 2020 12:10:26 +0300
Message-Id: <20200908091037.2709823-12-idosch@idosch.org>
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

Emit a notification in the nexthop notification chain when a new nexthop
is added (not replaced). The nexthop can either be a new group or a
single nexthop.

The notification is sent after the nexthop is inserted into the
red-black tree, as listeners might need to callback into the nexthop
code with the nexthop ID in order to mark the nexthop as offloaded.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h | 3 ++-
 net/ipv4/nexthop.c    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 4147681e86d2..6431ff8cdb89 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -106,7 +106,8 @@ struct nexthop {
 
 enum nexthop_event_type {
 	NEXTHOP_EVENT_ADD,
-	NEXTHOP_EVENT_DEL
+	NEXTHOP_EVENT_DEL,
+	NEXTHOP_EVENT_REPLACE,
 };
 
 struct nh_notifier_single_info {
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 71605c612458..1fa249facd46 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1277,7 +1277,11 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 
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

