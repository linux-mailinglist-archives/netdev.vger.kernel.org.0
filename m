Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCE2B3BE5
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 04:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgKPDmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 22:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgKPDmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 22:42:15 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5850EC0613CF;
        Sun, 15 Nov 2020 19:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=zql9Wmwi3sE1HYgw8ZdAK67RzlkxzMR12yOWc2tObwI=; b=dBB+XQDOhLl0c6Qr6FP86RlKX9
        +3NMHlnmbassjX2cz/53VIkRW/NsvD9Jg68lZCIZ+Iktas/avxSnvCiZ/rxa6f3zI/qwLcOCf2oW3
        +aDfYw8dStRwK/V88munLm88worWTNOTGOl1yOBLupBdvgqA9Tjkj7tojgY9qzX+Ttyjw0sC7YQ/o
        rAGGqA13+WMERtXA3R3NOGz/Q+FmNKg5IXnJH9n4gjBwT0vvraWoNikmI1nLrTW9tTnMnwwAl3KwG
        FdmbcIsHsKcNV7C4fyYRqdLgKz+TeZwP1bV5jpgugVuNSjvtzEdAEDexlUHihgVuO83+Kcp+M4hFh
        TKx5YNqQ==;
Received: from [2601:1c0:6280:3f0::f32] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keVP7-0001f8-65; Mon, 16 Nov 2020 03:42:09 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        "Jose M . Guisado Gomez" <guigom@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netfilter: nf_reject: bridge: fix build errors due to code movement
Date:   Sun, 15 Nov 2020 19:42:03 -0800
Message-Id: <20201116034203.7264-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build errors in net/bridge/netfilter/nft_reject_bridge.ko
by selecting NF_REJECT_IPV4, which provides the missing symbols.

ERROR: modpost: "nf_reject_skb_v4_tcp_reset" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
ERROR: modpost: "nf_reject_skb_v4_unreach" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!

Fixes: fa538f7cf05a ("netfilter: nf_reject: add reject skbuff creation helpers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Jose M. Guisado Gomez <guigom@riseup.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/bridge/netfilter/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20201113.orig/net/bridge/netfilter/Kconfig
+++ linux-next-20201113/net/bridge/netfilter/Kconfig
@@ -18,6 +18,7 @@ config NFT_BRIDGE_META
 config NFT_BRIDGE_REJECT
 	tristate "Netfilter nf_tables bridge reject support"
 	depends on NFT_REJECT
+	depends on NF_REJECT_IPV4
 	help
 	  Add support to reject packets.
 
