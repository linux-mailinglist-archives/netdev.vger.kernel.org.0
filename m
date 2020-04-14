Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C26B1A829B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440377AbgDNPYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390840AbgDNPXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:23:15 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC76DC061A0F
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 08:23:14 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id bu9so6341440qvb.13
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 08:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mFojnywoPNyFdhtgvXnmkYzEiNUOhwI6TxTxAvK3xdg=;
        b=SS4y0WhvQF1bhRQ3pn3wLMCiWkfm25jaLNJNqFQ3AGdG5Ie+8aNc3U9tGocHDfSWTi
         nP+oDC2NmQXii1RTPcUNQIL8gVaiNDH9qzhRCfQwRsuSwl/EmmYHOIZ9KjxJur5xTeSL
         7Vjbus/zWtsfWnZ8bBIMSrZuDZ0y/TqLZ0QIUfvodRUt9yC0QUXhZMc9fdqbHI2yoa6K
         w1ySea+kHv4r8Ugu79ALt3mtAd1B/Ihd2AamFw/3d/AtK6QauU6u7ZaiyS4j+fQmNDwy
         EDJOBUhMExnxLYWwN9HQ1rqa8gZ/OgdahR8fmY45lXLkUx5Vq8b+XdpMp0OL1rfhdNWu
         ti+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mFojnywoPNyFdhtgvXnmkYzEiNUOhwI6TxTxAvK3xdg=;
        b=qkzVVkMt2q7uwoZ3oiUFfvpMxUocqs7J44g9BvA4KMa2HzPaBoAhZctxElVrIva8bd
         WWR7p1/tRBI/Rw32K4BDaZi2MPIue0N+L4kzDtkq6zE1wHtsAHuOzgQx+8BZ2FmQyfbz
         X/JeM64XGYxe1bhBHDbN6bC/z5wt+2mxTwH3vl4ellkbL4R4+jRy590Z9cL2A3ACI8dW
         HPsIjCYB4DsQHecTuggawIPj9BhkoCKGFe0VMpIWhdg3mTcX93IIvwDNQVm/vRLeeuwG
         lb7tWhvM3QhdrJGgcjPeGFWXXJ/98DuwJ4Cicn/l5q8dQjc7SdLSTBuRl4At/6iBMtxj
         wU5A==
X-Gm-Message-State: AGi0PuaAclXcZv1pNpKY443EzS8Xfct+XjOYinLFrPDczAUOaUFabluV
        RIMe8zTC9CealoYpJtKlSwONmA==
X-Google-Smtp-Source: APiQypKtItLidlBv85QFnpoyu7Va9Voe4R7MeN23XgRqelBoPM+HtCP/PCBCt2N7ezfG4+eyRUxTjA==
X-Received: by 2002:a0c:ac48:: with SMTP id m8mr509910qvb.13.1586877793898;
        Tue, 14 Apr 2020 08:23:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m11sm10391993qkg.130.2020.04.14.08.23.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 08:23:13 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jONP6-0005EN-Cy; Tue, 14 Apr 2020 12:23:12 -0300
Date:   Tue, 14 Apr 2020 12:23:12 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Message-ID: <20200414152312.GF5100@ziepe.ca>
References: <20200408202711.1198966-1-arnd@arndb.de>
 <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca>
 <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
 <20200410171320.GN11886@ziepe.ca>
 <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
 <20200414132900.GD5100@ziepe.ca>
 <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 04:27:41PM +0200, Arnd Bergmann wrote:
> On Tue, Apr 14, 2020 at 3:29 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > On Fri, Apr 10, 2020 at 07:04:27PM +0000, Saeed Mahameed wrote:
> > > On Fri, 2020-04-10 at 14:13 -0300, Jason Gunthorpe wrote:
> > > > On Fri, Apr 10, 2020 at 02:40:42AM +0000, Saeed Mahameed wrote:
> > > >
> > > > > This assumes that the module using FOO has its own flag
> > > > > representing
> > > > > FOO which is not always the case.
> > > > >
> > > > > for example in mlx5 we use VXLAN config flag directly to compile
> > > > > VXLAN related files:
> > > > >
> > > > > mlx5/core/Makefile:
> > > > >
> > > > > obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
> > > > >
> > > > > mlx5_core-y := mlx5_core.o
> > > > > mlx5_core-$(VXLAN) += mlx5_vxlan.o
> > > > >
> > > > > and in mlx5_main.o we do:
> > > >
> > > > Does this work if VXLAN = m ?
> > >
> > > Yes, if VXLAN IS_REACHABLE to MLX5, mlx5_vxlan.o will be
> > > compiled/linked.
> >
> > So mlx5_core-m does the right thing somehow?
> 
> What happens with CONFIG_VXLAN=m is that the above turns into
> 
> mlx5_core-y := mlx5_core.o
> mlx5_core-m += mlx5_vxlan.o
> 
> which in turn leads to mlx5_core.ko *not* containing mlx5_vxlan.o,
> and in turn causing that link error against
> mlx5_vxlan_create/mlx5_vxlan_destroy, unless the IS_ENABLED()
> is changed to IS_REACHABLE().

What about the reverse if mlx5_core is 'm' and VLXAN is 'y'?

 mlx5_core-m := mlx5_core.o
 mlx5_core-y += mlx5_vxlan.o

Magically works out?

> > IIRC that isn't what the expression does, if vxlan is 'n' then
> >   n || !n == true
> 
> It forces MLX5_CORE to 'm' or 'n' but not 'y' if VXLAN=m,
> but allows any option if VXLAN=y

And any option if VXLAN=n ?

Jason
