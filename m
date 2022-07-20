Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1459057C09C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiGTXIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiGTXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E76C1B795;
        Wed, 20 Jul 2022 16:08:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 15/18] netfilter: nf_nat: in nf_nat_initialized(), use const struct nf_conn *
Date:   Thu, 21 Jul 2022 01:07:51 +0200
Message-Id: <20220720230754.209053-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Yonan <james@openvpn.net>

nf_nat_initialized() doesn't modify passed struct nf_conn,
so declare as const.

This is helpful for code readability and makes it possible
to call nf_nat_initialized() with a const struct nf_conn *.

Signed-off-by: James Yonan <james@openvpn.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 987111ae5240..e9eb01e99d2f 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -104,7 +104,7 @@ unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
 
-static inline int nf_nat_initialized(struct nf_conn *ct,
+static inline int nf_nat_initialized(const struct nf_conn *ct,
 				     enum nf_nat_manip_type manip)
 {
 	if (manip == NF_NAT_MANIP_SRC)
-- 
2.30.2

