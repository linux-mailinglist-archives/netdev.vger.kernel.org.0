Return-Path: <netdev+bounces-3465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 725D370744F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E93882817A5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3551510968;
	Wed, 17 May 2023 21:31:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B29B10942
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:31:28 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDFF1732
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:26 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56183784dd3so13643647b3.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684359085; x=1686951085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=irIG8KCUOmzBVDybK28kbexqEPi6/ODq6585bSSKGg0=;
        b=5rUT6j+BOtp//ggWf1bhEOJCFLklHJAnGgabKbrmezb+vdC2G6qb2FYk+FfcEUtNfX
         kx/aN6pcsdNRe3X5CD4qdpnybuiPHE7N7BO+1Jc9vz0dMX59bDU8Cagb/o0zE9DQLzVr
         lTwHGKU3XsCeKN0L8SA+a97nIjfFRBhjxWpZsr6Y6faiXeUzmyYBHz1qZuMaWN8Ey9va
         dLdntoNiRhUrqzsk2/+13nBExq/uM5G/b/6Kr0WpeuAHrJUxuLlZsLOwJZZGER2xqA+i
         kRIx5nZNsFnYCZRWTPiQR780JI18L3Vx+02pZUJady0Sk2P41+0ZcqcnJFQKceOYs0RH
         Ol2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684359085; x=1686951085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=irIG8KCUOmzBVDybK28kbexqEPi6/ODq6585bSSKGg0=;
        b=Rf92QQjkW6lgW5M+QbuTHCdi+XcjOk3457L1Rd4iTbLxcBntKB0vNSx8jgzUUjQ+Sa
         9BlJJY1NsOCRsFa9z++3mN6DzUqcZKLFOPaVxmsDMxCEm/CXFoeejafy0FkSPSo1nqUB
         dWdv9y2WKZJLKOa06S34ODJwAkVw9q+e9+YdXlg2/bacRqUCqiN6EROzh7J1LKkara3d
         FueCLZPisUy+2NtHnTUK9pzijgA3VAVz/M5lXYPMntPsC52uaRj5lJocFzP9G77UZ6r4
         wspIuyBn/SqDaOz6I9MuDSEa4FVm9jpGv2P3J/DIy7kfT339PDc2M9bfVwygFYps+pB5
         DBBw==
X-Gm-Message-State: AC+VfDx60pNHjJwLS3soJmRUCyW1X31f2fGkeV1HwT829bmc9vRTjVBD
	fi54Zi57l82OyNRGaTaeyz1nymUfAhraiw==
X-Google-Smtp-Source: ACHHUZ5E3v4u/a3tqWFE4Px3wpDa1TKOGf1O6Fs57F0a9uC+9kxmQJovQjrQM68gAJcSy7yQWmLryWClhzXmUg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:e703:0:b0:561:c567:c8ff with SMTP id
 x3-20020a81e703000000b00561c567c8ffmr1873776ywl.4.1684359085554; Wed, 17 May
 2023 14:31:25 -0700 (PDT)
Date: Wed, 17 May 2023 21:31:18 +0000
In-Reply-To: <20230517213118.3389898-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517213118.3389898-4-edumazet@google.com>
Subject: [PATCH net 3/3] ipv6: exthdrs: avoid potential NULL deref in ipv6_rpl_srh_rcv()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Aring <alex.aring@gmail.com>, David Lebrun <david.lebrun@uclouvain.be>, 
	netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is some chance __in6_dev_get() returns NULL, we should
not crash if that happens.

ipv6_rpl_srh_rcv() caller (ipv6_rthdr_rcv()) correctly deals with
a NULL idev, we can use the same idea.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Lebrun <david.lebrun@uclouvain.be>
Cc: Alexander Aring <alex.aring@gmail.com>
---
 net/ipv6/exthdrs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 4f874f70b3fb1f6b372b937fcfe6ebd1a56b921d..cf86d07227d0c4fe7081a45a61124f8aaae4ec3a 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -483,12 +483,11 @@ static int ipv6_srh_rcv(struct sk_buff *skb, struct inet6_dev *idev)
 	return -1;
 }
 
-static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
+static int ipv6_rpl_srh_rcv(struct sk_buff *skb, struct inet6_dev *idev)
 {
 	struct ipv6_rpl_sr_hdr *hdr, *ohdr, *chdr;
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(skb->dev);
-	struct inet6_dev *idev;
 	struct ipv6hdr *oldhdr;
 	unsigned char *buf;
 	int accept_rpl_seg;
@@ -496,10 +495,8 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 	u64 n = 0;
 	u32 r;
 
-	idev = __in6_dev_get(skb->dev);
-
 	accept_rpl_seg = net->ipv6.devconf_all->rpl_seg_enabled;
-	if (accept_rpl_seg > idev->cnf.rpl_seg_enabled)
+	if (idev && accept_rpl_seg > idev->cnf.rpl_seg_enabled)
 		accept_rpl_seg = idev->cnf.rpl_seg_enabled;
 
 	if (!accept_rpl_seg) {
@@ -711,7 +708,7 @@ static int ipv6_rthdr_rcv(struct sk_buff *skb)
 		return ipv6_srh_rcv(skb, idev);
 	case IPV6_SRCRT_TYPE_3:
 		/* rpl segment routing */
-		return ipv6_rpl_srh_rcv(skb);
+		return ipv6_rpl_srh_rcv(skb, idev);
 	default:
 		break;
 	}
-- 
2.40.1.606.ga4b1b128d6-goog


