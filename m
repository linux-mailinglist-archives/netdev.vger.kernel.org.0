Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F644CC37B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbiCCRQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiCCRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0352E5B3DE;
        Thu,  3 Mar 2022 09:15:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJEo/FhG0+j8UsdQWenNrIjooNO4Jwq8CGdtxHF/zeI=;
        b=lFVdN1Hp5xaSgOcs7eb8Oxnhj/5XLuwqCyMudQfNAzb+z1UMJbVsm9VK1QstHTdd/ZTS2q
        1sGeeBoObfQ2ygF9tmMro+vwNUBRkBvQV3WjKlFKB4MG78ssdkW1pBTxOObNPbHTraZMHE
        rJquukny7bKJhxg1F1+1Tx2SR9LFJqjYdojrEUXLrDWJjyEIys6pLBC7ldMdz10ins8R38
        YarfMwKLzsl4nqMK9K+9YnA4v9Jm0inUqOmm32lZ6deQ3ju02snlXA6VL+N+TiiYDxE4d7
        pfKJSPawAh5aFkO1op6OYNWvkKUVsrg8T3E6/gFbsUCnPAAbNepYXxsdpfwJ2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJEo/FhG0+j8UsdQWenNrIjooNO4Jwq8CGdtxHF/zeI=;
        b=BPMI86KfF6GXBN/QhYJlJnL779jZMWgzmIJvAm6xKjR6GrO5p0Mt68XpaapjkMOtLiAd22
        ttDPQO7UVeCBcSDg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next 1/9] docs: networking: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:14:57 +0100
Message-Id: <20220303171505.1604775-2-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-1-bigeasy@linutronix.de>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
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

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any co=
ntext.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/networking/timestamping.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/netw=
orking/timestamping.rst
index f5809206eb93d..be4eb12420570 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -668,7 +668,7 @@ In the generic layer, DSA provides the following infras=
tructure for PTP
   (through another RX timestamping FIFO). Deferral on RX is typically
   necessary when retrieving the timestamp needs a sleepable context. In
   that case, it is the responsibility of the DSA driver to call
-  ``netif_rx_ni()`` on the freshly timestamped skb.
+  ``netif_rx()`` on the freshly timestamped skb.
=20
 3.2.2 Ethernet PHYs
 ^^^^^^^^^^^^^^^^^^^
--=20
2.35.1

