Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D3014883E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405260AbgAXOVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405236AbgAXOVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F792077C;
        Fri, 24 Jan 2020 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875671;
        bh=juo3GS7boxFKexj+JW88vhjeX/iXSAXwaH0be0zL5jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQDwpKlxLexfFurn8IMko3x/zEwGOQtlxV1j7+WEjTI29wIcVwtKM+XfBBsl7FdC5
         zVwvKg5uIEFOAWtHClhyhOpmRbL64TzIuG5RoaTx3xtt5inUuCJmBV7G3WOrcrCeFr
         lwcxHEYzPaGmXGUimoEk6p4FuHg7J8R0uAVqbGxc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 50/56] netfilter: nft_tunnel: ERSPAN_VERSION must not be null
Date:   Fri, 24 Jan 2020 09:20:06 -0500
Message-Id: <20200124142012.29752-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9ec22d7c6c69146180577f3ad5fdf504beeaee62 ]

Fixes: af308b94a2a4a5 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 09441bbb0166f..e5444f3ff43fc 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -235,6 +235,9 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	if (err < 0)
 		return err;
 
+	if (!tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION])
+		 return -EINVAL;
+
 	version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
 	switch (version) {
 	case ERSPAN_VERSION:
-- 
2.20.1

