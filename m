Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D86E4CEE10
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiCFV7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiCFV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2981EADA
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:06 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uU3/xqrT6VpNeRDdI0G1J3j5XIM973IR+jmWqft55Jo=;
        b=E6yE8yCFRJ0p5f/1FNBSxASrusV53DDpD9XhfL3+TIS3CwRu/ftiw400u5RtgkVvnJIdrf
        R7KkxKIV4MsdAQHa5t6x5rzJXUVnt/TniWWLkC0sjSJ8FtLZmOxp9ryjmPlNeK5zP0WY1v
        RWxYOjXhEYHSTH3YubXYM6zMU1ilT2BUM0jUB9bffCbPN28zZhuIHjdVT5v9ULvDCrtOhV
        GZwQ2ODMsCXDUCsV4uoh747vqUWWZmcXsdCBZgfb2eHtrpUpOVXMULx5VFW6ONu/UlwR5m
        ikhD4N2fUmgFNWbzOkgXbjWWdw0rLxLpZf223wsugM4H6MKu/wj1TkSn7YsZ2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uU3/xqrT6VpNeRDdI0G1J3j5XIM973IR+jmWqft55Jo=;
        b=hE10roVYp7dWnGFVAFXFVmmR4XzuZ8z9a3TVH7uH4p/5JKJ+dciuwTRarq9ywTAhkBoYfw
        bz24zWy4ZB8+g9AA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 09/10] net: Remove netif_rx_any_context() and netif_rx_ni().
Date:   Sun,  6 Mar 2022 22:57:52 +0100
Message-Id: <20220306215753.3156276-10-bigeasy@linutronix.de>
In-Reply-To: <20220306215753.3156276-1-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove netif_rx_any_context and netif_rx_ni() because there are no more
users in tree.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netdevice.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 19a27ac361efb..29a850a8d4604 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3718,16 +3718,6 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct=
 sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
 int __netif_rx(struct sk_buff *skb);
=20
-static inline int netif_rx_ni(struct sk_buff *skb)
-{
-	return netif_rx(skb);
-}
-
-static inline int netif_rx_any_context(struct sk_buff *skb)
-{
-	return netif_rx(skb);
-}
-
 int netif_receive_skb(struct sk_buff *skb);
 int netif_receive_skb_core(struct sk_buff *skb);
 void netif_receive_skb_list_internal(struct list_head *head);
--=20
2.35.1

