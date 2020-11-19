Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7AB2B93FE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgKSN5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:57:53 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46261 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727153AbgKSN5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:57:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 66EF9D6A;
        Thu, 19 Nov 2020 08:57:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ejAt+q9G8UiAOjyJB4x8oyn90bu7s3R/wkdqE/r8Xx4=; b=LS8/tsrN
        c5QuRsLcfLULOPDEo7TMl1VeBDO8tIw/E6bd5DGMDQKAbWwVYP70YhUDI0EuACOw
        nk5VzLjTVsDG8NU+GLPvivDtW68jTHA3b5c1ZncTI7wrOrHXdoYg41Q7r2Q2c/ZY
        hotacGPWwaWAEY37RCh6JrMC0XiPUAEJvRVjBFKKsDnUIocBEnPG/u+3qp2cltAJ
        OABWYgC6m+yOBSVFCt/Y6yow8rxfC2V7TzXuLR1egwNnBl6iHF/eILpOlK8SH7eg
        NdIT0o0d3ODKkRrGShhejPnondbll32viVAtlYeGICxoy+6o9CYVaQfC8eNGBtYq
        NxUYc29Ap49XPQ==
X-ME-Sender: <xms:33m2X8rPvOXN_buNbi7TLiG-EiN9cj8SxHt3TxiqisxWqcMduPaDHQ>
    <xme:33m2XyoRQnZ20wRjKk4G06wY6RH2R5t3HR0onURd6tRQqEShhg_JR1AQiQS8zRZTp
    gOmzRbcS6sIW1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:33m2XxNjpetxfxeGe77tyDSP84hkhZflCet-TFVmWuFB-Qehn7dAFA>
    <xmx:33m2Xz6t1QBJgo21goyn2GHT_b_JVVkG8MTx7MOAdEEtKH1WTAgc9g>
    <xmx:33m2X747DAqPuclr5rZTZyo6SvjleQ2qpAu2QyCDQHNvliTNw0mNAw>
    <xmx:4Hm2X1TicXlJq2RSo2hvCYObDKg2N1axCuR0IwScfFdThi1LhtTVow>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id B85653280068;
        Thu, 19 Nov 2020 08:57:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 2/2] nexthop: Always print nexthop flags
Date:   Thu, 19 Nov 2020 15:57:31 +0200
Message-Id: <20201119135731.410986-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119135731.410986-1-idosch@idosch.org>
References: <20201119135731.410986-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, the nexthop flags are only printed when the nexthop has a
nexthop device. The offload / trap indication is therefore not printed
for nexthop groups.

Instead, always print the nexthop flags, regardless if the nexthop has a
nexthop device or not.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipnexthop.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 22c664918fcc..b7ffff77c160 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -263,8 +263,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 			     rtnl_rtprot_n2a(nhm->nh_protocol, b1, sizeof(b1)));
 	}
 
-	if (tb[NHA_OIF])
-		print_rt_flags(fp, nhm->nh_flags);
+	print_rt_flags(fp, nhm->nh_flags);
 
 	if (tb[NHA_FDB])
 		print_null(PRINT_ANY, "fdb", "fdb", NULL);
-- 
2.28.0

