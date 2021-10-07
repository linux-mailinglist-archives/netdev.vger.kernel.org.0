Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D5B4258FB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbhJGRL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbhJGRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:11:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95534C061570;
        Thu,  7 Oct 2021 10:10:04 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g10so24950251edj.1;
        Thu, 07 Oct 2021 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zvrsWew019O7PHzdE6mBd8qKwyXDHePBaKJlZlxzWEA=;
        b=e0iL9pgRKG6POXkIdBIKKkuedeDWrZTlO4gQ+kL0mLiD0/Ke8qmKrbKqj0pf+a8upj
         g0zH810e2uLuAcNZPQ7XzySUmaXQp/tU1NGTujRHF8Jof5jvJLngVZDx4g7JJsVxa1CC
         y5SfMOL9O/hSOZ7iAzFuxFyapWI9ItUKJrcw8nxEa87BYTpda9IqXPbOF5d4qqF+XaiS
         wxm9hDH9TEPLjLjNrjLui4LEe8TdZGbg2+PDPznkTfFaIHHfgc3dZPdZ11deW2mk/FDk
         Y8ldDOukvmcXwtUANyehHQNLGwAHTddXaUd56BeaGFfKH1Tlp1L7eI1R2m9GTcZCtagb
         EF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zvrsWew019O7PHzdE6mBd8qKwyXDHePBaKJlZlxzWEA=;
        b=FGikGyd/EmRtpoCyrg2NhbeTihaYAoJrebCxbn+lGPLFAReXYe4LbqnZiAzjH6+Oct
         fiuxEstrqBa3d1U1wsHN0P7jBu2W91XjJQ1WSc5s1zv4qRsP3Ygxkl+nArzr0KAj4gwI
         5Wg4TOZ0pEwcKbruBpn4L9V2lDg+ngV5f0rsdRUy3vLKXp0PRNokB22UljuZjtWFd64r
         FVpOFIh3uJP4iSs8jtEgxAeWEBjlNXycGOe5pTgLMHrpzT/Eu937zEnoX0605T4iRcq1
         qMQ2gu9z57hflxQXiTA8tt0DsCJVhuWjnJMmXvSRKsSrI1aqrG3f8opghNyVKHr+g/Ja
         1Efg==
X-Gm-Message-State: AOAM532BJrhfQB8CNtwsVRXp87Dt3i7J9Xwz6lY8yWZoZptPGMgz8QG+
        RJ+wA542Mi/bhx0oLWtjTW4=
X-Google-Smtp-Source: ABdhPJxUdN0NiyBnU9gC5stEJXEFofLGp/Fr+YOOdztG/kqpu3so4UvqTw93ooaE6cO+r5Ss4LMx3A==
X-Received: by 2002:a17:906:5689:: with SMTP id am9mr7245703ejc.416.1633626597241;
        Thu, 07 Oct 2021 10:09:57 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id s3sm70736eja.87.2021.10.07.10.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:09:56 -0700 (PDT)
Date:   Thu, 7 Oct 2021 19:09:55 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH 07/13] net: dsa: qca8k: add support for
 mac6_exchange, sgmii falling edge
Message-ID: <YV8p48rH+H6Ztp3c@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-8-ansuelsmth@gmail.com>
 <YV472otG4JTeppou@lunn.ch>
 <YV71nZsSDEeY97yt@Ansuel-xps.localdomain>
 <YV8lAvzocfvvsA/I@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV8lAvzocfvvsA/I@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:49:06PM +0200, Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 03:26:53PM +0200, Ansuel Smith wrote:
> > On Thu, Oct 07, 2021 at 02:14:18AM +0200, Andrew Lunn wrote:
> > > On Thu, Oct 07, 2021 at 12:35:57AM +0200, Ansuel Smith wrote:
> > > > Some device set the switch to exchange the mac0 port with mac6 port. Add
> > > > support for this in the qca8k driver. Also add support for SGMII rx/tx
> > > > clock falling edge. This is only present for pad0, pad5 and pad6 have
> > > > these bit reserved from Documentation.
> > > > 
> > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > > 
> > > Who wrote this patch? The person submitting it should be last. If
> > > Matthew actually wrote it, you want to play with git commit --author=
> > > to set the correct author.
> > > 
> > >    Andrew
> > 
> > I wrote it and Matthew did some very minor changes (binding name).
> > Should I use co-developed by ?
> 
> In that case, just reverse the order of the two Signed-off-by, and
> leave the author information as you.
> 
>       Andrew

Ok will fix in v2.

-- 
	Ansuel
