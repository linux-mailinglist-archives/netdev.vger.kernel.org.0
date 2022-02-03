Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F6D4A8F07
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbiBCUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355431AbiBCUj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:39:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26C8C06119B;
        Thu,  3 Feb 2022 12:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59802B835BB;
        Thu,  3 Feb 2022 20:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89BBC340E8;
        Thu,  3 Feb 2022 20:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920601;
        bh=bbIy+Y3eWMywAskF8Xde/iIAORrECZ6rLzNtCmennro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDIPvW1Y8x/OT21ALtvIwaDL4OKEpcrLU9is9UUP0UGSxcg0WVo5PEW+jwpdklVqR
         AyZYWqW7UhSfMLQ0+5pajJFj69aKVetcIKXzPhm7PmvJoQGhpzvf9tdAi9tvlsXm9S
         TXXCqQsskJcrPY5Gzy6HUVdJqcqs08O8IpKRVg+G+i4+xHlA6lMSgPcwNqxI1ts1t1
         uboNx6eS2vD1p1JVfCC1dCme+bcVIJaVJdEHdMIkxrbua/GRrNI0qtQTcy8sw3D/QU
         Ho8UBrjBhJ9UZKsJkXLHWxW9kE0Rpd8NhE9Zy/VpxQv7HQsv2+WZ20Qzgy/HgBdyB7
         KbQlaToUNLz7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/9] netfilter: nf_conntrack_netbios_ns: fix helper module alias
Date:   Thu,  3 Feb 2022 15:36:28 -0500
Message-Id: <20220203203633.4685-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203633.4685-1-sashal@kernel.org>
References: <20220203203633.4685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 0e906607b9c5ee22312c9af4d8adb45c617ea38a ]

The helper gets registered as 'netbios-ns', not netbios_ns.
Intentionally not adding a fixes-tag because i don't want this to go to
stable. This wasn't noticed for a very long time so no so no need to risk
regressions.

Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netbios_ns.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 496ce173f0c19..79d5bd1c52073 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -24,13 +24,14 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
+#define HELPER_NAME	"netbios-ns"
 #define NMBD_PORT	137
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_netbios_ns");
-MODULE_ALIAS_NFCT_HELPER("netbios_ns");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 static unsigned int timeout __read_mostly = 3;
 module_param(timeout, uint, S_IRUSR);
@@ -47,7 +48,7 @@ static int netbios_ns_help(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_conntrack_helper helper __read_mostly = {
-	.name			= "netbios-ns",
+	.name			= HELPER_NAME,
 	.tuple.src.l3num	= NFPROTO_IPV4,
 	.tuple.src.u.udp.port	= cpu_to_be16(NMBD_PORT),
 	.tuple.dst.protonum	= IPPROTO_UDP,
-- 
2.34.1

