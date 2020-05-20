Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DDA1DADFD
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgETIu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:50:57 -0400
Received: from novek.ru ([213.148.174.62]:52512 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETIu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:50:57 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 987D5502966;
        Wed, 20 May 2020 11:50:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 987D5502966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589964653; bh=mRPZeBU0KCrXOT6Paa9QbaCLs5ELHEOoIttm/UBgtZI=;
        h=From:To:Cc:Subject:Date:From;
        b=vtPsXrcVWBOLlTXlFsiaRxKCyHVI6mFgh6hSbL7kauuKdDOCzDHFzPA3KIL2+KhPY
         F6/yuzzt9vqKa/xtZTc9FwecOkBzrCDGxEqvZVo78yu6BqFibDFPbqsVKpAYXNak6r
         Q2qFxUMG8O+91wcLCe9NZGXgnRrC3uZ2KsV6Zvuw=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net] net: ipip: fix wrong address family in init error path
Date:   Wed, 20 May 2020 11:50:48 +0300
Message-Id: <1589964648-12516-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=1.7 required=5.0 tests=UNPARSEABLE_RELAY,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error with MPLS support the code is misusing AF_INET
instead of AF_MPLS.

Fixes: 1b69e7e6c4da ("ipip: support MPLS over IPv4")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv4/ipip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 2f01cf6..678575a 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -698,7 +698,7 @@ static int __init ipip_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_MPLS)
-	xfrm4_tunnel_deregister(&mplsip_handler, AF_INET);
+	xfrm4_tunnel_deregister(&mplsip_handler, AF_MPLS);
 xfrm_tunnel_mplsip_failed:
 
 #endif
-- 
1.8.3.1

