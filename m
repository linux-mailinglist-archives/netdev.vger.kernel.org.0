Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D355A2B9334
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgKSNJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:39 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35383 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbgKSNJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 32889A7C;
        Thu, 19 Nov 2020 08:09:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=wyLQQ/oF8gPUycgivvy2i435gjqllicWErsURLmHsVM=; b=anx1ioFe
        mavvGZHLp1ZUs1GTTEAGff1rvoRBR0M0zde78tv+pE8Tm23bjk3LzQQm7XWF+qMC
        vfSAclUm3kLlOFPfzL/fr2XCPDtQa4CLK6Q2fsgHa89hsdIjJUlA+CDjyIK2xApL
        Mz+p1PSVu+w2tXa5Hy2ZVs7pdrK/108uEoxuTYHXbHMuQN22k3LoATRrade34Ps+
        0RuErtj0yFzyQVIjJ7JEG+ylQ/0NMhrljJ0YX143H0wwzeDgfo+T9wZzXBFNwwv2
        qknEuPkESGiQPfavZ2hUT/6tA84ZZ/Ghik/TdTZPHMvhHlFSDNjgPoytcXas61e+
        sTkqyY3pDlvn9w==
X-ME-Sender: <xms:jG62X4qTHwFKZEQsu9zX6GF8lBT0qw-324_fv1s5L-r-a-TlH-vzBw>
    <xme:jG62X-rpLdDegQFFXrtcbMzfYuEVJfpzUYdu_803uK0tWGw1tah442shdyK4Pa8S9
    vjYou9D0oZxZ4k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jG62X9MszWoyBaSEW6j1g8XGJoiCWC5a-2pJDj0hhYXjEiYV-XzQVg>
    <xmx:jG62X_4TCWEiW0y4s5VKp7sd_mleo2kmdttppeg6VfFOcg0MdIEThw>
    <xmx:jG62X357P2dxv_D9fcYlO7wEwWCGYY6YJFRyQAqAqDyD8b2vKEH5xw>
    <xmx:jG62X5lxbHj2qnw2CL3uUbu2nYs1lToxT3Vz_3hpbazAhnCoM86kKw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF7603280064;
        Thu, 19 Nov 2020 08:09:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] selftests: forwarding: Do not configure nexthop objects twice
Date:   Thu, 19 Nov 2020 15:08:45 +0200
Message-Id: <20201119130848.407918-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

routing_nh_obj() is used to configure the nexthop objects employed by
the test, but it is called twice resulting in "RTNETLINK answers: File
exists" messages.

Remove the first call, so that the function is only called after
setup_wait(), when all the interfaces are up and ready.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
index cf3d26c233e8..6067477ff326 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -312,7 +312,6 @@ setup_prepare()
 
 	router1_create
 	router2_create
-	routing_nh_obj
 
 	forwarding_enable
 }
-- 
2.28.0

