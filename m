Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1290F1DEF9E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgEVTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730840AbgEVTCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:02:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804F1C061A0E;
        Fri, 22 May 2020 12:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3WYApwMQHv/jK2wjKkDG3PzXHTttraCjB18s9qs0m9Q=; b=oIYuKmUbm7Iz4mLUIgxRg3v4+Y
        9+sgh7Vf4L1vzyqBwRTlR1wbayzhVg6R9cnCs/3GzWiZJQd/P1+JDdE9OVKyU0B+pKi4tPTXJoIrH
        zb/MdevVMWFu9zsAKEr0VWCkVdxJQDRbhJcfWYdVRdVXOmo8L6176IF0hDGq4Y3KEWH3CDYUhLGSV
        UGGHjWqVcmnxY6aLEzqGR03IlwjP8H58HZoZP9MzS9pcfHlXFRMyUxFS+wcTohEemt78oCR8V+YFp
        rdM9EmTxzpefGAlduTvKUqvZILzsKaNMKCMOJfCa7fZ/JxW15/9q+pDafuLHgHpILYHn7omdFChq/
        fQzqkwLA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcCvy-0005AK-8C; Fri, 22 May 2020 19:02:18 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Yotam Gigi <yotam.gi@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net-next] net: psample: depends on INET
Message-ID: <3c51bea5-b7f5-f64d-eaf2-b4dcba82ce16@infradead.org>
Date:   Fri, 22 May 2020 12:02:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix psample build error when CONFIG_INET is not set/enabled.
PSAMPLE should depend on INET instead of NET since
ip_tunnel_info_opts() is only present for CONFIG_INET.

../net/psample/psample.c: In function ‘__psample_ip_tun_to_nlattr’:
../net/psample/psample.c:216:25: error: implicit declaration of function ‘ip_tunnel_info_opts’; did you mean ‘ip_tunnel_info_opts_set’? [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Yotam Gigi <yotam.gi@gmail.com>
---
This might be too stringent...

 net/psample/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200522.orig/net/psample/Kconfig
+++ linux-next-20200522/net/psample/Kconfig
@@ -4,7 +4,7 @@
 #
 
 menuconfig PSAMPLE
-	depends on NET
+	depends on INET
 	tristate "Packet-sampling netlink channel"
 	default n
 	help

