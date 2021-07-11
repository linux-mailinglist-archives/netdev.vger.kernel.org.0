Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74A3C3FC1
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 00:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhGKWev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 18:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhGKWen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 18:34:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE11C0613DD;
        Sun, 11 Jul 2021 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=der3BYRgQwyk0PHod6HemFTpspJQxjKE+51Oljy5seE=; b=tx0aVYvKL99MnMl/pjnNUVCJRL
        4oVMVMsArLs13Y2NgNGqIJFYSmCAHPQNWE2YgziKsD3SEtPuQtWfY5W226D8zX+J8qf1cuqzrv7NJ
        230AXmfYsXXqq9sa2PjpHDzu3UWGJOY6mWzqXFULSOyaAGAebTqqljRJQD6p82YxjWzl9hbZhrrsU
        sqUGtkeJKvgJeLLlhV1i4dsDMwXFR87GORSOneKfqnFNYAuFrUfqB6dI1ezwm0Yv9pSV41CGF9mNx
        ZPj9QxkF4zShtoSICuZQwEQktd3VIDnfn0L0564sPXyM4G2kQXAvSL7+duJ/ny60iTPwBCEkR/6LU
        5N/7KnQg==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2hzP-005U4u-Hi; Sun, 11 Jul 2021 22:31:55 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: [PATCH 6/6 v2] wireguard: main: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Sun, 11 Jul 2021 15:31:48 -0700
Message-Id: <20210711223148.5250-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210711223148.5250-1-rdunlap@infradead.org>
References: <20210711223148.5250-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename module_init & module_exit functions that are named
"mod_init" and "mod_exit" so that they are unique in both the
System.map file and in initcall_debug output instead of showing
up as almost anonymous "mod_init".

This is helpful for debugging and in determining how long certain
module_init calls take to execute.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: wireguard@lists.zx2c4.com
Cc: netdev@vger.kernel.org
---
v2: change Subject: prefixes and function names (thanks, Jason)

 drivers/net/wireguard/main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20210708.orig/drivers/net/wireguard/main.c
+++ linux-next-20210708/drivers/net/wireguard/main.c
@@ -17,7 +17,7 @@
 #include <linux/genetlink.h>
 #include <net/rtnetlink.h>
 
-static int __init mod_init(void)
+static int __init wg_mod_init(void)
 {
 	int ret;
 
@@ -60,7 +60,7 @@ err_allowedips:
 	return ret;
 }
 
-static void __exit mod_exit(void)
+static void __exit wg_mod_exit(void)
 {
 	wg_genetlink_uninit();
 	wg_device_uninit();
@@ -68,8 +68,8 @@ static void __exit mod_exit(void)
 	wg_allowedips_slab_uninit();
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(wg_mod_init);
+module_exit(wg_mod_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("WireGuard secure network tunnel");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
