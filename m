Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6C131A8E4
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhBMAog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMAod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:44:33 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E85C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:43:53 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id q2so1877298edi.4
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dB4wH9vhr50eLf18ujr0Z/2ndnXETftZ2m6iTzz/hCA=;
        b=caSHfpVV3pkx4O0oQ9C0pIUz0RWTp3Phs0bKtpfB6Kc2EYoZPsWR3qYjQm5fbQafB/
         LnYJsN67K3GUq5ZeOKs+O/posw+9bADOjwi/W0EhtjZzhkD/2RefF/W5HxBNWUxDAqhz
         tmvamJhHYGWLjBTu5nFXDjzOAWYG3Iui1LB6icOZngkqB4VVi3laJMMu6D+B1KSIthDd
         VecWvfBdaCSvKQud/5mEZULwAd1iGAJZCeDfhodNs9CSqkxJwCd/zNaNfVfvo+U6mker
         CYchbDEaKS6vbf7knODVD1VSCpd9fAwaVc53owD7L5nwUsjJsQyDAXsMpXszugmYRk+d
         /t8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dB4wH9vhr50eLf18ujr0Z/2ndnXETftZ2m6iTzz/hCA=;
        b=fNWKixjMXOqAQ+gfLSU5cNCllChN60UppNv3vZqgvoKcZLla7Zbd31gqCiD+LiJjZJ
         N9B3+4+wb8g5rDe0YEdrYsJDFiblTqsSJwW/pfbsoxI0st6Vj45P1HAQ8In91tzPw3oB
         bysAMiyJPH6dbbMHR7ZsUKF53gBwZ9n1DyGstK3k1kLLs/WuK/HGkIyqeBHbK1lHti8s
         PUjby0vjzhrhJ7VjGspiYB1l8YnW47jDGVV72Bz0ngxcvZu5Nx/2VPGCvcQqENGm8JIk
         92jF/V0NieyFyE52XtamCPhs1CJY+6VmEI4jA2L0LHU3OLwb82TIGN2fTl6HBOM1HLQ2
         OSdA==
X-Gm-Message-State: AOAM531qAxhuRskp5br9kpcmH86+J+FkouhkWybrqE831H/u8XzIdfjd
        qNxnjOhRqHve5N9xKRL5hVw=
X-Google-Smtp-Source: ABdhPJzQgNT52QA8me0rondNEPrr84hsKlaNmOMIZDQ5gI8OxWx5u7hO2KPiSdR3GP3lzaUMtDeNXg==
X-Received: by 2002:a05:6402:104b:: with SMTP id e11mr6065615edu.367.1613177031859;
        Fri, 12 Feb 2021 16:43:51 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7039202eja.81.2021.02.12.16.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:43:51 -0800 (PST)
Date:   Sat, 13 Feb 2021 02:43:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA
 switches
Message-ID: <20210213004350.k5zj2xgwpadpr4d2@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <87sg6648nw.fsf@waldekranz.com>
 <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com>
 <87k0rh487y.fsf@waldekranz.com>
 <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com>
 <87eehn4ojt.fsf@waldekranz.com>
 <20210210215524.m4vnztszcnsr6pxa@skbuf>
 <878s7s4zej.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s7s4zej.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 12:52:36AM +0100, Tobias Waldekranz wrote:
> On Wed, Feb 10, 2021 at 23:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Wed, Feb 10, 2021 at 10:10:14PM +0100, Tobias Waldekranz wrote:
> >> This whole thing sounds an awful lot like an FDB. I suppose an option
> >> would be to implement the RedBox/QuadBox roles in the bridge, perhaps by
> >> building on the work done for MRP? Feel free to tell me I'm crazy :)
> >
> > As far as I understand, the VDAN needs to generate supervision frames on
> > behalf of all nodes that it proxies. Therefore, implementing the
> > RedBox/QuadBox in the bridge is probably not practical. What I was
> > discussing with George though is that maybe we can make hsr a consumer
> > of SWITCHDEV_FDB_ADD_TO_DEVICE events, similar to DSA with its
> > assisted_learning_on_cpu_port functionality, and that would be how it
> > populates its proxy node table.
> 
> Is it not easier to just implement learning in the HSR layer? Seeing as
> you need to look up the table for each packet anyway, you might as well
> add a new entry on a miss. Otherwise you run the risk of filling up your
> proxy table with entries that never egress the HSR device. Perhaps not
> likely on this particular device, but on a 48-port switch with HSR
> offloading it might be.

In the HSR layer, sure, I didn't mean to suggest otherwise, I thought
you wanted to, when you said "I suppose an option would be to implement
the RedBox/QuadBox roles in the bridge".

So then the SWITCHDEV_FDB_ADD_TO_DEVICE events might be too much.
Learning / populating the proxy node table can be probably done from the
xmit function, with the only potential issue that the first packets will
probably be lost, since no supervision frames have yet been transmitted
for those proxied nodes.

> This should also work for more exotic configs with multiple macvlans for
> example:
> 
> macvlan0 macvlan1
>       \  /
>       hsr0
>       /  \
>    swp1  swp2

Yes, I don't think macvlan uses switchdev.

> > A RedBox becomes a bridge with one HSR
> > interface and one or more standalone interfaces, and a QuadBox becomes a
> > bridge with two HSR interfaces. How does that sound?
> 
> Yeah that is the straight forward solution, and what I tried to describe
> earlier in the thread with this illustration:
> 
>      >> >>       br0
>      >> >>      /   \
>      >> >>    hsr0   \
>      >> >>    /  \    \
>      >> >> swp1 swp2 swp3
> 
> I just wanted to double check that we had not overlooked a better
> solution outside of the existing HSR code.

I'm not aware of a better solution, but I'm also interested if there is one.
