Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871E23FB1EC
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhH3HaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 03:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhH3HaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 03:30:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1870C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 00:29:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i6so21065861wrv.2
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 00:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LGiql4+pbZhq5JdwWv98g0M0WhuVahEJS14BY/GaVK4=;
        b=ccsSr8IptF7Y+Llc5ct8fSAsd82TTfvMId4paUxR/gPCGsshEZtOdHgA4z0NtGjKO/
         H42Bkw3LL8vse4J3csuyUOTqbvJhzpCAHNU6gpZakxHtDyyNar1yOIPHQ08LpqyRiDbJ
         y3K+8VY8ianVfWnR4NNjuamZzvdJDCLNpIhLyEr3bBeGisqn/bzQyvne8svdfU0ewzeD
         U83/2B5+Z7eNuI0da3vHcYyfBdMopzfRlHWYIz0Y/YVuVwbXlX2NMa4CcUYsnYFlkTVo
         PTT+8wkl3E1biAJ3ZiBWiNL+umU5JZKCjBlvBgBbYbPiDiBjc7s9jEyuNEjFZ0I2Udos
         bl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LGiql4+pbZhq5JdwWv98g0M0WhuVahEJS14BY/GaVK4=;
        b=OlKn9KUrzEe3nK+8p78iEsko0CV1rNGD806JIJrPY91cvpdT9gra4rWIY2LiLtefpM
         Epm+O4QZf3zHKKdrxALGLUmSyIPKpz0zl4fmk9l+sATVC6gi0IoOim1Hl25TTI+ADKu9
         vLNbL8TcZSOyp/pl5XUOwUEVhtg88y1oRHViFZ/SrVyIusDppPSrR8RZCePBF2Jqyned
         vQNdCOC9jL2Qj25GHXQsxAemJw56HCyr+OOs2bb+c5vvQydeCbToEQUqXug31DBWwvMw
         NEZzS1qo2GC8VDHHPamt3OhBk77eDZ+44q56coqjE3H0nEXrC4ViMPmH8sQSoN9xNzSN
         wcJQ==
X-Gm-Message-State: AOAM530fCkI7qbQYBVn8198trF/Bd8MJwbUUaTJOFYviLss0ys+uoY7B
        NS3zT6QCqSSj0IBs0RYBpCE=
X-Google-Smtp-Source: ABdhPJwS0EAnaP5WOse00QZEN8qbb5wqFz18mYUIribxZfrM2MvVRMFzM34KOafvxPha05gFFcQb+A==
X-Received: by 2002:adf:b748:: with SMTP id n8mr19065929wre.133.1630308555378;
        Mon, 30 Aug 2021 00:29:15 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id r16sm10636492wrg.71.2021.08.30.00.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 00:29:15 -0700 (PDT)
Date:   Mon, 30 Aug 2021 10:29:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: Fix egress tags
Message-ID: <20210830072913.fqq6n5rn3nkbpm3q@skbuf>
References: <20210828235619.249757-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828235619.249757-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 01:56:19AM +0200, Linus Walleij wrote:
> I noticed that only port 0 worked on the RTL8366RB since we
> started to use custom tags.
> 
> It turns out that the format of egress custom tags is actually
> different from ingress custom tags. While the lower bits just
> contain the port number in ingress tags, egress tags need to
> indicate destination port by setting the bit for the
> corresponding port.
> 
> It was working on port 0 because port 0 added 0x00 as port
> number in the lower bits, and if you do this the packet gets
> broadcasted to all ports, including the intended port.
> Ooops.

Does it get broadcast, or forwarded by MAC DA/VLAN ID as you'd expect
for a regular data packet?

> 
> Fix this and all ports work again.
> 
> Tested on the D-Link DIR-685 by sending traffic to each of
> the ports in turn. It works.
> 
> Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  net/dsa/tag_rtl4_a.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
> index 57c46b4ab2b3..042a6cb7704a 100644
> --- a/net/dsa/tag_rtl4_a.c
> +++ b/net/dsa/tag_rtl4_a.c
> @@ -54,9 +54,10 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
>  	p = (__be16 *)tag;
>  	*p = htons(RTL4_A_ETHERTYPE);
>  
> -	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);

What was 2 << 8? This patch changes that part.

> -	/* The lower bits is the port number */
> -	out |= (u8)dp->index;
> +	out = (RTL4_A_PROTOCOL_RTL8366RB << RTL4_A_PROTOCOL_SHIFT);
> +	/* The lower bits indicate the port number */
> +	out |= BIT(dp->index);
> +
>  	p = (__be16 *)(tag + 2);
>  	*p = htons(out);
>  
> -- 
> 2.31.1
> 

