Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4E545DEB5
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240501AbhKYQsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbhKYQqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:46:08 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFA7C061757
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 08:20:56 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l25so27534545eda.11
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 08:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cNXp8PhPArnuL700uZkm+l1bBClTcmyiGId8YW9sHXY=;
        b=YcDzK9r/JELN8V7lUZsOYN9vy/+9AOnab2Y022+QU8DtS7jYg5AyQx5vKT1cjJPp9R
         hv5SCbieGRKKY8CiDxWR81Oy4GtUqjev3FPaxb3mR7YDCYH1zbwJ0bTG/e7k2R6DZqZd
         K/1EYBpDPWhIC+5KfkSUzxaSnex/TxIUSIxj32OWXSctuiozqh6hdBYEtpyZiAwOzbhR
         uZ1wvRVeA8qLQubl/E/NXDk0XPgXjb4okqoDI12g1J06cO2f/fqEKoHcb3uMyGL5BhS9
         SAbobsWs09+SrhjCdpi7PhLuzrj7rl+F5LJACIF19tMP/Bshipri/fhRaIe0jUpG4c3g
         y9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cNXp8PhPArnuL700uZkm+l1bBClTcmyiGId8YW9sHXY=;
        b=KqrX4QnHOUFOP0teaQusKvP09mOimTYfSwdhCzuFIG1fD2kpFNZhiROyMslsFgcM+g
         LzdnfspN7Ihx3GA1o6zI3QgXFHJRscHMTJOnVGJBhQbz9qu8WyXX36XkAi3juLg637X1
         h2oxzKhdX8B+ZFsVqoFET9SSmXVyN/xsB81dqruzh4tBl2+jPncCye628hVeAyoho/WX
         iI+E0mzUa338YIt2ukWhs79db0gT3jrtxCwID/Wo7SxcDmg7IBt9dnG5sFKqokCR5BVL
         zQ47U6E1rVDbiIHfnQISEsT+oYElhBHJ3eeI3TVvkol5l7g8aioPU/Af0bz/R0fiwbM1
         DjnQ==
X-Gm-Message-State: AOAM531V6g38MQd1JYhPpwJDz/D/Uq1bgcyVD3zv3kdzq0fE7DvVyojk
        ZX6cP535BODkeeKQC1Rb7XECJP6juFk=
X-Google-Smtp-Source: ABdhPJzn8UA71RbwdhPsE8aY1+LBe931qHP0SRzUZL0bxkIYklHTB/SICLaPn2iG7kVi38NM/e1K+Q==
X-Received: by 2002:a17:907:1c07:: with SMTP id nc7mr31684231ejc.546.1637857254932;
        Thu, 25 Nov 2021 08:20:54 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id m15sm2215823edl.22.2021.11.25.08.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 08:20:54 -0800 (PST)
Date:   Thu, 25 Nov 2021 18:20:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] net: dsa: felix: enable cut-through
 forwarding between ports by default
Message-ID: <20211125162053.t4ilul6oh6e5hxxh@skbuf>
References: <20211123132116.913520-1-olteanv@gmail.com>
 <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125101652.ansuiha5hlwe3ner@skbuf>
 <20211125072909.23b4e9d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125072909.23b4e9d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 07:29:09AM -0800, Jakub Kicinski wrote:
> > > Obviously shooting from the hip here, but I was expecting the cut-thru
> > > update to be before the bridge reconfig if port is joining, and after
> > > if port is leaving. Do you know what I'm getting at?  
> > 
> > Yes, I know what you're getting at. But it's a bit complicated to do,
> > given the layering constraints and that cut-through forwarding is an
> > optional feature which isn't present on all devices, so I am trying to
> > keep its footprint minimal on the ocelot library.
> > 
> > What I can do is I can disable cut-through forwarding for ports that are
> > standalone (not in a bridge). I don't have a use case for that anyway:
> > the store-and-forward latency is indistinguishable from network stack
> > latency. This will guarantee that when a port joins a bridge, it has
> > cut-through forwarding disabled. So there are no issues if it happens to
> > join a bridge and its link speed is higher than anybody else: there will
> > be no packet underruns.
> 
> Hm, to make sure I understand - fixing standalone ports doesn't
> necessary address the issue of a slow standalone port joining, right?

Yeah, I think I handled it better in v3 than my initial idea here.
