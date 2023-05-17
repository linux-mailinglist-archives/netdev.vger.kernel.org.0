Return-Path: <netdev+bounces-3463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD0C70744D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49FEC1C20FF4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA9010943;
	Wed, 17 May 2023 21:31:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE9D10942
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:31:27 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEED519AA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba83fed51adso2195013276.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684359082; x=1686951082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EaKzhqb/dGVPMeOpbE+DGG4DiN5Ezsfy9uG2UsGLzzA=;
        b=TE4Og9MEHxhveJpmv9p/sdAkhZ+XRqo7tNiw7LZLCuGzKUFZsuPCFdVqw5x0wxMNq1
         LpBfKzhKTSi4wmFUE1UFMarN1x3RcGNUE2FIkw95axLshC1Bs/vXY8RoVEwyRMeTvJoX
         n+uba9cEKURo+WLJq6g/EkEOFtwlT+Iin9RjYIGK3pjOXQSyqs/XHCouVzfkvM2dDLeL
         IrstNwtG6RbPzZGy4G4Xo8fBN2TPBX2wL9rUOunsCBLcJGGoJscSeAjhxdZS4xUMlgFD
         dJAQlnrP+oJ3VYTuS14JYc1p1ryrhthVTi3mCWITO2/OFfIFhM0L6/fjUYy8OeauRDP+
         vdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684359082; x=1686951082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EaKzhqb/dGVPMeOpbE+DGG4DiN5Ezsfy9uG2UsGLzzA=;
        b=XTFHd+kZzOWO4ei3E0PmtbVqj/klwUJw1WSLx7TskgcZn7iXvgUJuAZR8wJw3+uBYI
         RmjQnwjBivbI0PoPvxXneCPV3CmcDfIT5uwUsn6q2x6D9m/Zn1WRK6Fs5BGSxHpyj8+N
         52v5Qv1ZhKpn1D9gdCZpsNYly+fhsZNFROTeBVWkrSAKHMHOz78VibaU9p5o/zYl8V35
         uCkj1ro+WbO90UVyQszFA8kk7FOtq8nLUhehzFXuaM6sUxPot/8PN6nruR9M+OcBGhvK
         i+gy7cevouD7noSOD8R7EIOsP8q5+1EnYzSUHX125++W8ZrOsJnNKZsrlSTnalEN0UTT
         0KAg==
X-Gm-Message-State: AC+VfDxVbw123SehzsRAV4SpT1VR1aFT9C59XcZx8InHy5iaZCoQahZV
	GBlRwoBvGJFWHfT4RWGg0W7tcSyuGTyrbg==
X-Google-Smtp-Source: ACHHUZ6oxVgcnloxUZwf3ckh09kl9lu+nXCCvGcYbWJiI/QiUguc3g3fWF6CP5UxJ6STcWusrAub2hTJr22wwQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4a9:b0:ba7:6620:4caa with SMTP
 id r9-20020a05690204a900b00ba766204caamr6504639ybs.4.1684359082090; Wed, 17
 May 2023 14:31:22 -0700 (PDT)
Date: Wed, 17 May 2023 21:31:16 +0000
In-Reply-To: <20230517213118.3389898-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517213118.3389898-2-edumazet@google.com>
Subject: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in ipv6_rpl_srh_rcv()
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

After calls to pskb_may_pull() we need to reload @hdr variable,
because skb->head might have changed.

We need to move up first pskb_may_pull() call right after
looped_back label.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: David Lebrun <david.lebrun@uclouvain.be>
---
 net/ipv6/exthdrs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a8d961d3a477f6516f542025dfbcfc6f47407a70..b129e982205ee43cbf74f4900c3031827d962dc2 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -511,6 +511,10 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 	}
 
 looped_back:
+	if (!pskb_may_pull(skb, sizeof(*hdr))) {
+		kfree_skb(skb);
+		return -1;
+	}
 	hdr = (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
 
 	if (hdr->segments_left == 0) {
@@ -544,12 +548,6 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 
 		return 1;
 	}
-
-	if (!pskb_may_pull(skb, sizeof(*hdr))) {
-		kfree_skb(skb);
-		return -1;
-	}
-
 	n = (hdr->hdrlen << 3) - hdr->pad - (16 - hdr->cmpre);
 	r = do_div(n, (16 - hdr->cmpri));
 	/* checks if calculation was without remainder and n fits into
@@ -592,6 +590,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 		kfree_skb(skb);
 		return -1;
 	}
+	hdr = (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
 
 	hdr->segments_left--;
 	i = n - hdr->segments_left;
-- 
2.40.1.606.ga4b1b128d6-goog


