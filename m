Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D866C2BD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfGQVnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:43:47 -0400
Received: from sessmg23.ericsson.net ([193.180.251.45]:64996 "EHLO
        sessmg23.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfGQVnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1563399824; x=1565991824;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BwYt+dlodI1U0/rzDOvY/lALAouaKw69oKK3SSiOf48=;
        b=Lztxaj0Z40475oxIiJCwG/+ejPW7LLGKLr60JcLYSW9NuNkKRZQm4ixVeYKMUo7i
        EfyCEWAylJi+sawFpSxP22uNCFL2DwuE59r09IQrvGRJx17bSmrTQ9yqjc8Y+8+M
        GmYUQoU4TpHqBOujp6RXZvmYiB7uSi2ydhaZJQQnq88=;
X-AuditID: c1b4fb2d-195ff70000001a6d-2e-5d2f96901db6
Received: from ESESBMB501.ericsson.se (Unknown_Domain [153.88.183.114])
        by sessmg23.ericsson.net (Symantec Mail Security) with SMTP id 4B.CD.06765.0969F2D5; Wed, 17 Jul 2019 23:43:44 +0200 (CEST)
Received: from ESESSMR502.ericsson.se (153.88.183.110) by
 ESESBMB501.ericsson.se (153.88.183.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 17 Jul 2019 23:43:44 +0200
Received: from ESESBMB502.ericsson.se (153.88.183.169) by
 ESESSMR502.ericsson.se (153.88.183.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 17 Jul 2019 23:43:44 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.185) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 17 Jul 2019 23:43:44 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <gordan.mihaljevic@dektech.com.au>, <tung.q.nguyen@dektech.com.au>,
        <hoang.h.le@dektech.com.au>, <jon.maloy@ericsson.com>,
        <canh.d.luu@dektech.com.au>, <ying.xue@windriver.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net  1/1] tipc: initialize 'validated' field of received packets
Date:   Wed, 17 Jul 2019 23:43:44 +0200
Message-ID: <1563399824-4462-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsUyM2J7ke6EafqxBhNv6VjcaOhhtphzvoXF
        YsXuSawWb1/NYrc4tkDMYsv5LIsr7WfZLR5fv87swOGxZeVNJo93V9g8di/4zOTxeZOcx/ot
        W5kCWKO4bFJSczLLUov07RK4MpbtecVW0MlRcWPPT8YGxitsXYwcHBICJhJtpyS6GLk4hASO
        Mkp8nPUUKM4J5HxjlHi7mREiAWRv7O1ignAuMErc6rnNBFLFJqAh8XJaByOILSJgLPFqZSdY
        EbPAY0aJL/dXgY0SFvCSeDhvJ5jNIqAq8XXNUhaQ1bwCrhJTl7qChCUE5CTOH//JDLFZWWLu
        h2lg83kFBCVOznzCAmIzC0hIHHzxgnkCI/8sJKlZSFILGJlWMYoWpxYX56YbGeulFmUmFxfn
        5+nlpZZsYgSG7sEtv3V3MK5+7XiIUYCDUYmH9+lW8Vgh1sSy4srcQ4wSHMxKIryS50RihXhT
        EiurUovy44tKc1KLDzFKc7AoifOu9/4XIySQnliSmp2aWpBaBJNl4uCUamC05+tTDWhyeskQ
        vqZV+4C4GtvFjyHvlNhvdD95sCDFvabwF6+sK2PWmS/i7Jdbjdt5VyoINUtK9uqFxZsXskYe
        udC1nUktajL3FbcfDe+adMWmNru0b2QOXSTI1r5vw7lbmVHz1TL/nuiYkta7Y0Zwa4bG3H8n
        G6/MZNDv+inqcT1ee9HbLUosxRmJhlrMRcWJABbwhcpZAgAA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tipc_msg_validate() function leaves a boolean flag 'validated' in
the validated buffer's control block, to avoid performing this action
more than once. However, at reception of new packets, the position of
this field may already have been set by lower layer protocols, so
that the packet is erroneously perceived as already validated by TIPC.

We fix this by initializing the said field to 'false' before performing
the initial validation.

Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 324a1f9..3a5be1d 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1807,6 +1807,7 @@ void tipc_rcv(struct net *net, struct sk_buff *skb, struct tipc_bearer *b)
 	__skb_queue_head_init(&xmitq);
 
 	/* Ensure message is well-formed before touching the header */
+	TIPC_SKB_CB(skb)->validated = false;
 	if (unlikely(!tipc_msg_validate(&skb)))
 		goto discard;
 	hdr = buf_msg(skb);
-- 
2.1.4

