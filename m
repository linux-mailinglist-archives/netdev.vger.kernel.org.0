Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459EB34DA80
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhC2WWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhC2WV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F043961985;
        Mon, 29 Mar 2021 22:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056517;
        bh=VBA9o2EIdCUut3Sn5HLHtWT4SJ8aHzBGbxbctElJdEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh98EQNNu0suFlZflgWQ+VP3HhRUgngtCavWEy64wAUguanyrz9lD6UTCmXYPlDFy
         4MsmVlvMuAWgmLjVHzCWF3ykW6+4/ko3UUQBKaZP+wMiVGDlPdo59R6znWrgUYMenX
         cXqujlms0cf6RImUIkPGMckhnkMr5UHBtKmyJGvXoKEYsYXtTcZlIYWdIiw32O1IPz
         4JEOlIVYFzYiuyUNeODuv1v98DbvJoVDFHoQx7h1xeqTtQf/JYjIOBwxoqMElVK3Wo
         yFckcxLzRIbBZnUunMFIiiPOxjAXdpXyKIRrmDFoB7z2WyjbL6lXgiAVT0E9CUIk0x
         nqZJ8LFvdvKbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ludovic Senecaux <linuxludo@free.fr>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 19/38] netfilter: conntrack: Fix gre tunneling over ipv6
Date:   Mon, 29 Mar 2021 18:21:14 -0400
Message-Id: <20210329222133.2382393-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ludovic Senecaux <linuxludo@free.fr>

[ Upstream commit 8b2030b4305951f44afef80225f1475618e25a73 ]

This fix permits gre connections to be tracked within ip6tables rules

Signed-off-by: Ludovic Senecaux <linuxludo@free.fr>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_gre.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 5b05487a60d2..db11e403d818 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -218,9 +218,6 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state)
 {
-	if (state->pf != NFPROTO_IPV4)
-		return -NF_ACCEPT;
-
 	if (!nf_ct_is_confirmed(ct)) {
 		unsigned int *timeouts = nf_ct_timeout_lookup(ct);
 
-- 
2.30.1

