Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E0A589FDB
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbiHDR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiHDR1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:27:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DC9165A7
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:27:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oJecc-0007E5-DP; Thu, 04 Aug 2022 19:26:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 3/3] netfilter: flowtable: fix incorrect Kconfig dependencies
Date:   Thu,  4 Aug 2022 19:26:29 +0200
Message-Id: <20220804172629.29748-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220804172629.29748-1-fw@strlen.de>
References: <20220804172629.29748-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Remove default to 'y', this infrastructure is not fundamental for the
flowtable operational.

Add a missing dependency on CONFIG_NF_FLOW_TABLE.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df6abbfe0079..22f15ebf6045 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -736,9 +736,8 @@ config NF_FLOW_TABLE
 
 config NF_FLOW_TABLE_PROCFS
 	bool "Supply flow table statistics in procfs"
-	default y
+	depends on NF_FLOW_TABLE
 	depends on PROC_FS
-	depends on SYSCTL
 	help
 	  This option enables for the flow table offload statistics
 	  to be shown in procfs under net/netfilter/nf_flowtable.
-- 
2.35.1

