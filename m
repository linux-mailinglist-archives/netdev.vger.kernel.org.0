Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB666028D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfGEIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37482 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbfGEIqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7AC77200AC;
        Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3pmRvAjmLUh0; Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0613520254;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 609EB31809BA;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 8/9] xfrm: remove empty xfrmi_init_net
Date:   Fri, 5 Jul 2019 10:46:09 +0200
Message-ID: <20190705084610.3646-9-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

Pointer members of an object with static storage duration, if not
explicitly initialized, will be initialized to a NULL pointer. The
net namespace API checks if this pointer is not NULL before using it,
it are safe to remove the function.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index ad3a2555c517..f8eb9e342173 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -793,11 +793,6 @@ static void __net_exit xfrmi_destroy_interfaces(struct xfrmi_net *xfrmn)
 	unregister_netdevice_many(&list);
 }
 
-static int __net_init xfrmi_init_net(struct net *net)
-{
-	return 0;
-}
-
 static void __net_exit xfrmi_exit_net(struct net *net)
 {
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
@@ -808,7 +803,6 @@ static void __net_exit xfrmi_exit_net(struct net *net)
 }
 
 static struct pernet_operations xfrmi_net_ops = {
-	.init = xfrmi_init_net,
 	.exit = xfrmi_exit_net,
 	.id   = &xfrmi_net_id,
 	.size = sizeof(struct xfrmi_net),
-- 
2.17.1

