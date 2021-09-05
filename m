Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F965400F39
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 13:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhIELIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 07:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhIELIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 07:08:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D47C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 04:07:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id mf2so7314709ejb.9
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 04:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dOlSJ1sbsseA9VGP/fS0ylKzenbGhoztsnCPij6XkWQ=;
        b=UK0dq7/dt9iCcGtMpyQORaTvN2OpIGs5TC4acLXKQ1BYnVjSMPZyPV3cbq/QBYX6jV
         kbhxD4sctcmmZ35/1lhkE5lF2b7ELnlgT0eUBnIQUpEPXVk4Cu4H7KLWjqYJasWbD8ee
         gscZb3QqLiFUiOygeaN2xO/XQQxTG34jieoCulw2cii6rwiuIUcUUOmETcXjP9/dSFA5
         FkpROfAdKGQP8n+0gnCRQyK2wZgCy3F/nJGEFEVU3pUKlSr8c9bQlk2smJ/5uOrso1y7
         cBhsyk7pQK/4KnAv+UKXL8FGCh6f0ksDOU9Q0VEw8dvwOKnSIq8//tGKzKxg4TAcrE1l
         lotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dOlSJ1sbsseA9VGP/fS0ylKzenbGhoztsnCPij6XkWQ=;
        b=TT5YxaXSzVmRhLKIYuYh3HDJsTexgXAVRLStGvyPt/7Kp3gUCkWttfRTw+C9iETzZL
         gu5Lch7xpW5MH406gYtudTKw45nbh24mxfLPjP6GVLyklzkMl0wUm0tqmNuwsCsCC2dj
         1qHZHzW0nrR7yEcETNYOtbymFBeQgBNJRrJKhZeE1DIB7WfplT1N0Tpij/KK95JWU0Cr
         3FaHfEJC2n70P+Qk1Kp4MWL49fgaP89yrmTHsSoPWPso0NXhEMGLhrGz3RCXpYzW0EC5
         DsF7QdMnFCtaL5/tzvNz5FwPyd5hPXpCiUhsrhGKUhWfp9kqhg0zZCKN/aPmCiNJMK4b
         Nn9A==
X-Gm-Message-State: AOAM531A4Hj5CSfLdNz5tq4tIus2yqLmnlHluQjcZNVnv1TIdUzK92SU
        xzxFXky7K04jFhhVMwcJEiM=
X-Google-Smtp-Source: ABdhPJwL4eykcP5DEkdObxK2QDI9+teErsJKfkk0I4V/6JFg3a6XbZ4WdT3m+Ds7YUaNWx0ptdJc/Q==
X-Received: by 2002:a17:906:ff41:: with SMTP id zo1mr8225819ejb.525.1630840057848;
        Sun, 05 Sep 2021 04:07:37 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id d16sm2205744ejk.39.2021.09.05.04.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 04:07:36 -0700 (PDT)
Date:   Sun, 5 Sep 2021 14:07:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <20210905110735.asgsyjygsrxti6jk@skbuf>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTSgVw7BNK1e4YWY@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 01:47:51PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 05, 2021 at 01:31:25PM +0300, Vladimir Oltean wrote:
> > On Sun, Sep 05, 2021 at 01:25:03PM +0300, Leon Romanovsky wrote:
> > > On Sun, Sep 05, 2021 at 11:45:18AM +0300, Vladimir Oltean wrote:
> > > > On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> > > > > On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> 
> <...>
> 
> > > That sentence means that your change is OK and you did it right by not
> > > changing devlink port to hold not-working ports.
> > 
> > You're with me so far.
> > 
> > There is a second part. The ports with 'status = "disabled"' in the
> > device tree still get devlink ports registered, but with the
> > DEVLINK_PORT_FLAVOUR_UNUSED flavour and no netdev. These devlink ports
> > still have things like port regions exported.
> > 
> > What we do for ports that have failed to probe is to reinit their
> > devlink ports as DEVLINK_PORT_FLAVOUR_UNUSED, and their port regions, so
> > they effectively behave as though they were disabled in the device tree.
> 
> Yes, and this part require DSA knowledge that I don't have, because you
> suggest fallback for any error during devlink port register,

Again, fallback but not during devlink port register. The devlink port
was registered just fine, but our plans changed midway. If you want to
create a net device with an associated devlink port, first you need to
create the devlink port and then the net device, then you need to link
the two using devlink_port_type_eth_set, at least according to my
understanding.

So the failure is during the creation of the **net device**, we now have a
devlink port which was originally intended to be of the Ethernet type
and have a physical flavour, but it will not be backed by any net device,
because the creation of that just failed. So the question is simply what
to do with that devlink port.

The only thing I said about the devlink API in the commit description is
that it would have been nice to just flip the type and flavour of a
devlink port, post registration. That would avoid a lot of complications
in DSA. But that is obviously not possible, and my patch does not even
attempt to do it. What DSA does today, and will still do after the patch
we are discussing on, is to unregister that initial devlink port, and
create another one with the unused flavour, and register that one.

The reason why we even bother to re-register a devlink port a second
time for a port that failed to create and initialize its net_device is
basically for consistency with the ports that are statically disabled in
the device tree. Since devlink is a mechanism through which we gain
insight into the hardware, and disabled ports are still physically
present, just, you know, disabled and not used, their devlink ports
still exist and can be used for things like dumping port regions.
We treat ports that fail to find their PHY during probing as
'dynamically disabled', and the expectation is for them to behave just
the same as ports that were statically disabled through the device tree.

My change is entirely about how to properly structure the code such that
we unregister the port regions that a devlink port might have, before
unregistering the devlink port itself, and how to re-register those port
regions then, after the new devlink port was registered.

> which can fail for reasons that require proper unwind instead of
> reinit.
> 
> Thanks
