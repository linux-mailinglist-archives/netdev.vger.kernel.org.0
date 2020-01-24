Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2E21485F2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389801AbgAXNYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:35 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53255 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387915AbgAXNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0363721F1E;
        Fri, 24 Jan 2020 08:24:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=568WLC5nyoFsAyxld7mclH7GGlsK221n9oIhsWphaSc=; b=s0Tglwnh
        2532Ny36RVspPaN4Nx+9/e5EZXnvAC84vlMSB8MjPmU6s8BNfgTs/3S5fV1jBP9q
        iYxVPD9Hs0QEr/R/D2dnWXQitymH7ZWlqpiXRuQ8qQUMdwXSs9Pau/ENrWMVPj1K
        kjAqdDbPr0ZKepGaiFrCs2USpvFqtCSKblGZ697fTrqh0cps1Ca/hmJxPn2tCA6p
        uIDrFaw0b+g33fRMNc9dPU5/cF+FwLtA/AkHpOoRvUDSKj4TqA5Xn9iEoJKYXkKM
        +jmUytWNE1oUyFzsEJD244DFB0LDimFo7sczPbnPtGjOeaFSr06zU7TPKfxQkdIv
        y6btyjEtoFRkCg==
X-ME-Sender: <xms:EPAqXo5CTIYbhwq6_dLJYx26JSOh2LshfJJaySc0jsw14jxEImtMoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:EPAqXknw2A-dlr02k1OucIOPtjFtal430IYhCXg84_KD46-ttJVh0A>
    <xmx:EPAqXgKvDSb18C1_s6NP_CO2XboCTcB7qSpv5pRpcsG769qg-qYFyA>
    <xmx:EPAqXkTy3EpazyUu3VK4wcIZLQ7G5MRHDuYN7bKm4Ppg9G7VHFlByA>
    <xmx:EfAqXg83pcxVlujiSGQXps1FUkAbkG3VI9B5DuGyY4zuKUmBllrpRw>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id C14BA30610F6;
        Fri, 24 Jan 2020 08:24:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/14] selftests: forwarding: lib: Allow reading TC rule byte counters
Date:   Fri, 24 Jan 2020 15:23:17 +0200
Message-Id: <20200124132318.712354-14-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The function tc_rule_stats_get() fetches a packet counter of a given TC
rule. Extend it to support byte counters as well by adding an optional
argument with selector.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 096340f064db..2f5da414aaa7 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -593,9 +593,10 @@ tc_rule_stats_get()
 	local dev=$1; shift
 	local pref=$1; shift
 	local dir=$1; shift
+	local selector=${1:-.packets}; shift
 
 	tc -j -s filter show dev $dev ${dir:-ingress} pref $pref \
-	    | jq '.[1].options.actions[].stats.packets'
+	    | jq ".[1].options.actions[].stats$selector"
 }
 
 ethtool_stats_get()
-- 
2.24.1

