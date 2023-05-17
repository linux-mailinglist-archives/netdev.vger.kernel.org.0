Return-Path: <netdev+bounces-3464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC0870744E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 971B22814EB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEEE10953;
	Wed, 17 May 2023 21:31:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920D310942
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:31:27 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5201987
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2526a8918so2180976276.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684359084; x=1686951084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=csAjbYwJu7UYdTj0AOh80duniSMnuTnfbsSOqNb+yb8=;
        b=PVWUONt37Ie/L7QqPGLnMazin6L1nHfEiD434Hx/xVD39uXRejt2mODaoMerrDYzc/
         VDT33CvEOGlnZCc32PQeh0U9Ndy5uxXXqR9whRNRMFgF/3v4D+sqZs6onQw2HcqCxZ21
         OiEAItswAbDJajL/MHJLnn2MgyPK27y9iQWfb/Ro7do26I0k/v4Ys2xgRvUaQPH5NigE
         f3qfGiLpHS90aR7RP7l8ayKIMn8AHfCi0YFW5hJyCUOcPSK6WT1EBuRv3vmO5AfAcR4b
         u46Ktmsy0xMx7yc7mgfRsggFzd7XOEFXhrZB8PYje1SKjly8BQlwiqhJ1xHY041LuON3
         fEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684359084; x=1686951084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=csAjbYwJu7UYdTj0AOh80duniSMnuTnfbsSOqNb+yb8=;
        b=O2puwD/LK6HNgpxk962xJ9rgrQkIhnRnZnI6OMv0A/ls/JDRi7ApUJoTLKdIQi/M4Z
         csmyuFIx1+xKbJq8Vu4KIQpRvdkdswegQ7vE2QdlmTKM7OQVy+rBWurKfwq1nVBGHVa6
         tRZ97S+9pTvOb+hQq8bOQrEguOrb5ueXb//BFWvzZORiuC8xSbNganttUFJr8zA/LCVh
         AsBzwdVBo6sDdJKidz/KzAIJugbbca5KbPtua49FCV8ANvHN6/3gvg+05PTAB5WO97rS
         4Qs52alfv7VKst1tiU8jzURaNLd6gbvvjedfWbQxPCc6YplaADo++fGKwiWgG1OvEZMu
         5L0w==
X-Gm-Message-State: AC+VfDwm4JiapFm4J9iVPAopbjWUr01CQ7iEtBm08GJ1UFJP+s/3jQDB
	ISz3BCAShqYclwuE1vaFKoyNNBDdTGaicw==
X-Google-Smtp-Source: ACHHUZ72ocwz0bOOjc186ZJ/ShcIKSrD1+3flWCc32Ta3UGocwbnqxIrBRka0U9d9PqDgcxfIm8GGjxCoUq8jg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:4e41:0:b0:ba7:3724:37dc with SMTP id
 c62-20020a254e41000000b00ba7372437dcmr7352605ybb.13.1684359083877; Wed, 17
 May 2023 14:31:23 -0700 (PDT)
Date: Wed, 17 May 2023 21:31:17 +0000
In-Reply-To: <20230517213118.3389898-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517213118.3389898-3-edumazet@google.com>
Subject: [PATCH net 2/3] ipv6: exthdrs: avoid potential NULL deref in ipv6_srh_rcv()
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

ipv6_srh_rcv() caller (ipv6_rthdr_rcv()) correctly deals with
a NULL idev, we can use the same idea.

Same problem was later added in ipv6_rpl_srh_rcv(),
this is handled in a separate patch to ease stable backports.

Fixes: 1ababeba4a21 ("ipv6: implement dataplane support for rthdr type 4 (Segment Routing Header)")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Lebrun <david.lebrun@uclouvain.be>
Cc: Alexander Aring <alex.aring@gmail.com>
---
 net/ipv6/exthdrs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index b129e982205ee43cbf74f4900c3031827d962dc2..4f874f70b3fb1f6b372b937fcfe6ebd1a56b921d 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -366,21 +366,18 @@ static void seg6_update_csum(struct sk_buff *skb)
 			   (__be32 *)addr);
 }
 
-static int ipv6_srh_rcv(struct sk_buff *skb)
+static int ipv6_srh_rcv(struct sk_buff *skb, struct inet6_dev *idev)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct net *net = dev_net(skb->dev);
 	struct ipv6_sr_hdr *hdr;
-	struct inet6_dev *idev;
 	struct in6_addr *addr;
 	int accept_seg6;
 
 	hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
-	idev = __in6_dev_get(skb->dev);
-
 	accept_seg6 = net->ipv6.devconf_all->seg6_enabled;
-	if (accept_seg6 > idev->cnf.seg6_enabled)
+	if (idev && accept_seg6 > idev->cnf.seg6_enabled)
 		accept_seg6 = idev->cnf.seg6_enabled;
 
 	if (!accept_seg6) {
@@ -711,7 +708,7 @@ static int ipv6_rthdr_rcv(struct sk_buff *skb)
 	switch (hdr->type) {
 	case IPV6_SRCRT_TYPE_4:
 		/* segment routing */
-		return ipv6_srh_rcv(skb);
+		return ipv6_srh_rcv(skb, idev);
 	case IPV6_SRCRT_TYPE_3:
 		/* rpl segment routing */
 		return ipv6_rpl_srh_rcv(skb);
-- 
2.40.1.606.ga4b1b128d6-goog


