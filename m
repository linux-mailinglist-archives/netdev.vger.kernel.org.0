Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9CA4407D9
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 09:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhJ3H3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 03:29:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37658 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231669AbhJ3H3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 03:29:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AC05F2049A;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dPad6JC0xS1w; Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2AEB12009B;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 2193980004A;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Sat, 30 Oct 2021 09:26:35 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Sat, 30 Oct
 2021 09:26:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F1E013182FB0; Sat, 30 Oct 2021 09:26:35 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] xfrm: Remove redundant fields and related parentheses
Date:   Sat, 30 Oct 2021 09:26:33 +0200
Message-ID: <20211030072633.4158069-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211030072633.4158069-1-steffen.klassert@secunet.com>
References: <20211030072633.4158069-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <cgel.zte@gmail.com>

The variable err is not necessary in such places. It should be revmoved
for the simplicity of the code. This will cause the double parentheses
to be redundant, and the inner parentheses should be deleted.

The clang_analyzer complains as follows:

net/xfrm/xfrm_input.c:533: warning:
net/xfrm/xfrm_input.c:563: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Changes in v2:

Modify the title, because v2 removes the brackets.
Remove extra parentheses.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3df0861d4390..70a8c36f0ba6 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -530,7 +530,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 				goto drop;
 			}
 
-			if ((err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+			if (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 				goto drop;
 			}
@@ -560,7 +560,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	}
 
 	seq = 0;
-	if (!spi && (err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+	if (!spi && xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
 		secpath_reset(skb);
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 		goto drop;
-- 
2.25.1

