Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35851DCC59
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgEULrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:47:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48775 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729115AbgEULrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 07:47:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 60F3B5C00E9;
        Thu, 21 May 2020 07:47:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 07:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0yLMdM1/xjg3dJTgTmCB1WZqKRH6FQcxzoqfYBVNmPE=; b=FzvqCtF+
        czvlDpCiwt1yR32V8xQUTN5rkYhmY9CKiXNJbIVklTfKU78dV83qVIXVx3jb7QUI
        aJ/DT4rmxCnE2JqmCOntWLpj1k33+OGOzTHOH+frvLJG3f5jW8LrKKemJWWLP3ho
        hBvIFb8pb4zVe50vu0lTAbUaKwXxoQWcyJFPKtbnHBNgTWtdgBaKW+DiWrEZyX54
        MmbdmqXzxDPFGmS3oLzsPD9RgK9v0AGD+oN7Aft3uatrHvvnEftwkcUsjBkKaRuL
        aH/BVdrK3709ZcaVZFCm8P6rcH/qiggPA3hSL9EQtSKxz6zcB/1au8io+3kX2x84
        OKiMO7WDqYuPSw==
X-ME-Sender: <xms:NWrGXvS93BFmGu5nIR08UKwFbEr6wdmcEiuUQtjmyx4iK5XDbS4_Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NWrGXgw1jOqF2fBPCa11w-_PSEPuzr9tV8VF4AuO9xgL-GLbAdNQlQ>
    <xmx:NWrGXk22yxt2sWoQ4BUenZouoVUvVsky7K7GmGuGNaxWtTohMEjweg>
    <xmx:NWrGXvA4ZfW7tMeSbrstJtcXngSuofqin1hzOIILiPGBKJZVHTFsxw>
    <xmx:NWrGXkZycOaaceaBv1bm3yB8-2lVdvL7OaSIaPsxMFVVRkSj6CUWCw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18AE7306647D;
        Thu, 21 May 2020 07:46:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] selftests: netdevsim: Always initialize 'RET' variable
Date:   Thu, 21 May 2020 14:46:17 +0300
Message-Id: <20200521114617.1074379-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521114617.1074379-1-idosch@idosch.org>
References: <20200521114617.1074379-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The variable is used by log_test() to check if the test case completely
successfully or not. In case it is not initialized at the start of a
test case, it is possible for the test case to fail despite not
encountering any errors.

Example:

```
...
TEST: Trap group statistics                                         [ OK ]
TEST: Trap policer                                                  [FAIL]
	Policer drop counter was not incremented
TEST: Trap policer binding                                          [FAIL]
	Policer drop counter was not incremented
```

Failure of trap_policer_test() caused trap_policer_bind_test() to fail
as well.

Fix by adding missing initialization of the variable.

Fixes: 5fbff58e27a1 ("selftests: netdevsim: Add test cases for devlink-trap policers")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index dbd1e014ba17..da49ad2761b5 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -264,6 +264,8 @@ trap_policer_test()
 	local packets_t0
 	local packets_t1
 
+	RET=0
+
 	if [ $(devlink_trap_policers_num_get) -eq 0 ]; then
 		check_err 1 "Failed to dump policers"
 	fi
@@ -328,6 +330,8 @@ trap_group_check_policer()
 
 trap_policer_bind_test()
 {
+	RET=0
+
 	devlink trap group set $DEVLINK_DEV group l2_drops policer 1
 	check_err $? "Failed to bind a valid policer"
 	if [ $(devlink_trap_group_policer_get "l2_drops") -ne 1 ]; then
-- 
2.26.2

