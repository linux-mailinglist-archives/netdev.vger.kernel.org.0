Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85663782A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiKXLzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiKXLzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:55:49 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0D6C663A;
        Thu, 24 Nov 2022 03:55:48 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso1064036wmp.5;
        Thu, 24 Nov 2022 03:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uFPDvjtCbP4Fl3gQ9OrK16yYyHn0B4VM0PaF8ZquGSE=;
        b=T/FnsTcT2xkrA3yQ7Q2zthHnE2uoosNgSDeCjWjQkBX7Sael4MOqvmSL5UuvyvnV7z
         ah1rVgohqfDCitHE0id8Jw8unFHfZjGV5Bd/dljfEMHnKuIBpFNjyWhU92sovQ+I3yWQ
         WnNUD/4H6Rn0tuBOaz4v987chDB6Da8qOZVz9wd/oNsolUFLTY6u78vmf7m6UUmw79da
         ORmHnrQdrcGbj+V5gxg+n9M8lkCaOiMuVbxG0o879IVDyHJkd8F1htwsmHvYW4wtl2Kw
         ktFaT2SZwWCpdN/oKjfr6JsO/laMimQHBxSzGwAiLPtCN/fjQzj/T+i85VaMrWpP1jvy
         Pf4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFPDvjtCbP4Fl3gQ9OrK16yYyHn0B4VM0PaF8ZquGSE=;
        b=Jb9oTydA/nyQgAWiuYzTg95WkWt3JcwoMBvLWhmbL7XQvW/5OcB1WTxM/cKeeqaTyj
         2/RYmQXz/HA0nqgiyKkCWrIuNAx7Bsqz507ctGl37Xuk+NlwHLSk+iFFUBlrxvWeRX71
         ZoxDnplXDDEUfTECPoNYy/2P/wEhlvfAmePq+KD8XPSjtVXIg+b6FuC5TnMMuoNyE5ca
         9DPQsT+IQvpheLwAf4D4r2MgnQhYbsDjorabsB1keOnIOd14lBzeMEvTX6xoOu/xcwyo
         8nwNVVpIbZKmscQDsrgJZjBfgC3iDiRhNmON55E9kKl2ue2F7mLHtmz5eJksCbFwo9s5
         5cUA==
X-Gm-Message-State: ANoB5pncX9h0g/8tCW8KMu+2umtLqhwfpVKrbD+gLehgntwUaq7ajGVQ
        0wg8iojt0w/kVU5rCT72/xs=
X-Google-Smtp-Source: AA0mqf4iTbXVexLP7EAep4whGHAwXJHtThiCt5FXGGd/CojQ6kmwtgWiR+L/juTpZyQfSB/AUKHgZw==
X-Received: by 2002:a05:600c:288:b0:3cf:758f:161f with SMTP id 8-20020a05600c028800b003cf758f161fmr21979270wmk.54.1669290947271;
        Thu, 24 Nov 2022 03:55:47 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c4f1600b003cffd3c3d6csm1717612wmq.12.2022.11.24.03.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:55:46 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:55:27 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] gro: change confusing use of flush variable
Message-ID: <20221124115507.GA73719@debian>
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

The variable "flush" in tcp_gro_received is confusingly used for two different
purposes. The first use is to keep track whether we are going to flush the SKB
at the end of the function (the same use as in other GRO receive functions). The
second use is just after the "found" label, where it is used to keep track
whether we are going to skip the call to skb_gro_receive that merges the SKBs.
This is entirely not related to the previous use, but uses the same variable.

To make the code more readable, this patch moves the second use to a separate
variable called "dont_merge".

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv4/tcp_offload.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index f17271e5c7c5..7ca6be2f56df 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -191,6 +191,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	unsigned int hlen;
 	unsigned int off;
 	int flush = 1;
+	int dont_merge;
 	int i;
 
 	off = skb_gro_offset(skb);
@@ -234,13 +235,13 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 found:
 	/* Include the IP ID check below from the inner most IP hdr */
-	flush = NAPI_GRO_CB(p)->flush;
-	flush |= (__force int)(flags & TCP_FLAG_CWR);
-	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
+	dont_merge = NAPI_GRO_CB(p)->flush;
+	dont_merge |= (__force int)(flags & TCP_FLAG_CWR);
+	dont_merge |= (__force int)((flags ^ tcp_flag_word(th2)) &
 		  ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
-	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
+	dont_merge |= (__force int)(th->ack_seq ^ th2->ack_seq);
 	for (i = sizeof(*th); i < thlen; i += 4)
-		flush |= *(u32 *)((u8 *)th + i) ^
+		dont_merge |= *(u32 *)((u8 *)th + i) ^
 			 *(u32 *)((u8 *)th2 + i);
 
 	/* When we receive our second frame we can made a decision on if we
@@ -250,7 +251,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	if (NAPI_GRO_CB(p)->flush_id != 1 ||
 	    NAPI_GRO_CB(p)->count != 1 ||
 	    !NAPI_GRO_CB(p)->is_atomic)
-		flush |= NAPI_GRO_CB(p)->flush_id;
+		dont_merge |= NAPI_GRO_CB(p)->flush_id;
 	else
 		NAPI_GRO_CB(p)->is_atomic = false;
 
@@ -261,16 +262,16 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	 * is bigger than our mss.
 	 */
 	if (unlikely(skb_is_gso(skb)))
-		flush |= (mss != skb_shinfo(skb)->gso_size);
+		dont_merge |= (mss != skb_shinfo(skb)->gso_size);
 	else
-		flush |= (len - 1) >= mss;
+		dont_merge |= (len - 1) >= mss;
 
-	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
+	dont_merge |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
 #ifdef CONFIG_TLS_DEVICE
-	flush |= p->decrypted ^ skb->decrypted;
+	dont_merge |= p->decrypted ^ skb->decrypted;
 #endif
 
-	if (flush || skb_gro_receive(p, skb)) {
+	if (dont_merge || skb_gro_receive(p, skb)) {
 		flush = 0;
 		goto out_check_final;
 	}
-- 
2.36.1

