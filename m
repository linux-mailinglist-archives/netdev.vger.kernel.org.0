Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBB427B98A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbgI2Bb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgI2BbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E1E2080A;
        Tue, 29 Sep 2020 01:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343059;
        bh=4H/fR5q1JoOOjC4z3zPdkX31ixnSBx8yrYjHOz3qP/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJ+7UUfstL5VPqQflLnTSbj/NGZWs8De/E+qWMP9ZuhsWHqr9wrYb9q8ArQNWasii
         860luA0Z8njc6JqyC4oxYM9gc1tQcSbzBwVS+Cd0F623QddysFgeG5psc3vCzO3YU0
         H90rII5NwxUovQNiDs11Ao0i8Jgqb46Kudeb8VZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 25/29] net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries
Date:   Mon, 28 Sep 2020 21:30:22 -0400
Message-Id: <20200929013027.2406344-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit 8b9e03cd08250c60409099c791e858157838d9eb ]

Some of the IS2 IP4_TCP_UDP keys are not correct, like L4_DPORT,
L4_SPORT and other L4 keys. This prevents offloaded tc-flower rules from
matching on src_port and dst_port for TCP and UDP packets.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d7..7c167a394b762 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -607,17 +607,17 @@ struct vcap_field vsc9959_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_DIP_EQ_SIP]		= {118,   1},
 	/* IP4_TCP_UDP (TYPE=100) */
 	[VCAP_IS2_HK_TCP]			= {119,   1},
-	[VCAP_IS2_HK_L4_SPORT]			= {120,  16},
-	[VCAP_IS2_HK_L4_DPORT]			= {136,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {120,  16},
+	[VCAP_IS2_HK_L4_SPORT]			= {136,  16},
 	[VCAP_IS2_HK_L4_RNG]			= {152,   8},
 	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {160,   1},
 	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {161,   1},
-	[VCAP_IS2_HK_L4_URG]			= {162,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {163,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {164,   1},
-	[VCAP_IS2_HK_L4_RST]			= {165,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {166,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {162,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {163,   1},
+	[VCAP_IS2_HK_L4_RST]			= {164,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {165,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {166,   1},
+	[VCAP_IS2_HK_L4_URG]			= {167,   1},
 	[VCAP_IS2_HK_L4_1588_DOM]		= {168,   8},
 	[VCAP_IS2_HK_L4_1588_VER]		= {176,   4},
 	/* IP4_OTHER (TYPE=101) */
-- 
2.25.1

