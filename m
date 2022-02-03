Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3374A8B12
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbiBCR7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiBCR7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:59:21 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750C7C061714;
        Thu,  3 Feb 2022 09:59:21 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id k18so6545331wrg.11;
        Thu, 03 Feb 2022 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q9bsnlZ8RV5uMLzPmHQ+f5K+ELYVVxVVcqL8Kemji1Y=;
        b=NzAfHlJg+nSSYJ0seuhpbDWJWmpUqANARgb/eWLp4LEOxW3H9Vz2WhGo0VV8nrzLQ6
         pgXkkuuaK95EuqbMoVWK9E8ip5Xj6Ks8U9PeOjb55r3vXjazbHngoC7eHS04vZqoHf+7
         KKZDn3jH9B8W7Cpz1Hxvx6YIKxuPUUSDysoYf/7Jhcq2LBLmeZY/PqHOHCwkeGc9SSGk
         YuhXcJYRWJxGjwYg/umOXRTTW04CGOVe/dmCjNnPP8fI8hcC5VzmIqC666nBBUsmWa3g
         EYKnmQMQTGmPc+VckCBGx4SH3ib/vXtAh1fZEBXXyrkBqWc0FNZUItx8ESDh8tyH1dX+
         Ggmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q9bsnlZ8RV5uMLzPmHQ+f5K+ELYVVxVVcqL8Kemji1Y=;
        b=Hd0DTCvnkIQyQo+RLDPaWzYmfu1l0TQ/a4nB5sDLrRPj8qgDOpZhNlXC/Ikl8diw31
         ETM8Kkt75J1QDrS6mmPWqA7j4ScnOLM1adtduYzPK6kRGGHUvicOUqxBsSvOyYAtobs3
         mLbw6T4Dh4CQCX71Ml6MmYVnRB10t978JuBnwfWIPJFnw8eKsAcmyU1yUBUuXvJlQok4
         Boldv7JGoRBvMmy/ykehvVbkOEp/Czkia+SFFed6ovp9yiTedhLmhb7J6efANe79iKmY
         HRoh04pQCgO7XUsAp6N7XBq+b2Enr4n1aP53KjAhSiaRNQtXvKG9qf9ZuNG6nSuWgM8n
         kYQw==
X-Gm-Message-State: AOAM533C32u3KfUeTcnMH6+4SkioU296Nj2t3Dflhtj5RoSNhMxpdgjT
        YOWpPWrjNbLHyQGV0I3gbfQ=
X-Google-Smtp-Source: ABdhPJyioOz8rn4MMozjtmbvasDIUDVRYNgqfrefhVBB3SVuEoEjXjOP8MthBUXP5V4sxPgCCnbH+g==
X-Received: by 2002:adf:f4d1:: with SMTP id h17mr20770054wrp.448.1643911159785;
        Thu, 03 Feb 2022 09:59:19 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id m5sm8373157wms.4.2022.02.03.09.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:59:19 -0800 (PST)
Date:   Thu, 3 Feb 2022 18:59:13 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Message-ID: <YfwX8YDDygBEsyo3@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
 <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 09:07:16AM -0800, Florian Fainelli wrote:
> 
> 
> On 1/30/2022 5:59 AM, Ansuel Smith wrote:
> > > 
> > 
> > Hi,
> > sorry for the delay in sending v8, it's ready but I'm far from home and
> > I still need to check some mdio improvement with pointer handling.
> > 
> > Anyway I have some concern aboutall the skb alloc.
> > I wonder if that part can be improved at the cost of some additional
> > space used.
> > 
> > The idea Is to use the cache stuff also for the eth skb (or duplicate
> > it?) And use something like build_skb and recycle the skb space
> > everytime...
> > This comes from the fact that packet size is ALWAYS the same and it
> > seems stupid to allocate and free it everytime. Considering we also
> > enforce a one way transaction (we send packet and we wait for response)
> > this makes the allocation process even more stupid.
> > 
> > So I wonder if we would have some perf improvement/less load by
> > declaring the mgmt eth space and build an skb that always use that
> > preallocate space and just modify data.
> > 
> > I would really love some feedback considering qca8k is also used in very
> > low spec ath79 device where we need to reduce the load in every way
> > possible. Also if anyone have more ideas on how to improve this to make
> > it less heavy cpu side, feel free to point it out even if it would
> > mean that my implemenation is complete sh*t.
> > 
> > (The use of caching the address would permit us to reduce the write to
> > this preallocated space even more or ideally to send the same skb)
> 
> I would say first things first: get this patch series included since it is
> very close from being suitable for inclusion in net-next. Then you can
> profile the I/O accesses over the management Ethernet frames and devise a
> strategy to optimize them to make as little CPU cycles intensive as
> possible.
>

Don't know if it's correct to continue this disccusion here.

> build_skb() is not exactly a magic bullet that will solve all performance
> problems, you still need the non-data portion of the skb to be allocated,
> and also keep in mind that you need tail room at the end of the data buffer
> in order for struct skb_shared_info to be written. This means that the
> hardware is not allowed to write at the end of the data buffer, or you must
> reduce the maximum RX length accordingly to prevent that. Your frames are
> small enough here this is unlikely to be an issue.
> 

I did some test with a build_skb() implemenation and I just discovered
that It wouldn't work... Problem of build_skb() is that the driver will
release the data and that's exactly what I want to skip (one allocated
memory space that is reused for every skb)

Wonder if it would be acceptable to allocate a skb when master became
operational and use always that.
When this preallocated skb has to be used, the required data is changed
and the users of the skb is increased so that it's not free. In theory
all the skb shared data and head should be the same as what changes of
the packet is just the data and nothing else.
It looks like an hack but that is the only way I found to skip the
skb_free when the packet is processed. (increasing the skb users)

> Since the MDIO layer does not really allow more than one outstanding
> transaction per MDIO device at a time, you might be just fine with just have
> a front and back skb set of buffers and alternating between these two.

Another way as you suggested would be have 2 buffer and use build_skb to
use build the sbk around the allocated buffer. But still my main concern
is if the use of manually increasing the skb user is accepted to skip
any skb free from happening.

Hope I'm not too annoying with these kind of question.

> -- 
> Florian

-- 
	Ansuel
