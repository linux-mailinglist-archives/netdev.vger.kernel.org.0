Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31975426B8D
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbhJHNPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43803 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242545AbhJHNPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 31B715C00E0;
        Fri,  8 Oct 2021 09:13:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 08 Oct 2021 09:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=2CA8Db7PiPMfamUsWAWFfml/k0LDnJ+0kf2aW4loTEo=; b=H8Doy9d8
        9ZjX36HizEtVBAnJA6DUKF6oiMJx9wJK1uywMW9NxWDb0Yx8ULBB1HJoFqVH3+9c
        icGoqUgKCxH288DhRbzJOVf68Gpd1SqvP0xzc2l9VoGLA+KVE6sB0bFBmqQSg5HL
        iqTXF2z7PGf8s3J1hFb0A9Eqsc98Wuy3krWTnvkdm06v6WNUJnYhg0ZVRjDlEeT3
        Zj1IKhk16tNWAjpL8FAc7he/i8AjDvwIoXpN7Ptp6aUgrgit2VjYDLMZIbJZdVZW
        sN1rFr4DPSMjshHHuUcJ5AvCuLwDUNNw4RxKXbS+XdAfTNh7PIJDFQ9ZvzfJqbbq
        V4rF7QKL4ic2pw==
X-ME-Sender: <xms:80NgYXEDAtb0RdSS_2n81bjT711Od2swpCkiN3LHNTRPgtfsLoCJeg>
    <xme:80NgYUUZFWCzczQe0wSB5c-CvYmuDBrZVfGYt4zn_duXUc7OL3UZeBdTG6LcYV5ht
    FDYVzwNPvxGOeE>
X-ME-Received: <xmr:80NgYZIYrPYA2tbI6ypjx4lsx47E_e9Oaq1wMcbKhJDAuSiS_gJSWJXCtXsg2YqY9CKfuc61JPpbbulZcV1j_uTyDwH-zz5V5DeOJSGqjpXlmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:80NgYVEO1SwEh7bBVmX7W_RHJCoUycHbHgU4ETA_NVNz3EmeoLybUw>
    <xmx:80NgYdWigy7YFxTTjmorXFkD-yHm-Eb7slalgZXMqWXMeEyTdIG_kA>
    <xmx:80NgYQNPmmV8y96HKVDTx48yGNlJQGf4LkJaMyDVSm6JQY95QYYgYQ>
    <xmx:80NgYTzD2TL122C3S8ZkzP8-PjCkOThbLGn4opfOBt8g4Y_WRYds4A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] selftests: mlxsw: devlink_trap_tunnel_ipip: Send a full-length key
Date:   Fri,  8 Oct 2021 16:12:41 +0300
Message-Id: <20211008131241.85038-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As part of adding same test for GRE tunnel with IPv6 underlay, missing
bytes for key were found.

mausezahn does not fill zeros between two colons, so send them
explicitly. For example, use "00:00:00:E9:" instead of ":E9:"

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
index c072c1633f1d..e9a82cae8c9a 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
@@ -223,7 +223,8 @@ decap_error_test()
 	no_matching_tunnel_test "Decap error: Source IP check failed" \
 		192.0.2.68 "0"
 	no_matching_tunnel_test \
-		"Decap error: Key exists but was not expected" $sip "2" ":E9:"
+		"Decap error: Key exists but was not expected" $sip "2" \
+		"00:00:00:E9:"
 
 	# Destroy the tunnel and create new one with key
 	__addr_add_del g1 del 192.0.2.65/32
@@ -235,7 +236,8 @@ decap_error_test()
 	no_matching_tunnel_test \
 		"Decap error: Key does not exist but was expected" $sip "0"
 	no_matching_tunnel_test \
-		"Decap error: Packet has a wrong key field" $sip "2" "E8:"
+		"Decap error: Packet has a wrong key field" $sip "2" \
+		"00:00:00:E8:"
 }
 
 trap cleanup EXIT
-- 
2.31.1

