Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E2946C81F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhLGXXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhLGXXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:23:54 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70012C061574;
        Tue,  7 Dec 2021 15:20:23 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w1so2064190edc.6;
        Tue, 07 Dec 2021 15:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fbKrWgnK015a8m1cmzzO7jngiQRPVvdZY5LOc6nyEOs=;
        b=lj4LCD1bmcBxDeaVV99An66vrpXBYd+R/qvO/so0KnAcnFYvuAehGndDTg+HJO+qdZ
         PSUeVOqlPTwd0kJv+zi32vaJx/p4qicmgL69oTPDkHzErLVH7fCnUh+JW9Hd9a29cAHm
         /H2VFVe1zHIkekTvySFb/WJiLDIH+BnKzCEg9XQTCWzlpaP/QdF0UlV342suBuvp9NPY
         34X7ThNJ7ZQlxHG8D56EBcp7cHuDMaBDYCXjb4KCFl+bzu/7sqX2abezKjMmOsr6Oa/i
         6ergqCvKu+pqrxaw501NdFDwjF3XiKEhe8g85tDerDW3zyOKNKSyLzrTu9ItxPaxUmdZ
         fnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fbKrWgnK015a8m1cmzzO7jngiQRPVvdZY5LOc6nyEOs=;
        b=hO8DxSCteLIZ10nUsmviT8FukUe9slY8olvEYAsCpU0bThVXISDjG8xvCOdpx9o6rb
         NafP/WoKC6YpZDITRc2LHbQb1c49mX5s+GtFRiWK0yfve6DnuaxqjxpPxWDKCNSEvt35
         w0K1ly4tTD5waEnN7GIq2jhDIJmkNlrEk0sJZ/sKkXT/8Woc+f3EWi5O6NDwJVnwaed8
         819xLqVtDNDMdslERcR6ojsxdUQdJOlxKMssfAudfiKxXVoGyFGCBEk1lW32XHLBqjCH
         IFF2eAIQs7rGGc7P06VaS0BJxG9LRygxjMCQrVXvQQWa+Lyo/fAbHe/2K1puKa5ESb2/
         qo9A==
X-Gm-Message-State: AOAM530MGqDr5teIYvWQJCHefnRVa1tZvOzRsYNmxsuPRziFLdzIkmPd
        de/1i6cbZplncpARXN3SW3Gqr07BW40=
X-Google-Smtp-Source: ABdhPJxASTCPHJngvQ/5fRhQRTjLNDnJ1eKes7MGyFGPo5pqDthUoK3M5LOtnPYtGbyJZSueryz/AA==
X-Received: by 2002:a05:6402:3512:: with SMTP id b18mr13693918edd.347.1638919222048;
        Tue, 07 Dec 2021 15:20:22 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id m6sm861059edc.36.2021.12.07.15.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:20:21 -0800 (PST)
Date:   Wed, 8 Dec 2021 01:20:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211207232020.ckdc6polqat4aefo@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
 <61afe8a9.1c69fb81.897ba.6022@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61afe8a9.1c69fb81.897ba.6022@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 12:05:11AM +0100, Ansuel Smith wrote:
> Hm. Interesting idea. So qca8k would provide the way to parse the packet
> and made the request. The tagger would just detect the packet and
> execute the dedicated function.
> About mib considering the driver autocast counter for every port and
> every packet have the relevant port to it (set in the qca tag), the
> idea was to put a big array and directly write the data. The ethtool
> function will then just read the data and report it. (or even work
> directly on the ethtool data array).

Apart from the fact that you'd be running inside the priv->rw_reg_ack_handler()
which runs in softirq context (so you need spinlocks to serialize with
the code that runs in process and/or workqueue context), you have access
to all the data structures from the switch driver that you're used to.
So you could copy from the void *buf into something owned by struct
qca8k_priv *priv, sure.

> >   My current idea is maybe not ideal and a bit fuzzy, because the switch
> >   driver would need to be aware of the fact that the tagger private data
> >   is in dp->priv, and some code in one folder needs to be in sync with
> >   some code in another folder. But at least it should be safer this way,
> >   because we are in more control over the exact connection that's being
> >   made.
> > 
> > - to avoid leaking memory, we also need to patch dsa_tree_put() to issue
> >   a disconnect event on unbind.
> > 
> > - the tagging protocol driver would always need to NULL-check the
> >   function pointer before dereferencing it, because it may connect to a
> >   switch driver that doesn't set them up (dsa_loop):
> > 
> > 	struct qca8k_tagger_private *priv = dp->priv;
> > 
> > 	if (priv->rw_reg_ack_handler)
> > 		priv->rw_reg_ack_handler(dp, skb_mac_header(skb));
> 
> Ok so your idea is to make the driver the one controlling ""everything""
> and keep the tagger as dummy as possible. That would also remove all the
> need to put stuff in the global include dir. Looks complex but handy. We
> still need to understand the state part. Any hint about that?
> 
> In the mean time I will try implement this.

What do you mean exactly by understanding the state?
