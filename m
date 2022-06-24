Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504D9559EFA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 19:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiFXQzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiFXQzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:55:42 -0400
X-Greylist: delayed 515 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Jun 2022 09:55:41 PDT
Received: from mail.yonan.net (mail.yonan.net [54.244.116.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985DFDF25
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 09:55:41 -0700 (PDT)
Received: from unless.localdomain (unknown [76.130.91.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.yonan.net (Postfix) with ESMTPSA id E4DF93ECF5;
        Fri, 24 Jun 2022 16:47:05 +0000 (UTC)
From:   James Yonan <james@openvpn.net>
To:     netdev@vger.kernel.org
Cc:     James Yonan <james@openvpn.net>
Subject: [PATCH net-next] netfilter: nf_nat_initialized() doesn't modify struct nf_conn, so pointer should be declared const
Date:   Fri, 24 Jun 2022 10:45:52 -0600
Message-Id: <20220624164552.3813986-1-james@openvpn.net>
X-Mailer: git-send-email 2.25.1
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

This is helpful for code readability and makes it possible
to call nf_nat_initialized() with a const struct nf_conn *.

Signed-off-by: James Yonan <james@openvpn.net>
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
2.25.1

