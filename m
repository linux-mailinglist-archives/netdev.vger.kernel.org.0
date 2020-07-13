Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC31721E1FD
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 23:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgGMVVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 17:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGMVVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 17:21:22 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542E1C061755;
        Mon, 13 Jul 2020 14:21:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so6592707pgm.11;
        Mon, 13 Jul 2020 14:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ABF/kSJ7GZyTbibG8EMm3ujzxwiwSYQQuEfE9U6jw1s=;
        b=A6Qz9He4HdllJ76p8Kxuf4DBMs2r3GvMpumwrMS+pZrhuZ6g8wVMoM69tEhPKoW3V7
         hy9eQvvd41eylP67IxVGu3V5VvRzmGUx+87y+F9PoaMWCjUh7UEOTU4RxBbeXSoDEgYQ
         fTbzLQ/4rHvU9sgjghxvXUBeu32kcRSmPFWkx1VrDSPlG9jS8T1xkDal0sn90ERqcblm
         8gXQMA0f6gpQADh+9AXZNd3YQ4oapp6tB/Gal1K7cw6+fduWn2f6lW3sdAcAkcwo1nQt
         CncVIAkv9WSH4E/xWXyqdhJf3BABXCFYHd8lyoOr4Q5CSGVXioGxZs9NaFi0AkZjk9UD
         ZU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABF/kSJ7GZyTbibG8EMm3ujzxwiwSYQQuEfE9U6jw1s=;
        b=PxYqrieRb3OJPEYeNUlhte5O91QwueYwHQhyEyYKLi+qhI5YAZpBNMAQPEHNi4UBxW
         lRRoJL7AjfiW1dSUD9eG6xEFJjtPQ6TdJJkDVdPu+nEwpGItecVXjkdwyNsrgpsA9VGg
         NiWaXntkySCmdIj5T2WeGFTYlPwybHfsYKQF8o/lBo+UoGLFUZRT+elQjnfO/SVFNgfr
         VxhzqrNFhXVhKV/RjJcZ7fulA7P4iXLimjRZlWjpQgjwJjPf3xz4VUnpPRDyBwELz0FR
         t64VJPhzBwfkAUaJszuE9tWNUVTcsMFYce9iBT3mTqDP4Cl62gJtIMpux2vXKYBpVmgQ
         QbNA==
X-Gm-Message-State: AOAM533FMvNvZbkhGaEg0UwnQ1I7MTbYtUQpBMo7isuOeajEnhxJIPZW
        Xy7uSuAqeTsIwpkOuNxZ5K1tcQdZ
X-Google-Smtp-Source: ABdhPJwNAx6zk/9vxInegSvSaW/luicXQSuqpwuYJGgMYuomcZ6hjq9GhwPrDxBRXRzOPXmOG5qTZg==
X-Received: by 2002:aa7:9155:: with SMTP id 21mr1466155pfi.306.1594675281319;
        Mon, 13 Jul 2020 14:21:21 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id bx18sm436031pjb.49.2020.07.13.14.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:21:20 -0700 (PDT)
Subject: Re: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
To:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
References: <20200708043754.46554-1-xie.he.0141@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4b46b0f6-8424-5a6e-a4ae-3729f54c5d4b@gmail.com>
Date:   Mon, 13 Jul 2020 14:21:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708043754.46554-1-xie.he.0141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/20 9:37 PM, Xie He wrote:
> This driver is not working because of problems of its receiving code.
> This patch fixes it to make it work.
> 
> When the driver receives an LAPB frame, it should first pass the frame
> to the LAPB module to process. After processing, the LAPB module passes
> the data (the packet) back to the driver, the driver should then add a
> one-byte pseudo header and pass the data to upper layers.
> 
> The changes to the "x25_asy_bump" function and the
> "x25_asy_data_indication" function are to correctly implement this
> procedure.
> 
> Also, the "x25_asy_unesc" function ignores any frame that is shorter
> than 3 bytes. However the shortest frames are 2-byte long. So we need
> to change it to allow 2-byte frames to pass.
> 
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/x25_asy.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
> index 69773d228ec1..3fd8938e591b 100644
> --- a/drivers/net/wan/x25_asy.c
> +++ b/drivers/net/wan/x25_asy.c
> @@ -183,7 +183,7 @@ static inline void x25_asy_unlock(struct x25_asy *sl)
>  	netif_wake_queue(sl->dev);
>  }
>  
> -/* Send one completely decapsulated IP datagram to the IP layer. */
> +/* Send an LAPB frame to the LAPB module to process. */
>  
>  static void x25_asy_bump(struct x25_asy *sl)
>  {
> @@ -195,13 +195,12 @@ static void x25_asy_bump(struct x25_asy *sl)
>  	count = sl->rcount;
>  	dev->stats.rx_bytes += count;
>  
> -	skb = dev_alloc_skb(count+1);
> +	skb = dev_alloc_skb(count);
>  	if (skb == NULL) {
>  		netdev_warn(sl->dev, "memory squeeze, dropping packet\n");
>  		dev->stats.rx_dropped++;
>  		return;
>  	}
> -	skb_push(skb, 1);	/* LAPB internal control */
>  	skb_put_data(skb, sl->rbuff, count);
>  	skb->protocol = x25_type_trans(skb, sl->dev);
>  	err = lapb_data_received(skb->dev, skb);
> @@ -209,7 +208,6 @@ static void x25_asy_bump(struct x25_asy *sl)
>  		kfree_skb(skb);
>  		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
>  	} else {
> -		netif_rx(skb);
>  		dev->stats.rx_packets++;
>  	}
>  }
> @@ -356,12 +354,16 @@ static netdev_tx_t x25_asy_xmit(struct sk_buff *skb,
>   */
>  
>  /*
> - *	Called when I frame data arrives. We did the work above - throw it
> - *	at the net layer.
> + *	Called when I frame data arrives. We add a pseudo header for upper
> + *	layers and pass it to upper layers.
>   */
>  
>  static int x25_asy_data_indication(struct net_device *dev, struct sk_buff *skb)
>  {

It is not clear to me what guarantee we have to have one byte of headroom in the skb
at this point.

You might add to be safe : (as done in lapbeth_data_indication(), but after the skb_push() which seems wrong)

      if (skb_cow(skb, 1)) {
            kfree_skb(skb); /* This line I am not sure, but looking at
                             * lapb_data_indication() this might be needed.
                             */
	    return NET_RX_DROP;
      }

> +	skb_push(skb, 1);
> +	skb->data[0] = X25_IFACE_DATA;
> +	skb->protocol = x25_type_trans(skb, dev);
> +
>  	return netif_rx(skb);
>  }
>  
> @@ -657,7 +659,7 @@ static void x25_asy_unesc(struct x25_asy *sl, unsigned char s)
>  	switch (s) {
>  	case X25_END:
>  		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
> -		    sl->rcount > 2)
> +		    sl->rcount >= 2)
>  			x25_asy_bump(sl);
>  		clear_bit(SLF_ESCAPE, &sl->flags);
>  		sl->rcount = 0;
> 
