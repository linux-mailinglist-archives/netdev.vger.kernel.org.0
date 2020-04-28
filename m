Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987471BC1F3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgD1OxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727775AbgD1OxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:53:04 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8064AC03C1AB;
        Tue, 28 Apr 2020 07:53:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p8so10428563pgi.5;
        Tue, 28 Apr 2020 07:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/JpZ0+eTyvNRtNOYk4xxR3kczphsAY370jAlUixwt7E=;
        b=UAyjAIan1d3dX0IGuqchgOq9ZJxc+1lIdjWmNns+yfgfuI9rJ8BpOvKq6w9S7tvB9B
         lLaadMowzbiCMvG5JRaPPT2L/hk97E2Cg9e4glNhJTGWIm+SHU5YSb5eT6eALpNuFKv+
         8T6aN/cfUtXyX8sOwX+1abnlj8Z829PzZdUvcpNTyOG1GHxna/TV2gSedASndyIQykIX
         0ykK1jTkLm79a1tXkNpPGC/DUaHIjN33R4XY7YM+jCm5hR4Wmc8Ddv9htBSpxXJy2Mlq
         jLZ6JOvN4eRgZ5K/dnQ5gnQS+KPQOz7GBtYYq+8sjKPZBXDeL/bZJUBif8PmCgmMhpzr
         vW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/JpZ0+eTyvNRtNOYk4xxR3kczphsAY370jAlUixwt7E=;
        b=Nxis812MwUoBqc0tNuiVc/ZCBgCTZNJrWM9dmQ6Rykyc+Szub0kNGinGz9e4qDS7iF
         8evWgKeUZnXKw8RzBA5CdNLBZCzvpgRaZ/FDUr76bcH1+JEMIPHhf86DTTVuknx1FIwM
         SNAQ9qI3MeOotmhidPO3PB50hFrq09u5sSBoue96mva1r4hmXWR+wFblS44g5qYaW+RD
         f8cuozJq316svSTLqBXyCT9BXmCAY1VplEovKkdo/zbqoQp/gDLh5hTRCbfxtVA7UrSY
         8UHjeFZ3fSKuiJg5NJzAyvWochdj/aDsPziK/LgNlliixwUNwYPdz9Fb4sy9lwqtGkjf
         YnIQ==
X-Gm-Message-State: AGi0PuYFhtO1FOPHDTpPtRREC7ZT/C5ojnY7t/03xAin78de55KUaiUw
        taqBbb1mGufR3XdJ9gvbqwc=
X-Google-Smtp-Source: APiQypLZPibccVXPkfV9YKUx6XHMdVSQdB9T6nrvmqRSAJTVcXZudPqtpdseKkYT4ifhgZWyy3MFng==
X-Received: by 2002:a62:7515:: with SMTP id q21mr31848066pfc.1.1588085582953;
        Tue, 28 Apr 2020 07:53:02 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id bg6sm2223231pjb.21.2020.04.28.07.53.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2020 07:53:02 -0700 (PDT)
Date:   Tue, 28 Apr 2020 22:52:57 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, yash.shah@sifive.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
Message-ID: <20200428145257.GA3622@nuc8i5>
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
 <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
 <20200428032453.GA32072@nuc8i5>
 <acdfcb8d-9079-1340-09d5-2c10383f9c26@microchip.com>
 <20200428131159.GA2128@nuc8i5>
 <CAHp75VdAuo=UiTa+xJ8qFqbxqHVeL_M6nahhzXKbGHqvovoKMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdAuo=UiTa+xJ8qFqbxqHVeL_M6nahhzXKbGHqvovoKMA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 05:04:32PM +0300, Andy Shevchenko wrote:
> On Tue, Apr 28, 2020 at 4:12 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> > On Tue, Apr 28, 2020 at 10:42:56AM +0200, Nicolas Ferre wrote:
> > > On 28/04/2020 at 05:24, Dejin Zheng wrote:
> > > > On Mon, Apr 27, 2020 at 01:33:41PM +0300, Andy Shevchenko wrote:
> > > > > On Sat, Apr 25, 2020 at 3:57 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> > > > > >
> > > > > > A call of the function macb_init() can fail in the function
> > > > > > fu540_c000_init. The related system resources were not released
> > > > > > then. use devm_ioremap() to replace ioremap() for fix it.
> > > > > >
> > > > >
> > > > > Why not to go further and convert to use devm_platform_ioremap_resource()?
> > > > >
> > > > devm_platform_ioremap_resource() will call devm_request_mem_region(),
> > > > and here did not do it.
> > >
> > > And what about devm_platform_get_and_ioremap_resource()? This would
> > > streamline this whole fu540_c000_init() function.
> > >
> > Nicolas, the function devm_platform_get_and_ioremap_resource() will also
> > call devm_request_mem_region(), after call it, These IO addresses will
> > be monopolized by this driver. the devm_ioremap() and ioremap() are not
> > do this. if this IO addresses will be shared with the other driver, call
> > devm_platform_get_and_ioremap_resource() may be fail.
> 
> I guess request region is a right thing to do. If driver is sharing
> this IO region with something else, it is a delayed bomb attack and
> has to be fixed.
> 
>
I did encounter IO address sharing, for example, some registers are shared
by both PHY and USB controllers on Tegra SoCs. See link[1] for details.
If many people think that devm_request_mem_region() should be added
here, I will send patch v2 and convert to use
devm_platform_ioremap_resource(). Thanks very much!

link[1]: https://patchwork.ozlabs.org/project/linux-tegra/patch/20200127135841.17935-1-zhengdejin5@gmail.com/

BR,
Dejin
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
