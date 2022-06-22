Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF65550E5
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358809AbiFVQK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356636AbiFVQK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:10:28 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A399B3703E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:10:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u12so35277620eja.8
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=y2YO9/O6no0imcsCRFEbzTu6b4kaHJ0+DKmmWMOQcOo=;
        b=mOR4HKXwuWXVFq41eXkGtU9S0bM2iMTYVFD5Av9BCDbVLDH8u9mX7viiBpLJk1d/wf
         YejkG5I3VuxwI7pPc29FfQypDFbXwC5MYXHBQSWz2NgIduuMPHKw7XUjNlpPyoql/f/g
         KJU5R43hZYHH5ZwZPE0pOhTJAuqfquxm9IAlgtT1jCzlJDAhRG1Wf7NLRKe2Ko/+u3ei
         pDR3DcR20jUn7NgIGw4EEdpxx5nLvqIC8NSpuuD+qatpOljFpSEWWgSUN66yUkMZEhpj
         hx+D7cFtGKZusKdmrxjHQv5c4+W5zYix+Hm4seOsh6VWqyafuJgCjIDfZQ5S8OTpa05S
         yZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=y2YO9/O6no0imcsCRFEbzTu6b4kaHJ0+DKmmWMOQcOo=;
        b=6EM315mN6ap8nCDlEWQHAzDfwj9XLrWBN3nKhb1g2FEETNWwUvLIX69s4Ap3/nA4u3
         f8iZJSAUs/5gdmAo1Z2XSUYY9lCwc1ZwWcCkVKqnu+siQKbI8N47QfSeuzV6bNDlJOXB
         ZFY33ZeLPqc1aiqQeiRYaALrcmwXmPy8cWEKKccZU0qnnXT5YjoEwgAw1cowdIb3Ncp2
         0UNO+7SAijmq3MDEdaezmerKrA4UZo/BW5myyb33cdyjSOyL7oLEm+m+HlLAhOLSe860
         1rn4KQ3wC8HPiEInAOb906MUuALJZ77uoYaVzbUwSN71656EGPR+0pGGnq1T2d98Idne
         ha/Q==
X-Gm-Message-State: AJIora9HRLnioiuWuDOw16kZqfK5MoP6P2fipWp0T+nY1jYYC9d12T23
        aOZs33NUUhuoztxCXZ0fuYc=
X-Google-Smtp-Source: AGRyM1tQL+nW5gR+hmO0z+EGyRDR5pL/QH6okTkcekThh9jWJyIiKdENu4Dyy+SISue0bGh1RaNCUg==
X-Received: by 2002:a17:907:8a17:b0:711:e3fe:7767 with SMTP id sc23-20020a1709078a1700b00711e3fe7767mr3795737ejc.380.1655914226083;
        Wed, 22 Jun 2022 09:10:26 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id e7-20020a50ec87000000b0043561e0c9adsm12748339edr.52.2022.06.22.09.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 09:10:25 -0700 (PDT)
Date:   Wed, 22 Jun 2022 18:09:03 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: [PATCH v3] net: helper function skb_len_add
Message-ID: <20220622160853.GA6478@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the len fields manipulation in the skbs to a helper function.
There is a comment specifically requesting this and there are several
other areas in the code displaying the same pattern which can be
refactored.
This improves code readability.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/linux/skbuff.h | 12 ++++++++++++
 include/net/sock.h     |  4 +---
 net/core/skbuff.c      | 13 +++----------
 net/ipv4/esp4.c        |  4 +---
 net/ipv4/ip_output.c   |  8 ++------
 5 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84d78df60453..b02e0a314683 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2417,6 +2417,18 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 }
 
 /**
+ * skb_len_add - adds a number to len fields of skb
+ * @skb: buffer to add len to
+ * @delta: number of bytes to add
+ */
+static inline void skb_len_add(struct sk_buff *skb, int delta)
+{
+	skb->len += delta;
+	skb->data_len += delta;
+	skb->truesize += delta;
+}
+
+/**
  * __skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
  * @i: paged fragment index to initialise
diff --git a/include/net/sock.h b/include/net/sock.h
index a01d6c421aa2..648658f782c2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2230,9 +2230,7 @@ static inline int skb_copy_to_page_nocache(struct sock *sk, struct iov_iter *fro
 	if (err)
 		return err;
 
-	skb->len	     += copy;
-	skb->data_len	     += copy;
-	skb->truesize	     += copy;
+	skb_len_add(skb, copy);
 	sk_wmem_queued_add(sk, copy);
 	sk_mem_charge(sk, copy);
 	return 0;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..2110db41cb41 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3195,9 +3195,7 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 		}
 	}
 
-	to->truesize += len + plen;
-	to->len += len + plen;
-	to->data_len += len + plen;
+	skb_len_add(to, len + plen);
 
 	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
 		skb_tx_error(from);
@@ -3634,13 +3632,8 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 	tgt->ip_summed = CHECKSUM_PARTIAL;
 	skb->ip_summed = CHECKSUM_PARTIAL;
 
-	/* Yak, is it really working this way? Some helper please? */
-	skb->len -= shiftlen;
-	skb->data_len -= shiftlen;
-	skb->truesize -= shiftlen;
-	tgt->len += shiftlen;
-	tgt->data_len += shiftlen;
-	tgt->truesize += shiftlen;
+	skb_len_add(skb, -shiftlen);
+	skb_len_add(tgt, shiftlen);
 
 	return shiftlen;
 }
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index d747166bb291..2ad3d6955dae 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -502,9 +502,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 
 			nfrags++;
 
-			skb->len += tailen;
-			skb->data_len += tailen;
-			skb->truesize += tailen;
+			skb_len_add(skb, tailen);
 			if (sk && sk_fullsock(sk))
 				refcount_add(tailen, &sk->sk_wmem_alloc);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..5e32a2f86fbd 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1214,9 +1214,7 @@ static int __ip_append_data(struct sock *sk,
 
 			pfrag->offset += copy;
 			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
-			skb->len += copy;
-			skb->data_len += copy;
-			skb->truesize += copy;
+			skb_len_add(skb, copy);
 			wmem_alloc_delta += copy;
 		} else {
 			err = skb_zerocopy_iter_dgram(skb, from, copy);
@@ -1443,9 +1441,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 			skb->csum = csum_block_add(skb->csum, csum, skb->len);
 		}
 
-		skb->len += len;
-		skb->data_len += len;
-		skb->truesize += len;
+		skb_len_add(skb, len);
 		refcount_add(len, &sk->sk_wmem_alloc);
 		offset += len;
 		size -= len;
-- 
2.36.1

