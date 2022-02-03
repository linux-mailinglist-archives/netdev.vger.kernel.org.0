Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6658C4A8B7A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353402AbiBCSVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbiBCSVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:21:32 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC353C061714;
        Thu,  3 Feb 2022 10:21:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j23so7761042edp.5;
        Thu, 03 Feb 2022 10:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WR+RiPWCz8woMHz0rrpxrXp6fOQnDhJlz/ACklspUA4=;
        b=GsoTadMTlBcpQlSz5sziqzSKSqRnBnonO1VY+c/FN0QTkXnZUIQsKGPLvGV6Kyaqxe
         MCnJLORE7zcvwB+q19sV9NUAjsgltc7Sj38M4CdNF4/lms6OeEQm738yqUf9X2yZwX9r
         FssMPt+GACqUF/vXWDgojDCO3d4LN0BwJ39rY7I3HG0kFcOtAZ8q7CvK4HCWN6zOzhmm
         6BbV1ZXnlqekZnycnVHA9ZqXCw3YElng/QkqRMnDzvl/dwlH5JLJyHB0de6w5kIauX+K
         Ajqfp6ISWB0gJe0LL/z6t2kD/KKW8MtgDQKYP+Vvohz/MNct9kUqHxbHHL9xlZyLFSCA
         ApwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WR+RiPWCz8woMHz0rrpxrXp6fOQnDhJlz/ACklspUA4=;
        b=X+EjRpWEMKpohpBWsw86hgJlhRoWDLlfnP7y6hbnlk9XHBYWZkNLuEocG5RES8uSMw
         XLsJRsGZMDC2wSFFgItko2DbwVM+lSV7kJM7y7Z9gu0duWTp7rx6mGNkhzdbSAO+yrNk
         dyjjjaSgK0Gcn9ee7yO9X/Hu6CjHGSqg2wIkgHwBLBXB/ztpeVpNxfWQTkocP4qxMNin
         dodyCuEKRAcyAviWq8Jm5nC2UzXm8TiqBgRPi8TL/+LLnlJBYMbhuZyqLM2KZIwS3uhH
         wV1pJLjVLXCY1dv+5ozQ9sRBke/2aSGVIvX0kQnLBeC6PaKnZVUV+oEeTeJuv6Q6GctP
         Mfng==
X-Gm-Message-State: AOAM533fx5gdK8PssxfaWRASMm6+wBHwMDZkgoy7T3UD/bAE93gpcBdM
        JpwItuRNxL54D00YCozlieo=
X-Google-Smtp-Source: ABdhPJym+tFe9X+Y8nRB0U6ro0l2N3yaWajWA25OkoR8U25X3BfW2j5lNav6a5q8GkXbswG7qumztA==
X-Received: by 2002:a50:ed16:: with SMTP id j22mr37212118eds.114.1643912490237;
        Thu, 03 Feb 2022 10:21:30 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id gh14sm16957780ejb.38.2022.02.03.10.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:21:29 -0800 (PST)
Date:   Thu, 3 Feb 2022 20:21:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Message-ID: <20220203182128.z6xflse7fezccvhx@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
 <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
 <YfwX8YDDygBEsyo3@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfwX8YDDygBEsyo3@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 06:59:13PM +0100, Ansuel Smith wrote:
> On Sun, Jan 30, 2022 at 09:07:16AM -0800, Florian Fainelli wrote:
> > On 1/30/2022 5:59 AM, Ansuel Smith wrote:
> > > Hi,
> > > sorry for the delay in sending v8, it's ready but I'm far from home and
> > > I still need to check some mdio improvement with pointer handling.
> > > 
> > > Anyway I have some concern aboutall the skb alloc.
> > > I wonder if that part can be improved at the cost of some additional
> > > space used.
> > > 
> > > The idea Is to use the cache stuff also for the eth skb (or duplicate
> > > it?) And use something like build_skb and recycle the skb space
> > > everytime...
> > > This comes from the fact that packet size is ALWAYS the same and it
> > > seems stupid to allocate and free it everytime. Considering we also
> > > enforce a one way transaction (we send packet and we wait for response)
> > > this makes the allocation process even more stupid.
> > > 
> > > So I wonder if we would have some perf improvement/less load by
> > > declaring the mgmt eth space and build an skb that always use that
> > > preallocate space and just modify data.
> > > 
> > > I would really love some feedback considering qca8k is also used in very
> > > low spec ath79 device where we need to reduce the load in every way
> > > possible. Also if anyone have more ideas on how to improve this to make
> > > it less heavy cpu side, feel free to point it out even if it would
> > > mean that my implemenation is complete sh*t.
> > > 
> > > (The use of caching the address would permit us to reduce the write to
> > > this preallocated space even more or ideally to send the same skb)
> > 
> > I would say first things first: get this patch series included since it is
> > very close from being suitable for inclusion in net-next. Then you can
> > profile the I/O accesses over the management Ethernet frames and devise a
> > strategy to optimize them to make as little CPU cycles intensive as
> > possible.
> >
> 
> Don't know if it's correct to continue this disccusion here.
> 
> > build_skb() is not exactly a magic bullet that will solve all performance
> > problems, you still need the non-data portion of the skb to be allocated,
> > and also keep in mind that you need tail room at the end of the data buffer
> > in order for struct skb_shared_info to be written. This means that the
> > hardware is not allowed to write at the end of the data buffer, or you must
> > reduce the maximum RX length accordingly to prevent that. Your frames are
> > small enough here this is unlikely to be an issue.
> > 
> 
> I did some test with a build_skb() implemenation and I just discovered
> that It wouldn't work... Problem of build_skb() is that the driver will
> release the data and that's exactly what I want to skip (one allocated
> memory space that is reused for every skb)
> 
> Wonder if it would be acceptable to allocate a skb when master became
> operational and use always that.
> When this preallocated skb has to be used, the required data is changed
> and the users of the skb is increased so that it's not free. In theory
> all the skb shared data and head should be the same as what changes of
> the packet is just the data and nothing else.
> It looks like an hack but that is the only way I found to skip the
> skb_free when the packet is processed. (increasing the skb users)
>
> > Since the MDIO layer does not really allow more than one outstanding
> > transaction per MDIO device at a time, you might be just fine with just have
> > a front and back skb set of buffers and alternating between these two.
> 
> Another way as you suggested would be have 2 buffer and use build_skb to
> use build the sbk around the allocated buffer. But still my main concern
> is if the use of manually increasing the skb user is accepted to skip
> any skb free from happening.
> 
> Hope I'm not too annoying with these kind of question.

To my knowledge, when you call dev_queue_xmit(), the skb is no longer
yours, end of story, it doesn't matter whether you increase the refcount
on it or not. The DSA master may choose to do whatever it wishes with
that buffer after its TX completion interrupt fires: it may not call
napi_consume_skb() but directly recycle that buffer in its pool of RX
buffers, as part of some weird buffer recycling scheme. So you'll think
that the buffer is yours, but it isn't, because the driver hasn't
returned it to the allocator, and your writes for the next packet may be
concurrent with some RX DMA transactions. I don't have a mainline
example to give you, but I've seen the pattern, and I don't think it's
illegal (although of course, I stand to be corrected if necessary).
