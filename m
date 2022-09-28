Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC815EDD2D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiI1Mwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiI1Mwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:52:51 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63C31EE8;
        Wed, 28 Sep 2022 05:52:49 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z6so19697289wrq.1;
        Wed, 28 Sep 2022 05:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date;
        bh=1hzqiG7HrSUyrZce/1V3TgS1EDe5OFJVRs80nT+qH8M=;
        b=LUZHQXbpTD8cGM/dTvZySYSmQFfRhska9SS0ycvF9CtKf1nVXPwXqNR3eIYbb7r55Q
         e/rXq99bJ9UWi0JEhJW94NkXweAURXP0hoPP+nPRNvyasRaTBKWHQZRdgLk+QYHkIaY3
         T83Gej4RBHm5RKSHCRXUDUOusvgHFbnoWIh5sKIszCdl+sESLIZGAye1mnR2Pfb5uY6v
         tB49QBpn3eXQfOnKbK5iWu/MCbh1UXhsbnk6IVgjgIKOCPb6s5YHi7wqwXAZvGS5j0d0
         MywOq12zVey+nSw8Jzo8wWSrT1FGEOQ56/arrFi3F4+rDxpMEkC/j+o3rA4KETmOSUMw
         snTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1hzqiG7HrSUyrZce/1V3TgS1EDe5OFJVRs80nT+qH8M=;
        b=MtsGU8Aw+zmnxMF5JWPZODUgaB5zOFimsVZ2XbzRycM8pTLPFIPDaUtpXIg292Nqzr
         wq36Svvbr+iFCLobtfaMtTDYJLj6d0Goa/suNO0odXL7Oq3lccTdGqIzs/fY4JVyMelv
         S8r5yUxC7NhZqElPu7QSPgiaYaI/JXN4ujoLudiTPa5zomP0TaxqXSYHtXzrxfU+CPwf
         KIcxortDykTHdkRYxFThIwpt1TLwCJ9zYUdbE22tcb6bgHtNvEuB4dRpKSOMIeOqfWZz
         BSn0iBETvtA/jcUPIE65E55RVXR35If0IWR+J9P62pgO8BPqG3HM++vncbNh/Wk4BHnZ
         SEkA==
X-Gm-Message-State: ACrzQf3cBewqWvUDU2IgvFRdHHBDqVXPO5w+BTTpiI2qcb74qVnMgM4u
        7UjblXt6p+ztTE69Pi1rjSE=
X-Google-Smtp-Source: AMsMyM7PEGqEafMK3+1QAtnaexhIdk5J0T6/kg3u9T089hxyPQP47pTZbBpqvqO9iMyIpA4+QX+vFQ==
X-Received: by 2002:a05:6000:689:b0:228:e2cf:d20e with SMTP id bo9-20020a056000068900b00228e2cfd20emr19673995wrb.147.1664369568444;
        Wed, 28 Sep 2022 05:52:48 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id j8-20020a5d6188000000b0022cc3e67fc5sm2961687wru.65.2022.09.28.05.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 05:52:48 -0700 (PDT)
Date:   Wed, 28 Sep 2022 14:55:31 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        johannes@sipsolutions.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH] net-next: skbuff: refactor pskb_pull
Message-ID: <20220928125522.GA100793@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pskb_may_pull already contains all of the checks performed by
pskb_pull.
Use pskb_may_pull for validation in pskb_pull, eliminating the
duplication and making __pskb_pull obsolete.
Replace __pskb_pull with pskb_pull where applicable.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/linux/skbuff.h | 23 +++++++++--------------
 net/ipv6/ip6_offload.c |  2 +-
 net/mac80211/rx.c      |  4 ++--
 net/xfrm/espintcp.c    |  2 +-
 4 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8afa382bf2..615cd660dd69 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2587,20 +2587,6 @@ void *skb_pull_data(struct sk_buff *skb, size_t len);
 
 void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
-static inline void *__pskb_pull(struct sk_buff *skb, unsigned int len)
-{
-	if (len > skb_headlen(skb) &&
-	    !__pskb_pull_tail(skb, len - skb_headlen(skb)))
-		return NULL;
-	skb->len -= len;
-	return skb->data += len;
-}
-
-static inline void *pskb_pull(struct sk_buff *skb, unsigned int len)
-{
-	return unlikely(len > skb->len) ? NULL : __pskb_pull(skb, len);
-}
-
 static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
 {
 	if (likely(len <= skb_headlen(skb)))
@@ -2610,6 +2596,15 @@ static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
 	return __pskb_pull_tail(skb, len - skb_headlen(skb)) != NULL;
 }
 
+static inline void *pskb_pull(struct sk_buff *skb, unsigned int len)
+{
+	if (!pskb_may_pull(skb, len))
+		return NULL;
+
+	skb->len -= len;
+	return skb->data += len;
+}
+
 void skb_condense(struct sk_buff *skb);
 
 /**
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d12dba2dd535..d31775b87b6a 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -235,7 +235,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 	proto = iph->nexthdr;
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive) {
-		__pskb_pull(skb, skb_gro_offset(skb));
+		pskb_pull(skb, skb_gro_offset(skb));
 		skb_gro_frag0_invalidate(skb);
 		proto = ipv6_gso_pull_exthdrs(skb, proto);
 		skb_gro_pull(skb, -skb_transport_offset(skb));
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 57df21e2170a..addc8294198b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -49,7 +49,7 @@ static struct sk_buff *ieee80211_clean_skb(struct sk_buff *skb,
 
 	if (present_fcs_len)
 		__pskb_trim(skb, skb->len - present_fcs_len);
-	__pskb_pull(skb, rtap_space);
+	pskb_pull(skb, rtap_space);
 
 	hdr = (void *)skb->data;
 	fc = hdr->frame_control;
@@ -74,7 +74,7 @@ static struct sk_buff *ieee80211_clean_skb(struct sk_buff *skb,
 
 	memmove(skb->data + IEEE80211_HT_CTL_LEN, skb->data,
 		hdrlen - IEEE80211_HT_CTL_LEN);
-	__pskb_pull(skb, IEEE80211_HT_CTL_LEN);
+	pskb_pull(skb, IEEE80211_HT_CTL_LEN);
 
 	return skb;
 }
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 82d14eea1b5a..2000d67f9982 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -91,7 +91,7 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	}
 
 	/* remove header, leave non-ESP marker/SPI */
-	if (!__pskb_pull(skb, rxm->offset + 2)) {
+	if (!pskb_pull(skb, rxm->offset + 2)) {
 		XFRM_INC_STATS(sock_net(strp->sk), LINUX_MIB_XFRMINERROR);
 		kfree_skb(skb);
 		return;
-- 
2.20.1

