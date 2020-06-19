Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2286D2002E0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgFSHnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34740 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730797AbgFSHnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DA5E620582;
        Fri, 19 Jun 2020 09:43:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ExKTLzH_A_53; Fri, 19 Jun 2020 09:43:46 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 94A4E20299;
        Fri, 19 Jun 2020 09:43:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 19 Jun 2020 09:43:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 19 Jun
 2020 09:43:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E8D8B318022C;
 Fri, 19 Jun 2020 09:43:45 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/5] xfrm: merge fixup for "remove output_finish indirection from xfrm_state_afinfo"
Date:   Fri, 19 Jun 2020 09:43:39 +0200
Message-ID: <20200619074342.14095-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619074342.14095-1-steffen.klassert@secunet.com>
References: <20200619074342.14095-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4c23f69f69f..a7ab19353313 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -574,16 +574,12 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 	switch (x->outer_mode.family) {
 	case AF_INET:
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-#ifdef CONFIG_NETFILTER
 		IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
-#endif
 		break;
 	case AF_INET6:
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 
-#ifdef CONFIG_NETFILTER
 		IP6CB(skb)->flags |= IP6SKB_XFRM_TRANSFORMED;
-#endif
 		break;
 	}
 
-- 
2.17.1

