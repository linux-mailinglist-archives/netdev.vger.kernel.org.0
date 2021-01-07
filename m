Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5989D2ED379
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbhAGPZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:25:03 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41303 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727912AbhAGPZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:25:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0009EB6E;
        Thu,  7 Jan 2021 10:23:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 10:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=F7fnM8zd/xF4bF/u+T209mIHfXva57fEXsETJl7wk74=; b=N5kPGpCJ
        5jMkEZwa/v+2v3fE0nCQV7j7t1wQPrsXl60xEux6U94VuLdBCzFFm50/yqZCOBU3
        LXrWfFH0shuMlvr1E4F4BbwTHOx5mhlLfUWfCKDS4HvZp0D5pbz5drrIAE6nQ0N9
        dKUonWvhT8GjRmG4FJkk+GfsGt+yx0Fvda7qO8xJQMHLYNteH0qSyfCxj89Nex/P
        EhGYT4UVNa5JEs3YJi/3UXEfCxs4Y98vI3XR1rqXZ6CPycf59oadoOXo9cKt3565
        d4UXqtqPHRsR9iFH/qvL5gOFiIy5d2G1tX9Qbl9oOLvsMSH7D36eUiUIFtAmUTmA
        wJrv24bLQPHENQ==
X-ME-Sender: <xms:jCf3X6z0wRER2kDKes7jAp3oqHNxCTfk9tVwN_d4rUKIbVC4YSbtMg>
    <xme:jCf3X2TR7c8Xm8poAffHo4DPCowayvrGw4G4NkZMS7ucLnNqoKAfauEqf39g862YB
    vKC1z41pLMzI4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jCf3X8VX8umuTsqpQ61cqHFPDDvNsQ0ZXfPu_7sNAqcqMUDj7ywWig>
    <xmx:jCf3XwjJiVtWFrrRFX3XRAruFH5p5m-d5b9S34loOsj79u-W8YEBfQ>
    <xmx:jCf3X8CM60MZqbC-PgO37Mff6cIQvAX7D8k4l2qoogMpci7tQHnYXA>
    <xmx:jCf3X_NxU2J87-SmO2mnA8vWQJ6V8l2bXNxUOOkFwx6Z_N1B9GvKoQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7DA5240064;
        Thu,  7 Jan 2021 10:23:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 1/2] nexthop: Fix usage output
Date:   Thu,  7 Jan 2021 17:23:26 +0200
Message-Id: <20210107152327.1141060-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107152327.1141060-1-idosch@idosch.org>
References: <20210107152327.1141060-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Before:

 # ip nexthop help
 Usage: ip nexthop { list | flush } [ protocol ID ] SELECTOR
        ip nexthop { add | replace } id ID NH [ protocol ID ]
        ip nexthop { get| del } id ID
 SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]
             [ groups ] [ fdb ]
 NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]
       [ encap ENCAPTYPE ENCAPHDR ] | group GROUP ] }
 GROUP := [ id[,weight]>/<id[,weight]>/... ]
 ENCAPTYPE := [ mpls ]
 ENCAPHDR := [ MPLSLABEL ]

After:

 # ip nexthop help
 Usage: ip nexthop { list | flush } [ protocol ID ] SELECTOR
        ip nexthop { add | replace } id ID NH [ protocol ID ]
        ip nexthop { get | del } id ID
 SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]
             [ groups ] [ fdb ]
 NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]
         [ encap ENCAPTYPE ENCAPHDR ] | group GROUP [ fdb ] }
 GROUP := [ <id[,weight]>/<id[,weight]>/... ]
 ENCAPTYPE := [ mpls ]
 ENCAPHDR := [ MPLSLABEL ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipnexthop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index b7ffff77c160..20cde586596b 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -38,12 +38,12 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip nexthop { list | flush } [ protocol ID ] SELECTOR\n"
 		"       ip nexthop { add | replace } id ID NH [ protocol ID ]\n"
-		"       ip nexthop { get| del } id ID\n"
+		"       ip nexthop { get | del } id ID\n"
 		"SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]\n"
 		"            [ groups ] [ fdb ]\n"
 		"NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]\n"
-		"      [ encap ENCAPTYPE ENCAPHDR ] | group GROUP ] }\n"
-		"GROUP := [ id[,weight]>/<id[,weight]>/... ]\n"
+		"        [ encap ENCAPTYPE ENCAPHDR ] | group GROUP [ fdb ] }\n"
+		"GROUP := [ <id[,weight]>/<id[,weight]>/... ]\n"
 		"ENCAPTYPE := [ mpls ]\n"
 		"ENCAPHDR := [ MPLSLABEL ]\n");
 	exit(-1);
-- 
2.29.2

