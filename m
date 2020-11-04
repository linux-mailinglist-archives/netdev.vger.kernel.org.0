Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039CC2A6541
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgKDNcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:14 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35943 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730107AbgKDNcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:32:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 368FB5C0100;
        Wed,  4 Nov 2020 08:32:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Xg+NZ+OrsHcXvXl+Tj5NZ4Z6PLEZZCUfV45t1yQ0kAU=; b=jNbIuFdf
        K1GKKw2vR8gdsb9E9pelJGX2+tGfbI6L+bPfnotK7C1LiE6CfwmfxfGPLNNjsWaz
        RuqxIUNZ3V5xNwjqZY6QulHQq4vFnqwf8yb8UjtnPYwSFz5sIzENLo06t+AhflzB
        eDUbItouiWredU2+2ebEpaWS9N30MzOyNr1libtwBcKjE00dyL3nvTUHmDKEA5vX
        MFMKOQelrsQpRra9uD6Qt7oo8/v1tN9AEWDe0tZORW5A88WnbRqgHrV0SVvajhjt
        CqaBue0+xK8HdpIVVo04lIFovyZ2OsVRY4TYi1OhttpNbRlXpEq9CHPDKz2wkU90
        W7ENdcm8YFbuUQ==
X-ME-Sender: <xms:Va2iX7sFoeOdAnB9cs3jayFd5qPNP12xqn1s68GDplthib7LA5k84g>
    <xme:Va2iX8eOD1HoLd2jYk7GxDJLvNuI2vyETg0Siv9A042irw3MRi1IG72n6hwibTqBI
    MKEzw0I5nPcC1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedugeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Va2iX-zsuqbwVxE9btSmV7TaP_5Np172RXicuVDwR-NVYkUuQmEoRg>
    <xmx:Va2iX6NU5kTIkSxZJ2GaLyvQTZX74wafIooW5ZRSUmXGepIVBAPSUQ>
    <xmx:Va2iX78_pOLwvEp81sRDDZyvy6l_mjJcWTSCLA65CgSr0CNtUn6eIw>
    <xmx:Va2iX-aP6OGOe8nuNqYMtsPTGaCBXUJttR_ctSy9oD9DqIVTH7_x_Q>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5ABF3064684;
        Wed,  4 Nov 2020 08:32:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 17/18] netdevsim: Allow programming routes with nexthop objects
Date:   Wed,  4 Nov 2020 15:30:39 +0200
Message-Id: <20201104133040.1125369-18-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Previous patches added the ability to program nexthop objects.
Therefore, no longer forbid the programming of routes that point to such
objects.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/netdevsim/fib.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 9bdd9b9693e1..45d8a7790bd5 100644
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

