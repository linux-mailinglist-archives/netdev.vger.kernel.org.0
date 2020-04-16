Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F81E1AC74C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394798AbgDPOw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390562AbgDPOwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:52:37 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554D2C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:52:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x66so21508802qkd.9
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HCXSa5JOI0JuZixlWcSp9z9oFtd4hHMjntnKd7qnQdg=;
        b=D6q+HnWVLikot324F3seZu21QdKF1g0V5vDIQC90dGvb8GyvIIY9zhU6NqmwvyAEk0
         FckWdwe17Do6/HDwHmKwADXS4xTWcxpaA0Jh2Tn/hrGasbJXGfNc9DRt9UC2Wx9Bf18w
         jhcJi9wsgjNNJqTohK2bxvwrFZXcttFNaJAQrTkildLM0oDkbtoz26OkVcfRbU3WWOlj
         BqcdeBgCqxJWp7BIXvuN/RwKLCtTvkIS6uxA0GcuFdIsXlUTAzYbU7GYa6nj2eVzx8aH
         yGAukV9zW4gevdDx7bcEfam4rO8/sxjDT96zs8GY1Ew1HYpBT9WXTPh5e1xdiKqQubP1
         qvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HCXSa5JOI0JuZixlWcSp9z9oFtd4hHMjntnKd7qnQdg=;
        b=mvolmbf4j1kPtI6Rie6n7lDXKWpYxzLYPOx0DV+ZeP1OzdZiBMosQaqVU1IJvszyfk
         wDvg/TjjK7dA9uebTG1UACpv706PyO4JQzxL51Vi1nPonA5kpj4a32xXXCYPOcymXfiT
         AayZIcn8AIobMxJV8nkejGBa3JksfGgZxhlq068Zrc15fu1VTwxo5+NYBB9XnTfkr32N
         LeIRD1VPww0QsWOBr36FSlc852aH3e8+TYD9s9NV9vSz3FZPoiKRo6G/qQFAbXWFqzR+
         uAcX+VE8vl+fsjMkVAEC9xPTU4y0l780ukx0T+wyHK4wUgU+MvuvTY7YDOCk60b1tlYy
         JzCg==
X-Gm-Message-State: AGi0PuYOxJz5oa31xpmWzAa4d0rVN/BmNiWYg2qUqTjofaKRoitHpsj5
        LbmW8nMrlPtg+tb6oPTI434vWg==
X-Google-Smtp-Source: APiQypLQA2/bBUlk05pIMttoOYkQG4MHIWDLVjipXM3ESI2Uz2kPuVtpZdrkk1rBc69aWjfHtIAwKw==
X-Received: by 2002:a05:620a:1289:: with SMTP id w9mr15971965qki.263.1587048756521;
        Thu, 16 Apr 2020 07:52:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d85sm8046890qkc.99.2020.04.16.07.52.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Apr 2020 07:52:35 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jP5sZ-0003xG-6O; Thu, 16 Apr 2020 11:52:35 -0300
Date:   Thu, 16 Apr 2020 11:52:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Message-ID: <20200416145235.GR5100@ziepe.ca>
References: <20200414132900.GD5100@ziepe.ca>
 <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca>
 <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
 <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
 <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
 <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
 <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
 <874ktj4tvn.fsf@intel.com>
 <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 02:38:50PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 16, 2020 at 12:17 PM Jani Nikula
> <jani.nikula@linux.intel.com> wrote:
> >
> > On Thu, 16 Apr 2020, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> > >> BTW how about adding a new Kconfig option to hide the details of
> > >> ( BAR || !BAR) ? as Jason already explained and suggested, this will
> > >> make it easier for the users and developers to understand the actual
> > >> meaning behind this tristate weird condition.
> > >>
> > >> e.g have a new keyword:
> > >>      reach VXLAN
> > >> which will be equivalent to:
> > >>      depends on VXLAN && !VXLAN
> > >
> > > I'd love to see that, but I'm not sure what keyword is best. For your
> > > suggestion of "reach", that would probably do the job, but I'm not
> > > sure if this ends up being more or less confusing than what we have
> > > today.
> >
> > Ah, perfect bikeshedding topic!
> >
> > Perhaps "uses"? If the dependency is enabled it gets used as a
> > dependency.
> 
> That seems to be the best naming suggestion so far

Uses also  makes sense to me.

> > Of course, this is all just talk until someone(tm) posts a patch
> > actually making the change. I've looked at the kconfig tool sources
> > before; not going to make the same mistake again.
> 
> Right. OTOH whoever implements it gets to pick the color of the
> bikeshed. ;-)

I hope someone takes it up, especially now that imply, which
apparently used to do this, doesn't any more :)

Jason
