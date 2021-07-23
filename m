Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2882C3D3981
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhGWKtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhGWKto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:49:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D66EC061575;
        Fri, 23 Jul 2021 04:30:18 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hp25so3038871ejc.11;
        Fri, 23 Jul 2021 04:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sQJQk5bcPjyTMlCQd0KzChcR7IkcLHhVlzWHaX7oFLw=;
        b=hwD3tmbQD7AFuwr6hEpWXQbho/UNBthijCONnzdkL2bImKoMU1MnUkF3V8UeHGH7li
         zG+aqp4rdV44DUpsRPxEn6HQE+HYmacQOd53JRpPA8Sx0l8bvE901MzGEoVTfZeKJPNj
         jse8feHAD8hU04Fb2aZApsLppt5GnQ3+maEJ/kvlZ/CAubK4ebyKkSSYkyH9LIeAgY5S
         PilRfUtI1e9vxf55HgIM++t/YBUEfFXdC0aI0yvd++sgYcpsrD3twlYutglriqMEQYzP
         9ZrmHyJtGI18/uqmbT5LKbrymRRtp+mMcQVIOugUaITZ2tAM58eHT9Mx13uYByNX/LI5
         2TyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sQJQk5bcPjyTMlCQd0KzChcR7IkcLHhVlzWHaX7oFLw=;
        b=GJ08Zzvrdh2JtK8kpOElJTGeGStBdjqn3PTtufqw1KwAiIkX1n7AUufaNogHA1j7X0
         Dy0MVQz0U5paSNF9A5Te/NMvsGZcF56f9NJCNAjm4kKo3kNM3U4klVK/3KNr5/Td3gJA
         JRAb3Z+8vJUIujlM1VCy9fLrQbeh27zpoi5WJCx6FE50H41n/PY44Z6CEr2K6m+WqDZ2
         VVJY8TpKOe6BGlfCDikDtz2owtsYoekXyVQFJodGAylGhrnO0jq3c65DMXr0jI4wjU5b
         t+pShR0WWzLCdz/wY4r26znklDD0Y5Z6XGnJjHF8BzPbbjotr1xu+iU7vgUQPFBaLlTM
         nCsw==
X-Gm-Message-State: AOAM530pTwzTxOcJroh5G6CfXQ0VOjYyrUSbsXlNyZxwY5OfG8xS5wYf
        MzXZigrvm1ueAhvJojMbX+w=
X-Google-Smtp-Source: ABdhPJw7vP6syyGWnC77HfzEHY+HY6AvCexdOjhAxWXLdD9WZjZXpCnOMWE4FEmdX5oj6uwvgwe7ZA==
X-Received: by 2002:a17:906:8301:: with SMTP id j1mr4274146ejx.0.1627039816593;
        Fri, 23 Jul 2021 04:30:16 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-26-254-101.retail.telecomitalia.it. [79.26.254.101])
        by smtp.gmail.com with ESMTPSA id bm1sm10565161ejb.38.2021.07.23.04.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:30:16 -0700 (PDT)
Date:   Fri, 23 Jul 2021 13:30:18 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, vivien.didelot@gmail.com
Subject: Re: [RFC] dsa: register every port with of_platform
Message-ID: <YPqoSlzdZhPdyUKN@Ansuel-xps.localdomain>
References: <20210723110505.9872-1-ansuelsmth@gmail.com>
 <20210723111328.20949-1-michael@walle.cc>
 <YPqlmyvU2IjPFkXC@Ansuel-xps.localdomain>
 <168cb1440ebe1cff4a7b5e343502638a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168cb1440ebe1cff4a7b5e343502638a@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 01:25:02PM +0200, Michael Walle wrote:
> Am 2021-07-23 13:18, schrieb Ansuel Smith:
> > On Fri, Jul 23, 2021 at 01:13:28PM +0200, Michael Walle wrote:
> > > > The declaration of a different mac-addr using the nvmem framework is
> > > > currently broken. The dsa code uses the generic of_get_mac_address where
> > > > the nvmem function requires the device node to be registered in the
> > > > of_platform to be found by of_find_device_by_node. Register every port
> > > 
> > > Which tree are you on? This should be fixed with
> > > 
> > > f10843e04a07  of: net: fix of_get_mac_addr_nvmem() for non-platform
> > > devices
> > > 
> > > -michael
> > 
> > Thx a lot for the hint. So yes I missed that the problem was already
> > fixed. Sorry for the mess. Any idea if that will be backported?
> 
> I didn't include a Fixes tag, so it won't be automatically
> backported. Also I'm not sure if it qualifies for the stable trees
> because no in-tree users seem to be affected, no?
> 
> -michael

Also the patch seems very large. Anyway again thx a lot for the work and
the quick hint. Time to backport to 5.10 and 5.4 for openwrt.

