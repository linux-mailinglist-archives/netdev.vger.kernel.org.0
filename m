Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD11ACF82
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 20:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgDPSVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 14:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgDPSVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 14:21:09 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CA9C061A41
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 11:21:08 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id bu9so2490099qvb.13
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 11:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VBxNtn9uLGeSV22Vl2rB9fJP9oTr50J1UVIxL3T4SdQ=;
        b=AQM7h/guHIikQc6/ALmkgldpqSxx+vukOeOKH25qjbdAYokggloytSCSv3uQiNoab+
         kmCq0lgWRHsHhVXS/p/KuNMYHolqBV1lhCIlnfGP0GtGI/Hyrk9GYCsTpTg9E5SwNOX9
         r7oJF9IbgXygTuDOFxNChu/pX0xNIVcW5M88scZItWJNAHP2v3Q0QliUjLxhlWDActcy
         9twFPmO0K9ytT7V+3c9bR+pUOvNs0I0vnxODnP+il1jO3CGGGBnZWWeVC9kw3elxN3BO
         n+hwJeISZ+kUhd4+QGbmgmQa7fq/FNoQWDw7NlBGiTqRrxMCsVKSTdQXj0vKEpJVbcYm
         IvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VBxNtn9uLGeSV22Vl2rB9fJP9oTr50J1UVIxL3T4SdQ=;
        b=ZPR5QzGw83McqUWfY1VA8kXwGA0QEiI/8SrRJjZE5ZlwHsxfNblIwqbUq0/rbh5okq
         2nxJfjuh2oCHGUQ6waJkR/5PK9sW+MBXJ585wG9hhycxNQN7IMXAtII9TjLURrXxZ7Pj
         hsdOmAqU0tyaodSeDi+PeDre2ftAkL4StzLN7Si3pWUjQ8nIUk6RGd6OHrTne0uG6EhG
         fU/z9s4T+RQ1gvGds1NGpDK4PIZSUrG5M5eagGYNoiyPBLp3i7Xp/K1Q4IDZ+8GnDhXx
         8tm/+Gkx8XGwY7Aw3xQRoDGKlsbv/nMF2YQtysYtqtyS3uj1gMli3f6w1735TFku8Bbj
         znmA==
X-Gm-Message-State: AGi0PuaZuBdaVj/SQ0i9cdIzuTMaIYughFr0pDBFUaTgXVdxRhsuRJm0
        yn6Wolmgjgi9ZJX7C2zpFJDVyA==
X-Google-Smtp-Source: APiQypLv85/ivbA+DcFrwvD4zHlx16bJI6Zu4b9MTnY51aBljq0lYBh1Gg7Hao613nl9Rg4XGDGzhQ==
X-Received: by 2002:a05:6214:173:: with SMTP id y19mr11502093qvs.106.1587061268006;
        Thu, 16 Apr 2020 11:21:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id s15sm16363679qtc.31.2020.04.16.11.21.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Apr 2020 11:21:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jP98M-0006MB-Uj; Thu, 16 Apr 2020 15:21:06 -0300
Date:   Thu, 16 Apr 2020 15:21:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Nicolas Pitre <nico@fluxnic.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
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
Message-ID: <20200416182106.GX5100@ziepe.ca>
References: <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca>
 <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
 <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
 <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
 <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
 <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
 <874ktj4tvn.fsf@intel.com>
 <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
 <nycvar.YSQ.7.76.2004161106140.2671@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YSQ.7.76.2004161106140.2671@knanqh.ubzr>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 11:12:56AM -0400, Nicolas Pitre wrote:
> On Thu, 16 Apr 2020, Arnd Bergmann wrote:
> 
> > On Thu, Apr 16, 2020 at 12:17 PM Jani Nikula
> > <jani.nikula@linux.intel.com> wrote:
> > >
> > > On Thu, 16 Apr 2020, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> > > >> BTW how about adding a new Kconfig option to hide the details of
> > > >> ( BAR || !BAR) ? as Jason already explained and suggested, this will
> > > >> make it easier for the users and developers to understand the actual
> > > >> meaning behind this tristate weird condition.
> > > >>
> > > >> e.g have a new keyword:
> > > >>      reach VXLAN
> > > >> which will be equivalent to:
> > > >>      depends on VXLAN && !VXLAN
> > > >
> > > > I'd love to see that, but I'm not sure what keyword is best. For your
> > > > suggestion of "reach", that would probably do the job, but I'm not
> > > > sure if this ends up being more or less confusing than what we have
> > > > today.
> > >
> > > Ah, perfect bikeshedding topic!
> > >
> > > Perhaps "uses"? If the dependency is enabled it gets used as a
> > > dependency.
> > 
> > That seems to be the best naming suggestion so far
> 
> What I don't like about "uses" is that it doesn't convey the conditional 
> dependency. It could be mistaken as being synonymous to "select".
> 
> What about "depends_if" ? The rationale is that this is actually a
> dependency, but only if the related symbol is set (i.e. not n or empty).

I think that stretches the common understanding of 'depends' a bit too
far.. A depends where the target can be N is just too strange.

Somthing incorporating 'optional' seems like a better choice
'optionally uses' seems particularly clear and doesn't overload
existing works like depends or select

Jason
