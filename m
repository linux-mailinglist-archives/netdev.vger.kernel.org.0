Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65CE407929
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhIKPpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhIKPpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 11:45:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF68C061574;
        Sat, 11 Sep 2021 08:44:19 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 9so7123135edx.11;
        Sat, 11 Sep 2021 08:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xg2CvYZ+tH6t/k0xORBUUQI7HI+xjB9Z/g9ovNiV0Qw=;
        b=TenGP48rHBDJrR0xS3S+ahxytocH0V4V7qoCjcbu/24SOy3ZBsY05yLvUxOujTVhW/
         ZtcMmsMbZjUhxqGePjJm8Cs0i5bJPP7q0/5m7W2gmnzq6GsN+MxQuOBt9JR6DgIYXH6L
         ke7QJ0n1fK9oswgI7Udi+oABdrZYeJRJqCvv0KHfudRdg64m5OqJrSP+ZXcasVPbZVLN
         82i5eXIc/cwba/RbVt2iXonAISlrQmJB1UrcjZir+oG09LLsIU4oL1V3HVd4fX5IY/ZM
         Xya+s3pxNEGN+WodRrsI9AtiV0wGSwJFVjjX6lFV2fVkGs9nUtIFRqyDKKdos+76wp6h
         wQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xg2CvYZ+tH6t/k0xORBUUQI7HI+xjB9Z/g9ovNiV0Qw=;
        b=NJhBYOOGoq8Wo6nMXBAUXZYc8yVAt/shEne2NthRtLjrWPORK6SvHWsTyg0Z+jQhUy
         Z7b129Wqvn1bppgaQ4euqI3DB6vfA1Kzl72a1+dFHIk8Fvf+VWBuej6OEIT5EVWphUV8
         L5CDNTWqf6dMnQufP+YQqgM8uCJ+oxyZqc9SJ3gqbomS1hvNrhZkfy4Yn8M1gijCbY+4
         yLx4TSyIRVsK5/vKw41M3bNeXfhlQNhxDNPa/wtiDmyqh42leGgwlp/V47BoYK2mf4zP
         29yuQh1HHwsFMzJP1w3sgpb7wc5h7AnlAWmx740yP7h2D+spdN9HV+DhYU7wLd8PzF45
         tVsA==
X-Gm-Message-State: AOAM532/4DTE+gKucx3zG19cwmUkmX7ykxmQ6/M/dF2qw+y36I1ITrle
        ifpJGkyPzFYaqGM81YXlDhI=
X-Google-Smtp-Source: ABdhPJzy/bDkt/BRQSU+GcDgV3rqR4GhxWZ311zC1P1BWIGRbAhJXPFc4TiD7JXPG18T7SuEMfwFuw==
X-Received: by 2002:a05:6402:10d6:: with SMTP id p22mr3816620edu.168.1631375058276;
        Sat, 11 Sep 2021 08:44:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-87-21-249-69.retail.telecomitalia.it. [87.21.249.69])
        by smtp.gmail.com with ESMTPSA id z97sm1088745ede.72.2021.09.11.08.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:44:17 -0700 (PDT)
Date:   Sat, 11 Sep 2021 17:44:14 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: qca8k: fix kernel panic with legacy mdio
 mapping
Message-ID: <YTzOzhmnwpbtdO8D@Ansuel-xps.localdomain>
References: <20210911150731.16586-1-ansuelsmth@gmail.com>
 <5ec1a416-45e5-4679-9aa4-aa96b7f738b0@gmail.com>
 <YTzNCGutVkKZJz3t@Ansuel-xps.localdomain>
 <20210911154055.rzlresshnug6rshh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210911154055.rzlresshnug6rshh@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 11, 2021 at 06:40:55PM +0300, Vladimir Oltean wrote:
> On Sat, Sep 11, 2021 at 05:36:40PM +0200, Ansuel Smith wrote:
> > > > +static int
> > > > +qca8k_internal_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
> > > > +{
> > > > +	struct qca8k_priv *priv = salve_bus->priv;
> > > 
> > > You are only moving code here but while at it, mind fixing that typo?
> > >
> > 
> > I think I didn't understand what you mean here.
> > Sure I will fix the typo and sorry about it.
> > Aside from that anything wrong with the 2 new function or there is a
> > better fix that I can't think of.
> 
> "salve" is "hello" in Italian, and even though that is a greeting,
> surely that is not what was meant, but rather "slave". So even though
> that is less positive, it is at least a technical term with a clear
> meaning, so I think Florian's request was to replace "salve" with
> "slave" while you are moving the code anyway.

Ok this is embarrassing... Typo by vscode autocorrection... Fixing that
and sending v2. Again sorry.

