Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EB31B5854
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgDWJj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:39:26 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:33087 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgDWJj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 05:39:26 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id E6A8B3E240F;
        Thu, 23 Apr 2020 11:39:23 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1jRYKJ-0006Fn-SB; Thu, 23 Apr 2020 11:39:23 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec-next] xfrm interface: don't take extra reference to netdev
Date:   Thu, 23 Apr 2020 11:39:20 +0200
Message-Id: <20200423093920.23962-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't see any reason to do this. Maybe needed before
commit 56c5ee1a5823 ("xfrm interface: fix memory leak on creation").

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/xfrm/xfrm_interface.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 3361e3ac5714..eb9928c0a87c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -145,7 +145,6 @@ static int xfrmi_create(struct net_device *dev)
 	if (err < 0)
 		goto out;
 
-	dev_hold(dev);
 	xfrmi_link(xfrmn, xi);
 
 	return 0;
@@ -175,7 +174,6 @@ static void xfrmi_dev_uninit(struct net_device *dev)
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
 	xfrmi_unlink(xfrmn, xi);
-	dev_put(dev);
 }
 
 static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
-- 
2.24.0

