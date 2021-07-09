Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFC43C1D64
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhGICUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhGICUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:20:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C352AC061765;
        Thu,  8 Jul 2021 19:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2lXgoFdlw0nj3Z9RK3rE4yOZJUJiPD5izsxaIDhtFBc=; b=dzsf762Xi3yNrvBt9U1hN4Nd9s
        O1xhAYaj+ggfy7hDzTzOUOP40xChZ9QbTFa5unyEL3E+jbIdo/raDJuWmNmJhWHXRcLsrRjXM2zPi
        r5t/T1euH6N4OmxpM4ktkQoTyUSz5upz61bZ+hMpEpIBJBIkBW4wOEN+p/vVDT0S6WH5otvTZS4L7
        W527yvZWp1rmCX6yo2RJy/QjHPz9E3bNX3o2lyqhdW+mn58HTRngwy1EL8+/OMQjz9TnurthN6Ztf
        bmGf2fY7E2YCtbqqwZMFDza2vHdHslpCgGblA/uyK1qYjVuDfMCOwgHH4nMEd4PzUYZLN4BuWJApA
        oRagfV5w==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1g5R-000Wlc-Nh; Fri, 09 Jul 2021 02:17:53 +0000
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
Subject: [PATCH 5/6] net: hdlc: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Thu,  8 Jul 2021 19:17:46 -0700
Message-Id: <20210709021747.32737-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210709021747.32737-1-rdunlap@infradead.org>
References: <20210709021747.32737-1-rdunlap@infradead.org>
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
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: linux-x25@vger.kernel.org
---
 drivers/net/wan/hdlc_cisco.c   |    8 ++++----
 drivers/net/wan/hdlc_fr.c      |    8 ++++----
 drivers/net/wan/hdlc_ppp.c     |    8 ++++----
 drivers/net/wan/hdlc_raw.c     |    8 ++++----
 drivers/net/wan/hdlc_raw_eth.c |    8 ++++----
 drivers/net/wan/hdlc_x25.c     |    8 ++++----
 6 files changed, 24 insertions(+), 24 deletions(-)

--- linux-next-20210708.orig/drivers/net/wan/hdlc_cisco.c
+++ linux-next-20210708/drivers/net/wan/hdlc_cisco.c
@@ -364,19 +364,19 @@ static int cisco_ioctl(struct net_device
 	return -EINVAL;
 }
 
-static int __init mod_init(void)
+static int __init hdlc_cisco_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit hdlc_cisco_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(hdlc_cisco_init);
+module_exit(hdlc_cisco_exit);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("Cisco HDLC protocol support for generic HDLC");
--- linux-next-20210708.orig/drivers/net/wan/hdlc_fr.c
+++ linux-next-20210708/drivers/net/wan/hdlc_fr.c
@@ -1279,19 +1279,19 @@ static int fr_ioctl(struct net_device *d
 	return -EINVAL;
 }
 
-static int __init mod_init(void)
+static int __init hdlc_fr_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit hdlc_fr_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(hdlc_fr_init);
+module_exit(hdlc_fr_exit);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("Frame-Relay protocol support for generic HDLC");
--- linux-next-20210708.orig/drivers/net/wan/hdlc_ppp.c
+++ linux-next-20210708/drivers/net/wan/hdlc_ppp.c
@@ -705,20 +705,20 @@ static int ppp_ioctl(struct net_device *
 	return -EINVAL;
 }
 
-static int __init mod_init(void)
+static int __init hdlc_ppp_init(void)
 {
 	skb_queue_head_init(&tx_queue);
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit hdlc_ppp_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(hdlc_ppp_init);
+module_exit(hdlc_ppp_exit);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("PPP protocol support for generic HDLC");
--- linux-next-20210708.orig/drivers/net/wan/hdlc_raw.c
+++ linux-next-20210708/drivers/net/wan/hdlc_raw.c
@@ -90,7 +90,7 @@ static int raw_ioctl(struct net_device *
 }
 
 
-static int __init mod_init(void)
+static int __init hdlc_raw_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
@@ -98,14 +98,14 @@ static int __init mod_init(void)
 
 
 
-static void __exit mod_exit(void)
+static void __exit hdlc_raw_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(hdlc_raw_init);
+module_exit(hdlc_raw_exit);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("Raw HDLC protocol support for generic HDLC");
--- linux-next-20210708.orig/drivers/net/wan/hdlc_raw_eth.c
+++ linux-next-20210708/drivers/net/wan/hdlc_raw_eth.c
@@ -110,7 +110,7 @@ static int raw_eth_ioctl(struct net_devi
 }
 
 
-static int __init mod_init(void)
+static int __init hdlc_eth_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
@@ -118,14 +118,14 @@ static int __init mod_init(void)
 
 
 
-static void __exit mod_exit(void)
+static void __exit hdlc_eth_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(hdlc_eth_init);
+module_exit(hdlc_eth_exit);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("Ethernet encapsulation support for generic HDLC");
--- linux-next-20210708.orig/drivers/net/wan/hdlc_x25.c
+++ linux-next-20210708/drivers/net/wan/hdlc_x25.c
@@ -365,19 +365,19 @@ static int x25_ioctl(struct net_device *
 	return -EINVAL;
 }
 
-static int __init mod_init(void)
+static int __init hdlc_x25_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit hdlc_x25_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(hdlc_x25_init);
+module_exit(hdlc_x25_exit);
 
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("X.25 protocol support for generic HDLC");
