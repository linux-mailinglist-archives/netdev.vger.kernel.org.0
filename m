Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCCF436251
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhJUNFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:05:41 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:51261 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhJUNFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:05:40 -0400
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1634821397;
        bh=4YdKHvN93yhq8+9juz+qrXE/FDAOs4WQpC3s82kIpYY=;
        h=From:To:Cc:Subject:Date:From;
        b=ANysfixJonxu2KHFisv92/hdJqmcHpqRwjYtE1I7s3BPC6PnveWTakAuG1qfPg6X+
         T5rxYNJYSX99ixp8eoRnB5i59zo4W1iT1+LuZMXJSze+uB8dzLHVuJDcRR8Frm+8TR
         3pZBn7AyWdjrgsa3c5UAJNVBnwfrPvzZDiX2KETc=
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipvs: autoload ipvs on genl access
Date:   Thu, 21 Oct 2021 15:02:55 +0200
Message-Id: <20211021130255.4177-1-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel provides the functionality to automatically load modules
providing genl families. Use this to remove the need for users to
manually load the module.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 29ec3ef63edc..0ff94c66641f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -48,6 +48,8 @@
 
 #include <net/ip_vs.h>
 
+MODULE_ALIAS_GENL_FAMILY(IPVS_GENL_NAME);
+
 /* semaphore for IPVS sockopts. And, [gs]etsockopt may sleep. */
 static DEFINE_MUTEX(__ip_vs_mutex);
 

base-commit: d9aaaf223297f6146d9d7f36caca927c92ab855a
-- 
2.33.1

