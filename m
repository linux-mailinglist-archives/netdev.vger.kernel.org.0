Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C8711F54C
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 02:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLOBp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 20:45:56 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:32921 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfLOBpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 20:45:55 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so1424369pjb.0
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 17:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=M65BxJYOK/rnPjNwjfEQgQZEBOlii1DHSyoxZ/oRaiQ=;
        b=e1zofpLxaG8dni4/jt0peUM1YLymh7oC2IwVoMFxRSivLb1v5xwZcKns0DkEEu/hmx
         17KhKMP4YWw0Q4qj3yPmn35afMbAHyotkViBcQktTJhU8BcHGd3D1roeyAXXaiq6gcWj
         3zHYdeD+tiwhfIj8RapsvRm23MoAgCb+pstbFCkZDEybbnLE0hQgdJ9MYQgwbMosSM8l
         Q1aia9QwfQe1z9oVgJw3lBbizolM6Z1Rd735Fjc0Kbyw4kNqQjJ9Ew02O2f/e3ZtYkUs
         KMigpFdgh7YDeDdNxEF2k0dg3PUkLGF3fgPHv0WDdTGj7W5PyNWdZs2/WiKVp+hDrkCC
         bJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=M65BxJYOK/rnPjNwjfEQgQZEBOlii1DHSyoxZ/oRaiQ=;
        b=Yo2zd6TT8E5UcdeNba/HFEoOKV84/1k3U/+D0NJR6bn+2VyTXMlcZYAzQ+WIvTWpL6
         usCCcT3rZtpXjSStJqFgMU/LFt3/GKoLvkW8qHPvbXvIR/UxPRcVam47uOEQdDikvAGW
         ZaAW0ZN9wG8j7I5M0kaM3QCIAhbPQ+fmHUw34eECU6OVs1gZiMfLA7dOxiVpCDltp2eI
         qhtZ81u6wOFmeTBIuDbC+/ZvvfcrPH7uGhF0/cwx3QJKi/bnficpb629A+S7bXgLWxCV
         Y1O+Q2vSV8X6oa3tAHny2syG1LA1Q39tjEyCJZyD9cugIYmU9yeSKfw5laBSJtONmqwp
         pbyA==
X-Gm-Message-State: APjAAAXCHcdcJDpOyDdI4PdqsINbU9auurVynPacJAShQBb2lIExcSsH
        gF8146DhkVQQPupe2fYbVuZ+6g==
X-Google-Smtp-Source: APXvYqxL+Zjj+1lqExfO43xkuTzMhaGhGaBdeH35bWGVvTF1dHUw3NSwe819d4VO4XJT7SmFGTDJ4A==
X-Received: by 2002:a17:90a:330c:: with SMTP id m12mr9329248pjb.18.1576374354947;
        Sat, 14 Dec 2019 17:45:54 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id e16sm16110674pff.181.2019.12.14.17.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 17:45:54 -0800 (PST)
Date:   Sat, 14 Dec 2019 17:45:51 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Patrick Talbert <ptalbert@redhat.com>,
        Jarod Wilson <jarod@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: Use rx_nohandler for unhandled packets
Message-ID: <20191214174551.16e8df65@cakuba.netronome.com>
In-Reply-To: <20191211162107.4326-1-ptalbert@redhat.com>
References: <20191211162107.4326-1-ptalbert@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 17:21:07 +0100, Patrick Talbert wrote:
> Since caf586e5f23c ("net: add a core netdev->rx_dropped counter") incoming
> packets which do not have a handler cause a counter named rx_dropped to be
> incremented. This can lead to confusion as some see a non-zero "drop"
> counter as cause for concern.
> 
> To avoid any confusion, instead use the existing rx_nohandler counter. Its
> name more closely aligns with the activity being tracked here.
> 
> Signed-off-by: Patrick Talbert <ptalbert@redhat.com>

Looks like commit 6e7333d315a7 ("net: add rx_nohandler stat counter")
is far more relevant here, it added rx_nohandler but kept using
rx_dropped for non-exact delivery.

Jarod, could you take a look?

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9ef20389622d..3d194cea9859 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1618,8 +1618,9 @@ enum netdev_priv_flags {
>   *			do not use this in drivers
>   *	@tx_dropped:	Dropped packets by core network,
>   *			do not use this in drivers
> - *	@rx_nohandler:	nohandler dropped packets by core network on
> - *			inactive devices, do not use this in drivers
> + *	@rx_nohandler:	Dropped packets by core network when they were not handled
> + *			by any protocol/socket or the device was inactive,
> + *			do not use this in drivers.
>   *	@carrier_up_count:	Number of times the carrier has been up
>   *	@carrier_down_count:	Number of times the carrier has been down
>   *
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2c277b8aba38..11e500f8ffa3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5123,20 +5123,19 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>  			goto drop;
>  		*ppt_prev = pt_prev;
>  	} else {
> -drop:
> -		if (!deliver_exact)
> -			atomic_long_inc(&skb->dev->rx_dropped);
> -		else
> -			atomic_long_inc(&skb->dev->rx_nohandler);
> +		/* We have not delivered the skb anywhere */
> +		atomic_long_inc(&skb->dev->rx_nohandler);
>  		kfree_skb(skb);
> -		/* Jamal, now you will not able to escape explaining
> -		 * me how you were going to use this. :-)
> -		 */
>  		ret = NET_RX_DROP;
>  	}
>  
>  out:
>  	return ret;
> +drop:
> +	atomic_long_inc(&skb->dev->rx_dropped);
> +	kfree_skb(skb);
> +	ret = NET_RX_DROP;
> +	goto out;
>  }
>  
>  static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)

