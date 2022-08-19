Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6EF599B9F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348938AbiHSMPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348756AbiHSMP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:15:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845BAFBA43
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:15:22 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id j8so8437186ejx.9
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=xXVWZhjqeAkNlLD6nIdsDN330sAu6yXoB2pmNWkfjq8=;
        b=6rZKvojny92lNHiwCXBDB7+e4XLb0SUSI8xNptuHRv3mpR4VbPEopPQKFCoCaH9ZKD
         5RulSf2FQdeaBH67QhgtpUFRiiAlEgE1eARGx2G4lAqES3VPgaMnY4jXjKRC8ZfVPtaI
         JWBz2VNlnT9K+wmrc+1oEyF2SjD0xiVh4Ng+pYdHH3TBCqsjQnplzoGXjV1zEabF2uGZ
         6Vwxr0mmTY79eJmqzd4sJr8Xoj5cHVNz/qThKqkptWP+CK37XRQj2kn5IKRovEMSiF7i
         Oe2FKbkKWMuILnmksVxVZQ7A7OhS1tn0HyvnRm/L6uNekVcnY20ZWh/2FDqeaJitkccp
         Gdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=xXVWZhjqeAkNlLD6nIdsDN330sAu6yXoB2pmNWkfjq8=;
        b=tLwLQRCp5j1oVI2E5RMlK1/T2qtyCHCxEWL7unVUyo1Zcmz7w17/fSV11gzo/cAK1V
         ovvabQaeQAKr8mRwfH8ValH28eS/oxHdZCfIKuvlfPRIGth2YmNhWTg9F6ZdfGg3EEFD
         8oRAlwYCVDt5R2/7zOhy/ghpLalA5SKtaksWLdz66zWDQuPunh66SD22hPZ/1cXmjtCN
         WR+Z1O/2szsiqGjAaj2Y5g1YKbW167c68boM6b5SfWFSuI5JhZL7HCbiHFSoBRTboPfa
         DOZQ0M95oLLqDeiTDSy2Arrv4U1fRtrMe7YUWmWslh8aXYIgLe8/KR2tgDfPG4cE0f8A
         LFeA==
X-Gm-Message-State: ACgBeo1QkDd+NFIOLScDeDnRZQBjui3zWvxY1GIDJETx1Q2dgbw6zjEe
        0fW+jE1/XmJSTvKbpiFmy/bMDA==
X-Google-Smtp-Source: AA6agR7GtKamrSDVG3lUy3KiEGlgb6UL9opr0vEUmz8GOGyER6fJlE6kBDeerafsCu3XHGzhZJ83tQ==
X-Received: by 2002:a17:906:98c9:b0:730:a23e:2785 with SMTP id zd9-20020a17090698c900b00730a23e2785mr4686376ejb.622.1660911320892;
        Fri, 19 Aug 2022 05:15:20 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906218a00b0072af2460cd6sm2260910eju.30.2022.08.19.05.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 05:15:20 -0700 (PDT)
Message-ID: <c9bc0382-fd0d-c596-5f61-365a8e0cbb21@blackwall.org>
Date:   Fri, 19 Aug 2022 15:15:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net v2] net: neigh: don't call kfree_skb() under
 spin_lock_irqsave()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     den@openvz.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
References: <20220819044724.961356-1-yangyingliang@huawei.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220819044724.961356-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 07:47, Yang Yingliang wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So add all skb to
> a tmp list, then free them after spin_unlock_irqrestore() at
> once.
> 
> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/core/neighbour.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 5b669eb80270..d21c7de1ff1a 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -309,14 +309,17 @@ static int neigh_del_timer(struct neighbour *n)
>  
>  static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>  {
> +	struct sk_buff_head tmp;
>  	unsigned long flags;
>  	struct sk_buff *skb;
>  
> +	skb_queue_head_init(&tmp);
>  	spin_lock_irqsave(&list->lock, flags);
>  	skb = skb_peek(list);
>  	while (skb != NULL) {
>  		struct sk_buff *skb_next = skb_peek_next(skb, list);
>  		struct net_device *dev = skb->dev;
> +
>  		if (net == NULL || net_eq(dev_net(dev), net)) {
>  			struct in_device *in_dev;
>  
> @@ -328,11 +331,16 @@ static void :q

(struct sk_buff_head *list, struct net *net)
>  			__skb_unlink(skb, list);
>  
>  			dev_put(dev);
> -			kfree_skb(skb);
> +			dev_kfree_skb_irq(skb);

this is still doing dev_kfree_skb_irq() instead of attaching the skb to tmp, in fact
tmp seems unused so the loop below does nothing

>  		}
>  		skb = skb_next;
>  	}
>  	spin_unlock_irqrestore(&list->lock, flags);
> +
> +	while ((skb = __skb_dequeue(&tmp))) {
> +		dev_put(skb->dev);

Also note that there's already a dev_put() above

> +		kfree_skb(skb);
> +	}
>  }
>  
>  static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,

