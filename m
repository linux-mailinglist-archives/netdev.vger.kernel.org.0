Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E35B5A03B5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbiHXWEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240833AbiHXWD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:03:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93C3D76778;
        Wed, 24 Aug 2022 15:03:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 10/14] netfilter: nft_tunnel: restrict it to netdev family
Date:   Thu, 25 Aug 2022 00:03:26 +0200
Message-Id: <20220824220330.64283-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only allow to use this expression from NFPROTO_NETDEV family.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 5edaaded706d..983ade4be3b3 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -161,6 +161,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
 	.name		= "tunnel",
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_get_ops,
 	.policy		= nft_tunnel_policy,
 	.maxattr	= NFTA_TUNNEL_MAX,
-- 
2.30.2

