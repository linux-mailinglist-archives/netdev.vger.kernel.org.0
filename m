Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B5D1BB468
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD1DMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgD1DMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 23:12:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C46EC03C1A9;
        Mon, 27 Apr 2020 20:12:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 18so8784665pfv.8;
        Mon, 27 Apr 2020 20:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5DQBGmMU3Xnx4zkIfV2JJgQ1wnCTPo/vNaQ63QI1rwk=;
        b=Aw7hWpM6yrSAEef95p4A+fq2dxuXjMhWn0bVzpXIAMgQOO1kmH8QMc+O3beMf0M9VG
         GCAlZ1H6xuAejpvFWGYh8igmPVO2c6bX2vlntcOnxOm4dUmoqZ/zUFvFqN0k6yvj15pd
         KCQxhm/pwbOQsJjRnKr4O9XA9p5AH+lV9OR9wS+3DkynFKzvBE5+WBJwLF4gkGwfZ/Vj
         v92b/EcpdvUUD6tmHcDSp7RIvvWhq2sDNqgr2+LGr+rvfgaVngyCxziniCyy14vGE8rk
         aT7csKTwDpjbgWnSXsxJ/KtVFyjA8I0CSqR6eXbzkJb0KojGWHuGw0M50DACVJrsY2m0
         zVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5DQBGmMU3Xnx4zkIfV2JJgQ1wnCTPo/vNaQ63QI1rwk=;
        b=We9L20sl+NwuKxLg76tB91ZqL+s5wSiMalOrZko/AQbvI0FqBUjFl6AeOvvGxoSIIb
         DfwfYeDfIByHm9FHtRIWioVF7sDIFfx6YV9K0KogvChCdzCDtrzuAfMRwpJJfAgGWY9q
         KeHIh+fqvwI5f3nmejwwlD/zrjfkDgt4WnVlNBJwo/4i9uq1D8DShsNp0J6ibujYhUZn
         kTE6V18ZBY2tkd1dEf6x0CABphau1/h2x2ldzhfCh2dVLp8pJXPfYLrIsvhha0o4fZ2e
         8SrVURbIxcz214w5a73vPrzOWon7MX/NIDRlPPVOX5gLUb+ZPV2SWwF1LDJyNk1dWKm3
         /ABg==
X-Gm-Message-State: AGi0PuZW+/fndiUOFogupV8e27Pdl6O1sL65XxCAvnAf0OSv+rj0wmcb
        QQz3KRueiU+pAyIto+TmB+o=
X-Google-Smtp-Source: APiQypIl7xnOpudZlElRdxi10r9mqLmSdmyuizVzXF31o7t6B/x3o6d8tdncC5JAJn0/BXTbrb0BuA==
X-Received: by 2002:a63:1a1e:: with SMTP id a30mr25261543pga.368.1588043573046;
        Mon, 27 Apr 2020 20:12:53 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id u13sm601745pjb.45.2020.04.27.20.12.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Apr 2020 20:12:52 -0700 (PDT)
Date:   Tue, 28 Apr 2020 11:12:47 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, jes@trained-monkey.org,
        linux-acenic@sunsite.dk, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1] net: acenic: fix an issue about leak related
 system resources
Message-ID: <20200428031247.GB31933@nuc8i5>
References: <20200425134007.15843-1-zhengdejin5@gmail.com>
 <CAHp75VeAetsZsANoHx7X-g8+LOt0+NNarXheY5AR6L+LrdHavQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeAetsZsANoHx7X-g8+LOt0+NNarXheY5AR6L+LrdHavQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:40:02PM +0300, Andy Shevchenko wrote:
> On Sat, Apr 25, 2020 at 4:40 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> >
> > the function ace_allocate_descriptors() and ace_init() can fail in
> > the acenic_probe_one(), The related system resources were not
> > released then. so change the error handling to fix it.
> 
> ...
> 
> > @@ -568,7 +568,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
> >  #endif
> >
> >         if (ace_allocate_descriptors(dev))
> > -               goto fail_free_netdev;
> > +               goto fail_uninit;
> 
> Not sure.
> The code is quite old and requires a lot of refactoring.
> 
> Briefly looking the error path there is quite twisted.
>
> > @@ -580,7 +580,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
> >  #endif
> >
> >         if (ace_init(dev))
> > -               goto fail_free_netdev;
> > +               goto fail_uninit;
> 
> This change seems incorrect, the ace_init() calls ace_init_cleanup() on error.
> So, your change makes it call the cleanup() twice.
> 
Hi Andy:

Yes, this code is quite old, and There are also some mistakes in my
patch, abandon this commit first. Thanks!

BR,
Dejin
> -- 
> With Best Regards,
> Andy Shevchenko
