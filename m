Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF3722E3C0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 03:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgG0BwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 21:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgG0BwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 21:52:14 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9819DC0619D2;
        Sun, 26 Jul 2020 18:52:14 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id o2so6755299qvk.6;
        Sun, 26 Jul 2020 18:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=s0MTKKieN/5uVLS9bf74sUuYGfWvsi8uePbeYi7/ZQQ=;
        b=ulRkaaW1PHcCELDSdF9HxDj/uDBqyLm7aAEVHTvTq2QGpk6MJ1rgM+xjfHBhwORICq
         aHnRrfVDzUSW+3dRGzk/5qDez9RBFjsuPkvHy4K3CY4r+gm8DcS5sCNnoCD88Hk2p8ko
         P8YlgWPyvctOLknja1GCrRNdud90Jmbb0Xb2tQH/Nd+oIkYhlLjVDwHuHEr4PldIZPZq
         wmoZxBMk2P1rU7zGuURTTqYnastOQiaNB0mXl5OzhpyyBq7CPRSdQenqSWbhLEIfZJoi
         2RSaOhrRHOdcm/IF6kMBsHz22IW/kFBQwkhG2Vqq+mpah9pHr7OAvAbuemMzPrZhVupd
         geHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=s0MTKKieN/5uVLS9bf74sUuYGfWvsi8uePbeYi7/ZQQ=;
        b=nwHb7tOct8YfB6A7Zhciam5g8LvbHqKhmW3m4wbA/bFZq62aDploGd4foUu0SFHVDf
         Mm/+AI7a8/hXDm4YvNHY1CpGy/ZmRgh8cIFGRy5pvcfOdPDDfMm2vkJPx209gWI1Ewfi
         KPlV8jOLJO/czoSDEsJp5XlhOSt8LC6y+pzn6kL7//nBGFwNOuhgx8GltVGfDVyTWA+f
         UBgbcRvf6iwk+jEY4ovLAtVOkKXqzBkJEVA5+ME7FwYwKb+4TUMSJYtC/skNVg6EPH/3
         wvzyw2pplM0dtw2LhbpFFfqZs3U7DSk4Fv/eSLlrN/rRY8ICd8S/6PaJizswyXHOP4F8
         yZuw==
X-Gm-Message-State: AOAM533uF931eBaHryaBltQidr1/yBp1Z6gjBv2a4ZkW1y+xJeV45ced
        a92ut58C9P6w0yCkKQHnTT0=
X-Google-Smtp-Source: ABdhPJxSpUpXepXtpRmIc6e37L65Fv/e797GhCbnMphucuUsumOMoskJridQh/wS8Wfgd5AG5ymYvQ==
X-Received: by 2002:a0c:82a2:: with SMTP id i31mr20687818qva.106.1595814733886;
        Sun, 26 Jul 2020 18:52:13 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:9cb8:60da:6bf0:c998])
        by smtp.googlemail.com with ESMTPSA id 184sm15359142qkl.37.2020.07.26.18.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 18:52:13 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] netfilter: ip6tables: Remove redundant null checks
Date:   Sun, 26 Jul 2020 21:52:05 -0400
Message-Id: <20200727015206.26423-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625023626.32557-1-gaurav1086@gmail.com>
References: <20200625023626.32557-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netfilter: ip6tables: Remove redundant null checks

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/netfilter/ip6t_ah.c   | 3 +--
 net/ipv6/netfilter/ip6t_frag.c | 3 +--
 net/ipv6/netfilter/ip6t_hbh.c  | 3 +--
 net/ipv6/netfilter/ip6t_rt.c   | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 4e15a14435e4..70da2f2ce064 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -74,8 +74,7 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 ahinfo->hdrres, ah->reserved,
 		 !(ahinfo->hdrres && ah->reserved));
 
-	return (ah != NULL) &&
-		spi_match(ahinfo->spis[0], ahinfo->spis[1],
+	return spi_match(ahinfo->spis[0], ahinfo->spis[1],
 			  ntohl(ah->spi),
 			  !!(ahinfo->invflags & IP6T_AH_INV_SPI)) &&
 		(!ahinfo->hdrlen ||
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index fb91eeee4a1e..3aad6439386b 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -85,8 +85,7 @@ frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !((fraginfo->flags & IP6T_FRAG_NMF) &&
 		   (ntohs(fh->frag_off) & IP6_MF)));
 
-	return (fh != NULL) &&
-		id_match(fraginfo->ids[0], fraginfo->ids[1],
+	return id_match(fraginfo->ids[0], fraginfo->ids[1],
 			 ntohl(fh->identification),
 			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)) &&
 		!((fraginfo->flags & IP6T_FRAG_RES) &&
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 467b2a86031b..e7a3fb9355ee 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -86,8 +86,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		  ((optinfo->hdrlen == hdrlen) ^
 		   !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
 
-	ret = (oh != NULL) &&
-	      (!(optinfo->flags & IP6T_OPTS_LEN) ||
+	ret = (!(optinfo->flags & IP6T_OPTS_LEN) ||
 	       ((optinfo->hdrlen == hdrlen) ^
 		!!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index f633dc84ca3f..733c83d38b30 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -89,8 +89,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !((rtinfo->flags & IP6T_RT_RES) &&
 		   (((const struct rt0_hdr *)rh)->reserved)));
 
-	ret = (rh != NULL) &&
-	      (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
 	      (!(rtinfo->flags & IP6T_RT_LEN) ||
-- 
2.17.1

