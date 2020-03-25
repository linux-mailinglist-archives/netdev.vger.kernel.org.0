Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20F192018
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 05:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgCYEWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 00:22:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41789 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 00:22:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so309226plr.8
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 21:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MTXh/uYVhTcxkMvcajDj8d0iLHQvl7uo7VgVFRoUGGw=;
        b=avRZHdOp3t8l3502MZ+mk3EGtUNJ8nGQ3MCxnAPpirMrV33ouYGxY21YZJKv0tKa4Z
         LgOyQwFuI/6d1MLjztSFJn1j7K7g9mLEiFA7FXr4kezdeh/Z+KeZxyEelOix4nJxDR7C
         0I0DUGcx16RMEZPfiAR9HlqXw1/nZteztn/XVxglgD3rcbJbf0FZlJ06MrItj/4MPJTS
         TppXaCa94TjAH5qeiYnrOnmyKlkf3Ba3/ByEKr3xvZnJmyBGHog9J+BhURbXHtDm+Zhb
         au5DwVIjCKnC1NyXoqWPOIm9PyDTM3AFv0wHxgswZSXeuSEBxN3fSOKWuWzNSFFmjE8p
         n3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTXh/uYVhTcxkMvcajDj8d0iLHQvl7uo7VgVFRoUGGw=;
        b=dknGJAuwrDVzsdS9kyrHudEwEn2wjmWSARKj5HXyMvjYCe4UBZ3Sn/hUQuNSFSiELX
         J57uDDDsv+1uHriO2GzCeJS7vcpD2naFeXJL7sbYqqdNU0NMo3T6CCs28cFigHDwS3rI
         zNA3BdtZiwFaXF8F7zy1icBoSIyTp4oqqNHQko+MOmeHK96h71dMip+DDNKYti8Iuo4U
         /niS46OxcSUg6WLiFQ6n91/vzGYwKjt4Ylgcm6xOOKLI+gGwGSheEz+z1N+rZZ9WI+20
         DMFkodcR3b65DWEljdk9LX2hy7U/BRyGLTJNk0owAu8qCHekmMUNj3jYXqqnW0XfqKre
         2N7Q==
X-Gm-Message-State: ANhLgQ3QjARt9MYot88q2TFzOz0Xc0lJLmUSMsHgDt22wAlyPhS1xVyR
        xJLniswNDbqCYflsYSOwkqY=
X-Google-Smtp-Source: ADFU+vvRU93t0BqGBD6/k0xC9jdz7KOzP9+RDJfxvLn3TQYhemuRpQKIHIoCqhdEihJlHF6zmqFEVQ==
X-Received: by 2002:a17:90a:3328:: with SMTP id m37mr1472372pjb.158.1585110139228;
        Tue, 24 Mar 2020 21:22:19 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x3sm16886583pfp.167.2020.03.24.21.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 21:22:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sagi Grimberg <sagi@lightbitslabs.com>
References: <20200325022321.21944-1-edumazet@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <19793d41-acbc-e289-7728-6b77a2f1962c@gmail.com>
Date:   Tue, 24 Mar 2020 21:22:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325022321.21944-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/20 7:23 PM, Eric Dumazet wrote:
> TCP recvmsg() calls skb_copy_datagram_iter(), which
> calls an indirect function (cb pointing to simple_copy_to_iter())
> for every MSS (fragment) present in the skb.
> 
> CONFIG_RETPOLINE=y forces a very expensive operation
> that we can avoid thanks to indirect call wrappers.
> 
> This patch gives a 13% increase of performance on
> a single flow, if the bottleneck is the thread reading
> the TCP socket.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>


BTW, the expensive indirect call came with :

So we could also add a Fixes: tag eventually

Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")

commit 950fcaecd5cc6c014bb96506fd0652a501c85276
Author: Sagi Grimberg <sagi@lightbitslabs.com>
Date:   Mon Dec 3 17:52:08 2018 -0800

    datagram: consolidate datagram copy to iter helpers
    
    skb_copy_datagram_iter and skb_copy_and_csum_datagram are essentialy
    the same but with a couple of differences: The first is the copy
    operation used which either a simple copy or a csum_and_copy, and the
    second are the behavior on the "short copy" path where simply copy
    needs to return the number of bytes successfully copied while csum_and_copy
    needs to fault immediately as the checksum is partial.
    
    Introduce __skb_datagram_iter that additionally accepts:
    1. copy operation function pointer
    2. private data that goes with the copy operation
    3. fault_short flag to indicate the action on short copy
    
    Suggested-by: David S. Miller <davem@davemloft.net>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Sagi Grimberg <sagi@lightbitslabs.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

> ---
>  net/core/datagram.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 4213081c6ed3d4fda69501641a8c76e041f26b42..639745d4f3b94a248da9a685f45158410a85bec7 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -51,6 +51,7 @@
>  #include <linux/slab.h>
>  #include <linux/pagemap.h>
>  #include <linux/uio.h>
> +#include <linux/indirect_call_wrapper.h>
>  
>  #include <net/protocol.h>
>  #include <linux/skbuff.h>
> @@ -403,6 +404,11 @@ int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags)
>  }
>  EXPORT_SYMBOL(skb_kill_datagram);
>  
> +INDIRECT_CALLABLE_DECLARE(static size_t simple_copy_to_iter(const void *addr,
> +						size_t bytes,
> +						void *data __always_unused,
> +						struct iov_iter *i));
> +
>  static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  			       struct iov_iter *to, int len, bool fault_short,
>  			       size_t (*cb)(const void *, size_t, void *,
> @@ -416,7 +422,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  	if (copy > 0) {
>  		if (copy > len)
>  			copy = len;
> -		n = cb(skb->data + offset, copy, data, to);
> +		n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
> +				    skb->data + offset, copy, data, to);
>  		offset += n;
>  		if (n != copy)
>  			goto short_copy;
> @@ -438,8 +445,9 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  
>  			if (copy > len)
>  				copy = len;
> -			n = cb(vaddr + skb_frag_off(frag) + offset - start,
> -			       copy, data, to);
> +			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
> +					vaddr + skb_frag_off(frag) + offset - start,
> +					copy, data, to);
>  			kunmap(page);
>  			offset += n;
>  			if (n != copy)
> 
