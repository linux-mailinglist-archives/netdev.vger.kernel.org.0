Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE97FB0B
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406383AbfHBNgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393288AbfHBNUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C771F216C8;
        Fri,  2 Aug 2019 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752009;
        bh=phiVujId+WFxGQoYspshRxrrMTJTXAXY6Se9fQv9PWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dpu63Biasha1DELDgtmR78oQ2nIVAQbuzgPbAljy+rhj4nMyBm5cHW3Dq2PCwr0+E
         TjBxiv7erOGN3sXydD2qg7GCfrCtGEtqB0Ry6rIgziO9+8sfS47G/C7EYcreLNpl8Q
         Igow+9k55EckjpNlSK8cRLJGydLz+aq4BrRRIGBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 15/76] netfilter: nf_tables: Support auto-loading for inet nat
Date:   Fri,  2 Aug 2019 09:18:49 -0400
Message-Id: <20190802131951.11600-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit b4f1483cbfa5fafca4874e90063f75603edbc210 ]

Trying to create an inet family nat chain would not cause
nft_chain_nat.ko module to auto-load due to missing module alias. Add a
proper one with hard-coded family value 1 for the pseudo-family
NFPROTO_INET.

Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_chain_nat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 2f89bde3c61cb..ff9ac8ae0031f 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -142,3 +142,6 @@ MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
 #ifdef CONFIG_NF_TABLES_IPV6
 MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
 #endif
+#ifdef CONFIG_NF_TABLES_INET
+MODULE_ALIAS_NFT_CHAIN(1, "nat");	/* NFPROTO_INET */
+#endif
-- 
2.20.1

