Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D48431D881
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhBQLhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhBQLd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 06:33:59 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B358BC061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:33:17 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w1so21419876ejf.11
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 03:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qvYfth6IuTs3a/9ekqeWS7i7N+/WdBzrjQnpgRe3RW4=;
        b=mQEzor03DVSbxwX7aMIwpulknGK2ZfwWo4ssC5P/I4NkGNNlV9/vs/U5u0K11SAnPH
         Gl6MqrTcUMCTqPO37+aIRp1eEjYzDd+Kuei8fXHkO4vA5pW+H+5TRry+CintDlis6WSZ
         o7yeNcOJFtf3iMdO7mHZUiakqZvDhaEenu4R0mN9cXeDGjS34JWsLWDDrakckaF7ABsn
         UaHrgBK+PtzIeGwpbXA0Mo4TS7HPbci5ufRvXBexmWzZftCenkOTtAtb7Rp6+QtvZqha
         LwaD8R5LqCeCffvfcWT7JM8uBGmvCSC3Gt38XYmbZSoHAQ+H0MLMEhj12+yqWNSo4gVp
         O9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qvYfth6IuTs3a/9ekqeWS7i7N+/WdBzrjQnpgRe3RW4=;
        b=T+uJ1MJFg0vZKSQk6Dor4Zs7rr51SXqRshl/cAeTGple/5oB1t/4Ng9IZMt8TK8WPJ
         pFVdUlYV2VmlFAB5Nj+cjkuxtZgLOyKhtlbHX5bBPYki0APZ1MhrnGqZmEdO/uj0FLje
         GKNXAwgXdRa7Q0IcWwFI6Ys4MiQnjBQJrrgmX4Zy0U+7eNDaYc0LfVM1/FbMnKC1YbmX
         OJcNR/1kf/44a/QJzLZq6wLkU2GaTQ2HGgypg4+8L3GU364tsCb8W+qCZAe/PMgaZOrq
         PYF08F7G/zUAfOxp3H4yOlSRY9AuLTmeE9S6fd2t0OxWT0P4HEX85weSpkQr9wl73sji
         +pLg==
X-Gm-Message-State: AOAM5313gPokVFMAt2If/a6rDtjyNnYPcdyhWmLd/PIzT3QBk+VMsF6g
        cW7rMynOZD6OstRinLXR5AE=
X-Google-Smtp-Source: ABdhPJxk5bNI3BrYmtX8aySaYtHVrsqaqW9BjHsWWLh7rcrh0OPiriYtr6HfJqXFEUC0IleZVJGUJQ==
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr24524679ejd.215.1613561596442;
        Wed, 17 Feb 2021 03:33:16 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l25sm847435eja.82.2021.02.17.03.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 03:33:15 -0800 (PST)
Date:   Wed, 17 Feb 2021 13:33:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
Message-ID: <20210217113314.s5kttzvatbt5zkdk@skbuf>
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216235542.2718128-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 12:55:42AM +0100, Linus Walleij wrote:
> Support also transmitting frames using the custom "8899 A"
> 4 byte tag.
> 
> Qingfang came up with the solution: we need to pad the
> ethernet frame to 60 bytes using eth_skb_pad(), then the
> switch will happily accept frames with custom tags.

I think it's pretty frustrating to realize that 'it didn't werk' because
you only tested with ping.

> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Reported-by: DENG Qingfang <dqfext@gmail.com>

Reported-by seems like a bit of an understatement. Suggested-by maybe?

> Fixes: efd7fe68f0c6 ("net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  net/dsa/tag_rtl4_a.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
> index 2646abe5a69e..c17d39b4a1a0 100644
> --- a/net/dsa/tag_rtl4_a.c
> +++ b/net/dsa/tag_rtl4_a.c
> @@ -12,9 +12,7 @@
>   *
>   * The 2 bytes tag form a 16 bit big endian word. The exact
>   * meaning has been guessed from packet dumps from ingress
> - * frames, as no working egress traffic has been available
> - * we do not know the format of the egress tags or if they
> - * are even supported.
> + * frames.
>   */
>  
>  #include <linux/etherdevice.h>
> @@ -36,17 +34,34 @@
>  static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
>  				      struct net_device *dev)
>  {
> -	/*
> -	 * Just let it pass thru, we don't know if it is possible
> -	 * to tag a frame with the 0x8899 ethertype and direct it
> -	 * to a specific port, all attempts at reverse-engineering have
> -	 * ended up with the frames getting dropped.
> -	 *
> -	 * The VLAN set-up needs to restrict the frames to the right port.
> -	 *
> -	 * If you have documentation on the tagging format for RTL8366RB
> -	 * (tag type A) then please contribute.
> -	 */
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	u8 *tag;
> +	u16 *p;
> +	u16 out;
> +
> +	/* Pad out to at least 60 bytes */
> +	if (unlikely(eth_skb_pad(skb)))
> +		return NULL;
> +	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
> +		return NULL;
> +
> +	netdev_dbg(dev, "add realtek tag to package to port %d\n",
> +		   dp->index);

You should probably remove any sort of printing from the hot path.

> +	skb_push(skb, RTL4_A_HDR_LEN);
> +
> +	memmove(skb->data, skb->data + RTL4_A_HDR_LEN, 2 * ETH_ALEN);
> +	tag = skb->data + 2 * ETH_ALEN;
> +
> +	/* Set Ethertype */
> +	p = (u16 *)tag;
> +	*p = htons(RTL4_A_ETHERTYPE);
> +
> +	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
> +	/* The lower bits is the port numer */
> +	out |= (u8)dp->index;
> +	p = (u16 *)(tag + 2);
> +	*p = htons(out);
> +
>  	return skb;
>  }
>  
> -- 
> 2.29.2
> 

