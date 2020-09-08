Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49016260E67
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgIHJM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:29 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43801 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729132AbgIHJL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 80D71714;
        Tue,  8 Sep 2020 05:11:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=SItLM6lNDjSozGciH5D1kYg3cS8Xj05z1Vjk3Pq58+M=; b=i/8XAGtW
        Rfh9asbIB8k141zTCxv2Qeymx0CHW4mnBhfTXxsr5aFuRGq1Yvq9tzE74+IaPjp2
        1o5sorhfdd/SRjqYVnYBxIoaSFQly+j+MQP1t8TwCNChar461eV0Szbc7UN9CmdR
        B+Lq48PqTc5klmTyrBj3dTTCJjNRbtGV3PsuCLJoZ+iE9NYl8jTNPydGPZQHfPmv
        PrZxQlWIxBHE//tX6t1kmmT0t3xyvx+ChFXeom4RQgSabOc4t15jo6iBN/76wTds
        oF24HDmTKqShs++NE3FmA1earig4yg6dlF19UBdzgjxYEprEVCD2H98kBIss71Zx
        Avqb54UCztL9HA==
X-ME-Sender: <xms:3UpXX7aaocIykq6AoDYG4eHAVmlM2QpY9RpwqE2G6UQOS-zt_CxrmQ>
    <xme:3UpXX6Z_jMsPXHARPecFr6bcqe0cVk-DJkmvXw_EEd6w6fRri-MElFFodIJCgsEyI
    svutUcn5jsZz6I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3UpXX9_V6X0cVPvehF70qMnr2Tsctcby05RpzMdeKS4kGIE6mSt5lQ>
    <xmx:3UpXXxrWLYOXn0rpdzrHQWvmzE6uAS5DiEG1PSvSsYiM8XIdQEE_eQ>
    <xmx:3UpXX2pJGzGlWFl2eIY7vmiFcV-tU83y0GkgICVWKj4cId8JKxWBqg>
    <xmx:3UpXX5XaT1A4vTsM92wbkLbNtdRG7d8XTOSYr2GxE458HEo-JPFCfw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF359306467E;
        Tue,  8 Sep 2020 05:11:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 21/22] netdevsim: Allow programming routes with nexthop objects
Date:   Tue,  8 Sep 2020 12:10:36 +0300
Message-Id: <20200908091037.2709823-22-idosch@idosch.org>
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

Previous patches added the ability to program nexthop objects.
Therefore, no longer forbid the programming of routes that point to such
objects.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 196deed0aa97..731201519380 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -412,11 +412,6 @@ static int nsim_fib4_event(struct nsim_fib_data *data,
 
 	fen_info = container_of(info, struct fib_entry_notifier_info, info);
 
-	if (fen_info->fi->nh) {
-		NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
-		return 0;
-	}
-
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 		err = nsim_fib4_rt_insert(data, fen_info);
@@ -727,11 +722,6 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 
 	fen6_info = container_of(info, struct fib6_entry_notifier_info, info);
 
-	if (fen6_info->rt->nh) {
-		NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
-		return 0;
-	}
-
 	if (fen6_info->rt->fib6_src.plen) {
 		NL_SET_ERR_MSG_MOD(info->extack, "IPv6 source-specific route is not supported");
 		return 0;
-- 
2.26.2

