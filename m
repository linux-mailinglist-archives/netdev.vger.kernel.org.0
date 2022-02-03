Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823654A8DBF
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354707AbiBCUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354531AbiBCUbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:31:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F305EC06178C;
        Thu,  3 Feb 2022 12:31:39 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id v123so2994731wme.2;
        Thu, 03 Feb 2022 12:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XCETMGPdW3wgDml3MFs9nN0HklerhJbhRnBgKtYF4PQ=;
        b=em3FJJQloIOEeprnF4u4I4qEEDM53eBf/lx9p/V1denFvq6gHoHI5O66X9kka74gc6
         WMhvHUkobWukp2UghFYiekXFHVFZczuOhj6z1a10ORgoqwg7FzEA6wjXUoojF28h1Nk+
         2WFScLbaeKKpc44MnRAaB9csJNu6Hh+/zMNgFyL4CBEKgFr7HNeCx8zRRb8A1Yxyi23B
         44Y18jthVnWZpr0MiTWlNypCe709EvJU/idreuTsANSR8RY8QSxfpuzpJ0vQxQAl0xgm
         Z3IiC7iEY+ZYiXpu7YliH4VqgncEEoxV8Z2z2ljcyUo91boB8ZxAcXY60w1zydjMGtTn
         xACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XCETMGPdW3wgDml3MFs9nN0HklerhJbhRnBgKtYF4PQ=;
        b=5uSk8+T71/tjcrNPBmEaQZB56Pk6qOeCMNyBDu7IMI9+CNtrdUOHOyl6KCiF85bh58
         P/SnzBDcREYlk+Exls2tcD0a2iqzdFYxdkTKn6CMhj0aAX07tustU1eWtT7tmKys9DKl
         i9oW6CWHurtZbILQU1BfkK7bOtTzxLkvwnU2Y0Sm3GLa/QLzRxxGORaKPEYdA/jq2nBB
         KDjHM9gj2FQtpDcfvnha1UbEGXWcEXItUHZ/qY2XMamXJMb1S8YLQTW0oORocZdvnHyT
         wR2DVB/DDHsu4z/uIHmjIQgK88UL4+TH22IIDgxzRTZoUZDhg3wgVZG3dh6qIGDjn7+x
         sVPA==
X-Gm-Message-State: AOAM533Zd5l3XOhswZJPQ0KInJMQ+/thIcwCCYdWA3kTqzsz1PQbG8Jq
        LB1SYbdNiIZXZSXsOH278F0=
X-Google-Smtp-Source: ABdhPJzdSKkKjlx679FjpFTddMZ+VF58pxrgSngrczbC4LnV6jfBRPKrWKfOGBA5NIc7m8RhnsgLng==
X-Received: by 2002:a05:600c:d4:: with SMTP id u20mr12017791wmm.52.1643920298199;
        Thu, 03 Feb 2022 12:31:38 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id u7sm8060744wml.7.2022.02.03.12.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 12:31:37 -0800 (PST)
Date:   Thu, 3 Feb 2022 21:31:34 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Message-ID: <Yfw7phxyufXvowJl@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
 <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
 <YfwX8YDDygBEsyo3@Ansuel-xps.localdomain>
 <20220203182128.z6xflse7fezccvhx@skbuf>
 <20220203121027.7a6ea0f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203121027.7a6ea0f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 12:10:27PM -0800, Jakub Kicinski wrote:
> On Thu, 3 Feb 2022 20:21:28 +0200 Vladimir Oltean wrote:
> > To my knowledge, when you call dev_queue_xmit(), the skb is no longer
> > yours, end of story, it doesn't matter whether you increase the refcount
> > on it or not. The DSA master may choose to do whatever it wishes with
> > that buffer after its TX completion interrupt fires: it may not call
> > napi_consume_skb() but directly recycle that buffer in its pool of RX
> > buffers, as part of some weird buffer recycling scheme. So you'll think
> > that the buffer is yours, but it isn't, because the driver hasn't
> > returned it to the allocator, and your writes for the next packet may be
> > concurrent with some RX DMA transactions. I don't have a mainline
> > example to give you, but I've seen the pattern, and I don't think it's
> > illegal (although of course, I stand to be corrected if necessary).
> 
> Are we talking about holding onto the Tx skb here or also recycling 
> the Rx one? Sorry for another out of context comment in advance..
>

Here we are talking about tx skb. (We can't really operate on the
received skb handled by the tagger)
What I want to improve is the fact that we alloc 3 very small skb that
will have only some part of them modified and the rest equal on all 3
skb. So my idea is find a way to preallocate a space and build a skb
around it. In short as we force a 1:1 comunication where we send an skb
and we wait for the response to be processed, we can reuse the same skb
everytime and just modify the data in it. I'm asking if anyone have some
hint/direction without proposing a patch that is a big massive hack that
will be NACK in 0.1 ms LOL

> AFAIK in theory shared skbs are supposed to be untouched or unshared
> explicitly by the driver on Tx. pktgen takes advantage of it.
> We have IFF_TX_SKB_SHARING. 
> 

Will check how this flags is used. If you have any hint about this feel
free to suggest it.

> In practice everyone gets opted into SKB_SHARING because ether_setup()
> sets the flag. A lot of drivers are not aware of the requirement and
> will assume full ownership (and for example use skb->cb[]) :/
> 

Consider that currently this will be used by stmmac driver, brcm driver
and someother atheros driver.

> I don't think there is any Tx completion -> Rx pool recycling scheme
> inside the drivers (if that's what you described).

-- 
	Ansuel
