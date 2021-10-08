Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC063426B8C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242609AbhJHNPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49499 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242537AbhJHNPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D7C05C00B2;
        Fri,  8 Oct 2021 09:13:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 09:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=SypNvZbr0uRuWOXf6lgAgAHTa7zRChhPwwfCGtumEog=; b=O19ao69M
        QxjiV29WaXX1+wtG4lM4/T490A6wQjWOjK6qSbxEamDUer6aKiHsM6nfHWwX9dT2
        fFSy9E849kQUzRadZcNpP1Y52b1alf1iu2sWDreC9aWM9hDzZKCpPEFOb6qOjb3L
        GtOmnJHDj8l+Dq2XwXyomG7VS1bJUivqRIB8DG0K2xOjC3ti6pKk1RDt4HfSS6yN
        a4eOjtQg8adQnDBFbilLIvv4HdaH1GvUWrD0+87DjJkWRiKeR+jxqJqpth/odKzc
        IKtwupXZ5YwowhQpmPBA/F3QqjvGip5ObiT1riQiqoKJtOsKhPO3e+z210biDtio
        pFdxmN28dBLqnA==
X-ME-Sender: <xms:8UNgYXxDEjNxylwbWsF54zvOd84T92aQBFjdcRMzbsX--SFwuXIdTA>
    <xme:8UNgYfQ_ri0zE1YyUx7nNY1B3Gfbl6eNhrRRR6cMpeiZsdiQ_hdSVTZJSdmCsbN50
    8RqJTB8Ct99qyo>
X-ME-Received: <xmr:8UNgYRXL9oSYl2bVTT-i_Snjn_NqOQotjhgK4VlMCd3O2XILsZfGhA5yNM8fJzgkyxfFAnCkB6O6OeGY7-Wxa4kbar_6-VIV5s73oZAxSDGgQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8UNgYRjCyAlkziGLtwA2CuqGZVCUFm-3eLh84lmEblt_rQT92XbD7A>
    <xmx:8UNgYZD4P4MX0-Xsg9WnZDxVZc9Nm7Oz2mGXm0VVChMss8sBIWrB8g>
    <xmx:8UNgYaLRNOGzrJW4-vzlvIZ-e7384LhSGqMnqCs4jGAuC-ulQtrATg>
    <xmx:8UNgYU9e2NRIMCkXhkPuPHgYePiAS91mUhx8NGPblOb0cv_PSvb7RQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] selftests: mlxsw: devlink_trap_tunnel_ipip: Remove code duplication
Date:   Fri,  8 Oct 2021 16:12:40 +0300
Message-Id: <20211008131241.85038-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As part of adding same test for GRE tunnel with IPv6 underlay, an
optional improvement was found - call ipip_payload_get from
ecn_payload_get, so do not duplicate the code which creates the payload.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/mlxsw/devlink_trap_tunnel_ipip.sh     | 38 ++++++-------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
index e2ab26b790a0..c072c1633f1d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
@@ -116,12 +116,16 @@ cleanup()
 	forwarding_restore
 }
 
-ecn_payload_get()
+ipip_payload_get()
 {
+	local flags=$1; shift
+	local key=$1; shift
+
 	p=$(:
-		)"0"$(		              : GRE flags
+		)"$flags"$(		      : GRE flags
 	        )"0:00:"$(                    : Reserved + version
 		)"08:00:"$(		      : ETH protocol type
+		)"$key"$( 		      : Key
 		)"4"$(	                      : IP version
 		)"5:"$(                       : IHL
 		)"00:"$(                      : IP TOS
@@ -137,6 +141,11 @@ ecn_payload_get()
 	echo $p
 }
 
+ecn_payload_get()
+{
+	echo $(ipip_payload_get "0")
+}
+
 ecn_decap_test()
 {
 	local trap_name="decap_error"
@@ -171,31 +180,6 @@ ecn_decap_test()
 	tc filter del dev $swp1 egress protocol ip pref 1 handle 101 flower
 }
 
-ipip_payload_get()
-{
-	local flags=$1; shift
-	local key=$1; shift
-
-	p=$(:
-		)"$flags"$(		      : GRE flags
-	        )"0:00:"$(                    : Reserved + version
-		)"08:00:"$(		      : ETH protocol type
-		)"$key"$( 		      : Key
-		)"4"$(	                      : IP version
-		)"5:"$(                       : IHL
-		)"00:"$(                      : IP TOS
-		)"00:14:"$(                   : IP total length
-		)"00:00:"$(                   : IP identification
-		)"20:00:"$(                   : IP flags + frag off
-		)"30:"$(                      : IP TTL
-		)"01:"$(                      : IP proto
-		)"E7:E6:"$(    	              : IP header csum
-		)"C0:00:01:01:"$(             : IP saddr : 192.0.1.1
-		)"C0:00:02:01:"$(             : IP daddr : 192.0.2.1
-		)
-	echo $p
-}
-
 no_matching_tunnel_test()
 {
 	local trap_name="decap_error"
-- 
2.31.1

